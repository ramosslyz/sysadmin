#!/usr/bin/python3

########
##################### _get_api_key_first_thx
#####################

import os
import requests
import sys

from argparse import ArgumentParser

parser = ArgumentParser(description='Get the current weather information for your zipcode')
parser.add_argument('zip', help='zip/postal code to get weather for')
parser.add_argument('--country', default='us', help='country zip/postal belongs to, default is "us"')

args = parser.parse_args()

api_key = os.getenv("OWM_API_KEY")

if not api_key:
    print("Error: no 'OWM_API_KEY' provided")
    sys.exit(1)

url = f"http://api.openweathermap.org/data/2.5/weather?zip={args.zip},{args.country}&appid={api_key}"

res = requests.get(url)

if res.status_code != 200:
    print(f"Error talking to weather provider: {res.status_code}")
    sys.exit(1)

print(res.json())
~                 
