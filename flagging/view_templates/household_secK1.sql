SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    hh.country AS "Country",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    country.partner_institution AS "Partner Organization",
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    t.k_02_1,
    t.k_02_2,
    t.k_03_1,
    t.k_03_2,
    t.k_04,
    t.k_05_1,
    t.k_05_2,
    t.k_05a,
    t.k_06_1,
    t.k_06_2,
    t.k_item,
    t.k_item_code,
    t.k_item_other
   FROM ((("household_secK1" t
     JOIN household hh ON (((t.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))
