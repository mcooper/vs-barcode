--agric
CREATE TABLE agric_piiname
(uuid text PRIMARY KEY,
ag_head_name text,
ag_head_name_cpt bytea,
FOREIGN KEY(uuid) REFERENCES agric(uuid));

INSERT INTO agric_piiname
(SELECT uuid, ag_head_name, ag_head_name_cpt
FROM agric);

ALTER TABLE agric
DROP COLUMN ag_head_name CASCADE,
DROP COLUMN ag_head_name_cpt CASCADE;

CREATE TABLE agric_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES agric(uuid));

INSERT INTO agric_piigeo
(SELECT uuid, eplot_no, hh_no
FROM agric);

ALTER TABLE agric
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--agric_field
CREATE TABLE agric_field_piigeo
(uuid text PRIMARY KEY,
field_name text,
gps_lat numeric,
gps_lat_cpt bytea,
gps_long numeric,
gps_long_cpt bytea,
FOREIGN KEY(uuid) REFERENCES agric_field(uuid));

INSERT INTO agric_field_piigeo
(SELECT uuid, field_name, gps_lat, gps_lat_cpt, gps_long, gps_long_cpt
FROM agric_field);

ALTER TABLE agric_field
DROP COLUMN field_name CASCADE,
DROP COLUMN gps_lat CASCADE,
DROP COLUMN gps_lat_cpt CASCADE,
DROP COLUMN gps_long CASCADE,
DROP COLUMN gps_long_cpt CASCADE;

--agric_field_season_individual
CREATE TABLE agric_field_season_individual_piiname
(uuid text PRIMARY KEY,
ag_indid_name text,
ag_indid_name_cpt bytea,
FOREIGN KEY(uuid) REFERENCES agric_field_season_individual(uuid));

INSERT INTO agric_field_season_individual_piiname
(SELECT uuid, ag_indid_name, ag_indid_name_cpt
FROM agric_field_season_individual);

ALTER TABLE agric_field_season_individual
DROP COLUMN ag_indid_name CASCADE,
DROP COLUMN ag_indid_name_cpt CASCADE;

--household
CREATE TABLE household_piiname
(uuid text PRIMARY KEY,
hh_head_name text,
hh_head_name_cpt bytea,
FOREIGN KEY(uuid) REFERENCES household(uuid));

INSERT INTO household_piiname
(SELECT uuid, hh_head_name, hh_head_name_cpt
FROM household);

ALTER TABLE household
DROP COLUMN hh_head_name CASCADE,
DROP COLUMN hh_head_name_cpt CASCADE;

CREATE TABLE household_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES household(uuid));

INSERT INTO household_piigeo
(SELECT uuid, eplot_no, hh_no
FROM household);

ALTER TABLE household
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--household_individual
CREATE TABLE household_individual_piiname
(uuid text PRIMARY KEY,
hh_indid text,
hh_indid_cpt bytea,
FOREIGN KEY(uuid) REFERENCES household_individual(uuid));

INSERT INTO household_individual_piiname
(SELECT uuid, hh_indid, hh_indid_cpt
FROM household_individual);

ALTER TABLE household_individual
DROP COLUMN hh_indid CASCADE,
DROP COLUMN hh_indid_cpt CASCADE;

--processedsoils_farm
CREATE TABLE processedsoils_farm_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES processedsoils_farm(uuid));

INSERT INTO processedsoils_farm_piigeo
(SELECT uuid, eplot_no, hh_no
FROM processedsoils_farm);

ALTER TABLE processedsoils_farm
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--yields
CREATE TABLE yields_piiname
(uuid text PRIMARY KEY,
yield_head_name text,
yield_head_name_cpt bytea,
FOREIGN KEY(uuid) REFERENCES yields(uuid));

INSERT INTO yields_piiname
(SELECT uuid, yield_head_name, yield_head_name_cpt
FROM yields);

ALTER TABLE yields
DROP COLUMN yield_head_name CASCADE,
DROP COLUMN yield_head_name_cpt CASCADE;

CREATE TABLE yields_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES yields(uuid));

INSERT INTO yields_piigeo
(SELECT uuid, eplot_no, hh_no
FROM yields);

ALTER TABLE yields
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--yields_field
CREATE TABLE yields_field_piigeo
(uuid text PRIMARY KEY,
field_name text,
gpsne_lat numeric,
gpsne_lat_cpt bytea,
gpsne_long numeric,
gpsne_long_cpt bytea,
FOREIGN KEY(uuid) REFERENCES yields_field(uuid));

INSERT INTO yields_field_piigeo
(SELECT uuid, field_name, gpsne_lat, gpsne_lat_cpt, gpsne_long, gpsne_long_cpt
FROM yields_field);

ALTER TABLE yields_field
DROP COLUMN field_name CASCADE,
DROP COLUMN gpsne_lat CASCADE,
DROP COLUMN gpsne_lat_cpt CASCADE,
DROP COLUMN gpsne_long CASCADE,
DROP COLUMN gpsne_long_cpt CASCADE;

--yieldslab
CREATE TABLE yieldslab_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES yieldslab(uuid));

INSERT INTO yieldslab_piigeo
(SELECT uuid, eplot_no, hh_no
FROM yieldslab);

ALTER TABLE yieldslab
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--agric_individual
CREATE TABLE agric_individual_piiname
(uuid text PRIMARY KEY,
ag_indid_name text,
ag_indid_name_cpt bytea,
FOREIGN KEY(uuid) REFERENCES agric_individual(uuid));

INSERT INTO agric_individual_piiname
(SELECT uuid, ag_indid_name, ag_indid_name_cpt
FROM agric_individual);

ALTER TABLE agric_individual
DROP COLUMN ag_indid_name CASCADE,
DROP COLUMN ag_indid_name_cpt CASCADE;

--farmsoilslab
CREATE TABLE farmsoilslab_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES farmsoilslab(uuid));

INSERT INTO farmsoilslab_piigeo
(SELECT uuid, eplot_no, hh_no
FROM farmsoilslab);

ALTER TABLE farmsoilslab
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;

--farmsoils
CREATE TABLE farmsoils_piigeo
(uuid text PRIMARY KEY,
eplot_no text,
hh_no text,
FOREIGN KEY(uuid) REFERENCES farmsoils(uuid));

INSERT INTO farmsoils_piigeo
(SELECT uuid, eplot_no, hh_no
FROM farmsoils);

ALTER TABLE farmsoils
DROP COLUMN eplot_no CASCADE,
DROP COLUMN hh_no CASCADE;
