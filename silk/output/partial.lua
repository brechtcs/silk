local CONTAINER = "<%s%s>%s</%s>"
local EMPTY = "<%s%s>"
local SPACE = "%s+$"

local Partial = {}

function Partial:render_node (node)
	if type(node) == "string" then
		return node
	elseif node.nodetype == "html" then
		return node.content
	end
	node.attr = node.attr and node.attr:gsub(SPACE, "") or ""
	if not node.children then
		return EMPTY:format(node.tag, node.attr)
	end
	local inner = ""
	for _, child in ipairs(node.children) do
		local br = #inner > 0 and node.sep or ""
		inner = inner .. br .. self:render_node(child)
	end
	local outer = CONTAINER:format(node.tag, node.attr, inner, node.tag)
	if node.outer then
		outer = node.outer:format(outer)
	end
	return outer
end

function Partial:render (doc)
	local partial = ""
	for _, node in ipairs(doc.body.main) do
		partial = partial .. self:render_node(node)
	end
	return partial
end

return Partial
