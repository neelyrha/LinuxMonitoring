#!/bin/bash

re='^-?\+?[0-9]*\.?[0-9]+$'
if [[ $1 =~ $re ]]
then
    echo "incorrect input: not a string" >&2; exit 1
else
    if [ -z "$1" ]
    then
        echo "no arguments"
    else
        echo $1
    fi
fi
