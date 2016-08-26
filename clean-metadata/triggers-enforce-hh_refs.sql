CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_yields_paddy_maize_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils_yields_paddy_maize f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_yields_paddy_maize_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils_yields_paddy_maize
for each row execute procedure public.if_farmfieldsoils_yields_paddy_maize_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_yields_maize_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils_yields_maize f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
				
	UPDATE household_member_ref f
	SET hh_refno=r.hh_refno
	FROM farmfieldsoils_yields_maize r
	WHERE f.id=r.farmers_ref;

  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_yields_maize_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils_yields_maize
for each row execute procedure public.if_farmfieldsoils_yields_maize_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_yields_weight_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils_yields_weight f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_yields_weight_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils_yields_weight
for each row execute procedure public.if_farmfieldsoils_yields_weight_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_lab_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils_lab f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_lab_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils_lab
for each row execute procedure public.if_farmfieldsoils_lab_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils
for each row execute procedure public.if_farmfieldsoils_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_farmfieldsoils_processed_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE farmfieldsoils_processed f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER farmfieldsoils_processed_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON farmfieldsoils_processed
for each row execute procedure public.if_farmfieldsoils_processed_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_agric_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE agric f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
				
	UPDATE household_member_ref f
	SET hh_refno=r.hh_refno
	FROM agric r
	WHERE f.id=r.hh_head_refno;
	
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER agric_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON agric
for each row execute procedure public.if_agric_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_household_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE household f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
				
	UPDATE household_member_ref f
	SET hh_refno=r.hh_refno
	FROM household r
	WHERE f.id=r.hh_head_refno;
	
	RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER household_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON household
for each row execute procedure public.if_household_hh_ref_modified();

CREATE OR REPLACE FUNCTION public.if_household_secV_hh_ref_modified() RETURNS TRIGGER AS $body$
BEGIN
	UPDATE "household_secV" f
	SET hh_refno=r.id
	FROM household_ref r
	WHERE f.country=r.country AND
				f.landscape_no=r.landscape_no AND
				f.eplot_no=r.eplot_no AND
				f.hh_no=r.hh_no AND
				hh_refno <> r.id; 
  RETURN NULL;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

CREATE TRIGGER household_secV_hh_ref
AFTER UPDATE of landscape_no, country, eplot_no, hh_no
ON "household_secV"
for each row execute procedure public.if_household_secV_hh_ref_modified();
