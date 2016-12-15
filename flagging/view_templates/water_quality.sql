SELECT water_quality.uuid,
    water_quality.survey_uuid,
    water_quality.country AS "Country",
    country.partner_institution AS "Partner Organization",
    water_quality.landscape_no AS "Landscape Number",
    water_quality.analyst_id AS "Analyst",
    water_quality.analyst_first_name AS "Analyst First Name",
    water_quality.analyst_last_name AS "Analyst Last Name",
    water_quality.sample_analysis_date AS "Sample Analysis Date",
    water_quality.cl1_1 AS "EC calibration",
    water_quality.cl1_2 AS "PO4 calibration",
    water_quality.cl2_0 AS "pH 4 calibration",
    water_quality.cl2_1 AS "pH 7 calibration",
    water_quality.cl2_no_1 AS "NO3 High calibration",
    water_quality.cl2_no_2 AS "NO3 Low calibration",
    water_quality.sample_notes AS "Sample Notes",
    water_quality.survey_instrument AS "Survey Instrument"
   FROM (water_quality
     JOIN country ON (((country.country)::text = (water_quality.country)::text)))