Drop table allValues_chart;
Create table allValues_chart(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 
Insert into allValues_chart
select subject_id, hadm_id, sepsis_lab_id, itemid, value, charttime
from 
	(

SELECT * FROM chloride_chart
UNION ALL
SELECT * FROM sodium_chart
UNION ALL
SELECT * FROM cholesterol_chart
UNION ALL
SELECT * FROM creatinine_chart
UNION ALL
SELECT * FROM bicarbonate_chart
UNION ALL
SELECT * FROM hemoglobin_chart
UNION ALL
SELECT * FROM glucose_chart
UNION ALL
SELECT * FROM calcium_chart
UNION ALL
SELECT * FROM magnesium_chart
UNION ALL
SELECT * FROM hematocrit_chart
UNION ALL
SELECT * FROM potassium_chart
UNION ALL
SELECT * FROM protime_chart
UNION ALL
SELECT * FROM tprotein_chart
UNION ALL
SELECT * FROM lactic_chart
UNION ALL
SELECT * FROM albumin_chart
UNION ALL
SELECT * FROM platelet_chart
UNION ALL
SELECT * FROM whiteblood_chart
UNION ALL
SELECT * FROM bilirubin_chart
UNION ALL
SELECT * FROM alkPhos_chart
UNION ALL
SELECT * FROM neutrophils_chart
UNION ALL
SELECT * FROM pulse_chart
UNION ALL
SELECT * FROM SpO2_chart
UNION ALL
SELECT * FROM temp_chart
UNION ALL
SELECT * FROM gcs_chart
UNION ALL
SELECT * FROM rassscore_chart
UNION ALL
SELECT * FROM resp_chart
UNION ALL
--SELECT * FROM nudesc_chart
--UNION ALL
SELECT * FROM aniongap_chart
UNION ALL
SELECT * FROM blood_urea_nitrogen_chart
UNION ALL
SELECT * FROM alt_gpt_chart
UNION ALL
SELECT * FROM ast_got_chart
UNION ALL
SELECT * FROM inr_protime_chart
UNION ALL
SELECT * FROM arterial_ph_chart
UNION ALL
SELECT * FROM pco2_chart
UNION ALL
SELECT * FROM po2_chart
UNION ALL
SELECT * FROM oxygen_chart
UNION ALL
SELECT * FROM base_chart
UNION ALL
SELECT * FROM troponin_i_chart
UNION ALL
SELECT * FROM phosphorus_chart
UNION ALL
SELECT * FROM thromboplastin_chart
UNION ALL
SELECT * FROM FIO2_chart
UNION ALL
SELECT * FROM systolic_bp_chart
UNION ALL
SELECT * FROM diastolic_bp_chart	) as x;


Drop table allValues_lab;
Create table allValues_lab(
subject_id INT,
hadm_id INT,
sepsis_lab_id INT,
itemid INT,
value DOUBLE PRECISION,
charttime timestamp(0)
);
 Insert into allValues_lab
select subject_id, hadm_id, sepsis_lab_id, itemid, value, charttime
from 
	(

SELECT * FROM chloride_lab
UNION ALL
SELECT * FROM sodium_lab
UNION ALL
SELECT * FROM cholesterol_lab
UNION ALL
SELECT * FROM creatinine_lab
UNION ALL
SELECT * FROM bicarbonate_lab
UNION ALL
SELECT * FROM hemoglobin_lab
UNION ALL
SELECT * FROM glucose_lab
UNION ALL
SELECT * FROM calcium_lab
UNION ALL
SELECT * FROM magnesium_lab
UNION ALL
SELECT * FROM hematocrit_lab
UNION ALL
SELECT * FROM potassium_lab
UNION ALL
SELECT * FROM protime_lab
UNION ALL
SELECT * FROM tprotein_lab
UNION ALL
SELECT * FROM lactic_lab
UNION ALL
SELECT * FROM albumin_lab
UNION ALL
SELECT * FROM platelet_lab
UNION ALL
SELECT * FROM whiteblood_lab
UNION ALL
SELECT * FROM bilirubin_lab
UNION ALL
SELECT * FROM alkPhos_lab
UNION ALL
SELECT * FROM neutrophils_lab
UNION ALL
--SELECT * FROM pulse_lab
--UNION ALL
--SELECT * FROM SpO2_lab
--UNION ALL
SELECT * FROM temp_lab
UNION ALL
--SELECT * FROM gcs_lab
--UNION ALL
--SELECT * FROM rassscore_lab
--UNION ALL
--SELECT * FROM resp_lab
--UNION ALL
--SELECT * FROM nudesc_lab
--UNION ALL
SELECT * FROM aniongap_lab
UNION ALL
SELECT * FROM blood_urea_nitrogen_lab
UNION ALL
SELECT * FROM alt_gpt_lab
UNION ALL
SELECT * FROM ast_got_lab
UNION ALL
SELECT * FROM inr_protime_lab
UNION ALL
SELECT * FROM arterial_ph_lab
UNION ALL
SELECT * FROM pco2_lab
UNION ALL
SELECT * FROM po2_lab
UNION ALL
SELECT * FROM oxygen_lab
UNION ALL
SELECT * FROM base_lab
UNION ALL
SELECT * FROM troponin_i_lab
UNION ALL
SELECT * FROM phosphorus_lab
--UNION ALL
--SELECT * FROM thromboplastin_lab
--UNION ALL
--SELECT * FROM FIO2_lab
--UNION ALL
--SELECT * FROM systolic_bp_lab
--UNION ALL
--SELECT * FROM diastolic_bp_lab	
) as x;

delete from allvalues_lab where value is NULL;
delete from allvalues_chart where value is NULL;