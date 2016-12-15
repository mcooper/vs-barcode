SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    agric.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    agric.landscape_no AS "Landscape #",
    agric.hh_refno AS "Household ID",
    agric.data_entry_date AS "Data entry date",
    t.zaocode AS "Crop ID",
    t.is_processed AS "Is Processed",
    t.is_byproduct AS "Is Byproduct",
    t.ag09_02_1,
    t.ag09_03,
    t.ag09_03_other,
    t.ag09_03_by,
    t.ag09_03_by_other,
    t.ag09_03_product_name,
    t.ag09_04_1,
    t.ag09_04_2,
    t.ag09_07,
    t.ag09_07_2,
    t.ag09_05,
    t.ag09_06_1,
    t.ag09_06_2,
    t.ag09_08,
    t.ag09_vs_8a,
    t.ag09_vs_8b_1,
    t.ag09_vs_8b_2,
    t.ag09_10,
    t.ag09_11
   FROM (((agric_byprod t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))