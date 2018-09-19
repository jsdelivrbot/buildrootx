################################################################################
#
# lld
#
################################################################################

#LLD_VERSION = 5b39812
#LLD_SITE = https://llvm.org/releases/$(LLD_VERSION)
#LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz

#LLD_VERSION = 7.0.0rc2
LLD_VERSION = e36f4d4
LLD_SITE = $(call github,llvm-mirror,lld,$(LLD_VERSION))
#LLD_SITE = https://prereleases.llvm.org/7.0.0/rc2
#LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm host-clang

$(eval $(host-cmake-package))
