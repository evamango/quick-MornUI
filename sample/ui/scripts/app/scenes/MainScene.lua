
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
    --     :pos(display.cx, display.cy)
    --     :addTo(self)
    self.main = MUtil.getUIByName("Main"):addTo(self)

    self.main.btnOpen1:onButtonClicked(function()
        print("show Panel!")
        UIManager.showPanel("PanelSample")
    end)

    self.main.btnOpen2:onButtonClicked(function()
        app:enterScene("UITestScene")
    end)


end

function MainScene:onEnter()
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

function MainScene:onExit()
end

return MainScene
