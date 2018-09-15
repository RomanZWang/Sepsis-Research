-------------------------------------------------------------------------------
-- Identify antibiotic administration duration for each hadm_id
-- Author: Prabhat Rayapati
-- Contributor: Roman Wang
-- MIMIC version: MIMIC III v1.3
-- Description: Antibiotic administration is used to treat infections
-- in patients. Also, a combination of antibiotics and blood cultures
-- is a mark of suspected infection in patients. The prescriptions table
-- in mimic 3 contains information of drugs by name and the administration
-- startdate and enddate for each hadm_id. Each hadm_id has multiple antibiotic
-- drugs, with overlapping startdates and enddates.
-- so we want a table that identifies all the diff antibiotics a hadm_id recieved
-- and merge the overlapping durations of these antibiotics to get a periods of
-- antibiotic administrations.
-- This query produces a table called antib which contains
-- subject_id,hadm_id and the startdate and enddate of antibiotics
-- administration.
-------------------------------------------------------------------------------

--lets create duplicate of prescriptions table with only entries for the patients
-- in adultpatients_losg24 table

CREATE TABLE prescriptions_adult (LIKE prescriptions);
INSERT INTO prescriptions_adult
SELECT prescriptions.*
FROM prescriptions, adultpatients_losg24
WHERE prescriptions.hadm_id = adultpatients_losg24.hadm_id;

-- extract the records of the adult patients who got antibiotics
-- prescription into the table antibiotics_prescriptions
-- we match the name of antibiotics and pull out the antibiotic
-- records

CREATE TABLE antibiotics_prescriptions (LIKE prescriptions_adult);
INSERT INTO antibiotics_prescriptions
SELECT *
FROM prescriptions_adult
WHERE (lower(drug) like '%ampicillin-sulbactam%' or
	lower(drug) like '%amoxicillin-clavulanic%' or
	lower(drug) like '%amikacin%' or
	lower(drug) like '%augmentin suspension%' or
	lower(drug) like '%azithromycin%' or
	lower(drug) like '%aztreonam%' or
	lower(drug) like '%bactrim%' or
	lower(drug) like '%cefepime%' or
	lower(drug) like '%cefixime%' or
	lower(drug) like '%cefotaxime %' or
	lower(drug) like '%cefotetan%' or
	lower(drug) like '%cefoxitin%' or
	lower(drug) like '%cefpodoxime %' or
	lower(drug) like '%ceftazidime%' or
	lower(drug) like '%ceftriaxone%' or
	lower(drug) like '%cefuroxime%' or
	lower(drug) like '%ciprofloxacin%' or
	lower(drug) like '%clarithromycin%' or
	lower(drug) like '%clindamycin%' or
	lower(drug) like '%colistin%' or
	lower(drug) like '%daptomycin%' or
	lower(drug) like '%doxycycline %' or
	lower(drug) like '%ertapenem%' or
	lower(drug) like '%erythromycin%' or
	lower(drug) like '%gatifloxacin%' or
	lower(drug) like '%gentamicin%' or
	lower(drug) like '%imipenem%' or
	lower(drug) like '%levofloxacin%' or
	lower(drug) like '%linezolid%' or
	lower(drug) like '%meropenem%' or
	lower(drug) like '%metronidazole%' or
	lower(drug) like '%minocycline%' or
	lower(drug) like '%moxifloxacin%' or
	lower(drug) like '%piperacillin%' or
	lower(drug) like '%quinupristin%' or
	lower(drug) like '%synercid%' or
	lower(drug) like '%tetracycline%' or
	lower(drug) like '%tigecycline%' or
	lower(drug) like '%timentin%' or
	lower(drug) like '%tobramycin%' or
	lower(drug) like '%trimethoprim%' or
	lower(drug) like '%unasyn%' or
	lower(drug) like '%vancomycin%' or
	lower(drug) like '%abacavir%' or
	lower(drug) like '%lamivudine%' or
	lower(drug) like '%zidovudine%' or
	lower(drug) like '%acyclovir%' or
	lower(drug) like '%amikacin%' or
	lower(drug) like '%amoxicillin%' or
	lower(drug) like '%amoxicillin-pot%' or
	lower(drug) like '%amphotericin%' or
	lower(drug) like '%ampicillin%' or
	lower(drug) like '%ampicillin%' or
	lower(drug) like '%sulbactam%' or
	lower(drug) like '%atazanavir%' or
	lower(drug) like '%atovaquone%' or
	lower(drug) like '%atovaquone%' or
	lower(drug) like '%proguanil%' or
	lower(drug) like '%azithromycin%' or
	lower(drug) like '%aztreonam%' or
	lower(drug) like '%chloroquine%' or
	lower(drug) like '%ciprofloxacin%' or
	lower(drug) like '%ciprofloxacin%' or
	lower(drug) like '%ciproflox%' or
	lower(drug) like '%clarithromycin%' or
	lower(drug) like '%clindamycin%' or
	lower(drug) like '%dapsone%' or
	lower(drug) like '%daptomycin%' or
	lower(drug) like '%darunavir%' or
	lower(drug) like '%dicloxacillin%' or
	lower(drug) like '%doxycycline%' or
	lower(drug) like '%doxycycline-eyelid%' or
	lower(drug) like '%doxycycline-multivit/minerals%' or
	lower(drug) like '%doxycycline-suncreen-sal%' or
	lower(drug) like '%emtricitabine-tenofovir%' or
	lower(drug) like '%erythromycin%' or
	lower(drug) like '%erythromycin-sulfisoxazole%' or
	lower(drug) like '%ethambutol%' or
	lower(drug) like '%etravirine%' or
	lower(drug) like '%fluconazole%' or
	lower(drug) like '%fosfomycin%' or
	lower(drug) like '%gentamicin%' or
	lower(drug) like '%hepatitis b immune globulin%' or
	lower(drug) like '%hydroxychloroquine%' or
	lower(drug) like '%immune globulin%' or
	lower(drug) like '%isoniazid%' or
	lower(drug) like '%isoniazid-rifampin%' or
	lower(drug) like '%isoniazid-rifamp-pyrazinamide%' or
	lower(drug) like '%itraconazole%' or
	lower(drug) like '%ketoconazole%' or
	lower(drug) like '%lamivudine-zidovudine%' or
	lower(drug) like '%ledipasvir%' or
	lower(drug) like '%ledipasvir-sofosbuvir%' or
	lower(drug) like '%linezolid%' or
	lower(drug) like '%metronidazole%' or
	lower(drug) like '%minocycline%' or
	lower(drug) like '%moxifloxacin%' or
	lower(drug) like '%nafcillin%' or
	lower(drug) like '%neomycin%' or
	lower(drug) like '%neomycin-polymyxin%' or
	lower(drug) like '%nitrofurantoin%' or
	lower(drug) like '%nystatin%' or
	lower(drug) like '%nystatin-hydrocort-zinc%' or
	lower(drug) like '%oseltamivir%' or
	lower(drug) like '%palivizumab%' or
	lower(drug) like '%penicillin%' or
	lower(drug) like '%pentamidine%' or
	lower(drug) like '%piperacillin-tazobactam%' or
	lower(drug) like '%posaconazole%' or
	lower(drug) like '%pyrimethamine%' or
	lower(drug) like '%rabies immune globulin%' or
	lower(drug) like '%raltegravir%' or
	lower(drug) like '%ribavirin%' or
	lower(drug) like '%ribavirin-interferon%' or
	lower(drug) like '%rifampin%' or
	lower(drug) like '%rifaximin%' or
	lower(drug) like '%ritonavir%' or
	lower(drug) like '%sulfamethoxazole%' or
	lower(drug) like '%trimethoprim%' or
	lower(drug) like '%tenofovir%');

