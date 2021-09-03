local PATTERN = "^%s*([%|%$])([^%>]*)%>%s?(.*)"

local Preformatted = {}

function Preformatted.parse (line)
	local ok, _, mark, attr, text = line:find(PATTERN)
	if not ok then
		return nil, "not a preformatted line"
	end
	local node = {
		nodetype = "element";
		tag = "pre";
		attr = attr;
		children = { text };
		open = true;
		sep = "\n";
	}
	if mark == "$" then
		node.tag = "code"
		node.outer = "<pre>%s</pre>"
	end
	return node
end

return Preformatted
