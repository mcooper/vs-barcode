ory.resolved = false)) AND (advisory.ignored = false))))
          GROUP BY farmfieldsoils_yields_weight_crop.uuid
        )
 SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    yw.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    yw.landscape_no AS "Landscape #",
    yw.hh_refno AS "Household ID",
    yw.data_collection_date AS "Data Collection Date",
    t.field_no AS "Field #",
    t.dry_crop_id AS "Dry Crop ID",
    t."141_a1" AS d_141_a1,
    t."141_a2" AS d_141_a2,
    t."141_b" AS d_141_b,
    t."141_b_other" AS d_141_b_other
   FROM (((farmfieldsoils_yields_weight_crop t
     JOIN farmfieldsoils_yields_weight yw ON (((yw.uuid)::text = (t.parent_uuid)::text)))
     JOIN country ON (((country.country)::text = (yw.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (yw.country)::text) AND (landscape.landscape_no = yw.landscape_no))))