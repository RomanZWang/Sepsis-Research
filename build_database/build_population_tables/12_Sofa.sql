------------------------------------------------------
-- Continuous SOFA severity score for adult patients
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version- MIMIC III v1.3
-- Description: SOFA severity score along with a supected infection
-- is used in determining if a patient has sepsis.
-- This query create a table called sofa which contains the continous SOFA scores for adult patients.
-- continous here means, a sofa score is calculated everytime a new measurement comes into the system
-- for any of the physiological event
---------------------------------------------------------

-- create a table: sofa_calc to store the 6 required lab/vitals for sofa calculation
-- per patient
-- the 6 are- respiration, coagulation, liver-bilirubin, cardiovascular-hypotension,
-- glasgow coma score and renal-urine or creatinine
drop table if exists sofa_calc;
CREATE TABLE sofa_calc(
hadm_id int,
charttime timestamp(0),
lab_id int,
respiration double precision,
resp_support_start int,
resp_support_end int,
coagulation double precision,
liver_bilirubin double precision,
GCS double precision,
renal_creatinine double precision,
renal_urine double precision,
cardio_hypoten_map double precision,
cardio_hypoten_dopamine double precision,
cardio_hypoten_dobutamine double precision,
cardio_hypoten_epinephrine double precision,
cardio_hypoten_norepinephrine double precision);
---
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and gcs from the 3_gcs.sql script
-- with the lab_id in sofa_calc set to 1, and all the other values set to zero
---
INSERT INTO sofa_calc
SELECT chartevents_adult_gcs.hadm_id,chartevents_adult_gcs.charttime,1,0,0,0,0,0,
chartevents_adult_gcs.valuenum,0,0,0,0,0,0,0
FROM chartevents_adult_gcs;

INSERT INTO sofa_calc
SELECT chartevents_adult_gcs_joined.hadm_id,chartevents_adult_gcs_joined.charttime,1,0,0,0,0,0,
chartevents_adult_gcs_joined.total,0,0,0,0,0,0,0
FROM chartevents_adult_gcs_joined;

DELETE FROM sofa_calc WHERE gcs ISNULL;
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and liver_bilirubin from the 4_liver.sql script
-- with the lab_id in sofa_calc set to 2, and all the other values set to zero
---

DELETE FROM labevents_liver WHERE valuenum ISNULL;

INSERT INTO sofa_calc
SELECT labevents_liver.hadm_id,labevents_liver.charttime,2,0,0,0,0,labevents_liver.valuenum,0,
0,0,0,0,0,0,0
FROM labevents_liver;

DELETE FROM chartevents_liver WHERE valuenum ISNULL;

INSERT INTO sofa_calc
SELECT chartevents_liver.hadm_id,chartevents_liver.charttime,2,0,0,0,0,chartevents_liver.valuenum,0,
0,0,0,0,0,0,0
FROM chartevents_liver;


---

---
-- insert into the table sofa_calc the values of hadm_id,charttime and platelets from the 5_coagulation.sql script
-- with the lab_id in sofa_calc set to 3, and all the other values set to zero
---
DELETE FROM labevents_platelets WHERE valuenum ISNULL;
INSERT INTO sofa_calc
SELECT labevents_platelets.hadm_id,labevents_platelets.charttime,3,0,0,0,labevents_platelets.valuenum,0,0,
0,0,0,0,0,0,0
FROM labevents_platelets;

DELETE FROM chartevents_platelets WHERE valuenum ISNULL;
INSERT INTO sofa_calc
SELECT chartevents_platelets.hadm_id,chartevents_platelets.charttime,3,0,0,0,chartevents_platelets.valuenum,0,0,
0,0,0,0,0,0,0
FROM chartevents_platelets;
---

---
-- insert into the table sofa_calc the values of hadm_id,charttime and creatinine from the 6_renal.sql script
-- with the lab_id in sofa_calc set to 4, and all the other values set to zero
--
DELETE FROM labevents_creatinine WHERE valuenum ISNULL;
INSERT INTO sofa_calc
SELECT labevents_creatinine.hadm_id,labevents_creatinine.charttime,4,0,0,0,0,0,
0,labevents_creatinine.valuenum,0,0,0,0,0,0
FROM labevents_creatinine;

