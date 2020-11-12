#!/bin/bash
set -e # exit immediately if a command exits with a non-zero status.

POSTGRES="psql --username postgres"

# create database for superset
echo "Creating database: datains"
$POSTGRES <<EOSQL
CREATE DATABASE datains OWNER datains;
EOSQL

# create database for superset
echo "Creating database: tservice"
$POSTGRES <<EOSQL
CREATE DATABASE tservice OWNER tservice;
EOSQL