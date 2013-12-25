--
-- Author: Evans
-- Date: 2013-12-18 18:58:17
--
-- PanelSample = import("..view.PanelSample")

local UITestScene = class("UITestScene", function()
    return display.newScene("UITestScene")
end)

function UITestScene:ctor()

    self.main = MUtil.getUIByName("Main"):addTo(self)
    self.main.btnOpen1:onButtonClicked(function()
        print("show Panel!")
        UIManager.showPanel("PanelSample")
    end)

    self.main.btnOpen2:onButtonClicked(function()
        app:enterScene("MainScene")
    end)

    

    
    

    -----方便地设置组件属性并更新--------
    -- ui.boxBtn:setData({
    --     btn1 = "非常方便",
    --     btn2 = "地",
    --     btn3 = "设置属性",
    --     })


end

function UITestScene:showPanel1()
    print(self.__cname)
    self.ui:addTo(self)
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
