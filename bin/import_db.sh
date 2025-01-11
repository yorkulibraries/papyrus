#!/bin/bash
dump=$1

echo 'show tables;' | rails db -p | grep -v "Tables_in_" | xargs -i -n 1 echo "DROP TABLE IF EXISTS \`{}\`;" > drop.sql 

cat drop.sql | rails db -p

[ -f "$dump" ] &&  zcat -f "$dump" | sed '/DROP DATABASE \|CREATE DATABASE \|USE `/d'  | sed 's/ datetime / datetime(6) /'  > import.sql 

cat import.sql | rails db -p

rails db:migrate
