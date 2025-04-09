

local uilib = require("gamesense/uilib")
local http = require("gamesense/http")
local ffi = require("ffi")
local bit = require("bit")
local color = require("gamesense/color")
local filesystem_interface = ffi.cast(ffi.typeof("void***"), client.create_interface("filesystem_stdio.dll", "VFileSystem017"))
local filesystem_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", filesystem_interface[0][20])
local filesystem_create_directories = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", filesystem_interface[0][22])
local filesystem_find = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)", filesystem_interface[0][32])

local function remove_file(file, path_id)
    filesystem_remove_file(filesystem_interface, file, path_id)
end

local function create_directories(file, path_id)
    filesystem_create_directories(filesystem_interface, file, path_id)
end

local exists = function(file)
    local int_ptr = ffi.new("int[1]")
    local res = filesystem_find(filesystem_interface, file, int_ptr)
    if res == ffi.NULL then
        return nil
    end

    return int_ptr, ffi.string(res)
end

if not exists("materials\\panorama\\images\\icons\\revealer") then
    create_directories("materials\\panorama\\images\\icons\\revealer", "revealer")
    create_directories("materials\\panorama\\images\\icons\\revealer\\multicolored", "multicolored")
    create_directories("materials\\panorama\\images\\icons\\revealer\\unicolored", "unicolored")
    create_directories("materials\\panorama\\images\\icons\\revealer\\nadoryha", "nadoryha")
end

local missing_icons = {}
local downloaded_icons = {}

