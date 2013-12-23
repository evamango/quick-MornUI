--
-- Author: Evans
-- Date: 2013-12-14 11:01:20
--
local DisplayUtil = {}
regObjInGlobal("DisplayUtil",DisplayUtil)

--用UI的坐标系去定位
function DisplayUtil.posUI( target,x,y,parent )
	display.align(target, display.TOP_LEFT)

	if parent then
		display.align(parent, display.TOP_LEFT)
		target:pos(x, -y)
	else
		local p = CCDirector:sharedDirector():convertToUI(CCPoint(x,y))
		target:pos(p.x, p.y)
	end
	return target
end

local STR_MATCH_RGB = {"#","0x","ox"}

--将"#FFFFFF","0XFFFFFF"或"FFFFFF"转换为CCC3颜色对象
function DisplayUtil.convertToCCC3( v )
	if not v then
		return ccc3(0, 0, 0)
	end

	v = tostring(v)
	local s,e
	--找颜色值开始下标
	for _,strMatch in ipairs(STR_MATCH_RGB) do
		s,e = string.find(v, strMatch)
		if e then
			break
		end
	end

	e = e + 1 or 1

	local function getRGB( str )
		if string.len(str) == 1 then
			str = string.rep(str, 6)
		elseif string.len(str) == 3 then
			local r = string.sub(str, 1,1)
			local g = string.sub(str, 2,2)
			local b = string.sub(str, 3,3)
			local t = {r,r,g,g,b,b}
			str = table.concat(t)
		end
		return tonumber(string.sub(str, 1,2),16),tonumber(string.sub(str, 3,4),16),tonumber(string.sub(str, 5,6),16)
	end

	v = string.sub(v,e)
	return ccc3(getRGB(v))
end

return DisplayUtil