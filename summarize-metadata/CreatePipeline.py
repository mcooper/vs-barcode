# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 11:34:36 2016

@author: mcooper
"""

import os
import pandas as ps
import re
import string

os.chdir('D:\Documents and Settings\mcooper\Documents\Automate Data Dictionaries')

#Manually created mapping
mapping = ps.read_excel('Formhub-DB Mapping.xlsx', sheetname=0)

#Result of Parse XLSforms.py
xls_summary = ps.read_excel('XLS_forms_summary.xlsx', sheetname=0)

#Result of ParseSQLViews.py
db_schema = ps.read_csv('DbViewMapping.csv')

def cleanLabel(s):
    s = s.split(' ')
    if len(s) > 1:
        if ')' in s[0] or ':' in s[0] or '.' in s[0] or ('-' in s[0] and re.search('[0-9]', s[0])):
            s = s[1:]
        if not re.search('[^0-9]' + '[^{}]'.format(string.punctuation),  s[0]):
            s = s[1:]
    f = ' '.join(s)
    return(f)

def cleanXLSsummary(df):
    df.loc[~df['data_notes'].isnull(), 'data_notes'] = df['data_notes'].dropna().apply(cleanLabel)
    df.loc[~df['label'].isnull(), 'label'] = df['label'].dropna().apply(cleanLabel)
    df.loc[:,'relevant'] = df.loc[:,['bind:relevant', 'relevant']].fillna('').sum(axis=1)   
    df.loc[:,'constraint'] = df.loc[:,['bind:constraint', 'constraint']].fillna('').sum(axis=1)
    
    #This should only happen where    
    df.loc[~(df.label.isnull() | df.data_notes.isnull()), 'space'] = ' - '
    df.loc[:,'label'] = df.loc[:,['label', 'space', 'data_notes']].fillna('').sum(axis=1)
    df = df.loc[:,('required', 'relevant', 'constraint', 'calculation', 'choice_filter', 'constraint_message', 'form_name', 'hint', 'label', 'name', 'notes', 'values', 'type')]
    df.loc[df['required']=='true()', 'required'] = 'yes'
    return(df)

def cleanDBschema(df):
    df.loc[:,'User_Tables'] = df.User_Tables.str.replace('curation__', '')
    df = df.loc[~df.DB_Vars.str.contains('uuid')]
    #df = df.loc[~df.DB_Tables.isin(['weatherdata', 'weatherstation', 'eplotsoils_processed', 'farmfieldsoils_processed'])]
    return(df)
    
def cleanPlantSpecies(df):
    #delete where User_Tables and form_name dont map and where dbtable = plant_species
    #then, delete where User_Vars and name dont map and where User_Tables=eplot_subplot_vegetation
    df['combine_tables'] = df['User_Tables'] + '+' + df['form_name']
    df['combine_vars'] = df['name'] + '+' + df['User_Vars']
    tablemap = ['eplot_subplot_vegetation+eplot_15_may_2016_v1', 'rra_dominant+rapid_road_15_may_2016_v1', 'eplot_woody_plant+eplot_15_may_2016_v1']
    varmap = ['subplot_rank1_common+Common Name Ranked 1', 'subplot_rank2_common+Common Name Ranked 2', 'subplot_rank3_common+Common Name Ranked 3',
              'subplot_rank1_genus+Genus Ranked 1', 'subplot_rank2_genus+Genus Ranked 2', 'subplot_rank3_genus+Genus Ranked 3', 
              'subplot_rank1_species_select+Species Ranked 1', 'subplot_rank2_species_select+Species Ranked 2', 'subplot_rank3_species_select+Species Ranked 3',
              'subplot_rank1_subspecies+Subspecies Ranked 1', 'subplot_rank2_subspecies+Subspecies Ranked 2', 'subplot_rank3_subspecies+Subspecies Ranked 3',
              'subplot_tree_common+Common Name', 'subplot_tree_genus+Genus', 'subplot_tree_species_select+Genus', 'subplot_tree_species_select+Species',
              'subplot_tree_species+Species', 'subplot_tree_subspecies+Subspecies'] 
    #df = df.loc[df[]]
    df = df.loc[~(df['dbtable'].isin(['plant_species'])) | df['combine_tables'].isin(tablemap),:]
    df = df.loc[~(df['dbtable'].isin(['plant_species']) & df['User_Tables'].isin(['eplot_subplot_vegetation', 'eplot_woody_plant'])) | df.combine_vars.isin(varmap),:]
    del df['combine_tables']
    del df['combine_vars']
    return(df)

def replaceVars(df):
    #Replaces a ${odk_var} with a {user_var} in the formulas
    idx = ~(df['name'].isnull() | df['User_Vars'].isnull())
    for i in df.index[idx]:
        df = df.replace({'\{' + df.loc[idx, 'name'][i] : '{' + df.loc[idx, 'User_Vars'][i]}, regex=True)
    df = df.replace({'\$':''}, regex=True)
    
    return(df)

def removePii(df):
    #Remove all *_pii tables
    idx = df.User_Tables.str.contains('_pii')
    idx.loc[idx.isnull()] = False
    df = df.loc[-idx]
    
    return(df)

xls_summary = cleanXLSsummary(xls_summary)
db_schema = cleanDBschema(db_schema)

views_mapping = db_schema.merge(right=mapping, left_on=['DB_Vars', 'DB_Tables'], right_on=['dbvar', 'dbtable'], how='outer')

views_xls = views_mapping.merge(right=xls_summary, left_on=['odkvar', 'May 2016'], right_on=['name', 'form_name'], how='outer')

final_df = cleanPlantSpecies(views_xls)

metadata_definition = [
    ['User_Vars',           'The name of the variables in the views that users downloadas parsed from the view definition scripts'],
    ['User_Tables',         'The name of the views that users download, as parsed from the view definition scripts'],
    ['DB_Vars',             'The name of the variable in the database, as parsed from the view definition scripts'],
    ['DB_Tables',           'The name of the table in the database, as parsed from the view definition scripts'],
    ['form_name',           'The name of the ODK form that the teams used to collect the data'],
    ['source',              'Where the variable came from - can be from ODK directly, or a linking or pivot variable introduced between formhub and the database'],
    ['odkvar',              'The name of the variable in ODK, as described in "Formhub-DB mapping.xlsx"'],
    ['dbvar',               'The name of the variable in the database, as described in "Formhub-DB mapping.xlsx"'],
    ['dbtable',             'The name of the table in the database, as described in "Formhub-DB mapping.xlsx"'],
    ['September 2015',      'The name of the form that the variable came from in the September 2015 versions of the forms'],
    ['May 2016',            'The name of the form that the variable came from in the May 2016 versions of the forms'],
    ['name',                'From ODK: The name of the variable in the ODK form that the teams used to collect the data. This is the name of the variable in the "required", "relevant", "constrant", "calculation" and "choice_filter" calculations'],
    ['type',                'From ODK: The variables type from ODK'],    
    ['required',            'From ODK: If the variable was required to be answered, can be "yes" or a conditional statement describing when the variable is required'],
    ['relevant',            'From ODK: Describes whether the variable should be asked'], 
    ['constraint',          'From ODK: Describes the constraints on the variable being entered'],
    ['calculation',         'From ODK: Describes the calculation used to generate the variable'],
    ['choice_filter',       'From ODK: Describes the available choices in select/categorical variable types'],
    ['constraint_message',  'From ODK: The text displayed to data collecters when a variable violates the constraint condition'],
    ['hint',                'From ODK: A hint given to data collectors describing how to collect or enter the data'],
    ['label',               'From ODK: The label given to an ODK variable.  This is usually where the actual question is presented'],
    ['notes',               'From ODK: Any notes given before ODK brings up a variable.  Sometimes this is where the actual question is presented'], 
    ['values',              'From ODK: The possible values that can be selected for a select one or select many variable type']
]
    
metadata = ps.DataFrame(metadata_definition, columns=['Column Name', 'Column Description'])

#Write mapping results
final_df.loc[:, ['User_Vars', 'User_Tables', 'DB_Vars', 'DB_Tables', 'dbvar', 'dbtable', 'odkvar', 'May 2016']].to_excel('Mapping.xls', index=False)

#save entire pipeline
pipeline_writer = ps.ExcelWriter('metadata_summaries/_pipeline_summary.xlsx')
final_df.to_excel(pipeline_writer, 'Metadata Summary', index=False)
metadata.to_excel(pipeline_writer, 'Column Descriptions', index=False)
pipeline_writer.save()


include_cols = ['User_Vars', 'label', 'required', 'relevant', 'constraint', 'choice_filter']

#final_df = replaceVars(final_df)
userdf = removePii(final_df)

#Write results for automated metadata
final_df.loc[~final_df.User_Tables.isnull(), ['source', 'User_Vars', 'User_Tables', 'DB_Tables', 'label', 'type', 'values']].to_csv('Metadata_tool.csv', index=False)

#To Do Map table names to names in the download tool
#Figure out why C_name isn't replacing

for i in userdf['User_Tables'].dropna().unique():
    writer = ps.ExcelWriter('metadata_summaries/' + i + '.xlsx')
    userdf.loc[userdf['User_Tables']==i,include_cols].drop_duplicates().to_excel(writer, i[:31], index=False)
    metadata.loc[metadata['Column Name'].isin(include_cols),:].to_excel(writer, 'Column Descriptions', index=False)
    writer.save()