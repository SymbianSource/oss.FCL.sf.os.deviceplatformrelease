#
# Copyright (c) 2006, 2009 Nokia Corporation and/or its subsidiary(-ies).
# All rights reserved.
# This component and the accompanying materials are made available
# under the terms of "Eclipse Public License v1.0"
# which accompanies this distribution, and is available
# at the URL "http://www.eclipse.org/legal/epl-v10.html".
#
# Initial Contributors:
# Nokia Corporation - initial contribution.
#
# Contributors:
#
# Description:  qt translations configuration export makefile
#

MAKEFILE = /sf/os/deviceplatformrelease/qttranslations/cmaker/config/export.mk
$(call push,MAKEFILE_STACK,$(MAKEFILE))

LANGUAGE_IDS = 37 102 42 44 45 25 07 18 01 10 49 50 09 02 51 103 03 54 57 58 30 17 15 59 05 32 65 67 68 70 08 27 13 76 31 78 16 79 26 28 04 83 06 39 29 33 14 93 94 96

ts_config 	:: ts-content

ts-content :  
	cd \epoc32\include\platform\qt\translations && unzip -o \sf\os\deviceplatformrelease\qttranslations\data\tsfiles.zip
	cd \epoc32\include\platform\mw\loc && $(PERL) $(E32TOOLS)\emkdir.pl $(LANGUAGE_IDS)



$(call popout,MAKEFILE_STACK) 
