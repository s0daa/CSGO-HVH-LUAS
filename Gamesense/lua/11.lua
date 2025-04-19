
local ffi = require("ffi")
local bit = require("bit")

local memory do
    memory = { }

    function memory.pattern_scan(module, signature, add)
        local buff = ffi.new("char[1024]")

        local c = 0

        for char in string.gmatch(signature, "..%s?") do
            if char == "? " or char == "?? " then
                buff[c] = 0xcc
            else
                buff[c] = tonumber("0x" .. char)
            end

            c = c + 1
        end

        local result = ffi.cast("uintptr_t", client.find_signature(module, ffi.string(buff)))

        if add and tonumber(result) ~= 0 then
            result = ffi.cast("uintptr_t", tonumber(result) + add)
        end

        return result
    end
end

local clientside do
    clientside = { }

    local panorama = panorama.open()

    local native_BaseLocalClient_base = ffi.cast("uintptr_t**", memory.pattern_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1))

    local player_info_t = ffi.typeof([[
        struct {
            int64_t         unknown;
            int64_t         steamID64;
            char            szName[128];
            int             userId;
            char            szSteamID[20];
            char            pad_0x00A8[0x10];
            unsigned long   iSteamID;
            char            szFriendsName[128];
            bool            fakeplayer;
            bool            ishltv;
            unsigned int    customfiles[4];
            unsigned char   filesdownloaded;
        }
    ]])
    
    local native_GetStringUserData = vtable_thunk(11, ffi.typeof('$*(__thiscall*)(void*, int, int*)', player_info_t))
    
    local previous_names = {}
    local modified_names = {}
    
    clientside.nickname = function(player_index, prefix, suffix)
        local native_BaseLocalClient = native_BaseLocalClient_base[0][0]
        if not native_BaseLocalClient then return end
    
        local native_UserInfoTable = ffi.cast('void***', native_BaseLocalClient + 0x52C0)[0]
        if not native_UserInfoTable then return end
    
        local data = native_GetStringUserData(native_UserInfoTable, player_index - 1, nil)
        if not data then return end
    
        local current_name = ffi.string(data[0].szName)
    
        local original_name = previous_names[player_index] or current_name -- uwukson: if name was changed then use original name
    
        if not previous_names[player_index] then
            previous_names[player_index] = original_name
        end
    
        if prefix .. original_name .. suffix ~= modified_names[player_index] then -- uwukson: check for change name
            local new_name = prefix .. original_name .. suffix
            new_name = new_name:sub(1, 32)
    
            ffi.copy(data[0].szName, new_name, #new_name + 1)
            modified_names[player_index] = new_name
        end
    end
end

local voice_data_t = ffi.typeof([[
	struct {
		char		 pad_0000[8];
		int32_t	client;
		int32_t	audible_mask;
		uint32_t xuid_low;
		uint32_t xuid_high;
		void*		voice_data;
		bool		 proximity;
		bool		 caster;
		char		 pad_001E[2];
		int32_t	format;
		int32_t	sequence_bytes;
		uint32_t section_number;
		uint32_t uncompressed_sample_offset;
		char		 pad_0030[4];
		uint32_t has_bits;
	} *
]])

local js = panorama.loadstring([[
let entity_panels = {}
let entity_data = {}
let event_callbacks = {}
	let SLOT_LAYOUT = `
		<root>
			<Panel style="min-width: 3px; padding-top: 2px; padding-left: 0px;" scaling='stretch-to-fit-y-preserve-aspect'>
				<Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"	/>
				<Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
				<Image id="image" textureheight="21" style="opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
			</Panel>
		</root>
	`
	let _DestroyEntityPanel = function (key) {
		let panel = entity_panels[key]
		if(panel != null && panel.IsValid()) {
			var parent = panel.GetParent()
			let musor = parent.GetChild(0)
			musor.visible = true
			if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
				parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
			}
			panel.DeleteAsync(0.0)
		}
		delete entity_panels[key]
	}
	let _DestroyEntityPanels = function() {
		for(key in entity_panels){
			_DestroyEntityPanel(key)
		}
	}
	let _GetOrCreateCustomPanel = function(xuid) {
		if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
			entity_panels[xuid] = null
			let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")
			if(scoreboard_context_panel == null){
				_Clear()
				_DestroyEntityPanels()
				return
			}
			scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
				let scoreboard_el
				if(el.m_xuid == xuid) {
					el.Children().forEach(function(child_frame){
						let stat = child_frame.GetAttributeString("data-stat", "")
						if(stat == "rank")
							scoreboard_el = child_frame.GetChild(0)
					})
					if(scoreboard_el) {
						let scoreboard_el_parent = scoreboard_el.GetParent()
						let custom_icons = $.CreatePanel("Panel", scoreboard_el_parent, "revealer-icon", {
						})
						if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
							scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
						}
						scoreboard_el_parent.MoveChildAfter(custom_icons, scoreboard_el_parent.GetChild(1))
						let prev_panel = scoreboard_el_parent.GetChild(0)
						prev_panel.visible = false
						let panel_slot_parent = $.CreatePanel("Panel", custom_icons, `icon`)
						panel_slot_parent.visible = false
						panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)
						entity_panels[xuid] = custom_icons
						return custom_icons
					}
				}
			})
		}
		return entity_panels[xuid]
	}
	let _UpdatePlayer = function(entindex, path_to_image) {
		if(entindex == null || entindex == 0)
			return
		entity_data[entindex] = {
			applied: false,
			image_path: path_to_image
		}
	}
	let _ApplyPlayer = function(entindex) {
		let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
		let panel = _GetOrCreateCustomPanel(xuid)
		if(panel == null)
			return
		let panel_slot_parent = panel.FindChild(`icon`)
		panel_slot_parent.visible = true
		let panel_slot = panel_slot_parent.FindChild("image")
		panel_slot.visible = true
		panel_slot.style.opacity = "1"
		panel_slot.SetImage(entity_data[entindex].image_path)
		return true
	}
	let _ApplyData = function() {
		for(entindex in entity_data) {
			entindex = parseInt(entindex)
			let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
			if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
				if(_ApplyPlayer(entindex)) {
					entity_data[entindex].applied = true
				}
			}
		}
	}
	let _Create = function() {
		event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
		event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
			_ApplyData()
		})
		event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
	}
	let _Clear = function() { entity_data = {} }
	let _Destroy = function() {
		_Clear()
		_DestroyEntityPanels()
		for(event in event_callbacks){
			$.UnregisterForUnhandledEvent(event, event_callbacks[event])
			delete event_callbacks[event]
		}
	}
	return {
		create: _Create,
		destroy: _Destroy,
		clear: _Clear,
		update: _UpdatePlayer,
		destroy_panel: _DestroyEntityPanels
	}
]], "CSGOHud")()

