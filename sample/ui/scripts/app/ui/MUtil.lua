--
-- Author: Evans
-- Date: 2013-12-14 11:52:50
--
local MUtil = {}
regObjInGlobal("MUtil",MUtil)


--UI类
MUtil.UI_TAGS = {
    Box = "MGroup",
    Button = "MButton",
    Image = "MImage",
    Label = "MLabel",
    TextInput = "MEditBox",
    ImageWithBorder = "MImageBorder",
    -- CombineButton = {
    --     label = "MButton",
    -- },
}

--容器
MUtil.CONTAINER = {
    Box = true,
    -- CombineButton = true,
}



--组件
MUtil.COMPONENTS = {
    MUIProtocol = ".components.MUIProtocol",
    UISceneProtocol = ".components.UISceneProtocol",
}

local function importClass( table )
    for _,v in pairs(table) do
        if type(v) == "string" then
            local cls = import("app.ui.".. v)
            cc.Registry.add(cls, v)

        else
            importClass(v)
        end
        
    end
end


--注册类
importClass(MUtil.UI_TAGS)




--注册组件
for k,v in pairs(MUtil.COMPONENTS) do
    local cls = import(v)
    cc.Registry.add(cls, k)
end




--根据面板名称得到UI
function MUtil.getUIByName(name)
    if IS_RELEASE then
        --发布版的加载方式
        require(UI_TABLE_URL .. UI_ALL)
    else
        --开发版的加载方式
        require(UI_TABLE_URL .. name)
    end
    local table = _G["ui_" .. name .. "_table"]

    local t,tagName = MUtil.handlleUITable(table)
    dump(t)
    return MUtil.parseFromTable(tagName,t)
end

