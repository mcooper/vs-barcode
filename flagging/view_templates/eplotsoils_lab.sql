SELECT eplotsoils_lab.uuid,
    eplotsoils_lab.survey_uuid,
    eplotsoils_lab.country AS "Country",
    country.partner_institution AS "Partner Organization",
    eplotsoils_lab.landscape_no AS "Landscape #",
    eplotsoils_lab.eplot_no AS "Eplot #",
    (((((eplotsoils_lab.country)::text || '-'::text) || eplotsoils_lab.landscape_no) || '-'::text) || eplotsoils_lab.eplot_no) AS "Eplot Code",
    eplot.gpsne_lat AS latitude,
    eplot.gpsne_long AS longitude,
    eplotsoils_lab.data_entry_date AS "Data entry date",
    eplotsoils_lab.analyst_id AS "Analyst",
    eplotsoils_lab.analyst_first_name,
    eplotsoils_lab.analyst_last_name
   FROM ((eplotsoils_lab
     JOIN country ON (((country.country)::text = (eplotsoils_lab.country)::text)))
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
           FROM eplot eplot_1) eplot ON (((((eplotsoils_lab.country)::text = (eplot.country)::text) AND (eplotsoils_lab.landscape_no = eplot.landscape_no)) AND (eplotsoils_lab.eplot_no = eplot.eplot_no))))
