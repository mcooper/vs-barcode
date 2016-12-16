 SELECT t.id AS uuid,
    t."time" AS "Date time",
    ws.country AS "Country",
    country.partner_institution AS "Partner Organization",
    ws.name AS "Weather station name",
    ws.gps_lat AS latitude,
    ws.gps_long AS longitude,
    t.temp_c AS "Temperature (degrees centigrade)",
    t.rh_pct AS "Relative humidity (%)",
    t.pressure_mbar AS "Pressure (mbar)",
    t.solar_radiation_wm2 AS "Solar radiation (w/m2)",
    t.wind_speed_ms AS "Wind speed (m/s)",
    t.gust_speed_ms AS "Gust speed (m/s)",
    t.rain_mm AS "Precipitation (mm)",
    t.batt_v AS "Battery (V)"
   FROM ((weatherdata t
     JOIN weatherstation ws ON ((t.station = ws.id)))
     JOIN country ON (((country.country)::text = (ws.country)::text)))
