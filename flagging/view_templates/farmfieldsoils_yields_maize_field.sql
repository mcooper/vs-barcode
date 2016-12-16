SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    mz.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    mz.landscape_no AS "Landscape #",
    mz.hh_refno AS "Household ID",
    mz.data_collection_date AS "Data Collection Date",
    t.field_no AS "Field ID",
    t.field_name AS "Field Name",
    t.a_1,
    t.a_2,
    t.a_3,
    t.a_5,
    t.a_6
   FROM (((farmfieldsoils_yields_maize_field t
     JOIN farmfieldsoils_yields_maize mz ON (((mz.uuid)::text = (t.parent_uuid)::text)))
     JOIN country ON (((country.country)::text = (mz.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (mz.country)::text) AND (landscape.landscape_no = mz.landscape_no))))
