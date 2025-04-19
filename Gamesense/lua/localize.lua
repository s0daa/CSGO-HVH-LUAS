local js = panorama.loadstring([[
	return {
		localize: (str, params) => {
			if(params == null)
				return $.Localize(str)

			var panel = $.CreatePanel("Panel", $.GetContextPanel(), "")

			for(key in params) {
				panel.SetDialogVariable(key, params[key])
			}

			var result = $.Localize(str, panel)

			panel.DeleteAsync(0.0)

			return result
		},
		language: () => {
			return $.Language()
		}
	}
]])()

local localize_cache = {}
local function localize(str, params)
	if str == nil then return "" end

	if localize_cache[str] == nil then
		localize_cache[str] = {}
	end

	local params_key = params ~= nil and json.stringify(params) or true
	if localize_cache[str][params_key] == nil then
		localize_cache[str][params_key] = js.localize(str, params)
	end

	return localize_cache[str][params_key]
end

return setmetatable({
	localize = localize,
	language = js.language
}, {
	__call = function(tbl, ...)
		return localize(...)
	end
})