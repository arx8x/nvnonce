include ~/theos/makefiles/common.mk

TOOL_NAME = nvnonce
setnonce_FILES = main.mm
setnonce_FRAMEWORKS = IOKit

include ~/theos/makefiles/tool.mk
