local PATTERN = "^%s*(.+)$"

local Paragraph = {}

function Paragraph.parse (line)
	local _, _, content = line:find(PATTERN)

	return {
		nodetype = "element";
		name = "p";
		children = { content };
		sep = "<br>";
		open = true;
	}
end

return Paragraph
