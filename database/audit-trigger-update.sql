CREATE OR REPLACE FUNCTION audit.if_modified_func() RETURNS TRIGGER AS $body$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
	record_id TEXT;
BEGIN
		IF (TG_OP = 'UPDATE' AND ROW(OLD.*)<>ROW(NEW.*)) THEN
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
				record_id := substring(CAST(ROW(OLD.*) as text), 2, position(',' in cast(ROW(OLD.*) as text))-2);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,original_data,new_data,query,record_id) 
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query(),record_id);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE' AND ROW(OLD.*)<>ROW(NEW.*)) THEN
        v_old_data := ROW(OLD.*);
		record_id := substring(CAST(ROW(OLD.*) as text), 2, position(',' in cast(ROW(OLD.*) as text))-2);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,original_data,query,record_id)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query(),record_id);
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT' AND ROW(OLD.*)<>ROW(NEW.*)) THEN
        v_new_data := ROW(NEW.*);
		record_id := substring(CAST(ROW(NEW.*) as text), 2, position(',' in cast(ROW(NEW.*) as text))-2);
        INSERT INTO audit.logged_actions (schema_name,table_name,user_name,action,new_data,query,record_id)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query(),record_id);
        RETURN NEW;
    ELSE
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