-- SANITY CHECK: Just to make sure that only distinct records exist in the antibiotics_prescriptions table, lets
-- insert distinct records into antibiotics_prescriptions_table

DROP TABLE IF EXISTS antibiotics_prescriptions_table ;
CREATE TABLE antibiotics_prescriptions_table (LIKE antibiotics_prescriptions);
INSERT INTO antibiotics_prescriptions_table
SELECT DISTINCT *
FROM antibiotics_prescriptions;

-- lets create a table called anti_table which only contains
-- subject_id, hadm_id, startdate, end date from antibiotics_prescriptions_table

DROP TABLE IF EXISTS anti_table;
CREATE TABLE anti_table(
subject_id int,
hadm_id int,
startdate timestamp(0),

enddate timestamp(0));

WITH CTE AS (
SELECT subject_id,hadm_id,startdate,enddate+interval '1' day as enddate
FROM antibiotics_prescriptions_table)
INSERT INTO anti_table
SELECT DISTINCT *
FROM CTE
ORDER BY hadm_id, startdate, enddate;

UPDATE anti_table
SET enddate=startdate + interval '1' day
WHERE enddate ISNULL;

-- we create a table antib which merges the over lapping antibiotics
-- administration periods

DROP TABLE IF EXISTS antib;
CREATE TABLE antib (LIKE anti_table);

INSERT INTO antib
SELECT
	    s1.subject_id,
		s1.hadm_id,
        s1.startdate,
        MIN(t1.enddate) AS enddate
FROM anti_table s1
INNER JOIN anti_table t1 ON s1.startdate <= t1.enddate AND s1.hadm_id=t1.hadm_id
AND NOT EXISTS(
	SELECT * FROM anti_table t2
    WHERE t1.enddate >= t2.startdate
    AND t1.enddate < t2.enddate AND t1.hadm_id=t2.hadm_id)
WHERE NOT EXISTS(
	SELECT * FROM anti_table s2
    WHERE s1.startdate > s2.startdate
    AND s1.startdate <= s2.enddate AND s1.hadm_id=s2.hadm_id)
GROUP BY s1.startdate,s1.hadm_id,s1.subject_id
ORDER BY s1.StartDate;
