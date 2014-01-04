--
-- Author: Evans
-- Date: 2013-12-30 11:05:07
--模态层

local ModalLayer = class("ModalLayer", function(ccc4)
	if ccc4 then
		return display.newColorLayer(color)
	else
		return display.newColorLayer(ccc4(122,0,0,128))
	end
end)

function ModalLayer:ctor()
	self:setTouchEnabled(true)
end


function ModalLayer:setContent(content)
	-- body
end

function ModalLayer:onEnter()
	-- body
end

function ModalLayer:onExit()
	-- body
end



return ModalLayer