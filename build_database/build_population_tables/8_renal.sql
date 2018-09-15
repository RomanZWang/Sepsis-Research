------------------------------------------------------
-- RENAL measurements for adult patients
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version- MIMIC III v1.3
-- Description: Renal measurement in a criteria in sofa points
-- this query produces two tables calleed labevents_creatinine
-- which is a subset of labevents containing records of only creatinine
-- measurement. and the second table outputevents_urine a subset of
-- outputevents for urine records
---------------------------------------------------------

--###############################
--###############################
--######## RENAL ################
--###############################
--###############################
-- lets create a subset of labevents for creatinine(renal) measurements

DROP TABLE IF EXISTS labevents_creatinine;
CREATE TABLE labevents_creatinine (LIKE labevents_adult_admissions);
INSERT INTO labevents_creatinine
SELECT *
FROM labevents_adult_admissions
WHERE itemid=50912;

UPDATE labevents_creatinine
SET valuenum=NULL
WHERE valuenum>150;

DROP TABLE IF EXISTS chartevents_creatinine;
CREATE TABLE chartevents_creatinine (LIKE chartevents_adult_admissions);
INSERT INTO chartevents_creatinine
SELECT *
FROM chartevents_adult_admissions
WHERE itemid in(1525,220615);

UPDATE chartevents_creatinine
SET valuenum=NULL
WHERE valuenum>150;

-- the urine output records in the mimic database

DROP TABLE IF EXISTS outputevents_urine;
CREATE TABLE outputevents_urine (LIKE outputevents);
INSERT INTO outputevents_urine
SELECT outputevents.*
FROM outputevents, adultpatients_losg24
WHERE (outputevents.itemid IN ( 40055, 43175, 40069, 40094, 40715, 40473,
	40085, 40057, 40056, 40405, 40428, 40086, 40096, 40651,
	226559, 226560, 227510, 226561, 226584, 226563, 226564,
	226565, 226567, 226557, 226558)) AND (outputevents.hadm_id=adultpatients_losg24.hadm_id);
