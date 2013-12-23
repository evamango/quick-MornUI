--
-- Author: Evans
-- Date: 2013-12-14 11:52:19
--
local MImage = import(".MImage")
local MGroup = class("MGroup", cc.ui.UIGroup)


---------------override--------------

function MGroup:ctor(props,parent)
	self.isContainer_ = true
	MGroup.super.ctor(self)
	MUtil.extend(self)
	self:updateProps(props,parent)
	self:setNodeEventEnabled(true)
end

function MGroup:updateProps(props,parent)
	--bg
	if props.url then
		self:setBackgroundImage({url = props.url,sizeGrid = props.sizeGrid},self)
	end
	return self:getComponent(".MUIProtocol").updateProps(self,props,parent)
end

function MGroup:setBackgroundImage(props,parent)
	local imgBG = MImage.new(props, parent)
	imgBG:setLayoutSize(self:getLayoutSize())
    self.backgroundSprite_ = imgBG
    self:addChild(self.backgroundSprite_)
    return self
end

function MGroup:addWidget(widget)
	MGroup.super.addWidget(self,widget)
	--根据UI名字索引子对象
	self.childrenByName_ = self.childrenByName_ or {}
	if widget:getComponent(".MUIProtocol") then
		if widget:getUIName() and widget:getUIName() ~= "" then
			local childName = widget:getUIName()
			assert(not self.childrenByName_[childName],string.format("already exist child named %s", childName))
			self.childrenByName_[childName],self[childName] = widget,widget
			echoInfo("addWidget %s<%s> to %s<%s>", widget.__cname,childName,self.__cname,self:getUIName())
		end
	end

	return self
end

---------------custom------------------

function MGroup:getChildByName(name)
	return self.childrenByName_ and self.childrenByName_[name]
end

function MGroup:removeWidget(widget,cleanup)
	self:removeChild(widget,cleanup)
    self:getLayout():removeWidget(widget)

    local childName = widget:getUIName()
    if self.childrenByName_ and self.childrenByName_[childName] then
		self.childrenByName_[childName],self[childName] = nil,nil
		echoInfo("removeWidget %s<%s> from %s<%s>", widget.__cname,childName,self.__cname,self:getUIName())
	end
    return self
end



return MGroup