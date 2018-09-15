/*
OVERVIEW:
This document creates individual tables with lab value measurements based upon chosen d_labitems and d-items item IDs. 
 */
------------------------- start PR code -----------------------
-- create a table with chloride values
-- ITEMID for chloride in d_labitems is 50806, 50902,
-- itemid for chloride in d_items is 1523, 226536 all link to chartevents_adult_admissions


Drop table chloride_chart;
CREATE TABLE chloride_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO chloride_chart
SELECT subject_id,hadm_id,1,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1523, 226536);

Drop table chloride_lab;
CREATE TABLE chloride_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO chloride_lab
SELECT subject_id,hadm_id,1,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50806, 50902);

-- create a table with sodium values
-- itemid for sodium in d_items is 1536, 226534, all link to chartevents_adult_admissions tab les
-- itemid for sodium in d_labitems is 50824, 50983, 
 
Drop table sodium_chart;
CREATE TABLE sodium_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO sodium_chart
SELECT subject_id,hadm_id,2,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1536, 226534);

Drop table sodium_lab;
CREATE TABLE sodium_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO sodium_lab
SELECT subject_id,hadm_id,2,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50824, 50983);
 
-- create a table with cholesterol values
-- itemid for cholesterol in d_items is 1524, 220603
-- all link to chartevents_adult_admissions tables
-- itemid for cholesterol in d_labitems is 50907
 
Drop table cholesterol_chart;
CREATE TABLE cholesterol_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO cholesterol_chart
SELECT subject_id,hadm_id,3,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1524, 220603);

Drop table cholesterol_lab;
CREATE TABLE cholesterol_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO cholesterol_lab
SELECT subject_id,hadm_id,3,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50907);
 
-- create a table with creatinine values
-- itemid for creatinine in d_items is 1525, 220615
-- all link to chartevents_adult_admissions tables
-- itemid for creatinine in d_labitems is 50912
 
Drop table creatinine_chart;
CREATE TABLE creatinine_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO creatinine_chart
SELECT subject_id,hadm_id,4,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1525, 220615);

Drop table creatinine_lab;
CREATE TABLE creatinine_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO creatinine_lab
SELECT subject_id,hadm_id,4,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50912);
 
-- create a table with bicarbonate values
-- itemid for bicarbonate in d_items is 46362
-- itemid for bicarbonate in d_labitems is 50803, 50882
 
Drop table bicarbonate_chart;
CREATE TABLE bicarbonate_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO bicarbonate_chart
SELECT subject_id,hadm_id,5,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (812, 226759, 227443, 787, 3810);

Drop table bicarbonate_lab;
CREATE TABLE bicarbonate_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO bicarbonate_lab
SELECT subject_id,hadm_id,5,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50803, 50882, 50804);
 
-- create a table with hemoglobin values
-- itemid for hemoglobin in d_items is 814, 220228
-- all link to chartevents_adult_admissions tables
-- itemid for hemoglobin in d_labitems is 51222, 50811,50855
 
Drop table hemoglobin_chart;
CREATE TABLE hemoglobin_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO hemoglobin_chart
SELECT subject_id,hadm_id,6,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (814,220228);

Drop table hemoglobin_lab;
CREATE TABLE hemoglobin_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO hemoglobin_lab
SELECT subject_id,hadm_id,6,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51222, 50811,50855);
 
 
-- create a table with glucose values
-- itemid for glucose in d_items is 1529, 3744, 3745, 226537
-- all link to chartevents_adult_admissions tables
-- itemid for glucose in d_labitems is 50809, 50931
 
Drop table glucose_chart;
CREATE TABLE glucose_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO glucose_chart
SELECT subject_id,hadm_id,7,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1529, 3744, 3745, 226537);

Drop table glucose_lab;
CREATE TABLE glucose_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO glucose_lab
SELECT subject_id,hadm_id,7,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50809, 50931);
 
-- create a table with calcium values
-- itemid for calcium in d_items is 225625, 1522
-- all link to chartevents_adult_admissions tables
-- itemid for calcium in d_labitems is 50893
 
Drop table calcium_chart;
CREATE TABLE calcium_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO calcium_chart
SELECT subject_id,hadm_id,8,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (225625, 1522, 786);

Drop table calcium_lab;
CREATE TABLE calcium_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO calcium_lab
SELECT subject_id,hadm_id,8,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50893);
 
