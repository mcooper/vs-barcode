--hh secV
SELECT * FROM "household_secV" WHERE country='UGA' AND landscape_no='L07' and eplot_no = '014' and hh_no = '04'

--ffs
SELECT * FROM "farmfieldsoils" WHERE country='UGA' AND landscape_no='L03' and eplot_no = '004' and hh_no = '01'
SELECT * FROM "farmfieldsoils_field_elegibility" WHERE survey_uuid = '6fd3ab60-ae21-422a-b66e-3957ff2bb33c' OR survey_uuid = '2794b68c-0146-4db2-8bbf-7eb668c7e6ed';
SELECT * FROM "farmfieldsoils_soil_measurements" WHERE survey_uuid = '6fd3ab60-ae21-422a-b66e-3957ff2bb33c' OR survey_uuid = '2794b68c-0146-4db2-8bbf-7eb668c7e6ed';

--ffs lab
SELECT * FROM "farmfieldsoils_lab" WHERE country='UGA' AND landscape_no='L03' and eplot_no = '004' and hh_no = '01'
SELECT * FROM "farmfieldsoils_lab_weights" WHERE survey_uuid = '27a828ed-f9ec-4e3d-bccf-fc5c50a5c11e' OR survey_uuid = '83981426-23af-471b-b00c-31164e2b5e0c'

--ffs processed
SELECT * FROM "farmfieldsoils_processed" WHERE country='UGA' AND landscape_no='L03' and eplot_no = '004' and hh_no = '01'

--household
SELECT * FROM "household" WHERE country='UGA' AND landscape_no='L03' and eplot_no = '004' and hh_no = '01'
SELECT * FROM "household_secB" WHERE survey_uuid = '8b3dd0c7-4293-4042-829a-ccbdc323c6ee' OR survey_uuid = '79de3878-f0e1-4192-aab2-85941ef2942d'




--DELETING
BEGIN;
DELETE FROM "farmfieldsoils_lab_weights" WHERE survey_uuid = '27a828ed-f9ec-4e3d-bccf-fc5c50a5c11e';
DELETE FROM "farmfieldsoils_lab" WHERE survey_uuid = '27a828ed-f9ec-4e3d-bccf-fc5c50a5c11e';
COMMIT;

BEGIN;
DELETE FROM "farmfieldsoils_soil_measurements" WHERE survey_uuid = '6fd3ab60-ae21-422a-b66e-3957ff2bb33c';
DELETE FROM "farmfieldsoils_field_elegibility" WHERE survey_uuid = '6fd3ab60-ae21-422a-b66e-3957ff2bb33c';
DELETE FROM "farmfieldsoils" WHERE survey_uuid = '6fd3ab60-ae21-422a-b66e-3957ff2bb33c';
COMMIT;

BEGIN;
DELETE FROM "household_secU" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secC" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secE" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secHV1" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secB" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secHV2" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secI" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secJ1" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secJ2" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secK1" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secK2" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secL" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secM" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household_secN" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
DELETE FROM "household" WHERE survey_uuid = '7ab5f516-4d30-450f-bd81-33303c8bc190';
COMMIT;


