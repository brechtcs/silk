local EMPTY = "^%s*$"
local STYLE = "^%<style%s+([^%>]+)%>%s*(.*)$"
local CHARSET = "^%<charset%>%s*(.+)$"
local TITLE = "^%<title%>%s?(.+)$"

local Nodes = require "silk.nodes.all"
local Doc = {}

function Doc:new (doc)
	doc = doc or {}

	doc.charset = doc.charset or "utf-8"
	doc.title = doc.title or ""
	doc.head = doc.head or {}
	doc.head.style = doc.head.style or {}

	doc.body = doc.body or {}
	doc.body.header = doc.body.header or ""
	doc.body.footer = doc.body.footer or ""
	doc.body.main = {}

	setmetatable(doc, self)
	self.__index = self
	return doc
end

function Doc:parse_file (file)
	for line in file:lines() do
		self:parse_line(line)
	end
	return self
end

function Doc:parse_line (line)
	local done = self:try_empty(line)

	if not done and not self.head.closed then
		done = self:try_head(line)
	end
	if not done then
		self:try_body(line)
	end
end

function Doc:try_empty (line)
	if not line:find(EMPTY) then
		return false
	end

	local prev = self.body.main[#self.body.main]
	if prev and prev.open then
		prev.open = false
	end
	return true
end

function Doc:try_head (line)
	for _, Node in ipairs(Nodes.Head) do
		local node = Node.parse(line)
		if node then
			table.insert(self.head, node)
			return true
		end
	end
	return self:try_style(line)
		or self:try_title(line)
		or self:try_charset(line)
end

function Doc:try_style (line)
	local ok, _, selector, rule = line:find(STYLE)
	if not ok then
		return nil, "not a style line"
	end
	if not self.head.style[selector] then
		self.head.style[selector] = {}
	end
	table.insert(self.head.style[selector], rule)
	return true
end

function Doc:try_charset (line)
	local ok, _, charset = line:find(CHARSET)
	if not ok then
		return nil, "not a charset line"
	end
	self.charset = charset
	return true
end

function Doc:try_title (line)
	local ok, _, title = line:find(TITLE)
	if not ok then
		return nil, "not a title line"
	end
	self.title = title
	return true
end

function Doc:try_body (line)
	for _, Node in ipairs(Nodes.Body) do
		local node = Node.parse(line)
		if node then
			self:append_body(node)
			self:close_head()
			return true
		end
	end
end

function Doc:append_body (node)
	local depth = 1
	local prev = self.body.main[#self.body.main]
	if prev and prev.open then
		if prev.level and node.level then
			while node.level > depth do
				local deeper = prev.children[#prev.children]
				if not deeper or not deeper.level then break end
				depth = depth + 1
				prev = deeper
			end
		end
		local level = node.level and node.level == depth
		local flat = not node.level and prev.tag == node.tag
		if level or flat then
			for _, child in ipairs(node.children) do
				table.insert(prev.children, child)
			end
		elseif node.nodetype == "element" then
			table.insert(prev.children, node)
		else
			table.insert(self.body.main, node)
			prev.open = false
		end
	else
		table.insert(self.body.main, node)
	end
end

function Doc:close_head ()
	if not self.head.closed then
		self.head.closed = true;
	end
end

return Doc
