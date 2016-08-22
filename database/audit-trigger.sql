CREATE schema audit;
REVOKE CREATE ON schema audit FROM public;
 
CREATE TABLE audit.logged_actions (
    schema_name text NOT NULL,
    TABLE_NAME text NOT NULL,
    user_name text,
    action_tstamp TIMESTAMP WITH TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action TEXT NOT NULL CHECK (action IN ('I','D','U')),
    original_data text,
    new_data text,
    query text
) WITH (fillfactor=100);
 
REVOKE ALL ON audit.logged_actions FROM public;
 
-- You may wish to use different permissions; this lets anybody
-- see the full audit data. In Pg 9.0 and above you can use column
-- permissions for fine-grained control.
GRANT SELECT ON audit.logged_actions TO public;
 
CREATE INDEX logged_actions_schema_table_idx 
ON audit.logged_actions(((schema_name||'.'||TABLE_NAME)::TEXT));
 
CREATE INDEX logged_actions_action_tstamp_idx 
ON audit.logged_actions(action_tstamp);
 
CREATE INDEX logged_actions_action_idx 
ON audit.logged_actions(action);
 
--
-- Now, define the actual trigger function:
--
CREATE OR REPLACE FUNCTION audit.if_modified_func() RETURNS TRIGGER AS $body$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,original_data,new_data,query) 
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := ROW(OLD.*);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,original_data,query)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        v_new_data := ROW(NEW.*);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,new_data,query)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
        RETURN NEW;
    ELSE
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    END IF;
 
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
SET search_path = pg_catalog, audit;

create trigger agric_update
 after update or insert or delete
 on "agric" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_byprod_update
 after update or insert or delete
 on "agric_byprod" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_crops_by_field_update
 after update or insert or delete
 on "agric_crops_by_field" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_crops_by_hh_update
 after update or insert or delete
 on "agric_crops_by_hh" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_extension_update
 after update or insert or delete
 on "agric_extension" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_extension_family_update
 after update or insert or delete
 on "agric_extension_family" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_field_details_update
 after update or insert or delete
 on "agric_field_details" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_field_details_labor_update
 after update or insert or delete
 on "agric_field_details_labor" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_field_roster_update
 after update or insert or delete
 on "agric_field_roster" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_implement_update
 after update or insert or delete
 on "agric_implement" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_livestock_update
 after update or insert or delete
 on "agric_livestock" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_livestock_by_field_update
 after update or insert or delete
 on "agric_livestock_by_field" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_livestock_byproduct_update
 after update or insert or delete
 on "agric_livestock_byproduct" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_perm_crop_update
 after update or insert or delete
 on "agric_perm_crop" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_perm_crops_by_field_update
 after update or insert or delete
 on "agric_perm_crops_by_field" 
 for each row execute procedure audit.if_modified_func();

create trigger agric_roster_update
 after update or insert or delete
 on "agric_roster" 
 for each row execute procedure audit.if_modified_func();

create trigger countries_plant_species_update
 after update or insert or delete
 on "countries_plant_species" 
 for each row execute procedure audit.if_modified_func();

create trigger country_update
 after update or insert or delete
 on "country" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_update
 after update or insert or delete
 on "eplot" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_id_update
 after update or insert or delete
 on "eplot_id" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_subplot_landscapefn_update
 after update or insert or delete
 on "eplot_subplot_landscapefn" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_subplot_vegetation_update
 after update or insert or delete
 on "eplot_subplot_vegetation" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_subplot_woody_canopy_update
 after update or insert or delete
 on "eplot_subplot_woody_canopy" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_woody_plant_update
 after update or insert or delete
 on "eplot_woody_plant" 
 for each row execute procedure audit.if_modified_func();

create trigger eplot_woody_plant_stem_update
 after update or insert or delete
 on "eplot_woody_plant_stem" 
 for each row execute procedure audit.if_modified_func();

create trigger eplotsoils_lab_update
 after update or insert or delete
 on "eplotsoils_lab" 
 for each row execute procedure audit.if_modified_func();

create trigger eplotsoils_lab_weights_update
 after update or insert or delete
 on "eplotsoils_lab_weights" 
 for each row execute procedure audit.if_modified_func();

create trigger eplotsoils_processed_update
 after update or insert or delete
 on "eplotsoils_processed" 
 for each row execute procedure audit.if_modified_func();

create trigger eplotsoils_sample_update
 after update or insert or delete
 on "eplotsoils_sample" 
 for each row execute procedure audit.if_modified_func();

