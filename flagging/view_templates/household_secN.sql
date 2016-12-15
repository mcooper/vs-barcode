SELECT t.uuid,
    t.survey_uuid,
    t.parent_uuid,
    hh.country AS "Country",
    country.partner_institution AS "Partner Organization",
    landscape.centerpoint_longitude AS longitude,
    landscape.centerpoint_latitude AS latitude,
    hh.landscape_no AS "Landscape #",
    hh.hh_refno AS "Household ID",
    hh.data_entry_date AS "Data entry date",
    t.n_401,
    t.n_402,
    t.n_403,
    t.n_404,
    t.n_405,
    t.n_406,
    t.n_407,
    t.n_408,
    t.n_409,
    t.n_410,
    t.n_411,
    t.n_412,
    t.n_413,
    t.n_414,
    t.n_415,
    t.n_416,
    t.n_417,
    t.n_418,
    t.n_419,
    t.n_420,
    t.n_421,
    t.n_422,
    t.n_423,
    t.n_424,
    t.n_425,
    t.n_426,
    t.n_427,
    t.n_428,
    t.n_429,
    t.n_430,
    t.n_431,
    t.n_432,
    t.n_433,
    t.n_434,
    t.n_435,
    t.n_436,
    t.n_437,
    t.n_438,
    t.n_439,
    t.n_440,
    t.n_441,
    t.n_442,
    t.n_443,
    t.n_444,
    t.n_445,
    t.n_446,
    t.n_447,
    t.n_448,
    t.n_449,
    t.n_450,
    t.n_451,
    t.n_452,
    t.n_453,
    t.n_454,
    t.n_455,
    t.n_456,
    t.n_457,
    t.n_458,
    t.n_459,
    t.n_460,
    t.n_461,
    t.n_462,
    t.n_463,
    t.n_464,
    t.n_465,
    t.n_466,
    t.n_467,
    t.n_468
   FROM ((("household_secN" t
     JOIN household hh ON (((t.parent_uuid)::text = (hh.uuid)::text)))
     JOIN country ON (((country.country)::text = (hh.country)::text)))
     JOIN landscape ON ((((landscape.country)::text = (hh.country)::text) AND (landscape.landscape_no = hh.landscape_no))))