# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:18:55 2016

@author: mcooper
"""

import os
import pandas as ps

os.chdir('D:\Documents and Settings\mcooper\Documents\Staging Form and DD Updates\XLS forms')

xls = os.listdir()

def str_index(string, substring, start):
    #Function to find substring starting from a specified position
    nstring = string[start:]
    ind = nstring.find(substring)
    if ind > -1:
        return(ind + start)
    else:
        return(len(string))
    
def getDataFromXLSform(filename):
    raw = ps.read_excel(filename, sheetname=0)
    
    vartypes = 'start|end$|today|date|text|time|select.one*|select1|string|calculate|decimal|image|integer'
    
    #Subset data with simple variables
    ind = raw.type.str.contains(vartypes)
    ind[ind.isnull()] = False
    df = raw[ind]
    
    #Subset data with 'select multiple' variables
    ind2 = raw.type.str.contains('select.multiple*|select all that apply')
    ind2[ind2.isnull()] = False
    one2manyvar = raw.name[ind2]
    
    choices = ps.read_excel(filename, sheetname=1)
    
    for i in one2manyvar:
        #Get the list name for the variable
        multivar = raw['type'][raw['name']==i].to_string(index=False)
        try:
            start = multivar.index('multiple ') + 9
        except ValueError:
            start = multivar.index('select all that apply from ') + 27
        end = str_index(multivar, ' ', start)
        choice_list = multivar[start:end]
        
        #Select appropriate list from choices tab, add other option if necessary and delete other tables
        sel = choices[choices['list name']==choice_list]
        if 'other' in multivar:
            sel = sel.append(ps.DataFrame(data={'name': 'other', 'label':'other'}, index=[1]))
        for name in sel.columns.values:
            if name not in ['type', 'name']:
                del sel[name]
        
        #Reformat names of select multiple variables
        newname = []
        for n in sel['name']:
            newname.append(i + '/' + str(n))
        sel.loc[:,('name')] = newname
    
        #Fill in columns based on variable metadata from form
        for c in df.columns.values:
            if c not in sel.columns.values and not ps.isnull(raw[c][raw['name']==i]).bool():
                sel.loc[:,(c)] = (raw[c][raw['name']==i]).to_string(index=False)
    
        df = df.append(sel)
    
    formname = ps.read_excel(filename, sheetname=2)['form_id'].to_string(index=False)
    df.loc[:,('form_name')] = formname

    return(df)

allxls = ps.DataFrame() #Empty accumulator
for x in xls:
    out = getDataFromXLSform(x)
    allxls = allxls.append(out)

allxls.to_excel('../XLS_forms_summary.xlsx', index=False)



#Testing and exploring - do not run:
'''
import os
import pandas as ps

os.chdir('D:\Documents and Settings\mcooper\Documents\Staging Form and DD Updates\XLS forms')

xls = os.listdir()

allxls2 = ps.DataFrame() #Empty accumulator

for x in xls:
    raw = ps.read_excel(x, sheetname=0)

    formname = ps.read_excel(x, sheetname=2)['form_id'].to_string(index=False)
    raw.loc[:,('form_name')] = formname
    
    allxls2 = allxls2.append(raw)
    
    
excluded = []
for i in set(allxls2['type']):
    if i not in set(allxls['type']):
        excluded.append(i)

'''
















