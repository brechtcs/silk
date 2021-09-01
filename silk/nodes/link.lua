local PATTERN = "^%<link%s+([^%>]+)%>%s*(.*)$"

local Link = {}

function Link.parse (line)
	local ok, _, attr, href = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return {
		nodetype = "element";
		name = "link";
		attr = string.format(" href=%q %s", href, attr);
	}
end

return Link
