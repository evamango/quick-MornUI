--
-- Author: Evans
-- Date: 2013-12-23 14:38:11
--带边框图片

MImage = cc.Registry.classes_[".MImage"]
MGroup = cc.Registry.classes_[".MGroup"]
MImageBorder = class("MImageBorder", MGroup)

--------------override---------------

function MImageBorder:ctor(props,parent)
	MImageBorder.super.ctor(self,props,parent)
	self.isContainer_ = false
end

function MImageBorder:updateProps(props, parent)
	-- 更新底图,注意:底图不支持sizeGrid
	MImageBorder.super.updateProps(self,props,parent)

	-- 更新边框
	if props.urlBorder then
		props.url = props.urlBorder
		props.sizeGrid = props.sizeGridBorder
		MImage.new(props,parent):pos(0, 0):addTo(self,1)
	end
	return self
end

function MImageBorder:getDefaultDataBind()
	return self.setImage
end

-------------custom--------------


--以后可更换为setDisplayFrame
function MImageBorder:setImage(url)
	local img

	if self.backgroundSprite_ then
		self.backgroundSprite_:removeSelf()
	end
	local w,h = self:getLayoutSize()
	img = MImage.new({["url"] = url,width = w,height = h},self):addTo(self)

	return self
end

return MImageBorder
