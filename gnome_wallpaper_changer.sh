#!/bin/bash
#
# Sets gnome desktop wallpaper. Script reads a file, a pipe or a standard input to 
# retrive a list of images and chooses a random one.
#
# Usage examples:
# ./gnome_wallpaper_changer.sh < file.txt
# cat images.txt | ./gnome_wallpaper_changer.sh
# ./gnome_wallpaper_changer.sh mypic.jpg
#
# (c) 2010, Eugene Leonovich <gen.work@gmail.com>


# configuration options
# filename of the image, which will be set as a wallpaper
WALLPAPER_FILENAME="$HOME/gnome_wallpaper"
# leave it blank if resize is not needed
WALLPAPER_SIZE=`xrandr | grep current | sed 's/^.*current \([0-9]*\) x \([0-9]*\).*$/\1x\2/'` # 1280x960


# read data
if file $( readlink /proc/$$/fd/0 ) | grep -q "character special"; then
  # standard input
  IMAGE=$1
else
  # pipe or file input
  IMAGE_LIST=`cat`

  if [ -z "$IMAGE_LIST" ]; then
    echo "Error: looks like we got an empty list."
    exit 10
  fi

  # get a random line from the list
  TOTAL=`echo -e "$IMAGE_LIST" | wc -l`
  if [ $TOTAL -gt 1 ]; then
    RAND=0
    while [ "$RAND" -eq 0 ]; do
      RAND=$(expr $RANDOM \% $TOTAL)
    done
  else
    RAND=1
  fi

  IMAGE=`echo -e "$IMAGE_LIST" | sed -n "${RAND}p;${RAND}q"`
fi


if [ -z "$IMAGE" ]; then
  echo "Error: image's name is empty."
  exit 20
fi


# retrieve an image file
IS_URL=`echo $IMAGE | grep -e "^https*://"`
if [ -n "$IS_URL" ]; then
  wget -O "$WALLPAPER_FILENAME.$$" "$IMAGE"
else
  if [ ! -e "$IMAGE" ]; then
    echo "Error: file \"$IMAGE\" is not found."
    exit 21
  fi
  cp "$IMAGE" "$WALLPAPER_FILENAME.$$"
fi

# exit with an error if the file is empty
if [ ! -s "$WALLPAPER_FILENAME.$$" ]; then
  echo "Error: file is empty."
  exit 22
fi

# if a wallpaper size defined and imagemagic installed then resize an image
if [ -n "$WALLPAPER_SIZE" ] && [ -n "`which convert`" ]; then
  convert -geometry "$WALLPAPER_SIZE^" "$WALLPAPER_FILENAME.$$" "$WALLPAPER_FILENAME.$$"
fi

# if it's first time, update a gnome setting to use new a wallpaper
if [ ! -e "$WALLPAPER_FILENAME" ]; then
  mv "$WALLPAPER_FILENAME.$$" "$WALLPAPER_FILENAME"
  gconftool -s --type=string /desktop/gnome/background/picture_filename "$WALLPAPER_FILENAME"
else
  mv "$WALLPAPER_FILENAME.$$" "$WALLPAPER_FILENAME"
fi

echo "Done."

