
#
# Copyright (c) 2010 Symbian Foundation Ltd
# This component and the accompanying materials are made available
# under the terms of the License "Eclipse Public License v1.0"
# which accompanies this distribution, and is available
# at the URL "http://www.eclipse.org/legal/epl-v10.html".
#
# Initial Contributors:
# Symbian Foundation Ltd - initial contribution.
#
# Contributors:
#
# Description:
#
#

COREPLAT_NAME    = sf
COREPLAT_VERSION = 3.0.0
S60_VERSION      = 5.2
SOS_VERSION      = 9.5
PLATFORM_NAME    = sf_refhw

USE_PAGING     = 0
USE_ROMFILE    = 0
USE_SYMGEN     = 0
USE_UDEB       = 1
USE_VARIANTBLD = 0
USE_VERGEN     = 1
USE_ROFS       = 0

# CORE
# imaker -f /epoc32/rom/config/platform/product/image_conf_product.mk core
#
COREPLAT_OPT = $(BLDROM_OPT) -D_EABI=$(ARM_VERSION)\
  $(if $(PRODUCT_MSTNAME),-D$(call ucase,$(PRODUCT_MSTNAME))) -D$(call ucase,$(PRODUCT_NAME)) $(PRODUCT_OPT)

CORE_OBYGEN =\
  geniby | $(CORE_PREFIX)_core_collected.oby |\
    $(E32ROMINC)/core/app $(E32ROMINC)/core/mw $(E32ROMINC)/core/os\ $(E32ROMINC)/core/stubs \
    $(call select,$(TYPE),prd,,$(E32ROMINC)/core/tools) \
    $(E32ROMINC)/language/* \
    $(E32ROMINC)/customer/* \
    $(E32ROMINC)/customervariant/* \
    | *.iby | \#include "%3" | end
#
CORE_OBY = $(CONFIGROOT)/sf_refhw/bigrom.oby $(CORE_PREFIX)_core_collected.oby
# <variant/patchdata.iby> would be added here too

CORE_OPT = $(COREPLAT_OPT) -es60ibymacros -DSECTION

# Workaround to fix Rombuild errors:
# "ERROR: incorrect format for time keyword..." and "The size of the ROM has not been supplied."
CORE_OPT += --DROMMEGS=80 --DROMDATE=$(CORE_TIME)


