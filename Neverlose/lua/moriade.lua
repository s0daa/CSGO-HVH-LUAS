-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- moriade beta
-- cvar x fincast x dashfwe
local render_world_to_screen, rage_exploit, ui_get_binds, ui_get_alpha, entity_get_players, entity_get, entity_get_entities, entity_get_game_rules, common_set_clan_tag, common_is_button_down, common_get_username, common_get_date, ffi_cast, ffi_typeof, render_gradient, render_text, render_texture, render_rect_outline, render_rect, entity_get_local_player, ui_create, ui_get_style, math_floor, math_abs, math_max, math_ceil, math_min, math_random, utils_trace_bullet, render_screen_size, render_load_font, render_load_image_from_file, render_measure_text, render_poly, render_poly_blur, common_add_notify, common_add_event, utils_console_exec, utils_execute_after, utils_create_interface, utils_trace_line, ui_find, entity_get_threat, string_format, hooked_function, entity_get_player_resource, common_get_unixtime, table_insert = render.world_to_screen, rage.exploit, ui.get_binds, ui.get_alpha, entity.get_players, entity.get, entity.get_entities, entity.get_game_rules, common.set_clan_tag, common.is_button_down, common.get_username, common.get_date, ffi.cast, ffi.typeof, render.gradient, render.text, render.texture, render.rect_outline, render.rect, entity.get_local_player, ui.create, ui.get_style, math.floor, math.abs, math.max, math.ceil, math.min, math.random, utils.trace_bullet, render.screen_size, render.load_font, render.load_image_from_file, render.measure_text, render.poly, render.poly_blur, common.add_notify, common.add_event, utils.console_exec, utils.execute_after, utils.create_interface, utils.trace_line, ui.find, entity.get_threat, string.format, nil, entity.get_player_resource, common.get_unixtime, table.insert
local tls = {}
local system = {}
local tabs = {}
local menu = {}
local antiaim_func = {}
local aa_builder_main = {}
local attacked = {}
local LnextIndex = 1
local savecfg_1 = 0
local pitch_ads = 0
local current = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):get()
local aa_builder_main = {}
local cur_state = "Shared"
local libs = {}
local BUILD_VER = "2.4"
local BUILD_EDITION = ""
local cfgs = {}
local DEFAULT_CONFIG = "eyJpbnRzIjp7IjEiOiJEZWxheSIsIjIiOjAsIjMiOjAsIjQiOjAsIjUiOi0xNywiNiI6NDEsIjciOjMsIjgiOiJEaXNhYmxlZCIsIjkiOjAsIjEwIjp0cnVlLCIxMSI6ZmFsc2UsIjEyIjo2MCwiMTMiOjYwLCIxNCI6eyIxIjoiSml0dGVyIiwiMiI6In4ifSwiMTUiOmZhbHNlLCIxNiI6IlN0YXRpYyIsIjE3IjowLCIxOCI6MCwiMTkiOjMsIjIwIjowLCIyMSI6MCwiMjIiOjAsIjIzIjoiRGlzYWJsZWQiLCIyNCI6MCwiMjUiOjAsIjI2IjowLCIyNyI6MCwiMjgiOjAsIjI5IjoxLCIzMCI6MSwiMzEiOjEsIjMyIjpmYWxzZSwiMzMiOjEsIjM0IjoiRGVsYXkiLCIzNSI6NywiMzYiOi0yMiwiMzciOjM2LCIzOCI6LTM2LCIzOSI6MzYsIjQwIjo0LCI0MSI6IkRpc2FibGVkIiwiNDIiOi01NSwiNDMiOnRydWUsIjQ0IjpmYWxzZSwiNDUiOjI5LCI0NiI6NjAsIjQ3Ijp7IjEiOiJKaXR0ZXIiLCIyIjoifiJ9LCI0OCI6ZmFsc2UsIjQ5IjoiU3RhdGljIiwiNTAiOjAsIjUxIjowLCI1MiI6MywiNTMiOjAsIjU0IjowLCI1NSI6MCwiNTYiOiJEaXNhYmxlZCIsIjU3IjowLCI1OCI6MCwiNTkiOjAsIjYwIjowLCI2MSI6MCwiNjIiOjEsIjYzIjoxLCI2NCI6MSwiNjUiOmZhbHNlLCI2NiI6MSwiNjciOiJMZWZ0ICYgUmlnaHQiLCI2OCI6MCwiNjkiOi0xOSwiNzAiOjM4LCI3MSI6MCwiNzIiOjAsIjczIjoxLCI3NCI6IkRpc2FibGVkIiwiNzUiOjAsIjc2Ijp0cnVlLCI3NyI6ZmFsc2UsIjc4Ijo2MCwiNzkiOjYwLCI4MCI6eyIxIjoiSml0dGVyIiwiMiI6In4ifSwiODEiOmZhbHNlLCI4MiI6IlN0YXRpYyIsIjgzIjowLCI4NCI6MCwiODUiOjMsIjg2IjowLCI4NyI6MCwiODgiOjAsIjg5IjoiRGlzYWJsZWQiLCI5MCI6MCwiOTEiOjAsIjkyIjowLCI5MyI6MCwiOTQiOjAsIjk1IjoxLCI5NiI6MSwiOTciOjEsIjk4IjpmYWxzZSwiOTkiOjEsIjEwMCI6IkxlZnQgJiBSaWdodCIsIjEwMSI6NSwiMTAyIjotNywiMTAzIjo0MSwiMTA0IjotMTcsIjEwNSI6MjIsIjEwNiI6NCwiMTA3IjoiRGlzYWJsZWQiLCIxMDgiOi01MCwiMTA5Ijp0cnVlLCIxMTAiOmZhbHNlLCIxMTEiOjYwLCIxMTIiOjYwLCIxMTMiOnsiMSI6IkppdHRlciIsIjIiOiJ+In0sIjExNCI6ZmFsc2UsIjExNSI6IlNwaW4iLCIxMTYiOjAsIjExNyI6MCwiMTE4IjozLCIxMTkiOjAsIjEyMCI6MCwiMTIxIjowLCIxMjIiOiJEaXNhYmxlZCIsIjEyMyI6MCwiMTI0IjowLCIxMjUiOjAsIjEyNiI6MCwiMTI3IjowLCIxMjgiOjEsIjEyOSI6MSwiMTMwIjo4OSwiMTMxIjpmYWxzZSwiMTMyIjozLCIxMzMiOiJMZWZ0ICYgUmlnaHQiLCIxMzQiOjAsIjEzNSI6LTE3LCIxMzYiOjM2LCIxMzciOjAsIjEzOCI6MCwiMTM5IjoxLCIxNDAiOiJEaXNhYmxlZCIsIjE0MSI6MCwiMTQyIjp0cnVlLCIxNDMiOmZhbHNlLCIxNDQiOjYwLCIxNDUiOjYwLCIxNDYiOnsiMSI6IkppdHRlciIsIjIiOiJ+In0sIjE0NyI6dHJ1ZSwiMTQ4IjoiU3BpbiIsIjE0OSI6LTI1LCIxNTAiOjIwLCIxNTEiOjMsIjE1MiI6MCwiMTUzIjowLCIxNTQiOjAsIjE1NSI6IlNsb3cgU2lkZXdheXMiLCIxNTYiOjAsIjE1NyI6MCwiMTU4IjowLCIxNTkiOjAsIjE2MCI6MCwiMTYxIjoxLCIxNjIiOjEsIjE2MyI6MzYsIjE2NCI6dHJ1ZSwiMTY1IjoxLCIxNjYiOiJEZWxheSIsIjE2NyI6MCwiMTY4IjowLCIxNjkiOjAsIjE3MCI6MjYsIjE3MSI6MjIsIjE3MiI6MiwiMTczIjoiRGlzYWJsZWQiLCIxNzQiOjAsIjE3NSI6dHJ1ZSwiMTc2IjpmYWxzZSwiMTc3Ijo2MCwiMTc4Ijo2MCwiMTc5Ijp7IjEiOiJKaXR0ZXIiLCIyIjoifiJ9LCIxODAiOmZhbHNlLCIxODEiOiJTdGF0aWMiLCIxODIiOjAsIjE4MyI6MCwiMTg0IjozLCIxODUiOjAsIjE4NiI6MCwiMTg3IjowLCIxODgiOiJEaXNhYmxlZCIsIjE4OSI6MCwiMTkwIjowLCIxOTEiOjAsIjE5MiI6MCwiMTkzIjowLCIxOTQiOjEsIjE5NSI6MSwiMTk2IjoxLCIxOTciOmZhbHNlLCIxOTgiOjEsIjE5OSI6IkRlZmF1bHQiLCIyMDAiOjAsIjIwMSI6MCwiMjAyIjowLCIyMDMiOjAsIjIwNCI6MCwiMjA1IjoxLCIyMDYiOiJEaXNhYmxlZCIsIjIwNyI6MCwiMjA4Ijp0cnVlLCIyMDkiOmZhbHNlLCIyMTAiOjYwLCIyMTEiOjYwLCIyMTIiOnsiMSI6In4ifSwiMjEzIjp0cnVlLCIyMTQiOiJTcGluIiwiMjE1IjowLCIyMTYiOjAsIjIxNyI6MywiMjE4IjowLCIyMTkiOjAsIjIyMCI6MCwiMjIxIjoiSGlkZGVuIiwiMjIyIjowLCIyMjMiOjAsIjIyNCI6MCwiMjI1IjowLCIyMjYiOjAsIjIyNyI6NDcsIjIyOCI6MSwiMjI5IjoyOSwiMjMwIjp0cnVlLCIyMzEiOjEsIjIzMiI6dHJ1ZSwiMjMzIjp0cnVlLCIyMzQiOnRydWUsIjIzNSI6ZmFsc2UsIjIzNiI6dHJ1ZSwiMjM3IjoxMTksIjIzOCI6dHJ1ZSwiMjM5Ijp0cnVlLCIyNDAiOjg1LCIyNDEiOi0xLCIyNDIiOi03LCIyNDMiOjIsIjI0NCI6dHJ1ZSwiMjQ1Ijp0cnVlLCIyNDYiOiJDdXN0b20iLCIyNDciOjUsIjI0OCI6MTIwLCIyNDkiOiIjRkZGRkZGODYiLCIyNTAiOnRydWUsIjI1MSI6eyIxIjoiQ29uc29sZSIsIjIiOiJPbiBzY3JlZW4iLCIzIjoifiJ9LCIyNTIiOmZhbHNlLCIyNTMiOmZhbHNlLCIyNTQiOnRydWUsIjI1NSI6dHJ1ZSwiMjU2Ijp0cnVlLCIyNTciOiJTdGF0aWMiLCIyNTgiOiJTbG93IEppdHRlciIsIjI1OSI6ODAsIjI2MCI6eyIxIjoiTW92ZSBMZWFuIiwiMiI6In4ifSwiMjYxIjoiU3RhdGljIiwiMjYyIjpmYWxzZSwiMjYzIjoxLCIyNjQiOjEsIjI2NSI6ZmFsc2UsIjI2NiI6ZmFsc2UsIjI2NyI6eyJ3YXRlcm1hcmtfdHlwZSI6Ik1vZGVybiJ9LCIyNjgiOiJNb2Rlcm4iLCIyNjkiOnRydWUsIjI3MCI6dHJ1ZSwifjQzIjp7ImppdHRlcl9kZWxheSI6MSwibGVmdF9saW1pdCI6MjksImludmVydGVyMiI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MCwib3B0aW9uczIiOnsiMSI6IkppdHRlciIsIjIiOiJ+In19LCJ+NDgiOnsid2l0aF9ocyI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LCJ+NzYiOnsiaml0dGVyX2RlbGF5IjoxLCJsZWZ0X2xpbWl0Ijo2MCwiaW52ZXJ0ZXIyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLCJvcHRpb25zMiI6eyIxIjoiSml0dGVyIiwiMiI6In4ifX0sIn44MSI6eyJ3aXRoX2hzIjpmYWxzZSwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZX0sIn4xMDkiOnsiaml0dGVyX2RlbGF5IjozLCJsZWZ0X2xpbWl0Ijo2MCwiaW52ZXJ0ZXIyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLCJvcHRpb25zMiI6eyIxIjoiSml0dGVyIiwiMiI6In4ifX0sIn4xMTQiOnsid2l0aF9ocyI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LCJ+MTQyIjp7ImppdHRlcl9kZWxheSI6MSwibGVmdF9saW1pdCI6NjAsImludmVydGVyMiI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MCwib3B0aW9uczIiOnsiMSI6IkppdHRlciIsIjIiOiJ+In19LCJ+MTQ3Ijp7IndpdGhfaHMiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZX0sIn4xODAiOnsid2l0aF9ocyI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LCJ+MjA4Ijp7ImppdHRlcl9kZWxheSI6MSwibGVmdF9saW1pdCI6NjAsImludmVydGVyMiI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MCwib3B0aW9uczIiOnsiMSI6In4ifX0sIn4yMTMiOnsid2l0aF9ocyI6dHJ1ZSwiZm9yY2VfZGVmZW5zaXZlIjp0cnVlfSwifjIzMyI6eyJzYWZlX2hlYWRfa25pZmVfZSI6dHJ1ZX0sIn4yMzYiOnsiYXNwZWN0X3JhdGlvX3ZhbHVlIjoxMTl9LCJ+MTc1Ijp7ImppdHRlcl9kZWxheSI6MSwibGVmdF9saW1pdCI6NjAsImludmVydGVyMiI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MCwib3B0aW9uczIiOnsiMSI6IkppdHRlciIsIjIiOiJ+In19LCJ+MjQ1Ijp7InNjb3BldHlwZSI6IkN1c3RvbSIsInNjb3BlR2FwIjo1LCJzY29wZUNvbG9yIjoiI0ZGRkZGRjg2Iiwic2NvcGVMZW5ndGgiOjEyMH0sIn4yNTAiOnsiYWltbG9nc190eXBlIjp7IjEiOiJDb25zb2xlIiwiMiI6Ik9uIHNjcmVlbiIsIjMiOiJ+In19LCJ+MjU0Ijp7InNheV9vbl9kZWF0aCI6dHJ1ZX0sIn4yNTYiOnsic2xpZGVyX2ppdHRlciI6ODAsImppdHRlcl9jb21ibyI6IlNsb3cgSml0dGVyIiwiYWlyX2NvbWJvIjoiU3RhdGljIiwid2Fsa19jb21ibyI6IlN0YXRpYyIsIm90aGVyX2NvbWJvIjp7IjEiOiJNb3ZlIExlYW4iLCIyIjoifiJ9fSwifjI2NSI6eyJhaXJfZXhwbG9pdF9kZWxheSI6MX0sIn4yNjYiOnsiYXV0b190ZWxlcG9ydF9kZWxheSI6MX0sIn4yMzkiOnsidmlld21vZGVsX3kiOi03LCJ2aWV3bW9kZWxfeiI6MiwiY2hhbmdlX2hhbmRfb25fa25pZmUiOnRydWUsInZpZXdtb2RlbF9mb3YiOjg1LCJ2aWV3bW9kZWxfeCI6LTF9LCJ+MTUiOnsid2l0aF9ocyI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2V9LCJ+MTAiOnsiaml0dGVyX2RlbGF5IjoxLCJsZWZ0X2xpbWl0Ijo2MCwiaW52ZXJ0ZXIyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLCJvcHRpb25zMiI6eyIxIjoiSml0dGVyIiwiMiI6In4ifX19fQ=="
local IMG = "https://i.imgur.com/pqYdTuj.png"
local img_obj = render.load_image(network.get(IMG),vector(545,377))
local screen_x, screen_y = render.screen_size().x, render.screen_size().y

