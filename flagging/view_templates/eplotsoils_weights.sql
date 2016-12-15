SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    sample.country AS "Country",
    country.partner_institution AS "Partner Organization",
    sample.landscape_no AS "Landscape #",
    sample.eplot_no AS "Eplot #",
    (((((sample.country)::text || '-'::text) || sample.landscape_no) || '-'::text) || sample.eplot_no) AS "Eplot Code",
    eplot.gpsne_lat AS latitude,
    eplot.gpsne_long AS longitude,
    sample.sample_date AS "Sampling date",
    t.soil_depth_class AS "Sampling depth class",
        CASE
            WHEN (t.soil_depth_class = 'top'::text) THEN 0
            WHEN (t.soil_depth_class = 'subsoil'::text) THEN 20
            WHEN (t.soil_depth_class = '50-80'::text) THEN 50
            WHEN (t.soil_depth_class = '80-100'::text) THEN 80
            ELSE NULL::integer
        END AS "Sample depth top",
        CASE
            WHEN (t.soil_depth_class = 'top'::text) THEN 20
            WHEN (t.soil_depth_class = 'subsoil'::text) THEN 50
            WHEN (t.soil_depth_class = '50-80'::text) THEN 80
            WHEN (t.soil_depth_class = '80-100'::text) THEN 100
            ELSE NULL::integer
        END AS "Sample depth bottom",
    t.moisture AS "Moisture Tin ID#",
    t.tin_fresh_weight AS "Weight of soil moisture tin - fresh soil subsample (g)",
    t.tin_weight AS "Weight of soil moisture tin (g)",
    t.weight AS "Total weight of cumulative mass sample (g)"
   FROM (((eplotsoils_weights t
     JOIN eplotsoils_sample sample ON (((t.parent_uuid)::text = (sample.uuid)::text)))
     JOIN country ON (((country.country)::text = (sample.country)::text)))
     JOIN ( SELECT DISTINCT ON (eplot_1.country, eplot_1.landscape_no, eplot_1.eplot_no) eplot_1.country,
            eplot_1.landscape_no,
            eplot_1.eplot_no,
            eplot_1.gpsse_lat,
            eplot_1.gpsse_long,
            eplot_1.gpssw_lat,
            eplot_1.gpssw_long,
            eplot_1.gpsne_lat,
            eplot_1.gpsne_long,
            eplot_1.gpsnw_lat,
            eplot_1.gpsnw_long
           FROM eplot eplot_1) eplot ON (((((sample.country)::text = (eplot.country)::text) AND (sample.landscape_no = eplot.landscape_no)) AND (sample.eplot_no = eplot.eplot_no))))