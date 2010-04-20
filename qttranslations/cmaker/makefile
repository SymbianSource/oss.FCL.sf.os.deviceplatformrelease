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
# Description:  qt translations configuration makefile
#

#Define this platform as default if nothing is defined

MAKEFILE = /sf/os/deviceplatformrelease/qttranslations/cmaker/makefile

# Define the directories you want to create to a variable.
TSFILES = /epoc32/include/platform/qt/translations
LANGUAGE_IDS_FOLDER = /epoc32/include/platform/mw/loc


export_template_files    :: $(TSFILES) $(LANGUAGE_IDS_FOLDER) ts_config

# create a target with that variable, which treats each directory as its own target.
# The perl emkdir.pl <target> will create the folder structure
$(TSFILES):
	$(PERL) $(E32TOOLS)\emkdir.pl $@

$(LANGUAGE_IDS_FOLDER):
	$(PERL) $(E32TOOLS)\emkdir.pl $@

include include_template.mk
