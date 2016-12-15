SELECT farmfieldsoils_lab.uuid,
    farmfieldsoils_lab.survey_uuid,
    farmfieldsoils_lab.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    farmfieldsoils_lab.landscape_no AS "Landscape #",
    farmfieldsoils_lab.hh_refno AS "Household ID",
    farmfieldsoils_lab.enumerator_id AS "Enumerator ID",
    farmfieldsoils_lab.date AS "Date",
    farmfieldsoils_lab.selected_first_field AS "Selected first field",
    farmfieldsoils_lab.selected_second_field AS "Selected second field"
   FROM ((farmfieldsoils_lab
     JOIN country ON (((country.country)::text = (farmfieldsoils_lab.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (farmfieldsoils_lab.country)::text) AND (landscape.landscape_no = farmfieldsoils_lab.landscape_no))))