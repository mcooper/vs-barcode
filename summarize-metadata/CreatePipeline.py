# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 11:34:36 2016

@author: mcooper
"""

import os
import pandas as ps

os.chdir('D:\Documents and Settings\mcooper\Documents\Automate Data Dictionaries')

#Manually created mapping
mapping = ps.read_excel('Treasure Map.xlsx', sheetname=0)

#Result of Parse XLSforms.py
xls_summary = ps.read_excel('XLS_forms_summary.xlsx', sheetname=0)

#Result of ParseSQLViews.py
db_schema = ps.read_csv('DbViewMapping.csv')

def cleanXLSsummary(df):
    df.loc[:,'relevant'] = df.loc[:,'bind:relevant'] + df.loc[:,'relevant']    
    df = df.loc[:,('required', 'bind:constraint', 'relevant', 'constraint', 'calculation', 'choice_filter', 'constraint_message', 'form_name', 'hint', 'label', 'name', 'notes', 'values')]
    df.loc[df['required']=='true()', 'required'] = 'yes'
    return(df)

def cleanDBschema(df):
    df.loc[:,'User_Tables'] = df.User_Tables.str.replace('curation__', '')
    df = df.loc[~df.DB_Vars.str.contains('uuid')]
    df = df.loc[~df.DB_Tables.str.contains('_pii')]
    df = df.loc[~df.DB_Tables.isin(['weatherdata', 'weatherstation', 'eplotsoils_processed', 'farmfieldsoils_processed'])]
    return(df)

xls_summary = cleanXLSsummary(xls_summary)
db_schema = cleanDBschema(db_schema)

views_mapping = db_schema.merge(right=mapping, left_on=['DB_Vars', 'DB_Tables'], right_on=['dbvar', 'dbtable'], how='outer')

#could remove or keep this
views_mapping = views_mapping.loc[views_mapping['source'] == 'ODK Forms']

views_xls = views_mapping.merge(right=xls_summary, left_on=['odkvar', 'May 2016'], right_on=['name', 'form_name'], how='outer')

views_xls[['source', 'User_Vars', 'User_Tables','DB_Vars', 'DB_Tables', 'dbvar', 'dbtable', 'odkvar', 'May 2016', 'name', 'form_name']].to_excel('pipeline_summary.xlsx', index=False)