js.create()

local main_data_table

local function get_players()
    local players = {}
    local player_resource = entity.get_player_resource()

    for i = 1, globals.maxplayers() do
        repeat
            if entity.get_prop(player_resource, "m_bConnected", i) == 0 then
                if main_data_table.users[i] then
                    main_data_table.users[i] = nil
                end

                break
            else
                local flags = entity.get_prop(i, "m_fFlags")
                if not flags then
                    break
                end

                if bit.band(flags, 512) == 512 then
                    break
                end
            end

            players[#players + 1] = i
        until true
    end

    return players
end

main_data_table = {
    users = {}
}

local scoreboard_icon_enabled = false

js.create()

local last_scoreboard_icon_enabled = false

local icon_changed = false

local detection_storage_table = {
    nl = {
        sig = {},
        sig_count = {}
    },
    gs = {}
}

local CHEAT = {
    ARCTIC = "at",
    NEVERLOSE = "nl",
    NIXWARE = "nw",
    PANDORA = "pd",
    FATALITY = "ft", 
    PLAGUE = "pl",
    EVOLVE = "ev",
    AIRFLOW = "af",
    GAMESENSE = "gs"
}

local ICONS = {
    [CHEAT.ARCTIC] = 'https://raw.githubusercontent.com/shialexx/Arctic-tech-icon/main/logo.png',
    [CHEAT.NEVERLOSE] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/neverlose.png',
    [CHEAT.NIXWARE] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/nixware.png',
    [CHEAT.PANDORA] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/pandora.png',
    [CHEAT.FATALITY] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/fatality.png',
    [CHEAT.PLAGUE] = 'https://raw.githubusercontent.com/dave3x8/revealer-icons/main/nadoryha/pl.png',
    [CHEAT.EVOLVE] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/ev0.png',
    [CHEAT.AIRFLOW] = 'https://raw.githubusercontent.com/dave3x8/revealer-icons/main/multicolored/af.png',
    [CHEAT.GAMESENSE] = 'https://raw.githubusercontent.com/tickcount/.p2c-icons/main/gamesense.png'
}

local detector_table = {
    at = function(packet, target)
        return packet.xuid_low == 1099264
    end,
    nl = function(packet, target)
        if packet.xuid_high == 0 or packet.xuid_low == 1099264 then
            return
        end

        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 22)[0])

        if sig == 0 then
            return
        end

        if sig == detection_storage_table.nl.sig[target] then
            detection_storage_table.nl.sig_count[target] = detection_storage_table.nl.sig_count[target] + 1
        else
            detection_storage_table.nl.sig_count[target] = 0
        end

        detection_storage_table.nl.sig[target] = sig

        if detection_storage_table.nl.sig_count[target] > 24 then
            return true
        end

        return false
    end,
    nw = function(packet, target)
        return packet.xuid_high == 0 and packet.xuid_low ~= 0
    end,
    pd = function(packet, target)
        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        return sig == "695B" or sig == "1B39"
    end,
    ft = function(packet, target)
        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        return sig == "7FFA" or sig == "7FFB"
    end,
    pl = function(packet, target)
        return ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 44)[0]) == "7275"
    end,
    ev = function(packet, target)
        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        return sig == "7FFC" or sig == "7FFD"
    end,
    af = function(packet, target)
        return ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0]) == "AFF1"
    end,
    gs = function(packet, target)
        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 22)[0])
        local sequence_bytes = string.sub(packet.sequence_bytes, 1, 4)

        if not detection_storage_table.gs[target] then
            detection_storage_table.gs[target] = {
                repeated = 0,
                packet = sig,
                bytes = sequence_bytes
            }
        end

        if sequence_bytes ~= detection_storage_table.gs[target].bytes and sig ~= detection_storage_table.gs[target].packet then
            detection_storage_table.gs[target].packet = sig
            detection_storage_table.gs[target].bytes = sequence_bytes
            detection_storage_table.gs[target].repeated = detection_storage_table.gs[target].repeated + 1
        else
            detection_storage_table.gs[target].repeated = 0
        end

        if detection_storage_table.gs[target].repeated >= 36 then
            detection_storage_table.gs[target] = {
                repeated = 0,
                packet = sig,
                bytes = sequence_bytes
            }

            return true
        end

        return false
    end
}

