---------------------------------------------------------------
-- Sepsis Population
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version: MIMIC III v1.3
-- Description: This query creates a table called sepsis_pop of Adult patients who meet the
-- sepsis 3 definition.The table outputs subject_id, sepsis_time along with
-- some other info. This is table is a subset of the table sepsis created before. It conatins only the first
-- event of sepsis for each patients. so total rows will be equal to the total distinct number of patients.
---------------------------------------------------------------


-- lets index the table sepsis first
DROP INDEX IF EXISTS sepsis_idx01;
CREATE INDEX sepsis_idx01
    ON sepsis (subject_id);

DROP INDEX IF EXISTS sepsis_idx02;
CREATE INDEX sepsis_idx02
    ON sepsis (sepsis_time);


-- the table sepsis created earlier contains the records for every patient everytime his delta sofa>=2
-- therefore each patients could have multiple records when his delta sofa was >=2
-- BUT we made the choice to define a sepsis event as the first event of sepsis for a given patient
-- (here the earliest of all spsis_time)
-- lets create the table sepsis_pop, this table will contain all the distinct subject_id from the sepsis table.

DROP TABLE IF EXISTS sepsis_pop;
CREATE TABLE sepsis_pop(
subject_id INT,
hadm_id INT,
icu_intime TIMESTAMP(0),
sepsis_time TIMESTAMP(0)
);

-- Lets insert into the table all the distinct patients
INSERT INTO sepsis_pop
SELECT DISTINCT(subject_id)
FROM sepsis;

-- lets add the rest of the columns
-- we are selecting all the sepsis_time for a given patient in sepsis table
-- and ordering them in ascending order and returning the 1st sepsis_time of the
-- sorted list
UPDATE sepsis_pop AS t1
SET (sepsis_time,hadm_id,icu_intime)=(SELECT sepsis_time,hadm_id,icu_intime FROM sepsis AS t2
WHERE t1.subject_id=t2.subject_id
ORDER BY t2.sepsis_time
LIMIT 1);

alter table sepsis_pop add column admittime TIMESTAMP(0);
UPDATE sepsis_pop as t1
SET admittime=(
	select t2.admittime
	from admissions as t2
	WHERE t1.hadm_id = t2.hadm_id

	);
-- sepsis pop has all the patients with sepsis and their time of first sepsis. This is our control group!


DROP TABLE IF EXISTS nonsepsis_pop;
CREATE TABLE nonsepsis_pop(
subject_id INT,
hadm_id INT,
admittime TIMESTAMP(0),
icu_intime TIMESTAMP(0)
);
INSERT INTO nonsepsis_pop
SELECT subject_id, hadm_id, admittime, intime
FROM adultpatients_losg24;

DELETE FROM nonsepsis_pop USING sepsis_pop
WHERE nonsepsis_pop.subject_id = sepsis_pop.subject_id;
