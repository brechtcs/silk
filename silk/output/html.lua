local DOCUMENT = "<!doctype html><html>%s%s</html>\n"
local CONTAINER = "<%s%s>%s</%s>"
local EMPTY = "<%s%s>"
local SPACE = "%s+$"

local function render_node (self)
	if type(self) == "string" then
		return self
	elseif self.nodetype == "html" then
		return self.content
	end
	self.attr = self.attr and self.attr:gsub(SPACE, "") or ""
	if not self.children then
		return EMPTY:format(self.tag, self.attr)
	end
	local inner = ""
	for _, child in ipairs(self.children) do
		local br = #inner > 0 and self.sep or ""
		inner = inner .. br .. render_node(child)
	end
	return CONTAINER:format(self.tag, self.attr, inner, self.tag)
end

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
		head = head .. render_node(node)
	end
	return head .. render_style(self) .. "</head>"
end

local function render_body (self)
	local body = "<body>" .. self.body.header
	for _, node in ipairs(self.body.main) do
		body = body .. render_node(node)
	end
	return body .. self.body.footer .. "</body>"
end

return function (doc)
	return DOCUMENT:format(render_head(doc), render_body(doc))
end
