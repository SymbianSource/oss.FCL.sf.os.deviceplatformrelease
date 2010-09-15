# S60 build level configuration makefile 
 
MAKEFILE = $(EPOCROOT)/sf/os/deviceplatformrelease/sf_build/sf_prebuild/makefile
          
# Exporting makefile template
include $(EPOCROOT)/sf/os/devicesrv/commonservices/commonengine/makefile

include $(EPOCROOT)/sf/os/devicesrv/devicesrv_pub/common_platform_security_definitions_api/makefile
include $(EPOCROOT)/sf/os/devicesrv/devicesrv_pub/platform_path_definitions_api/makefile


ifeq (S60,$(BUILD))
include $(EPOCROOT)/sf/mw/uiresources/uigraphics/icons/makefile
include $(EPOCROOT)/sf/mw/uiresources/uigraphics/bitmaps2/makefile
include $(EPOCROOT)/sf/mw/platformtools/gfxconversion/mifconv/makefile_templates/makefile
include $(EPOCROOT)/sf/app/homescreentools/dtdinstaller/makefile
endif
 
# Place the first target as the default target which is executed from this level 
s60_prebuild  :: commonengine_all platform_path_all common_platform_security_all export_template_files icons_all bitmaps_all dtdinstaller_all
os_prebuild  :: commonengine_all platform_path_all common_platform_security_all  

# include include_template.mk 