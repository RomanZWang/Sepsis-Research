-----------------------------------------------------------------------------
-- Identifying adultpatients_losg24 who had blood culture done
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- Mimic version- MIMIC III v1.3
-- Description: Blood culture is done on patients to check for infections,
-- and when they occur in combination with antibiotics they signify infections.
-- In mimic 3 blood culture info can be gathered from microbiologyevents,
-- chartevents, procedureevents_mv and labevents.
-- This query creates a table called blood which contains subject_id,
-- hadm_id, charttime of blood culture tests.
------------------------------------------------------------------------------

-- create a table of adult microbiologyevents
DROP TABLE IF EXISTS microbiology_adult_admissions;
CREATE TABLE microbiology_adult_admissions (LIKE microbiologyevents);
INSERT INTO microbiology_adult_admissions
SELECT microbiologyevents.*
FROM microbiologyevents, adultpatients_losg24
WHERE microbiologyevents.hadm_id=adultpatients_losg24.hadm_id;

-- lets update the NULL values in charttime column with values in column chartdate

UPDATE microbiology_adult_admissions
SET charttime=chartdate
WHERE charttime ISNULL;

-- lets start by creating a blood culture tables for records of interest in each table
-- that contains the information subject_id, hadm_id, itemid, and charttime
-- lets create one table for each table and then merge them

DROP TABLE IF EXISTS blood_culture_mv;
CREATE TABLE blood_culture_mv(
Subject_id int,
Hadm_id int,
Itemid int,
Charttime timestamp(0));

-- lets only input the blood culture items from microbiology_adult_admissions
-- into blood_culture_mv, spec_item=70012 is the blood cult item in microbiologyevents table
INSERT INTO blood_culture_mv
SELECT subject_id, hadm_id,spec_itemid,charttime
FROM microbiology_adult_admissions
WHERE spec_itemid=70012;

-- The blood_culture has duplicates because blood culture is performed for diff bacteria at the same time in
-- microbiology so we add only the distinct records from blood_culture_mv to the final blood_culture_events table

DROP TABLE IF EXISTS blood_culture_events;
CREATE TABLE blood_culture_events(LIKE blood_culture_mv);
INSERT INTO blood_culture_events
SELECT DISTINCT *
FROM blood_culture_mv;

-- next, lets create the adult records for chartevents table

DROP TABLE IF EXISTS chartevents_adult_admissions;
CREATE TABLE chartevents_adult_admissions (LIKE chartevents);
INSERT INTO chartevents_adult_admissions
SELECT chartevents.*
FROM chartevents, adultpatients_losg24
WHERE chartevents.hadm_id=adultpatients_losg24.hadm_id;

-----------------------------------------------------
-----------------------------------------------------
-- lets index the chartevents_adult_admissions table, this will be useful later when calculating
-- sofa score, itll speed up the process

DROP INDEX IF EXISTS chartevents_adult_admissions_idx01;
CREATE INDEX chartevents_adult_admissions_idx01
  ON chartevents_adult_admissions (subject_id);

DROP INDEX IF EXISTS chartevents_adult_admissions_idx02;
CREATE INDEX chartevents_adult_admissions_idx02
  ON chartevents_adult_admissions (itemid);

DROP INDEX IF EXISTS chartevents_adult_admissions_idx04;
CREATE INDEX chartevents_adult_admissions_idx04
  ON chartevents_adult_admissions (hadm_id);

-------------------------------------------------------
-------------------------------------------------------

-- Next create a blood_culture_chart table like blood_culture_mv
-- and insert the blood culture records from
-- chartevents_adult_admissions,
-- before entering into blood_culture_events
drop table IF EXISTS blood_culture_chart;
CREATE TABLE blood_culture_chart (LIKE blood_culture_mv);
INSERT INTO blood_culture_chart
SELECT subject_id, hadm_id,itemid,charttime
FROM chartevents_adult_admissions
WHERE itemid in (3333,938,942);
-- only 6 blood culture records

INSERT INTO blood_culture_events
SELECT DISTINCT *
FROM blood_culture_chart;

-- next do the same on procedureevnets_mv table
drop table IF EXISTS procedureevents_mv_adult_admissions;
CREATE TABLE procedureevents_mv_adult_admissions (LIKE procedureevents_mv);
INSERT INTO procedureevents_mv_adult_admissions
SELECT procedureevents_mv.*
FROM procedureevents_mv,adultpatients_losg24
WHERE procedureevents_mv.hadm_id=adultpatients_losg24.hadm_id;

-- Next create a blood_culture_proceduremv table like blood_culture_mv
-- and insert the blood culture records
-- from procedureevents_mv_adult_admissions,
-- before entering into blood_culture_events
drop table IF EXISTS blood_cul_proceduremv;
CREATE TABLE blood_cul_proceduremv (LIKE blood_culture_mv);
INSERT INTO blood_cul_proceduremv
SELECT subject_id,hadm_id,itemid,starttime
FROM procedureevents_mv_adult_admissions
WHERE itemid=225401;

INSERT INTO blood_culture_events
SELECT DISTINCT *
FROM blood_cul_proceduremv;

-- next do the same on labevents
drop table IF EXISTS labevents_adult_admissions;
CREATE TABLE labevents_adult_admissions (LIKE labevents);
INSERT INTO labevents_adult_admissions
SELECT labevents.*
FROM labevents, adultpatients_losg24
WHERE labevents.hadm_id=adultpatients_losg24.hadm_id;

-- Next create a blood_culture_labevents table like blood_culture_mv
-- and insert the blood culture records from
-- labevents_adult_admissions,
-- before entering into blood_culture_events

drop table IF EXISTS blood_culture_labevents;
CREATE TABLE  blood_culture_labevents (LIKE blood_culture_mv);
INSERT INTO blood_culture_labevents
SELECT subject_id,hadm_id,itemid,charttime
FROM labevents_adult_admissions
WHERE itemid=50886;

INSERT INTO blood_culture_events
SELECT DISTINCT *
FROM blood_culture_labevents;


drop table IF EXISTS blood;
CREATE TABLE blood (LIKE blood_culture_events);
ALTER TABLE blood DROP COLUMN itemid;
INSERT INTO blood
SELECT DISTINCT *
FROM (

	SELECT subject_id,hadm_id,charttime FROM blood_culture_events
	UNION
	SELECT subject_id,hadm_id,charttime FROM blood_culture_mv

	) as x
ORDER BY hadm_id,charttime;

ALTER TABLE blood ADD admittime TIMESTAMP(0);

UPDATE blood as b
SET admittime = (

SELECT a.admittime
from adultpatients_losg24 as a
where a.hadm_id = b.hadm_id
LIMIT 1 -- some hadm has multiple icu stays
);

--make sure that we don't have charttime < admission time
delete from blood
where charttime<admittime;
