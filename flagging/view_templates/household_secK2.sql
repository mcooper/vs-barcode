)
 SELECT t.uuid,
    t.survey_uuid,
    t.parent_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    t.k2_8_a,
    t.k2_8_b,
    t.k2_8_c,
    t.k2_8_d,
    t.k2_8_e,
    t.k2_8_f,
    t.k2_8_g,
    t.k2_8_h,
    t.k2_8_i,
    t.k2_8_j,
    t.k2_9,
    t.k2_10_a,
    t.k2_11_a,
    t.k2_10_b,
    t.k2_11_b,
    t.k2_10_c,
    t.k2_11_c,
    t.k2_10_d,
    t.k2_11_d
   FROM ((("household_secK2" t
     JOIN household hh ON (((t.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))