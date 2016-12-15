SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    wq.country AS "Country",
    country.partner_institution AS "Partner Organization",
    wq.sample_analysis_date AS "Sample Analysis Date",
    t.water_smp_no AS "Water Sample #",
    t.water_temp AS "Water Temperature",
    t.water_smp_ph AS "Water Ph",
    t.water_smp_cdty AS "Water Conductivity",
    t.water_smp_no3 AS "Water NO3",
    t.water_smp_po4 AS "Water PO4",
    t.ws1_1 AS "Compartments With Color Changes",
    t.ws1_1_10ml AS "Color change in the 10 mL compartment",
    t.ws1_1_30ml AS "Color change in the 30 mL compartment",
    t.ws1_1_50ml AS "Color change in the 50 mL compartment",
    t.ws1_1_3ml AS "Color change in the 3 mL compartment",
    t.ws1_1_1ml AS "Color change in the 1 mL compartment",
    t.ws1_mpn AS "Most Probable Number of Organisms per 100 mL"
   FROM ((water_quality_sample_data t
     JOIN water_quality wq ON (((wq.uuid)::text = (t.parent_uuid)::text)))
     JOIN country ON (((country.country)::text = (wq.country)::text)))