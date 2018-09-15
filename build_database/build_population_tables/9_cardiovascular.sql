------------------------------------------------------
-- Cardiovascular measurements for adult patients
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version- MIMIC III v1.3
-- Description: Cardiovascular measurement in a criteria in sofa points
-- this query produces tables containing MAP,dobutamine, dopamine,
-- epinephrine, norepinephrine.
---------------------------------------------------------

--###########################################
--###########################################
--######### CARDIOVASCULAR ##################
--###########################################
--###########################################

--*******************************************
--****** MAP ********************************
--*******************************************
--lets make a subset of chartevents table for adults patients' mean arterial pressure

DROP TABLE IF EXISTS chartevents_adult_map;
CREATE TABLE chartevents_adult_map (LIKE chartevents);
INSERT INTO chartevents_adult_map
SELECT *
FROM chartevents_adult_admissions
WHERE itemid IN (52,220052);
-- the map item ids are 52 and 220052 and there are 3,223,150 map measurements

--**********************************************
--*********DOPAMINE*****************************
--**********************************************
-- we create a subset of inputevents_cv table that contain the rate of dopamine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_dopamine;
CREATE TABLE inputevents_dopamine (LIKE inputevents_cv);
INSERT INTO inputevents_dopamine
SELECT inputevents_cv.*
FROM inputevents_cv,adultpatients_losg24
WHERE (inputevents_cv.itemid IN (30043,30307)) AND (inputevents_cv.hadm_id=adultpatients_losg24.hadm_id);

-- we create a subset of inputevents_cv table that contain the rate of dopamine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_mv_dopamine;
CREATE TABLE inputevents_mv_dopamine (LIKE inputevents_mv);
INSERT INTO inputevents_mv_dopamine
SELECT inputevents_mv.*
FROM inputevents_mv,adultpatients_losg24
WHERE inputevents_mv.itemid=221662 AND inputevents_mv.statusdescription != 'Rewritten'
AND inputevents_mv.hadm_id=adultpatients_losg24.hadm_id;

--**********************************************
--*********EPINEPHRINE**************************
--**********************************************
-- lets make a subset of chartevents table for adult patients' epinephrine measurements
DROP TABLE IF EXISTS chartevents_adult_epinephrine;
CREATE TABLE chartevents_adult_epinephrine (LIKE chartevents);
INSERT INTO chartevents_adult_epinephrine
SELECT *
FROM chartevents_adult_admissions
WHERE itemid=3112;
-- there are 30 measurements for epiniphrine in mimic 3 and the itemid is 3112

-- we create a subset of inputevents_cv table that contain the rate of epinephrine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_epinephrine;
CREATE TABLE inputevents_epinephrine (LIKE inputevents_cv);
INSERT INTO inputevents_epinephrine
SELECT inputevents_cv.*
FROM inputevents_cv,adultpatients_losg24
WHERE (inputevents_cv.itemid IN (30044,30119,30309)) AND (inputevents_cv.hadm_id=adultpatients_losg24.hadm_id);

-- we create a subset of inputevents_mv table that contain the rate of epinephrine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_mv_epinephrine;
CREATE TABLE inputevents_mv_epinephrine (LIKE inputevents_mv);
INSERT INTO inputevents_mv_epinephrine
SELECT inputevents_mv.*
FROM inputevents_mv, adultpatients_losg24
WHERE inputevents_mv.itemid=221289 AND inputevents_mv.statusdescription != 'Rewritten' AND inputevents_mv.hadm_id=adultpatients_losg24.hadm_id;

--**********************************************
--*********NOREPINEPHRINE***********************
--**********************************************
-- we create a subset of inputevents_cv table that contain the rate of norepinephrine/levophed
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_norepinephrine;
CREATE TABLE inputevents_norepinephrine (LIKE inputevents_cv);
INSERT INTO inputevents_norepinephrine
SELECT inputevents_cv.*
FROM inputevents_cv, adultpatients_losg24
WHERE (inputevents_cv.itemid IN (30047,30120)) AND (inputevents_cv.hadm_id=adultpatients_losg24.hadm_id);

-- we create a subset of inputevents_mv table that contain the rate of norepinephrine/levophed
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_mv_norepinephrine;
CREATE TABLE inputevents_mv_norepinephrine (LIKE inputevents_mv);
INSERT INTO inputevents_mv_norepinephrine
SELECT inputevents_mv.*
FROM inputevents_mv, adultpatients_losg24
WHERE inputevents_mv.itemid =221906 AND inputevents_mv.statusdescription != 'Rewritten'
AND inputevents_mv.hadm_id=adultpatients_losg24.hadm_id;

--**********************************************
--*********DOBUTAMINE***************************
--**********************************************
--lets make a subset of prescriptions table for adult patients who took dobutamine
DROP TABLE IF EXISTS prescription_adult_dobutamine;
CREATE TABLE prescription_adult_dobutamine (LIKE prescriptions_adult);
INSERT INTO prescription_adult_dobutamine
SELECT *
FROM prescriptions_adult
WHERE lower(drug) LIKE '%dobutamine%';
-- There are 1435 prescriptions of dobutamine
-- -- we create a subset of inputevents_cv table that contain the rate of dobutamine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_dobutamine;
CREATE TABLE inputevents_dobutamine (LIKE inputevents_cv);
INSERT INTO inputevents_dobutamine
SELECT inputevents_cv.*
FROM inputevents_cv, adultpatients_losg24
WHERE (inputevents_cv.itemid IN (30042,30306))
AND (inputevents_cv.hadm_id=adultpatients_losg24.hadm_id);

-- -- we create a subset of inputevents_mv table that contain the rate of dobutamine
-- administered to patients which can be used to determine sofa points
DROP TABLE IF EXISTS inputevents_mv_dobutamine;
CREATE TABLE inputevents_mv_dobutamine (LIKE inputevents_mv);
INSERT INTO inputevents_mv_dobutamine
SELECT inputevents_mv.*
FROM inputevents_mv, adultpatients_losg24
WHERE inputevents_mv.itemid=221653 AND inputevents_mv.statusdescription != 'Rewritten'
AND inputevents_mv.hadm_id=adultpatients_losg24.hadm_id;
