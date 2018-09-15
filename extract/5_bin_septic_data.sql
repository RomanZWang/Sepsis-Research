DROP INDEX IF EXISTS allValues_chart_idx01;
CREATE INDEX allValues_chart_idx01
    ON allValues_chart (hadm_id);
 
DROP INDEX IF EXISTS allValues_chart_idx02;
CREATE INDEX allValues_chart_idx02
    ON allValues_chart (sepsis_lab_id);
    
DROP INDEX IF EXISTS allValues_lab_idx01;
CREATE INDEX allValues_lab_idx01
    ON allValues_lab (hadm_id);
 
DROP INDEX IF EXISTS allValues_lab_idx02;
CREATE INDEX allValues_lab_idx02
    ON allValues_lab (sepsis_lab_id);    

DROP TABLE sepsis_train_data;
CREATE TABLE sepsis_train_data (
subject_id INT,
hadm_id INT,
admittime TIMESTAMP(0),
icu_intime TIMESTAMP(0),
sepsis_time TIMESTAMP(0),
time TIMESTAMP(0),
fmt TIMESTAMP(0),
v1 double precision,
v2 double precision,
v3 double precision,
v4 double precision,
v5 double precision,
v6 double precision,
v7 double precision,
v8 double precision,
v9 double precision,
v10 double precision,
v11 double precision,
v12 double precision,
v13 double precision,
v14 double precision,
v15 double precision,
v16 double precision,
v17 double precision,
v18 double precision,
v19 double precision,
v20 double precision,
v21 double precision,
v22 double precision,
v23 double precision,
v24 double precision,
v25 double precision,
v26 double precision,
v27 double precision,
v28 double precision,
v29 double precision,
v30 double precision,
v31 double precision,
v32 double precision,
v33 double precision,
v34 double precision,
v35 double precision,
v36 double precision,
v37 double precision,
v38 double precision,
v39 double precision,
v40 double precision,
v41 double precision,
v42 double precision,
v43 double precision
);
 
INSERT INTO sepsis_train_data
SELECT subject_id, hadm_id, sepsis_time,admittime, icu_intime FROM sepsis_pop;

DROP INDEX IF EXISTS sepsis_train_data_idx01;
CREATE INDEX sepsis_train_data_idx01
    ON sepsis_train_data (hadm_id);

--lab update

