Patrick's dotfiles repository
=============================

This is a freely available repository of some of my dotfiles.  I use
this to maintain a consistent environment between all of the Linux
machines that I use.  I have decided in addition to make this available
as a resource for others to use to get what I feel is a reasonably
decent default setup.

This repository is meant to be used with [vcsh][vcsh] and [myrepos][mr].
I have provided a .mrconfig which allows you to drop myrepos configuration
files into ~/.config/mr/conf.d.

My shell and vim configurations use the
[solarized color scheme][solarized].

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
want to make sure it sets TERM correctly.

[mr]: https://myrepos.branchable.com/
[solarized]: http://ethanschoonover.com/solarized
[vcsh]: https://github.com/RichiH/vcsh