-- create a table with magnesium values
-- itemid for magnesium in d_items is 1532, 220635  
-- all link to chartevents_adult_admissions tables
-- itemid for magnesium in d_labitems is 50960
 
Drop table magnesium_chart;
CREATE TABLE magnesium_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO magnesium_chart
SELECT subject_id,hadm_id,9,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1532, 220635, 821);

Drop table magnesium_lab;
CREATE TABLE magnesium_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO magnesium_lab
SELECT subject_id,hadm_id,9,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50960);
 
-- create a table with hematocrit values
-- itemid for hematocrit in d_items is 813, 226540
-- all link to chartevents_adult_admissions tables
-- itemid for hematocrit in d_labitems 51221
 
Drop table hematocrit_chart;
CREATE TABLE hematocrit_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO hematocrit_chart
SELECT subject_id,hadm_id,10,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (813, 226540);

Drop table hematocrit_lab;
CREATE TABLE hematocrit_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO hematocrit_lab
SELECT subject_id,hadm_id,10,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51221);
 
-- create a table with potassium values
-- itemid for potassium in d_items is 1535, 227464
-- all link to chartevents_adult_admissions tables
-- itemid for potassium in d_labitems is 50822
 
Drop table potassium_chart;
CREATE TABLE potassium_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO potassium_chart
SELECT subject_id,hadm_id,11,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (3725, 3792, 1535, 829, 4194, 226772);

Drop table potassium_lab;
CREATE TABLE potassium_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO potassium_lab
SELECT subject_id,hadm_id,11,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50822);
 
 
-- create a table with protime values
-- itemid for protime in d_items is 3793
-- all link to chartevents_adult_admissions tables
 
Drop table protime_chart;
CREATE TABLE protime_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO protime_chart
SELECT subject_id,hadm_id,12,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (3793, 824, 1286);

Drop table protime_lab;
CREATE TABLE protime_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO protime_lab
SELECT subject_id,hadm_id,12,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51274);
 
-- create a table with total protein values
-- itemid for total protein in d_items is 1539, 220650
-- all link to chartevents_adult_admissions tables
-- itemid for total protein in d_labitems is 50976
 
Drop table tprotein_chart;
CREATE TABLE tprotein_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO tprotein_chart
SELECT subject_id,hadm_id,13,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1539, 220650);

Drop table tprotein_lab;
CREATE TABLE tprotein_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO tprotein_lab
SELECT subject_id,hadm_id,13,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50976);
 
-- create a table with lactic acid values
-- itemid for total protein in d_items is 1531, 225668
-- all link to chartevents_adult_admissions tables
-- d_labitems: 50813
 
Drop table lactic_chart;
CREATE TABLE lactic_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO lactic_chart
SELECT subject_id,hadm_id,14,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1531, 225668, 818, 225668);

Drop table lactic_lab;
CREATE TABLE lactic_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO lactic_lab
SELECT subject_id,hadm_id,14,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50813);
 
-- create a table with albumin values
-- itemid for albumin in d_items is 1521, 2358, 3066, 227456
-- all link to chartevents_adult_admissions tables
-- itemid for albumin in d_labitems is 50862
 
Drop table albumin_chart;
CREATE TABLE albumin_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO albumin_chart
SELECT subject_id,hadm_id,15,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1521, 2358, 3066, 227456, 772, 3727);

Drop table albumin_lab;
CREATE TABLE albumin_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO albumin_lab
SELECT subject_id,hadm_id,15,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50862);
 
-- create a table with platelet count values
-- itemid for platelet count in d_items is 6256, 828, 227457,
-- all link to chartevents_adult_admissions tables
-- itemid for platelet count in d_labitems is 51265
 
Drop table platelet_chart;
CREATE TABLE platelet_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO platelet_chart
SELECT subject_id,hadm_id,16,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (6256, 828, 227457);

Drop table platelet_lab;
CREATE TABLE platelet_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO platelet_lab
SELECT subject_id,hadm_id,16,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51265);
 
-- create a table with white blood cells count values
-- itemid for white blood cells count in d_items is 1542, 220546
-- itemid for white blood cells count in d_labitems is 51301, 51300
 
Drop table whiteblood_chart;
CREATE TABLE whiteblood_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
 INSERT INTO whiteblood_chart
SELECT subject_id,hadm_id,17,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1542, 220546);

Drop table whiteblood_lab;
CREATE TABLE whiteblood_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO whiteblood_lab
SELECT subject_id,hadm_id,17,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51301, 51300);

