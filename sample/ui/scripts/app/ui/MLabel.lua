--
-- Author: Evans
-- Date: 2013-12-18 17:11:42
--
local MLabel = class("MLabel", function(props,parent)

	local param = {}

	param.color = DisplayUtil.convertToCCC3(props.color)
	param.size = props.size and tonumber(props.size) or FONT_SIZE_M
	param.text = props.text and props.text or ""
	param.font = FONT_FAMILY
	local w,h = MUtil.computeSize(nil,props,parent)
	if w > 0 and h > 0 then
		param.dimensions = CCSize(w,h)
		param.valign = ui.TEXT_VALIGN_TOP
	end
	

	if tobool(props.stroke) then
		return ui.newTTFLabelWithOutline(param)
	else
		return ui.newTTFLabel(param)
	end

    
end)

function MLabel:ctor(props,parent)
	makeUIControl_(self)
    self:setLayoutSizePolicy(display.FIXED_SIZE, display.FIXED_SIZE)

	MUtil.extend(self)
	self:updateProps(props,parent)

	--描边字得再向下移
	if props.stroke then
		local children = self:getChildren()
		local len = children:count()
		local child
		for i=0,len - 1 do
			child = tolua.cast(children:objectAtIndex(i), "CCNode")
			child:align(display.CENTER_TOP)
		end
	end
end

function MLabel:getDefaultDataBind()
	return self.setString
end


return MLabel