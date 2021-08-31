local UL = "%s*(%*+)%s+(.*)$"

local Node = require "silk.nodes.base"
local UnorderedList = {}

function UnorderedList.parse (line)
	local ok, _, mark, text = line:find(UL)
	if not ok then
		return nil, "not an unordered list line"
	end
	return Node:create {
		name = "ul";
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

return UnorderedList
