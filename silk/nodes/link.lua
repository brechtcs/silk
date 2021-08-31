local PATTERN = "^link%[(%w+)%]%s+(.*)$"

local Node = require "silk.nodes.base"
local Link = {}

function Link.parse (line)
	local ok, _, rel, href = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return Node:create {
		name = "link";
		attr = string.format(" rel=%q href=%q", rel, href);
	}
end

return Link