DELETE FROM chartevents_creatinine WHERE valuenum ISNULL;
INSERT INTO sofa_calc
SELECT chartevents_creatinine.hadm_id,chartevents_creatinine.charttime,4,0,0,0,0,0,
0,chartevents_creatinine.valuenum,0,0,0,0,0,0
FROM chartevents_creatinine;
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and urine from the 6_renal.sql script
-- with the lab_id in sofa_calc set to 5, and all the other values set to zero
--
DELETE FROM outputevents_urine WHERE value ISNULL;
INSERT INTO sofa_calc
SELECT outputevents_urine.hadm_id,outputevents_urine.charttime,5,0,0,0,0,0,
0,0,outputevents_urine.value,0,0,0,0,0
FROM outputevents_urine;
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and MAP from the 7_cardiovascular.sql script
-- with the lab_id in sofa_calc set to 6, and all the other values set to zero
--
DELETE FROM chartevents_adult_map WHERE valuenum ISNULL;
INSERT INTO sofa_calc
SELECT chartevents_adult_map.hadm_id,chartevents_adult_map.charttime,6,0,0,0,0,0,
0,0,0,chartevents_adult_map.valuenum,0,0,0,0
FROM chartevents_adult_map;
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and dopamine from the 7_cardiovascular.sql script
-- with the lab_id in sofa_calc set to 7, and all the other values set to zero
--
DELETE FROM inputevents_dopamine WHERE rate ISNULL;
INSERT INTO sofa_calc
SELECT inputevents_dopamine.hadm_id,inputevents_dopamine.charttime,7,0,0,0,0,0,
0,0,0,0,inputevents_dopamine.rate,0,0,0
FROM inputevents_dopamine;

INSERT INTO sofa_calc
SELECT inputevents_mv_dopamine.hadm_id,inputevents_mv_dopamine.starttime,7,0,0,0,0,0,
0,0,0,0,inputevents_mv_dopamine.rate,0,0,0
FROM inputevents_mv_dopamine;
---
---
-- insert into the table sofa_calc the values of hadm_id,charttime and epinephrine from the 7_cardiovascular.sql script
-- with the lab_id in sofa_calc set to 8, and all the other values set to zero
--
DELETE FROM inputevents_epinephrine WHERE rate ISNULL;
INSERT INTO sofa_calc
SELECT inputevents_epinephrine.hadm_id,inputevents_epinephrine.charttime,8,0,0,0,0,0,
0,0,0,0,0,0,inputevents_epinephrine.rate,0
FROM inputevents_epinephrine
WHERE inputevents_epinephrine.itemid=30119;

INSERT INTO sofa_calc
SELECT inputevents_mv_epinephrine.hadm_id,inputevents_mv_epinephrine.starttime,8,0,0,0,0,0,
0,0,0,0,0,0,inputevents_mv_epinephrine.rate,0
FROM inputevents_mv_epinephrine;
---
-- insert into the table sofa_calc the values of hadm_id,charttime and norepinephrine from the 7_cardiovascular.sql script
-- with the lab_id in sofa_calc set to 9, and all the other values set to zero
--
DELETE FROM inputevents_norepinephrine WHERE rate ISNULL;
INSERT INTO sofa_calc
SELECT inputevents_norepinephrine.hadm_id,inputevents_norepinephrine.charttime,9,0,0,0,0,0,
0,0,0,0,0,0,0,inputevents_norepinephrine.rate
FROM inputevents_norepinephrine WHERE inputevents_norepinephrine.itemid=30120;

INSERT INTO sofa_calc
SELECT inputevents_mv_norepinephrine.hadm_id,inputevents_mv_norepinephrine.starttime,9,0,0,0,0,0,
0,0,0,0,0,0,0,inputevents_mv_norepinephrine.rate
FROM inputevents_mv_norepinephrine;
---
-- insert into the table sofa_calc the values of hadm_id,charttime and 1 in the column dobutamine from the 7_cardiovascular.sql script
-- with the lab_id in sofa_calc set to 10, and all the other values set to zero, since the criteria is any dosage of dobutamine
--
INSERT INTO sofa_calc
SELECT inputevents_dobutamine.hadm_id,inputevents_dobutamine.charttime,10,0,0,0,0,0,
0,0,0,0,0,1,0,0
FROM inputevents_dobutamine;

INSERT INTO sofa_calc
SELECT inputevents_mv_dobutamine.hadm_id,inputevents_mv_dobutamine.starttime,10,0,0,0,0,0,
0,0,0,0,0,1,0,0
FROM inputevents_mv_dobutamine;

