SELECT t.uuid,
    t.parent_uuid,
    t.survey_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
	hh.questionnaire_inspection_date,
    t.ind AS "Individual ID",
    t.hh_b02,
    t.hh_b05,
    t.hh_b03,
    t.hh_b04,
    t.hh_b07,
    t.hh_b08
   FROM ((("household_secB" t
     JOIN household hh ON (((t.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))
