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
    t.field_id AS "Field ID",
    t.field_name AS "Field name",
    t.ag10_vs_1,
    t.ag10_vs_2,
    t.ag10_vs_2_1,
    t.ag10_vs_2_2,
    t.ag10_vs_2_3,
    t.ag10_vs_2_4,
    t.ag10_vs_2_5,
    t.ag10_vs_2_6,
    t.ag10_vs_2_7,
    t.ag10_vs_2_8,
    t.ag10_vs_2_9,
    t.ag10_vs_2_50,
    t.ag10_vs_2_51,
    t.ag10_vs_2_other,
    t.ag10_vs_3,
    t.ag10_vs_3_other
   FROM (((agric_livestock_by_field t
     JOIN agric ON (((t.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))