--Run this script to encrypt columns with people's names and then erase those columns
--CTRL-F to change PASSWORD to the appropriate word (Matt has it in his LastPass)

UPDATE "agric"
SET hh_first_name_cpt = pgp_sym_encrypt(hh_first_name, 'PASSWORD'),
hh_first_name=NULL
WHERE hh_first_name IS NOT NULL;

UPDATE "agric"
SET hh_last_name_cpt = pgp_sym_encrypt(hh_last_name, 'PASSWORD'),
hh_last_name=NULL
WHERE hh_last_name IS NOT NULL;

UPDATE "agric_field_details_labor"
SET hh_indid_name_cpt = pgp_sym_encrypt(hh_indid_name, 'PASSWORD'),
hh_indid_name=NULL
WHERE hh_indid_name IS NOT NULL;

UPDATE "agric_roster"
SET hh_indid_name_cpt = pgp_sym_encrypt(hh_indid_name, 'PASSWORD'),
hh_indid_name=NULL
WHERE hh_indid_name IS NOT NULL;

UPDATE "farmfieldsoils_yields_maize"
SET farmers_first_name_cpt = pgp_sym_encrypt(farmers_first_name, 'PASSWORD'),
farmers_first_name=NULL
WHERE farmers_first_name IS NOT NULL;

UPDATE "farmfieldsoils_yields_maize"
SET farmers_last_name_cpt = pgp_sym_encrypt(farmers_last_name, 'PASSWORD'),
farmers_last_name=NULL
WHERE farmers_last_name IS NOT NULL;

UPDATE "farmfieldsoils_yields_paddy_maize"
SET farmers_first_name_cpt = pgp_sym_encrypt(farmers_first_name, 'PASSWORD'),
farmers_first_name=NULL
WHERE farmers_first_name IS NOT NULL;

UPDATE "farmfieldsoils_yields_paddy_maize"
SET farmers_last_name_cpt = pgp_sym_encrypt(farmers_last_name, 'PASSWORD'),
farmers_last_name=NULL
WHERE farmers_last_name IS NOT NULL;

UPDATE "household"
SET hh_first_name_cpt = pgp_sym_encrypt(hh_first_name, 'PASSWORD'),
hh_first_name=NULL
WHERE hh_first_name IS NOT NULL;

UPDATE "household"
SET hh_last_name_cpt = pgp_sym_encrypt(hh_last_name, 'PASSWORD'),
hh_last_name=NULL
WHERE hh_last_name IS NOT NULL;

UPDATE "household_secV"
SET v1_2_a_name_cpt = pgp_sym_encrypt(v1_2_a_name, 'PASSWORD'),
v1_2_a_name=NULL
WHERE v1_2_a_name IS NOT NULL;

UPDATE "household_secV"
SET v1_2_b_name_cpt = pgp_sym_encrypt(v1_2_b_name, 'PASSWORD'),
v1_2_b_name=NULL
WHERE v1_2_b_name IS NOT NULL;

UPDATE "household_secV"
SET v1_2_c_name_cpt = pgp_sym_encrypt(v1_2_c_name, 'PASSWORD'),
v1_2_c_name=NULL
WHERE v1_2_c_name IS NOT NULL;

UPDATE "household_secV"
SET v1_2_a_phone_cpt = pgp_sym_encrypt(v1_2_a_phone, 'PASSWORD'),
v1_2_a_phone=NULL
WHERE v1_2_a_phone IS NOT NULL;

UPDATE "household_secV"
SET v1_2_b_phone_cpt = pgp_sym_encrypt(v1_2_b_phone, 'PASSWORD'),
v1_2_b_phone=NULL
WHERE v1_2_b_phone IS NOT NULL;

UPDATE "household_secV"
SET v1_2_c_phone_cpt = pgp_sym_encrypt(v1_2_c_phone, 'PASSWORD'),
v1_2_c_phone=NULL
WHERE v1_2_c_phone IS NOT NULL;

UPDATE "household_secV"
SET v1_3_a_cpt = pgp_sym_encrypt(v1_3_a, 'PASSWORD'),
v1_3_a=NULL
WHERE v1_3_a IS NOT NULL;

UPDATE "household_secV"
SET v1_4_a_cpt = pgp_sym_encrypt(v1_4_a, 'PASSWORD'),
v1_4_a=NULL
WHERE v1_4_a IS NOT NULL;

