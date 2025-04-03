local json = require "JSON"

local M = {}

local color_log, unpack, tostring = client.log, unpack, tostring
local concat, insert, remove = table.concat, table.insert, table.remove
local sub, rep, len = string.sub, string.rep, string.len
local COLOR_SYM_DEFAULT, COLOR_STRING_DEFAULT, COLOR_LITERAL_DEFAULT, COLOR_QUOTE_DEFAULT = {221, 221, 221}, {180, 230, 30}, {96, 160, 220}, {218, 230, 30}

local function skip_delim(str, pos, delim, err_if_missing)     
	pos = pos + #str:match('^%s*', pos)  

	if str:sub(pos, pos) ~= delim then      
		if err_if_missing then              
			error('Expected ' .. delim .. ' near position ' .. pos)     
		end

		return pos, false 
	end

	return pos + 1, true
end

local function parse_str_val(str, pos, val)    
	val = val or ''

	local early_end_error = 'End of input found while parsing string.'   

	if pos > #str then 
		error(early_end_error) 
	end

	local c = str:sub(pos, pos)

	if c == '"'  then 
		return val, pos + 1 
	end

	if c ~= '\\' then 
		return parse_str_val(str, pos + 1, val .. c)
	end

	local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
	local nextc = str:sub(pos + 1, pos + 1)

	if not nextc then 
		error(early_end_error) 
	end

	return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
end

local function parse_num_val(str, pos)     
	local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos) 
	local val = tonumber(num_str) 

	if not val then 
		error('Error parsing number at position ' .. pos .. '.') 
	end

	return val, pos + #num_str
end

function M.format(json_text, line_feed, indent, ac)
	json_text = tostring(json_text)
	line_feed, indent, ac = tostring(line_feed or "\n"), tostring(indent or "\t"), tostring(ac or " ")

	local i, j, k, n, r, p, q  = 1, 0, 0, len(json_text), {}, nil, nil
	local al = sub(ac, -1) == "\n"

	for x = 1, n do
		local c = sub(json_text, x, x)

		if not q and (c == "{" or c == "[") then
			r[i] = p == ":" and (c .. line_feed) or (rep(indent, j) .. c .. line_feed)
			j = j + 1
		elseif not q and (c == "}" or c == "]") then
			j = j - 1
			if p == "{" or p == "[" then
				i = i - 1
				r[i] = rep(indent, j) .. p .. c
			else
				r[i] = line_feed .. rep(indent, j) .. c
			end
		elseif not q and c == "," then
			r[i] = c .. line_feed
			k = -1
		elseif not q and c == ":" then
			r[i] = c .. ac
			if al then
				i = i + 1
				r[i] = rep(indent, j)
			end
		else
			if c == '"' and p ~= "\\" then
				q = not q and true or nil
			end
			if j ~= k then
				r[i] = rep(indent, j)
				i, k = i + 1, j
			end
			r[i] = c
		end
		p, i = c, i + 1
	end

	return concat(r)
end
local pretty_json = M.format

function M.highlight(json_text, color_sym, color_quote, color_string, color_literal)
	color_sym, color_string, color_literal, color_quote = color_sym or COLOR_SYM_DEFAULT, color_string or COLOR_STRING_DEFAULT, color_literal or COLOR_LITERAL_DEFAULT, color_quote or COLOR_QUOTE_DEFAULT
	json_text = tostring(json_text)

	local i, n, result, prev, quote = 1, len(json_text), {}, nil, nil

	local cur_clr, cur_text = color_sym, {}

	for x = 1, n do
		local c = sub(json_text, x, x)
		local new_clr

		if not quote and (c == "{" or c == "[") then
			new_clr = color_sym

			insert(cur_text, c)
		elseif not quote and (c == "}" or c == "]") then
			new_clr = color_sym
			if prev == "{" or prev == "[" then
				insert(cur_text, concat(prev, c))
			else
				insert(cur_text, c)
			end
		elseif not quote and (c == "," or c == ":") then
			new_clr = color_sym
			insert(cur_text, c)
		else
			if c == '"' and prev ~= "\\" then
				quote = not quote and true or nil
				new_clr = color_quote
			elseif cur_clr == color_quote then
				new_clr = quote and color_string or color_literal
			elseif cur_clr == color_sym and (c ~= " " and c ~= "\n" and c ~= "\t") then
				new_clr = quote and color_string or color_literal
			end

			insert(cur_text, c)
		end

		if new_clr ~= nil and new_clr ~= cur_clr then
			local new_text = {remove(cur_text, #cur_text)}

			insert(result, {cur_clr[1], cur_clr[2], cur_clr[3], concat(cur_text)})

			cur_clr, cur_text = new_clr, new_text
		end

		prev = c
	end

	if #cur_text > 0 then
		insert(result, {cur_clr[1], cur_clr[2], cur_clr[3], concat(cur_text)})
	end

	return result
end
local highlight_json = M.highlight

function M.print_highlighted(json_text, color_sym, color_quote, color_string, color_literal)
	local highlighted = highlight_json(json_text, color_sym, color_string, color_literal, color_quote)
	local count = #highlighted

	for i=1, count do
		local r, g, b, str = unpack(highlighted[i])
		print(str, i == count and "" or "\0")
	end

	return highlighted
end

function M.stringify(tbl, line_feed, indent, ac)
	local success, json_text = pcall(json.encode, tbl)
	if not success then
		error(json_text, 2)
		return
	end

	return pretty_json(json_text, line_feed, indent, ac)
end

function M.parse(str, pos, end_delim)
	pos = pos or 1

	if pos > #str then 
		error('Reached unexpected end of input.') 
	end

	local pos = pos + #str:match('^%s*', pos)
	local first = str:sub(pos, pos)

	if first == '{' then     
		local obj, key, delim_found = {}, true, true    
		pos = pos + 1    

		while true do       
			key, pos = M.parse(str, pos, '}')

			if key == nil then
			 	return obj, pos 
			end      

			if not delim_found then 
				error('Comma missing between object items.') 
			end     

			pos = skip_delim(str, pos, ':', true) 
			obj[key], pos = M.parse(str, pos)
			pos, delim_found = skip_delim(str, pos, ',')
		end
	elseif first == '[' then 
		local arr, val, delim_found = {}, true, true 
		pos = pos + 1

		while true do       
			val, pos = M.parse(str, pos, ']') 

			if val == nil then 
				return arr, pos 
			end
			
			if not delim_found then 
				error('Comma missing between array items.') 
			end
			
			arr[#arr + 1] = val

			pos, delim_found = skip_delim(str, pos, ',')

		end
	elseif first == '"' then     
		return parse_str_val(str, pos + 1)
	elseif first == '-' or first:match('%d') then     
		return parse_num_val(str, pos)
	elseif first == end_delim then     
		return nil, pos + 1
	else     
		local literals = {['true'] = true, ['false'] = false, ['null'] = json.null};    
		for lit_str, lit_val in pairs(literals) do       
			local lit_end = pos + #lit_str - 1

			if str:sub(pos, lit_end) == lit_str then 
				return lit_val, lit_end + 1 
			end   
		end   

		local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)    

		error('Invalid json syntax starting at ' .. pos_info_str)
	end
end

return M