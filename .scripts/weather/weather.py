#!/bin/env python3

import requests
import json
import os

from moon import getMoonPhase as moon_phase
from sun import sunset_check
from bs4 import BeautifulSoup

URL = "https://gismeteo.ru" 
HEADERS = {
    "User-Agent":"Mozilla/5.0 (Linux; Android 10; SM-G975U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36"
}

def prettify(temperature, weather_condition: str, lat, lon: float) -> str:
    return (
        {
            "Ясно"                      : chr(0x2600),
            "Переменная облачность"     : chr(0x1F324),
            "Облачно"                   : chr(0x1F325),
            "Пасмурно"                  : chr(0x2601),
            "Пасмурно, небольшой дождь" : chr(0x1F327),
            "Пасмурно, снежная крупа"   : chr(0x1F328),

            "New Moon"        : chr(0x1F311),
            "Waxing Crescent" : chr(0x1F312),
            "First Quarter"   : chr(0x1F313),
            "Waxing Gibbous"  : chr(0x1F314),
            "Full Moon"       : chr(0x1F315),
            "Waning Gibbous"  : chr(0x1F316),
            "Last Quarter"    : chr(0x1F317),
            "Waning Crescent" : chr(0x1F318),
        }.get(
            moon_phase() if
                sunset_check(lat, lon)
            else 
                weather_condition,
            ' '
        ) + ' '
          + weather_condition
          + ('' if weather_condition.endswith(', ') else ', ')
          + temperature
          + chr(0x00B0)
    )

def scrap(location: str) -> (str, str):
   return (tag.text for tag in BeautifulSoup(
         requests.get(f'{URL}{location}/now', headers = HEADERS).text,
         "html.parser"
      ).find_all(
         lambda tag: (
            tag.parent.attrs.get("class") == ["now__feel"] or
            tag.attrs.get("class") == ["now__desc"]
         )
      )
   )

def find_location(lat, lon: float) -> str:
   return json.loads(
      requests.get(
         f"{URL}/api/v2/search/nearesttownsbycoords/?latitude={lat}&longitude={lon}&limit=1", 
         headers = HEADERS
      ).text
   )[0]['url']

def main(lat, lon: float):
    print(
        prettify(
            *scrap( find_location(lat, lon) ),
            lat, lon
        )
    )

(lambda __name__:
    main(
        *map(
            float, 
            os.environ.get('LOCATION').split() 
        )
    ) if __name__ == '__main__' else None
)(__name__)