if not db.configs then
	db.configs  = {}	
end	
	

ffi.cdef[[
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
]]

--- vmt hook
local library = {}
library.list = {}

library.copy = function(void, source, length)
    return ffi.copy(ffi.cast("void*", void), ffi.cast("const void*", source), length)
end

library.virtual_protect = function(point, size, new_protect, old_protect)
    return ffi.C.VirtualProtect(ffi.cast("void*", point), size, new_protect, old_protect)
end

library.virtual_alloc = function(point, size, allocation_type, protect)
    local alloc = ffi.C.VirtualAlloc(point, size, allocation_type, protect)
    return ffi.cast("intptr_t", alloc)
end

library.new = function(address)
    local cache = {
        data = {},
        org_func = {},

        old_protection = ffi.new("unsigned long[1]"),
        virtual_table = ffi.cast("intptr_t**", address)[0]
    }

    cache.data.hook = function(cast, __function, method)
        cache.org_func[method] = cache.virtual_table[method]
        library.virtual_protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

        cache.virtual_table[method] = ffi.cast("intptr_t", ffi.cast(cast, __function))
        library.virtual_protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)

        return ffi.cast(cast, cache.org_func[method])
    end

    cache.data.unhook = function(method)
        library.virtual_protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

        local alloc_addr = library.virtual_alloc(nil, 5, 0x1000, 0x40)
        local trampoline_bytes = ffi.new("uint8_t[?]", 5, 0x90)

        trampoline_bytes[0] = 0xE9
        ffi.cast("int32_t*", trampoline_bytes + 1)[0] = cache.org_func[method] - tonumber(alloc_addr) - 5

        library.copy(alloc_addr, trampoline_bytes, 5)
        cache.virtual_table[method] = ffi.cast("intptr_t", alloc_addr)

        library.virtual_protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)
        cache.org_func[method] = nil
    end

    cache.data.unhook_all = function()
        for method, _ in pairs(cache.org_func) do
            cache.data.unhook(method)
        end
    end

    table.insert(library.list, cache.data.unhook_all)
    return cache.data
end

events.shutdown:set(function()
    for _, reset_function in ipairs(library.list) do
        reset_function()
    end
end)
	
	
local function list_cfgs()
    for i=1,table.getn(db.configs) do
        table.insert(cfgs,db.configs[i][2])
    end
end
list_cfgs()

local lerpik = function(start, vend, time)
    return start+(vend-start) * time
end
--font
local font = {
    verdana_bold = render.load_font("Verdana Bold", 22, "ab"),
    verdana_bold2 = render.load_font("Verdana Bold", 18, "ab"),
    verdana_bold3 = render.load_font("Verdana Bold", 17, "ab"),
    verdana = render.load_font("Verdana", 20, "ab"),
    verdana_ind = render.load_font("Verdana", 11, "ab"),
    verdana_arrows = render.load_font("Verdana", 25, "ab"),
    verdana = render.load_font("Verdana", 11, "a"),
    arial = render.load_font("arial", 12, "a"),
    arial_s = render.load_font("arial", 11, "a"),
    skeetind_font = render.load_font('calibri', 22, 'ab')

}

libs = {
    pui = require("neverlose/pui"),
    clipboard = require("neverlose/clipboard"),
    aa_library = require("neverlose/anti_aim"),
    gradient = require("neverlose/gradient"),
    animations = require("neverlose/animations"),
    base64 = require("neverlose/sec-base64"),
    drag_system = require 'neverlose/drag_system'
}


icon = ui.get_icon "react"
ui.sidebar("moriade", icon)



common.add_notify("moriade #white","Welcome " .. "\a96969696" .. common.get_username())


local game_rules = entity.get_game_rules()

aa_refs = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    hidden_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    freestanding_body = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    inv = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
}

refs = {
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    isDuck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(),
    isSafe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    isBody = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    isPeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    findik = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    findhs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    sloww = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    clantag = ui.find('Miscellaneous', 'Main', 'In-Game', 'Clan Tag'),
    fakelaglim = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
    fov = ui.find("Visuals", "World", "Main", "Field of View"),
    hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
}
find = {
    ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    da = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
}

tabs = {
    anti_aim = libs.pui.create("", {
        {"tab_switch", "\n", 1},
        {"condition1", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 1},
        {"tab_switch_aa_2", "\n\n\n\n\n\n\n\n\n\n\n\n\n", 2},
        {"tab_switch_def", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 1},
        {"condition", "\n\n\n\n\n", 2},
        {"tab_switch_misc", "\n\n\n\n", 2},
        {"builder", "\n\n\n\n", 2},
        {"exploits", "\n\n\n\n\n", 1},
        {"visuals", "\n\n\n\n\n\n\n\n", 2},
        {"visuals2", "\n\n\n\n\n\n\n\n\n", 1},
        {"info", "\n\n\n\n\n\n\n\n\n\n\n\n", 1},
        {"info2", "\n\n\n\n\n\n\n\n\n\n\n\n\n", 2},
        {"link", "\n\n\n\n\n\n\n\n\n\n\n\n", 2},
        {"img", "\n", 1},
        {"config", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n",2},
        {"tweaks", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 2},
        {"super", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 1},
        {"colors", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 1},
    }),
}

local tag_anim = {
    " ",
    "m_ ",
    "m0_ ",
    "mo6_ ",
    "mor1_ ",
    "mori4_ ",
    "moria6_ ",
    "moriad3_ ",
    "moriade._ ",
    "moriade.1_ ",
    "moriade.l7_ ",
    "moriade.lu4_ ",
    "moriade.lua_ ",
    "moriade.lua  ",
    "moriade.lua_ ",
    "moriade.lua  ",
    "moriade.lua_ ",
    "moriade.lua  ",
    "moriade.lua_ ",
    "moriade.lua  ",
    "moriade.lua_ ",
    "moriade.lua  ",
    "moriade.lu" ,
    "moriade.l ",
    "moriade. ",
    "moriade ",
    "moriad ",
    "moria ",
    "mori ",
    "mor ",
    "mo ",
    "m ",
    " ",
}

local phase_first = {
    "ｌｉｉａｎ ｈｅｌｐｏｓｔｉ",
    "9l YbNJL Teb9l CJLNIIIkoM JleGKo",
    "ｏｐｒａｖｄａｎｉｙａ ｖ ｈｕｙ?",
	"ｃａｔａｐｕｌｔａｔｅｄ",
    "𝖒𝖔𝖗𝖎𝖆𝖉𝖊 𝖔𝖜𝖓𝖘 𝖆𝖑𝖑 𝖇𝖔𝖙𝖘 𝖎𝖓 𝖙𝖍𝖎𝖘 𝖜𝖔𝖗𝖑𝖉",
    "ty for clip :>",
    "【 𝖆𝖓𝖙𝖎-𝖆𝖎𝖒𝖇𝖔𝖇 𝖘𝖞𝖘𝖙𝖊𝖒 】",
    ":3 К9aCнbIй ЯнB4рb :3  <3 К9aCнbIй ЯнB4рb <3 kP0Bb $$$",
    "ɎØɄ'ⱤɆ ₴Ø ₱₳₮ⱧɆ₮ł₵ | Đ₴₵.₲₲/₥ØⱤł₳ĐɆ",
    "ᴇбᴀноᴇ оᴛᴩодьᴇ хуя чᴇ ʙ хуй чᴇ ᴄ хуя ʙ ᴩоᴛ ᴛʙоᴇй ʍᴀᴛᴇᴩи",
    "ʜʟᴛᴠʟᴇɢᴇɴᴅ <---- ʍᴇнᴇджᴇᴩ ᴨо ᴛʙоиʍ ʍинᴇᴛᴀʍ",
    "𝐥𝐚𝐜𝐡𝐛𝐨𝐦𝐛𝐞𝐝",
}


local phase_dead = {
    "ᴋᴀᴋ ᴛы ʍᴇня убиᴧ ʙᴩᴇдиᴛᴇᴧь",
    "ʍиндᴀʍᴀᴦ ʍиниᴄᴛᴩ",
    "ᴧᴀдно боʍж ᴇбᴧиʙый нᴀ ϶ᴛоᴛ ᴩᴀз ᴛᴇбя чиᴛ ᴨᴩоᴄᴛиᴧ",
	"чᴇ ᴛо ᴛᴀʍ ᴦыᴦыᴦы ʙᴩᴇдиᴛᴇᴧь",
    "𝐥𝐮𝐜𝐤𝐛𝐨𝐨𝐬𝐭𝐞𝐝",
    "𝐥𝐮𝐜𝐤𝐛𝐚𝐬𝐞𝐝",
    "ᴇбᴀнный ʙᴩᴇдиᴛᴇᴧь",
    "ᛊᎶᚤᚺᚺⰓᛁᛋ ᚢᛋᛟᛜᚹᚤᛈ"
}





menu = {
    anti_aim = {
        info = {
            welcome_username = tabs.anti_aim.info2:label("»  Logined in as: \v"..common.get_username()..""),
            welcome_build = tabs.anti_aim.info2:label("»  Build: \aFFFFFFFFWhite  "..BUILD_VER.."  "..icon.."                         "),
            link_discord = tabs.anti_aim.info2:button("\f<discord> Discord ", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/moriade")
            end, true),
            link_youtube = tabs.anti_aim.info2:button("\f<gear> Config 1", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=lKsWVm")
            end, true),
            link_config = tabs.anti_aim.info2:button("\f<gear> Config 2", function()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://ru.neverlose.cc/market/item?id=7s4d2H")
            end, true),
        },
        tab_switch = {
            tab_switcher = tabs.anti_aim.tab_switch:list('', {"\v\f<circle-info>\r    Info", "\v\f<user-pen>\r  Anti-Aim", "\v\f<pen-to-square>\r   Settings", "\v\f<gear>\r   Rage"}),
            tab_name = tabs.anti_aim.tab_switch:label("                 \aFFFFFFFF      moriade.lua ® 2024     ")
        },  
        tab_switch_aa = {
            tab_switch_aa_2 = tabs.anti_aim.tab_switch_aa_2:list('', {"\v\f<sliders>\r  Anti-aims", "\v\f<wrench>\r  Tweaks"}),
        },
        tab_switch_def = {
            tab_switch_def_2 = tabs.anti_aim.tab_switch_def:list('', {"\f<gears> Builder", "\f<layer-group> Defensive"}),
        },
        tab_switch_misc = {
            tab_switch_misc_2 = tabs.anti_aim.tab_switch_misc:list('', {"\v\f<paintbrush>\r Visuals", "\v\f<layer-group>\r Miscellaneous"}),
        },
        condition = {
            conditions = tabs.anti_aim.condition1:combo("\v\f<bars-sort>\r    Conditions", {"Standing", "Running", "Air", "Air Crouch", "Crouch", "Sneaking", "Slow moving"}, false, nil, function(gear)
                return {
                    manul_aa = gear:combo("\v\f<arrow-right-arrow-left>\r Manual", {"Disabled", "Left", "Right", "Forward"}),
                    fs_aa = gear:switch("\v\f<repeat>\r Freestanding")}
            end),
        },

        img = {
            img_u = tabs.anti_aim.img:texture(img_obj,vector(265,170),color(),"",5),
        },
        
        visuals = {
            ts = tabs.anti_aim.visuals:switch("\v\f<repeat>\r   Arrows", false, nil, function(gear) 
                return {
                    ts_type = gear:combo("Type", "Adaptive", "TeamSkeet"),
                    accent_color = gear:color_picker("Color", color(138, 207, 255, 255)),
                    ts_cl1 = gear:color_picker("Accent Color", color(175, 255, 0, 255)),
                    ts_cl2 = gear:color_picker("Desync Color", color(0, 200, 255, 255)),
                }
            end),
            aimlogs = tabs.anti_aim.visuals:switch("\v\f<gears>\r  Aimbot Logs",false,nil,function(gear)
                return {
                    aimlogs_type = gear:selectable("Type",{"Console","On screen"}),
                }
            end),
            viewmodel = tabs.anti_aim.visuals:switch("\v\f<hand-middle-finger>\r  Viewmodel", false, nil, function(gear) 
                return {
                    viewmodel_fov = gear:slider("FOV", -100, 100, 68),
                    viewmodel_x = gear:slider("X", -10, 10, 2.5, 0.1),
                    viewmodel_y = gear:slider("Y", -10, 10, 0, 0.1),
                    viewmodel_z = gear:slider("Z", -10, 10, -1.5, 0.1),
                    change_hand_on_knife = gear:switch("Change Hand On Knife")
                }
            end),
            customscope = tabs.anti_aim.visuals:switch("\v\f<telescope>\r  Scope", false, nil, function(gear) 
                return {
                    scopetype = gear:combo("Type", "Custom", "Reversed"),
                    scopeGap = gear:slider("Gap", 0, 300, 5),
                    scopeLength = gear:slider("Length", 0, 300, 120),
                    scopeColor = gear:color_picker(" Color", color(255, 255, 255, 134)),
                }
            end),
            air_exploit = tabs.anti_aim.visuals:switch("\v\f<rocket>\r  Air Exploit", false, nil, function(gear)
                return {
                    air_exploit_delay = gear:slider("Delay", 1, 40, 1),
                }
            end),
            
            legs_jitter = tabs.anti_aim.visuals:switch('\v\f<street-view>\r  Anim Breaker', false, nil, function(gear)
                return {
                    jitter_combo = gear:combo("\v\f<person-running>\r   Ground", "Disabled", "Flex", "Static", "Walking", "Fast Jitter", "Slow Jitter"),
                    slider_jitter = gear:slider("\v\f<pen-nib>\r   Speed", 0, 100, 80),
                    air_combo = gear:combo("\v\f<child-dress>\r    Air", "Disabled", "Static", "Kangaroo", "Walking"),
                    walk_combo = gear:combo("\v\f<person-walking-with-cane>\r  Slow Walking", "Disabled", "Static", "Jitter", "Pirat"),
                    other_combo = gear:selectable("\v\f<gear>\r  Other Animation", "Earthquake", "Move Lean"),
                }
            end),
            trash_talk = tabs.anti_aim.visuals:switch("\v\f<message>\r  Trash Talk" ,false, nil,function (gear)
                return{
                    say_on_death = gear:switch("\v\f<message>\r  Say On Death"),
                }
            end),
            clantag52 = tabs.anti_aim.visuals:switch("\v\f<user-tag>\r Clantag"),
            aspect_ratio = tabs.anti_aim.visuals:switch("\v\f<person-rays>\r   Aspect Ratio", false, nil, function(gear) 
                return {
                    aspect_ratio_value = gear:slider("Value", 0, 400, 0, 0.01),
                    a43 = gear:button("4:3"),
                    a1610 = gear:button("16:10"),
                    a54 = gear:button("5:4"),
                }
            end),
            fps_boost = tabs.anti_aim.visuals:switch("\v\f<palette>\r  FPS Boost"),
            damage_ind = tabs.anti_aim.visuals:switch("\v\f<gears>\r  Damage Indicator"),
            auto_baim = tabs.anti_aim.visuals:switch("\v\f<shield-halved>\r  Ragebot improver"),
            grenades = tabs.anti_aim.visuals:label("\v\f<gears>\r  Nades", false, nil, function(gear)
                return {
                fix = gear:switch("\v\f<crosshairs>\r  Throw Fix"),
                toss = gear:switch("\v\f<splotch>\r  Super Toss"),
                }
            end),
            auto_teleport = tabs.anti_aim.visuals:switch("\v\f<wind>\r  Auto teleport", false, nil, function(gear) 
                return {
                    auto_teleport_delay = gear:slider("Delay", 1, 20, 1),
                }
            end),
        },
        tweaks = {
            avoid_backstab = tabs.anti_aim.tweaks:switch("\v\f<shoe-prints>\r  Avoid backstab"),
            safe_head_knife = tabs.anti_aim.tweaks:switch("\v\f<knife>\r   Safe Head Additiions", false, function(gear)
                return {
                safe_head_knife_e = gear:switch("Flick Defensive"),
                }
            end),
            fs_flick = tabs.anti_aim.tweaks:switch("\v\f<rotate-exclamation>\r  Flick function", false, nil, function(gear)
                return {
                    vibor = gear:selectable("Flick opposite on", {"Manual Left", "Manual Right", "Freestand"})
                }
            end),
            randomize_warmup = tabs.anti_aim.tweaks:switch("\v\f<rotate-right>\r   Spin on round end"),
            fastladder = tabs.anti_aim.tweaks:switch("\v\f<water-ladder>\r   Fast ladder"),
        },
        private = {
            watermark = tabs.anti_aim.colors:label("\v\f<screwdriver-wrench>\r  Watermark", false, function(gear)
            return {
                watermark_type = gear:combo("\v\f<palette>\r  Style", "Modern", "Alternative"),
                }
            end),
            gs_ind = tabs.anti_aim.colors:switch("\v\f<dollar-sign>\r  GS indicators"),
            widgets = tabs.anti_aim.colors:label("\v\f<window>\r  Widgets", false, nil, function(gear)
                return {
                    vibor = gear:selectable("Settings", {"Keybinds", "Spectators", "Watermark"})
            }
        end),
        },
        config = {
            config_id = tabs.anti_aim.config:list("\v\f<code>\r  Configs", cfgs),
            config_name = tabs.anti_aim.config:input("\f<message> Config Name "),
        },
    },
}



-- tooltips
menu.anti_aim.visuals.air_exploit:tooltip("Teleport exploit (enemy will delay)")


for i = 1, 7 do 
    aa_builder_main[i] = {
        -- YAW
        yaw = tabs.anti_aim.condition:combo("\v\f<arrow-up-right-and-arrow-down-left-from-center>\r   Yaw", {"Default", "Left & Right", "Delay",}),
        yaw_offset = tabs.anti_aim.condition:slider("\v\f<left-right>\r   Offset", -180, 180, 0),
        yaw_offset_left = tabs.anti_aim.condition:slider("\v\f<arrow-left>\r   Left", -180, 180, 0),
        yaw_offset_right = tabs.anti_aim.condition:slider("\v\f<arrow-right>\r   Right", -180, 180, 0),
        yaw_delay_left = tabs.anti_aim.condition:slider("\v\f<arrow-left>\r   Left", -180, 180, 0),
        yaw_delay_right = tabs.anti_aim.condition:slider("\v\f<arrow-right>\r   Right", -180, 180, 0),
        delay_ticks_slider = tabs.anti_aim.condition:slider(string.format("\v\f<clock>\r   Delay"), 1, 10, 1),
        -- YAW MODIFIER
        yaw_mod = tabs.anti_aim.condition:combo("\v\f<sliders>\r   Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "3-Way", "5-Way"}),
        yaw_mod_offset = tabs.anti_aim.condition:slider("\v\f<left-right>\r   Offset", -180, 180, 0),
        -- BODY YAW
        enable_body_yaw = tabs.anti_aim.condition:switch("\v\f<gear>\r   Body Yaw", false, nil, function(gear) 
            return {
                inverter2 = gear:switch("Inverter"),
                left_limit = gear:slider("Left", 0, 60, 60),
                right_limit = gear:slider("Right", 0, 60, 60),
                options2 = gear:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}),
                jitter_delay = gear:slider("Desync Delay", 1, 5, 1),
            }
        end),

        -- DEFENISVE ANTI AIM
        defensive_aa_enabled = tabs.anti_aim.exploits:switch("\v\f<shield>\r    Defensive AA", false, nil, function(gear)
            return {
                force_on = gear:selectable("Force on", {"Double tap", "Hide shots"}),
                addi = gear:selectable("Additiions", {"Hittable", "Lethal"}),
            }
        end),
        defensive_aa_pitch = tabs.anti_aim.exploits:combo("\v\f<user-plus>\r   Pitch", {"Static", "Switch", "Random", "3 way", "Spin"}),
        defensive_aa_pitch_switch_first_value = tabs.anti_aim.exploits:slider("\v\f<arrow-left>\r   First Value", -89, 89, 0),
        defensive_aa_pitch_switch_second_value = tabs.anti_aim.exploits:slider("\v\f<arrow-right>\r   Second Value", -89, 89, 0),
        defensive_aa_pitch_switch_speed_value = tabs.anti_aim.exploits:slider("\v\f<timer>\r   Delay", 3, 20, 0),
        defensive_aa_pitch_random_first_value = tabs.anti_aim.exploits:slider("\v\f<arrow-left>\r   From", -89, 89, 0),
        defensive_aa_pitch_random_second_value = tabs.anti_aim.exploits:slider("\v\f<arrow-right>\r   To", -89, 89, 0),
        defensive_aa_pitch_value = tabs.anti_aim.exploits:slider("\v\f<left-right>\r    Offset", -89, 89, 0, 1, function(er)
            if er == 0 then return "Zero"
            elseif er == -89 then return "Up"
            elseif er == 89 then return "Down"
            elseif er == -45 then return "Up-s"
            elseif er == 45 then return "Down-s"
            end
        end),
        defensive_aa_pitch_3way_first_value = tabs.anti_aim.exploits:slider("\v\f<f>\r    First Value", -89, 89, 0),
        defensive_aa_pitch_3way_second_value = tabs.anti_aim.exploits:slider("\v\f<s>\r    Second Value", -89, 89, 0),
        defensive_aa_pitch_3way_third_value = tabs.anti_aim.exploits:slider("\v\f<t>\r    Third Value", -89, 89, 0),
        defensive_aa_pitch_spin_range = tabs.anti_aim.exploits:slider("\v\f<left-right>\r    Range", 1, 89, 1),
        defensive_aa_yaw = tabs.anti_aim.exploits:combo("\v\f<user-minus>\r   Yaw", {"Disabled", "Spinbot", "Offset", "Custom Jitter", "Random"}),
        defensive_aa_yaw_switch_first_value = tabs.anti_aim.exploits:slider("\v\f<arrow-left>\r   Left", -180, 180, -90),
        defensive_aa_yaw_switch_second_value = tabs.anti_aim.exploits:slider("\v\f<arrow-right>\r   Right", -180, 180, 90),
        defensive_aa_yaw_default = tabs.anti_aim.exploits:slider("\v\f<left-right>\r    Offset", -180, 180, 0),
        defensive_aa_yaw_custom_delay = tabs.anti_aim.exploits:slider("\v\f<timer>\r    Delay", 4, 40, 1),
        defensive_aa_yaw_random_first_value = tabs.anti_aim.exploits:slider("\v\f<arrow-left>\r   From", -180, 180, 0),
        defensive_aa_yaw_random_second_value = tabs.anti_aim.exploits:slider("\v\f<arrow-right>\r   To", -180, 180, 0),
        defensive_aa_yaw_spin_range = tabs.anti_aim.exploits:slider("Range", 1, 180, 0, true, "°", 1),
        defensive_aa_yaw_spin_speed = tabs.anti_aim.exploits:slider("Speed", 1, 20, 1, 0.5, true, "", 1),
        }
