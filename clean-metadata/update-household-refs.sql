--This still wont work, there are records in household_member_ref that are not updating.
--somehow, the household and the individual they correspond to dont exist.  Might need
--David's help.

--Also, updating households in household_member_ref should triggered everytime, not just one time

UPDATE farmfieldsoils_yields_paddy_maize f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE farmfieldsoils_yields_maize f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE farmfieldsoils_yields_weight f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE farmfieldsoils_lab f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE farmfieldsoils f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE farmfieldsoils_processed f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE agric f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE "household_secV" f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

UPDATE household f
SET hh_refno=r.id
FROM household_ref r
WHERE f.country=r.country AND
      f.landscape_no=r.landscape_no AND
			f.eplot_no=r.eplot_no AND
			f.hh_no=r.hh_no;

--household
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM household r
WHERE f.id=r.hh_head_refno;

--household_secB
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM
(SELECT a.hh_refno, 
		b.ind, 
		b.indid FROM household a
JOIN "household_secB" b ON (a.uuid=b.parent_uuid)) r
WHERE f.id=r.ind;

--agric
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM agric r
WHERE f.id=r.hh_head_refno;

--agric_roster
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM 
(SELECT a.hh_refno, 
		b.hh_indid_name,
		b.ind
	FROM agric a
JOIN agric_roster b ON (a.uuid=b.parent_uuid)) r
WHERE f.id=r.ind;
	  
--agric_field_details_labor
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM 
(SELECT a.hh_refno, 
		b.hh_indid_name,
		b.ind
	FROM agric a
JOIN agric_field_details c ON (a.uuid=c.parent_uuid)
JOIN agric_field_details_labor b ON (c.uuid=b.parent_uuid)) r
WHERE f.id=r.ind;
	  
--farmfieldsoils_yields_maize
UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM farmfieldsoils_yields_maize r
WHERE f.id=r.farmers_ref;

DELETE FROM household_member_ref
WHERE hh_refno in
(SELECT id FROM household_ref
WHERE length(hh_no)>2);

DELETE FROM household_ref
WHERE length(hh_no) > 2;