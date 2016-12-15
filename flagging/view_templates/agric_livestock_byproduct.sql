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
    t.ag10b_01,
    t.ag10b_1a,
    t.ag10b_1a_unit,
    t.ag10b_1b,
    t.ag10b_05_1,
    t.ag10b_05_2,
    t.ag10b_06
   FROM (((agric_livestock_byproduct t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))