SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    eplot.country AS "Country",
    country.partner_institution AS "Partner Organization",
    eplot.landscape_no AS "Landscape #",
    eplot.eplot_no AS "Eplot #",
    (((((eplot.country)::text || '-'::text) || eplot.landscape_no) || '-'::text) || eplot.eplot_no) AS "Eplot Code",
    eplot.gpsne_lat AS latitude,
    eplot.gpsne_long AS longitude,
    eplot.date AS "Date",
    woodyplant.subplot AS "Subplot #",
    woodyplant.tree_code,
    t.tree_multistem_stemid,
    t.tree_multistem_height AS "Stem height",
    t.tree_multistem_width AS "Stem width",
    t.tree_multistem_circumference AS "Stem circumference"
   FROM (((eplot_woody_plant_stem t
     JOIN eplot_woody_plant woodyplant ON (((woodyplant.uuid)::text = (t.parent_uuid)::text)))
     JOIN eplot ON (((eplot.uuid)::text = (woodyplant.parent_uuid)::text)))
     JOIN country ON (((country.country)::text = (eplot.country)::text)))