local function info_update_callback()
    scoreboard_icon_enabled = true

    if icon_changed then
        icon_changed = false
        for _, user in pairs(main_data_table.users) do
            user.icon_set = false
        end
    end

    if scoreboard_icon_enabled and not last_scoreboard_icon_enabled then
        last_scoreboard_icon_enabled = true

        js.create()
    elseif not scoreboard_icon_enabled and last_scoreboard_icon_enabled then
        last_scoreboard_icon_enabled = false

        for _, user in pairs(main_data_table.users) do
            user.icon_set = false
        end

        js.destroy()
    end
end

client.set_event_callback("paint", function()
    if not scoreboard_icon_enabled then
        return
    end

    for _, target in pairs(get_players()) do
        local user = main_data_table.users[target]
        if user then
            if not user.icon_set then
                local icon_url = ICONS[user.cheat] or target == entity.get_local_player() and ICONS[CHEAT.GAMESENSE] or nil
                js.update(target, icon_url)
                
                if user.cheat then
                    clientside.nickname(target, user.cheat .. ' ~ ', '')
                end
                
                user.icon_set = true
            end
        else
            main_data_table.users[target] = {}
        end
    end
end)

local CHEAT_DETECTION_RULES = {
    ["at"] = {"nl", "nw"},
    ["nl"] = {"ev", "gs", "pl", "pd", "af", "ft"},
    ["nw"] = {"nl"},
    ["ev"] = {"pd", "nl", "ft"},
    ["gs"] = {"ev", "ot", "pl", "pd", "ft"},
    ["ot"] = {"nw", "ft", "pd", "pl"},
    ["ft"] = {"nw", "pd"}
}

local function should_check_cheat(current_cheat, cheat_identifier)
    if current_cheat == cheat_identifier then
        return false
    end

    local blocked_cheats = CHEAT_DETECTION_RULES[cheat_identifier]
    if blocked_cheats then
        for _, blocked in ipairs(blocked_cheats) do
            if current_cheat == blocked then
                return false
            end
        end
    end

    return true
end

client.set_event_callback("voice", function(event)
    local packet = ffi.cast(voice_data_t, event.data)
    local target = (ffi.cast("char*", packet) + 8)[0] + 1
    
    main_data_table.users[target] = main_data_table.users[target] or {}
    local user = main_data_table.users[target]

    for cheat_identifier, detection_function in pairs(detector_table) do
        if should_check_cheat(user.cheat, cheat_identifier) then
            if detection_function(packet, target) then
                local previous_cheat = user.cheat
                user.cheat = cheat_identifier
                user.icon_set = false

                if not previous_cheat or previous_cheat == "wh" or previous_cheat ~= cheat_identifier then
                    client.fire_event("cheat_detected", {
                        player = target,
                        cheat_id = cheat_identifier,
                    })

                    local player_index = client.userid_to_entindex(target)
                    if player_index then
                        clientside.nickname(player_index, cheat_identifier .. ' ~ ', '')
                    end
                end
            end
        end
    end
end)

local function reset_nicknames()
    for _, target in pairs(get_players()) do
        clientside.nickname(target, '', '')
    end
end

client.set_event_callback("player_connect_full", function(event)
    local target = client.userid_to_entindex(event.userid)
    if target == entity.get_local_player() then
        main_data_table.users = {}

        reset_nicknames()
        js.clear()
        js.destroy()
        client.delay_call(0.5, function()
            js.create()
        end)
    else
        for _, user in pairs(main_data_table.users) do
            user[target] = {}
        end
    end
end)

client.set_event_callback("game_start", function()
    for _, user in pairs(main_data_table.users) do
        user.icon_set = false
    end
end)

client.set_event_callback("paint", function()
    info_update_callback()
end)

client.set_event_callback("shutdown", function()
    reset_nicknames()
    js.clear()
    js.destroy()
end)