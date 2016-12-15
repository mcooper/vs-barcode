SELECT farmfieldsoils_lab_weights.uuid,
    farmfieldsoils_lab_weights.parent_uuid,
    farmfieldsoils_lab_weights.survey_uuid,
    ffs.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    ffs.landscape_no AS "Landscape #",
    ffs.hh_refno AS "Household ID",
    farmfieldsoils_lab_weights.field_no AS "Field #",
    farmfieldsoils_lab_weights.depth AS "Depth",
    farmfieldsoils_lab_weights.weight_moisture_bag AS "Weight moisture bag",
    farmfieldsoils_lab_weights.sample_weight_fine AS "Sample weight fine",
    farmfieldsoils_lab_weights.sample_weight_coarse AS "Sample weight coarse",
    farmfieldsoils_lab_weights.barcode_id AS "Barcode ID"
   FROM (((farmfieldsoils_lab_weights
     JOIN farmfieldsoils_lab ffs ON (((farmfieldsoils_lab_weights.parent_uuid)::text = (ffs.uuid)::text)))
     JOIN country ON (((country.country)::text = (ffs.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (ffs.country)::text) AND (landscape.landscape_no = ffs.landscape_no))))