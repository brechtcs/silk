local PATTERN = "^%s*(.+)$"

local Node = require "silk.nodes.base"
local Paragraph = {}

function Paragraph.parse (line)
	local _, _, content = line:find(PATTERN)

	return Node:create {
		name = "p";
		children = { content };
		sep = "<br>";
		open = true;
	}
end

return Paragraph
