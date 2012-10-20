generalpenguin89's dotfiles repository
======================================

This is a freely available repository of some of my dotfiles.  I use
this to maintain a consistent environment between all of the Linux
machines that I use.  I have decided in addition to make this available
as a resource for others to use to get what I feel is a reasonably
decent default setup.

I have provided an env-setup script that will automatically checkout
this repository into ~/src/dotfiles.  WARNING: the script has been
created and tested within my environment and it may not work quite right
in your environment.  It will also create local versions of these files
named .file.local where you can put local modifications that will
not be overwritten on updates.

This is currently in the process of being switched over to the solarized
colorscheme.  You can find out more information about the solarized
colorscheme here: http://ethanschoonover.com/solarized

The most important thing to note about the solarized colorscheme is that
it makes nonstandard use of the base 16 colors of your terminal
emulator.  That means that the colors may look gross unless you switch
your terminal emulator to use the solarized colorscheme.  Luckily,
solarized configurations exists for all popular terminal emulators.
Note that solarized uses 16 colors so the terminal type ($TERM) must
advertise this capability in order to have the colors work properly.
This may be a problem for screen in particular, but if you set
TERM=screen-16color or TERM=screen-256color then you should be fine.

I highly recommend using the rxvt-unicode terminal emulator as it has
very simple configuration via Xresources, is light on resources, and
actually sets the TERM, COLORTERM, and COLORFGBG variables to sane
values on startup.  I use the COLORFGBG variable in particular to derive
the TERMBG variable.  If you use a different terminal emulator, you will
want to make sure it sets TERM correctly.  GNOME Terminal is notoriously
terrible about this.

Speaking of colors and TERMBG, my bashrc and zshrc have a recolor
function that is used to set the foreground colors appropriately based
on your terminal background.  There are three values supported:
* light
* dark
* solarized
Setting this variable correctly will ensure that vim uses sane colors.
To override the detection, create a file called "~/.termbg.$TERM" in
your home directory.

Feel free to contact me at generalpenguin89@gmail.com with any comments
or questions on any of these files.

