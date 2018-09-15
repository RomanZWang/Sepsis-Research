/******************************************************************************/

/*
TABLES
labitemstats - stats for itemids coming from d_labitems which have data entries in labevents
itemstats - stats for itemids coming from d_items which have data entries in chartevents, outputevents, inputevents_cv, inputevents_mv

the linksto column shows which table the data entries were in

It seems like inputevents are measured quantities given to patients so those itemids are probably not what we want in our variables.

/******************************************************************************/

/* items centraltend */

/******************************************************************************/

*/

/******************************************************************************/


/*Create table*/
DROP TABLE itemcentraltend;
CREATE TABLE itemcentraltend(
itemid INT,
label VARCHAR(200),
count INT,
valueuom VARCHAR(50),
median DOUBLE PRECISION,
min DOUBLE PRECISION,
q1 DOUBLE PRECISION,
mean DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
linksto VARCHAR(50)
);

/*Insert names and itemids*/
INSERT INTO itemcentraltend (itemid, label)
Select itemid, label from d_items;


/*update counts - number of times the itemid appears in labevents as an entry*/
UPDATE itemcentraltend AS t1
SET count = (
SELECT COUNT(itemid) FROM labevents AS t2
WHERE t1.itemid=t2.itemid
GROUP BY itemid);

UPDATE itemcentraltend AS t1
SET count = (
SELECT COUNT(itemid) FROM chartevents AS t2
WHERE t1.itemid=t2.itemid
GROUP BY itemid);

/*update unit of measurements*/
UPDATE itemcentraltend AS t1
SET valueuom = (SELECT valueuom FROM labevents AS t2
WHERE t1.itemid=t2.itemid
AND (t2.valueuom IS NOT NULL)
AND t2.valueuom != '\'\''
LIMIT 1);

UPDATE itemcentraltend AS t1
SET valueuom = (SELECT valueuom FROM labevents AS t2
WHERE t1.itemid=t2.itemid
AND (t2.valueuom IS NOT NULL)
AND t2.valueuom != '\'\''
LIMIT 1);

/*create table to hold stat values*/
CREATE TABLE itemstats_num (
itemid INT,
mean DOUBLE PRECISION,
q1 DOUBLE PRECISION,
median DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
min DOUBLE PRECISION
);

/*populate stat values*/
INSERT INTO itemstats_num
SELECT
  itemid, avg(valuenum) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY valuenum) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY valuenum) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY valuenum) AS q3, max(valuenum) AS max, min(valuenum)

FROM mimiciii.chartevents
GROUP BY itemid;

/*update itemcentraltend with nums*/

UPDATE itemcentraltend SET (mean, min, max, q1, median, q3) = (itemstats_num.mean, itemstats_num.min, itemstats_num.max, itemstats_num.q1, itemstats_num.median, itemstats_num.q3) FROM itemstats_num WHERE itemcentraltend.itemid = itemstats_num.itemid;

\copy itemcentraltend to 'C:/Users/Public/itemcentraltend.csv' csv header

/******************************************************************************/

/* lab items */

/******************************************************************************/

/*Create table*/
DROP TABLE labitemstats;
CREATE TABLE labitemstats (
variable VARCHAR(255),
itemid INT,
label VARCHAR(200),
count INT,
valueuom VARCHAR(50),
median DOUBLE PRECISION,
min DOUBLE PRECISION,
q1 DOUBLE PRECISION,
mean DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
linksto VARCHAR(50)
);

