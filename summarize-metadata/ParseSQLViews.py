# -*- coding: utf-8 -*-
"""
Created on Thu Apr  7 11:26:08 2016

@author: mcooper
"""
#Get all user-facing views from db and their definitions using:
#  SELECT viewname, definition FROM pg_views WHERE viewname LIKE 'curation%'
#Make that a table and then read it in

import pandas
import os

os.chdir('D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/')

defs = pandas.read_table('ViewDefinitions.txt')

def gettables(sql):
    sql = sql.replace('\n', '')
    splits = sql.split()
    
    #Get all variables with a table name
    variables = []
    for s in splits:
        if '.' in s:
            variables.append(s)

    #Get tables    
    tables = []
    for v in variables:
        if '(' in v:
            tables.append(v[(v.rindex("(")+1):v.index('.')])
        else:
            tables.append(v[:v.index('.')])
    tables = set(tables)
       
    #Check for aliasing
    aliased = {}
    for t in tables:
        if ' ' + t + ' ' in sql:
            aliased[t] = sql.index(' ' + t + ' ')
    alias = {}
    for a in aliased:
        alias[a] = (sql[(sql.rindex(' ',0,aliased[a])):aliased[a]]).strip(' ("')
    
    truealiases = {}
    for a in alias:
        if alias[a] != 'WITH' and alias[a] != 'JOIN':
            truealiases[a] = alias[a]        
    tabled = {}
    for i in tables:
        if i in truealiases:
            tabled[i.strip('"')] = truealiases[i.strip('"')]
        else:
            tabled[i.strip('"')] = i.strip('"')
    
    return tabled
    
def getvariables(sql, tabled):
    #Finds the variables ennumerated between SELECT and FROM
    #Finds the last 
    sql = sql[(sql.rindex('SELECT')+6):sql.rindex('FROM')]
    sqls = sql.split('\n')
    sqls = [s for s in sqls if not 'severity' in s and len(s)>0 and "CASE" not in s and "WHEN" not in s and "ELSE" not in s and "END" not in s]
    dbtables = []
    dbvars = []
    viewvars = []
    for s in sqls:
        if 'AS' in s:
            if s.count('.') == 1:
                dbtables.append(tabled[(s[s.rfind(' ',0,s.index('.')):s.index('.')]).strip('," ')])
                dbvars.append((s[(s.index('.')+1):s.index('AS')]).strip('," '))
                viewvars.append((s[(s.index('AS')+2):]).strip('," '))
            if s.count('.') > 1:
                inds = [i for i in range(len(s)) if s.startswith('.', i)]
                for i in range(0,len(inds)):
                    if i == 0:
                        dbtables.append(tabled[(s[s.rfind('(',0,inds[i]):inds[i]]).strip(',() |.')])
                        dbvars.append((s[inds[i]:s.find(')',inds[i])]).strip(',() |.'))
                        viewvars.append((s[(s.index('AS')+2):]).strip('," .'))
                    else:
                        dbtables.append((s[s.rfind('|',0,inds[i]):inds[i]]).strip(',() |.'))
                        dbvars.append((s[inds[i]:s.find(')',inds[i])]).strip(',() |.'))
                        viewvars.append((s[(s.index('AS')+2):]).strip('," .'))                      
        else:
            if s.count('.') == 1:
                dbtables.append(tabled[(s[:s.index('.')]).strip('," ')])
                dbvars.append((s[(s.index('.')+1):s.index(',')]).strip('," '))
                viewvars.append((s[(s.index('.')+1):s.index(',')]).strip('," '))        
            if s.count('.') > 1:
                print('I\'m pretty sure this isn\'t possible')
    return([dbtables, dbvars, viewvars])

adbtabs = []
adbvars = []
avwvars = []
avwtabs = []
for i in range(0,70):
    sql = defs['definition'][i]
    tb = gettables(sql)
    ot = getvariables(sql, tb)
    adbtabs = adbtabs + ot[0]
    adbvars = adbvars + ot[1]
    avwvars = avwvars + ot[2]
    avwtabs = avwtabs + [defs['name'][i]]*len(ot[1])

table = [adbtabs, adbvars, avwvars, avwtabs]
df = pandas.DataFrame(table)
df = df.transpose()
df.to_csv('DbViewMapping.csv', index=False, header=['DB_Tables', 'DB_Vars', 'User_Vars', 'User_Tables'])
    
#This is just to make sure all the definitions are formatted the same
#should not be run
    
'''
for i in range(0,70):
    sql = defs['definition'][i]
    sql = sql.replace('\n', '')
    whilect = sql.count('WITH')
    whileind = sql.find('WITH')
    selectct = sql.count('SELECT')
    selectind = sql.index('SELECT')
    fromct = sql.count('FROM')
    fromind = sql.rindex('FROM')
    print(str(i) + 'WHILE: ' + str(whilect) + ' ' + str(whileind) + '   SELECT: ' + str(selectct) + ' ' + str(selectind) + '   FROM: ' + str(fromct) + ' ' + str(fromind) + defs['name'][i])
    
            
for i in range(0,70):
    sql = defs['definition'][i]
    print(str('autoqa_severity' in sql) + '  ' + defs['name'][i])
            
'''
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            