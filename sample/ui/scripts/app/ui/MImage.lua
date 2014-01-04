--
-- Author: Evans
-- Date: 2013-12-16 10:45:36
--图片

local MImage = class("MImage", function(props)
	local url = MUtil.parseUrl(props.url)
    if props and tobool(props.sizeGrid) then
        return display.newScale9Sprite(url)
    else
        return display.newSprite(url)
    end
end)

function MImage:ctor(props,parent)
    makeUIControl_(self)
    local contentSize = self:getContentSize()
    self:getComponent("components.ui.LayoutProtocol"):setLayoutSize(contentSize.width, contentSize.height)
    self.isScale9_ = props and tobool(props.sizeGrid)
    if self.isScale9_ then
        self:setLayoutSizePolicy(display.AUTO_SIZE, display.AUTO_SIZE)
    end

    MUtil.extend(self)
    self:updateProps(props,parent)
end

function MImage:setLayoutSize(width, height)
    self:getComponent("components.ui.LayoutProtocol"):setLayoutSize(width, height)
    local width, height = self:getLayoutSize()
    local top, right, bottom, left = self:getLayoutPadding()
    width = width - left - right
    height = height - top - bottom

    if self.isScale9_ then
        self:setContentSize(CCSize(width, height))
    else
        local boundingSize = self:getBoundingBox().size
        local sx = width / (boundingSize.width / self:getScaleX())
        local sy = height / (boundingSize.height / self:getScaleY())
        if sx > 0 and sy > 0 then
            self:setScaleX(sx)
            self:setScaleY(sy)
        end
    end

    if self.layout_ then
        self:setLayout(self.layout_)
    end

    return self
end

function MImage:getDefaultDataBind()
    return self.setImage
end

--以后可更换为setDisplayFrame
function MImage:setImage(url)
    -- echoInfo("MImage's setImage function has not implemented!")
    self:setDisplayFrame(display.newSpriteFrame(url))
    return self
end

return MImage