/*Insert names and itemids*/
INSERT INTO labitemstats (variable, itemid)
VALUES
('Chloride',50806),
('Chloride',50902),
('Sodium',50824),
('Sodium',50983),
('Cholesterol',50907),
('Creatinine',50912),
('Bicarbonate',50803),
('Bicarbonate',50882),
('Bicarbonate',50804),
('Hemoglobin',51222),
('Hemoglobin',50811),
('Hemoglobin',50855),
('Glucose',50931),
('Glucose',50809),
('Calcium',50893),
('Magnesium',50960),
('Hematocrit',51221),
('Potassium',50822),
('Protime_INR',51274),
('Total_Protein',50976),
('Lactate',50813),
('Albumin',50862),
('Platelet_Count',51265),
('WBCC',51301),
('WBCC',51300),
('Total_Bilirubin',50885),
('Alkaline_Phosphatase',50863),
('Neutrophils_Percent',51256),
('Temp_Source',50825),
('Anion_Gap',50868),
('Blood_Urea_Nitrogen',51006),
('ALT_GPT',50861),
('AST_GOT',50878),
('Protime',51237),
('pH_Arterial',50820),
('PCO2',50818),
('PO2',50821),
('Oxygen_Saturation',50817),
('Base_Excess',50802),
('Troponin-I',51002),
('Phosphorus',50970),
('PTT',51275);

/*update labels that describe what the itemid measures*/
UPDATE labitemstats AS t1
SET label = (SELECT label FROM d_labitems AS t2
WHERE t1.itemid=t2.itemid);

/*update counts - number of times the itemid appears in labevents as an entry*/
UPDATE labitemstats AS t1
SET count = (
SELECT COUNT(itemid) FROM labevents AS t2
WHERE t1.itemid=t2.itemid
GROUP BY itemid);

/*update unit of measurements*/
UPDATE labitemstats AS t1
SET valueuom = (SELECT valueuom FROM labevents AS t2
WHERE t1.itemid=t2.itemid
AND (t2.valueuom IS NOT NULL)
AND t2.valueuom != '\'\''
LIMIT 1);

/*create table to hold stat values*/
CREATE TABLE labitemstats_num (
itemid INT,
mean DOUBLE PRECISION,
q1 DOUBLE PRECISION,
median DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
min DOUBLE PRECISION
);

/*populate stat values*/
INSERT INTO labitemstats_num
SELECT
  itemid, avg(valuenum) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY valuenum) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY valuenum) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY valuenum) AS q3, max(valuenum) AS max, min(valuenum)

FROM mimiciii.labevents
GROUP BY itemid;

/*update labitemstats with nums*/

UPDATE labitemstats SET (mean, min, max, q1, median, q3) = (labitemstats_num.mean, labitemstats_num.min, labitemstats_num.max, labitemstats_num.q1, labitemstats_num.median, labitemstats_num.q3) FROM labitemstats_num WHERE labitemstats.itemid = labitemstats_num.itemid;

/******************************************************************************/

/* items */

/******************************************************************************/

/*Create table*/
DROP TABLE itemstats;
CREATE TABLE itemstats (
variable VARCHAR(255),
itemid INT,
label VARCHAR(200),
count INT,
valueuom VARCHAR(50),
median DOUBLE PRECISION,
min DOUBLE PRECISION,
q1 DOUBLE PRECISION,
mean DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
linksto VARCHAR(50)
);

