# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:18:55 2016

@author: mcooper
"""

import os
import pandas as ps
import time

os.chdir('D:\Documents and Settings\mcooper\Documents\Automate Data Dictionaries\Version 2')

xls = os.listdir()

def getGroupIndices(ser):
    begin_indices = []
    end_indices = []
    ct = 0
    for i in ser:
        if i == 'begin group':
            begin_indices.append(ct)
            end_indices.append(999)
        if i == 'end group':
            ind = (len(end_indices) - 1) - end_indices[::-1].index(999)
            end_indices[ind] = ct
    return(zip(begin_indices, end_indices))
            
            

def str_index(string, substring, start):
    #Function to find substring starting from a specified position
    nstring = string[start:]
    ind = nstring.find(substring)
    if ind > -1:
        return(ind + start)
    else:
        return(len(string))

##Need to figure out how to incorporate notes!
def getDataFromXLSform(filename):
    raw = ps.read_excel(filename, sheetname=0)
    
    vartypes = 'date|text|time|select|string|calculate|decimal|image|int'
    
    #Subset data with simple variables
    ind = raw.type.str.contains(vartypes)
    ind[ind.isnull()] = False
    df = raw[ind]
    
    #get variables with select* types
    ind2 = raw.type.str.contains('select*')
    ind2[ind2.isnull()] = False
    selectvar = raw.type[ind2]
    
    choices = ps.read_excel(filename, sheetname=1).dropna(subset=['list name'])

    selects = ps.DataFrame()
    for i in choices['list name'].unique():
        sub = choices[choices['list name']==i]
        d = str(dict(zip(sub.name, sub.label)))
        for j in selectvar:
            if i in j and i!='y':
                joinvar = j
                newdf = ps.DataFrame(data={'joinvar': [joinvar], 'list_name': [i], 'values': [d]})
                selects = selects.append(newdf)
        
    df=df.merge(selects.drop_duplicates(), how='outer', left_on=['type'], right_on=['joinvar'], left_index=True)
    
    formname = ps.read_excel(filename, sheetname=2)['form_id'].to_string(index=False)
    df.loc[:,('form_name')] = formname

    return(df)

allxls = ps.DataFrame() #Empty accumulator
for x in xls:
    out = getDataFromXLSform(x)
    allxls = allxls.append(out)

allxls.to_excel('../XLS_forms_summary_' + time.strftime("%d-%m-%Y_%I-%M-%S") +'.xlsx', index=False)



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
















