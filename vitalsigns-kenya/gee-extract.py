import ee
import pandas as pd
import time

ee.Initialize()

#Get PAs
PA = ee.Image('users/mcooper/wdpa')

#Get full raster stack
forest12 = ee.Image("UMD/hansen/global_forest_change_2013")
forest15 = ee.Image("UMD/hansen/global_forest_change_2015_v1_3")

#Get tree cover for 2000 as a binary raster
forest00 = forest12.select('treecover2000').where(forest12.select('treecover2000').gte(10), 1).where(forest12.select('treecover2000').lt(10), 0)

#Get 
fcover12 = forest00.add(forest12.select('gain')).subtract(forest12.select('loss'))
fcover15 = forest00.add(forest15.select('gain')).subtract(forest15.select('loss'))

#Get permanent water bodies and areas of no data
#   0 No Forest
#   1 Forest
#   2 Water Bodies
#   9 No Data
fcover12 = fcover12.where(forest12.select('datamask').eq(2), 2).where(forest12.select('datamask').eq(0), 9)
fcover15 = fcover15.where(forest15.select('datamask').eq(2), 2).where(forest15.select('datamask').eq(0), 9)


#Get all cci land cover
cci00 = ee.Image("users/geflanddegradation/lcov/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2000-v207")
cci10 = ee.Image("users/geflanddegradation/lcov/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v207")
cci15 = ee.Image("users/geflanddegradation/lcov/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v207")

pop15 = ee.Image("CIESIN/GPWv4/population-count/2015")
mkt10 = ee.Image("users/mcooper/TT_50K--SSA1")


sp = ee.FeatureCollection('users/mcooper/geometries')

features = [PA, fcover12, fcover15, forest00, cci00, cci10, cci15]
labels =   ['PA', 'f12',  'f15',    'f00',  'cci00', 'cci10','cii15']

accum = pd.DataFrame()
for f in range(0, len(features)):
    out = features[f].reduceRegions(reducer=ee.Reducer.frequencyHistogram(), collection=sp).getInfo()
    
    for i in out['features']:
        d = i['properties']['histogram']
        d['area_ha'] = i['properties']['area_ha'] 
        d['type'] = i['properties']['type']
        d['id'] = i['properties']['id']
        d['name'] = i['properties']['name']
    
        temp = pd.DataFrame(d, index = [0])
        
        temp['dataset'] = labels[f]
        
        accum = accum.append(temp)

    time.sleep(1)

    print(labels[f])

out = pop15.reduceRegions(reducer=ee.Reducer.sum(), collection=sp).getInfo()
for i in out['features']:
    d = i['properties']

    temp = pd.DataFrame(d, index = [0])
    
    temp['dataset'] = 'population'
    
    accum = accum.append(temp)

time.sleep(1)
    
print('population')

out = mkt10.reduceRegions(reducer=ee.Reducer.mean(), collection=sp).getInfo()
for i in out['features']:
    d = i['properties']

    temp = pd.DataFrame(d, index = [0])
    
    temp['dataset'] = 'market'
    
    accum = accum.append(temp)

time.sleep(1)

print('market')

accum.to_csv('D://Documents and Settings//mcooper//GitHub/vs-data-tools//vitalsigns-kenya//ee_output.csv', index=False)