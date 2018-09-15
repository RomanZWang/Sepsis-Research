------------------------------------------------------------------------------
-- Identify patients with Suspected Infections
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- Mimic version: MIMIC III v1.3
-- Descriptions: Suspected infection is defined as blood culture drawn in the
-- window of 24 hours after antibiotics administrations OR antibiotics
-- administration in a window of 72 hours after blood culture.
-- This query creates a table antib_blood which contains subject_id,
-- hadm_id, startdate of antibiotics, enddate of antibiotics, charttime
-- of blood culture, time of infection.
------------------------------------------------------------------------------

--- definition: antibiotics-24hrs-blood_culture-72hrs-antibiotics --

-- lets add a column to antibiotics prescriptions table
-- this column contains the time diff in hours between prescription time
-- and blood culture time
DROP TABLE IF EXISTS antib_blood;
CREATE TABLE antib_blood (
subject_id int,
hadm_id int,
admittime timestamp(0),
startdate timestamp(0),
enddate timestamp(0),
charttime timestamp(0));

INSERT INTO antib_blood
SELECT antib.subject_id,antib.hadm_id, blood.admittime, antib.startdate,
antib.enddate,blood.charttime
FROM antib
INNER JOIN blood
ON antib.hadm_id=blood.hadm_id
ORDER BY antib.hadm_id;


--cap start with admit time

UPDATE antib_blood
SET startdate = (

	startdate+'1 minute'::INTERVAL*ROUND(RANDOM()*60)+'1 hour'::INTERVAL*ROUND(RANDOM()*24)

);

UPDATE antib_blood
SET enddate = (

	startdate+'1 minute'::INTERVAL*ROUND(RANDOM()*60)+'1 hour'::INTERVAL*ROUND(RANDOM()*24)

);


UPDATE antib_blood
SET startdate = (

	SELECT admittime


)
WHERE startdate<admittime;

ALTER TABLE antib_blood
ADD time_infection timestamp(0);


-- UPDATE antib_blood
-- SET time_infection=(CASE
-- WHEN charttime>=(startdate-interval '72 hours') AND startdate>=charttime THEN charttime
-- WHEN charttime>=startdate AND (startdate+interval'24 hours')>=charttime THEN charttime
-- WHEN charttime>=(startdate+interval '24 hours') AND charttime<=enddate THEN (charttime-interval '24 hours')
-- WHEN charttime>=enddate AND charttime<=(enddate+interval '24 hours') THEN enddate
-- ELSE NULL
-- END);

UPDATE antib_blood
SET time_infection=(CASE
WHEN charttime>=(startdate-interval '72 hours') AND (startdate+interval'24 hours')>=charttime THEN charttime
WHEN charttime>=(startdate+interval '24 hours') AND charttime<=enddate THEN startdate+(interval '24 hours')
WHEN charttime>=enddate AND charttime<=(enddate+interval '24 hours') THEN enddate
ELSE NULL
END);


DELETE FROM antib_blood
WHERE time_infection ISNULL;
