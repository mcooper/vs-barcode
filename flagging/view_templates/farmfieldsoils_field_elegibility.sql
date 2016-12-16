SELECT farmfieldsoils_field_elegibility.uuid,
    farmfieldsoils_field_elegibility.parent_uuid,
    farmfieldsoils_field_elegibility.survey_uuid,
    ffs.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    ffs.landscape_no AS "Landscape #",
    ffs.hh_refno AS "Household ID",
    farmfieldsoils_field_elegibility.field_no AS "Field #",
    farmfieldsoils_field_elegibility.a_1 AS "Larger than 100 sqm",
    farmfieldsoils_field_elegibility.a_2 AS "Cultivated currently or last season",
    farmfieldsoils_field_elegibility.a_3 AS "One of Three major crops grown",
    farmfieldsoils_field_elegibility.a_4 AS "Purestand/monoculture",
    farmfieldsoils_field_elegibility.a_5 AS "Eligible for First Field Testing",
    farmfieldsoils_field_elegibility.a_6 AS "Eligible for Second Field Testing"
   FROM (((farmfieldsoils_field_elegibility
     JOIN farmfieldsoils ffs ON (((farmfieldsoils_field_elegibility.parent_uuid)::text = (ffs.uuid)::text)))
     JOIN country ON (((country.country)::text = (ffs.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (ffs.country)::text) AND (landscape.landscape_no = ffs.landscape_no))))
