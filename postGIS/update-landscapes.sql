--shp2pgsql -s SRID RWA_T4_Polygon_20150801.shp public.rwandatemp | psql -h -d -U 
--shp2pgsql -s SRID KEN_T4_Landscapes.shp public.kenyatemp | psql -h -d -U 


INSERT INTO landscape (id, country, landscape_no) VALUES (32, 'KEN', '000');

INSERT INTO landscape (id, country, landscape_no, description, shape)
	(SELECT  "row_number"() OVER (ORDER BY t4_id)+32, 'KEN', t4_id, name, geom FROM kenyatemp);

DROP TABLE kenyatemp;

UPDATE landscape SET shape = rwandatemp.geom
FROM rwandatemp
WHERE landscape.country='RWA' and landscape.landscape_no=rwandatemp.t4_id;

DROP TABLE rwandatemp;

UPDATE landscape
SET centerpoint_latitude = st_Y(st_centroid(shape)),
		centerpoint_longitude = st_X(st_centroid(shape)),
		lower_left_latitude = st_Ymin(st_envelope(shape)),
		lower_left_longitude = st_Xmin(st_envelope(shape)),
		lower_right_latitude = st_Ymin(st_envelope(shape)),
		lower_right_longitude = st_Xmax(st_envelope(shape)),
		upper_left_latitude = st_Ymax(st_envelope(shape)),
		upper_left_longitude = st_Xmin(st_envelope(shape)),
		upper_right_latitude = st_Ymax(st_envelope(shape)),
		upper_right_longitude = st_Xmax(st_envelope(shape));