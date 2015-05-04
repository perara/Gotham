import pymysql.cursors
import json
from decimal import *
import time
import random


connection = pymysql.connect(host='localhost',
                             user='root',
                             passwd='root',
                             db='gotham',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

with connection.cursor() as cursor:
	cursor.execute("SELECT * FROM isp")
	isps = cursor.fetchall()
	isps_sort = {}
	
	# Sort isps by country
	for isp in isps:
		# Create Array for country if not exists
		if isp["country"] not in isps_sort:
			isps_sort[isp["country"]] = []
		isps_sort[isp["country"]].append(isp)
		

	cursor.execute("SELECT * FROM country_ip WHERE owner = %s", ("None",))
	providers = cursor.fetchall()
	
	for provider in providers:
		country = provider["country"]
	
		# GQ does not exist
		if country == "GQ":
			country = "GA"
		if country == "KM":
			country = "MZ"
		if country == "PM":
			country = "US"
		if country == "PW":
			country = "PH"
		if country == "CV":
			country = "SN"
		if country == "BW":
			country = "ZA"
		if country == "VU":
			country = "AU"
		if country == "DJ":
			country = "ET"
		if country == "TD":
			country = "NG"
		if country == "GW":
			country = "SN"
		if country == "AS":
			country = "AU"
		if country == "ST":
			country = "FR"
		if country == "TG":
			country = "GH"
		if country == "WS":
			country = "AU"
		if country == "TL":
			country = "ID"
		if country == "TV":
			country = "AU"
		if country == "NR":
			country = "AU"
		if country == "PG":
			country = "AU"
		if country == "CK":
			country = "GB"
		if country == "BJ":
			country = "NG"
		if country == "MW":
			country = "TZ"
		if country == "FM":
			country = "AU"
		if country == "CD":
			country = "AU"	
		if country == "PF":
			country = "FR"	
		if country == "RE":
			country = "US"
		if country == "VA":
			country = "IT"
			
			
		newIsp = random.choice(isps_sort[country])
		
		cursor.execute("UPDATE country_ip SET owner = %s WHERE id = %s", (newIsp["name"], provider["id"]))
		
		
		
		
	
	
	
	

	connection.commit()
	
	
	
	
	
	connection.close()