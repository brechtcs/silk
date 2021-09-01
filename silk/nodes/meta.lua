local PATTERN = "^%<meta%s+([^%>]+)%>%s*(.*)$"
local SPACE = "%s+$"

local Node = require "silk.nodes.base"
local Meta = {}

function Meta.parse (line)
	local ok, _, attr, content = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return Node:create {
		name = "meta";
		attr = string.format(" %s content=%q", attr:gsub(SPACE, ""), content);
	}
end

return Meta
