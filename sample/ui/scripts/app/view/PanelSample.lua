--
-- Author: Evans
-- Date: 2013-12-24 17:13:13
--
PanelSample = class("PanelSample",function()
	return MUtil.getUIByName("UISample")
end)

function PanelSample:ctor()
	self.btnClose:onButtonClicked(function()
		self:hide()
	end)
end


return PanelSample