local function download_icon(path, cheat)
    local file_path = ("csgo/materials/panorama/images/icons/revealer/%s/%s.png"):format(path, cheat)

    http.get(("https://ghproxy.com/https://raw.githubusercontent.com/dave3x8/revealer-icons/main/%s/%s.png"):format(path, cheat), function(status, response)
        if not status then
            return error("Revealer: Couldn't retrieve " .. path .. " " .. cheat:upper() .. " icon due to " .. response.status_message:lower())
        end

        writefile(file_path, response.body)

        downloaded_icons[#downloaded_icons + 1] = path .. " " .. cheat:upper()
    end)
end

for path, cheats in pairs({
    multicolored = {
        "nl1",
        "nl2",
        "gs",
        "ft",
        "nw",
        "ev",
        "ot",
        "pd",
        "pl",
        "r7",
        "af",
        "wh"
    },
    unicolored = {
        "nl1",
        "nl2",
        "gs",
        "ft",
        "nw",
        "ev",
        "ot",
        "pd",
        "pl",
        "r7",
        "af",
        "wh"
    },
    nadoryha = {
        "nl",
        "gs",
        "ft",
        "nw",
        "ev",
        "ot",
        "pd",
        "pl",
        "r7",
        "af",
        "wh"
    }
}) do
    for _, cheat in ipairs(cheats) do
        local old_file = readfile("csgo/materials/panorama/images/icons/achievements/" .. path .. "_" .. cheat .. ".png")
        if not old_file and not readfile("csgo/materials/panorama/images/icons/revealer/" .. path .. "/" .. cheat .. ".png") then
            missing_icons[#missing_icons + 1] = path .. " " .. cheat:upper()
            download_icon(path, cheat)
        elseif old_file then
            writefile("csgo/materials/panorama/images/icons/revealer/" .. path .. "/" .. cheat .. ".png", old_file)
            remove_file(("materials\\panorama\\images\\icons\\achievements\\%s_%s.png"):format(path, cheat), "")
        end
    end
end

if #missing_icons > 0 then
    print("Revealer: Missing icons: " .. table.concat(missing_icons, ", "))
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
// @ the guy trying to see what panorama i got (again?), chill bruh
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
		// clear entity data
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

local tab = "Visuals"
local container = "Player ESP"
local images_path = "file://{images}/icons/revealer/multicolored/%s.png"

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

local function find_duplicate_element(array, divisor)
    local visited_elements = {}

    for current_index = 1, #array do
        local current_element = array[current_index]

        if not visited_elements[current_element] then
            visited_elements[current_element] = true

            for next_index = current_index + 4, #array do
                if current_index % divisor == 0 then
                    if array[next_index] == current_element then
                        return true
                    end
                elseif array[next_index] == current_element then
                    return false
                end
            end
        end
    end

    return false
end


main_data_table = {
    main = uilib.new_checkbox(tab, container, "Cheat revealer"),
    display_method = uilib.new_multiselect(tab, container, "\nCheat revealer display options", {
        "Scoreboard icon",
        "Flag"
    }),
    icon_type = uilib.new_multiselect(tab, container, "\nCheat revealer icon set", {
        "Multicolored",
        "Unicolored",
        "Nado & Ryha",
        "Alternative NL icon"
    }),
    plist_handler = uilib.create_plist(),
    yeah = {
        names = {
            gs = {
                long = "gamesense",
                color = color.hex("95B80CFF")
            },
            nl = {
                long = "neverlose",
                color = color.hex("037696FF")
            },
            nw = {
                long = "nixware",
                color = color.hex("FFFFFFFF")
            },
            pd = {
                long = "pandora",
                color = color.hex("D4A9FFFF")
            },
            pr = {
                long = "primordial",
                color = color.hex("E2B6C7FF")
            },
            ot = {
                long = "onetap",
                color = color.hex("f7a414FF")
            },
            ft = {
                long = "fatality",
                color = color.hex("f00657FF")
            },
            pl = {
                long = "plaguecheat",
                color = color.hex("6BFF87FF")
            },
            ev = {
                long = "ev0lve",
                color = color.hex("42B7FFFF")
            },
            r7 = {
                long = "rifk7",
                color = color.hex("FF00FFFF")
            },
            af = {
                long = "airflow",
                color = color.hex("8E76C0FF")
            },
            wh = {
                long = "unknown",
                color = color.hex("9F9F9FFF")
            }
        },
        colored_names = {
            gs = {
                short = "\aEAEAEAFFG\a95B80CFFS",
                long = "\aEAEAEAFFgame\a95B80CFFsense"
            },
            nl = {
                short = "\a037696FFNL",
                long = "\aEAEAEAFFnever\a037696FFlose"
            },
            nw = {
                short = "\aFFFFFFFFNW",
                long = "\aFFFFFFFFnixware"
            },
            pd = {
                short = "\aD4A9FFFFPD",
                long = "\aD4A9FFFFpandora"
            },
            pr = {
                short = "\aE2B6C7FFPR",
                long = "\aE2B6C7FFprimordial"
            },
            ot = {
                short = "\aEAEAEAFFO\af7a414FFT",
                long = "\aEAEAEAFFone\af7a414FFtap"
            },
            ft = {
                short = "\af00657FFFT",
                long = "\aF00657FFfatality"
            },
            pl = {
                short = "\a6BFF87FFPLG",
                long = "\a6BFF87FFplaguecheat"
            },
            ev = {
                short = "\a42B7FFFFEV0",
                long = "\a42B7FFFFev0\aFFFFFFFFlve"
            },
            r7 = {
                short = "\a00F600FFR\aFF00FFFF7",
                long = "\a00F600FFrifk\aFF00FFFF7"
            },
            af = {
                short = "\a8E76C0FFAF",
                long = "\a8E76C0FFairflow"
            },
            wh = {
                short = false,
                long = "\a515364FFunknown"
            }
        },
    },
    users = {}
}

main_data_table.list_label = main_data_table.plist_handler:add(ui.new_label, "Cheat: " .. main_data_table.yeah.colored_names.wh.long)

local scoreboard_icon_enabled = false

main_data_table.display_method:add_callback(function(method)
    if method:contains("Scoreboard icon") then
        js.create()
    else
        js.destroy()
    end

    scoreboard_icon_enabled = method:contains("Scoreboard icon")
end)

local esp_flag_enabled = false

local last_scoreboard_icon_enabled = false
local last_esp_flag_enabled = false

local nl_path = nil

local is_multicolored = false
local is_unicolored = false
local is_nadoryha = false
local is_alternate_nl_icon = false

local icon_changed = false

main_data_table.icon_type:add_callback(function(icon_type)
    icon_changed = true
    if icon_type:contains("Unicolored") and (is_multicolored or is_nadoryha) then
        icon_type:remove("Multicolored")
        icon_type:remove("Nado & Ryha")
    elseif icon_type:contains("Multicolored") and (is_unicolored or is_nadoryha) then
        icon_type:remove("Unicolored")
        icon_type:remove("Nado & Ryha")
    elseif icon_type:contains("Nado & Ryha") and (is_multicolored or is_unicolored) then
        icon_type:remove("Unicolored")
        icon_type:remove("Multicolored")
        icon_type:remove("Alternative NL icon")
    elseif icon_type:contains("Alternative NL icon") and is_nadoryha then
        icon_type:remove("Alternative NL icon")
    else
        icon_type:add(is_multicolored and "Multicolored" or is_unicolored and "Unicolored" or is_nadoryha and "Nado & Ryha" or "Multicolored")
    end

    is_nadoryha = icon_type:contains("Nado & Ryha")
    is_unicolored = icon_type:contains("Unicolored")
    is_multicolored = icon_type:contains("Multicolored")
    nl_path = not is_nadoryha and (icon_type:contains("Alternative NL icon") and "nl2" or "nl2") or "nl2"
    images_path = "file://{images}/icons/revealer/" .. (is_multicolored and "multicolored" or is_unicolored and "unicolored" or is_nadoryha and "nadoryha") .. "/%s.png"

    for _, user in pairs(main_data_table.users) do
        user.icon_set = false
    end
end)
main_data_table.icon_type:add("Multicolored")

local detection_storage_table = {
    nl = {
        sig_count = {},
        found = {}
    },
    nw = {},
    pd = {},
    ot = {},
    ft = {},
    pl = {},
    ev = {},
    r7 = {},
    af = {},
    gs = {}
}
local detector_table = {
    nl = function(packet, target)
        if packet.xuid_high == 0 then
            return
        end

        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 22)[0])

        if sig == detection_storage_table.current_signature then
            detection_storage_table.nl.sig_count[target] = (detection_storage_table.nl.sig_count[target] or 0) + 1

            if detection_storage_table.nl.sig_count[target] > 24 then
                detection_storage_table.nl.found[target] = 1

                return true
            else
                detection_storage_table.nl.sig_count[target] = nil
            end
        end

        if #detection_storage_table.nl.found > 3 then
            return false
        end

        if not detection_storage_table.nl[target] then
            detection_storage_table.nl[target] = {}
        end

        detection_storage_table.nl[target][#detection_storage_table.nl[target] + 1] = packet.xuid_high

        if #detection_storage_table.nl[target] > 24 then
            if find_duplicate_element(detection_storage_table.nl[target], 4) and packet.xuid_high ~= 0 then
                detection_storage_table.current_signature = sig
                detection_storage_table.nl[target] = {}

                return true
            end

            table.remove(detection_storage_table.nl[target], 1)
        end

        return false
    end,
    nw = function(packet, target)
        if not detection_storage_table.nw[target] then
            detection_storage_table.nw[target] = 0
        end

        if detection_storage_table.nw[target] > 34 then
            detection_storage_table.nw[target] = nil

            return true
        elseif packet.xuid_high == 0 then
            detection_storage_table.nw[target] = detection_storage_table.nw[target] + 1
        else
            detection_storage_table.nw[target] = 0
        end

        return false
    end,
    pd = function(packet, target)
        if not detection_storage_table.pd[target] then
            detection_storage_table.pd[target] = 0
        end

        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        if detection_storage_table.pd[target] > 24 then
            return true
        elseif sig == "695B" or sig == "1B39" then
            detection_storage_table.pd[target] = detection_storage_table.pd[target] + 1
        else
            detection_storage_table.pd[target] = 0
        end

        return false
    end,
    ot = function(packet, target)
        if not detection_storage_table.ot[target] then
            detection_storage_table.ot[target] = {}
        end

        detection_storage_table.ot[target][#detection_storage_table.ot[target] + 1] = {
            sequence_bytes = packet.sequence_bytes,
            xuid_low = packet.xuid_low,
            section_number = packet.section_number,
            umcompressed_sample_offset = packet.uncompressed_sample_offset
        }

        if #detection_storage_table.ot[target] > 16 then
            local oldest_packet = detection_storage_table.ot[target][1]

            for i = 2, #detection_storage_table.ot[target] do
                local loop_packet = detection_storage_table.ot[target][i]
                if loop_packet.xuid_low ~= oldest_packet.xuid_low or loop_packet.section_number ~= oldest_packet.section_number or loop_packet.uncompressed_sample_offset ~= oldest_packet.uncompressed_sample_offset then
                    table.remove(detection_storage_table.ot[target], 1)

                    return false
                end
            end

            table.remove(detection_storage_table.ot[target], 1)

            return true
        end

        return false
    end,
    ft = function(packet, target)
        if not detection_storage_table.ft[target] then
            detection_storage_table.ft[target] = 0
        end

        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        if detection_storage_table.ft[target] > 36 then
            return true
        elseif sig == "7FFA" or sig == "7FFB" then
            detection_storage_table.ft[target] = detection_storage_table.ft[target] + 1
        end

        return false
    end,
    pl = function(packet, target)
        if not detection_storage_table.pl[target] then
            detection_storage_table.pl[target] = 0
        end

        if detection_storage_table.pl[target] > 24 then
            return true
        elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 44)[0]) == "7275" then
            detection_storage_table.pl[target] = detection_storage_table.pl[target] + 1
        else
            detection_storage_table.pl[target] = 0
        end

        return false
    end,
    ev = function(packet, target)
        if not detection_storage_table.ev[target] then
            detection_storage_table.ev[target] = {}
        end

        detection_storage_table.ev[target][#detection_storage_table.ev[target] + 1] = packet.xuid_high

        if #detection_storage_table.ev[target] > 44 then
            for i = 1, #detection_storage_table.ev[target] - 4 do
                local loop_info = detection_storage_table.ev[target][i]
                if detection_storage_table.ev[target][i + 1] + detection_storage_table.ev[target][i + 2] == detection_storage_table.ev[target][i] * 2 and detection_storage_table.ev[target][i + 4] == loop_info + 1 then
                    detection_storage_table.ev[target] = {}

                    return true
                end
            end

            table.remove(detection_storage_table.ev[target], 1)
        end

        return false
    end,
    r7 = function(packet, target)
        if not detection_storage_table.r7[target] then
            detection_storage_table.r7[target] = 0
        end

        local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])

        if detection_storage_table.r7[target] > 24 then
            return true
        elseif sig == "234" or sig == "134" then
            detection_storage_table.r7[target] = detection_storage_table.r7[target] + 1
        else
            detection_storage_table.r7[target] = 0
        end

        return false
    end,
    af = function(packet, target)
        if not detection_storage_table.af[target] then
            detection_storage_table.af[target] = 0
        end

        if detection_storage_table.af[target] > 24 then
            return true
        elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0]) == "AFF1" then
            detection_storage_table.af[target] = detection_storage_table.af[target] + 1
        else
            detection_storage_table.af[target] = 0
        end

        return false
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

