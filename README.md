# final_project

The main datasets used for this project exceed the Github file size limit (100MB). Therefore they cannot be included in this repository. 

To reproduce our work please download and save the following files in a folder named "data" in your own repository.  

# Final datasets

You may also use the final datasets available from: 

https://www.dropbox.com/scl/fo/9c04715s1hkowsf0vnk70/h?rlkey=7r3x8pm6y9nkcdiusfhmq2ulb&dl=0

# Build datasets

## 1. UK real estate transactions

http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv

Note that this is the complete dataset (1995-2022) and it is particularly heavy (28M observations / ~4.7Go)

If you just want to have an idea about what our code look like you can always use the 'rd_df.csv' dataset (which is a random sample of 10 000 lines).

## 2. Postcode to MLSOA (Middle Layer Super Output Area)

https://www.arcgis.com/sharing/rest/content/items/3770c5e8b0c24f1dbe6d2fc6b46a0b18/data

This file will be used to combine datasets with different geographical scales. 
Save it as 'postcode_to_area.csv'.

## 3. Income and population

Those datasets (pre-processed) are available directly from our Github. 
If you want the raw initial data please download and merge the following datasets. 

- Population (single file):
* https://www.nomisweb.co.uk/census/2011/postcode_headcounts_and_household_estimates
At the time we are writting this, we are still waiting for the data from the 2021 census to be available. 

- Income:
* https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/smallareaincomeestimatesformiddlelayersuperoutputareasenglandandwales/financialyearending2020/saiefy1920finalqaddownload280923.xlsx
/!\ This is not available as .csv so you need to save the Excel worksheet 'Total annual income' as a .csv file.
* https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/smallareaincomeestimatesformiddlelayersuperoutputareasenglandandwales/financialyearending2018/totalannualincome2018.csv
* https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/smallareaincomeestimatesformiddlelayersuperoutputareasenglandandwales/financialyearending2016/1totalannualincome.csv
* https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/smallareaincomeestimatesformiddlelayersuperoutputareasenglandandwales/financialyearending2014/1totalweeklyincome.csv
* https://www.ons.gov.uk/file?uri=/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/smallareaincomeestimatesformiddlelayersuperoutputareasenglandandwales/201112/1totalweeklyincome.csv

Data for the years 2012 and 2014 are weekly (instead of annual) income, we multiplied by 52 the 3 last columns. 
