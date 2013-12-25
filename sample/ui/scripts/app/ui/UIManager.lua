--
-- Author: Evans
-- Date: 2013-12-24 19:43:17
--
UIManager = class("UIManager")

UIManager.LIST_PANEL = {}
UIManager.PANEL_CURR = {}
UIManager.Z_INDEX = 1000

--显示面板--
function UIManager.showPanel(name,...)
	local panel = UIManager.LIST_PANEL[name]
	dump(tolua.getpeer(panel))
	if not panel then
		local cls = import("app.view." .. name)
		panel = cls.new(...)
		UIManager.LIST_PANEL[name] = panel
	end

	--在当前场景显示--
	local currScene = display.getRunningScene()
	local parent = panel:getParent()

	if not parent or parent ~= currScene then
		if parent then
			parent:removeChild(panel)
		end
		currScene:addChild(panel)
	else
		if not panel:isVisible() then
			panel:show()
		end
	end
	--设置Z坐标
	panel:setZOrder(UIManager.Z_INDEX)

	UIManager.PANEL_CURR.name = name
	UIManager.PANEL_CURR.panel = panel
end

--隐藏面板
function UIManager.hidePanel(name)
	-- body
end

--隐藏当前面板
function UIManager.hideCurrPanel()
	-- body
end

--隐藏全部面板
function UIManager.hideAllPanel()
	-- body
end



return UIManager