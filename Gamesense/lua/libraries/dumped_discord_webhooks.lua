slot0 = require("gamesense/http")
slot1 = {
	Properties = {},
	setTitle = function (slot0, slot1)
		slot0.Properties.title = slot1
	end,
	setDescription = function (slot0, slot1)
		slot0.Properties.description = slot1
	end,
	setURL = function (slot0, slot1)
		slot0.Properties.url = slot1
	end,
	setTimestamp = function (slot0, slot1)
		slot0.Properties.timestamp = slot1
	end,
	setColor = function (slot0, slot1)
		slot0.Properties.color = slot1
	end,
	setFooter = function (slot0, slot1, slot2, slot3)
		slot0.Properties.footer = {
			text = slot1,
			icon_url = slot2 or "",
			proxy_icon_url = slot3 or ""
		}
	end,
	setImage = function (slot0, slot1, slot2, slot3, slot4)
		slot0.Properties.image = {
			url = slot1 or "",
			proxy_url = slot2 or "",
			height = slot3 or nil,
			width = slot4 or nil
		}
	end,
	setThumbnail = function (slot0, slot1, slot2, slot3, slot4)
		slot0.Properties.thumbnail = {
			url = slot1 or "",
			proxy_url = slot2 or "",
			height = slot3 or nil,
			width = slot4 or nil
		}
	end,
	setVideo = function (slot0, slot1, slot2, slot3)
		slot0.Properties.video = {
			url = slot1 or "",
			height = slot2 or nil,
			width = slot3 or nil
		}
	end,
	setAuthor = function (slot0, slot1, slot2, slot3, slot4)
		slot0.Properties.author = {
			name = slot1 or "",
			url = slot2 or "",
			icon_url = slot3 or "",
			proxy_icon_url = slot4 or ""
		}
	end,
	addField = function (slot0, slot1, slot2, slot3)
		if not slot0.Properties.fields then
			slot0.Properties.fields = {}
		end

		table.insert(slot0.Properties.fields, {
			name = slot1,
			value = slot2,
			inline = slot3 or false
		})
	end
}
slot2 = {
	URL = "",
	send = function (slot0, ...)
		slot1 = {
			username = slot0.username
		}
		slot2 = table.pack(...)

		if slot0.username then
			-- Nothing
		end

		if slot0.avatar_url then
			slot1.avatar_url = slot0.avatar_url
		end

		for slot6, slot7 in next, slot2, nil do
			if type(slot7) == "table" then
				if not slot1.embeds then
					slot1.embeds = {}
				end

				table.insert(slot1.embeds, slot7.Properties)
			elseif type(slot7) == "string" then
				slot1.content = slot7
			end
		end

		uv0.post(slot0.URL, {
			body = json.stringify(slot1),
			headers = {
				["Content-Type"] = "application/json",
				["Content-Length"] = #json.stringify(slot1)
			}
		}, function ()
		end)
	end,
	setUsername = function (slot0, slot1)
		slot0.username = slot1
	end,
	setAvatarURL = function (slot0, slot1)
		slot0.avatar_url = slot1
	end
}

return {
	newEmbed = function ()
		return setmetatable({
			Properties = {}
		}, {
			__index = uv0
		})
	end,
	new = function (slot0)
		return setmetatable({
			URL = slot0
		}, {
			__index = uv0
		})
	end
}
