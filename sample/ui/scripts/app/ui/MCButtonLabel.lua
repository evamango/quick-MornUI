--
-- Author: Evans
-- Date: 2014-01-03 15:41:00
--组合按钮-图标标签

MGroup = cc.Registry.classes_["MGroup"]
local M = class("MCButtonLabel", MGroup)


-----------override----------

function M:ctor(props,parent)
	M.super.ctor(self,props,parent)
	self.isContainer_ = false
end

function M:addWidget(widget)
	M.super.addWidget(self,widget)

	
	if iskindof(widget, "MButton") then
		--按钮
		self.btn_ = widget
	else
		--标签
		self.label_ = widget
	end
	
	return self
end

function M:getDefaultDataBind()
	return self.setLabelImg
end


-----------custom-------------

function M:setButtonEnabled(v)
	assert(self.btn_,"Btn_ has not be set!")
	return self.btn_:setButtonEnabled(v)
end

function M:setLabelImg(url)
	self.label_:setData(url)
	return self
end

function M:onButtonClicked(callback, isWeakReference)
	assert(self.btn_,"Btn_ has not be set!")
	return self.btn_:onButtonClicked(callback, isWeakReference)
end

return M