end

local function cond_trig()
    if menu.anti_aim.condition.conditions:get() == "Standing" then
        return 1
    end
    if menu.anti_aim.condition.conditions:get() == "Running" then
        return 2
    end
    if menu.anti_aim.condition.conditions:get() == "Air" then
        return 3
    end
    if menu.anti_aim.condition.conditions:get() == "Air Crouch" then
        return 4
    end
    if menu.anti_aim.condition.conditions:get() == "Crouch" then
        return 5
    end
    if menu.anti_aim.condition.conditions:get() == "Sneaking" then
        return 6
    end
    if menu.anti_aim.condition.conditions:get() == "Slow moving" then
        return 7
    end
end  

local if_inverted = false

local stateid = 1

ground_ticks, end_time = 1, 0
local in_air = function()
    if not entity.get_local_player() == nil then return end
    if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
        end_time = globals.curtime + 1
    end
    return ground_ticks > 1 and end_time > globals.curtime
end

local get_player_state = function(cmd)
    in_air()

    on_ground = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) ~= 0
    jump = (cmd.in_jump) and end_time > (globals.curtime + 0.9)
    is_slowwalk = refs.sloww:get()
    crouch = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 1)) ~= 0 or refs.fakeduck:get()
    vx, vy, vz = entity.get_local_player().m_vecVelocity.x, entity.get_local_player().m_vecVelocity.y, entity.get_local_player().m_vecVelocity.z
    math_velocity = math.sqrt(vx ^ 2 + vy ^ 2)
    move = math_velocity > 5
    local is_not_moving = entity.get_local_player().m_vecVelocity:length() < 2

    if not refs.doubletap:get() and not refs.hideshots:get() or refs.fakeduck:get() or rage.exploit:get() == 0 then return "Fake Lag"
    elseif on_ground and not move and not crouch then return "Stand"
    elseif not jump and not crouch and not is_not_moving and not is_slowwalk then return "Move"
    elseif refs.sloww:get() and on_ground then return "Walk"
    elseif crouch and not move and (not jump and on_ground) then return "Crouch"
    elseif crouch and move and (not jump and on_ground) and not refs.sloww:get() then return "Sneak"
    elseif jump and not crouch then return "Air"
    elseif crouch and (jump or not on_ground) then  return "AirCrouch"
    else return "Shared" end
end

local anti_aim = function(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    if get_player_state(cmd) == "Stand" then stateid = 1
    elseif get_player_state(cmd) == "Move" then stateid = 2
    elseif get_player_state(cmd) == "Air" then stateid = 3
    elseif get_player_state(cmd) == "AirCrouch" then stateid = 4
    elseif get_player_state(cmd) == "Crouch" then stateid = 5
    elseif get_player_state(cmd) == "Sneak" then stateid = 6
    elseif refs.sloww:get() then stateid = 7 end

    local inverted = entity.get_local_player().m_flPoseParameter[11] * 120 - 60 > 0

    if aa_builder_main[stateid].yaw:get() == "Delay" then
        aa_refs.options:set("Jitter")
        if (if_inverted and globals.tickcount % (aa_builder_main[stateid].delay_ticks_slider:get() * 1) > 0) then
            rage.antiaim:inverter(false) if_inverted = false
        elseif (not if_inverted and globals.tickcount % (aa_builder_main[stateid].delay_ticks_slider:get() * 1) > 0) then
            rage.antiaim:inverter(true) if_inverted = true
        end
    end

    aa_refs.yaw:override(aa_builder_main[stateid].yaw:get())
    aa_refs.yaw_modifier:override(aa_builder_main[stateid].yaw_mod:get())
    aa_refs.modifier_degree:override(aa_builder_main[stateid].yaw_mod_offset:get())

    if aa_builder_main[stateid].yaw:get() == "Default" then
        aa_refs.yaw_offset:override(aa_builder_main[stateid].yaw_offset:get())
    elseif aa_builder_main[stateid].yaw:get() == "Left & Right" then
        aa_refs.yaw_offset:override(inverted and aa_builder_main[stateid].yaw_offset_left:get() or aa_builder_main[stateid].yaw_offset_right:get())
    elseif aa_builder_main[stateid].yaw:get() == "Delay" then
        aa_refs.yaw_offset:override(inverted and aa_builder_main[stateid].yaw_delay_left:get() or aa_builder_main[stateid].yaw_delay_right:get())
    end

    aa_refs.body_yaw:override(aa_builder_main[stateid].enable_body_yaw:get())
    aa_refs.inv:override(aa_builder_main[stateid].enable_body_yaw.inverter2:get())
    aa_refs.left_limit:override(aa_builder_main[stateid].enable_body_yaw.left_limit:get())
    aa_refs.right_limit:override(aa_builder_main[stateid].enable_body_yaw.right_limit:get())
    aa_refs.freestanding_body:override("Off")


    
    if aa_builder_main[stateid].enable_body_yaw.options2:get("Jitter") and aa_builder_main[stateid].enable_body_yaw.jitter_delay:get() > 1 then
            body_yaw_options = aa_builder_main[stateid].enable_body_yaw.options2:get()
            if globals.tickcount % aa_builder_main[stateid].enable_body_yaw.jitter_delay:get() > 1 then
            aa_refs.inv:set(true)
            for i in pairs(body_yaw_options) do
                if body_yaw_options[i] == "Jitter" then
                    body_yaw_options[i] = ""
                end
            end
        end
    else
            aa_refs.inv:set(false)
            body_yaw_options = aa_builder_main[stateid].enable_body_yaw.options2:get()
    end
    aa_refs.options:override(body_yaw_options)

    if menu.anti_aim.condition.conditions.fs_aa:get() then
        aa_refs.freestanding:override(true)
    else
        aa_refs.freestanding:override()
    end

    if aa_builder_main[stateid].defensive_aa_enabled:get() then aa_refs.hidden_yaw:set(true) else aa_refs.hidden_yaw:set(false) end

    if aa_builder_main[stateid].defensive_aa_enabled:get() and find.dt then 
        refs.findik:override("Always on")

        if aa_builder_main[stateid].defensive_aa_pitch:get() == "Static" then
            rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_value:get())
        elseif aa_builder_main[stateid].defensive_aa_pitch:get() == "Switch" then
            if globals.tickcount % aa_builder_main[stateid].defensive_aa_pitch_switch_speed_value:get() > 5 then
                rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_switch_first_value:get())
            else
                rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_switch_second_value:get())
            end
        elseif aa_builder_main[stateid].defensive_aa_pitch:get() == "Random" then
            rage.antiaim:override_hidden_pitch(math.random(aa_builder_main[stateid].defensive_aa_pitch_random_first_value:get(), aa_builder_main[stateid].defensive_aa_pitch_random_second_value:get()))
        elseif aa_builder_main[stateid].defensive_aa_pitch:get() == "3 way" then
            if globals.tickcount % 3 == 0 then
                rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_3way_first_value:get())
            elseif globals.tickcount % 3 == 1 then
                rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_3way_second_value:get())
            elseif globals.tickcount % 3 == 2 then
                rage.antiaim:override_hidden_pitch(aa_builder_main[stateid].defensive_aa_pitch_3way_third_value:get())
            end
        elseif aa_builder_main[stateid].defensive_aa_pitch:get() == "Spin" then
            if pitch_ads <= aa_builder_main[stateid].defensive_aa_pitch_spin_range:get() then
                pitch_ads = pitch_ads + 2
            else
                pitch_ads = (-pitch_ads) + 2
            end
                rage.antiaim:override_hidden_pitch(-pitch_ads)
            end
        end

    if aa_builder_main[stateid].defensive_aa_enabled:get() then
        refs.findik:override("Always on")
        local cur_time = globals.curtime
        local tick = globals.tickcount
        if aa_builder_main[stateid].defensive_aa_yaw:get() == "Offset" then
            if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Double tap") and refs.doubletap:get() or aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Hide shots") and refs.hideshots:get() then 
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
            rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_default:get())
        else
            rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_default:get())
        end
        elseif aa_builder_main[stateid].defensive_aa_yaw:get() == "Custom Jitter" then
            if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Double tap") and refs.doubletap:get() or aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Hide shots") and refs.hideshots:get() then 
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
            if globals.tickcount % aa_builder_main[stateid].defensive_aa_yaw_custom_delay:get() > aa_builder_main[stateid].defensive_aa_yaw_custom_delay:get() / 2 then
                rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_switch_first_value:get())
            else
                rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_switch_second_value:get())
            end
        else
            if globals.tickcount % aa_builder_main[stateid].defensive_aa_yaw_custom_delay:get() > aa_builder_main[stateid].defensive_aa_yaw_custom_delay:get() / 2 then
                rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_switch_first_value:get())
            else
                rage.antiaim:override_hidden_yaw_offset(aa_builder_main[stateid].defensive_aa_yaw_switch_second_value:get())
            end
        end
        elseif aa_builder_main[stateid].defensive_aa_yaw:get() == "Random" then
            if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Double tap") and refs.doubletap:get() or aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Hide shots") and refs.hideshots:get() then 
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
            rage.antiaim:override_hidden_yaw_offset(math.random(aa_builder_main[stateid].defensive_aa_yaw_random_first_value:get(), aa_builder_main[stateid].defensive_aa_yaw_random_second_value:get()))
        else
            rage.antiaim:override_hidden_yaw_offset(math.random(aa_builder_main[stateid].defensive_aa_yaw_random_first_value:get(), aa_builder_main[stateid].defensive_aa_yaw_random_second_value:get()))
        end
        elseif aa_builder_main[stateid].defensive_aa_yaw:get() == "Spinbot" then
            if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Double tap") and refs.doubletap:get() or aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Hide shots") and refs.hideshots:get() then 
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
                aa_refs.options:override("")
            local speed = aa_builder_main[stateid].defensive_aa_yaw_spin_speed:get() / 2
            local range = aa_builder_main[stateid].defensive_aa_yaw_spin_range:get()
            rage.antiaim:override_hidden_yaw_offset(-math.fmod(cur_time * (speed * 180), range * 2) + range)
        else
            local speed = aa_builder_main[stateid].defensive_aa_yaw_spin_speed:get()
            local range = aa_builder_main[stateid].defensive_aa_yaw_spin_range:get()
            rage.antiaim:override_hidden_yaw_offset(-math.fmod(cur_time * (speed * 360), range * 2) + range)
        end
        elseif aa_builder_main[stateid].defensive_aa_yaw:get() == "Disabled" then 
            rage.antiaim:override_hidden_yaw_offset(0)
        end
    end
    -- manual anti-aim
    if menu.anti_aim.condition.conditions.manul_aa:get() == "Left" then
        aa_refs.yaw_offset:override(-90)
        aa_refs.yaw_base:override("Local View")
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.options:override("")
        aa_refs.freestanding:override(false)
        aa_refs.hidden_yaw:override(false)
    elseif menu.anti_aim.condition.conditions.manul_aa:get() == "Right" then
        aa_refs.yaw_offset:override(90)
        aa_refs.yaw_base:override("Local View")
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.options:override("")
        aa_refs.freestanding:override(false)
        aa_refs.hidden_yaw:override(false)
    elseif menu.anti_aim.condition.conditions.manul_aa:get() == "Forward" then
        aa_refs.yaw_offset:override(180)
        aa_refs.yaw_base:override("Local View")
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.options:override("")
        aa_refs.freestanding:override(false)
        aa_refs.hidden_yaw:override(false)
    else
        aa_refs.yaw_base:override("At Target")
    end


    refs.backstab:override(menu.anti_aim.tweaks.avoid_backstab:get())

    if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Double tap") then
        refs.findik:override("Always on")
        else
        refs.findik:override("On peek")
    end

    if aa_builder_main[stateid].defensive_aa_enabled.force_on:get("Hide shots") then
        refs.findhs:override("Break LC")
    else
        refs.findhs:override("Favor Fire Rate")
    end

    if aa_builder_main[stateid].defensive_aa_enabled.addi:get("Hittable") and not aa_builder_main[stateid].defensive_aa_enabled.addi:get("Lethal") and refs.doubletap or refs.hideshots then
        if entity.get_threat(true) and aa_builder_main[stateid].defensive_aa_enabled.addi:get("Hittable") then
            if entity.get_threat(true) then
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
                refs.findik:override("Always on")
                refs.findhs:override("Break LC")
                --aa_refs.hidden_yaw:set(true)
            else
                refs.findik:override("On peek")
                refs.findhs:override("Favor Fire Rate")
                --aa_refs.hidden_yaw:set(false)
            end
        end
    end

    if aa_builder_main[stateid].defensive_aa_enabled.addi:get("Lethal") and refs.doubletap:get() or refs.hideshots:get() then
        local lp = entity.get_local_player()
        local hp = lp.m_iHealth
            if hp <= 92 and hp > 0 and aa_builder_main[stateid].defensive_aa_enabled.addi:get("Lethal") then
                aa_refs.yaw_offset:override(0)
                aa_refs.yaw_modifier:override("Disabled")
                refs.findik:override("Always on")
                refs.findhs:override("Break LC")
                --aa_refs.hidden_yaw:set(true)
            end
        end
