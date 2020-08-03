#!/usr/bin/env python3

import time

def cal_speed(s1, s2): # return connection speed in human-readable format
    speed = s2 - s1
    if speed >= 131072:
        return f"{round(speed / 131072, 1)} Mbit/s"
    else:
        return f"{round(speed / 128, 1)} Kbit/s"

def get_bytes():
    with open(f'/sys/class/net/wlp3s0/statistics/tx_bytes', 'r') as file:
        t = int(file.read())
    with open(f'/sys/class/net/wlp3s0/statistics/rx_bytes', 'r') as file:
        r = int(file.read())

    return t, r

if __name__ == '__main__':
    t1, r1 = get_bytes()
    time.sleep(0.969)
    t2, r2 = get_bytes()
    print('🡑', cal_speed(t1, t2).ljust(12, ' '),
          '🡓', cal_speed(r1, r2).ljust(12, ' '))

