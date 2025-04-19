local M = {}

local table_insert, table_concat, string_rep, string_len, string_sub = table.insert, table.concat, string.rep, string.len, string.sub
local math_max, math_floor, math_ceil = math.max, math.floor, math.ceil

local function len(str)
	local _, count = string.gsub(tostring(str), "[^\128-\193]", "")
	return count
end

local styles = {
	--					 1    2     3    4    5     6    7    8     9    10   11
	["ASCII"] = {"-", "|", "+"},
	["Compact"] = {"-", " ", " ", " ", " ", " ", " ", " "},
	["ASCII (Girder)"] = {"=", "||",  "//", "[]", "\\\\",  "|]", "[]", "[|",  "\\\\", "[]", "//"},
	["Unicode"] = {"═", "║",  "╔", "╦", "╗",  "╠", "╬", "╣",  "╚", "╩", "╝"},
	["Unicode (Single Line)"] = {"─", "│",  "┌", "┬", "┐",  "├", "┼", "┤",  "└", "┴", "┘"},
	["Markdown (Github)"] = {"-", "|", "|"}
}

--initialize missing style values (ascii etc)
for _, style in pairs(styles) do
	if #style == 3 then
		for j=4, 11 do
			style[j] = style[3]
		end
	end
end

local function justify_center(text, width)
	text = string_sub(text, 1, width)
	local length = len(text)
	return string_rep(" ", math_floor(width/2-length/2)) .. text .. string_rep(" ", math_ceil(width/2-length/2))
end

local function justify_left(text, width)
	text = string_sub(text, 1, width)
	return text .. string_rep(" ", width-len(text))
end

function M.generate_table(rows, headings, options)
	if type(options) == "string" or options == nil then
		options = {
			style=options or "ASCII",
		}
	end

	if options.top_line == nil then
		options.top_line = options.style ~= "Markdown (Github)"
	end

	if options.bottom_line == nil then
		options.bottom_line = options.style ~= "Markdown (Github)"
	end

	if options.header_seperator_line == nil then
		options.header_seperator_line = true
	end

	local seperators = styles[options.style] or styles["ASCII"]

	local rows_out, columns_width, columns_count = {}, {}, 0
	local has_headings = headings ~= nil and #headings > 0

	if has_headings then
		for i=1, #headings do
			columns_width[i] = len(headings[i])+2
		end
		columns_count = #headings
	else
		for i=1, #rows do
			columns_count = math_max(columns_count, #rows[i])
		end
	end

	for i=1, #rows do
		local row = rows[i]
		for c=1, columns_count do
			columns_width[c] = math_max(columns_width[c] or 2, len(row[c])+2)
		end
	end

	local column_seperator_rows = {}
	for i=1, columns_count do
		table_insert(column_seperator_rows, string_rep(seperators[1], columns_width[i]))
	end
	if options.top_line then
		table_insert(rows_out, seperators[3] .. table_concat(column_seperator_rows, seperators[4]) .. seperators[5])
	end

	if has_headings then
		local headings_justified = {}
		for i=1, columns_count do
			headings_justified[i] = justify_center(headings[i], columns_width[i])
		end
		table_insert(rows_out, seperators[2] .. table_concat(headings_justified, seperators[2]) .. seperators[2])
		if options.header_seperator_line then
			table_insert(rows_out, seperators[6] .. table_concat(column_seperator_rows, seperators[7]) .. seperators[8])
		end
	end

	for i=1, #rows do
		local row, row_out = rows[i], {}
		if #row == 0 then
			table_insert(rows_out, seperators[6] .. table_concat(column_seperator_rows, seperators[7]) .. seperators[8])
		else
			for j=1, columns_count do
				local justified = options.value_justify == "center" and justify_center(row[j] or "", columns_width[j]-2) or justify_left(row[j] or "", columns_width[j]-2)
				row_out[j] = " " .. justified .. " "
			end
			table_insert(rows_out, seperators[2] .. table_concat(row_out, seperators[2]) .. seperators[2])
		end
	end

	if options.bottom_line and seperators[9] then
		table_insert(rows_out, seperators[9] .. table_concat(column_seperator_rows, seperators[10]) .. seperators[11])
	end

	return table_concat(rows_out, "\n")
end

return setmetatable(M, {
	__call = function(_, ...)
		return M.generate_table(...)
	end
})