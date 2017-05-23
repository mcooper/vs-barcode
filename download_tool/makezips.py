import boto3
import zipfile
import os

#Read in data, skipping words already in buck
s3client = boto3.client('s3')
s3resource = boto3.resource('s3')

bucket = s3resource.Bucket('vitalsigns-website-downloads')

tables = []
for k in bucket.objects.all():
    if k.key[:6] == 'tables':
        tables.append(k.key)

allzip = zipfile.ZipFile('allfiles.zip', 'w', zipfile.ZIP_DEFLATED)
for t in tables[1:]:
    f = t[7:len(t)-4]
    print(f)
    
    table = s3client.get_object(Bucket='vitalsigns-website-downloads', Key=t)
    meta = s3client.get_object(Bucket='vitalsigns-website-downloads', Key='Metadata/' + f + ' codebook.csv')
    
    with open(f + '.csv', 'w') as temp1:
        temp1.write(table['Body'].read())

    with open(f + ' codebook.csv', 'w') as temp2:
        temp2.write(meta['Body'].read().replace('\r\n', '\n'))
    
    tempzip = zipfile.ZipFile(f + '.zip', 'w', zipfile.ZIP_DEFLATED)
    
    tempzip.write(f + '.csv')
    tempzip.write(f + ' codebook.csv')
    tempzip.close()
    
    allzip.write(f + '.csv')
    allzip.write(f + ' codebook.csv')
    
    os.system('aws s3 cp ' + f + '.zip s3://vitalsigns-website-downloads/Zips/' + f + '.zip')
    
allzip.close()

os.system('aws s3 cp allfiles.zip s3://vitalsigns-website-downloads/Zips/allfiles.zip')