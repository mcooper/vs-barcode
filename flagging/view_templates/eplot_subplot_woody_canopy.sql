SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    country.partner_institution AS "Partner Organization",
    eplot.country AS "Country",
    eplot.landscape_no AS "Landscape #",
    eplot.eplot_no AS "Eplot #",
    (((((eplot.country)::text || '-'::text) || eplot.landscape_no) || '-'::text) || eplot.eplot_no) AS "Eplot Code",
    eplot.gpsne_lat AS latitude,
    eplot.gpsne_long AS longitude,
    eplot.date AS "Date",
    t.subplot AS "Subplot #",
    t.densiometer_n AS "Densiometer N",
    t.densiometer_e AS "Densiometer E",
    t.densiometer_s AS "Densiometer S",
    t.densiometer_w AS "Densiometer W"
   FROM ((eplot_subplot_woody_canopy t
     JOIN eplot ON (((t.parent_uuid)::text = (eplot.uuid)::text)))
     JOIN country ON (((country.country)::text = (eplot.country)::text)))