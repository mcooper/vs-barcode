# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 11:34:36 2016

@author: mcooper
"""

import os
import pandas as ps
import time

os.chdir('D:\Documents and Settings\mcooper\Documents\Automate Data Dictionaries')

mapping = ps.read_excel('Treasure Map.xlsx', sheetname=0)
xls_summary = ps.read_excel('XLS_forms_summary.xlsx', sheetname=0)
db_schema = ps.read_excel(')