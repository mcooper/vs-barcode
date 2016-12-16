SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    lab.country AS "Country",
    country.partner_institution AS "Partner Organization",
    lab.landscape_no AS "Landscape #",
    lab.eplot_no AS "Eplot #",
    (((((lab.country)::text || '-'::text) || lab.landscape_no) || '-'::text) || lab.eplot_no) AS "Eplot Code",
    eplot.gpsne_lat AS latitude,
    eplot.gpsne_long AS longitude,
    lab.data_entry_date AS "Data entry date",
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
    t.restriction_depth AS "Depth restriction (cm)",
    t.moisture_tin_id AS "Moisture tin ID #",
    t.tin_dry_weight AS "Weight of Cumulative Soil Moist Tin + Oven/Air Dried Soil (g)",
    t.sample_bag_label AS "Sample Bag label ID #",
    t.total_dry_weight AS "Total Air Dried Weight of Composite Sample in Bag (g)",
    t.fine_dry_weight AS "Total Weight of Composite Soil Fine Fraction (< 2mm g)",
    t.coarse_dry_weight AS "Total Weight of Composite Sample Coarse Fraction (> 2mm)",
    t.barcode_id
   FROM (((eplotsoils_lab_weights t
     JOIN eplotsoils_lab lab ON (((t.parent_uuid)::text = (lab.uuid)::text)))
     JOIN country ON (((country.country)::text = (lab.country)::text)))
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
           FROM eplot eplot_1) eplot ON (((((lab.country)::text = (eplot.country)::text) AND (lab.landscape_no = eplot.landscape_no)) AND (lab.eplot_no = eplot.eplot_no))))
