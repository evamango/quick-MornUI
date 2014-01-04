--
-- Author: Evans
-- Date: 2013-12-14 16:55:45
--
local UIPushButton = cc.ui.UIPushButton
local MButton = class("MButton", UIPushButton)

--默认LABEL颜色:黑
MButton.COLOR_LABEL_DEFAULT = "0x000000"
--默认LABEL是否描边:否
MButton.STROKE_LABEL_DEFAULT = false

local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()

---------------override---------------

function MButton:ctor(props,parent)
	local url,suffix = MUtil.parseBtnSkin(props.skin)
	local urlPressed = url .. "_press." .. suffix
	local urlDisabled = url .. "_disabled." .. suffix
	local images = {
		normal = "#" .. url .. "." .. suffix,
	}
	if sharedSpriteFrameCache:spriteFrameByName(urlPressed) then
		images.pressed = "#" .. urlPressed
	end

	if sharedSpriteFrameCache:spriteFrameByName(urlDisabled) then
		images.disabled = "#" .. urlDisabled
	end


	MButton.super.ctor(self,images, {scale9 = tobool(props.sizeGrid),touchInSprite = true})

	MUtil.extend(self)
	self.sizeInit_ = self.sprite_ and self.sprite_:getContentSize() or {width = 10,height = 10}

	self.sizeInit_.width = props.width or self.sizeInit_.width
	self.sizeInit_.height = props.height or self.sizeInit_.height

	props.width = self.sizeInit_.width
	props.height = self.sizeInit_.height
	self:updateProps(props,parent)
end

function MButton:updateProps(props,parent)
	self:getComponent("MUIProtocol"):updateProps(props,parent)


	-- label
	if props.label and props.label ~= "" then
		--标签文本
		local listColor = props.labelColors and string.split(props.labelColors, ",") or {MButton.COLOR_LABEL_DEFAULT}
		local isStroke = props.labelStroke and tobool(props.labelStroke) or MButton.STROKE_LABEL_DEFAULT

		local lbl = self:createTTFLabel(props.label,props.labelSize,listColor[1],props.labelStroke)
		self:setButtonLabelElement(UIPushButton.NORMAL, lbl)

		if listColor[2] then
			self:setButtonLabelElement(UIPushButton.PRESSED, self:createTTFLabel(props.label,props.labelSize,listColor[2],props.labelStroke))
			if listColor[3] then
				self:setButtonLabelElement(UIPushButton.DISABLED, self:createTTFLabel(props.label,props.labelSize,listColor[3],props.labelStroke))
			else
				self:setButtonLabelElement(UIPushButton.DISABLED, lbl)
			end
		end
	elseif props.labelSkin and props.labelSkin ~= "" then
		--标签对象
		local url,suffix = MUtil.parseBtnSkin(props.labelSkin)
		self:setButtonLabelElement(display.newSprite("#" .. url .. "." .. suffix))
	end

	
	return self
end

function MButton:getDefaultDataBind()
	return self.setButtonLabelElement
end


--设置按钮标签
function MButton:setButtonLabelString(text)
	MButton.super.setButtonLabelString(self,UIPushButton.NORMAL,text)
	MButton.super.setButtonLabelString(self,UIPushButton.PRESSED,text)
	MButton.super.setButtonLabelString(self,UIPushButton.DISABLED,text)
	return self
end

function  MButton:setButtonLabel(label)
	MButton.super.setButtonLabel(self,UIPushButton.NORMAL,label)
	-- MButton.super.setButtonLabel(self,UIPushButton.PRESSED,label)
	-- MButton.super.setButtonLabel(self,UIPushButton.DISABLED,label)
	return self
end

function MButton:addWidget(widget)

end

-----------------custom-----------------

function MButton:setButtonLabelElement(v)
	print(self:getUIName(),type(v))
	if type(v) == "string" then
		self:setButtonLabelString(v)
	else
		self:setButtonLabel(v)
	end
end

function MButton:createTTFLabel( t,s,c,isStroke )
	local label
	t = t or ""
	s = s and tonumber(s) or FONT_SIZE_M
	if type(c) == "string" then
		c = DisplayUtil.convertToCCC3(c)
	end

	local param = {
		text = t,
		font = FONT_FAMILY,
		color = c,
		size = s,
		align = ui.TEXT_ALIGN_CENTER,
	}


	if isStroke then
		label = ui.newTTFLabelWithOutline(param)
	else
		label = ui.newTTFLabel(param)
	end

	return label
end

function MButton:getLayoutSize()
	local size = self.sprite_:getContentSize()
	return size.width,size.height
end

function MButton:setLayoutSize(width,height)
	if self.scale9_ then
		MButton.super.setButtonSize(self,width,height)
	end
	
	return self
end


return MButton