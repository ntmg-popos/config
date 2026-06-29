#!/usr/bin/env python3
import urllib.request
import json
import sys

API_KEY = "0c7df6a8818b542fceae863443771108"
CITY = "Irpin"
URL = f"https://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units=metric&lang=ru"

# Mapping OWM condition codes to FontAwesome icons
# https://openweathermap.org/weather-conditions
ICON_MAP = {
    "01d": "\uf185", # clear sky day
    "01n": "\uf186", # clear sky night
    "02d": "\uf6c4", # few clouds day
    "02n": "\uf6c3", # few clouds night
    "03d": "\uf0c2", # scattered clouds day
    "03n": "\uf0c2", # scattered clouds night
    "04d": "\uf0c2", # broken clouds day
    "04n": "\uf0c2", # broken clouds night
    "09d": "\uf740", # shower rain day
    "09n": "\uf740", # shower rain night
    "10d": "\uf73d", # rain day
    "10n": "\uf73d", # rain night
    "11d": "\uf76c", # thunderstorm day
    "11n": "\uf76c", # thunderstorm night
    "13d": "\uf2dc", # snow day
    "13n": "\uf2dc", # snow night
    "50d": "\uf75f", # mist day
    "50n": "\uf75f", # mist night
}

try:
    with urllib.request.urlopen(URL) as response:
        data = json.loads(response.read().decode())
        temp = round(data["main"]["temp"])
        icon_code = data["weather"][0]["icon"]
        icon = ICON_MAP.get(icon_code, "?")
        desc = data["weather"][0]["description"].capitalize()
        feels_like = round(data["main"]["feels_like"])
        
        # Output for Waybar custom module
        text = f"ирпень - {icon} {temp}°C"
        tooltip = f"{desc}\nОщущается как: {feels_like}°C\nВлажность: {data['main']['humidity']}%"
        
        print(json.dumps({"text": text, "tooltip": tooltip}))
except Exception as e:
    # On error, show a placeholder
    print(json.dumps({"text": "ирпень - \uf753 ?", "tooltip": str(e)}))
