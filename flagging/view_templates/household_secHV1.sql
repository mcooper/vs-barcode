SELECT t.uuid,
    t.survey_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    t.parent_uuid,
    hh_secb.ind AS "Individual ID",
    t.hh_hv103,
    t.hh_hv104,
    t.hh_hv105,
    t.hh_hv105_other,
    t.hh_hv105_unit,
    t.hh_hv105a
   FROM (((("household_secHV1" t
     JOIN "household_secB" hh_secb ON (((t.parent_uuid)::text = (hh_secb.uuid)::text)))
     JOIN household hh ON (((hh_secb.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))