create trigger eplotsoils_weights_update
 after update or insert or delete
 on "eplotsoils_weights" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_update
 after update or insert or delete
 on "farmfieldsoils" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_field_elegibility_update
 after update or insert or delete
 on "farmfieldsoils_field_elegibility" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_lab_update
 after update or insert or delete
 on "farmfieldsoils_lab" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_lab_weights_update
 after update or insert or delete
 on "farmfieldsoils_lab_weights" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_soil_measurements_update
 after update or insert or delete
 on "farmfieldsoils_soil_measurements" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_maize_update
 after update or insert or delete
 on "farmfieldsoils_yields_maize" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_maize_field_update
 after update or insert or delete
 on "farmfieldsoils_yields_maize_field" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_maize_field_characteristic_update
 after update or insert or delete
 on "farmfieldsoils_yields_maize_field_characteristic" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_paddy_maize_update
 after update or insert or delete
 on "farmfieldsoils_yields_paddy_maize" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_paddy_maize_field_update
 after update or insert or delete
 on "farmfieldsoils_yields_paddy_maize_field" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_paddy_maize_field_characteristic_update
 after update or insert or delete
 on "farmfieldsoils_yields_paddy_maize_field_characteristic" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_weight_update
 after update or insert or delete
 on "farmfieldsoils_yields_weight" 
 for each row execute procedure audit.if_modified_func();

create trigger farmfieldsoils_yields_weight_crop_update
 after update or insert or delete
 on "farmfieldsoils_yields_weight_crop" 
 for each row execute procedure audit.if_modified_func();

create trigger household_update
 after update or insert or delete
 on "household" 
 for each row execute procedure audit.if_modified_func();

create trigger household_member_ref_update
 after update or insert or delete
 on "household_member_ref" 
 for each row execute procedure audit.if_modified_func();

create trigger household_ref_update
 after update or insert or delete
 on "household_ref" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secB_update
 after update or insert or delete
 on "household_secB" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secC_update
 after update or insert or delete
 on "household_secC" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secE_update
 after update or insert or delete
 on "household_secE" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secHV1_update
 after update or insert or delete
 on "household_secHV1" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secHV2_update
 after update or insert or delete
 on "household_secHV2" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secI_update
 after update or insert or delete
 on "household_secI" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secJ1_update
 after update or insert or delete
 on "household_secJ1" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secJ2_update
 after update or insert or delete
 on "household_secJ2" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secK1_update
 after update or insert or delete
 on "household_secK1" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secK2_update
 after update or insert or delete
 on "household_secK2" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secL_update
 after update or insert or delete
 on "household_secL" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secM_update
 after update or insert or delete
 on "household_secM" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secN_update
 after update or insert or delete
 on "household_secN" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secU_update
 after update or insert or delete
 on "household_secU" 
 for each row execute procedure audit.if_modified_func();

create trigger household_secV_update
 after update or insert or delete
 on "household_secV" 
 for each row execute procedure audit.if_modified_func();

create trigger images_update
 after update or insert or delete
 on "images" 
 for each row execute procedure audit.if_modified_func();

create trigger landscape_update
 after update or insert or delete
 on "landscape" 
 for each row execute procedure audit.if_modified_func();

create trigger odk_times_update
 after update or insert or delete
 on "odk_times" 
 for each row execute procedure audit.if_modified_func();

create trigger plant_species_update
 after update or insert or delete
 on "plant_species" 
 for each row execute procedure audit.if_modified_func();

create trigger plant_species_ranking_update
 after update or insert or delete
 on "plant_species_ranking" 
 for each row execute procedure audit.if_modified_func();

create trigger qa_advisories_update
 after update or insert or delete
 on "qa_advisories" 
 for each row execute procedure audit.if_modified_func();

create trigger rapid_water_update
 after update or insert or delete
 on "rapid_water" 
 for each row execute procedure audit.if_modified_func();

create trigger rra_update
 after update or insert or delete
 on "rra" 
 for each row execute procedure audit.if_modified_func();

create trigger rra_dominant_update
 after update or insert or delete
 on "rra_dominant" 
 for each row execute procedure audit.if_modified_func();

create trigger safe_coords_ref_update
 after update or insert or delete
 on "safe_coords_ref" 
 for each row execute procedure audit.if_modified_func();

create trigger schema_migrations_update
 after update or insert or delete
 on "schema_migrations" 
 for each row execute procedure audit.if_modified_func();

create trigger staff_update
 after update or insert or delete
 on "staff" 
 for each row execute procedure audit.if_modified_func();

create trigger water_laboratory_analysis_update
 after update or insert or delete
 on "water_laboratory_analysis" 
 for each row execute procedure audit.if_modified_func();

create trigger water_quality_update
 after update or insert or delete
 on "water_quality" 
 for each row execute procedure audit.if_modified_func();

create trigger water_quality_sample_data_update
 after update or insert or delete
 on "water_quality_sample_data" 
 for each row execute procedure audit.if_modified_func();

create trigger weatherdata_update
 after update or insert or delete
 on "weatherdata" 
 for each row execute procedure audit.if_modified_func();

create trigger weatherstation_update
 after update or insert or delete
 on "weatherstation" 
 for each row execute procedure audit.if_modified_func();