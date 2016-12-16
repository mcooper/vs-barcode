SELECT household.uuid,
    household.survey_uuid,
    household.country AS "Country",
    country.partner_institution AS "Partner Organization",
    household.region AS "Region",
    household.district AS "District",
    household.landscape_no AS "Landscape #",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    household.hh_refno AS "Household ID",
    household.clerk_id AS "Clerk ID",
    household.clerk_code,
    household.data_clerk_code_2,
    household.data_entry_date AS "Data entry date",
    household.data_entry_date_2,
    household.questionnaire_inspection_date AS "Questionnaire inspection date",
    household.supervisor_id AS "Supervisor ID",
    household.supervisor_code,
    household.hh_head_refno AS "Household head ID",
    household.interview_date AS "Interview Date",
    household.interview_time AS "Interview Time",
    household.observations AS "Observations",
    household.survey_instrument AS "Survey Instrument",
    household.time_finish AS "Finish Time",
    "household_secV".refused AS "Number Refused"
   FROM (((household
     JOIN country ON (((country.country)::text = (household.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (household.country)::text) AND (landscape.landscape_no = household.landscape_no))))
     LEFT JOIN "household_secV" ON (((household.hh_refno = "household_secV".hh_refno) AND (household.interview_date = "household_secV".end_date))))
