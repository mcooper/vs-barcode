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
    t.crop_type AS "Crop type",
    t.zaocode AS "Crop ID",
    t.crop_name AS "Crop name",
    t.ag7a_02,
    t.ag7a_03_1,
    t.ag7a_03_2,
    t.ag7a_04
   FROM (((agric_perm_crop t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))
