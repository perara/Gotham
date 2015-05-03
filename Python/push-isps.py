import pymysql.cursors
import json
from decimal import *
import time

connection = pymysql.connect(host='localhost',
                             user='root',
                             passwd='root',
                             db='gotham',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

with connection.cursor() as cursor:

	json_data=open("isp-load-statistics.py").read()
	data = json.loads(json_data)
	
	countryFixes = {
		"Curacao": "CW",
		"Saint Martin": "MF",
		"Bonaire, Statia & Saba": "BQ",
		"Aland Islands": "AX",
		"DR Congo": "CG",
		"Reunion": "FR",
		"Macau": "MO",
		"Laos": "LA",
		"St. Vincent and Grenadines": "VC",
		"Cote D'Ivoire": "CI",
		"Taiwan": "TW",
		"Vietnam": "VN",
		"South Korea": "KR",
		"Palestinian Territory": "PS",
		"Republic of Moldova": "MD",
		"Kazakstan": "KZ",
		"Bolivia": "BO",
		"Tanzania": "TZ",
		"Macedonia": "MK",
		"Venezuela": "VE",
		"Russia": "RU"
	
	}
	
	# Fix some country codes
	for i in data: 
		if i["country"] is None:
			continue
			
		if "Unknown" in i["countryCode"]:
			i["countryCode"] = countryFixes[i["country"]]
		print(i["countryCode"] + " ||||| " + i["country"])
		
		
	print("------------------------------------------")
	print("------------------------------------------")
	print("------------------------------------------")
	print("Time to push to DB:")
	for country in data:
		for isp in country["isps"]:
			cursor.execute("INSERT INTO isp(name, country, ip_addresses, test_count) VALUES (%s,%s,%s,%s)", (isp["label"], country["countryCode"], isp["ip_addresses"], isp["test_count"]))
		


	connection.commit()
	
	
	
	
	
	connection.close()