SELECT farmfieldsoils.uuid,
    farmfieldsoils.survey_uuid,
    farmfieldsoils.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    farmfieldsoils.region AS "Region",
    farmfieldsoils.district AS "District",
    farmfieldsoils.hh_refno AS "Household ID",
    farmfieldsoils.landscape_no AS "Landscape #",
    farmfieldsoils.enumerator_id AS "Enumerator ID",
    farmfieldsoils.data_collection_date AS "Data collection date",
    farmfieldsoils.number_of_fields AS "Number of fields",
    farmfieldsoils.selected_first_field AS "Selected first field",
    farmfieldsoils.selected_second_field AS "Selected second field",
    farmfieldsoils.selected_first_field_other AS "Selected first field other",
    farmfieldsoils.selected_second_field_other AS "Selected second field other",
    farmfieldsoils.survey_instrument AS "Survey Instrument",
    farmfieldsoils.survey_type AS "Survey Type"
   FROM ((farmfieldsoils
     JOIN country ON (((country.country)::text = (farmfieldsoils.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (farmfieldsoils.country)::text) AND (landscape.landscape_no = farmfieldsoils.landscape_no))))
