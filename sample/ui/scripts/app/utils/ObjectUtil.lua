--
-- Author: Evans
-- Date: 2013-12-11 11:44:36
--
local ObjectUtil = {}


--在全局中添加一个变量
function regObjInGlobal(name,obj)
    _G[name] = obj
    package.loaded[name] = obj
end

local function search( k,pList )
    for i=1,#pList do
        local v = pList[i][k]
        if v then
            return v
        end
    end
end


local function setInterface( obj,pList )
    local target
    if type(obj) == "userdata" then
        target = tolua.getpeer(obj)
        if not target then
            target = {}
            tolua.setpeer(obj, target)
        end
        -- pList[#pList + 1] = getmetatable(target)
    else
        target = obj
        -- target.funcA()
        -- pList[#pList + 1] = target
    end
    pList[#pList + 1] = getmetatable(target)

    setmetatable(target, {__index = function ( t,k )
        local v = search(k,pList)
        t[k] = v
        return v
    end})
end

--多继承(实现接口)
--
--classname 类名
--super 超类(可以是function/table)
--pList 其他父类
function ObjectUtil.multiClass( classname,super,pList )
    local superType = type(super)
    local cls
    cls = class(classname, super)

    -- dump(super)

    if pList then
        if superType == "function" or (super and super.__ctype == 1) then
            cls.new = function( ... )
                local instance = cls.__create(...)
                -- copy fields from class to native object
                setInterface(instance,pList)
                for k,v in pairs(cls) do instance[k] = v end
                instance.class = cls
                instance:ctor(...)
                return instance
            end
        else
            cls.new = function( ... )
                local instance = setmetatable({}, cls)
                setInterface(instance,pList)
                instance.class = cls
                instance:ctor(...)
                return instance
            end
        end
    end

    regObjInGlobal(classname,cls) 

    return cls
end

function checkObjType(obj,checkType,atLevel)
    if type(obj) ~= checkType then
        if atLevel then
            error("param type error",atLevel + 1)
        end
        
        return false
    else
        return true
    end

end

--将对象设为单例对象
--使用方法:放在类的ctor方法里
function ObjectUtil.setToSingleton(target)
    assert(target.__cname,"The class object is specified param in this method!")
    if _G[target.__cname] then
        error(string.format("The instance of this class(%s) already exists!Do not new again", target.__cname),2)
    else
        _G[target.__cname] = target
        _G[target.__cname].instance = target
    end
    return target
end


regObjInGlobal("ObjectUtil",ObjectUtil) 

return ObjectUtil