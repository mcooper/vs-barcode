# -*- coding: utf-8 -*-
"""
Created on Mon Apr 11 14:56:40 2016

@author: mcooper
"""

import pandas as ps
import os

os.chdir('D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/')
XLSvars = ps.read_excel('XLS_forms_summary.xlsx', sheetname=0)
DBvars = ps.read_csv('DbViewMapping.csv')

os.chdir('D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/vitalsigns-data-apps/lib/forms/versions')

#Manual Mapping between formnames and ruby code scripts:
#Normally, this shouldn't have to happen manullly, if we standardize form/migration script naming conventions
mapping = {'agriculture_survey_17_sep_2015v1': 'agriculture_survey_02_jul_2015v3.rb',
 'eplot_17_sep_2015_v1': 'eplot_02_jul_2015_v1.rb',
 'eplot_soil_lab_17_sep_2015_v1': 'eplot_soil_lab_02_jul_2015_v1.rb',
 'ffs_17_sep_2015_v1': 'ffs_02_jul_2015_v1.rb',
 'ffs_lab_17_sep_2015_v1': 'ffs_lab_02_jul_2015_v1.rb',
 'ffs_yields_dry_weight_17_sep_2015_v1': 'ffs_yields_dry_weight_02_jul_2015_v1.rb',
 'ffs_yields_maize_17_sep_2015_v1': 'ffs_yields_maize_02_jul_2015_v1.rb',
 'house_hold_17_sep_2015_v1': 'house_hold_02_jul_2015_v1.rb',
 'rapid_road_17_sep_2015_v1': 'rapid_road_02_jul_2015_v1.rb',
 'rapid_water_17_09_2015_v1': 'rapid_water_02_07_2015_v1.rb',
 'soils_eplot_sample_17_sep_2015_v1': 'soils_eplot_sample_17_09_2015_v1.rb',
 'water_lab_17_sep_2015_v1': 'water_lab_02_jul_2015_v1.rb'}
 
for i in set(XLSvars['form_name']):
    f = open(mapping[i], 'r')
    ruby = []
    for l in f.readlines():
        ruby.append(l.strip('\n'))