function MUtil.handlleUITable(table)
    local t = {}
    local cTagName = table[0]

    --设置默认值,防止MornUI里没生成
    -- if cTagName == "CombineButton" and not table.type then
    --     table.type = "label"
    -- end


    for k,v in pairs(table) do
        local tagName = v[0]
        
        if MUtil.UI_TAGS[tagName] then
            assert(t,"t不能为空")
            --处理子对象
            if MUtil.CONTAINER[tagName] then
                --处理子容器对象
                t[#t + 1] = MUtil.handlleUITable(v)
            else
                --其他子对象
                if k == 1 and tagName == "Image" and v.name == "bg" then
                    --底图
                    t.url = v.url
                    t.sizeGrid = v.sizeGrid
                else
                    t[#t + 1] = v
                end
                
            end
        else
            assert(t,"t不能为空")
            --处理背景属性
            t[k] = v
        end
    end

    return t,cTagName
end




--将table解释成UI
function MUtil.parseFromTable( tagName,table,parent )
    local children
    local props


    --update props & children
    for k,v in pairs(table) do
        if k ~= 0 then
            if type(k) == "number" and MUtil.UI_TAGS[v[0]] then
                -- update children list
                children = children or {}
                children[#children + 1] = {key = v[0], value = v}
            else
                props = props or {}
                props[k] = v
            end
        end
    end
    local className = props.type and MUtil.UI_TAGS[tagName][props.type] or MUtil.UI_TAGS[tagName]
    if type(className) == "table" then
        dump(props)
    end
	local ui = tagName and cc.Registry.newObject(className,props,parent)
    assert(ui,"缺少ui组件")

    --add children
    if children then
        for _,v in ipairs(children) do
            local child = MUtil.parseFromTable(v.key,v.value,ui)
            ui:addWidget(child)
        end
    end


    table = nil

	return ui
end

MUtil.IMG_SUFFIX = {
    png = true,
    jpg = true,
}

function MUtil.parseUrl(url)
    -- body
    local list = string.split(url, ".")
    if MUtil.IMG_SUFFIX[list[#list]] then
        return url
    end
    return "#" .. list[#list] .. "." .. list[1]
end

function MUtil.parseBtnSkin( url )
    local list = string.split(url, ".")
    return list[#list],list[1]
end

function MUtil.extend( obj )
    obj:addComponent("MUIProtocol"):exportMethods()
end

--计算尺寸
--相对父容器2边距离(left,right,top,bottom) > 百分比尺寸(pWidth,pHeight) > 绝对尺寸(width,height)
function MUtil:computeSize(props,parent)
    
    local width
    local height
    local parentWidth,parentHeight = MUtil.computeParentSize(parent)

    --width--
    if props.left and props.right then
        width = parentWidth - toint(props.left) - toint(props.right)
    elseif props.pWidth then
        width = parentWidth * toint(props.pWidth) / 100
    else
        width = toint(MUtil.checkProps_(self,props.width,"width"))
    end

    --height--
    if props.top and props.bottom then
        height = parentHeight - toint(props.top) - toint(props.bottom)
    elseif props.pHeight then
        height = parentHeight * toint(props.pHeight) / 100
    else
        height = toint(MUtil.checkProps_(self,props.height,"height"))
    end

    return width,height
end

--计算位置
-- 相对中心坐标centerX,centerY > 相对父容器坐标(left,right,top,bottom) > 百分比坐标(px,py) > 绝对坐标(x,y)
function MUtil:computePos(props,parent)
    
    local x
    local y
    local parentWidth,parentHeight = MUtil.computeParentSize(parent)

    --X--
    if props.centerX then
        x = (parentWidth - self:getLayoutSize()) / 2 + toint(props.centerX)
    elseif props.left then
        x = toint(props.left)
    elseif props.right then
        x = parentWidth - toint(props.right) - self:getLayoutSize()
    elseif props.px then
        x = parentWidth * toint(props.px) / 100
    else
        x = toint(MUtil.checkProps_(self,props.x,"x"))
    end

    --Y--
    local _,hSelf = self:getLayoutSize()
    if props.centerY then
        y = (parentHeight - hSelf) / 2 + toint(props.centerY)
    elseif props.top then
        y = toint(props.top)
    elseif props.bottom then
        y = parentHeight - toint(props.bottom) - hSelf
    elseif props.py then
        y = parentHeight * toint(props.py) / 100
    else
        y = toint(MUtil.checkProps_(self,props.y,"y"))
    end

    return x,y
end

--计算父容器尺寸
function MUtil.computeParentSize(parent)
    local parentWidth
    local parentHeight

    if parent then
        if iskindof(parent, "UIGroup") then
            parentWidth = parent:getLayoutSize()
        else
            parentWidth = parent:getContentSize().width
        end
    else
        parentWidth = display.width
    end

    if parent then
        if iskindof(parent, "UIGroup") then
            _,parentHeight = parent:getLayoutSize()
        else
            parentHeight = parent:getContentSize().height
        end
    else
        parentHeight = display.height
    end

    return parentWidth,parentHeight
end

function MUtil:checkProps_(value,propName)
    if value == nil then
        -- echoInfo("warning!! %s(%s) has not set <%s> value and will set it to defautlt value!", self.__cname,self:getUIName(),propName)
        -- if propName == "width" or propName == "heigh" then
        --     return 10
        -- end
        return 0
    end
    return value
end

--尽量不要使用!
function MUtil.newTTFLabelWithOutline(params)
    -- body
    local label = ui.newTTFLabelWithOutline(params)

    local children = label:getChildren()
    if not children then
        return
    end
    local len = children:count()
    local child
    for i=0,len - 1 do
        child = tolua.cast(children:objectAtIndex(i), "CCNode")
        if i == 0 then
            --move right
            child:align(display.LEFT_TOP,1,0)
        elseif i == 1 then
            --move left
            child:align(display.LEFT_TOP,-1,0)
        elseif i == 2 then
            --move down
            child:align(display.LEFT_TOP,0,-1)
        elseif i == 3 then
            --move up
            child:align(display.LEFT_TOP,0,1)
        else
            child:align(display.LEFT_TOP,0,0)
        end
        
    end

    return label
end



return MUtil