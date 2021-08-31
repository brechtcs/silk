local CONTAINER = "<%s%s>%s</%s>"
local EMPTY = "<%s%s>"

local Element = {}

function Element:create (el)
	assert(el.name)
	el.attr = el.attr or ""
	el.sep = el.sep or ""
	setmetatable(el, self)
	self.__index = self
	return el
end

function Element:__tostring ()
	if not self.children then
		return EMPTY:format(self.name, self.attr)
	end
	local inner = ""
	for _, child in ipairs(self.children) do
		local br = #inner > 0 and self.sep or ""
		inner = inner .. br .. tostring(child)
	end
	return CONTAINER:format(self.name, self.attr, inner, self.name)
end

return Element
