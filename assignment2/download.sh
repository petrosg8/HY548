#!/bin/bash
set -e
# Change directory to the mounted volume location
cd /data
# Update package lists and install wget using apt-get
apt-get update && apt-get install -y wget
# Confirm wget is installed
which wget
# Download the entire site using wget
wget -E -k -p http://csd.uoc.gr