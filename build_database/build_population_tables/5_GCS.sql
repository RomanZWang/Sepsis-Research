--------------------------------------------------------
--	GSC scores of adult patients
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- Mimic version: MIMIC III v1.3
-- Description: GCS score is one of the criteria for calculating
-- SOFA points. This query produces a table called chartevents_adult_gcs
-- which contains all the information for gcs from chartevents
--------------------------------------------------------

-- convert the label field of d_labitems to lower case
UPDATE d_labitems SET label=lower(label);

--###############################
--###############################
--###### GLASSGOW COMA SCORE ####
--###############################
--###############################
-- lets create a subset of chartevents for gcs score

drop table if exists chartevents_adult_gcs;
CREATE TABLE chartevents_adult_gcs (LIKE chartevents);
INSERT INTO chartevents_adult_gcs
SELECT *
FROM chartevents_adult_admissions
WHERE itemid=198;
-- there are 943,217 gcs measurements in adult patients

drop table if exists chartevents_adult_gcs_eye;
CREATE TABLE chartevents_adult_gcs_eye (LIKE chartevents);
INSERT INTO chartevents_adult_gcs_eye
SELECT *
FROM chartevents_adult_admissions
WHERE itemid in(220739);

ALTER TABLE chartevents_adult_gcs_eye rename column value to eye_value;
ALTER TABLE chartevents_adult_gcs_eye rename column valuenum to eye_valuenum;

drop table if exists chartevents_adult_gcs_verbal;
CREATE TABLE chartevents_adult_gcs_verbal (LIKE chartevents);
INSERT INTO chartevents_adult_gcs_verbal
SELECT *
FROM chartevents_adult_admissions
WHERE itemid in(223900);

ALTER TABLE chartevents_adult_gcs_verbal rename column value to verbal_value;
ALTER TABLE chartevents_adult_gcs_verbal rename column valuenum to verbal_valuenum;

drop table if exists chartevents_adult_gcs_motor;
CREATE TABLE chartevents_adult_gcs_motor (LIKE chartevents);
INSERT INTO chartevents_adult_gcs_motor
SELECT *
FROM chartevents_adult_admissions
WHERE itemid in(223901);

ALTER TABLE chartevents_adult_gcs_motor rename column value to motor_value;
ALTER TABLE chartevents_adult_gcs_motor rename column valuenum to motor_valuenum;

drop table if exists chartevents_adult_gcs_joined;
CREATE TABLE chartevents_adult_gcs_joined (
subject_id int,
hadm_id int,
icustay_id int,
charttime timestamp(0),
eye_value VARCHAR(255),
eye_valuenum int,
verbal_value VARCHAR(255),
verbal_valuenum int,
motor_value VARCHAR(255),
motor_valuenum int
);

INSERT INTO chartevents_adult_gcs_joined
SELECT e.subject_id, e.hadm_id, e.icustay_id, e.charttime, e.eye_value, e.eye_valuenum, v.verbal_value, v.verbal_valuenum, m.motor_value, m.motor_valuenum
from chartevents_adult_gcs_eye e
inner join chartevents_adult_gcs_verbal v
on e.subject_id=v.subject_id
AND e.hadm_id = v.hadm_id
AND e.icustay_id = v.icustay_id
AND e.charttime = v.charttime
inner join chartevents_adult_gcs_motor m
on m.subject_id=v.subject_id
AND m.hadm_id = v.hadm_id
AND m.icustay_id = v.icustay_id
AND m.charttime = v.charttime;

alter table chartevents_adult_gcs_joined add total int;

UPDATE chartevents_adult_gcs_joined
SET total=eye_valuenum+verbal_valuenum+motor_valuenum
WHERE eye_valuenum IS NOT NULL
AND verbal_valuenum IS NOT NULL
AND motor_valuenum IS NOT NULL;

DELETE FROM chartevents_adult_gcs_joined
WHERE total IS NULL;