end

-- visibility anti-aims
anti_aim_visible = function()
    local cond = cond_trig()

    for i = 1, 7 do
        menu.anti_aim.condition.conditions:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1)
        aa_builder_main[i].yaw:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].defensive_aa_enabled:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 )
        aa_builder_main[i].yaw_mod:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].defensive_aa_enabled:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_switch_first_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Switch" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_switch_speed_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Switch" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_switch_second_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Switch" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_random_first_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Random" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_random_second_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Random" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_3way_first_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "3 way" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_3way_second_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "3 way" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_3way_third_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "3 way" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_spin_range:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Spin" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_pitch_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_pitch:get() == "Static" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_switch_first_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Custom Jitter" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_switch_second_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Custom Jitter" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_default:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Offset" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_custom_delay:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Custom Jitter" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_random_first_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Random" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_random_second_value:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Random" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_spin_range:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Spinbot" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].defensive_aa_yaw_spin_speed:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and aa_builder_main[i].defensive_aa_enabled:get() and aa_builder_main[i].defensive_aa_yaw:get() == "Spinbot" and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 2)
        aa_builder_main[i].yaw_offset:visibility(cond == i and aa_builder_main[i].yaw:get() == "Default" and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].yaw_offset_left:visibility(cond == i and aa_builder_main[i].yaw:get() == "Left & Right" and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].yaw_offset_right:visibility(cond == i and aa_builder_main[i].yaw:get() == "Left & Right" and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].yaw_delay_left:visibility(cond == i and aa_builder_main[i].yaw:get() == "Delay" and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].yaw_delay_right:visibility(cond == i and aa_builder_main[i].yaw:get() == "Delay" and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].delay_ticks_slider:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and aa_builder_main[i].yaw:get() == "Delay" and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].yaw_mod_offset:visibility(cond == i and menu.anti_aim.tab_switch.tab_switcher:get() == 2 and aa_builder_main[i].yaw_mod:get() ~="Disabled" and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1 and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw.inverter2:visibility(aa_builder_main[i].enable_body_yaw:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw.left_limit:visibility(aa_builder_main[i].enable_body_yaw:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw.right_limit:visibility(aa_builder_main[i].enable_body_yaw:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw.options2:visibility(aa_builder_main[i].enable_body_yaw:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1)
        aa_builder_main[i].enable_body_yaw.jitter_delay:disabled(not(aa_builder_main[i].enable_body_yaw:get() and menu.anti_aim.tab_switch_def.tab_switch_def_2:get() == 1 and aa_builder_main[i].enable_body_yaw.options2:get("Jitter") and not aa_builder_main[i].enable_body_yaw.options2:get("Randomize Jitter")))
    end

    exporttcp:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    importfcp:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    defaultpreset:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    savecfg:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    overwritecfg:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    loadcfg:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    deletecfg:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.config.config_id:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
end
menu.anti_aim.config.config_name:visibility(false)


-- visibility anti-aims end
--clantag
local ct_animation = function()
    if utils.net_channel() == nil then return end
    local set_clan_tag = math.floor(math.fmod((globals.tickcount + (utils.net_channel().latency[0] / globals.tickinterval)) / 28, #tag_anim + 1) + 1)
    return tag_anim[set_clan_tag]
end

local ct_check = nil
local clan_tag = function(tag_anim)
    if tag_anim == ct_check then return end
    if tag_anim == nil then return end

    common.set_clan_tag(tag_anim)
    ct_check = tag_anim
end

-- Scope
local lerp = function(time,a,b)
    return a * (1-time) + b * time
end

length = 0
gap = 0

local function customscope()
    if menu.anti_aim.visuals.customscope:get() then
        local x = render.screen_size().x
        local y = render.screen_size().y
        local localplayer = entity.get_local_player()
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove All")
        if localplayer == nil then return end
        if localplayer.m_iHealth < 1 then return end
		length = lerp(0.2, length, localplayer.m_bIsScoped and menu.anti_aim.visuals.customscope.scopeLength:get() or 0)
		gap = lerp(0.2, gap, localplayer.m_bIsScoped and menu.anti_aim.visuals.customscope.scopeGap:get() or 0) 
		local scopeColor_x = color(menu.anti_aim.visuals.customscope.scopeColor:get().r, menu.anti_aim.visuals.customscope.scopeColor:get().g, menu.anti_aim.visuals.customscope.scopeColor:get().b, menu.anti_aim.visuals.customscope.scopeColor:get().a)
		local scopeColor_y = color(menu.anti_aim.visuals.customscope.scopeColor:get().r, menu.anti_aim.visuals.customscope.scopeColor:get().g, menu.anti_aim.visuals.customscope.scopeColor:get().b, 0)
        if menu.anti_aim.visuals.customscope.scopetype:get() == "Custom" then
            render.gradient(vector(x / 2 - gap, y / 2), vector(x / 2 - gap - length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
            render.gradient(vector(x / 2 + gap, y / 2), vector(x / 2 + gap + length, y / 2 + 1), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
            render.gradient(vector(x / 2, y / 2 + gap), vector(x / 2 + 1, y / 2 + gap + length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
            render.gradient(vector(x / 2, y / 2 - gap), vector(x / 2 + 1, y / 2 - gap - length), scopeColor_x, scopeColor_x, scopeColor_y, scopeColor_y)
        elseif menu.anti_aim.visuals.customscope.scopetype:get() == "Reversed" then
            render.gradient(vector(x / 2 - gap - length, y / 2 + 1 ), vector(x / 2 - gap, y / 2), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
            render.gradient(vector(x / 2 + gap + length, y / 2 + 1 ), vector(x / 2 + gap, y / 2), scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
            render.gradient(vector(x / 2 + 1, y / 2 + gap + length), vector(x / 2, y / 2 + gap),scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
            render.gradient(vector(x / 2 + 1, y / 2 - gap - length), vector(x / 2, y / 2 - gap),scopeColor_x, scopeColor_y, scopeColor_x, scopeColor_y)
        end
    else
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):set("Remove Overlay")
    end
end
-- Scope end

--velocity ind

-- aspectratio
local aspect = function()
    local aspect_value = menu.anti_aim.visuals.aspect_ratio.aspect_ratio_value:get() / 100

    if not menu.anti_aim.visuals.aspect_ratio:get() then
        aspect_value = 0
    end

    if aspect_value ~= cvar.r_aspectratio.float(cvar.r_aspectratio) then
        cvar.r_aspectratio.float(cvar.r_aspectratio, aspect_value)
    end
end

menu.anti_aim.visuals.aspect_ratio:set_callback(function(ref)
	local enabled = ref:get()
	if enabled then
		cvar.r_aspectratio:float(menu.anti_aim.visuals.aspect_ratio.aspect_ratio_value:get()/10)
	else
		cvar.r_aspectratio:float(0)
	end
end)

menu.anti_aim.visuals.aspect_ratio.aspect_ratio_value:set_callback(function(ref)
	local enabled = menu.anti_aim.visuals.aspect_ratio:get()
	if enabled then
		cvar.r_aspectratio:float(ref:get()/10)
	end
end)

events.shutdown:set(function()
    cvar.r_aspectratio:float(0)
end)
-- aspectratio end

-- viewmodel
events.createmove:set(function()
    if menu.anti_aim.visuals.viewmodel:get() then
        cvar.viewmodel_fov:int(menu.anti_aim.visuals.viewmodel.viewmodel_fov:get(), true)
        cvar.viewmodel_offset_x:float(menu.anti_aim.visuals.viewmodel.viewmodel_x:get(), true)
        cvar.viewmodel_offset_y:float(menu.anti_aim.visuals.viewmodel.viewmodel_y:get(), true)
        cvar.viewmodel_offset_z:float(menu.anti_aim.visuals.viewmodel.viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
    if menu.anti_aim.visuals.viewmodel:get() and menu.anti_aim.visuals.viewmodel.change_hand_on_knife:get() then
        cvar.viewmodel_fov:int(menu.anti_aim.visuals.viewmodel.viewmodel_fov:get(), true)
        cvar.viewmodel_offset_x:float(menu.anti_aim.visuals.viewmodel.viewmodel_x:get(), true)
        cvar.viewmodel_offset_y:float(menu.anti_aim.visuals.viewmodel.viewmodel_y:get(), true)
        cvar.viewmodel_offset_z:float(menu.anti_aim.visuals.viewmodel.viewmodel_z:get(), true)
        if entity_get_local_player():get_player_weapon():get_classname() == "CKnife" then
            utils.console_exec("cl_righthand 0")
        else
            utils.console_exec("cl_righthand 1")
        end
    else
        utils.console_exec("cl_righthand 1")
    end
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)

-- config system

local JSON = panorama.loadstring([[
    return {
        stringify: JSON.stringify,
        parse: JSON.parse
    };
]])()

-- cfg
local cfg_data = {
    ints = {
        aa_builder_main[1].yaw,
        aa_builder_main[1].yaw_offset,
        aa_builder_main[1].yaw_offset_left,
        aa_builder_main[1].yaw_offset_right,
        aa_builder_main[1].yaw_delay_left,
        aa_builder_main[1].yaw_delay_right,
        aa_builder_main[1].delay_ticks_slider,
        aa_builder_main[1].yaw_mod,
        aa_builder_main[1].yaw_mod_offset,
        aa_builder_main[1].enable_body_yaw,
        aa_builder_main[1].enable_body_yaw.inverter2,
        aa_builder_main[1].enable_body_yaw.left_limit,
        aa_builder_main[1].enable_body_yaw.right_limit,
        aa_builder_main[1].enable_body_yaw.options2,
        --aa_builder_main[1].hs_type,
        aa_builder_main[1].defensive_aa_enabled,
        aa_builder_main[1].defensive_aa_pitch,
        aa_builder_main[1].defensive_aa_pitch_switch_first_value,
        aa_builder_main[1].defensive_aa_pitch_switch_second_value,
        aa_builder_main[1].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[1].defensive_aa_pitch_random_first_value,
        aa_builder_main[1].defensive_aa_pitch_random_second_value,
        aa_builder_main[1].defensive_aa_pitch_value,
        aa_builder_main[1].defensive_aa_yaw,
        aa_builder_main[1].defensive_aa_yaw_switch_first_value,
        aa_builder_main[1].defensive_aa_yaw_switch_second_value,
        aa_builder_main[1].defensive_aa_yaw_default,
        aa_builder_main[1].defensive_aa_yaw_random_first_value,
        aa_builder_main[1].defensive_aa_yaw_random_second_value,
        aa_builder_main[1].defensive_aa_yaw_spin_range,
        aa_builder_main[1].defensive_aa_yaw_spin_speed,
        aa_builder_main[1].defensive_aa_pitch_spin_range,
        aa_builder_main[1].defensive_aa_enabled.force_on,
        aa_builder_main[1].defensive_aa_enabled.addi,
        aa_builder_main[1].enable_body_yaw.jitter_delay,
        aa_builder_main[2].yaw,
        aa_builder_main[2].yaw_offset,
        aa_builder_main[2].yaw_offset_left,
        aa_builder_main[2].yaw_offset_right,
        aa_builder_main[2].yaw_delay_left,
        aa_builder_main[2].yaw_delay_right,
        aa_builder_main[2].delay_ticks_slider,
        aa_builder_main[2].yaw_mod,
        aa_builder_main[2].yaw_mod_offset,
        aa_builder_main[2].enable_body_yaw,
        aa_builder_main[2].enable_body_yaw.inverter2,
        aa_builder_main[2].enable_body_yaw.left_limit,
        aa_builder_main[2].enable_body_yaw.right_limit,
        aa_builder_main[2].enable_body_yaw.options2,
        aa_builder_main[2].defensive_aa_enabled,
        aa_builder_main[2].defensive_aa_pitch,
        aa_builder_main[2].defensive_aa_pitch_switch_first_value,
        aa_builder_main[2].defensive_aa_pitch_switch_second_value,
        aa_builder_main[2].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[2].defensive_aa_pitch_random_first_value,
        aa_builder_main[2].defensive_aa_pitch_random_second_value,
        aa_builder_main[2].defensive_aa_pitch_value,
        aa_builder_main[2].defensive_aa_yaw,
        aa_builder_main[2].defensive_aa_yaw_switch_first_value,
        aa_builder_main[2].defensive_aa_yaw_switch_second_value,
        aa_builder_main[2].defensive_aa_yaw_default,
        aa_builder_main[2].defensive_aa_yaw_random_first_value,
        aa_builder_main[2].defensive_aa_yaw_random_second_value,
        aa_builder_main[2].defensive_aa_yaw_spin_range,
        aa_builder_main[2].defensive_aa_yaw_spin_speed,
        aa_builder_main[2].defensive_aa_pitch_spin_range,
        aa_builder_main[2].defensive_aa_enabled.force_on,
        aa_builder_main[2].defensive_aa_enabled.addi,
        aa_builder_main[2].enable_body_yaw.jitter_delay,
        aa_builder_main[3].yaw,
        aa_builder_main[3].yaw_offset,
        aa_builder_main[3].yaw_offset_left,
        aa_builder_main[3].yaw_offset_right,
        aa_builder_main[3].yaw_delay_left,
        aa_builder_main[3].yaw_delay_right,
        aa_builder_main[3].delay_ticks_slider,
        aa_builder_main[3].yaw_mod,
        aa_builder_main[3].yaw_mod_offset,
        aa_builder_main[3].enable_body_yaw,
        aa_builder_main[3].enable_body_yaw.inverter2,
        aa_builder_main[3].enable_body_yaw.left_limit,
        aa_builder_main[3].enable_body_yaw.right_limit,
        aa_builder_main[3].enable_body_yaw.options2,
        --aa_builder_main[3].hs_type,
        aa_builder_main[3].defensive_aa_enabled,
        aa_builder_main[3].defensive_aa_pitch,
        aa_builder_main[3].defensive_aa_pitch_switch_first_value,
        aa_builder_main[3].defensive_aa_pitch_switch_second_value,
        aa_builder_main[3].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[3].defensive_aa_pitch_random_first_value,
        aa_builder_main[3].defensive_aa_pitch_random_second_value,
        aa_builder_main[3].defensive_aa_pitch_value,
        aa_builder_main[3].defensive_aa_yaw,
        aa_builder_main[3].defensive_aa_yaw_switch_first_value,
        aa_builder_main[3].defensive_aa_yaw_switch_second_value,
        aa_builder_main[3].defensive_aa_yaw_default,
        aa_builder_main[3].defensive_aa_yaw_random_first_value,
        aa_builder_main[3].defensive_aa_yaw_random_second_value,
        aa_builder_main[3].defensive_aa_yaw_spin_range,
        aa_builder_main[3].defensive_aa_yaw_spin_speed,
        aa_builder_main[3].defensive_aa_pitch_spin_range,
        aa_builder_main[3].defensive_aa_enabled.force_on,
        aa_builder_main[3].defensive_aa_enabled.addi,
        aa_builder_main[3].enable_body_yaw.jitter_delay,
        aa_builder_main[4].yaw,
        aa_builder_main[4].yaw_offset,
        aa_builder_main[4].yaw_offset_left,
        aa_builder_main[4].yaw_offset_right,
        aa_builder_main[4].yaw_delay_left,
        aa_builder_main[4].yaw_delay_right,
        aa_builder_main[4].delay_ticks_slider,
        aa_builder_main[4].yaw_mod,
        aa_builder_main[4].yaw_mod_offset,
        aa_builder_main[4].enable_body_yaw,
        aa_builder_main[4].enable_body_yaw.inverter2,
        aa_builder_main[4].enable_body_yaw.left_limit,
        aa_builder_main[4].enable_body_yaw.right_limit,
        aa_builder_main[4].enable_body_yaw.options2,
        --aa_builder_main[4].hs_type,
        aa_builder_main[4].defensive_aa_enabled,
        aa_builder_main[4].defensive_aa_pitch,
        aa_builder_main[4].defensive_aa_pitch_switch_first_value,
        aa_builder_main[4].defensive_aa_pitch_switch_second_value,
        aa_builder_main[4].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[4].defensive_aa_pitch_random_first_value,
        aa_builder_main[4].defensive_aa_pitch_random_second_value,
        aa_builder_main[4].defensive_aa_pitch_value,
        aa_builder_main[4].defensive_aa_yaw,
        aa_builder_main[4].defensive_aa_yaw_switch_first_value,
        aa_builder_main[4].defensive_aa_yaw_switch_second_value,
        aa_builder_main[4].defensive_aa_yaw_default,
        aa_builder_main[4].defensive_aa_yaw_random_first_value,
        aa_builder_main[4].defensive_aa_yaw_random_second_value,
        aa_builder_main[4].defensive_aa_yaw_spin_range,
        aa_builder_main[4].defensive_aa_yaw_spin_speed,
        aa_builder_main[4].defensive_aa_pitch_spin_range,
        aa_builder_main[4].defensive_aa_enabled.force_on,
        aa_builder_main[4].defensive_aa_enabled.addi,
        aa_builder_main[4].enable_body_yaw.jitter_delay,
        aa_builder_main[5].yaw,
        aa_builder_main[5].yaw_offset,
        aa_builder_main[5].yaw_offset_left,
        aa_builder_main[5].yaw_offset_right,
        aa_builder_main[5].yaw_delay_left,
        aa_builder_main[5].yaw_delay_right,
        aa_builder_main[5].delay_ticks_slider,
        aa_builder_main[5].yaw_mod,
        aa_builder_main[5].yaw_mod_offset,
        aa_builder_main[5].enable_body_yaw,
        aa_builder_main[5].enable_body_yaw.inverter2,
        aa_builder_main[5].enable_body_yaw.left_limit,
        aa_builder_main[5].enable_body_yaw.right_limit,
        aa_builder_main[5].enable_body_yaw.options2,
        --aa_builder_main[5].hs_type,
        aa_builder_main[5].defensive_aa_enabled,
        aa_builder_main[5].defensive_aa_pitch,
        aa_builder_main[5].defensive_aa_pitch_switch_first_value,
        aa_builder_main[5].defensive_aa_pitch_switch_second_value,
        aa_builder_main[6].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[5].defensive_aa_pitch_random_first_value,
        aa_builder_main[5].defensive_aa_pitch_random_second_value,
        aa_builder_main[5].defensive_aa_pitch_value,
        aa_builder_main[5].defensive_aa_yaw,
        aa_builder_main[5].defensive_aa_yaw_switch_first_value,
        aa_builder_main[5].defensive_aa_yaw_switch_second_value,
        aa_builder_main[5].defensive_aa_yaw_default,
        aa_builder_main[5].defensive_aa_yaw_random_first_value,
        aa_builder_main[5].defensive_aa_yaw_random_second_value,
        aa_builder_main[5].defensive_aa_yaw_spin_range,
        aa_builder_main[5].defensive_aa_yaw_spin_speed,
        aa_builder_main[5].defensive_aa_pitch_spin_range,
        aa_builder_main[5].defensive_aa_enabled.force_on,
        aa_builder_main[5].defensive_aa_enabled.addi,
        aa_builder_main[5].enable_body_yaw.jitter_delay,
        aa_builder_main[6].yaw,
        aa_builder_main[6].yaw_offset,
        aa_builder_main[6].yaw_offset_left,
        aa_builder_main[6].yaw_offset_right,
        aa_builder_main[6].yaw_delay_left,
        aa_builder_main[6].yaw_delay_right,
        aa_builder_main[6].delay_ticks_slider,
        aa_builder_main[6].yaw_mod,
        aa_builder_main[6].yaw_mod_offset,
        aa_builder_main[6].enable_body_yaw,
        aa_builder_main[6].enable_body_yaw.inverter2,
        aa_builder_main[6].enable_body_yaw.left_limit,
        aa_builder_main[6].enable_body_yaw.right_limit,
        aa_builder_main[6].enable_body_yaw.options2,
        --aa_builder_main[6].hs_type,
        aa_builder_main[6].defensive_aa_enabled,
        aa_builder_main[6].defensive_aa_pitch,
        aa_builder_main[6].defensive_aa_pitch_switch_first_value,
        aa_builder_main[6].defensive_aa_pitch_switch_second_value,
        aa_builder_main[6].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[6].defensive_aa_pitch_random_first_value,
        aa_builder_main[6].defensive_aa_pitch_random_second_value,
        aa_builder_main[6].defensive_aa_pitch_value,
        aa_builder_main[6].defensive_aa_yaw,
        aa_builder_main[6].defensive_aa_yaw_switch_first_value,
        aa_builder_main[6].defensive_aa_yaw_switch_second_value,
        aa_builder_main[6].defensive_aa_yaw_default,
        aa_builder_main[6].defensive_aa_yaw_random_first_value,
        aa_builder_main[6].defensive_aa_yaw_random_second_value,
        aa_builder_main[6].defensive_aa_yaw_spin_range,
        aa_builder_main[6].defensive_aa_yaw_spin_speed,
        aa_builder_main[6].defensive_aa_pitch_spin_range,
        aa_builder_main[6].defensive_aa_enabled.force_on,
        aa_builder_main[6].defensive_aa_enabled.addi,
        aa_builder_main[6].enable_body_yaw.jitter_delay,
        aa_builder_main[7].yaw,
        aa_builder_main[7].yaw_offset,
        aa_builder_main[7].yaw_offset_left,
        aa_builder_main[7].yaw_offset_right,
        aa_builder_main[7].yaw_delay_left,
        aa_builder_main[7].yaw_delay_right,
        aa_builder_main[7].delay_ticks_slider,
        aa_builder_main[7].yaw_mod,
        aa_builder_main[7].yaw_mod_offset,
        aa_builder_main[7].enable_body_yaw,
        aa_builder_main[7].enable_body_yaw.inverter2,
        aa_builder_main[7].enable_body_yaw.left_limit,
        aa_builder_main[7].enable_body_yaw.right_limit,
        aa_builder_main[7].enable_body_yaw.options2,
        --aa_builder_main[7].hs_type,
        aa_builder_main[7].defensive_aa_enabled,
        aa_builder_main[7].defensive_aa_pitch,
        aa_builder_main[7].defensive_aa_pitch_switch_first_value,
        aa_builder_main[7].defensive_aa_pitch_switch_second_value,
        aa_builder_main[7].defensive_aa_pitch_switch_speed_value,
        aa_builder_main[7].defensive_aa_pitch_random_first_value,
        aa_builder_main[7].defensive_aa_pitch_random_second_value,
        aa_builder_main[7].defensive_aa_pitch_value,
        aa_builder_main[7].defensive_aa_yaw,
        aa_builder_main[7].defensive_aa_yaw_switch_first_value,
        aa_builder_main[7].defensive_aa_yaw_switch_second_value,
        aa_builder_main[7].defensive_aa_yaw_default,
        aa_builder_main[7].defensive_aa_yaw_random_first_value,
        aa_builder_main[7].defensive_aa_yaw_random_second_value,
        aa_builder_main[7].defensive_aa_yaw_spin_range,
        aa_builder_main[7].defensive_aa_yaw_spin_speed,
        aa_builder_main[7].defensive_aa_pitch_spin_range,
        aa_builder_main[7].defensive_aa_enabled.force_on,
        aa_builder_main[7].defensive_aa_enabled.addi,
        aa_builder_main[7].enable_body_yaw.jitter_delay,
        --other
        menu.anti_aim.tweaks.avoid_backstab,
        menu.anti_aim.tweaks.safe_head_knife,
        menu.anti_aim.tweaks.safe_head_knife.safe_head_knife_e,
        menu.anti_aim.visuals.grenades.fix,
        menu.anti_aim.visuals.grenades.toss,
        menu.anti_aim.visuals.aspect_ratio,
        menu.anti_aim.visuals.aspect_ratio.aspect_ratio_value,
        menu.anti_aim.visuals.fps_boost,
        menu.anti_aim.visuals.viewmodel,
        menu.anti_aim.visuals.viewmodel.viewmodel_fov,
        menu.anti_aim.visuals.viewmodel.viewmodel_x,
        menu.anti_aim.visuals.viewmodel.viewmodel_y,
        menu.anti_aim.visuals.viewmodel.viewmodel_z,
        menu.anti_aim.visuals.viewmodel.change_hand_on_knife,
        menu.anti_aim.visuals.customscope,
        menu.anti_aim.visuals.customscope.scopetype,
        menu.anti_aim.visuals.customscope.scopeGap,
        menu.anti_aim.visuals.customscope.scopeLength,
        menu.anti_aim.visuals.customscope.scopeColor,
        menu.anti_aim.visuals.aimlogs,
        menu.anti_aim.visuals.aimlogs.aimlogs_type,
        menu.anti_aim.visuals.clantag52,
        menu.anti_aim.visuals.auto_baim,
        menu.anti_aim.visuals.trash_talk,
        menu.anti_aim.visuals.trash_talk.say_on_death,
        menu.anti_aim.visuals.legs_jitter,
        menu.anti_aim.visuals.legs_jitter.air_combo,
        menu.anti_aim.visuals.legs_jitter.jitter_combo,
        menu.anti_aim.visuals.legs_jitter.slider_jitter,
        menu.anti_aim.visuals.legs_jitter.other_combo,
        menu.anti_aim.visuals.legs_jitter.walk_combo,
        menu.anti_aim.tweaks.randomize_warmup,
        menu.anti_aim.visuals.air_exploit.air_exploit_delay,
        menu.anti_aim.visuals.auto_teleport.auto_teleport_delay,
        menu.anti_aim.visuals.air_exploit,
        menu.anti_aim.visuals.auto_teleport,
        menu.anti_aim.private.watermark,
        menu.anti_aim.private.watermark.watermark_type,
        menu.anti_aim.tweaks.fastladder,
        menu.anti_aim.visuals.damage_ind,
    },
}

function cfg(cfg2)
    if cfg2 then
    for k, v in pairs(JSON.parse(cfg2)) do

        k = ({[1] = "bools", [2] = "ints"})[k]

        for k2, v2 in pairs(v) do
            if (k == "bools") then
                cfg_data[k][k2]:set(v2)
            end

            if (k == "ints") then
                cfg_data[k][k2]:set(v2)
            end
        end
    end
end
end




exporttcp = tabs.anti_aim.config:button("\f<file-export> Export ", function()
    local config = libs.pui.save()
    libs.clipboard.set(libs.base64.encode(JSON.stringify(config)))
    common.add_notify("moriade #white","successfully exported config to clipboard")
end)

importfcp = tabs.anti_aim.config:button("\f<file-import> Import ", function()
    local decrypted = JSON.parse(libs.base64.decode(libs.clipboard.get()))
    local config = libs.pui.load(decrypted)
    cfg(config)
    common.add_notify("moriade #white","successfully imported config from clipboard")
end)

defaultpreset = tabs.anti_aim.config:button("\f<loader> Default ", function()
    local decrypted = JSON.parse(libs.base64.decode(DEFAULT_CONFIG))
    local default = libs.pui.load(decrypted)
    cfg(default)
    common.add_notify("moriade #white","successfully loaded default config")
end)



loadcfg = tabs.anti_aim.config:button("\f<file-arrow-up> Load ", function()
    local config = db.configs[menu.anti_aim.config.config_id:get()][1]
    local decrypted = JSON.parse(libs.base64.decode(config))
    local config_tl = libs.pui.load(decrypted)
    cfg(config_tl)
    common.add_notify("moriade #white","successfully loaded config  " .. "\aFFFFF0FF" .. db.configs[menu.anti_aim.config.config_id:get()][2])
end)

overwritecfg = tabs.anti_aim.config:button("\f<user-pen> Save ", function()
    local config = libs.pui.save()
    config = libs.base64.encode(JSON.stringify(config))
    local configs = db.configs
    configs[menu.anti_aim.config.config_id:get()][1] = config
    db.configs = configs
    common.add_notify("moriade #white","successfully overwrited config  " .. "\aFFFFF0FF" .. configs[menu.anti_aim.config.config_id:get()][2])
end)


deletecfg = tabs.anti_aim.config:button("\f<trash-can> Remove ", function()
    local configs = db.configs
    local config_removed = table.remove(configs,menu.anti_aim.config.config_id:get())
    table.remove(cfgs,menu.anti_aim.config.config_id:get())
    menu.anti_aim.config.config_id:update(cfgs)
    db.configs = configs
    common.add_notify("moriade #white","successfully removed config  " .. "\aFFFFF0FF" .. config_removed[2])
end)

savecfg = tabs.anti_aim.config:button("\f<circle-plus> Create ", function()
    menu.anti_aim.config.config_name:visibility(true)
    savecfg_1 = savecfg_1 + 1
    if savecfg_1 == 2 then
        local config = libs.pui.save()
        config = libs.base64.encode(JSON.stringify(config))
        local configs = db.configs
        table.insert(configs,{config,menu.anti_aim.config.config_name:get()})
        table.insert(cfgs,menu.anti_aim.config.config_name:get())
        db.configs = configs
        menu.anti_aim.config.config_id:update(cfgs)
        menu.anti_aim.config.config_name:visibility(false)
        savecfg_1 = 0
        common.add_notify("moriade #white","successfully saved config  " .. "\aFFFFF0FF" .. menu.anti_aim.config.config_name:get())
        menu.anti_aim.config.config_name:set("")
    end
end)



ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder; //0x0014
        int m_nSequence; //0x0018
        float m_flPrevCycle; //0x001C
        float m_flWeight; //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate; //0x0028
        float m_flCycle; //0x002C
        void *m_pOwner; //0x0030
        char  pad_0038[4]; //0x0034
    } animstate_layer_t;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animslsg = nil
local this_call = function(call_function, parameters)
    return function(...)
        return call_function(parameters, ...)
    end
end

local entity_list_003 = ffi.cast(uintptr_t, utils.create_interface("client.dll", "VClientEntityList003"))
local get_entity_address = this_call(ffi.cast("get_client_entity_t", entity_list_003[0][3]), entity_list_003)

local hooked_function = nil
local inside_updateCSA = function(thisptr, edx)
    hooked_function(thisptr, edx)
    local localplayer = entity.get_local_player()
    local move = math.sqrt(localplayer.m_vecVelocity.x ^ 2 + localplayer.m_vecVelocity.y ^ 2) > 5
    local jump = bit.band(localplayer.m_fFlags, 1) == 0
    animslsg = get_entity_address(localplayer:get_index())
    if menu.anti_aim.visuals.legs_jitter:get() then
        if menu.anti_aim.visuals.legs_jitter.air_combo:get() == "Static" and jump then
            localplayer.m_flPoseParameter[6] = 1
        elseif menu.anti_aim.visuals.legs_jitter.air_combo:get() == "Kangaroo" and jump then
            localplayer.m_flPoseParameter[6] = math.random(0, 1)
        elseif menu.anti_aim.visuals.legs_jitter.air_combo:get() == "Walking" and jump then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        end
        if menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Flex" then
            refs.legs:override("Walking")
            localplayer.m_flPoseParameter[7] = utils.random_float(0.5, 1)
        elseif menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Walking" then
            refs.legs:override("Walking")
            localplayer.m_flPoseParameter[7] = 1
        elseif menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Static" then
            refs.legs:override("Sliding")
            localplayer.m_flPoseParameter[0] = 0
        elseif menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Fast Jitter" then
            refs.legs:override("Sliding")
            localplayer.m_flPoseParameter[0] = utils.random_float(0, 1)
        elseif menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Slow Jitter" then
            refs.legs:override("Sliding")
            localplayer.m_flPoseParameter[0] = globals.tickcount % 4 > 1 and menu.anti_aim.visuals.legs_jitter.slider_jitter:get()/100 or 1
        end
        if menu.anti_aim.visuals.legs_jitter.walk_combo:get() == "Jitter" then
            localplayer.m_flPoseParameter[9] = utils.random_float(0.0, 1.0)
        elseif menu.anti_aim.visuals.legs_jitter.walk_combo:get() == "Static" then
            localplayer.m_flPoseParameter[9] = 0
        elseif menu.anti_aim.visuals.legs_jitter.walk_combo:get() == "Pirat" then
            localplayer.m_flPoseParameter[9] = 0.4
        end
        if menu.anti_aim.visuals.legs_jitter.other_combo:get("Earthquake") then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = utils.random_float(0.0, 1.0)
        elseif menu.anti_aim.visuals.legs_jitter.other_combo:get("Move Lean") and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = 1
        end
    end
end

local update_hook = function()
    local self = entity.get_local_player()
    if not self or not self:is_alive() then
        return
    end

    local self_index = self:get_index()
    local self_address = get_entity_address(self_index)

    if not self_address or hooked_function then
        return
    end

    local new_point = library.new(self_address)
    hooked_function = new_point.hook("void(__fastcall*)(void*, void*)", inside_updateCSA, 224)
end

-- legs

--rageboba
local function auto_baim()
if menu.anti_aim.visuals.auto_baim:get() then
    local lp = entity.get_local_player()
    local weapon = lp:get_player_weapon()
    local weapon_id = weapon:get_weapon_index()

    if not lp or not lp:is_alive() then
        return
    end

    if weapon == nil or false then
        return
    end

    threat = entity.get_threat()
    if not threat then
        return
    end

    if weapon_id == 40 then
        hp = threat.m_iHealth

        if hp <= 90 and hp > 0 then
            refs.isBody:override("Force")
        elseif hp > 90 then
            refs.isBody:override("prefer")
            end
        end
    end
end
-- Aimbot logs
local f, rep = string.format, string.rep;
local logger = {};

logger.id = 0;
logger.hitgroup = {
    [ 0 ] = 'generic',
    'head',
    'chest',
    'stomach',
    'left arm',
    'right arm',
    'left leg',
    'right leg',
    'neck',
    '?',
    'gear'
};



local LtextXpos = render.screen_size().x/2-105 -- offset
local LrectXpos = render.screen_size().x/2-120 -- auto align
local LtextYposoffset = 9
local LrectHeight = 25
local LtextOffset = 5
local LmaxPos = 300
local LrectYpos = 240

local icon_hit = ui.get_icon "circle-check" -- Pater noster, qui es in caelis, sanctificetur nomen Tuum. Adveniat regnum Tuum. Fiat voluntas Tua, sicut in caelo et in terra. Panem nostrum quotidianum da nobis hodie, et dimitte nobis debita nostra sicut et nos dimittimus debitoribus nostris. Et ne nos inducas in tentationem, sed libera nos a malo. Quoniam Tuum est regnum et virtus et gloria in saecula. Amen.
local icon_miss = ui.get_icon "circle-xmark" -- !

local LMAX_LOGS = 9 --max logs to be shown




local function logs_processing(e)
    if menu.anti_aim.visuals.aimlogs.aimlogs_type:get("On screen") and menu.anti_aim.visuals.aimlogs:get() then
    local newLog = {
        event = e,
        log = {
            current_y = 900,
            target_y = 880 - ((#attacked < LMAX_LOGS and #attacked or LMAX_LOGS) * 30),
            alpha = 255,
            moving_up = true,
        }
    }

    if #attacked < LMAX_LOGS then
        table.insert(attacked, newLog)
    else
        attacked[LnextIndex] = newLog
        LnextIndex = LnextIndex % LMAX_LOGS + 1
    end
end
end


local function logs_render()
    if menu.anti_aim.visuals.aimlogs.aimlogs_type:get("On screen") and menu.anti_aim.visuals.aimlogs:get() then
    for i = #attacked, 1, -1 do
        local attack = attacked[i]
        if attack then
            local log = attack.log
            log.current_y = lerpik(log.current_y, log.target_y, 0.05)

            local target_name = attack.event.target and attack.event.target:get_name()
            local damage = attack.event.damage or 0
            local wanted_damage = attack.event.wanted_damage or 0
            local hitgroup = logger.hitgroup[attack.event.hitgroup]
            local backtrack = attack.event.backtrack or 0
            if not attack.event.state and  attack then
                local Ltxtoff = 0
                if string.len(tostring(backtrack)) > 1 then
                    Ltxtoff = string.len(tostring(backtrack))
                else
                    Ltxtoff = 0
                end
                local LtxtSizeHit = render.measure_text(1, "", "  hit " .. target_name .. " for " .. damage .. " in: " .. hitgroup .. " (".."exp: " .. wanted_damage .. " bt: " .. backtrack ..")")
                local Lrect_startHit = vector(LrectXpos - LtxtSizeHit.x/2  + 100, log.current_y)
                local Lrect_endHit = vector(LrectXpos + LrectYpos + LtxtSizeHit.x/2 - 110, log.current_y + LrectHeight)
                render.rect(Lrect_startHit, Lrect_endHit, color(15, 15, 15, log.alpha), 10)
    
                local LtextPosHit = vector(LtextXpos - LtxtSizeHit.x/2 + 103 + Ltxtoff, log.current_y + LtextOffset)
                local LtextPosHitI = vector(LtextXpos - LtxtSizeHit.x/2 + 96 + Ltxtoff, log.current_y + LtextOffset)
                render.text(
                    1,
                    LtextPosHitI,
                    color(55, 120, 55, log.alpha),
                    nil,
                    icon_hit
                )
                render.text(
                    1,
                    LtextPosHit,
                    color(175, 175, 175, log.alpha),
                    nil,
                    "  hit " .. target_name .. " for " .. damage .. " in: " .. hitgroup .. " (".."exp: " .. wanted_damage .. " bt: " .. backtrack ..")"
                )
            elseif attack then
                local state = attack.event.state or "unknown"
                local wanted_hitgroup = logger.hitgroup[attack.event.wanted_hitgroup] or "unknown"
                local Ltxtoff = 0
                if string.len(tostring(backtrack)) > 1 then
                    Ltxtoff = string.len(tostring(backtrack))
                else
                    Ltxtoff = 0
                end
                local LtxtSizeMiss = render.measure_text(1, "", "  missed " .. target_name .. " due to " .. state .. " in " .. wanted_hitgroup .. "!")
                local Lrect_startMiss = vector(LrectXpos - LtxtSizeMiss.x/2  + 100, log.current_y)
                local Lrect_endMiss = vector(LrectXpos + LrectYpos + LtxtSizeMiss.x/2 - 110, log.current_y + LrectHeight)
                render.rect(Lrect_startMiss, Lrect_endMiss, color(15, 15, 15, log.alpha), 10)
    
                local LtextPosMissI = vector(LtextXpos - LtxtSizeMiss.x/2 + 96 + Ltxtoff, log.current_y + LtextOffset)
                local LtextPosMiss = vector(LtextXpos - LtxtSizeMiss.x/2 + 103 + Ltxtoff, log.current_y + LtextOffset)
                render.text(
                    1,
                    LtextPosMissI,
                    color(200, 55, 55, log.alpha),
                    nil,
                    icon_miss
                )
                render.text(
                    1,
                    LtextPosMiss,
                    color(175, 175, 175, log.alpha),
                    nil,
                    "  missed " ..
                        target_name ..
                        " due to " .. state .. " in " .. wanted_hitgroup .. "!"
                )
                
            end

            log.alpha = log.alpha - 1.5
            if log.alpha <= 0 then
                table.remove(attacked, i)
                if LnextIndex > i then
                    LnextIndex = LnextIndex - 1
                end
            end
        end
    end
end
end




logger.state = {
    [ 'correction' ] = 'resolver',
    [ 'player death' ] = 'enemy death',
    [ 'backtrack failure' ] = 'lagcomp failure'
};
logger.verb = {
    [ 'knife' ] = 'Knifed',
    [ 'inferno' ] = 'Burned',
    [ 'hegrenade' ] = 'Naded'
};
logger.bell_pattern = f('\\a%s', rep('%%X', 6));
logger.remove_bell = function(s)
    return s:gsub(logger.bell_pattern, '')
end
logger.get_id = function()
    return logger.id % (1000 + 1)
end
logger.miss = function(e)
    local state = logger.state[ e.state ] or e.state;
    if menu.anti_aim.visuals.aimlogs.aimlogs_type:get("Console") and menu.anti_aim.visuals.aimlogs:get() then
        print_dev((
            "moriade ● missed \ad6b9a55 " .. e.target:get_name() .. " \ad2d6d22 due to \ad6b9a55 " .. state .. " \ad2d6d22 in \ad6b9a55 " .. logger.hitgroup[ e.wanted_hitgroup ] .. " \ad2d6d22 bt: \ad6b9a55 " .. e.backtrack .. " \ad2d6d22"
        ));

        print_raw((
            "moriade ● missed \ad6b9a55 " .. e.target:get_name() .. " \ad2d6d22 due to \ad6b9a55 " .. state .. " \ad2d6d22 in \ad6b9a55 " .. logger.hitgroup[ e.wanted_hitgroup ] .. " \ad2d6d22 bt: \ad6b9a55 " .. e.backtrack .. " \ad2d6d22"
        ));
    end
end
logger.hit = function(e)
    if menu.anti_aim.visuals.aimlogs.aimlogs_type:get("Console") and menu.anti_aim.visuals.aimlogs:get() then
        print_dev((
           "moriade ● hit \acad6a55 " .. e.target:get_name() .. " \ad2d6d22 for \acad6a55 " ..  e.damage .. " \ad2d6d22 in: \acad6a55 " ..  logger.hitgroup[ e.hitgroup ] .. " \ad2d6d22 (".."exp: \acad6a55 " .. e.wanted_damage .. " \ad2d6d22 bt: \acad6a55 " .. e.backtrack .."\ad2d6d22 )"
        ));
    
        print_raw((
            "moriade ● hit \acad6a55 " .. e.target:get_name() .. " \ad2d6d22 for \acad6a55 " ..  e.damage .. " \ad2d6d22 in: \acad6a55 " ..  logger.hitgroup[ e.hitgroup ] .. " \ad2d6d22 (".."exp: \acad6a55 " .. e.wanted_damage .. " \ad2d6d22 bt: \acad6a55 " .. e.backtrack .."\ad2d6d22 )"
        ));
    end
end
logger.player_hurt = function(e)
    local lp = entity.get_local_player();
    local userid = entity.get(e.userid, true);
    local attacker = entity.get(e.attacker, true);

    if attacker ~= lp or userid == lp then
        return
    end

    local verb = logger.verb[ e.weapon ];

    if verb == nil then
        return
    end
    if menu.anti_aim.visuals.aimlogs.aimlogs_type:get("Console") and menu.anti_aim.visuals.aimlogs:get() then
        print_dev(f(
            '\acad6a55 %s %s \ad2d6d22 for \acad6a55 %d \ad2d6d22 damage (\acad6a55 %d \ad2d6d22 hp remaining)',
            verb, userid:get_name(), e.dmg_health, e.health
        ));
    
        print_raw(f(
            '\acad6a55 %s %s \ad2d6d22 for \acad6a55 %d \ad2d6d22 damage (\acad6a55 %d \ad2d6d22 hp remaining)',
            verb, userid:get_name(), e.dmg_health, e.health
        ));
    end
end
events.player_connect_full:set(function(e)
    local lp = entity.get_local_player();
    local userid = entity.get(e.userid, true);

    if lp ~= userid then
        return
    end

    logger.id = -1;
end)
events.aim_fire:set(function(e)
    logger.id = logger.id + 1;
end);
events.aim_ack:set(function(e)
    if not entity.get_local_player() or not globals.is_in_game then
        return end
    logs_processing(e);
    (e.state and logger.miss or logger.hit)(e);
end);
events.player_hurt:set(logger.player_hurt);
-- visuals_visibility
set_visibility = function()
    menu.anti_aim.visuals.aspect_ratio.aspect_ratio_value:visibility(menu.anti_aim.visuals.aspect_ratio:get())
    menu.anti_aim.visuals.auto_teleport.auto_teleport_delay:visibility(menu.anti_aim.visuals.auto_teleport:get())
    menu.anti_aim.visuals.air_exploit.air_exploit_delay:visibility(menu.anti_aim.visuals.air_exploit:get())
    menu.anti_aim.visuals.trash_talk:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    menu.anti_aim.visuals.ts:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.visuals.aspect_ratio:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.visuals.viewmodel:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.visuals.aimlogs:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    menu.anti_aim.visuals.auto_teleport:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 4)
    menu.anti_aim.visuals.air_exploit:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    menu.anti_aim.visuals.fps_boost:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.visuals.auto_baim:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 4)
    menu.anti_aim.visuals.legs_jitter:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    menu.anti_aim.visuals.legs_jitter.slider_jitter:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Slow Jitter" and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    menu.anti_aim.visuals.customscope:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.info.link_discord:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.info.link_youtube:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.info.link_config:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.img.img_u:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.info.welcome_username:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.info.welcome_build:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 1)
    menu.anti_aim.private.watermark:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.private.watermark.watermark_type:visibility(menu.anti_aim.private.watermark and menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.private.gs_ind:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.private.widgets:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
    menu.anti_aim.visuals.ts.accent_color:visibility(menu.anti_aim.visuals.ts:get() and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1 and menu.anti_aim.visuals.ts.ts_type:get() == "Adaptive")
    menu.anti_aim.visuals.ts.ts_cl1:visibility(menu.anti_aim.visuals.ts:get() and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1 and menu.anti_aim.visuals.ts.ts_type:get() == "TeamSkeet")
    menu.anti_aim.visuals.ts.ts_cl2:visibility(menu.anti_aim.visuals.ts:get() and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1 and menu.anti_aim.visuals.ts.ts_type:get() == "TeamSkeet")
    
    menu.anti_aim.visuals.clantag52:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 2)
    -- gear
    menu.anti_aim.visuals.ts.ts_type:visibility(menu.anti_aim.visuals.ts:get())
    menu.anti_aim.visuals.customscope.scopetype:visibility(menu.anti_aim.visuals.customscope:get())
    menu.anti_aim.visuals.customscope.scopeGap:visibility(menu.anti_aim.visuals.customscope:get())
    menu.anti_aim.visuals.customscope.scopeLength:visibility(menu.anti_aim.visuals.customscope:get())
    menu.anti_aim.visuals.customscope.scopeColor:visibility(menu.anti_aim.visuals.customscope:get())
    menu.anti_aim.visuals.viewmodel.viewmodel_fov:visibility(menu.anti_aim.visuals.viewmodel:get())
    menu.anti_aim.visuals.viewmodel.viewmodel_x:visibility(menu.anti_aim.visuals.viewmodel:get())
    menu.anti_aim.visuals.viewmodel.viewmodel_y:visibility(menu.anti_aim.visuals.viewmodel:get())
    menu.anti_aim.visuals.viewmodel.viewmodel_z:visibility(menu.anti_aim.visuals.viewmodel:get())
    menu.anti_aim.visuals.viewmodel.change_hand_on_knife:visibility(menu.anti_aim.visuals.viewmodel:get())
    menu.anti_aim.visuals.trash_talk.say_on_death:visibility(menu.anti_aim.visuals.trash_talk:get())
    menu.anti_aim.visuals.aimlogs.aimlogs_type:visibility(menu.anti_aim.visuals.aimlogs:get())
    menu.anti_aim.visuals.legs_jitter.jitter_combo:visibility(menu.anti_aim.visuals.legs_jitter:get())
    menu.anti_aim.visuals.legs_jitter.slider_jitter:visibility(menu.anti_aim.visuals.legs_jitter:get() and menu.anti_aim.visuals.legs_jitter.jitter_combo:get() == "Slow Jitter")
    menu.anti_aim.visuals.legs_jitter.air_combo:visibility(menu.anti_aim.visuals.legs_jitter:get())
    menu.anti_aim.visuals.legs_jitter.walk_combo:visibility(menu.anti_aim.visuals.legs_jitter:get())
    menu.anti_aim.visuals.legs_jitter.other_combo:visibility(menu.anti_aim.visuals.legs_jitter:get())
    menu.anti_aim.tab_switch_aa.tab_switch_aa_2:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2)
    --menu.anti_aim.tab_switch_aa.tab_name:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2)
    menu.anti_aim.tab_switch_def.tab_switch_def_2:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 1)
    menu.anti_aim.tab_switch_misc.tab_switch_misc_2:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3)
    menu.anti_aim.visuals.grenades:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 4)
    menu.anti_aim.tweaks.avoid_backstab:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2)
    menu.anti_aim.tweaks.safe_head_knife:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2)
    menu.anti_aim.tweaks.safe_head_knife.safe_head_knife_e:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2 and menu.anti_aim.tweaks.safe_head_knife:get())
    menu.anti_aim.tweaks.fs_flick:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2)
    menu.anti_aim.tweaks.randomize_warmup:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2)
    menu.anti_aim.tweaks.fastladder:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 2 and menu.anti_aim.tab_switch_aa.tab_switch_aa_2:get() == 2)
    menu.anti_aim.visuals.damage_ind:visibility(menu.anti_aim.tab_switch.tab_switcher:get() == 3 and menu.anti_aim.tab_switch_misc.tab_switch_misc_2:get() == 1)
end
-- visuals_visibility end

--
--grenades
local function grenades()
    if menu.anti_aim.visuals.grenades.fix:get() then
        if entity.get_local_player() == nil then return end
        if entity.get_local_player():get_player_weapon() == nil then return end

        local weapon_index = entity.get_local_player():get_player_weapon():get_weapon_index()
        local is_grenade = weapon_index == 43 or weapon_index == 44 or weapon_index == 45 or weapon_index == 46 or weapon_index == 47 or weapon_index == 48

        if is_grenade then
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set({''})
        else
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(current)
        end
    end
end

local function toss()
    if menu.anti_aim.visuals.grenades.toss:get() then end
end
--warmup aa

local function warmup_aa()
    if menu.anti_aim.tweaks.randomize_warmup:get() then
        local players = entity.get_players(true)
        local local_player = entity.get_local_player()
        local alive_players_count = 0

        for i = 1, #players do
            local player = players[i]
            if player and player:is_alive() then
                alive_players_count = alive_players_count + 1
            end
        end

        if alive_players_count == 0 and local_player:is_alive() and menu.anti_aim.tweaks.randomize_warmup:get() then
            aa_refs.hidden_yaw:set(true)
            aa_refs.pitch:override("Disabled")
            aa_refs.yaw:override("Backward")
            aa_refs.yaw_offset:set(0)
            aa_refs.yaw_base:override("Local View")
            aa_refs.yaw_modifier:override("Spin")
            aa_refs.modifier_degree:override(360 * 10)
            aa_refs.body_yaw:override(menu.anti_aim.tweaks.fs_flick:get())
            aa_refs.options:override("")
            aa_refs.freestanding:override(false)
            aa_refs.hidden_yaw:override(false)
        else
            aa_refs.pitch:override("Down")
            aa_refs.yaw_base:override("At Target")
        end
    else
        aa_refs.pitch:override("Down")
        aa_refs.yaw_base:override("At Target")
    end
end

--dsadsad
local verdana = render.load_font("Verdana", 16, "ad")
local calibri_bold = render.load_font("Calibri", 24, "bad")

local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))

