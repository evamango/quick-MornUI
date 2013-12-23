--
-- Author: Evans
-- Date: 2013-12-18 21:54:40
--
local MEditBox = class("MEditBox", function (props,parent)

	local box = CCEditBox:create(CCSize(MUtil.computeSize(nil,props,parent)), display.newScale9Sprite(MUtil.parseUrl(props.skin)))
	CCNodeExtend.extend(box)
	return box
end)

-------------override--------------
function MEditBox:ctor( props,parent )
	makeUIControl_(self)
    self:setLayoutSizePolicy(display.FIXED_SIZE, display.FIXED_SIZE)

	MUtil.extend(self)
	self:updateProps(props,parent)
end

function MEditBox:updateProps(props,parent)
	--fontColor
	self:setFontColor(DisplayUtil.convertToCCC3(props.color))
	--fontSize
	self:setFontSize(props.size and toint(props.size) or FONT_SIZE_M)
	--fontName
	self:setFontName(FONT_FAMILY)
	-- box:set
	if tobool(props.asPassword) then
		self:setInputFlag(kEditBoxInputFlagPassword)
	end

	return self:getComponent(".MUIProtocol").updateProps(self,props,parent)
end


function MEditBox:getDefaultDataBind()
	return self.setText
end

-----------custom------------------



return MEditBox