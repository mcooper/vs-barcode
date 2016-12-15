",
    t.batt_v AS "Battery (V)"
   FROM (weatherdata t
     JOIN weatherstation ws ON ((t.station = ws.id)))
     JOIN country ON (((country.country)::text = (ws.country)::text)))