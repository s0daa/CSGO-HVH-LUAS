-- adapted from LosAngeles to primordial.dev # evitable#5356

local http_library = require('Lightweight HTTP Library')

local http = http_library.new({0.3, false, 10})
local json = require('json')

--// RichEmbed object
local RichEmbed = { Properties = {} }

function RichEmbed:setTitle(title) self.Properties.title = title end
function RichEmbed:setDescription(description) self.Properties.description = description end
function RichEmbed:setURL(url) self.Properties.url = url end
function RichEmbed:setTimestamp(timestamp) self.Properties.timestamp = timestamp end
function RichEmbed:setColor(color) self.Properties.color = color end
function RichEmbed:setFooter(text, icon, proxy_icon) self.Properties.footer = { text = text, icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:setImage(icon, proxy_icon, height, width) self.Properties.image = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setThumbnail(icon, proxy_icon, height, width) self.Properties.thumbnail = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setVideo(url, height, width) self.Properties.video = { url = url or '', height = height or nil, width = width or nil } end
function RichEmbed:setAuthor(name, url, icon, proxy_icon) self.Properties.author = { name = name or '', url = url or '', icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:addField(name, value, inline) if not self.Properties.fields then self.Properties.fields = {} end table.insert(self.Properties.fields, { name = name, value = value, inline = inline or false }) end

--// WebhookClient object
local WebhookClient = { URL = '' }

function WebhookClient:send(...)
	local unifiedBody = {}
	local arguments = {...}

	-- Other variables
	if self.username then unifiedBody.username = self.username end
	if self.avatar_url then unifiedBody.avatar_url = self.avatar_url end

	for _, value in next, arguments do
		if type(value) == 'table' then
			-- The object has to be a RichEmbed
			if not unifiedBody.embeds then
				unifiedBody.embeds = {}
			end

			table.insert(unifiedBody.embeds, value.Properties)
		elseif type(value) == 'string' then
			unifiedBody.content = value
		end
	end
	http:request('post', self.URL, {headers = { ['Content-Length'] = #json.encode(unifiedBody), ['Content-Type'] = 'application/json' }, body = json.encode(unifiedBody) }, function() end)
end

function WebhookClient:setUsername(username) self.username = username end
function WebhookClient:setAvatarURL(avatar_url) self.avatar_url = avatar_url end

return {
	newEmbed = function()
		return setmetatable({ Properties = {} }, {__index = RichEmbed})
	end,
	new = function(url)
		return setmetatable({ URL = url }, {__index = WebhookClient})
	end
}