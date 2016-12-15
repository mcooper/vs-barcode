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
    t.field_id AS "Field ID",
    t.field_name AS "Field name",
    t.zaocode AS "Crop ID",
    t.crop_name AS "Crop name",
    t.ag6a_02,
    t.ag6a_05,
    t.ag6a_08_1,
    t.ag6a_08_2,
    t.ag6a_vs_09
   FROM (((agric_perm_crops_by_field t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))