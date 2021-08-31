local quarg = { sep = "&"; }

function quarg:extract (argv)
	local query = ""
	local idx = 1

	while argv[idx] do
		local _, _, opt = argv[idx]:find("^%-%-(.+)$")
		if opt then 
			local sep = #query > 0 and self.sep or ""
			query = query .. sep .. opt
			table.remove(argv, idx)
		else
			idx = idx + 1
		end
	end
	return self:parse(query)
end

function quarg:parse (str)
	local values = {}
	for key,val in str:gmatch(string.format('([^%q=]+)(=*[^%q=]*)', self.sep, self.sep)) do
		local keys = {}
		key = key:gsub('%[([^%]]*)%]', function(v)
			-- extract keys between balanced brackets
			if string.find(v, "^-?%d+$") then
				v = tonumber(v)
			end
			table.insert(keys, v)
			return "="
		end)
		key = key:gsub('=+.*$', "")
		val = val:gsub('^=+', "")

		if not values[key] then
			values[key] = {}
		end
		if #keys > 0 and type(values[key]) ~= 'table' then
			values[key] = {}
		elseif #keys == 0 and type(values[key]) == 'table' then
			values[key] = val
		end

		local t = values[key]
		for i,k in ipairs(keys) do
			if type(t) ~= 'table' then
				t = {}
			end
			if k == "" then
				k = #t+1
			end
			if not t[k] then
				t[k] = {}
			end
			if i == #keys then
				t[k] = val
			end
			t = t[k]
		end
	end
	setmetatable(values, { __tostring = function() return str end  })
	return values
end

return quarg