INSERT INTO sofa_calc
SELECT prescription_adult_dobutamine.hadm_id,prescription_adult_dobutamine.startdate,10,0,0,0,0,0,
0,0,0,0,0,1,0,0
FROM prescription_adult_dobutamine;
---
-- insert into the table sofa_calc the values of hadm_id,charttime and pf ratio from the 9_respiration.sql script
-- with the lab_id in sofa_calc set to 11, and all the other values set to zero
--
INSERT INTO sofa_calc
SELECT pf_ratio.hadm_id,pf_ratio.charttime,11,pf_ratio.ratio,0,0,0,0,0,0,0,0,0,0,0,0
FROM pf_ratio;
--
-- insert into the table sofa_calc the values of hadm_id,starttime and 1 for identifier in resp_support_start
-- from the 9_respiration.sql script
-- with the lab_id in sofa_calc set to 12, and all the other values set to zero
--
INSERT INTO sofa_calc
SELECT ventidurations.hadm_id,ventidurations.starttime,12,0,1,0,0,0,0,0,0,0,0,0,0
FROM ventidurations;

-- insert into the table sofa_calc the values of hadm_id,endtime and 1 for identifier in resp_support_end
-- from the 9_respiration.sql script
-- with the lab_id in sofa_calc set to 12, and all the other values set to zero
--
INSERT INTO sofa_calc
SELECT ventidurations.hadm_id,ventidurations.endtime,12,0,0,1,0,0,0,0,0,0,0,0,0
FROM ventidurations;
--
--lets create a table called sofa_table with the distinct entries of sofa_calc ordered by hadm_id and charttime
--
DROP TABLE IF EXISTS sofa_table;
CREATE TABLE sofa_table (LIKE sofa_calc);
INSERT INTO sofa_table
SELECT DISTINCT *
FROM sofa_calc
ORDER BY hadm_id,charttime;

--DELETE FROM sofa_table WHERE cardio_hypoten_map>=70;

-- lets idex this table on hadm_id and charttime
DROP INDEX IF EXISTS sofa_table_idx01;
CREATE INDEX sofa_table_idx01
  ON sofa_table (hadm_id);

DROP INDEX IF EXISTS sofa_table_idx02;
CREATE INDEX sofa_table_idx02
  ON sofa_table (charttime);


-- when a new sofa physiological measuremnt is made at time 't',
-- the sofa at that particular time 't' is calculated by taking the
-- worst values of all physiological measurements occuring in the time window [t-24hours,t]

-- each row in the "sofa_table" we created represents a particular physiological measurement, given by lab_id
-- so we replace each row with the worst value of that physiological measurement occuring in the last 24hours

