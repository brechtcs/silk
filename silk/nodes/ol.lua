local OL = "%s*(%#+)%s+(.*)$"

local OrderedList = {}

function OrderedList.parse (line)
	local ok, _, mark, text = line:find(OL)
	if not ok then
		return nil, "not an ordered list line"
	end
	return {
		nodetype = "element";
		name = "ol";
		level = #mark;
		children = {
			{
				nodetype = "element";
				name = "li";
				children = { text };
			}
		};
		open = true;
	}
end

return OrderedList
