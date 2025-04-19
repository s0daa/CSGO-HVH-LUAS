slot0 = _G.ui
slot1 = {
	__index = slot1,
	add_callback = function (slot0, slot1)
		if type(slot1) == "function" then
			slot0.callbacks[#slot0.callbacks + 1] = slot1

			slot0:process_callbacks()
		end

		return slot0
	end
}

function slot1.add_children(slot0, slot1, slot2)
	if getmetatable(slot1) == uv0 then
		slot1 = {
			slot1
		}
	end

	for slot6, slot7 in pairs(slot1) do
		slot0.children[#slot0.children + 1] = {
			obj = slot7,
			value = slot2 or true
		}
	end

	table.sort(slot0.children, function (slot0, slot1)
		return slot1.obj:ref() < slot0.obj:ref()
	end)
	slot0:process_callbacks()
end

function slot1.process_callbacks(slot0, slot1)
	function slot2()
		for slot4 = 1, #uv0.children do
			slot5.obj:set_visible(type(uv0.children[slot4].value) == "function" and slot5.value(uv0) or uv0:get() == slot5.value)

			if uv1 ~= nil then
				slot5.obj:set_visible(uv1 and slot6)
			end

			if uv1 ~= nil then
				slot5.obj:process_callbacks(uv1 and slot6)
			else
				slot5.obj:process_callbacks(slot6)
			end
		end

		for slot4 = 1, #uv0.callbacks do
			uv0.callbacks[slot4]()
		end

		for slot4 = 1, #uv0.events do
			if slot5.registered ~= (type(uv0.events[slot4].value) == "function" and slot5.value(uv0) or slot0 == slot5.value) then
				client[(slot6 and "" or "un") .. "set_event_callback"](slot5.name, slot5.func)

				slot5.registered = slot6
			end
		end
	end

	slot3, slot4 = pcall(function ()
		uv0.get(uv1:ref())
	end)

	if not slot4 then
		slot0:set_callback(slot2)
		slot2()
	end
end

function slot1.get(slot0, slot1)
	if slot0 == nil then
		return
	end

	if slot1 then
		return uv0.get(slot0.objs[slot1] or slot0)
	end

	slot2 = {}

	for slot6 = 1, #slot0.objs do
		pcall(function ()
			uv0 = {
				uv1.get(uv2.objs[uv3] or uv2)
			}
		end)

		for slot11 = 1, #{} do
			slot2[#slot2 + 1] = slot7[slot11]
		end
	end

	return unpack(slot2)
end

function slot1.register(slot0, slot1, slot2, slot3)
	slot4 = #slot0.events + 1
	slot0.events[slot4] = {
		registered = false,
		name = slot1,
		func = slot2,
		value = slot3 or true
	}

	return slot4
end

function slot1.unregister(slot0, slot1)
	table.remove(slot0.events, slot1)

	return slot0
end

function slot1.compare(slot0, slot1, slot2)
	slot3 = slot0:get()

	return (slot2 and slot3:lower() or slot3) == slot1
end

function slot1.lower(slot0)
	return slot0:get():lower()
end

function slot1.set(slot0, ...)
	if not slot0 then
		return
	end

	if type(slot0) ~= "number" and slot0.objs[1] or slot0 then
		uv0.set(slot1, ...)
	end

	return slot0
end

function slot1.set_index(slot0, slot1, ...)
	if not slot0 then
		return
	end

	if type(slot0) ~= "number" and slot0.objs[slot1] or slot0 then
		uv0.set(slot2, ...)
	end

	return slot0
end

function slot1.update(slot0, ...)
	slot1 = {}

	for slot5 = 1, #slot0.objs do
		if ({
			...
		})[slot5] ~= nil then
			slot1[#slot1 + 1] = uv0.update(slot0.objs[slot5] or slot0, slot6[slot5])
		end
	end

	return slot0
end

function slot1.ref(slot0, slot1)
	return slot1 and slot0.objs[slot1] or unpack(slot0.objs)
end

function slot1.set_callback(slot0, ...)
	slot1 = {}

	for slot5 = 1, #slot0.objs do
		if ({
			...
		})[slot5] ~= nil then
			slot1[#slot1 + 1] = uv0.set_callback(slot0.objs[slot5] or slot0, slot6[slot5])
		end
	end

	return slot0
end

function slot1.set_visible(slot0, ...)
	slot1 = {}

	for slot5 = 1, #slot0.objs do
		if ({
			...
		})[slot5] ~= nil then
			slot1[#slot1 + 1] = uv0.set_visible(slot0.objs[slot5] or slot0, slot6[slot5])
		end
	end

	return slot0
end

function slot1.name(slot0, slot1)
	if slot1 then
		return uv0.name(slot0.objs[slot1] or slot0)
	end

	slot2 = {}

	if type(slot0) == "number" then
		return uv0.name(slot0)
	end

	for slot6 = 1, #slot0.objs do
		slot2[#slot2 + 1] = uv0.name(slot0.objs[slot6] or slot0)
	end

	return unpack(slot2)
end

function slot1.new(...)
	return setmetatable({
		objs = {
			...
		},
		children = {},
		callbacks = {},
		events = {}
	}, uv0)
end

for slot6 = 1, #{
	"new_button",
	"new_checkbox",
	"new_color_picker",
	"new_combobox",
	"new_hotkey",
	"new_label",
	"new_listbox",
	"new_multiselect",
	"new_slider",
	"new_string",
	"new_textbox",
	"reference"
} do
	slot1[slot2[slot6]] = function (...)
		if getmetatable(({
			...
		})[1]) == uv0 then
			table.remove(slot0, 1)
		else
			slot1 = nil
		end

		slot2 = {}

		if uv1 == uv2[3] and slot0[8] then
			slot2[#slot2 + 1] = uv0.new(uv3.new_label(unpack(slot0)))
		end

		slot2[#slot2 + 1] = uv0.new(uv3[uv1](unpack(slot0)))

		if slot1 then
			slot1:add_children(slot2)
		end

		return slot2[slot3]
	end
end

for slot7 = 1, #{
	"is_menu_open",
	"menu_position",
	"menu_size",
	"mouse_position"
} do
	slot1[slot3[slot7]] = function (...)
		return uv0[uv1](...)
	end
end

setmetatable(slot1, {
	__call = function (slot0, ...)
		return uv0.new(...)
	end
})

return slot1