/*Insert names and itemids*/
INSERT INTO itemstats (variable, itemid)
VALUES
('Chloride',1523),
('Chloride',226536),
('Sodium',1536),
('Sodium',226534),
('Cholesterol',1524),
('Cholesterol',220603),
('Creatinine',1525),
('Creatinine',220615),
('Bicarbonate',812),
('Bicarbonate',226759),
('Bicarbonate',227443),
('Bicarbonate',787),
('Bicarbonate',3810),
('Hemoglobin',814),
('Hemoglobin',220228),
('Glucose',1529),
('Glucose',3744),
('Glucose',3745),
('Glucose',226537),
('Calcium',225625),
('Calcium',1522),
('Calcium',786),
('Magnesium',1532),
('Magnesium',220635),
('Magnesium',821),
('Hematocrit',813),
('Hematocrit',226540),
('Potassium',3725),
('Potassium',3792),
('Potassium',1535),
('Potassium',226772),
('Potassium',829),
('Potassium',4194),
('Protime',3793),
('Protime',824),
('Protime',1286),
('Total_Protein',1539),
('Total_Protein',220650),
('Lactate',1531),
('Lactate',225668),
('Lactate',818),
('Lactate',225668),
('Albumin',1521),
('Albumin',2358),
('Albumin',3066),
('Albumin',227456),
('Albumin',772),
('Albumin',3727),
('Platelet_Count',6256),
('Platelet_Count',828),
('Platelet_Count',227457),
('WBCC',1542),
('WBCC',220546),
('Total_Bilirubin',4948),
('Total_Bilirubin',225690),
('Alkaline_Phosphatase',225612),
('Alkaline_Phosphatase',773),
('Neutrophils_Percent',225643),
('Pulse',1725),
('Pulse',211),
('Pulse',220045),
('Pulse',1332),
('Pulse',1341),
('Pulse',212),
('Pulse',1332),
('SpO2',646),
('SpO2',220277),
('Temp_Source',676),
('Temp_Source',677),
('Temp_Source',678),
('Temp_Source',679),
('Temp_Source',3652),
('Temp_Source',3654),
('Temp_Source',3655),
('Temp_Source',223761),
('Temp_Source',223762),
('GCS',198),
('Rass_Score',228302),
('Respiration',615),
('Respiration',618),
('Respiration',619),
('Respiration',219),
('Respiration',653),
('Respiration',1884),
('Respiration',8113),
('Respiration',3603),
('Respiration',224688),
('Respiration',224689),
('Respiration',224690),
('Respiration',3337),
('Respiration',220210),
('Nudesc', 228332),
('Anion_Gap',3732),
('Anion_Gap',227073),
('Blood_Urea_Nitrogen',1162),
('Blood_Urea_Nitrogen',5876),
('Blood_Urea_Nitrogen',225624),
('ALT_GPT',769),
('ALT_GPT',220644),
('AST_GOT',220587),
('AST_GOT',770),
('Protime INR',815),
('Protime INR',1530),
('Protime INR',227467),
('pH_Arterial',223830),
('pH_Arterial',780),
('pH_Arterial',1126),
('pH_Arterial',4753),
('Arterial PCO2',3784),
('Arterial PCO2',3835),
('Arterial PCO2',220235),
('Arterial PCO2',778),
('PO2',3837),
('PO2',3785),
('Oxygen_Saturation',220227),
('Oxygen_Saturation',834),
('Oxygen_Saturation',3288),
('Oxygen_Saturation',228232),
('Base_Excess',74),
('Base_Excess',776),
('Base_Excess',224828),
('Troponin-I',851),
('Phosphorus',1534),
('Phosphorus',225677),
('Phosphorus',827),
('PTT',227056),
('PTT',3796),
('PTT',1533),
('PTT',227466),
('PTT',220562),
('PTT',227465),
('PTT',227469),
('PTT',844),
('PTT',825),
('FIO2',2981),
('FIO2',3420),
('FIO2',223835),
('FIO2',226754),
('NI_Systolic_BP',442),
('NI_Systolic_BP',455),
('NI_Systolic_BP',480),
('NI_Systolic_BP',482),
('NI_Systolic_BP',484),
('NI_Systolic_BP',227243),
('NI_Systolic_BP',224167),
('NI_Systolic_BP',220179),
('NI_Diastolic_BP',8440),
('NI_Diastolic_BP',8441),
('NI_Diastolic_BP',8445),
('NI_Diastolic_BP',8446),
('NI_Diastolic_BP',8444),
('NI_Diastolic_BP',227242),
('NI_Diastolic_BP',220180),
('NI_Diastolic_BP',224643);


/*update labels that describe what the itemid measures*/
UPDATE itemstats AS t1
SET label = (SELECT label FROM d_items AS t2
WHERE t1.itemid=t2.itemid);

/*update counts - number of times the itemid appears in labevents as an entry*/

UPDATE itemstats AS t1
SET count = (
SELECT COUNT(itemid) FROM inputevents_cv AS t2
WHERE t1.itemid=t2.itemid
AND count is NULL
GROUP BY itemid);

UPDATE itemstats AS t1
SET count = (
SELECT COUNT(itemid) FROM inputevents_mv AS t2
WHERE t1.itemid=t2.itemid
AND count is NULL
GROUP BY itemid);

