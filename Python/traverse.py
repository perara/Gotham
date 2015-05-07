import os
import json


def generate(parent, path):
	for file in os.listdir(path):
		fileName, fileExtension = os.path.splitext(file)
		
		# Ignore proc
		if fileName == "proc" or fileName == "sys":
			continue
			
		if os.path.islink(file):
			continue
			
		name = fileName.encode('utf-8').strip()
			
	
		parent["children"][name] = {}
		
		isFile = os.path.isfile(file)
		
		# if its a file but no extension
		if isFile and fileExtension == "":
			fileExtension = "x"
			
		if not isFile:
			parent["children"][name]["children"] = {}
			fileExtension == "dir"
		
		parent["children"][name]["extension"] = fileExtension
		
		# Generate further down the tree if its a dir
		if not isFile:
		
			if path == "/":
				nextPath = "/" + fileName
			else:
				nextPath = path + "/" + fileName
	
			try:
				generate(parent["children"][name], nextPath)
			except:
				pass
		
structure = {
	"extension": "dir",
	"children": {}

}

generate(structure, "/")

filex = open("structure.json", "w")

data = json.dumps(structure)


filex.write(data)
filex.close()