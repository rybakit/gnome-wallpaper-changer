gnome-wallpaper-changer
=======================

The script reads a file, a pipe or a standard input to retrive a list of images and sets a random one as a gnome wallpaper.

### Usage examples

* Set random image from user's home folder:

  `source/folder.sh [optional-folder-name] | ./gnome_wallpaper_changer.sh`


* Set random photo from your account at [fotki.yandex.ru](http://fotki.yandex.ru):

  `source/yandex_fotki.sh <your-account> | ./gnome_wallpaper_changer.sh`


* Append a crontab line (crontab -e) to change a background image every hour:

  `0 * * * * <path-to-gnome_wallpaper_changer-folder>/source/folder.sh | <path-to-gnome_wallpaper_changer-folder>/gnome_wallpaper_changer.sh >> /dev/null 2>&1`
  
