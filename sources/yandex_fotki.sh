#!/bin/bash
# 
# A simple script which retrieves user's photos from fotki.yandex.ru.
# Notice: only first page from collection will be taken (100 photos max).
#
# (c) 2010, Eugene Leonovich <gen.work@gmail.com>

if [ -z "$1" ]; then
  echo "Error: user name is empty."
  exit 10
fi

curl -s http://api-fotki.yandex.ru/api/users/"$1"/photos/ | \
sed -ne 's/^\s*<content src="\([^"]*\)_XL".*$/\1_orig/gp'

