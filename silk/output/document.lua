local DOCUMENT = "<!doctype html><html>%s%s</html>\n"

local Partial = require "silk.output.partial"
local Document = {}

function Document:render_style (doc)
	local blocks = {}
	for selector, rules in pairs(doc.head.style) do
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

function Document:render_head (doc)
	local head = "<head>"
	head = head .. string.format("<meta charset=%q>", doc.charset)
	head = head .. string.format("<title>%s</title>", doc.title)
	for _, node in ipairs(doc.head) do
		head = head .. Partial:render_node(node)
	end
	return head .. self:render_style(doc) .. "</head>"
end

function Document:render_body (doc)
	local body = "<body>" .. doc.body.header
	for _, node in ipairs(doc.body.main) do
		body = body .. Partial:render_node(node)
	end
	return body .. doc.body.footer .. "</body>"
end

function Document:render (doc)
	return DOCUMENT:format(self:render_head(doc), self:render_body(doc))
end

return Document
