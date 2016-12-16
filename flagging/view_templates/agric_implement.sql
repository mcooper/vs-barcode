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
    t.itemcode AS "Item code",
    t.toolname AS "Tool name",
    t.ag11_01,
    t.ag11_07
   FROM (((agric_implement t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))
