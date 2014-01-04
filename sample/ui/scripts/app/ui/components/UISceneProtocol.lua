--
-- Author: Evans
-- Date: 2013-12-24 19:43:17
--显示UI面板的场景协议

UISceneProtocol = class("UISceneProtocol",cc.Registry.classes_["components.Component"])


-------------override-------------
function UISceneProtocol:ctor()
	UISceneProtocol.super.ctor(self, "UISceneProtocol")
	--模式层
	self.mask_ = display.newColorLayer(ccc4(255, 0, 0, 127))
	self.mask_:setTouchEnabled(true)

	self.mask_:addTouchEventListener(function(evt)
		print(evt)
		if evt == "began" then
			return true
		end
	end,false,-200,true)

	-- addTouchEventListener(nHandler, bIsMultiTouches, nPriority, bSwallowsTouches)
end

function UISceneProtocol:exportMethods()
	self:exportMethods_({
		"createPanel",
        "showPanel",
        "closePanel",
        "onExitScene",
        "closeAllPanel",
        "closeCurrPanel",
        "getCurrPanel",
    })
    return self
end

function UISceneProtocol:onBind_(target)
	--给场景添加一个UI层
	target.layerUI = display.newNode():addTo(target)
	target.layerUI:setZOrder(100)
	target.layerUI.___UI_LAYER = true
	--面板列表
	self.listPanel_ = {}
	--已显示面板顺序
	self.seqPanel_ = {}
	--面板Z
	self.indexPanel_ = 1000
	--顶部面板
	self.panelTop_ = nil
	--次顶部面板
	self.panelSec_ = nil
end

-------------custom--------------

function UISceneProtocol:handlePanels_(top,sec)
	
	return top,sec
end

--增加面板
--返回顶部,次顶部面板
function UISceneProtocol:addPanel_(t,panel)
	assert(t,"Table must not be nil")

	--看原来有没有,有就移除
	for i,v in ipairs(t) do
		if v == panel then
			table.remove(t, i)
			break
		end
	end

	--添加到最后
	table.insert(t, panel)

	return self:handlePanels_(t[#t],t[#t - 1])
end

--减少面板
--返回顶部,次顶部面板
function UISceneProtocol:removePanel_(t,panel)
	assert(t,"Table must not be nil")

	--看原来有没有,有就移除
	for i,v in ipairs(t) do
		if v == panel then
			table.remove(t, i)
			break
		end
	end

	return self:handlePanels_(t[#t],t[#t - 1])
end



--生成面板(类名或LUA文件名)
function UISceneProtocol:createPanel(name,...)
	local panel = self.listPanel_[name]
	if not panel then
		local cls
		if pcall(import, "app.view." .. name) then
			cls = import("app.view." .. name)
			panel = cls.new(...)
		else
			panel = MUtil.getUIByName(name)
		end
		 
		
		self.listPanel_[name] = panel
	else
		--更新内容
		panel:updateContent(...)
	end

	return panel
end

--显示面板(传入面板或面板类名)
function UISceneProtocol:showPanel(p,...)
	local target = self.target_.layerUI

	local panel

	if type(p) == "string" then
		panel = self:createPanel(p,...)
	elseif iskindof(p, "UIGroup") then
		panel = p
	else
		error("Param type error!",3)
	end


	--在场景显示--
	local parent = panel:getParent()
	if not parent or parent ~= target then
		--添加到场景上
		target:addChild(panel)
	end

	panel:setZOrder(self.indexPanel_)
	self.indexPanel_ = self.indexPanel_ + 1

	--增加面板
	self.panelTop_,self.panelSec_ = self:addPanel_(self.seqPanel_,panel)

	return panel
end


--隐藏面板(传入面板或面板类名)
function UISceneProtocol:closePanel(p,cleanup)
	local panel
	if type(p) == "string" then
		--如果传入的是名称
		panel = self.listPanel_[p]
	elseif type(p) == "userdata" then
		panel = self.listPanel_[p.__cname]

		if not panel then
			for k,v in pairs(self.listPanel_) do
				if v == p then
					panel = v
				end
			end
		end
	end

	assert(panel,string.format("Panel not found!"))

	--减少面板
	self.panelTop_,self.panelSec_ = self:removePanel_(self.seqPanel_,panel)

	if not panel:isOftenShow() then
		self.listPanel_[name] = nil
	end

	cleanup = cleanup or true
	panel:removeSelf(cleanup)

	return self
end

--隐藏当前面板
function UISceneProtocol:closeCurrPanel(cleanup)
	assert(self.panelTop_,"Not any panel was showed in this scene")
	return self:closePanel(self.panelTop_.__cname, cleanup)
end

--隐藏全部面板
function UISceneProtocol:closeAllPanel(cleanup)
	for k,v in pairs(self.seqPanel_) do
		self:closePanel(k,cleanup)
	end

	-- target.panelTop_.name,target.panelTop_.panel = nil,nil
	-- target.panelTop_.name,target.panelTop_.panel = nil,nil
	return self
end

--当切换场景时,清理
function UISceneProtocol:onExitScene()
	--关闭全部面板
	self:closeAllPanel(true)
	--清理
	for k,v in pairs(self.listPanel_) do
		v:release()
	end

	return self
end

--当前显示的面板
function UISceneProtocol:getCurrPanel()
	return self.panelTop_
end





return UISceneProtocol