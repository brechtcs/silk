local PATTERN = "^%s*%<h(%d)(.*)%>%s?(.*)$"

local Heading = {}

function Heading.parse (line)
	local ok, _, level, attr, text = line:find(PATTERN)
	if not ok then
		return nil, "not a header line"
	end
	return {
		nodetype = "element";
		tag = string.format('h%d', level);
		children = { text };
		attr = attr;
	}
end

return Heading