client.register_esp_flag("", 220, 220, 220, function(target)
    if not main_data_table.main.value then
        return false
    end

    if not main_data_table.users[target] or not main_data_table.users[target].cheat then
        return false
    end

    local cheat = main_data_table.users[target].cheat or "wh"

    if not esp_flag_enabled or not cheat or cheat == "wh" then
        return false
    end

    return true, (entity.is_dormant(target) and cheat or main_data_table.yeah.colored_names[cheat].short or ""):upper()
end)

local function info_update_callback()
    main_data_table.icon_type.vis = main_data_table.main.value
    main_data_table.display_method.vis = main_data_table.main.value
    scoreboard_icon_enabled = main_data_table.display_method:contains("Scoreboard icon") and main_data_table.main.value
    esp_flag_enabled = main_data_table.display_method:contains("Flag") and main_data_table.main.value

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

main_data_table.main:add_event_callback("paint", function()
    if not scoreboard_icon_enabled then
        return
    end

    if (not is_multicolored) and (not is_unicolored) and (not is_nadoryha) then
        return
    end

    for _, target in pairs(get_players()) do
        local user = main_data_table.users[target]
        if user then
            if not user.icon_set then
                js.update(target, images_path:format(user.cheat and (user.cheat == "nl" and nl_path or user.cheat) or target == entity.get_local_player() and "gs" or "wh"))

                user.icon_set = true
            end
        else
            main_data_table.users[target] = {}
        end
    end
end)

