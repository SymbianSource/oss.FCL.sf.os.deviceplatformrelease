# needs override.pm in \epoc32\tools\
# needs s60ibymacros.pm, plugincommon.pm obyparse.pm rom\include\symbian_os_romdefs.hby rom\variant\s60macros.iby tools\localise.pm, localise_all_resources.pm

PRODUCT_NAME =zoom2
PLATFORM_NAME =zoom2
BUILD =armv5
ROMMEGS =71
ROMDATE =abcd 
USE_FLOAT =0
USE_VERGEN =1
USE_ROFS =0
USE_PAGING =0
USE_PLATSEC =0
USE_ROMFILE =1
COREPLAT_OPT =
CORE_OBY     = $(E32ROM)/config/zoom2/bigrom.oby $(CORE_PREFIX)_core_generated.oby

CORE_OBYGEN =\
  geniby | $(CORE_PREFIX)_core_generated.oby |\
    $(E32ROMINC)/core/app \
	$(E32ROMINC)/core/mw \
	$(E32ROMINC)/core/os \
	$(E32ROMINC)/core/stubs \
   $(call select,$(TYPE),prd,,$(E32ROMINC)/core/tools) | *.iby | \#include "%3" | end

CORE_OPT = -keepgoing $(BLDROM_OPT) -D_EABI=$(ARM_VERSION) -D$(call ucase,$(PRODUCT_NAME)) -I\epoc32\rom\include\core\mw -I\epoc32\rom\include\core\app -I\epoc32\rom\include\core\os -es60ibymacros -elocalise -D_FULL_DEBUG
#	$(E32ROMINC)/language/app \
#	$(E32ROMINC)/language/mw \
#	$(E32ROMINC)/language/os \
#	$(E32ROMINC)/customer/app \
#	$(E32ROMINC)/customer/mw \
#	$(E32ROMINC)/customer/os \
