import pymysql.cursors
import json
from decimal import *
import time
from math import radians, cos, sin, asin, sqrt

def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    r = 6371 # Radius of earth in kilometers. Use 3956 for miles
    return c * r

connection = pymysql.connect(host='hybel.keel.no',
                             user='root',
                             passwd='%hidden%',
                             db='gotham',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

with connection.cursor() as cursor:
	cursor.execute("SELECT * FROM node")
	nodes = cursor.fetchall()
	
	""""one = (40.78599913,-72.69482174)
	two = (40.78035187,-72.77519817)
	distance = vincenty(one,two).km
	print(distance)
	
	exit()
	"""
	
	
	count = 0
	
	blacklist = []
	for node in nodes: 
		n1 = (node["lat"], node["lng"])


		for node2 in nodes: 
			n2 = (node2["lat"], node2["lng"])
			
	
			if node == node2:
				continue
				
			if node2 in blacklist:
				continue
				
			
			
				
			distance = haversine(node["lng"], node["lat"], node2["lng"], node2["lat"])

			if distance < 10:
				count = count + 1
				print("---------------------------------------------")
				print("Case #{0}".format(count))
				print("Node #1: {0}".format(str(node["id"])))
				print("Node #2: {0}".format(str(node2["id"])))
				print("Distance: {0}".format(str(distance)))
				print("---------------------------------------------")
				cursor.execute("SELECT cable FROM node_cable WHERE node=%s", node["id"])
				node_1_cables = cursor.fetchall()
				node_1_cables = [item["cable"] for item in node_1_cables]
				
				cursor.execute("SELECT cable FROM node_cable WHERE node=%s", node2["id"])
				node_2_cables = cursor.fetchall()
				node_2_cables = [item["cable"] for item in node_2_cables]
				
				# Start merging Node 1 and Node 2
				unique_cables = []
				delete_cables = []
				for cable in node_1_cables:
					if int(cable) not in node_2_cables:
						unique_cables.append(cable)
					else:
						delete_cables.append(cable)
						
				print("Having " + str(len(node_1_cables)) + " only " + str(len(unique_cables)) + " are unique")
				
				# Delete duplicates
				for cable in delete_cables:
					print("Deleting cable {0}".format(str(cable)))
					cursor.execute("DELETE from node_cable WHERE node=%s AND cable=%s",(node["id"],cable))
					
				# Update pointers from Node 1 to node 2
				# UPDATE WHERE node 1 set node 2
				print(node["id"])
				print(node2["id"])
				print(delete_cables)
				print(node_1_cables)
				print("UPDATE node_cable SET node={0} WHERE node={1}".format(node2["id"],node["id"]))
				cursor.execute("UPDATE node_cable SET node=%s WHERE node=%s",(node2["id"],node["id"]))
				
				# Delete Node
				cursor.execute("DELETE FROM node WHERE id=%s", node["id"])
				
				# Delete Node 1's network
				# DELETE FROM Network Where  node = node 1 id
				cursor.execute("DELETE FROM network WHERE node=%s", node["id"])
				
				
				
				
				

				print(node_1_cables)
				print(node_2_cables)
	
		# Add to blacklist
		blacklist.append(node)
			
			
		
		


	connection.commit()
	
	
	
	
	
	connection.close()