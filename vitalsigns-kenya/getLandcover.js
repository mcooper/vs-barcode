//Read in GIS data
var geom = ee.FeatureCollection('users/mcooper/geometries');
var red = ee.Reducer.frequencyHistogram();

//Setup for loop
var myStringArray = ["2010", "2005", "2000", "1995", "1990"];
var arrayLength = myStringArray.length;

for (var i = 0; i < arrayLength; i++) {
  var img = ee.Image('users/mcooper/SLEEK_' + myStringArray[i]);


  var hist = img.reduceRegions(geom, red);
  
  // Export the FeatureCollection.
  Export.table.toDrive({
    collection: hist,
    description: 'S' + myStringArray[i],
    fileFormat: 'CSV'
  });
}