-- create a table with bilirubin values
-- itemid for bilirubin in d_items is 4948, 225690
-- all link to chartevents_adult_admissions tables
-- itemid for bilirubin in d_labitems is 50885
 
Drop table bilirubin_chart;
CREATE TABLE bilirubin_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO bilirubin_chart
SELECT subject_id,hadm_id,18,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (4948, 225690);

Drop table bilirubin_lab;
CREATE TABLE bilirubin_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO bilirubin_lab
SELECT subject_id,hadm_id,18,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50885);
 
-- create a table with alkaline phosphate values
-- itemid for alkaline phosphate in d_items is 3728, 225612
-- all link to chartevents_adult_admissions tables
-- itemid for alkaline phosphate in d_labitems is 50863
 
Drop table alkPhos_chart;
CREATE TABLE alkPhos_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
INSERT INTO alkPhos_chart
SELECT subject_id,hadm_id,19,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (225612, 773);

Drop table alkPhos_lab;
CREATE TABLE alkPhos_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO alkPhos_lab
SELECT subject_id,hadm_id,19,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50863);
 
-- create a table with neutrophils values
-- itemid for neutrophils in d_labitems is 51256
 
Drop table neutrophils_chart;
CREATE TABLE neutrophils_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
 INSERT INTO neutrophils_chart
SELECT subject_id,hadm_id,20,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (225643);

Drop table neutrophils_lab;
CREATE TABLE neutrophils_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);

INSERT INTO neutrophils_lab
SELECT subject_id,hadm_id,20,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51256);
 
 
------- START SA CODE -------
-- create a table with pulse values
-- ITEMID for pulse in d_labitems is n/a
-- itemid for pulse in d_items is 1725, 211, 20045 all link to chartevents_adult_admissions table
 
Drop table pulse_chart;
CREATE TABLE pulse_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO pulse_chart
SELECT subject_id,hadm_id,21,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1725, 211, 220045, 1332, 1341, 212,  1332);
 
-- create a table with SpO2
-- ITEMID for SpO2 in d_labitems is n/a
-- itemid for SpO2 in d_items is 646 all link to chartevents_adult_admissions table
 
Drop table SpO2_chart;
CREATE TABLE SpO2_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO SpO2_chart
SELECT subject_id,hadm_id,22,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (646, 220277);

------------------ START ML CODE ----------
 
-- create a table with temp values
-- ITEMID for temp values in d_labitems is 50825 (C)
-- itemid for temp values in d_items is 676 ©, 677 ©, 678 (F), 679 (F), 3652 (F), 3654 (F), 3655 ©, 223761 (F), 223762 ©, all link to chartevents_adult_admissions table
 
Drop table temp_chart;
CREATE TABLE temp_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
 
INSERT INTO temp_chart
SELECT subject_id,hadm_id,23,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (676, 677, 678, 679, 3652, 3654, 3655, 223761, 223762);

Drop table temp_lab;
CREATE TABLE temp_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO temp_lab
SELECT subject_id,hadm_id,23,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50825);
 

-- create a table with glascow coma score values
-- ITEMID for chloride in d_labitems is [none]
-- itemid for chloride in d_items is 198, all link to chartevents_adult_admissions table
 
Drop table gcs_chart;
CREATE TABLE gcs_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO gcs_chart
SELECT subject_id,hadm_id,24,itemid,valuenum,charttime 
FROM chartevents_adult_admissions
WHERE itemid in (198);

INSERT INTO gcs_chart
SELECT subject_id,hadm_id,24,-420,total,charttime 
FROM chartevents_adult_gcs_joined;


-- create a table with rass score values
-- ITEMID for rass score in d_labitems is [none]
-- itemid for rass score in d_items is 228302 all link to chartevents_adult_admissions table
 
Drop table rassscore_chart;
CREATE TABLE rassscore_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO rassscore_chart
SELECT subject_id,hadm_id,25,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (228302);

-- create a table with resp values
-- ITEMID for resp in d_labitems is [NONE]
-- itemid for resp in d_items is 614, 615, 618, 219, 619, 653, 1884, 8113, 3603, 224688, 224689, 224690, 220210 all link to chartevents_adult_admissions table
 
Drop table resp_chart;
CREATE TABLE resp_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO resp_chart
SELECT subject_id,hadm_id,26,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (615, 618, 219, 619, 653, 1884, 8113, 3603, 224688, 224689, 224690, 220210, 3337);

