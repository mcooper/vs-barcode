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

UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM household r
WHERE f.id=r.hh_head_refno AND
      f.indid=r.hh_first_name;

UPDATE household_member_ref f
SET hh_refno=r.hh_refno
FROM
(SELECT a.hh_refno, b.ind, b.indid FROM household a
JOIN "household_secB" b ON (a.uuid=b.parent_uuid)) r
WHERE f.id=r.ind AND
      f.indid=r.indid;

DELETE FROM household_ref
WHERE length(hh_no) > 2