--Run this script to fill the pii columns with the appropriate info,
--using CTRL-F to replace PASSWORD with the appropriate word (Matt has it in his LastPass)

UPDATE "agric"
SET hh_first_name = pgp_sym_decrypt(hh_first_name_cpt, 'PASSWORD'),
hh_first_name_cpt=NULL
WHERE hh_first_name_cpt IS NOT NULL;

UPDATE "agric"
SET hh_last_name = pgp_sym_decrypt(hh_last_name_cpt, 'PASSWORD'),
hh_last_name_cpt=NULL
WHERE hh_last_name_cpt IS NOT NULL;

UPDATE "agric_field_details_labor"
SET hh_indid_name = pgp_sym_decrypt(hh_indid_name_cpt, 'PASSWORD'),
hh_indid_name_cpt=NULL
WHERE hh_indid_name_cpt IS NOT NULL;

UPDATE "agric_roster"
SET hh_indid_name = pgp_sym_decrypt(hh_indid_name_cpt, 'PASSWORD'),
hh_indid_name_cpt=NULL
WHERE hh_indid_name_cpt IS NOT NULL;

UPDATE "farmfieldsoils_yields_maize"
SET farmers_first_name = pgp_sym_decrypt(farmers_first_name_cpt, 'PASSWORD'),
farmers_first_name_cpt=NULL
WHERE farmers_first_name_cpt IS NOT NULL;

UPDATE "farmfieldsoils_yields_maize"
SET farmers_last_name = pgp_sym_decrypt(farmers_last_name_cpt, 'PASSWORD'),
farmers_last_name_cpt=NULL
WHERE farmers_last_name_cpt IS NOT NULL;

UPDATE "farmfieldsoils_yields_paddy_maize"
SET farmers_first_name = pgp_sym_decrypt(farmers_first_name_cpt, 'PASSWORD'),
farmers_first_name_cpt=NULL
WHERE farmers_first_name_cpt IS NOT NULL;

UPDATE "farmfieldsoils_yields_paddy_maize"
SET farmers_last_name = pgp_sym_decrypt(farmers_last_name_cpt, 'PASSWORD'),
farmers_last_name_cpt=NULL
WHERE farmers_last_name_cpt IS NOT NULL;

UPDATE "household"
SET hh_first_name = pgp_sym_decrypt(hh_first_name_cpt, 'PASSWORD'),
hh_first_name_cpt=NULL
WHERE hh_first_name_cpt IS NOT NULL;

UPDATE "household"
SET hh_last_name = pgp_sym_decrypt(hh_last_name_cpt, 'PASSWORD'),
hh_last_name_cpt=NULL
WHERE hh_last_name_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_a_name = pgp_sym_decrypt(v1_2_a_name_cpt, 'PASSWORD'),
v1_2_a_name_cpt=NULL
WHERE v1_2_a_name_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_b_name = pgp_sym_decrypt(v1_2_b_name_cpt, 'PASSWORD'),
v1_2_b_name_cpt=NULL
WHERE v1_2_b_name_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_c_name = pgp_sym_decrypt(v1_2_c_name_cpt, 'PASSWORD'),
v1_2_c_name_cpt=NULL
WHERE v1_2_c_name_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_a_phone = pgp_sym_decrypt(v1_2_a_phone_cpt, 'PASSWORD'),
v1_2_a_phone_cpt=NULL
WHERE v1_2_a_phone_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_b_phone = pgp_sym_decrypt(v1_2_b_phone_cpt, 'PASSWORD'),
v1_2_b_phone_cpt=NULL
WHERE v1_2_b_phone_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_2_c_phone = pgp_sym_decrypt(v1_2_c_phone_cpt, 'PASSWORD'),
v1_2_c_phone_cpt=NULL
WHERE v1_2_c_phone_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_3_a = pgp_sym_decrypt(v1_3_a_cpt, 'PASSWORD'),
v1_3_a_cpt=NULL
WHERE v1_3_a_cpt IS NOT NULL;

UPDATE "household_secV"
SET v1_4_a = pgp_sym_decrypt(v1_4_a_cpt, 'PASSWORD'),
v1_4_a_cpt=NULL
WHERE v1_4_a_cpt IS NOT NULL;