--------------------- START OL CODE ---------------------
-- create a table with aniongap values
-- ITEMID for aniongap  in d_labitems is  3732, 227073
-- itemid for aniongap  in d_items is 50868

Drop table aniongap_chart;
CREATE TABLE aniongap_chart(
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO aniongap_chart
SELECT subject_id,hadm_id,28,itemid,valuenum,charttime
 FROM chartevents_adult_admissions
WHERE itemid in (3732, 227073);

Drop table aniongap_lab;
CREATE TABLE aniongap_lab(
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO aniongap_lab
SELECT subject_id,hadm_id,28,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50868);

-- create a table with blood_urea_nitrogen values
-- ITEMID for blood_urea_nitrogen  in d_labitems is 51006
-- itemid for blood_urea_nitrogen  in d_items is 1162, 5876, 225624

Drop table blood_urea_nitrogen_chart;
CREATE TABLE blood_urea_nitrogen_chart (
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO blood_urea_nitrogen_chart
 SELECT subject_id,hadm_id,29,itemid,valuenum,charttime
 FROM chartevents_adult_admissions
WHERE itemid in (1162, 5876, 225624);

Drop table blood_urea_nitrogen_lab;
CREATE TABLE blood_urea_nitrogen_lab (
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO blood_urea_nitrogen_lab
 SELECT subject_id,hadm_id,29,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51006);

-- create a table with alt_gpt values
-- ITEMID for alt_gpt  in d_labitems is 50861
-- itemid for alt_gpt in d_items is 769, 220644

Drop table alt_gpt_chart;
CREATE TABLE alt_gpt_chart (
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO alt_gpt_chart
 SELECT subject_id,hadm_id,30,itemid,valuenum,charttime
 FROM chartevents_adult_admissions
WHERE itemid in (769, 220644);

Drop table alt_gpt_lab;
CREATE TABLE alt_gpt_lab (
 subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO alt_gpt_lab
 SELECT subject_id,hadm_id,30,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50861);

--------------------- START RW CODE --------------------
-- create a table with AST (GOT) values
-- itemid for AST (GOT) in d_items is 220587, 770
-- ITEMID for AST (GOT) in d_labitems is 50878
 
Drop table ast_got_chart;
CREATE TABLE ast_got_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO ast_got_chart
SELECT subject_id,hadm_id,31,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (220587, 770);

Drop table ast_got_lab;
CREATE TABLE ast_got_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO ast_got_lab
SELECT subject_id,hadm_id,31,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50878);
 
-- create a table with INR Protime values
-- itemid for INR Protime in d_items is 3793, 227467
-- ITEMID for INR Protime in d_labitems is 51237
 
Drop table inr_protime_chart;
CREATE TABLE inr_protime_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO inr_protime_chart
SELECT subject_id,hadm_id,32,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (815,1530,227467);

Drop table inr_protime_lab;
CREATE TABLE inr_protime_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO inr_protime_lab
SELECT subject_id,hadm_id,32,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51237);
 
-- create a table with Arterial pH values
-- itemid for Arterial pH in d_items is 223830, 780
-- ITEMID for Arterial pH in d_labitems is NONE
 
Drop table arterial_ph_chart;
CREATE TABLE arterial_ph_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO arterial_ph_chart
SELECT subject_id,hadm_id,33,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (223830, 780, 1126, 4753);

Drop table arterial_ph_lab;
CREATE TABLE arterial_ph_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO arterial_ph_lab
SELECT subject_id,hadm_id,33,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50820);
 
-- create a table with PCO2 values
-- itemid for PCO2 in d_items is 3784, 3835
-- ITEMID for PCO2 in d_labitems is 50818
 
Drop table pco2_chart;
CREATE TABLE pco2_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO pco2_chart
SELECT subject_id,hadm_id,34,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (3784, 3835, 220235, 778);
 
Drop table pco2_lab;
CREATE TABLE pco2_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO pco2_lab
SELECT subject_id,hadm_id,34,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50818);
 
-- create a table with PO2 values
-- itemid for PO2 in d_items is 3837, 3785
-- ITEMID for PO2 in d_labitems is 50821
 
Drop table po2_chart;
CREATE TABLE po2_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO po2_chart
SELECT subject_id,hadm_id,35,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (3837, 3785);

Drop table po2_lab;
CREATE TABLE po2_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO po2_lab
SELECT subject_id,hadm_id,35,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50821);
 
