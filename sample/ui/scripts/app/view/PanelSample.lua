--
-- Author: Evans
-- Date: 2013-12-24 17:13:13
--
PanelSample = class("PanelSample",function()
	return MUtil.getUIByName("UISample")
end)

-- function PanelSample:ctor()
-- 	self:isOftenShow(true)
-- end

function PanelSample:onEnter()
	self.btnClose:onButtonClicked(function()
		self:close()
	end)
end


-- 	-- PanelSample.super.onEnter(self)

	

-- 	--处理点击事件
-- 	-- self:setTouchEnable(true,function(evt,x,y)
-- 	-- 	return true
-- 	-- end)

-- 	print("PanelSample onEnter")
-- 	dump(self)

-- end

-- function PanelSample:onCleanup()
-- 	print("onCleanup",self:retainCount())
-- end

-- function PanelSample:onExit()
-- 	print("onExit",self:retainCount())
-- end


return PanelSample