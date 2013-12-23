
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2
DEBUG_FPS = true
-- DEBUG_MEM = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 1027
CONFIG_SCREEN_HEIGHT = 768

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"


----------MornUI 设置------------

--是否是发布版(影响资源加载方式)
RELEASE = false

RES_PATH = RELEASE and "res/" or "res/debug/"

--默认字体设置
FONT_FAMILY = "Microsoft Yahei"
FONT_SIZE_M = 20

--UI
UI_ALL = "MUI"
UI_SAMPLE = "UISample"