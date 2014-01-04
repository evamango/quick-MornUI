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
	if props.align then
		local al
		if props.align == "center" then
			al = ui.TEXT_ALIGN_CENTER
		elseif props.align == "right" then
			al = ui.TEXT_ALIGN_RIGHT
		else
			al = ui.TEXT_ALIGN_LEFT
		end
		param.align = al
	end
	local w,h = MUtil.computeSize(nil,props,parent)
	if w > 0 and h > 0 then
		param.dimensions = CCSize(w,h)
		param.valign = ui.TEXT_VALIGN_CENTER
	end
	
	if tobool(props.stroke) then
		return MUtil.newTTFLabelWithOutline(param)
	else
		return ui.newTTFLabel(param)
	end

    
end)

function MLabel:ctor(props,parent)
	makeUIControl_(self)
    self:setLayoutSizePolicy(display.FIXED_SIZE, display.FIXED_SIZE)

	MUtil.extend(self)
	self:updateProps(props,parent)

end

function MLabel:getDefaultDataBind()
	return self.setString
end


return MLabel