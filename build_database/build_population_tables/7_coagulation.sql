------------------------------------------------------
-- Platelet Count (Coagulation) measurements for adult patients
-- Author: Prabhat Rayapati
-- MIMIC version- MIMIC III v1.3
-- Description: Platelet count measurement in a criteria in sofa points
-- this query produces a table calleed labevents_platelets which is a subset
-- of labevents containing records of only platelet count measurement
---------------------------------------------------------

--###############################
--###############################
--########### COAGULATION #######
--###############################
--###############################
-- lets create a subset of chartevents in adult patients for platelet measurements
drop table if exists labevents_platelets;
CREATE TABLE labevents_platelets (LIKE labevents_adult_admissions);
INSERT INTO labevents_platelets
SELECT *
FROM labevents_adult_admissions
WHERE itemid=51265;

UPDATE labevents_platelets
SET valuenum=NULL
WHERE valuenum>10000;

drop table if exists chartevents_platelets;
CREATE TABLE chartevents_platelets (LIKE chartevents_adult_admissions);
INSERT INTO chartevents_platelets
SELECT *
FROM chartevents_adult_admissions
WHERE itemid in(6256,828,227457);

UPDATE chartevents_platelets
SET valuenum=NULL
WHERE valuenum>10000;
