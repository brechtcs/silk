local PATTERN = "^meta%[(%w+)%]%s+(.*)$"

local Node = require "silk.nodes.base"
local Meta = {}

function Meta.parse (line)
	local ok, _, name, content = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return Node:create {
		name = "meta";
		attr = string.format(" name=%q content=%q", name, content);
	}
end

return Meta
