--
-- Author: Evans
-- Date: 2013-12-14 15:04:03
--
local MUIProtocol = class("MUIProtocol", cc.Registry.classes_["components.Component"])


function MUIProtocol:ctor()
    MUIProtocol.super.ctor(self, "MUIProtocol")
end

--更新属性
function MUIProtocol:updateProps(props,parent)
	if not props then
		error("props must not be nil",2)
	end

	if iskindof(self, "MUIProtocol") then
		self = self:getTarget()
	end


	--name
	if props.name then
		self:setUIName(props.name)
	end
	--size
	local width,height = MUtil.computeSize(self,props,parent)

	self:setLayoutSize(width, height)
	

	--position
	local x,y = MUtil.computePos(self,props,parent)

	DisplayUtil.posUI(self,x, y,parent)

	return self
end




function MUIProtocol:getUIName()
	if iskindof(self, "MUIProtocol") then
		self = self:getTarget()
	end
	return self.UIName_ or ""
end

function MUIProtocol:setUIName(name)
	name = name or ""

	if iskindof(self, "MUIProtocol") then
		self = self:getTarget()
	end
	self.UIName_ = name
	return self
end

--设置数据,将针对getDefaultDataBind得到的默认属性对应赋值
function MUIProtocol:setData(...)
	local args = ...
	if type(args) ~= "table" then
		args = {args}
	end
	if iskindof(self, "MUIProtocol") then
		self = self:getTarget()
	end
	-- body
	if iskindof(self, "UIGroup") and self.isContainer_ then
		--如果是容器
		for k,v in pairs(args) do
			local child = self:getChildByName(k)
			if child then
				child:setData(v)
			else
				echoInfo("Can't find child named <%s> in %s <%s>", k,self.__cname,self:getUIName())
			end
		end
	else
		--如果不是
		for i,v in ipairs({self:getDefaultDataBind()}) do
			v(self,args[i])
		end
	end
	
end

--获取组件默认属性
function MUIProtocol:getDefaultDataBind()
	-- body
end


function MUIProtocol:exportMethods()
    self:exportMethods_({
        "updateProps",
        "getUIName",
        "setUIName",
        "setData",
        "getDefaultDataBind",
    })
    return self
end

function MUIProtocol:onBind_(target)
	target.uiName_ = ""
	display.align(target, display.LEFT_TOP)
end

return MUIProtocol