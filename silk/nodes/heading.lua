local PATTERN = "^%s*%<h(%d)(.*)%>%s?(.*)$"

local Node = require "silk.nodes.base"
local Heading = {}

function Heading.parse (line)
	local ok, _, level, attr, text = line:find(PATTERN)
	if not ok then
		return nil, "not a header line"
	end
	return Node:create {
		name = string.format('h%d', level);
		children = { text };
		attr = attr;
	}
end

return Heading
