import datetime
import math

def sin(degrees: float) -> float:
    return math.sin(degrees * math.pi / 180)

def cos(degrees: float) -> float:
    return math.cos(degrees * math.pi / 180)

def asin(x: float) -> float:
    return math.asin(x) * 180 / math.pi

def acos(x: float) -> float:
    return math.acos(x) * 180 / math.pi


def sunrise_equation(latitude, longtitude: float) -> float:
    delta = (
        datetime.datetime.utcnow()
      - datetime.datetime(2000, 1, 1, 12, 0)
    )

    J = delta.days - longtitude / 360

    M = (357.5291 + 0.98560028 * J) % 360
    
    C = 1.9148 * sin(M) + 0.0200 * sin(2 * M) + 0.0003 * sin(3 * M)

    l = (M + C + 180 + 102.9372) % 360

    j_transit = 2451545 + J + 0.0053 * sin(M) - 0.0069 * sin(2 * l)

    b = asin( sin(l) * sin(23.44) )

    w = acos(
        ( sin(-0.83) - sin(latitude) * sin(b) )
      / ( cos(latitude) * cos(b) )
    )

    return (
        j_transit - w/360,
        j_transit + w/360
    )

def sunset_check(latitude, longtitude: float) -> bool:
    sunrise_time, sunset_time = sunrise_equation(latitude, longtitude)
    current_time = datetime.datetime.now().timestamp() / 86400 + 2440587.5
    #print(sunrise_time, current_time, sunset_time)
    return (
        sunrise_time < current_time < sunset_time
            or
        sunrise_time < sunset_time < current_time
    )

import os
if __name__ == "__main__":
    print(
        sunset_check(
            *[float(c) for c in os.environ.get('LOCATION').split()]
        )
    )
