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
    t.source_id,
    t.source_name,
    t.sourceid,
    t.ag12a_02_1,
    t.ag12a_02_2,
    t.ag12a_02_3,
    t.ag12a_02_4,
    t.ag12a_02_5,
    t.ag12a_02_6,
    t.ag12a_03,
    t.ag12a_04,
    t.ag12a_05
   FROM (((agric_extension t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))
