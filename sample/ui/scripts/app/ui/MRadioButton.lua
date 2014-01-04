--
-- Author: Evans
-- Date: 2014-01-04 11:29:17
--单选按钮
local UICheckBoxButton = cc.ui.UICheckBoxButton
local M = class("MRadioButton", UICheckBoxButton)

local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()

local function checkResCache(url,table,name)
	if sharedSpriteFrameCache:spriteFrameByName(url) then
		table[name] = "#" .. url
	end
end
----------override-----------

function M:ctor(props,parent)
	--update images
	local url,suffix = MUtil.parseBtnSkin(props.skin)

	local images = {
		off = "#" .. url .. "." .. suffix,
	}

	local urlOffPessed = url .. "_press." .. suffix
	local urlOffDisabled = url .. "_disabled." .. suffix
	local urlOn = url .. "_on." .. suffix
	local urlOnPessed = url .. "_on_press." .. suffix
	local urlOnDisabled = url .. "_on_disabled." .. suffix

	checkResCache(urlOffPessed,images,"off_pressed")
	checkResCache(urlOffDisabled,images,"off_disabled")
	checkResCache(urlOn,images,"on")
	checkResCache(urlOnPessed,images,"on_pressed")
	checkResCache(urlOnDisabled,images,"on_disabled")

	M.super.ctor(self,images,{scale9 = tobool(props.sizeGrid),touchInSprite = true})

	----------------

	MUtil.extend(self)
	self.sizeInit_ = self.sprite_ and self.sprite_:getContentSize() or {width = 10,height = 10}

	self.sizeInit_.width = props.width or self.sizeInit_.width
	self.sizeInit_.height = props.height or self.sizeInit_.height

	props.width = self.sizeInit_.width
	props.height = self.sizeInit_.height
	self:updateProps(props,parent)
end

function M:updateProps(props, parent)
	self:getComponent("MUIProtocol"):updateProps(props,parent)

	--label
	if not props.label or props.label == "" then
		return self
	end

	local listColor = props.labelColors and string.split(props.labelColors, ",") or {MButton.COLOR_LABEL_DEFAULT}
	local isStroke = props.labelStroke and tobool(props.labelStroke) or MButton.STROKE_LABEL_DEFAULT

	local lbl = self:createTTFLabel(props.label,props.labelSize,listColor[1],props.labelStroke)
	self:setButtonLabelElement(UICheckBoxButton.OFF, lbl)
	self:setButtonLabelElement(UICheckBoxButton.OFF_PRESSED, lbl)

	if listColor[2] then
		self:setButtonLabelElement(UICheckBoxButton.ON, self:createTTFLabel(props.label,props.labelSize,listColor[2],props.labelStroke))
		self:setButtonLabelElement(UICheckBoxButton.ON_PRESSED, self:createTTFLabel(props.label,props.labelSize,listColor[2],props.labelStroke))
		if listColor[3] then
			self:setButtonLabelElement(UICheckBoxButton.OFF_DISABLED, self:createTTFLabel(props.label,props.labelSize,listColor[3],props.labelStroke))
			self:setButtonLabelElement(UICheckBoxButton.ON_DISABLED, self:createTTFLabel(props.label,props.labelSize,listColor[3],props.labelStroke))
		else
			self:setButtonLabelElement(UICheckBoxButton.OFF_DISABLED, lbl)
			self:setButtonLabelElement(UICheckBoxButton.ON_DISABLED, lbl)
		end
	end
	return self
end

function M:getDefaultDataBind()
	return self.setButtonLabelElement
end


function M:setButtonLabelString(text)
	M.super.setButtonLabelString(self,UICheckBoxButton.OFF,text)
	M.super.setButtonLabelString(self,UICheckBoxButton.OFF_PRESSED,text)
	M.super.setButtonLabelString(self,UICheckBoxButton.OFF_DISABLED,text)

	M.super.setButtonLabelString(self,UICheckBoxButton.ON,text)
	M.super.setButtonLabelString(self,UICheckBoxButton.ON_PRESSED,text)
	M.super.setButtonLabelString(self,UICheckBoxButton.ON_DISABLED,text)
	return self
end

function M:setButtonLabel(label)
	M.super.setButtonLabel(self,UICheckBoxButton.OFF,label)
	M.super.setButtonLabel(self,UICheckBoxButton.OFF_PRESSED,label)
	M.super.setButtonLabel(self,UICheckBoxButton.OFF_DISABLED,label)

	M.super.setButtonLabel(self,UICheckBoxButton.ON,label)
	M.super.setButtonLabel(self,UICheckBoxButton.ON_PRESSED,label)
	M.super.setButtonLabel(self,UICheckBoxButton.ON_DISABLED,label)
end

-----------------custom--------------

--设置按钮标签
function M:setButtonLabelElement(v)
	if type(v) == "string" then
		self:setButtonLabelString(v)
	elseif iskindof(v, "CCNode") then
		self:setButtonLabel(v)
	end
end

return M