local function calc_dist(pos1, pos2)
    local lx = pos1.x
    local ly = pos1.y
    local lz = pos1.z
    local tx = pos2.x
    local ty = pos2.y
    local tz = pos2.z
    local dx = lx - tx
    local dy = ly - ty
    local dz = lz - tz
    return math.sqrt(dx * dx + dy * dy + dz * dz);
end

local hitted, reg_shot = 0, 0

local function render_indicators(text, colors, ind_dst, imgs)
    local ts = render.measure_text(calibri_bold, "bad", text)
    local x = 28
    local y = screen_y - 350
    --local ind_dst = ind_dst or 0
    
    if imgs then
        render.gradient(vector(5, y + 3 - ind_dst), vector(x + ((imgs.width) + (ts.x)) / 2 + 3, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
        render.gradient(vector(x + ((imgs.width) + (ts.x)) / 2 + 3, y + 3 - ind_dst), vector(x + (ts.x) + (imgs.width) + 29, y + 37 - ind_dst), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
        render.texture(imgs, vector(x, y + 6 - ind_dst), colors)
        render.text(calibri_bold, vector(x + (imgs.width) + 6, y + 10 - ind_dst), colors, "bad", text)
    else
        render.gradient(vector(5, y + 3 - ind_dst), vector(x + (ts.x) / 2, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50))
        render.gradient(vector(x + (ts.x) / 2, y + 3 - ind_dst + 0), vector(x + (ts.x) + 23, y + 37 - ind_dst), color(0, 0, 0, 50), color(0, 0, 0, 0), color(0, 0, 0, 50), color(0, 0, 0, 0))
        render.text(calibri_bold, vector(x, y + 4 - ind_dst + 5), colors, "bad", text)
    end
end

get_bind = function(name)
    local state = false
    local value = 0
    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].name == name and binds[i].active then
            state = true
            value = binds[i].value
        end
    end
    return {state, value}
end

--gs ind
local function gs_ind()
    if not globals.is_in_game then return end
    if menu.anti_aim.private.gs_ind:get() then
            local ind_dst = 0
            local ind_spr = 41

            local x = 28
            local y = screen_y - 350
        
            local percent = hitted > 0 and reg_shot > 0 and (hitted / reg_shot) * 100 or 0

            if find.ping:get() > 0 then
                render_indicators("PING", color(150, 189, 18, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.doubletap:get() then
                render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            elseif refs.hideshots:get() and not refs.doubletap:get()  then
                render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
            
            if refs.freestanding:get() or menu.anti_aim.condition.conditions.fs_aa:get() then
                render_indicators("FS", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.isBody:get() == "Force" then
                render_indicators("BODY", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if get_bind("Min. Damage")[1] then
                render_indicators("MD", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            if get_bind("Hit Chance")[1] then
                render_indicators("HITCHANCE OVR", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
                
            if refs.fakeduck:get() then
                render_indicators("DUCK", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
            if find.da:get() then
                if dormant_work then
                    render_indicators("DA", color(215, 215, 215, 255), ind_dst)
                else
                    render_indicators("DA", color(255, 0, 0, 255), ind_dst)
                end
                ind_dst = ind_dst + ind_spr
            end
        
            if refs.isSafe:get() == "Force" then
                render_indicators("SAFE", color(215, 215, 215, 255), ind_dst)
                ind_dst = ind_dst + ind_spr
            end
        
            local c4 = entity.get_entities("CPlantedC4")[1];
            if c4 ~= nil then
                local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
                local defused = c4.m_bBombDefused

                if math.floor(time) >= -1 and not defused then
                    local defusestart = c4.m_hBombDefuser ~= 4294967295
                    local defuselength = c4.m_flDefuseLength
                    local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1

                    if defusetimer > 0 and not abort_defuse then
                        local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                        local barlength = (((y - 50) / defuselength) * (defusetimer))
                        render.rect(vector(0, 0), vector(16, y), color(25, 25, 25, 160))
                        render.rect(vector(0, y - barlength), vector(16, y), col)
                    end

                    local lp = entity.get_local_player()
                    local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                    local health = lp.m_iHealth
                    local armor = lp.m_ArmorValue
                    local will_die = false
                    local eLoc = c4.m_vecOrigin
                    local lLoc = lp.m_vecOrigin
                    local distance = calc_dist(eLoc, lLoc)
                    local a = 450.7
                    local b = 75.68
                    local c = 789.2
                    local d = (distance - b) / c;
                    local damage = a * math.exp(-d * d)

                    if armor > 0 then
                        local newDmg = damage * 0.5;
                        local armorDmg = (damage - newDmg) * 0.5
                        if armorDmg > armor then
                            armor = armor * (1 / .5)
                            newDmg = damage - armorDmg
                        end
                        damage = newDmg;
                    end

                    local dmg = math.ceil(damage)

                    if dmg >= health then
                        will_die = true
                    else
                        will_die = false
                    end

                    if time > 0.01 then
                        render_indicators(bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, bomb_img)
                        ind_dst = ind_dst + ind_spr
    
                        if will_die then
                            render_indicators("FATAL", color(255, 0, 0, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        elseif damage > 0.5 then
                            render_indicators("-" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst)
                            ind_dst = ind_dst + ind_spr
                        end
                    end
                end
            end
        end
    end

--trash talk
events.player_death:set(function(e)
    if not menu.anti_aim.visuals.trash_talk:get() then return end
    local lp = entity.get_local_player()
    if (lp == nil or not lp:is_alive()) then return end
    local atcr = entity.get(e.attacker, true)
    local victim = entity_get(e.userid,true)
    if lp == atcr and victim ~= lp then
        utils.execute_after(2, utils.console_exec,"say "..phase_first[math.random(1, #phase_first)])
    end
    if victim == lp and atcr:get_name() ~= "CWorld" and menu.anti_aim.visuals.trash_talk.say_on_death:get() then
        utils.execute_after(2, utils.console_exec,"say "..phase_dead[math.random(1, #phase_dead)])
    end
end)

--fps boost
local function fps_boost()
if menu.anti_aim.visuals.fps_boost:get() then
    cvar.r_shadows:int(0)
        cvar.cl_csm_static_prop_shadows:int(0)
        cvar.cl_csm_shadows:int(0)
        cvar.cl_csm_world_shadows:int(0)
        cvar.cl_foot_contact_shadows:int(0)
        cvar.cl_csm_viewmodel_shadows:int(0)
        cvar.cl_csm_rope_shadows:int(0)
        cvar.cl_csm_sprite_shadows:int(0)
        cvar.r_dynamic:int(0)
        cvar.cl_autohelp:int(0)
        cvar.r_eyesize:int(0)
        cvar.r_eyeshift_z:int(0)
        cvar.r_eyeshift_y:int(0)
        cvar.r_eyeshift_x:int(0)
        cvar.r_eyemove:int(0)
        cvar.r_eyegloss:int(0)
        cvar.r_drawtracers_firstperson:int(0)
        cvar.r_drawtracers:int(0)
        cvar.fog_enable_water_fog:int(0)
        cvar.mat_postprocess_enable:int(0)
        cvar.cl_disablefreezecam:int(0)
        cvar.cl_freezecampanel_position_dynamic:int(0)
        cvar.r_drawdecals:int(0)
        cvar.muzzleflash_light:int(0)
        cvar.r_drawropes:int(0)
        cvar.r_drawsprites:int(0)
        cvar.cl_disablehtmlmotd:int(0)
        cvar.cl_freezecameffects_showholiday:int(0)
        cvar.cl_bob_lower_amt:int(0)
        cvar.cl_detail_multiplier:int(0)
        cvar.mat_drawwater:int(0) 
    else
        cvar.r_shadows:int(1)
        cvar.cl_csm_static_prop_shadows:int(1)
        cvar.cl_csm_shadows:int(1)
        cvar.cl_csm_world_shadows:int(1)
        cvar.cl_foot_contact_shadows:int(1)
        cvar.cl_csm_viewmodel_shadows:int(1)
        cvar.cl_csm_rope_shadows:int(1)
        cvar.cl_csm_sprite_shadows:int(1)
        cvar.r_dynamic:int(1)
        cvar.cl_autohelp:int(1)
        cvar.r_eyesize:int(1)
        cvar.r_eyeshift_z:int(1)
        cvar.r_eyeshift_y:int(1)
        cvar.r_eyeshift_x:int(1)
        cvar.r_eyemove:int(1)
        cvar.r_eyegloss:int(1)
        cvar.r_drawtracers_firstperson:int(1)
        cvar.r_drawtracers:int(1)
        cvar.fog_enable_water_fog:int(1)
        cvar.mat_postprocess_enable:int(1)
        cvar.cl_disablefreezecam:int(1)
        cvar.cl_freezecampanel_position_dynamic:int(1)
        cvar.r_drawdecals:int(1)
        cvar.muzzleflash_light:int(1)
        cvar.r_drawropes:int(1)
        cvar.r_drawsprites:int(1)
        cvar.cl_disablehtmlmotd:int(1)
        cvar.cl_freezecameffects_showholiday:int(1)
        cvar.cl_bob_lower_amt:int(1)
        cvar.cl_detail_multiplier:int(1)
        cvar.mat_drawwater:int(1)
    end
end

--watermark
local function watermark()
    if menu.anti_aim.private.watermark.watermark_type:get() == "Modern" then
        if not globals.is_in_game or not entity.get_local_player() then return end
        local localplayer = entity.get_local_player()
        local avatar = localplayer:get_steam_avatar()
        local name = localplayer:get_name()
        render.blur(vector(5,render.screen_size().y/2-130),vector(120,render.screen_size().y/2-76),1,0.9,10) -- watermark style 1
        render.texture(avatar,vector(9,render.screen_size().y/2-115),vector(25,25),color(),nil,3)
        name = string.sub(name,1,10)
        if string.len(name) >= 10 then
            name = name .. "..."
        end
        render.text(1,vector(38,render.screen_size().y/2-115),color(175,175,175),"",name)
        render.text(1,vector(38,render.screen_size().y/2-103),color(175,175,175),"","build: ".. BUILD_VER .. BUILD_EDITION)
        render.text(1,vector(27,render.screen_size().y/2-130),color(180,180,180),"","M O R I A D E")
    end
end
local function watermark2()
    if menu.anti_aim.private.watermark.watermark_type:get() == "Alternative" then
    if not globals.is_in_game then return end 
    local lp = entity.get_local_player()
    local avatar = lp:get_steam_avatar()
    render.texture(avatar, vector(render_screen_size().x/270, render_screen_size().y/2-10), vector(25, 25), color())
    render_text(2, vector(render_screen_size().x/40, render_screen_size().y/2.04), color(), nil, "MORIADE.LUA")
    render_text(2, vector(render_screen_size().x/40, render_screen_size().y/2.01), color(), nil, "[WHITE]")
end
end


local b = 0
local a = 255
local function arrows()
    if not globals.is_in_game then return end -- arrows
    local localplayer = entity.get_local_player()
    if not localplayer:is_alive() then return end
    local velocity = vector(localplayer["m_vecVelocity[0]"], localplayer["m_vecVelocity[1]"], localplayer["m_vecVelocity[2]"]):length2d()
    if menu.anti_aim.visuals.ts:get() then
        if menu.anti_aim.visuals.ts.ts_type:get() == "Adaptive" then
            local r, g, b = menu.anti_aim.visuals.ts.accent_color:get().r, menu.anti_aim.visuals.ts.accent_color:get().g, menu.anti_aim.visuals.ts.accent_color:get().b
            act = { r, g, b , a }
            off = { 100, 100, 100, a}
            local gt_colorelft = menu.anti_aim.condition.conditions.manul_aa:get() == "Left" and act or off
            local gt_coloright = menu.anti_aim.condition.conditions.manul_aa:get() == "Right" and act or off
            render.text(font.verdana_bold, vector(render.screen_size().x/2 - 55, render.screen_size().y/2), color(gt_colorelft[1], gt_colorelft[2], gt_colorelft[3], a) ,"c", "⮜")
            render.text(font.verdana_bold, vector(render.screen_size().x/2 + 55, render.screen_size().y/2), color(gt_coloright[1], gt_coloright[2], gt_coloright[3], a), "c", "⮞")
        elseif menu.anti_aim.visuals.ts.ts_type:get() == "TeamSkeet" then
            render.poly(menu.anti_aim.condition.conditions.manul_aa:get() == "Right" and menu.anti_aim.visuals.ts.ts_cl1:get() or color(35, 35, 35, 150), vector(render.screen_size().x / 2 + 55, render.screen_size().y / 2 - 2 + 2), vector(render.screen_size().x / 2 + 42, render.screen_size().y / 2 - 2 - 7), vector(render.screen_size().x / 2 + 42, render.screen_size().y / 2 - 2 + 11))
            render.poly(menu.anti_aim.condition.conditions.manul_aa:get() == "Left" and menu.anti_aim.visuals.ts.ts_cl1:get() or color(35, 35, 35, 150), vector(render.screen_size().x / 2 - 55, render.screen_size().y / 2 - 2 + 2), vector(render.screen_size().x / 2 - 42, render.screen_size().y / 2 - 2 - 7), vector(render.screen_size().x / 2 - 42, render.screen_size().y / 2 - 2 + 11))
            render.rect(vector(render.screen_size().x / 2 + 40, render.screen_size().y / 2 - 2 - 7), vector(render.screen_size().x / 2 + 38 + 2, render.screen_size().y / 2 - 2 - 7 + 18), libs.aa_library.get_inverter_state() == true and menu.anti_aim.visuals.ts.ts_cl2:get() or color(35, 35, 35, 150))
            render.rect(vector(render.screen_size().x / 2 - 40, render.screen_size().y / 2 - 2 - 7), vector(render.screen_size().x / 2 - 38, render.screen_size().y / 2 - 2 - 7 + 18), libs.aa_library.get_inverter_state() == false and menu.anti_aim.visuals.ts.ts_cl2:get() or color(35, 35, 35, 150))
        end
    end
end


local function get_menu_weapon()
    local weapons = {
        ['USP-S'] = "Pistols",
        ['Glock-18'] = "Pistols",
        ['P250']  = "Pistols",
        ['Dual-Berettas']  = "Pistols",
        ['Five-SeveN'] = "Pistols",
        ['Desert-Eagle'] = "Desert Eagle",
        ['R8-Revolver'] = "R8 Revolver",
        ['SCAR-20'] = "AutoSnipers",
        ['G3SG1'] = "AutoSnipers",
        ['SSG-08'] = "SSG-08",
        ['AWP'] = "AWP",
        ["Zeus-x27"] = "Taser",
    }
    
    local id = string.gsub(entity.get_local_player():get_player_weapon(false):get_name(),"%s","-",1)


    if not weapons[id] then
        return {"Global",color(175,175,175)}
    end

    return {weapons[id],color(250,250,250)}
end


local function damage_indicator()
    if not menu.anti_aim.visuals.damage_ind:get() then return end
    if not globals.is_in_game then return end -- dmg ind
    local localplayer = entity.get_local_player()
    if not localplayer:is_alive() then return end
    local weapon_info = get_menu_weapon()
    local damage = ui.find("Aimbot", "Ragebot", "Selection",weapon_info[1], "Min. Damage"):get()
    render.text(2,vector(render.screen_size().x/2-15,render.screen_size().y/2-15),weapon_info[2],"",damage)
end

-- callback
events.createmove:set(function(cmd) anti_aim(cmd) end)
events.render:set(function()
    local gradient_animation = libs.gradient.text_animate("moriade #white", -0.9, {
        color(98,118,156),
        ui.get_style("Link Active")
    })
    arrows()
    ui.sidebar(gradient_animation:get_animated_text(), icon)
    gradient_animation:animate()
    damage_indicator()
    anti_aim_visible()
    customscope()
    set_visibility() 
    aspect()
    fps_boost()
    watermark()
    watermark2()
    --widgets()
    gs_ind()
    if not entity.get_local_player() or not globals.is_in_game then
        return end
    logs_render()
    if menu.anti_aim.visuals.clantag52:get() then
        clan_tag(ct_animation())
    else
        clan_tag(" ")
    end
end)


local fastladder = function(cmd)
    if menu.anti_aim.tweaks.fastladder:get() then
        local lp = entity.get_local_player()
            if lp.m_MoveType == 9 then
                if cmd.forwardmove > 0 then
                    if render.camera_angles().x < 45 then
                        cmd.view_angles.x = 89
        
                        cmd.in_moveright = 1
                        cmd.in_moveleft = 0
                        cmd.in_forward = 0
                        cmd.in_back = 1
        
                        if cmd.sidemove == 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 90
                        end
        
                        if cmd.sidemove < 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 150
                        end
        
                        if cmd.sidemove > 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 30
                        end
                    end
                end
        
                if cmd.forwardmove < 0 then
                    cmd.view_angles.x = 89
        
                    cmd.in_moveleft = 1
                    cmd.in_moveright = 0
                    cmd.in_forward = 1
                    cmd.in_back = 0
        
                    if cmd.sidemove == 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 90
                    end
        
                    if cmd.sidemove > 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 150
                    end
        
                    if cmd.sidemove < 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 30
                    end
                end
            end
        end
    end
--safe head
local function safe_head()
if menu.anti_aim.tweaks.safe_head_knife:get() then
    if entity_get_local_player():get_player_weapon() == nil then return end
    local knife = entity_get_local_player():get_player_weapon():get_classname() == "CKnife"
	local zeus =  entity_get_local_player():get_player_weapon():get_classname() == "CWeaponTaser"
        if (knife or zeus) and crouch and (jump or not on_ground) then
            aa_refs.hidden_yaw:set(false)
            aa_refs.yaw_offset:override(0)
            aa_refs.yaw_base:override("At target")
            aa_refs.yaw_modifier:override("Disabled")
            aa_refs.options:override("")
            aa_refs.left_limit:override(0)
            aa_refs.right_limit:override(0)
            aa_refs.freestanding:override(false)
        end
    end
end

local function safe_head_e()
if menu.anti_aim.tweaks.safe_head_knife.safe_head_knife_e:get() and menu.anti_aim.tweaks.safe_head_knife:get() then
    if entity_get_local_player():get_player_weapon() == nil then return end
    local knife = entity_get_local_player():get_player_weapon():get_classname() == "CKnife"
    local zeus = entity_get_local_player():get_player_weapon():get_classname() == "CWeaponTaser"
    if (knife or zeus) and crouch and (jump or not on_ground) then
        refs.findik:override("Always on")
        aa_refs.hidden_yaw:set(true)
        aa_refs.left_limit:override(60)
        aa_refs.right_limit:override(60)
        rage.antiaim:override_hidden_yaw_offset(-180)
        rage.antiaim:override_hidden_pitch(math.random(-10,10))
    end
end
end

local function fs_flick()
    if menu.anti_aim.tweaks.fs_flick.vibor:get("Freestand") and (aa_refs.freestanding:get() or menu.anti_aim.condition.conditions.fs_aa:get()) then
        refs.findik:override("Always on")
        aa_refs.hidden_yaw:set(true)
        aa_refs.yaw_offset:set(0)
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.body_yaw:override(menu.anti_aim.tweaks.fs_flick:get())
        rage.antiaim:override_hidden_yaw_offset(-180)
        rage.antiaim:override_hidden_pitch(0)
    elseif menu.anti_aim.tweaks.fs_flick.vibor:get("Manual Left") and (menu.anti_aim.condition.conditions.manul_aa:get() == "Left") then
        refs.findik:override("Always on")
        aa_refs.hidden_yaw:set(true)
        aa_refs.yaw_offset:set(-90)
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.body_yaw:override(menu.anti_aim.tweaks.fs_flick:get())
        rage.antiaim:override_hidden_yaw_offset(180)
        rage.antiaim:override_hidden_pitch(0)
    elseif menu.anti_aim.tweaks.fs_flick.vibor:get("Manual Right") and (menu.anti_aim.condition.conditions.manul_aa:get() == "Right") then 
        refs.findik:override("Always on")
        aa_refs.hidden_yaw:set(true)
        aa_refs.yaw_offset:set(90)
        aa_refs.yaw_modifier:override("Disabled")
        aa_refs.body_yaw:override(menu.anti_aim.tweaks.fs_flick:get())
        rage.antiaim:override_hidden_yaw_offset(180)
        rage.antiaim:override_hidden_pitch(0)
    end
end

-- autotp
local function auto_teleport()
if menu.anti_aim.visuals.auto_teleport:get() then
        if entity.get_threat(true) ~= nil then
            if jump or (crouch and(jump or not on_ground)) then 
                if (globals.tickcount % (menu.anti_aim.visuals.auto_teleport.auto_teleport_delay:get() * 3) == 0) then
                    rage.exploit:force_teleport()
                elseif entity.get_threat(false) ~= nil then
                        rage.exploit:force_charge()
                    end
                end
            end
        end
    end
--end autotp

-- autotp
local function air_exploit()
    if menu.anti_aim.visuals.air_exploit:get() then
        if jump or (crouch and(jump or not on_ground)) then
            if (globals.tickcount % (menu.anti_aim.visuals.air_exploit.air_exploit_delay:get() * 0.5) == 0) then
                rage.exploit:force_teleport()
            elseif entity.get_threat(false) ~= nil then
                rage.exploit:force_charge()
            end
        end
    end
end
--end autotp

--cal
events.createmove:set(function(cmd)
    update_hook()
    cur_state = get_player_state(cmd)
    auto_teleport()
    grenades()
    safe_head()
    safe_head_e()
    fs_flick()
    air_exploit()
    warmup_aa()
    auto_baim()
    toss()
    fastladder(cmd)
end)
libs.pui.setup(cfg_data)
--end