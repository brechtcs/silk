local OL = "%s*(%#+)%s+(.*)$"

local OrderedList = {}

function OrderedList.parse (line)
	local ok, _, mark, text = line:find(OL)
	if not ok then
		return nil, "not an ordered list line"
	end
	return {
		name = "ol";
		level = #mark;
		children = {
			{
				name = "li";
				children = { text };
			}
		};
		open = true;
	}
end

return OrderedList
