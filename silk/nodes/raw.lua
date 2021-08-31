local HTML = "^%s*(<[^>]+>)%s*$"

local Raw = {}

function Raw.parse (line)
	local ok, _, raw = line:find(HTML)
	if not ok then
		return nil, "not a raw html line"
	end
	return raw
end

return Raw
