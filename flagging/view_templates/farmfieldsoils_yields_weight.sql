SELECT t.uuid,
    t.survey_uuid,
    t.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    t.landscape_no AS "Landscape #",
    t.hh_refno AS "Household ID",
    t.data_collection_date AS "Data Collection Date",
    t.region AS "Region",
    t.district AS "District",
    t.enumerator_id AS "Enumerator ID",
    t.number_of_fields AS "Number of fields"
   FROM ((farmfieldsoils_yields_weight t
     JOIN country ON (((country.country)::text = (t.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (t.country)::text) AND (landscape.landscape_no = t.landscape_no))))
