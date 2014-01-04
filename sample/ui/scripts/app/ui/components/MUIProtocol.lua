--
-- Author: Evans
-- Date: 2013-12-14 15:04:03
--
local MUIProtocol = class("MUIProtocol", cc.Registry.classes_["components.Component"])

-------------override-----------

function MUIProtocol:ctor()
    MUIProtocol.super.ctor(self, "MUIProtocol")
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

----------custom--------------

--更新属性
function MUIProtocol:updateProps(props,parent)
	if not props then
		error("props must not be nil",2)
	end

	local target = self.target_
	--name
	if props.name then
		target:setUIName(props.name)
	end
	--size
	local width,height = MUtil.computeSize(target,props,parent)

	target:setLayoutSize(width, height)
	

	--position
	local x,y = MUtil.computePos(target,props,parent)

	DisplayUtil.posUI(target,x, y,parent)

	return self
end




function MUIProtocol:getUIName()
	return self.target_.UIName_ or ""
end

function MUIProtocol:setUIName(name)
	name = name or ""
	self.target_.UIName_ = name
	return self
end

--设置数据,将针对getDefaultDataBind得到的默认属性对应赋值
function MUIProtocol:setData(...)
	local args = ...
	if type(args) ~= "table" then
		args = {args}
	end

	local target = self.target_
	-- body
	if iskindof(target, "UIGroup") and target.isContainer_ then
		--如果是容器
		for k,v in pairs(args) do
			local child = target:getChildByName(k)
			if child then
				child:setData(v)
			else
				echoInfo("Can't find child named <%s> in %s <%s>", k,target.__cname,target:getUIName())
			end
		end
	else
		--如果不是
		for i,v in ipairs({target:getDefaultDataBind()}) do
			v(target,args[i])
		end
	end

	return self
	
end

--获取组件默认属性
function MUIProtocol:getDefaultDataBind()
	-- body
end




return MUIProtocol