UPDATE itemstats AS t1
SET count = (
SELECT COUNT(itemid) FROM outputevents AS t2
WHERE t1.itemid=t2.itemid
AND count is NULL
GROUP BY itemid);

UPDATE itemstats AS t1
SET count = (
SELECT COUNT(itemid) FROM chartevents AS t2
WHERE t1.itemid=t2.itemid
AND count is NULL
GROUP BY itemid);

/*update linksto - where the itemid data entries can be found*/

UPDATE itemstats AS t1
SET linksto = (SELECT linksto FROM d_items AS t2
WHERE t1.itemid=t2.itemid);

/*update unit of measurements*/

UPDATE itemstats AS t1
SET valueuom = (SELECT amountuom FROM inputevents_mv AS t2
WHERE t1.itemid=t2.itemid
AND (t2.amountuom IS NOT NULL)
ORDER BY valueuom DESC NULLS LAST
LIMIT 1)
WHERE valueuom IS NULL;

UPDATE itemstats AS t1
SET valueuom = (SELECT amountuom FROM inputevents_cv AS t2
WHERE t1.itemid=t2.itemid
AND (t2.amountuom IS NOT NULL)

ORDER BY valueuom DESC NULLS LAST
LIMIT 1)
WHERE valueuom is NULL;

UPDATE itemstats AS t1
SET valueuom = (SELECT valueuom FROM outputevents AS t2
WHERE t1.itemid=t2.itemid
AND (t2.valueuom IS NOT NULL)
ORDER BY valueuom DESC NULLS LAST
LIMIT 1)
WHERE valueuom is NULL;

UPDATE itemstats AS t1
SET valueuom = (SELECT valueuom FROM chartevents AS t2
WHERE t1.itemid=t2.itemid
AND (t2.valueuom IS NOT NULL)
ORDER BY valueuom DESC NULLS LAST
LIMIT 1)
WHERE valueuom is NULL;

/*create table to hold stat values*/
CREATE TABLE itemstats_num (
itemid INT,
mean DOUBLE PRECISION,
q1 DOUBLE PRECISION,
median DOUBLE PRECISION,
q3 DOUBLE PRECISION,
max DOUBLE PRECISION,
min DOUBLE PRECISION
);

/*populate stat values*/

INSERT INTO itemstats_num
SELECT
  itemid, avg(amount) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY amount) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY amount) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY amount) AS q3, max(amount) AS max, min(amount)
FROM mimiciii.inputevents_cv
GROUP BY itemid;

INSERT INTO itemstats_num
SELECT
  itemid, avg(amount) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY amount) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY amount) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY amount) AS q3, max(amount) AS max, min(amount)
FROM mimiciii.inputevents_mv
GROUP BY itemid;

INSERT INTO itemstats_num
SELECT
  itemid, avg(valuenum) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY valuenum) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY valuenum) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY valuenum) AS q3, max(valuenum) AS max, min(valuenum)
FROM chartevents
GROUP BY itemid;

INSERT INTO itemstats_num
SELECT
  itemid, avg(valuenum) AS mean, percentile_cont(0.25) WITHIN GROUP (ORDER BY valuenum) AS q1,percentile_cont(0.5) WITHIN GROUP (ORDER BY valuenum) AS median, percentile_cont(0.75) WITHIN GROUP (ORDER BY valuenum) AS q3, max(valuenum) AS max, min(valuenum)
FROM mimiciii.outputevents
GROUP BY itemid;

/*update itemstats with nums*/

UPDATE itemstats SET (mean, min, max, q1, median, q3) = (itemstats_num.mean, itemstats_num.min, itemstats_num.max, itemstats_num.q1, itemstats_num.median, itemstats_num.q3) FROM itemstats_num WHERE itemstats.itemid = itemstats_num.itemid;

\copy labitemstats to 'C:/Users/Public/labitemstats.csv' csv header
\copy itemstats to 'C:/Users/Public/itemstats.csv' csv header
