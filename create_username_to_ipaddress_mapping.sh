#!/bin/bash
nova list | head -n -1 | awk -F'[-=|]' '{print $9, $15}'
