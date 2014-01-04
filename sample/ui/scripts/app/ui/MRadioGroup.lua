--
-- Author: Evans
-- Date: 2014-01-04 11:22:12
--单选组

MGroup = cc.Registry.classes_["MGroup"]
local M = class("MRadioGroup", MGroup)

M.BTN_SELECT_CHANGED = "BTN_SELECT_CHANGED"


--------override----------

function M:ctor( props,parent )
	M.super.ctor(self,props,parent)

	self.buttons_ = {}
	self.currSelectedIndex_ = 0
end

function M:addWidget(widget)
	M.super.addWidget(self,widget)

	self.buttons_[#self.buttons_ + 1] = widget
	widget:onButtonClicked(handler(self, self.onButtonStateChanged_))
	widget:onButtonStateChanged(handler(self, self.onButtonStateChanged_))
end

--------custom-------------


function M:onButtonStateChanged_(event)
	-- body
end

return M
