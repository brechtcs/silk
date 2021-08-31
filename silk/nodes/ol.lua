local OL = "%s*(%#+)%s+(.*)$"

local Node = require "silk.nodes.base"
local OrderedList = {}

function OrderedList.parse (line)
	local ok, _, mark, text = line:find(OL)
	if not ok then
		return nil, "not an ordered list line"
	end
	return Node:create {
		name = "ol";
		level = #mark;
		children = {
			Node:create {
				name = "li";
				children = { text };
			}
		};
		open = true;
	}
end

return OrderedList
