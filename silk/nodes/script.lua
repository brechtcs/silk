local PATTERN = "^%<script(%s+[^%>]+)%>%s*(.*)$"

local Script = {}

function Script.parse (line)
	local ok, _, attr, script = line:find(PATTERN)
	if not ok then
		return nil, "not a link line"
	end
	return {
		nodetype = "element";
		tag = "script";
		attr = attr;
		children = { script };
	}
end

return Script
