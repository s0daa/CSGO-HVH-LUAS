--------------------------------------------------------------------------------
-- Cache commonly used functions
--------------------------------------------------------------------------------
local setmetatable, error, client_set_event_callback, client_unset_event_callback, ui_get, ui_new_checkbox, pairs, ui_set, ui_set_callback, ui_set_visible = setmetatable, error, client.set_event_callback, client.unset_event_callback, ui.get, ui.new_checkbox, pairs, ui.set, ui.set_callback, ui.set_visible

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local OBJ_REFERENCE 	  = 0
local OBJ_CHANGE_CALLBACK = 1
local OBJ_EVENT_CALLBACKS = 2

local objects 		= {}
local ref_to_object = {}
local object_mt
local checkbox_mt

--------------------------------------------------------------------------------
-- Implementation
--------------------------------------------------------------------------------
local function proxy_to_object(proxy)
	return objects[proxy] or error("invalid object", 3)
end

local function reference_to_object(ref)
	return ref_to_object[ref] or error("invalid reference", 2)
end

local function make_proxy(ref)
	local obj = {}
	local proxy = setmetatable({}, object_mt)
	obj[OBJ_REFERENCE] = ref
	obj[OBJ_EVENT_CALLBACKS] = {}
	objects[proxy] = obj
	ref_to_object[ref] = obj
	return proxy
end

local function new_checkbox(...)
	local ref = ui_new_checkbox(...)
	if ref then
		local proxy = make_proxy(ref)
		return setmetatable(proxy, checkbox_mt)
	end
end

local function object_changed(ref)
	local value = ui_get(ref)
	local obj = reference_to_object(ref)
	local change_callback = obj[OBJ_CHANGE_CALLBACK]
	if change_callback then
		-- Invoke the change callback and pass the value of the object for ease of use
		change_callback(ref, value)
	end
	local event_callbacks = obj[OBJ_EVENT_CALLBACKS]
	if event_callbacks then
		local update_callback = value and client_set_event_callback or client_unset_event_callback
		for event_name, callback in pairs(event_callbacks) do
			update_callback(event_name, callback)
		end
	end
end

local function object_register_callback(proxy, event_name, callback)
	local obj = proxy_to_object(proxy)
	if event_name == "change" then
		obj[OBJ_CHANGE_CALLBACK] = callback
	else
		obj[OBJ_EVENT_CALLBACKS][event_name] = callback
	end
	object_changed(obj[OBJ_REFERENCE])
	ui_set_callback(obj[OBJ_REFERENCE], object_changed)
end

local function object_hide(proxy)
	local obj = proxy_to_object(proxy)
	ui_set_visible(obj[OBJ_REFERENCE], false)
end

local function object_show(proxy)
	local obj = proxy_to_object(proxy)
	ui_set_visible(obj[OBJ_REFERENCE], true)
end

local function object_get(proxy)
	local obj = proxy_to_object(proxy)
	return ui_get(obj[OBJ_REFERENCE])
end

local function object_set(proxy, value)
	local obj = proxy_to_object(proxy)
	ui_set(obj[OBJ_REFERENCE], value)
end

--------------------------------------------------------------------------------
-- Initilization code
--------------------------------------------------------------------------------
local function init()
	object_mt = {
		on 		= object_register_callback,
		hide 	= object_hide,
		show 	= object_show,
		get 	= object_get,
		set 	= object_set,
	}
	checkbox_mt = {
		__index = object_mt
	}
end

init()

--------------------------------------------------------------------------------
-- Return exposed functions
--------------------------------------------------------------------------------
return {
	new_checkbox = new_checkbox
}