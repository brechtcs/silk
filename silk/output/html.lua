local HTML5 = "<!doctype html><html>%s%s</html>\n"

local function render_style (self)
	local blocks = {}
	for selector, rules in pairs(self.head.style) do
		local block = selector .. "{"
		for _, rule in ipairs(rules) do
			block = block .. rule .. ";"
		end
		block = block .. "}"
		table.insert(blocks, block)
	end
	if #blocks > 0 then
		return "<style>" .. table.concat(blocks, " ") .. "</style>"
	else
		return ""
	end
end

local function render_head (self)
	local head = "<head>"
	head = head .. string.format("<meta charset=%q>", self.charset)
	head = head .. string.format("<title>%s</title>", self.title)
	for _, node in ipairs(self.head) do
		head = head .. tostring(node)
	end
	return head .. render_style(self) .. "</head>"
end

local function render_body (self)
	local body = "<body>" .. self.body.header
	for _, node in ipairs(self.body.main) do
		body = body .. tostring(node)
	end
	return body .. self.body.footer .. "</body>"
end

return function (doc)
	return HTML5:format(render_head(doc), render_body(doc))
end
