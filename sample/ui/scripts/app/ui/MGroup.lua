--
-- Author: Evans
-- Date: 2013-12-14 11:52:19
--容器/面板
local MImage = import(".MImage")
local MGroup = class("MGroup", cc.ui.UIGroup)


---------------override--------------

function MGroup:ctor(props,parent)
	self:setIsRoot(parent)
	self.isContainer_ = true
	MGroup.super.ctor(self)
	MUtil.extend(self)
	self:updateProps(props,parent)
	self:setNodeEventEnabled(true)

	--处理触摸事件默认方法
	self:setTouchEnabled(true)
	self:addTouchEventListener(function(evt,x,y)
		if evt == "began" then
			return true
		end
	end)
end


function MGroup:updateProps(props,parent)
	--bg
	if props.url then
		self:setBackgroundImage({url = props.url,sizeGrid = props.sizeGrid},self)
	end
	return self:getComponent("MUIProtocol"):updateProps(props,parent)
end

function MGroup:setBackgroundImage(props,parent)
	-- print("设置底图!!")
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
	if widget:getComponent("MUIProtocol") then
		if widget:getUIName() and widget:getUIName() ~= "" then
			local childName = widget:getUIName()
			assert(not self.childrenByName_[childName],string.format("already exist child named %s", childName))
			self.childrenByName_[childName],self[childName] = widget,widget
			echoInfo("addWidget %s<%s> to %s<%s>", widget.__cname,childName,self.__cname,self:getUIName())
		end
	end

	return self
end

function MGroup:onExit()
	print("onExit",self:getUIName(),self:retainCount())
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

--设置是否是面板根节点
function MGroup:setIsRoot(parent)
	self.isRoot_ = not tobool(parent)
	if self.isRoot_ then
		self.isOftenShow_ = false

		--给它一个关闭面板方法
		self.close = function(cleanup)
			local parent = self:getParent()
			if parent then
				if parent:getComponent("UISceneProtocol") then
					parent:closePanel(self.__cname,cleanup)
				else
					self:removeSelf(cleanup)
				end
			end
			return self
		end
	end
end

function MGroup:isRoot()
	return self.isRoot_
end


--设置面板是否经常打开
--如果是的话,被父容器移除时将不会被回收
function MGroup:isOftenShow(value)
	assert(self.isRoot_,"This is not the root node of the panel!!")
	if value then
		--setter
		if self.isOftenShow_ ~= value then
			self.isOftenShow_ = value
			if value then
				self:retain()
			else
				self:release()
			end
		end
		return self
	else
		--getter
		return self.isOftenShow_
	end
end



return MGroup