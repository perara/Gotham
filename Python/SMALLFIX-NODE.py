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
	cursor.execute("SELECT * FROM node")
	nodes = cursor.fetchall()
	
	for node in nodes: 
		nodeId = node["id"]
		networkId = node["network"]
		
		cursor.execute("UPDATE network SET node = %s WHERE id = %s", (nodeId, networkId))
		
		


	connection.commit()
	
	
	
	
	
	connection.close()