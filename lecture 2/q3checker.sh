#!/usr/bin/env bash

count=0
# initialize counter
until [[ $? -ne 0 ]];
do
	count=$(( count + 1 ))
	./q3material.sh > current-result.txt
done
echo "It takes $count runs for the script to fail"
cat current-result.txt
