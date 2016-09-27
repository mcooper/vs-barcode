# -*- coding: utf-8 -*-
"""
Created on Thu Apr  7 11:26:08 2016

@author: mcooper
"""
#Get all user-facing views from db and their definitions using:
#  SELECT viewname, definition FROM pg_views WHERE viewname LIKE 'curation%'
#Make that a table called 'ViewDefinitions.txt'


import pandas
import os

os.chdir('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/')

defs = pandas.read_table('ViewDefinitions.txt')

def gettables(sql):
    sql = sql.replace('\n', '')
    splits = sql.split()
    
    #Get all variables with a table name
    variables = []
    for s in splits:
        if '.' in s:
            variables.append(s)

    #Get all tables (text before a '.')
    tables = []
    for v in variables:
        if '(' in v:
            tables.append(v[(v.rindex("(")+1):v.index('.')])
        else:
            tables.append(v[:v.index('.')])
    tables = set(tables)
    
    #Get all tables that have been aliased
    #Tables are aliased if it can be found between two spaces
    aliased = {}
    for t in tables:
        if ' ' + t + ' ' in sql:
            aliased[t] = sql.rindex(' ' + t + ' ')
    
    #get the aliases for those tables that have been aliased
    #an alias is the word comes before any any table that is known to be aliased
    badalias = ''
    alias = {}
    for a in aliased:
        #check to see if this is an instance of a query being aliased, with the name of the alias being the name of the actual table from the subquery
        #this happened with the eplotsoils tables, because of the SELECT DISTINCT clause
        neighborhood = sql[(aliased[a]-100):(aliased[a]+len(a)+1)]
        neighbors = neighborhood.split(' ')
        if neighbors[-3:].count(a) > 1:
            badalias = neighbors[-2].rstrip(')')
        else:
            alias[a] = (sql[(sql.rindex(' ',0,aliased[a])):aliased[a]]).strip(' ("')
    
    #turealiases are those that did not come before a WITH or a JOIN
    truealiases = {}
    for a in alias:
        if alias[a] != 'WITH' and alias[a] != 'JOIN' and alias[a][-1] != ')':
            truealiases[a] = alias[a]        
    tabled = {}
    for i in tables:
        if i in truealiases:
            tabled[i.strip('"')] = truealiases[i.strip('"')]
        elif i != badalias:
            tabled[i.strip('"')] = i.strip('"')
    
    #{'alias': 'tablename}
    return tabled
    
def getvariables(sql, tabled):   
    
    #Ignore everything after a SELECT DISTINCT clause (ad-hoc eplot error fix)
    if 'SELECT DISTINCT' in sql:
        sql = sql[:sql.rindex('SELECT DISTINCT')]
        
    #Finds the variables ennumerated between SELECT and FROM
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
                dbvars.append((s[(s.index('.')+1):s.index('AS')]).strip('()," '))
                viewvars.append((s[(s.index('AS')+2):]).strip('," '))
            elif s.count('.') > 1:
                inds = [i for i in range(len(s)) if s.startswith('.', i)]
                for i in range(0,len(inds)):
                    if i == 0:
                        dbtables.append(tabled[(s[s.rfind('(',0,inds[i]):inds[i]]).strip(',() |.')])
                        dbvars.append((s[inds[i]:s.find(')',inds[i])]).strip(',() |.'))
                        viewvars.append((s[(s.index('AS')+2):]).strip('," .'))
                    else:
                        dbtables.append(tabled[(s[s.rfind('|',0,inds[i]):inds[i]]).strip(',() |.')])
                        dbvars.append((s[inds[i]:s.find(')',inds[i])]).strip(',() |.'))
                        viewvars.append((s[(s.index('AS')+2):]).strip('," .'))                      
        else:
            if s.count('.') == 1:
                dbtables.append(tabled[(s[:s.index('.')]).strip('," ')])
                dbvars.append((s[(s.index('.')+1):s.index(',')]).strip('," '))
                viewvars.append((s[(s.index('.')+1):s.index(',')]).strip('," '))        
            if s.count('.') > 1:
                #this is the worst error message I've ever seen
                print('I\'m pretty sure this isn\'t possible')
                
    return([dbtables, dbvars, viewvars])

adbtabs = []
adbvars = []
avwvars = []
avwtabs = []
for i in range(0,defs.shape[0]):
    try:
        sql = defs['definition'][i]
        tb = gettables(sql)
        ot = getvariables(sql, tb)
        adbtabs = adbtabs + ot[0]
        adbvars = adbvars + ot[1]
        avwvars = avwvars + ot[2]
        avwtabs = avwtabs + [defs['viewname'][i]]*len(ot[1])
    except:
        print(defs.loc[i, ])

table = [adbtabs, adbvars, avwvars, avwtabs]
df = pandas.DataFrame(table)
df = df.transpose()
df.to_csv('DbViewMapping.csv', index=False, header=['DB_Tables', 'DB_Vars', 'User_Vars', 'User_Tables'])

            