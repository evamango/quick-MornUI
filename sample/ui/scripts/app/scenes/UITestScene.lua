--
-- Author: Evans
-- Date: 2013-12-18 18:58:17
--

import("..utils.DisplayUtil")
import("..ui.MUtil")

local UITestScene = class("UITestScene", function()
    return display.newScene("UITestScene")
end)

function UITestScene:ctor()

    ----一行代码就将UI解释出来
    local ui = MUtil.getUIByName(UI_SAMPLE)
    self:addChild(ui)

    -----方便地设置组件属性并更新--------
    ui.boxBtn:setData({
        btn1 = {"非常"},
        btn2 = {"方便"},
        btn3 = {"地"},
        btn4 = {"设置"},
        btn5 = {"属性"}
        })

    ui.itxtNormal:setData({"HI!我是Evans"})
    ui.itxtPassword:setData({"我是星星"})

    ui.lbl1:setData({"标签111"})
    ui:setData({
        lbl2 = {"标签222"}
        })

    -- ui:setData({
    --     bImg1 = {"sister.png"}
    --     })
end

function UITestScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end

end

function UITestScene:onExit()
end

return UITestScene
