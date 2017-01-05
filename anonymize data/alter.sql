--Run once just to alter the schema and add encryption columns

ALTER TABLE "agric" ADD COLUMN hh_first_name_cpt bytea;

ALTER TABLE "agric" ADD COLUMN hh_last_name_cpt bytea;

ALTER TABLE "agric_field_details_labor" ADD COLUMN hh_indid_name_cpt bytea;

ALTER TABLE "agric_roster" ADD COLUMN hh_indid_name_cpt bytea;

ALTER TABLE "farmfieldsoils_yields_maize" ADD COLUMN farmers_first_name_cpt bytea;

ALTER TABLE "farmfieldsoils_yields_maize" ADD COLUMN farmers_last_name_cpt bytea;

ALTER TABLE "farmfieldsoils_yields_paddy_maize" ADD COLUMN farmers_first_name_cpt bytea;

ALTER TABLE "farmfieldsoils_yields_paddy_maize" ADD COLUMN farmers_last_name_cpt bytea;

ALTER TABLE "household" ADD COLUMN hh_first_name_cpt bytea;

ALTER TABLE "household" ADD COLUMN hh_last_name_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_a_name_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_b_name_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_c_name_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_a_phone_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_b_phone_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_2_c_phone_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_3_a_cpt bytea;

ALTER TABLE "household_secV" ADD COLUMN v1_4_a_cpt bytea;

