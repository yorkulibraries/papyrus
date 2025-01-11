#!/bin/bash
dump=$1

echo 'SET foreign_key_checks = 0;' > drop.sql 
echo 'show tables;' | rails db -p | grep -v "Tables_in_" | xargs -i -n 1 echo "DROP TABLE IF EXISTS \`{}\`;" >> drop.sql 

[ -f "$dump" ] &&  zcat -f "$dump" | sed '/^DROP DATABASE \|^CREATE DATABASE \|^USE `/d'  | sed 's/ datetime / datetime(6) /'  > import.sql 

cat drop.sql | rails db -p
cat import.sql | rails db -p

rails db:migrate
