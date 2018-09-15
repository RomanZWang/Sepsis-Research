-------------------------------------------------------------------------
-- Dropping all the intermediate/unnecessary tables
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version: MIMIC III v1.3
-- Descriptions: We created a lot of tables in the middle to get to the following tables
-- adult patients table called adultpatients,
-- adult patients with hospital stay greater than 24 hours called adultpatients_log24,
-- suspected infections table called antib_blood,
-- continous sofa calculation table called sofa,
-- sepsis table
-----------------------------------------------------------------------
-- Dropping intermediate tables

DROP TABLE icustays_1;
DROP TABLE icustays_2;
DROP TABLE admissions_1;

DROP TABLE prescriptions_adult;
DROP TABLE antibiotics_prescriptions;
DROP TABLE antibiotics_prescriptions_table;
DROP TABLE anti_table;
DROP TABLE antib;

--DROP TABLE microbology_adult_admissions;
DROP TABLE blood_culture_mv;
DROP TABLE blood_culture_events;
DROP TABLE blood_culture_chart;
DROP TABLE procedureevents_mv_adult_admissions;
DROP TABLE blood_cul_proceduremv;
DROP TABLE blood_culture_labevents;
DROP TABLE blood;

DROP TABLE chartevents_adult_gcs;

DROP TABLE chartevents_adult_admissions;

DROP TABLE labevents_liver;

DROP TABLE labevents_adult_admissions;

DROP TABLE labevents_platelets;

DROP TABLE labevents_creatinine;
DROP TABLE outputevents_urine;

DROP TABLE chartevents_adult_map;
DROP TABLE inputevents_dopamine;
DROP TABLE inputevents_mv_dopamine;
DROP TABLE chartevents_adult_epinephrine;
DROP TABLE inputevents_epinephrine;
DROP TABLE inputevents_mv_epinephrine;
DROP TABLE inputevents_norepinephrine;
DROP TABLE inputevents_mv_norepinephrine;
DROP TABLE prescription_adult_dobutamine;

DROP TABLE inputevents_dobutamine;
DROP TABLE inputevents_mv_dobutamine;

DROP MATERIALIZED VIEW ventdurations;
DROP TABLE ventidurations;
DROP TABLE labevents_fio2;
DROP TABLE chartevents_adult_fio2;
DROP TABLE fio2;
DROP TABLE fio2_final;
DROP TABLE fio2_event;
DROP TABLE po2;
DROP TABLE po2_final;
DROP TABLE po2_event;
DROP TABLE pafi;
DROP TABLE pafi_ratio;
DROP TABLE pafio2_ratio;
DROP TABLE pf_ratio;

DROP TABLE sofa_calc;
DROP TABLE sofa_table;
DROP TABLE sofa1;
DROP TABLE sofa_all;

DROP TABLE sofa_delta;
