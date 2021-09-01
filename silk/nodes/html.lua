local HTML = "^%s*(<[^>]+>)%s*$"

local Html = {}

function Html.parse (line)
	local ok, _, html = line:find(HTML)
	if not ok then
		return nil, "not a raw html line"
	end
	return {
		nodetype = "html";
		content = html;
	}
end

return Html
