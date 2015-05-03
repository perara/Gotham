import urllib.request
import json

# Fetch CountryName to Country Code
_countryUrl = "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.json"
response = urllib.request.urlopen(_countryUrl)
data = response.read()
json_countries = json.loads(data.decode('utf-8'))

countries = {}
for country in json_countries:
	name = country["name"]
	countries[name] = country
	

result = []

url = "http://explorer.netindex.com/apiproxy.php?url=api_detail.php&index=0&index_start_date=2015-05-01&index_date=2015-05-01&index_level=3&id={0}&major=true"
count = 0
errCount = 0
while count < 500:
	count = count + 1

	response = urllib.request.urlopen(url.format(count))
	data = response.read()      # a `bytes` object
	text = json.loads(data.decode('utf-8')) # a `str`; this step can't be used if data is binary
	
	countryCode = None
	try:
		print(count)
		test = text["data"]["label"]
		
		try:
			countryCode = countries[text["data"]["label"]]["alpha-2"]
		except KeyError:
			countryCode = "Unknown | " + str(text["data"]["label"])

			
		out = {
			"country": text["data"]["label"],
			"countryCode": countryCode,
			"bandwidth": text["data"]["value"],
			"test_count": text["data"]["test_count"],
			"ip_addresses": text["data"]["ip_addresses"],
			"isps": text["data"]["top_isps"]
		}	
		result.append(out)
	except KeyError:
		continue


	
filex = open("isp-load-statistics.py", "w")
filex.write(json.dumps(result))
filex.close()

