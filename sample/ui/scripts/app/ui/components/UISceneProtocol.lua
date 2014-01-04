--
-- Author: Evans
-- Date: 2013-12-24 19:43:17
--显示UI面板的场景协议

UISceneProtocol = class("UISceneProtocol",cc.Registry.classes_["components.Component"])


-------------override-------------
function UISceneProtocol:ctor()
	UISceneProtocol.super.ctor(self, "UISceneProtocol")
end

function UISceneProtocol:exportMethods()
	self:exportMethods_({
        "showPanel",
        "closePanel",
        "onExitScene",
        -- "setUIName",
        -- "setData",
        -- "getDefaultDataBind",
    })
    return self
end

function UISceneProtocol:onBind_(target)
	target.listPanel_ = {}
	target.panelCurr_ = {}
	target.indexPanel_ = 1000
end

-------------custom--------------

--显示面板--
function UISceneProtocol:showPanel(name,...)
	local target = self.target_

	local panel = target.listPanel_[name]
	if not panel then
		local cls = import("app.view." .. name)
		panel = cls.new(...)
		target.listPanel_[name] = panel
	end

	--在场景显示--
	local parent = panel:getParent()
	if not parent or parent ~= target then
		target:addChild(panel)
	end

	panel:setZOrder(target.indexPanel_)
	target.indexPanel_ = target.indexPanel_ + 1

	target.panelCurr_.name = name
	target.panelCurr_.panel = panel

	return self
end

--隐藏面板
function UISceneProtocol:closePanel(name,cleanup)
	local target = self.target_

	local panel = target.listPanel_[name]
	assert(panel,string.format("Has not panel named <%s>", name))

	if not panel:isOftenShow() then
		target.listPanel_[name] = nil
	end

	cleanup = cleanup or true
	panel:removeSelf(cleanup)

	return self
end

--隐藏当前面板
function UISceneProtocol:hideCurrPanel()
	-- body
end

--隐藏全部面板
function UISceneProtocol:hideAllPanel()
	-- body
end

--当切换场景时
function UISceneProtocol:onExitScene()
	-- body
end





return UISceneProtocol