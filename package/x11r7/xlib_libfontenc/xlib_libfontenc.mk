################################################################################
#
# xlib_libfontenc
#
################################################################################

XLIB_LIBFONTENC_VERSION = 1.1.3
XLIB_LIBFONTENC_SOURCE = libfontenc-$(XLIB_LIBFONTENC_VERSION).tar.bz2
XLIB_LIBFONTENC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFONTENC_LICENSE = MIT
XLIB_LIBFONTENC_LICENSE_FILES = COPYING
XLIB_LIBFONTENC_INSTALL_STAGING = YES
XLIB_LIBFONTENC_DEPENDENCIES = zlib xproto_xproto
HOST_XLIB_LIBFONTENC_DEPENDENCIES = host-zlib host-xproto_xproto
XLIB_LIBFONTENC_OPTS = --enable-static --disable-shared

$(eval $(autotools-package))
$(eval $(host-autotools-package))
