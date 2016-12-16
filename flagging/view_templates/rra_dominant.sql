SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    rra.country AS "Country",
    rra.gps_lat AS latitude,
    rra.gps_long AS longitude,
    country.partner_institution AS "Partner Organization",
    rra.rapid_road_asses_no AS "Rapid Road Assessment #",
    t.tax AS "Plant species",
    t.plant_type,
    t.code,
    ps.common,
    ps.genus,
    ps.species,
    ps.subspecies,
    t.unknown_image AS "Photo of unknown species"
   FROM (((rra_dominant t
     JOIN rra ON (((t.parent_uuid)::text = (rra.uuid)::text)))
     LEFT JOIN plant_species ps ON ((ps.id = t.tax)))
     JOIN country ON (((country.country)::text = (rra.country)::text)))
