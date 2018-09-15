---------------------------------------------------------------
-- Identify adult patients with spesis according to sepsis 3 definition
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version: MIMIC III v1.3
-- Description: This query creates a table called sepsis of Adult patients who meet the
-- sepsis 3 definition.The table outputs subject_id, hadm_id, the delta in sofa score, sepsis_time along with
-- some other info.
---------------------------------------------------------------

-- create a table like sofa called sofa delta which will contain a new column called prev_val
-- prev_val will be equal to the previous sofa value occuring before the given row
DROP TABLE IF EXISTS sofa_delta;
CREATE TABLE sofa_delta(LIKE sofa);
ALTER TABLE sofa_delta
ADD prev_val int;
ALTER TABLE sofa_delta
ADD prev_chart timestamp(0);

INSERT INTO sofa_delta
SELECT *
from (SELECT *, LAG(sofa_score) OVER (PARTITION BY hadm_id ORDER BY charttime) as prev_val,
	LAG(charttime) OVER (PARTITION BY hadm_id ORDER BY charttime) as prev_chart
FROM sofa) AS x
ORDER BY hadm_id,charttime;

--adding the time in hours between the prev occuring sofa and the current sofa
ALTER TABLE sofa_delta
ADD time_diff int;
UPDATE sofa_delta
SET time_diff=DATE_PART('day',charttime-prev_chart)*24 + DATE_PART('hour',charttime-prev_chart);

-- calculating the diff between sofa scores provided the prev sofa value was with in 24hours of the current sofa value
ALTER TABLE sofa_delta
ADD delta int;

UPDATE sofa_delta
SET delta=(CASE
	WHEN time_diff <=24 THEN sofa_score-prev_val
	ELSE NULL
	END);

-- since one of sepsis criteria is a sofa inc of >=2 lets
-- delete all records with diff < 2.
DELETE FROM sofa_delta
WHERE delta<2 OR delta ISNULL;

-- create a new table sepsis like sofa_delta with an additional column time_infection, which is the time of
-- suspected infection from the antib_blood table
DROP TABLE IF EXISTS sepsis;
CREATE TABLE sepsis (LIKE sofa_delta);
ALTER TABLE sepsis
ADD time_infection timestamp(0);

-- we insert the time_infection from the antib_blood into the sepsis table
INSERT INTO sepsis
SELECT sofa_delta.*,antib_blood.time_infection
FROM sofa_delta
INNER JOIN antib_blood
ON antib_blood.hadm_id=sofa_delta.hadm_id
ORDER BY sofa_delta.hadm_id;

-- add another column to sepsis table to calculate the time of sepsis onset
ALTER TABLE sepsis
ADD sepsis_time timestamp(0);

-- time of sepsis onset is defined in the paper as
-- (a)the time of inc in sofa score of 2 or more points
-- given the inc occurs anywhere bewteen the (time of suspected infection-48 hours, time of suspected infection)
-- OR OR OR OR
-- (b)The time of suspected infection given the inc in sofa occurs anywhere between
-- (time of suspected infection, time of suspected infection+24 hours)
UPDATE sepsis
SET sepsis_time=(CASE
	WHEN charttime>=(time_infection-interval '48 hours') AND charttime<=time_infection THEN charttime
	WHEN charttime>=time_infection AND charttime<=(time_infection+interval '24 hours') THEN time_infection
	ELSE NULL
	END
);
-- delete the entires without any sepsis time
DELETE FROM sepsis
WHERE sepsis_time ISNULL;

--ADD INTIME

ALTER TABLE sepsis
ADD icu_intime timestamp(0);

UPDATE sepsis as t1
SET icu_intime=(
	select t2.intime
	from adultpatients_losg24 as t2
	WHERE t1.hadm_id = t2.hadm_id
	order by intime asc
	limit 1
	);

ALTER TABLE sepsis
ADD admittime timestamp(0);

UPDATE sepsis as t1
SET admittime=(
	select t2.admittime
	from admissions as t2
	WHERE t1.hadm_id = t2.hadm_id

	);

-- now this table should give us the time a patient was definied as sepsis.
