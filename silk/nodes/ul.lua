local UL = "%s*(%*+)%s+(.*)$"

local UnorderedList = {}

function UnorderedList.parse (line)
	local ok, _, mark, text = line:find(UL)
	if not ok then
		return nil, "not an unordered list line"
	end
	return {
		nodetype = "element";
		tag = "ul";
		level = #mark;
		children = {
			{
				nodetype = "element";
				tag = "li";
				children = { text };
			}
		};
		open = true;
	}
end

return UnorderedList
