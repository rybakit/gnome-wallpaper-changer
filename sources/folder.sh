#!/bin/bash
# 
# A simple script which finds all *.jpg images in a specific directory.
# If a directory is not provided, user's home folder will be taken.
#
# (c) 2010, Eugene Leonovich <gen.work@gmail.com>

DIR=$1
if [ -z "$DIR" ]; then
  DIR=~
elif [ ! -d "$DIR" ]; then
  echo "Error: directory name \"$DIR\" is not found."
  exit 10
fi

find "$DIR" -iname "*.jpg"

