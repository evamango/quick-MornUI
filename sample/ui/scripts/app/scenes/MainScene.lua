
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
     --添加UI管理组件--
    cc.GameObject.extend(self)
    self:addComponent("UISceneProtocol"):exportMethods()

    --面板打开/关闭测试
    self.main = MUtil.getUIByName("Main"):addTo(self)
    self.main:setData({
        btnOpen1 = "打开面板",
        btnOpen2 = "切换到场景2",
        })

    self.main.btnOpen1:onButtonClicked(function()
        print("show Panel!")
        self:showPanel("PanelSample")
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
