local PATTERN = "^%<meta%s+([^%>]+)%>%s*(.*)$"
local SPACE = "%s+$"

local Meta = {}

function Meta.parse (line)
	local ok, _, attr, content = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return {
		nodetype = "element";
		name = "meta";
		attr = string.format(" %s content=%q", attr:gsub(SPACE, ""), content);
	}
end

return Meta
