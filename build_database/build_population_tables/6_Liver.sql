------------------------------------------------------
-- Bilirubin (LIVER) measurements for adult patients
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version- MIMIC III v1.3
-- Description: Bilirubin measurement in a criteria in sofa points
-- this query produces a table calleed labevents_liver which is a subset
-- of labevents containing records of only bilirubin measurement
---------------------------------------------------------

--###############################
--###############################
--########## LIVER ##############
--###############################
--###############################
--lets create a subset of labevents for bilirubin (liver) measurements
drop table if exists labevents_liver;
CREATE TABLE labevents_liver (LIKE labevents_adult_admissions);
INSERT INTO labevents_liver
SELECT *
FROM labevents_adult_admissions
WHERE itemid=50885;

UPDATE labevents_liver
SET valuenum=NULL
WHERE valuenum>150;

drop table if exists chartevents_liver;
CREATE TABLE chartevents_liver (LIKE chartevents_adult_admissions);
INSERT INTO chartevents_liver
SELECT *
from chartevents_adult_admissions
where itemid in(4948, 225690);

UPDATE chartevents_liver
SET valuenum=NULL
WHERE valuenum>150;
