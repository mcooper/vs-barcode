# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 15:35:50 2016

@author: mcooper
"""

import boto3 as bt
import psycopg2 as pg
import csv

#Read in credentials
file = 'D:/Documents and Settings/mcooper/GitHub/vitalsigns-data-reports/rds_settings'
reader = csv.DictReader(open(file))
for row in reader:
    d = row
    
#Connect to database
conn = pg.connect(host=d['host'], database='vitalsigns', user=d['user'], password=d['pass'], port=d['port'])
cur = conn.cursor()

#Get eplots
cur.execute('SELECT country, landscape_no, eplot_no, photo_e, photo_n, photo_s, photo_w FROM eplot')
eplot = []
for i in cur:
    code = i[0] + '-' + i[1] + '-' + i[2]
    if i[3]:
        eplot.append([code+'-e', i[3]])
    if i[4]:
        eplot.append([code+'-n', i[4]])
    if i[5]:
        eplot.append([code+'-s', i[5]])
    if i[6]:        
        eplot.append([code+'-w', i[6]])

#Get RRAs
cur.execute('SELECT country, rapid_road_asses_no, photo_e, photo_n, photo_s, photo_w, panorama FROM rra')
rra = []
for i in cur:
    code = i[0] + '-' + i[1].upper()
    if i[2]:
        rra.append([code+'-e', i[2]])
    if i[3]:
        rra.append([code+'-n', i[3]])
    if i[4]:
        rra.append([code+'-s', i[4]])
    if i[5]:
        rra.append([code+'-w', i[5]])
    if i[6]:
        rra.append([code+'-p', i[6]])
        
#Connect to s3 by manual loading credentials      
#AWS credentials stopped being read into ENV variables halfway through the session, for some reason.
f = open('D:/Documents and Settings/mcooper/.aws/credentials')
read = f.readlines()
access_key = read[1][20:-1]
secret_key = read[2][24:-1]
s3 = bt.client('s3', aws_access_key_id=access_key, aws_secret_access_key=secret_key)

#Get photos from vs2015v1
paginator = s3.get_paginator('list_objects')
pages = paginator.paginate(Bucket='vitalsigns-surveys-media-prod', Prefix='vs2015v1/attachments')
out1 = []
for p in pages:
    for x in p['Contents']:
        out1.append(x['Key'][21:])

#Get photos from vsadmin
paginator = s3.get_paginator('list_objects')
pages = paginator.paginate(Bucket='vitalsigns-surveys-media-prod', Prefix='vsadmin/attachments')
out2 = []
for p in pages:
    for x in p['Contents']:
        out2.append(x['Key'][20:])

#Copy Photos, hopefully
for i in rra:
    if i[1] in out1:
        s3.copy_object(CopySource={'Bucket':'vitalsigns-surveys-media-prod', 'Key':'vs2015v1/attachments/'+i[1]}, Bucket='vitalsigns-media-processed', Key=i[0]+'_'+i[1])
    elif i[1] in out2:
        s3.copy_object(CopySource={'Bucket':'vitalsigns-surveys-media-prod', 'Key':'vsadmin/attachments/'+i[1]}, Bucket='vitalsigns-media-processed', Key=i[0]+'_'+i[1])
    print(i[0])   

for i in eplot:
    if i[1] in out1:
        s3.copy_object(CopySource={'Bucket':'vitalsigns-surveys-media-prod', 'Key':'vs2015v1/attachments/'+i[1]}, Bucket='vitalsigns-media-processed', Key=i[0]+'_'+i[1])
    elif i[1] in out2:
        s3.copy_object(CopySource={'Bucket':'vitalsigns-surveys-media-prod', 'Key':'vsadmin/attachments/'+i[1]}, Bucket='vitalsigns-media-processed', Key=i[0]+'_'+i[1])
    print(i[0])











