SELECT t.uuid,
    t.survey_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    t.parent_uuid,
    hh_secb.ind AS "Individual ID",
    t.hh_e04,
    t.hh_e06,
    t.hh_e08,
    t.hh_e22_1,
    t.hh_e22_2,
    t.hh_e23,
    t.hh_e24_1,
    t.hh_e24_2,
    t.hh_e25,
    t.hh_e26,
    t.hh_e27,
    t.hh_e28,
    t.hh_e51,
    t.hh_e52,
    t.hh_e64_1,
    t.hh_e64_2,
    t.hh_e65_1,
    t.hh_e65_2
   FROM (((("household_secE" t
     JOIN "household_secB" hh_secb ON (((t.parent_uuid)::text = (hh_secb.uuid)::text)))
     JOIN household hh ON (((hh_secb.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))