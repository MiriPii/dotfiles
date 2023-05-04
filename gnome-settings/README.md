# Gnome Settings

These settings are not backed up fully with gnu-stow.

The sane default configs are listed in this file instead.

## Display Settings

```sh
# set screensaver to 20 mins
gsettings set org.gnome.desktop.screensaver lock-delay 1500

# time (in seconds) before the screen blanks
gsettings set org.gnome.desktop.session idle-delay 900
```

## Keyboard Map

Keyboardmap without the finnish dead-keys

`Finnish (classic, no dead keys)`

### X11

`setxkbmap fi nodeadkeys`

