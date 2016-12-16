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
    t.season AS "Season",
    t.zaocode AS "Crop ID",
    t.crop_name AS "Crop name",
    t.ag5a_01,
    t.ag5a_02_1,
    t.ag5a_02_2,
    t.ag5a_03,
    t.ag5a_12_1,
    t.ag5a_20,
    t.ag5a_21,
    t.ag5a_21_other,
    t.ag5a_22,
    t.ag5a_24,
    t.ag5a_24_other,
    t.ag5a_25,
    t.ag5a_26
   FROM (((agric_crops_by_hh t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))