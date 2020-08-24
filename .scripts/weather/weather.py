#!/bin/env python3

import re
import requests
import time
import os

from sun import Sun
import moon as Moon

RETRIES = 5
CACHE_FILE = f'{os.getenv("HOME")}/.cache/weather/last.tmp'
headers = {
    'User-Agent':'Mozilla/5.0 (Linux; Android 10; SM-G975U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36',
}


icons = {
    'weather': {
        'ясно':chr(9728),
        'малооблачно':chr(127780),
        'облачно с прояснениями':chr(9925),
        'облачно':chr(127781),
        'пасмурно':chr(9729),
        'небольшой снег':chr(127784),
        'снег':chr(127784),
        'дождь со снегом':chr(127784),
        'небольшой дождь':chr(127783),
        'дождь':chr(127783),
        'ливень':chr(127783),
        'дождь с грозой':chr(9928),
        'туман':chr(127787),
    },
    'moon': {
        'New Moon':chr(127761),
        'Waxing Crescent':chr(127762),
        'First Quarter':chr(127763),
        'Waxing Gibbous':chr(127764),
        'Full Moon':chr(127765),
        'Waning Gibbous':chr(127766),
        'Last Quarter':chr(127767),
        'Waning Crescent':chr(127768),
    }
}

def get_weather():
    location = os.getenv('LOCATION').split()
    lat =  float(location[0])
    lon = float(location[1])

    page = requests.get(f'https://yandex.ru/weather/?lat={lat}&lon={lon}', headers=headers).text

    temp_pat = r'<div class="typo typo_text_m yw-text-shadow yw-fact__feels-like">Ощущается как (.*?)</div>'
    cond_pat = r'<div class="typo typo_text_m yw-text-shadow yw-fact__condition">(.*?)</div>'

    t = re.search(temp_pat,page)[1]
    condition = re.search(cond_pat,page)[1]

    sun = Sun()
    sunset = sun.getSunsetTime({'latitude':lat,'longitude':lon})
    sunrise = sun.getSunriseTime({'latitude':lat,'longitude':lon})
    current_time = time.time() % (60*60*24) / (60*60)
    if sunrise < current_time < sunset or current_time < sunset < sunrise:
        icon = icons['weather'][condition]
    else:
        icon = icons['moon'][Moon.getMoonPhase()]
    
    to_show = f'{icon} {condition[0].upper() + condition[1:]} {t}'
    with open(CACHE_FILE, 'w') as cache:
        cache.write(to_show)

    return(to_show)

def get_last():
    with open(CACHE_FILE, 'r') as cache:
        return(cache.read())


if __name__ == '__main__':
    print(get_weather())
    for i in range(RETRIES):
        try:
            print(get_weather())
            break
        except Exception as ex:
            pass
    else:
        print(get_last())
