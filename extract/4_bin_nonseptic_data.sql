DROP TABLE nonsepsis_train_data;
CREATE TABLE nonsepsis_train_data (
subject_id INT,
hadm_id INT,
admittime TIMESTAMP(0),
icu_intime TIMESTAMP(0),
time TIMESTAMP(0),
v1 DOUBLE PRECISION,
v2 DOUBLE PRECISION,
v3 DOUBLE PRECISION,
v4 DOUBLE PRECISION,
v5 DOUBLE PRECISION,
v6 DOUBLE PRECISION,
v7 DOUBLE PRECISION,
v8 DOUBLE PRECISION,
v9 DOUBLE PRECISION,
v10 DOUBLE PRECISION,
v11 DOUBLE PRECISION,
v12 DOUBLE PRECISION,
v13 DOUBLE PRECISION,
v14 DOUBLE PRECISION,
v15 DOUBLE PRECISION,
v16 DOUBLE PRECISION,
v17 DOUBLE PRECISION,
v18 DOUBLE PRECISION,
v19 DOUBLE PRECISION,
v20 DOUBLE PRECISION,
v21 DOUBLE PRECISION,
v22 DOUBLE PRECISION,
v23 DOUBLE PRECISION,
v24 DOUBLE PRECISION,
v25 DOUBLE PRECISION,
v26 DOUBLE PRECISION,
v27 DOUBLE PRECISION,
v28 DOUBLE PRECISION,
v29 DOUBLE PRECISION,
v30 DOUBLE PRECISION,
v31 DOUBLE PRECISION,
v32 DOUBLE PRECISION,
v33 DOUBLE PRECISION,
v34 DOUBLE PRECISION,
v35 DOUBLE PRECISION,
v36 DOUBLE PRECISION,
v37 DOUBLE PRECISION,
v38 DOUBLE PRECISION,
v39 DOUBLE PRECISION,
v40 DOUBLE PRECISION,
v41 DOUBLE PRECISION,
v42 DOUBLE PRECISION,
v43 DOUBLE PRECISION
);
 
-- index this table 

INSERT INTO nonsepsis_train_data
SELECT * FROM nonsepsis_pop;

DROP INDEX IF EXISTS nonsepsis_train_data_idx01;
CREATE INDEX nonsepsis_train_data_idx01
ON nonsepsis_train_data (hadm_id);

drop function gen_time_nonsepsis(character varying, character varying);
CREATE OR REPLACE FUNCTION gen_time_nonsepsis(update_table_name VARCHAR(40), data_table_name VARCHAR(40)) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET time=(COALESCE(time,(SELECT charttime FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id ORDER BY RANDOM() LIMIT 1)))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;

drop function update_features_nonsepsis(character varying, character varying,character varying,integer);
CREATE OR REPLACE FUNCTION update_features_nonsepsis(column_number integer,update_table_name VARCHAR(40),data_table_name VARCHAR(40),int1 integer) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET v'||column_number||'=(COALESCE(v'||column_number||',(SELECT value FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND  t2.charttime<=(t1.time + interval '''||int1||' hours'') AND (t1.time - interval '''||int1||' hours'') <= t2.charttime AND t2.sepsis_lab_id='||column_number|| 'ORDER BY ABS((EXTRACT(DAY FROM t2.charttime-t1.time))*24*60 + (EXTRACT(HOUR FROM t2.charttime-t1.time))*60 + (EXTRACT(MINUTE FROM t2.charttime-t1.time))) LIMIT 1)))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;

drop function update_features_full_carry_nonsepsis(character varying, character varying,character varying,integer);
CREATE OR REPLACE FUNCTION update_features_nonsepsis(column_number integer,update_table_name VARCHAR(40),data_table_name VARCHAR(40),int1 integer) RETURNS void AS $ret$
BEGIN
    EXECUTE 
    'UPDATE '||update_table_name||' AS t1 SET v'||column_number||'=(COALESCE(v'||column_number||',(SELECT value FROM '||data_table_name||
' AS t2 WHERE t1.hadm_id=t2.hadm_id AND  t2.charttime<=(t1.time + interval '''||int1||' hours'') AND (t1.time - interval '''||int1||' hours'') <= t2.charttime AND t2.sepsis_lab_id='||column_number|| 'ORDER BY ABS((EXTRACT(DAY FROM t2.charttime-t1.time))*24*60 + (EXTRACT(HOUR FROM t2.charttime-t1.time))*60 + (EXTRACT(MINUTE FROM t2.charttime-t1.time))) LIMIT 1)))'
    ;
    RETURN;
END;
$ret$ LANGUAGE plpgsql;


select gen_time_nonsepsis('nonsepsis_train_data','allValues_lab');
select gen_time_nonsepsis('nonsepsis_train_data','allValues_chart');

DO
$do$
BEGIN 
FOR i IN 1..43 LOOP
    --perform (select update_features_nonsepsis(i,'allValues_lab',24));
   -- perform (select update_features_nonsepsis(i,'allValues_chart',24));
    perform (select update_features_nonsepsis(i,'nonsepsis_train_data','allValues_lab',48));
    perform (select update_features_nonsepsis(i,'nonsepsis_train_data','allValues_chart',48));
    RAISE NOTICE '% -th feature complete', i;
END LOOP;
END
$do$;

ALTER TABLE nonsepsis_train_data
ADD sepsis_identifier int;
 
UPDATE nonsepsis_train_data
SET sepsis_identifier = 0;
 
\copy nonsepsis_train_data to 'C:/slmodelbuild/nonsepsis_iv.csv' csv header;