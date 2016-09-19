# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 11:34:36 2016

@author: mcooper
"""

import os
import pandas as ps
import np

os.chdir('D:\Documents and Settings\mcooper\Documents\Automate Data Dictionaries')

#Manually created mapping
mapping = ps.read_excel('Formhub-DB Mapping.xlsx', sheetname=0)

#Result of Parse XLSforms.py
xls_summary = ps.read_excel('XLS_forms_summary.xlsx', sheetname=0)

#Result of ParseSQLViews.py
db_schema = ps.read_csv('DbViewMapping.csv')

def cleanXLSsummary(df):
    df.loc[:,'relevant'] = df.loc[:,'bind:relevant'] + df.loc[:,'relevant']    
    df.loc[:,'constraint'] = df.loc[:,'bind:constraint'] + df.loc[:,'constraint']
    df = df.loc[:,('required', 'relevant', 'constraint', 'calculation', 'choice_filter', 'constraint_message', 'form_name', 'hint', 'label', 'name', 'notes', 'values')]
    df.loc[df['required']=='true()', 'required'] = 'yes'
    
    #Could use regex to remove question numbers from lable
    #df.loc[df['label'].str.contains('^(.?)[0-9](.?)') & ~df['label'].isnull(),'label']

    return(df)

def cleanDBschema(df):
    df.loc[:,'User_Tables'] = df.User_Tables.str.replace('curation__', '')
    df = df.loc[~df.DB_Vars.str.contains('uuid')]
    df = df.loc[~df.User_Tables.str.contains('_pii')]
    df = df.loc[~df.DB_Tables.isin(['weatherdata', 'weatherstation', 'eplotsoils_processed', 'farmfieldsoils_processed'])]
    return(df)
    
def cleanPlantSpecies(df):
    #delete where User_Tables and form_name dont map and where dbtable = plant_species
    #then, delete where User_Vars and name dont map and where User_Tables=eplot_subplot_vegetation
    df = views_xls
    df['combine_tables'] = df['User_Tables'] + '+' + df['form_name']
    df['combine_vars'] = df['name'] + '+' + df['User_Vars']
    tablemap = ['eplot_subplot_vegetation+eplot_15_may_2016_v1', 'rra_dominant+rapid_road_15_may_2016_v1', 'eplot_woody_plant+eplot_15_may_2016_v1']
    varmap = ['subplot_rank1_common+Common Name Ranked 1', 'subplot_rank2_common+Common Name Ranked 2', 'subplot_rank3_common+Common Name Ranked 3',
              'subplot_rank1_genus+Genus Ranked 1', 'subplot_rank2_genus+Genus Ranked 2', 'subplot_rank3_genus+Genus Ranked 3', 
              'subplot_rank1_species_select+Species Ranked 1', 'subplot_rank2_species_select+Species Ranked 2', 'subplot_rank3_species_select+Species Ranked 3',
              'subplot_rank1_subspecies+Subspecies Ranked 1', 'subplot_rank2_subspecies+Subspecies Ranked 2', 'subplot_rank3_subspecies+Subspecies Ranked 3',
              'subplot_tree_common+Common Name', 'subplot_tree_genus+Genus', 'subplot_tree_species_select+Genus', 'subplot_tree_species_select+Species',
              'subplot_tree_species+Species', 'subplot_tree_subspecies+Subspecies'] 
    df = df.loc[~(df['dbtable'].isin(['plant_species', np.NaN])) | df['combine_tables'].isin(tablemap),:]
    df = df.loc[~(df['User_Tables'].isin(['eplot_subplot_vegetation', 'eplot_woody_plant', np.NaN])) | df.combine_vars.isin(varmap),:]
    del df['combine_tables']
    del df['combine_vars']
    return(df)

xls_summary = cleanXLSsummary(xls_summary)
db_schema = cleanDBschema(db_schema)

views_mapping = db_schema.merge(right=mapping, left_on=['DB_Vars', 'DB_Tables'], right_on=['dbvar', 'dbtable'], how='outer')

views_xls = views_mapping.merge(right=xls_summary, left_on=['odkvar', 'May 2016'], right_on=['name', 'form_name'], how='outer')

#views_xls = cleanPlantSpecies(views_xls)

metadata_definition = [
    ['User_Vars',       'The name of the variables in the views that users downloadas parsed from the view definition scripts'],
    ['User_Tables',     'The name of the views that users download, as parsed from the view definition scripts'],
    ['DB_Vars',         'The name of the variable in the database, as parsed from the view definition scripts'],
    ['DB_Tables',       'The name of the table in the database, as parsed from the view definition scripts'],
    ['form_name',       'The name of the ODK form that the teams used to collect the data'],
    ['source',          'Where the variable came from - can be from ODK directly, or a linking or pivot variable introduced between formhub and the database'],
    ['odkvar',          'The name of the variable in ODK, as described in "Formhub-DB mapping.xlsx"'],
    ['dbvar',           'The name of the variable in the database, as described in "Formhub-DB mapping.xlsx"'],
    ['dbtable',         'The name of the table in the database, as described in "Formhub-DB mapping.xlsx"'],
    ['September 2015',  'The name of the form that the variable came from in the September 2015 versions of the forms'],
    ['May 2016',        'The name of the form that the variable came from in the May 2016 versions of the forms'],
    ['name',            'From ODK: The name of the variable in the ODK form that the teams used to collect the data. This is the name of the variable in the "required", "relevant", "constrant", "calculation" and "choice_filter" calculations'],
    ['required',        'From ODK: If the variable was required to be answered, can be "yes" or a conditional statement describing when the variable is required'],
    ['relevant',        'From ODK: Describes whether the variable should be asked'], 
    ['constraint',      'From ODK: Describes the constraints on the variable being entered'],
    ['calculation',     'From ODK: Describes the calculation used to generate the variable'],
    ['choice_filter',   'From ODK: Describes the available choices in select/categorical variable types'],
    ['constraint_message', 'From ODK: The text displayed to data collecters when a variable violates the constraint condition'],
    ['hint',            'From ODK: A hint given to data collectors describing how to collect or enter the data'],
    ['label',           'From ODK: The label given to an ODK variable.  This is usually where the actual question is presented'],
    ['notes',           'From ODK: Any notes given before ODK brings up a variable.  Sometimes this is where the actual question is presented'], 
    ['values',          'From ODK: The possible values that can be selected for a select one or select many variable type']
]
    
metadata = ps.DataFrame(metadata_definition, columns=['Column Name', 'Column Description'])

pipeline_writer = ps.ExcelWriter('metadata_summaries/_pipeline_summary.xlsx')
views_xls.to_excel(pipeline_writer, 'Metadata Summary', index=False)
metadata.to_excel(pipeline_writer, 'Column Descriptions', index=False)
pipeline_writer.save()

include_cols = ['User_Vars', 'source', 'label', 'notes', 'constraint_message', 'hint', 'values', 'name', 'required', 'relevant', 'constraint', 'calculation']

for i in views_xls['User_Tables'].dropna().unique():
    writer = ps.ExcelWriter('metadata_summaries/' + i + '.xlsx')
    views_xls.loc[views_xls['User_Tables']==i,include_cols].to_excel(writer, i[:31], index=False)
    metadata.loc[metadata['Column Name'].isin(include_cols),:].to_excel(writer, 'Column Descriptions', index=False)
    writer.save()