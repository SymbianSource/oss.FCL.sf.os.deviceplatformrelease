#
# Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).
# All rights reserved.
# This component and the accompanying materials are made available
# under the terms of the License "Symbian Foundation License v1.0" to Symbian Foundation members and "Symbian Foundation End User License Agreement v1.0" to non-members
# which accompanies this distribution, and is available
# at the URL "http://www.symbianfoundation.org/legal/licencesv10.html".
#
# Initial Contributors:
# Nokia Corporation - initial contribution.
#
# Contributors:
#
# Description:
# Example version of a platform-specific configuration makefile,
# common to many products.
#

COREPLAT_NAME    =__SYBORG__
COREPLAT_VERSION = 1
S60_VERSION      = 5.0
SOS_VERSION      = 9.4
PLATFORM_NAME    =__SYBORG__


USE_PAGING     	= 0
USE_ROMFILE    	= 1
USE_ROFS	= 0
USE_SYMGEN     	= 0
USE_UDEB       	= full
USE_VARIANTBLD 	= 0
USE_VERGEN     	= 1


PRODUCT_NAME  	= Syborg
PRODUCT_TYPE  	= Syborg
PRODUCT_MODEL 	= Syborg

BUILD           =armv5
ROMMEGS         =71
ROMDATE         =abcd 

# CORE
# imaker -f /epoc32/rom/config/platform/product/image_conf_product.mk core
#(ARM_VERSION)
COREPLAT_OPT = $(BLDROM_OPT) -D_EABI=$(ARM_VERSION)\
  $(if $(PRODUCT_MSTNAME),-D$(call ucase,$(PRODUCT_MSTNAME))) -D$(call ucase,$(PRODUCT_NAME)) $(PRODUCT_OPT)

#CORE_OBYGEN =\
#  geniby | $(CORE_PREFIX)_core_collected.oby |\
#    $(E32ROMINC)/core/app $(E32ROMINC)/core/mw $(E32ROMINC)/core/osext\
#    $(call select,$(TYPE),prd,,$(E32ROMINC)/core/tools) | *.iby | \#include "%3" | end
#
#CORE_OBY = $(E32ROM)/master.oby $(CORE_PREFIX)_core_collected.oby <symbianos.iby> <variant/patchdata.iby>

NAME            = MySyborg
CORE_NAME 	= Syborg
CORE_NDNAME     = Syborg.NDcore
CORE_OBY        = $(E32ROM)/config/Syborg/platform/SyborgMasterTextShell.oby

CORE_UDEBFILE   = $(E32ROM)/config/Syborg/platform/mytraces.txt
CORE_ROMFILE    = $(E32ROM)/config/Syborg/platform/romfiles.txt
CORE_NDPROMFILE	= $(E32ROM)/config/Syborg/platform/romfiles.txt
#Emilio CORE_OPT= $(COREPLAT_OPT) -es60ibymacros -DSECTION

# Workaround to fix Rombuild errors:
# "ERROR: incorrect format for time keyword..." and "The size of the ROM has not been supplied."
CORE_OPT += --DROMMEGS=80 --DROMDATE=$(CORE_TIME)


# ROFS2
# imaker -f /epoc32/rom/config/platform/product/image_conf_product.mk langpack_01
#
ROFS2_OBYGEN =\
  geniby | $(ROFS2_PREFIX)_rofs2_customer_collected.oby | $(E32ROMINC)/customer/* | *.iby | \#include "%3" | end |\
  geniby | $(ROFS2_PREFIX)_rofs2_language_collected.oby | $(E32ROMINC)/language/* |\
    __header__ | LOCALISE_ALL_RESOURCES_BEGIN | *.iby | \#include "%3" | __footer__ | LOCALISE_ALL_RESOURCES_END | end

ROFS2_OBY = <Variant.oby> $(ROFS2_PREFIX)_rofs2_language_collected.oby $(ROFS2_PREFIX)_rofs2_customer_collected.oby
ROFS2_OPT = $(COREPLAT_OPT) -es60ibymacros -elocalise -DLOCALES_SC_IBY -D__LOCALES_SC_IBY__


# ROFS3
# imaker -f /epoc32/rom/config/platform/product/image_conf_product.mk custvariant_XX
#
ROFS3_OBYGEN =\
  geniby | $(ROFS3_PREFIX)_rofs3_collected.oby | $(E32ROMINC)/customervariant/* | *.iby | \#include "%3" | end

ROFS3_OBY = $(ROFS3_PREFIX)_rofs3_collected.oby
ROFS3_OPT = $(COREPLAT_OPT) -es60ibymacros