drop function gen_time_sepsis(character varying, integer, integer);
CREATE OR REPLACE FUNCTION gen_time_sepsis(update_table_name VARCHAR(40),data_table_name VARCHAR(40),int1 integer, int2 integer) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET time=(COALESCE(time,(SELECT charttime FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND  t2.charttime<=(t1.sepsis_time - interval '''||int2||' hours'') AND (t1.sepsis_time - interval '''||int1||' hours'') <= t2.charttime ORDER BY RANDOM() LIMIT 1)))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;



drop function update_features_sepsis(integer, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION update_features_sepsis(column_number integer,update_table_name VARCHAR(40),data_table_name VARCHAR(40),int1 integer, int2 integer) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET v'||column_number||'=(COALESCE(v'||column_number||',(SELECT value FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND  t2.charttime<=(t1.sepsis_time - interval '''||int2||' hours'') AND (t1.sepsis_time - interval '''||int1||' hours'') <= t2.charttime AND t2.sepsis_lab_id='||column_number|| 'ORDER BY ABS((EXTRACT(DAY FROM t2.charttime-t1.time))*24*60 + (EXTRACT(HOUR FROM t2.charttime-t1.time))*60 + (EXTRACT(MINUTE FROM t2.charttime-t1.time))) LIMIT 1))),fmt=LEAST(fmt,(select charttime from '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND  t2.charttime<=(t1.sepsis_time - interval '''||int2||' hours'') AND (t1.sepsis_time - interval '''||int1||' hours'') <= t2.charttime AND t2.sepsis_lab_id='||column_number|| 'ORDER BY ABS((EXTRACT(DAY FROM t2.charttime-t1.time))*24*60 + (EXTRACT(HOUR FROM t2.charttime-t1.time))*60 + (EXTRACT(MINUTE FROM t2.charttime-t1.time))) LIMIT 1))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;

drop function update_features_carry_full_sepsis(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION update_features_carry_full_sepsis(column_number integer,update_table_name VARCHAR(40),data_table_name VARCHAR(40)) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET v'||column_number||'=(COALESCE(v'||column_number||',(SELECT value FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND t2.sepsis_lab_id='||column_number|| ' AND t2.charttime<=(t1.fmt + interval ''24  hours'')AND t2.charttime>=(t1.fmt) ORDER BY ABS((EXTRACT(DAY FROM t2.charttime-t1.time))*24*60 + (EXTRACT(HOUR FROM t2.charttime-t1.time))*60 + (EXTRACT(MINUTE FROM t2.charttime-t1.time))) LIMIT 1)))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;

select gen_time_sepsis('sepsis_train_data','allValues_lab',48,6);
select gen_time_sepsis('sepsis_train_data','allValues_chart',48,6);

DO
$do$
BEGIN 
FOR i IN 1..43 LOOP
    perform (select update_features_sepsis(i,'sepsis_train_data','allValues_lab',48,6));
    perform (select update_features_sepsis(i,'sepsis_train_data','allValues_chart',48,6));
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_lab',96,6));
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_chart',96,6));
    RAISE NOTICE '% -th feature complete', i;
END LOOP;
END
$do$;

\copy sepsis_train_data to 'C:/slmodelbuild/sepsis_before_carry.csv' csv header;

DO
$do$
BEGIN 
FOR i IN 1..43 LOOP
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_lab',48,6));
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_chart',48,6));
    perform (select update_features_sepsis(i,'sepsis_train_data','allValues_lab',72,6));
    perform (select update_features_sepsis(i,'sepsis_train_data','allValues_chart',72,6));
    RAISE NOTICE '% -th feature complete', i;
END LOOP;
END
$do$;
\copy sepsis_train_data to 'C:/slmodelbuild/sepsis_after_carry.csv' csv header;

DO
$do$
BEGIN 
FOR i IN 1..43 LOOP
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_lab',48,6));
    --perform (select update_features_sepsis(i,'sepsis_train_data','allValues_chart',48,6));
    perform (select update_features_carry_full_sepsis(i,'sepsis_train_data','allValues_lab'));
    perform (select update_features_carry_full_sepsis(i,'sepsis_train_data','allValues_chart'));
    RAISE NOTICE '% -th feature complete', i;
END LOOP;
END
$do$;
\copy sepsis_train_data to 'C:/slmodelbuild/sepsis_after_carry_full.csv' csv header;


ALTER TABLE sepsis_train_data
ADD sepsis_identifier int;
 
UPDATE sepsis_train_data
SET sepsis_identifier = 1;

DELETE FROM sepsis_train_data where time is NULL;


ALTER TABLE sepsis_train_data
ADD sex VARCHAR(255);

UPDATE sepsis_train_data as t
SET sex = (SELECT gender from patients as p
where t.subject_id=p.subject_id
limit 1
);

ALTER TABLE sepsis_train_data
ADD age int;

UPDATE sepsis_train_data as t
SET age = (SELECT age from icustays_2 as i
where t.hadm_id=i.hadm_id
limit 1
);



ALTER TABLE sepsis_train_data
ADD dbsource varchar(10);

UPDATE sepsis_train_data as t
SET dbsource = (SELECT dbsource from adultpatients_losg24 as i
where t.hadm_id=i.hadm_id
limit 1
);

ALTER TABLE sepsis_train_data
ADD sepsis_identifier int;
 
UPDATE sepsis_train_data
SET sepsis_identifier = 1;
