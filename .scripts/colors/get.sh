#!/bin/sh
xrdb -query | grep "\*.\?$1:" | awk '{print $NF}'
