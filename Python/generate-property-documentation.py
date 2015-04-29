import pymysql.cursors
import json
from decimal import *
import time

field_type = {
	0: 'Double',
	3: 'Integer',
	253: 'String',
	246: 'Double',
	5: 'Double',
	4: 'Double',
	252: 'String',
	12: 'Date',
	16: 'Boolean'
}


connection = pymysql.connect(host='localhost',
                             user='root',
                             passwd='root',
                             db='gotham',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)


	
cursor = connection.cursor()	

cursor.execute("USE gotham") 
cursor.execute("SHOW TABLES")   
table_names = []
tables = cursor.fetchall()
for t in tables:
	table_names.append(t["Tables_in_gotham"])
filex = open("docGen.txt", "w")
	
for name in table_names:
	filex.write("---------{0}---------\n\n".format(name))
	cursor.execute("SELECT * FROM {0} LIMIT 1".format(name))
	for a in cursor.description:
		print(a)
		column = a[0]
		type = a[1]
		filex.write("###*\n")
		filex.write("# The {0} of the {1}\n".format(column, name))
		filex.write("# @property {1} {0}\n".format(column, "{"+field_type[type]+"}"))
		filex.write("###\n")
		
	filex.write("\n\n")
	print("--------------")
	
filex.close()