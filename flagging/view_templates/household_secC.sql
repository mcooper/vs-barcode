ECT t.uuid,
    t.survey_uuid,
    t.parent_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    hh_secb.ind AS "Individual ID",
    t.hh_c01,
    t.hh_c02,
    t.hh_c03,
    t.hh_c07
   FROM (((("household_secC" t
     JOIN "household_secB" hh_secb ON (((t.parent_uuid)::text = (hh_secb.uuid)::text)))
     JOIN household hh ON (((hh_secb.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))