-- for a given row 'n' with lab_id=11, i.e. a row 'n' containing a pf ratio value we replace the value with the worst
-- pf ratio occuring in the window [n.charttime-24hours, n.charttime]
UPDATE sofa_table AS v11
SET respiration=(SELECT min(respiration) FROM sofa_table AS v12
WHERE v12.lab_id=11 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=11;

-- for a given row 'n' with lab_id=3, i.e. a row 'n' containing a coagulation value we replace the value with the worst
-- coagulation occuring in the window [n.charttime-24hours, n.charttime]
UPDATE sofa_table AS v11
SET coagulation=(SELECT min(coagulation) FROM sofa_table AS v12
WHERE v12.lab_id=3 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=3;

--replace with worst liver value in last 24 hours
UPDATE sofa_table AS v11
SET liver_bilirubin=(SELECT max(liver_bilirubin) FROM sofa_table AS v12
WHERE v12.lab_id=2 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=2;

--replace with worst gcs value in last 24 hours
UPDATE sofa_table AS v11
SET gcs=(SELECT min(gcs) FROM sofa_table AS v12
WHERE v12.lab_id=1 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=1;


--replace with worst creatinine value in last 24 hours
UPDATE sofa_table AS v11
SET renal_creatinine=(SELECT max(renal_creatinine) FROM sofa_table AS v12
WHERE v12.lab_id=4 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=4;

--replace with worst urine value in last 24 hours
UPDATE sofa_table AS v11
SET renal_urine=(SELECT min(renal_urine) FROM sofa_table AS v12
WHERE v12.lab_id=5 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=5;

--replace with worst dopamine value in last 24 hours
UPDATE sofa_table AS v11
SET cardio_hypoten_dopamine=(SELECT max(cardio_hypoten_dopamine) FROM sofa_table AS v12
WHERE v12.lab_id=7 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=7;

--replace with worst epinephrine value in last 24 hours
UPDATE sofa_table AS v11
SET cardio_hypoten_epinephrine=(SELECT max(cardio_hypoten_epinephrine) FROM sofa_table AS v12
WHERE v12.lab_id=8 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=8;

--replace with worst norepinephrine value in last 24 hours
UPDATE sofa_table AS v11
SET cardio_hypoten_norepinephrine=(SELECT max(cardio_hypoten_norepinephrine) FROM sofa_table AS v12
WHERE v12.lab_id=9 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id)
WHERE lab_id=9;

-- for a row 'n', corresponding to the ventilation start and stop, lab_id=12, we fill the pf ratio value of the row
-- with the closest previous value of pf ratio if any in the time window 24hours prior to the charttime of row 'n'.
UPDATE sofa_table AS v11
SET respiration=(SELECT respiration FROM sofa_table AS v12
WHERE v12.lab_id=11 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id
ORDER BY v12.charttime DESC LIMIT 1)
WHERE lab_id=12 AND resp_support_start=1;


UPDATE sofa_table AS v11
SET respiration=(SELECT respiration FROM sofa_table AS v12
WHERE v12.lab_id=11 AND v12.charttime>=(v11.charttime- interval '24 hours')
AND v12.charttime<=v11.charttime
AND v12.hadm_id=v11.hadm_id
ORDER BY v12.charttime DESC LIMIT 1)
WHERE lab_id=12 AND resp_support_end=1;

-- we need an identifier for any pf ratio measurment occuring between start and stop time of ventilation/support system
-- so lets add a column support_status
ALTER TABLE sofa_table
ADD support_status int;

--  we only need the support status for rows with pf ratio for calculating the sofa points
-- so we only update the support_status for rows with lab_id=11.
-- so for a given row (lab_id=11) with a hadm_id, and charttime, we check if the charttime falls between the
-- starttime and endtime for ventilation status of that hadm_id in the ventidurations table, if yes then we set
-- support_status to 1
UPDATE sofa_table AS vv1
SET support_status=(SELECT status FROM ventidurations AS vv2
where vv1.hadm_id=vv2.hadm_id AND
vv1.charttime>=vv2.starttime AND
vv1.charttime<=vv2.endtime)
WHERE lab_id=11;
-- we replace all the null values in support status to 0
UPDATE sofa_table
SET support_status=0
WHERE support_status ISNULL;

DELETE FROM sofa_table WHERE respiration ISNULL;

--all this updating to sofa_table... the order by charttime and hadm_id is gone
-- lets create a table called sofa, which is a copy of sofa_table only its ordered by hadm_id and charttime

DROP TABLE IF EXISTS sofa;

CREATE TABLE sofa (LIKE sofa_table);
INSERT INTO sofa
SELECT *
FROM sofa_table
ORDER BY hadm_id,charttime;

-- update support status to include the starttime and endtime of the ventilation too
UPDATE sofa
SET support_status=support_status+resp_support_start+resp_support_end;


DROP TABLE IF EXISTS sofa1;
-- create a copy to reorder them again, its just that i like to look at my tables ordered, makes thinking easier
CREATE TABLE sofa1 (LIKE sofa);
INSERT INTO sofa1
SELECT *
FROM sofa
ORDER BY hadm_id,charttime;

------
------
-- now we update the values of the sofa1 table with the sofa score for each measurement based on the criteria
-- in the paper: THE SOFA-J.L. Vincent et.al.
------

-- respiration
UPDATE sofa1
SET respiration=(CASE
WHEN respiration<100 AND support_status=1 THEN 4
WHEN respiration<200 AND support_status=1 THEN 3
WHEN respiration<300 THEN 2
WHEN respiration<400 THEN 1
ELSE 0
END)
WHERE lab_id=11;

UPDATE sofa1
SET respiration=(CASE
WHEN respiration<100 AND support_status=1 THEN 4
WHEN respiration<200 AND support_status=1 THEN 3
WHEN respiration<300 THEN 2
WHEN respiration<400 THEN 1
ELSE 0
END)
WHERE lab_id=12;

--
--coagulation

UPDATE sofa1
SET coagulation=(CASE
WHEN coagulation<20 THEN 4
WHEN coagulation<50 THEN 3
WHEN coagulation<100 THEN 2
WHEN coagulation<150 THEN 1
ELSE 0
END)
WHERE lab_id=3;

---
-- liver bilirubin
UPDATE sofa1
SET liver_bilirubin=(CASE
WHEN liver_bilirubin>=12 THEN 4
WHEN liver_bilirubin<12 AND liver_bilirubin>=6 THEN 3
WHEN liver_bilirubin<6 AND liver_bilirubin>=2 THEN 2
WHEN liver_bilirubin<2 AND liver_bilirubin>=1.2 THEN 1
ELSE 0
END)
WHERE lab_id=2;
---
--GCS
UPDATE sofa1
SET gcs=(CASE
WHEN gcs<6 THEN 4
WHEN gcs<=9 AND gcs>=6 THEN 3
WHEN gcs<=12 AND gcs>=10 THEN 2
WHEN gcs<=14 AND gcs>=13 THEN 1
ELSE 0
END)
WHERE lab_id=1;
---
--creatinine
UPDATE sofa1
SET renal_creatinine=(CASE
WHEN renal_creatinine>=5 THEN 4
WHEN renal_creatinine<5 AND renal_creatinine>=3.5 THEN 3
WHEN renal_creatinine<3.5 AND renal_creatinine>=2 THEN 2
WHEN renal_creatinine<2 AND renal_creatinine>=1.2 THEN 1
ELSE 0
END)
WHERE lab_id=4;
---
--urine
UPDATE sofa1
SET renal_urine=(CASE
WHEN renal_urine<200 THEN 4
WHEN renal_urine<500 THEN 3
ELSE 0
END)
WHERE lab_id=5;
---
--MAP
UPDATE sofa1
SET cardio_hypoten_map=(CASE
WHEN cardio_hypoten_map<70 THEN 1
ELSE 0
END)
WHERE lab_id=6;
---
--dopamine
UPDATE sofa1
SET cardio_hypoten_dopamine=(CASE
WHEN cardio_hypoten_dopamine>=15 THEN 4
WHEN cardio_hypoten_dopamine>5  THEN 3
WHEN cardio_hypoten_dopamine<=5 THEN 2
ELSE 0
END)
WHERE lab_id=7;
---
--dobutamine
UPDATE sofa1
SET cardio_hypoten_dobutamine=(CASE
WHEN cardio_hypoten_dobutamine<>0 THEN 2
ELSE 0
END)
WHERE lab_id=10;
---
--epinephrine
UPDATE sofa1
SET cardio_hypoten_epinephrine=(CASE
WHEN cardio_hypoten_epinephrine>0.1 THEN 4
WHEN cardio_hypoten_epinephrine<=0.1  THEN 3
ELSE 0
END)
WHERE lab_id=8;
---
-- norepinephrine

UPDATE sofa1
SET cardio_hypoten_norepinephrine=(CASE
WHEN cardio_hypoten_norepinephrine>0.1 THEN 4
WHEN cardio_hypoten_norepinephrine<=0.1  THEN 3
ELSE 0
END)
WHERE lab_id=9;
---
---
-- now lets aggregate these points and calculate the sofa score
---

-- add a column to store the aggregate
ALTER TABLE sofa1
ADD sofa_score int;

-- index to make the process faster
DROP INDEX IF EXISTS sofa1_idx01;
CREATE INDEX sofa1_idx01
  ON sofa1 (hadm_id);

DROP INDEX IF EXISTS sofa1_idx02;
CREATE INDEX sofa1_idx02
  ON sofa1 (charttime);

-- for a given row sum all the points associated with the worst case measurements in the last 24hours of the charttime
-- of the particular row, this translates to the aggregate of maximum points for each measurement in the last 24 hours
UPDATE sofa1 AS r1
SET sofa_score=(SELECT max(respiration)+max(coagulation)+ max(liver_bilirubin)
	+max(gcs)+GREATEST(max(renal_creatinine),max(renal_urine))+GREATEST(max(cardio_hypoten_map)
	,max(cardio_hypoten_dopamine),max(cardio_hypoten_dobutamine)
	,max(cardio_hypoten_epinephrine),max(cardio_hypoten_norepinephrine))
FROM sofa1 AS r2
WHERE r2.charttime>=(r1.charttime- interval '24 hours')
AND r2.charttime<=r1.charttime
AND r2.hadm_id=r1.hadm_id);

-- create a new table called sofa_all that will only have the hadm_id, charttime and the sofa_score
drop table sofa_all;
CREATE TABLE sofa_all(
hadm_id int,
charttime timestamp(0),
sofa_score int);

INSERT INTO sofa_all
SELECT DISTINCT *
FROM (SELECT hadm_id,charttime,sofa_score
	FROM sofa1) AS x
ORDER BY hadm_id,charttime;

-- add subject_id to the table
ALTER TABLE sofa_all
ADD subject_id int;

UPDATE sofa_all
SET subject_id= (SELECT admissions.subject_id
	FROM admissions
	WHERE admissions.hadm_id=sofa_all.hadm_id);

-- drop a previous table
DROP TABLE sofa;

-- create a new nice looking table to copy the data in sofa_all
CREATE TABLE sofa (
subject_id int,
hadm_id int,
charttime timestamp(0),
sofa_score int);

INSERT INTO sofa
SELECT subject_id,hadm_id,charttime,sofa_score
FROM sofa_all
ORDER BY hadm_id,charttime;

-- sofa is the final table we want and need and deserve!
