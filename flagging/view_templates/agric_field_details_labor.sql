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
    det.field_id AS "Field ID",
    det.season AS "Season",
    t.ind AS "Individual ID",
    t.ag3a_70_preparing,
    t.ag3a_70_weeding,
    t.ag3a_70_fertilizing,
    t.ag3a_70_harvesting
   FROM ((((agric_field_details_labor t
     JOIN agric_field_details det ON (((t.parent_uuid)::text = (det.uuid)::text)))
     JOIN agric ON (((det.parent_uuid)::text = (agric.uuid)::text)))
     JOIN country ON (((country.country)::text = (agric.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (agric.country)::text) AND (landscape.landscape_no = agric.landscape_no))))
