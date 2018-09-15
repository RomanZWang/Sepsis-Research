---------------------------------------------------------------
-- Identify patients over 18years of age AND patients over 18+length of stay>=24hrs
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version: MIMIC III v1.3
-- Description: This query create a table of Adult patients and their corresponding hospital admission ID, adult
-- is definied as age greater than or equal to 18 years. The table produced by this script called "adultpatients" contains the subject_id
-- and the corresponding hadm_id of adult patients.
-- this query also creates a table adultpatients_log24 which contains subject_id,
-- hadm_id of adult patients whose length of stay in the hospital is greater than
-- 24 hours.
-- This query does not specify a schema, and can be directly run on your data
---------------------------------------------------------------

-- create a copy of icustays called icustays_1
DROP TABLE IF EXISTS icustays_1;
CREATE TABLE icustays_1 (LIKE icustays);
INSERT INTO icustays_1
SELECT *
FROM icustays;

-- add the dob column to icustays_1, copy the dob data from the patients table
ALTER TABLE icustays_1
ADD dob date;

UPDATE icustays_1
SET dob=patients.dob
FROM patients
WHERE icustays_1.subject_id=patients.subject_id;

--Now lets calculate the age of the patients at the time of icu admission

ALTER TABLE icustays_1
ADD age int;

UPDATE icustays_1
SET age=date_part('year',age(cast(intime as date),dob));

-- the age of people over 89 years is scwered
-- so replace the age of anyone over 89years with 91, since the median age
-- of shifted age is 91.4

UPDATE icustays_1
SET age=91
WHERE age>89;


--Add admit time
ALTER TABLE icustays_1
ADD admittime timestamp(0);

UPDATE icustays_1 as i
SET admittime = (

select a.admittime from admissions as a
where i.hadm_id=a.hadm_id

);


 -- Now lets create a table of adult patients only, and their corresponding hospital admissions
 DROP TABLE IF EXISTS icustays_2;
 CREATE TABLE icustays_2 (LIKE icustays_1);

 INSERT INTO icustays_2
 SELECT *
 FROM icustays_1;
 DELETE FROM icustays_2
 WHERE age<18;

-- creating a table with the adult distinct hospital admissions
DROP TABLE IF EXISTS adultpatients;
 CREATE TABLE adultpatients(
 	subject_id int,
 	hadm_id int,
 	admittime TIMESTAMP(0),
 	intime TIMESTAMP(0),
 	outtime TIMESTAMP(0));
 INSERT INTO adultpatients
 SELECT distinct subject_id, hadm_id,admittime, intime, outtime
 FROM icustays_2
WHERE dbsource LIKE '%metavision%';

--------------------------------------------------------------------------
----- EXTRA: Identify patients with a hospital stay of more than 24 hours
--------------------------------------------------------------------------

-- create a duplicate of admissions table lets call it admissions_1
DROP TABLE IF EXISTS admissions_1;
CREATE TABLE admissions_1 (LIKE admissions);
INSERT INTO admissions_1
SELECT *
FROM admissions;

ALTER TABLE admissions_1
ADD hosp_stay double precision;
UPDATE admissions_1
SET hosp_stay=date_part('day', dischtime-admittime)*24 + date_part('hour', dischtime-admittime);

-- lets add the length of hospital stay to the adultpatients table
ALTER TABLE adultpatients
ADD hosp_stay double precision;

UPDATE adultpatients
SET hosp_stay=admissions_1.hosp_stay
FROM admissions_1
WHERE adultpatients.hadm_id=admissions_1.hadm_id;

--Lets create a table of adults whose length of hospital stay was greater than 24hrs
DROP TABLE IF EXISTS adultpatients_losg24;
CREATE TABLE adultpatients_losg24(
 	subject_id int,
 	hadm_id int,
 	admittime TIMESTAMP(0),
 	intime TIMESTAMP(0),
 	outtime TIMESTAMP(0));

INSERT INTO adultpatients_losg24
SELECT subject_id,hadm_id, admittime, intime, outtime
FROM adultpatients
WHERE adultpatients.hosp_stay>=24;

DROP INDEX IF EXISTS adultpatients_losg24_idx01;
CREATE INDEX adultpatients_losg24_idx01
  ON adultpatients_losg24 (subject_id);

DROP INDEX IF EXISTS adultpatients_losg24_idx02;
CREATE INDEX adultpatients_losg24_idx02
  ON adultpatients_losg24 (hadm_id);
