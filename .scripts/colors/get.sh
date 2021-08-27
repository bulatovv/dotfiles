#!/bin/sh
getcolor() {
    xrdb -query | grep "\*.\?$1:" | awk '{print $NF}'
}
