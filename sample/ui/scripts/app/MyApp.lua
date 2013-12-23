
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

import("app.utils.ObjectUtil")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath(RES_PATH)
    self:enterScene("UITestScene")
end

return MyApp
