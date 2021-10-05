import csv

import pandas as pd
import requests

from utils import *

CSV_URL = "https://covid.ourworldindata.org/data/owid-covid-data.csv"

class Data: 
    def __init__(self, dowloadData=False, location = 'Canada', column_names= []):
        self.dowloadData = dowloadData
        if (dowloadData):
            self.getDataFromOurWorldData()
        self.readData()
        self.location = location
        self.column_names = column_names
        self.df_location = self.getDFForLocation(location=location)
        self.getDataParsed()
        
    
    def getDataFromOurWorldData(self):
        with requests.Session() as s:
            download = s.get(CSV_URL)
            decoded_content = download.content.decode('utf-8')
            csv_file = csv.reader(decoded_content.splitlines(), delimiter=',')
            with open('data.csv', 'w', newline='') as file:
                writer = csv.writer(file)
                writer.writerows(csv_file)

    def readData(self):
        self.df = pd.read_csv('data.csv')

    def displayDfMetrics(self):
        print(list(self.df.columns.values))
        print(list(self.df.dtypes))

    def getListLocations(self): 
        locations = self.df['location'].unique()

    def getDFForLocation(self, location):
        locations = self.df['location'].unique()
        if (location in locations):
            df = self.df.loc[self.df['location'] == location]
            return df
        else:
            print("Please select a valid country. Here is the list of countries available: ")
            print(locations)

    def getDataParsed(self):
        data_parsed = {}
        date = self.df_location['date'].values
        data_parsed['dates'] = date
        col_names = list(self.df_location.columns.values)
        for name in col_names:
            if (name in self.column_names):
                data_parsed[name] = list(self.df_location[name].values)
        self.data_parsed = data_parsed
        return data_parsed