main_data_table.main:add_event_callback("voice", function(event)
    local packet = ffi.cast(voice_data_t, event.data)
    local target = (ffi.cast("char*", packet) + 8)[0] + 1
    if not main_data_table.users[target] then
        main_data_table.users[target] = {}
    end

    local user = main_data_table.users[target]

    for cheat_identifier, cheat_detection_function in pairs(detector_table) do
        repeat
            local cheat = user.cheat
            if user.cheat ~= cheat_identifier and (cheat_identifier ~= "nl" or user.cheat ~= "ev" and user.cheat ~= "gs" and user.cheat ~= "pl" and user.cheat ~= "pd" and user.cheat ~= "r7" and user.cheat ~= "af" and user.cheat ~= "ft") and (cheat_identifier ~= "nw" or user.cheat ~= "nl") and (cheat_identifier ~= "ev" or user.cheat ~= "pd" and user.cheat ~= "nl" and user.cheat ~= "ft") and (cheat_identifier ~= "gs" or user.cheat ~= "ev" and user.cheat ~= "ot" and user.cheat ~= "pl" and user.cheat ~= "pd" and user.cheat ~= "r7" and user.cheat ~= "ft") and (cheat_identifier ~= "ot" or user.cheat ~= "nw" and user.cheat ~= "ft" and user.cheat ~= "pd" and user.cheat ~= "pl") then
                if cheat_identifier == "ft" and (user.cheat == "nw" or user.cheat == "pd") then
                    break
                end

                if cheat_detection_function(packet, target) then
                    user.cheat = cheat_identifier
                    user.icon_set = false

                    main_data_table.plist_handler:set_state(main_data_table.list_label, target, ("Cheat: %s"):format(main_data_table.yeah.colored_names[cheat_identifier].long) or main_data_table.yeah.colored_names.wh.long)

                    if (user.cheat or "wh") == "wh" or cheat ~= cheat_identifier then
                        client.fire_event("cheat_detected", {
                            player = target,
                            cheat_id = cheat_identifier,
                            cheat_long = main_data_table.yeah.names[cheat_identifier].long,
                            cheat_color = main_data_table.yeah.names[cheat_identifier].color
                        })
                    end
                end
            end
        until true
    end
end)
main_data_table.main:add_event_callback("player_connect_full", function(event)
    local target = client.userid_to_entindex(event.userid)
    if target == entity.get_local_player() then
        main_data_table.users = {}

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
main_data_table.main:add_event_callback("game_start", function()
    for _, user in pairs(main_data_table.users) do
        user.icon_set = false
    end
end)
main_data_table.main:add_callback(info_update_callback)
main_data_table.display_method:add_callback(info_update_callback)
main_data_table.icon_type:add_callback(info_update_callback)
main_data_table.main:invoke()
client.set_event_callback("shutdown", function()
    js.clear()
    js.destroy()
end)

package.preload["gamesense/cheat_revealer"] = function()
    return {
        get_cheat = function(target)
            local cheat = main_data_table.users[target].cheat or "wh"

            return {
                cheat_id = cheat,
                cheat_long = main_data_table.yeah.names[cheat].long or "unknown",
                cheat_color = main_data_table.yeah.names[cheat].color or color.hex("9F9F9FFF")
            }
        end,
        has_data = function(target)
            return main_data_table.users[target] ~= nil
        end,
        clear_data = function(target)
            if main_data_table.users[target] == nil then
                return false
            end

            main_data_table.users[target] = nil

            for _, detection in pairs(detection_storage_table) do
                detection[target] = nil
            end

            return true
        end
    }
end