--------------------- START CS CODE --------------------
-- itemid for oxygen saturation in d_labitems is 50817
-- itemid for oxygen saturation in d_items is 220227
-- for d_items, anything with oxygen/o2 with sat was included (excluding spo2, po2 and including venous)
 
Drop table oxygen_chart;
CREATE TABLE oxygen_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO oxygen_chart
SELECT subject_id,hadm_id,36,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (220227, 834, 3288, 228232);

Drop table oxygen_lab;
CREATE TABLE oxygen_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO oxygen_lab
SELECT subject_id,hadm_id,36,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50817);
 
-- itemid for base excess in d_labitems is 50802
-- itemid for base excess in d_items is 74, 776, 224828
 
Drop table base_chart;
CREATE TABLE base_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO base_chart
SELECT subject_id,hadm_id,37,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (74, 776, 224828);

Drop table base_lab;
CREATE TABLE base_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO base_lab
SELECT subject_id,hadm_id,37,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50802);
 
-- itemid for troponin_i in d_labitems is 51002
-- itemid for troponin_i in d_items is 851
 
Drop table troponin_i_chart;
CREATE TABLE troponin_i_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO troponin_i_chart
SELECT subject_id,hadm_id,38,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (851);

Drop table troponin_i_lab;
CREATE TABLE troponin_i_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO troponin_i_lab
SELECT subject_id,hadm_id,38,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (51002);
 
-- itemid for phosphorus in d_labitems is n/a
-- selecting just 'phosphor(o)us' had no results, had to select 'phosp'
-- itemid for phosphorus in d_items is 1534, 225677
-- selecting 'phosphorus' and 'phosphorous'
 
Drop table phosphorus_chart;
CREATE TABLE phosphorus_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO phosphorus_chart
SELECT subject_id,hadm_id,39,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (1534, 225677, 827);

Drop table phosphorus_lab;
CREATE TABLE phosphorus_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

 INSERT INTO phosphorus_lab
SELECT subject_id,hadm_id,39,itemid,valuenum,charttime
FROM labevents
WHERE itemid in (50971);
 
-- itemid for partial thromboplastin time in d_labitems is n/a
-- itemid for partial thromboplastin time in d_items is 221004, 227056
-- selecting 'thrombo' which gives thrombocyte and thrombolytic
 
Drop table thromboplastin_chart;
CREATE TABLE thromboplastin_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO thromboplastin_chart
SELECT subject_id,hadm_id,40,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (227056,825,3796,1533,227466,220562,227465,227469,844);
 
-- itemid for FIO2 in d_labitems is n/a
-- itemid for FIO2 in d_items is 2981, 3420, 22385
-- also selected for ‘inspire’
 
Drop table FIO2_chart;
CREATE TABLE FIO2_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO FIO2_chart
SELECT subject_id,hadm_id,41,itemid,valuenum,charttime
FROM chartevents_adult_admissions
WHERE itemid in (190, 2981, 3420, 223835, 226754);

------------------------------------------------------------------- ADDING BLOOD PRESSURE
----GENDER AND DOB
 
Drop table systolic_bp_chart;
CREATE TABLE systolic_bp_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));
 
INSERT INTO systolic_bp_chart
SELECT subject_id,hadm_id,42,itemid,valuenum,charttime
FROM mimiciii.chartevents_adult_admissions
WHERE itemid in (442, 455, 480, 482, 484, 227243, 220179, 224167);



Drop table diastolic_bp_chart;
CREATE TABLE diastolic_bp_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0));

INSERT INTO diastolic_bp_chart
SELECT subject_id,hadm_id,43,itemid,valuenum,charttime
FROM mimiciii.chartevents_adult_admissions
WHERE itemid in (8440, 8441, 8445, 8446, 8444, 227242, 220180, 224643);

-- outlier removal
update temp_chart set value = (((value * 9) / 5)+32) where itemid  in (50825, 676, 677, 3655, 223762);
update temp_lab set value = (((value * 9) / 5)+32) where itemid  in (50825, 676, 677, 3655, 223762);

update temp_chart set value = CASE WHEN value < 45 THEN (((value * 9) / 5)+32) end;

DELETE FROM temp_chart where value <60;
DELETE FROM temp_chart where value >115;
delete from resp_chart where value=0;
UPDATE FIO2_chart set value = (CASE WHEN value <=1 THEN value*100 end);
DELETE FROM systolic_bp_chart where value=0;
DELETE FROM diastolic_bp_chart where value=0;

DELETE FROM gcs_chart where value<3;
