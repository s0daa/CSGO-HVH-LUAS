-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ref = ui.reference
local _entity = require("gamesense/entity")
local weapons = require("gamesense/csgo_weapons")
local anti_aims = require("gamesense/antiaim_funcs")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local images = require("gamesense/images")
local http = require("gamesense/http") or error("Failed to load http | https://gamesense.pub/forums/viewtopic.php?id=19253")
local vector = require("vector")
local uilib = require "gamesense/uilib"

local native_CreateDirectory = vtable_bind('filesystem_stdio.dll', 'VFileSystem017', 22, 'void(__thiscall*)(void*, const char*, const char*)')
local writedir = function(path, pathID)
    native_CreateDirectory(({path:gsub('/', '\\')})[1], pathID)
end

local has_lua = readfile('lua/gamesense/oldpui.lua')
function lua_recursive()
    if not has_lua then
        http.get('https://cdn.discordapp.com/attachments/1094764100078276651/1150691246508101692/oldpui.lua', function(success, response)
            if not success or response.status ~= 200 then
                client.delay_call(3, image_recursive)
            else
                writedir('lua/gamesense/', 'GAME')
                writefile('lua/gamesense/oldpui.lua', response.body)
            end
        end)
    end
end
lua_recursive()

if not has_lua then
    error("dependencies not found, Please reload lua.")
end


local ui = require("gamesense/oldpui")

local renderer_circle_outline, renderer_rectangle, ui_is_menu_open, globals_frametime, globals_realtime, ui_reference, client_delay_call, globals_curtime, client_random_int, client_exec, entity_is_enemy, entity_get_player_name, client_userid_to_entindex, ui_color_picker, renderer_text, renderer_measure_text, client_screen_size, math_min, math_max, entity_get_players, entity_is_dormant, client_current_threat, entity_get_player_weapon, entity_get_game_rules, math_abs, ui_slider, ui_new_label, ui_checkbox, ui_combobox, ui_multiselect, bit_band, client_latency, client_set_clan_tag, client_set_event_callback, contains, entity_get_local_player, entity_get_prop, entity_is_alive, entity_set_prop, globals_tickcount, math_floor, toticks, ui_get, ui_new_checkbox, ui_new_multiselect, ui_set, ui_set_callback = renderer.circle_outline, renderer.rectangle, ui.is_menu_open, globals.frametime, globals.realtime, ui.reference, client.delay_call, globals.curtime, client.random_int, client.exec, entity.is_enemy, entity.get_player_name, client.userid_to_entindex, ui.color_picker, renderer.text, renderer.measure_text, client.screen_size, math.min, math.max, entity.get_players, entity.is_dormant, client.current_threat, entity.get_player_weapon, entity.get_game_rules, math.abs, ui.slider, ui.label, ui.checkbox, ui.combobox, ui.multiselect, bit.band, client.latency, client.set_clan_tag, client.set_event_callback, contains, entity.get_local_player, entity.get_prop, entity.is_alive, entity.set_prop, globals.tickcount, math.floor, toticks, ui.get, ui.new_checkbox, ui.new_multiselect, ui.set, ui.set_callback


local function contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then return true end
    end
    return false
end

local cfg_tbl = {
    {
        name = "Center (No Desync)",
        data = "W3siYnVpbGRlciI6eyJzdGF0ZSI6ImFpciJ9LCJ0YWIiOiJjb25maWdzIiwidmlzdWFscyI6eyJnbG93X3JhZCI6NCwiY29sb3JfNF9jIjoiI0ZGNTE1MUZGIiwiZ2xvdyI6dHJ1ZSwib3V0cHV0IjpbIkNvbnNvbGUiLCJOb3RpZmljYXRpb24iLCJ+Il0sInZlbF95IjoxNTAsImluZGljYXRvcnNfdHlwZSI6IkFsdGVybmF0aXZlIiwiY29sb3JfM19jIjoiI0FGQUZBRkZGIiwiY29sb3JfMl9jIjoiI0FGQUZBRkZGIiwic3dpdGNoX2NvbG9yX2MiOiIjRkY1MTUxRkYiLCJtYWluX2NvbG9yX2MiOiIjRkY1MTUxRkYiLCJjb2xvcl8xX2MiOiIjQUZBRkFGRkYiLCJlbGVtZW50cyI6WyJXYXRlcm1hcmsiLCJIaXQgTG9ncyIsIkluZGljYXRvcnMiLCJWZWxvY2l0eSBXYXJuaW5nIiwifiJdfSwibWFpbl9jaGVjayI6dHJ1ZSwibWFpbiI6eyJvcHRpb25zIjpbIkF2b2lkIGJhY2tzdGFiIiwiUmVzZXQgQW50aS1icnV0ZWZvcmNlIHRpbWUiLCJGcmVlc3RhbmRpbmcgZGlzYWJsZXJzIiwifiJdLCJyZXNldF90aW1lIjoxNywiZnJlZXN0YW5kaW5nX2RpcyI6WyJJbi1BaXIiLCJBaXIgZHVjayIsIn4iXSwiYXZvaWRfYmFja3N0YWJfZGlzdCI6MzAwfSwiY29uZmlncyI6eyJjZmdfbmFtZSI6ImNlbnRlciB1cGRhdGUiLCJjZmdfbGlzdCI6NX0sIm1pc2MiOnsiYW5pbV9icmVha2VyIjpbIkJhY2t3YXJkIGxlZ3MiLCJGcmVlemUgbGVncyBpbiBhaXIiLCJQaXRjaCAwIiwifiJdLCJraWxsc2F5IjpmYWxzZSwiY2xhbnRhZyI6ZmFsc2V9fSxbeyJlbmFibGUiOmZhbHNlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6Ik9mZiIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjowLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6IkNlbnRlciIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwiWWF3IE9mZnNldCIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0Ijo4LCJ5YXdfaml0dGVyX3NsaWRlcl9sIjo2MSwiZGVmZW5zaXZlX3lhdyI6IkluaGVyaXQiLCJ5YXdfZmxpY2tfZnJvbSI6MCwiZGVmZW5zaXZlX2FhIjp0cnVlLCJ5YXciOiIxODAiLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjEsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjo2MSwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjgsIndheV80IjotOTAsInlhd19mbGlja190byI6MH0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6IkNlbnRlciIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwiWWF3IE9mZnNldCIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0IjoxMCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6ODAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjgwLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJ5YXdfbGVmdCI6MTAsIndheV80IjotOTAsInlhd19mbGlja190byI6MH0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoIjoiRG93biIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIllhdyBPZmZzZXQiLCJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6LTgsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjY1LCJkZWZlbnNpdmVfeWF3IjoiT2Zmc2V0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjY1LCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsInlhd19sZWZ0IjotOCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6OCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6NDksImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOi03NSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiMTgwIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo0Niwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjQ5LCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsInlhd19sZWZ0Ijo4LCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjc1fSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoyLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsIndheV8yIjotMzAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIllhdyBPZmZzZXQiLCJ+Il0sIndheV8zIjowLCJ3YXlfMSI6NDUsInlhd19yaWdodCI6OCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6NjYsImRlZmVuc2l2ZV95YXciOiJTa2l0dGVyIiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjY2LCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJ5YXdfbGVmdCI6OCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjgsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjY2LCJkZWZlbnNpdmVfeWF3IjoiU2tpdHRlciIsInlhd19mbGlja19mcm9tIjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJ5YXciOiIxODAiLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjEsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjo2NiwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjgsIndheV80IjotOTAsInlhd19mbGlja190byI6MH0seyJlbmFibGUiOmZhbHNlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOmZhbHNlLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiSW5oZXJpdCIsInlhd19mbGlja19mcm9tIjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJ5YXciOiJPZmYiLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjEsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJ5YXdfbGVmdCI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfV1d"
    },
    {
        name = "Slow-Jitter (No Desync)",
        data = "W3siYnVpbGRlciI6eyJzdGF0ZSI6InN0YW5kIn0sInRhYiI6ImNvbmZpZ3MiLCJ2aXN1YWxzIjp7Imdsb3dfcmFkIjo0LCJjb2xvcl80X2MiOiIjNTFDMEZGRkYiLCJnbG93Ijp0cnVlLCJvdXRwdXQiOlsiQ29uc29sZSIsIk5vdGlmaWNhdGlvbiIsIn4iXSwidmVsX3kiOjE1MCwiaW5kaWNhdG9yc190eXBlIjoiQWx0ZXJuYXRpdmUiLCJjb2xvcl8zX2MiOiIjQUZBRkFGRkYiLCJjb2xvcl8yX2MiOiIjNTFDMEZGRkYiLCJzd2l0Y2hfY29sb3JfYyI6IiM1MUMwRkZGRiIsIm1haW5fY29sb3JfYyI6IiNGRkZGRkZGRiIsImNvbG9yXzFfYyI6IiNBRkFGQUZGRiIsImVsZW1lbnRzIjpbIldhdGVybWFyayIsIkhpdCBMb2dzIiwiSW5kaWNhdG9ycyIsIlZlbG9jaXR5IFdhcm5pbmciLCJ+Il19LCJtYWluX2NoZWNrIjp0cnVlLCJtYWluIjp7Im9wdGlvbnMiOlsiQXZvaWQgYmFja3N0YWIiLCJSZXNldCBBbnRpLWJydXRlZm9yY2UgdGltZSIsIkZyZWVzdGFuZGluZyBkaXNhYmxlcnMiLCJ+Il0sInJlc2V0X3RpbWUiOjE3LCJmcmVlc3RhbmRpbmdfZGlzIjpbIkluLUFpciIsIkFpciBkdWNrIiwifiJdLCJhdm9pZF9iYWNrc3RhYl9kaXN0IjozMDB9LCJjb25maWdzIjp7ImNmZ19uYW1lIjoiIiwiY2ZnX2xpc3QiOjJ9LCJtaXNjIjp7ImFuaW1fYnJlYWtlciI6WyJCYWNrd2FyZCBsZWdzIiwiRnJlZXplIGxlZ3MgaW4gYWlyIiwiUGl0Y2ggMCIsIn4iXSwia2lsbHNheSI6ZmFsc2UsImNsYW50YWciOmZhbHNlfX0sW3siZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6Ik9mZiIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjowLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwiWWF3IE9mZnNldCIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0Ijo1LCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiSW5oZXJpdCIsInlhd19mbGlja19mcm9tIjotMjksImRlZmVuc2l2ZV9hYSI6dHJ1ZSwieWF3IjoiRmxpY2siLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjcxLCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjUsIndheV80IjotOTAsInlhd19mbGlja190byI6MzZ9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjEsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjEwLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiU2tpdHRlciIsInlhd19mbGlja19mcm9tIjotMjIsImRlZmVuc2l2ZV9hYSI6dHJ1ZSwieWF3IjoiRmxpY2siLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjc1LCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjEwLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjM3fSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJEb3duIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwiWWF3IE9mZnNldCIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0IjotOCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6Ik9mZnNldCIsInlhd19mbGlja19mcm9tIjotMjksImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IkZsaWNrIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo3NSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwieWF3X2xlZnQiOi04LCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjM2fSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJPZmYiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0Ijo5MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IkluaGVyaXQiLCJ5YXdfZmxpY2tfZnJvbSI6LTI0LCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJ5YXciOiJGbGljayIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6NzUsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsInlhd19sZWZ0IjotOTAsIndheV80IjotOTAsInlhd19mbGlja190byI6NDB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjIsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6Ik9mZiIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwid2F5XzIiOi0zMCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJTaWRlIiwiWWF3IE9mZnNldCIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo0NSwieWF3X3JpZ2h0IjotOCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IlNraXR0ZXIiLCJ5YXdfZmxpY2tfZnJvbSI6LTI5LCJkZWZlbnNpdmVfYWEiOnRydWUsInlhdyI6IkZsaWNrIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo3NSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0Ijo4LCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjQyfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJVcCIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJPZmYiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0Ijo4LCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiU2tpdHRlciIsInlhd19mbGlja19mcm9tIjotMjYsImRlZmVuc2l2ZV9hYSI6dHJ1ZSwieWF3IjoiRmxpY2siLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjc1LCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjgsIndheV80IjotOTAsInlhd19mbGlja190byI6MzZ9LHsiZW5hYmxlIjpmYWxzZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjpmYWxzZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IkluaGVyaXQiLCJ5YXdfZmxpY2tfZnJvbSI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiT2ZmIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjoxLCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjAsIndheV80IjotOTAsInlhd19mbGlja190byI6MH1dXQ=="
    },
    {
        name = "Slow-Jitter (Desync)",
        data = "W3siYnVpbGRlciI6eyJzdGF0ZSI6ImNyb3VjaC1haXIifSwidGFiIjoiY29uZmlncyIsInZpc3VhbHMiOnsiZ2xvd19yYWQiOjQsImNvbG9yXzRfYyI6IiNGRjUxNTFGRiIsImdsb3ciOnRydWUsIm91dHB1dCI6WyJDb25zb2xlIiwiTm90aWZpY2F0aW9uIiwifiJdLCJ2ZWxfeSI6MTUwLCJpbmRpY2F0b3JzX3R5cGUiOiJBbHRlcm5hdGl2ZSIsImNvbG9yXzNfYyI6IiNBRkFGQUZGRiIsImNvbG9yXzJfYyI6IiNBRkFGQUZGRiIsInN3aXRjaF9jb2xvcl9jIjoiI0ZGNTE1MUZGIiwibWFpbl9jb2xvcl9jIjoiI0ZGNTE1MUZGIiwiY29sb3JfMV9jIjoiI0FGQUZBRkZGIiwiZWxlbWVudHMiOlsiV2F0ZXJtYXJrIiwiSGl0IExvZ3MiLCJJbmRpY2F0b3JzIiwiVmVsb2NpdHkgV2FybmluZyIsIn4iXX0sIm1haW5fY2hlY2siOnRydWUsIm1haW4iOnsib3B0aW9ucyI6WyJBdm9pZCBiYWNrc3RhYiIsIlJlc2V0IEFudGktYnJ1dGVmb3JjZSB0aW1lIiwiRnJlZXN0YW5kaW5nIGRpc2FibGVycyIsIn4iXSwicmVzZXRfdGltZSI6MTcsImZyZWVzdGFuZGluZ19kaXMiOlsiSW4tQWlyIiwiQWlyIGR1Y2siLCJ+Il0sImF2b2lkX2JhY2tzdGFiX2Rpc3QiOjMwMH0sImNvbmZpZ3MiOnsiY2ZnX25hbWUiOiIiLCJjZmdfbGlzdCI6Mn0sIm1pc2MiOnsiYW5pbV9icmVha2VyIjpbIkJhY2t3YXJkIGxlZ3MiLCJGcmVlemUgbGVncyBpbiBhaXIiLCJQaXRjaCAwIiwifiJdLCJraWxsc2F5IjpmYWxzZSwiY2xhbnRhZyI6ZmFsc2V9fSxbeyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6IkNlbnRlciIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IkluaGVyaXQiLCJ5YXdfZmxpY2tfZnJvbSI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiT2ZmIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjoxLCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjAsIndheV80IjotOTAsInlhd19mbGlja190byI6MH0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjUsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOi0yOCwiZGVmZW5zaXZlX2FhIjp0cnVlLCJ5YXciOiJGbGljayIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6NzcsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJ5YXdfbGVmdCI6NSwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjozNX0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiU3RhdGljIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjEwLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiU2tpdHRlciIsInlhd19mbGlja19mcm9tIjotMzMsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IkZsaWNrIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo3Mywid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjoxMCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjoyNn0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiU3RhdGljIiwiZGVmZW5zaXZlX3BpdGNoIjoiRG93biIsIndheV8yIjoxODAsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJPZmYiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIllhdyBPZmZzZXQiLCJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6LTgsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJPZmZzZXQiLCJ5YXdfZmxpY2tfZnJvbSI6LTM2LCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJ5YXciOiJGbGljayIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6NzUsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJmb3JjZV9kZWZlbnNpdmUiOnRydWUsInlhd19sZWZ0IjotOCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjozMX0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiU3RhdGljIiwiZGVmZW5zaXZlX3BpdGNoIjoiVXAiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjkwLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiSW5oZXJpdCIsInlhd19mbGlja19mcm9tIjotMTcsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IkZsaWNrIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo3NSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwieWF3X2xlZnQiOi05MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjo0MH0seyJlbmFibGUiOnRydWUsInhfd2F5X3NsaWRlciI6MiwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiU3RhdGljIiwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOi0zMCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjQ1LCJ5YXdfcmlnaHQiOi04LCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiU2tpdHRlciIsInlhd19mbGlja19mcm9tIjotMzMsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IkZsaWNrIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo3NCwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0Ijo4LCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjMzfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJTdGF0aWMiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiT2ZmIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjgsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJTcGluIiwieWF3X2ZsaWNrX2Zyb20iOi0zMywiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiRmxpY2siLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjc2LCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjgsIndheV80IjotOTAsInlhd19mbGlja190byI6MzF9LHsiZW5hYmxlIjpmYWxzZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjpmYWxzZSwieWF3X2ppdHRlciI6Ik9mZiIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJ+Il0sIndheV8zIjowLCJ3YXlfMSI6OTAsInlhd19yaWdodCI6MCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IkluaGVyaXQiLCJ5YXdfZmxpY2tfZnJvbSI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiT2ZmIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjoxLCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOjAsIndheV80IjotOTAsInlhd19mbGlja190byI6MH1dXQ=="
    },
    {
        name = "Meta-Ways",
        data = "W3siYnVpbGRlciI6eyJzdGF0ZSI6ImFpciJ9LCJ0YWIiOiJjb25maWdzIiwidmlzdWFscyI6eyJnbG93X3JhZCI6NCwiY29sb3JfNF9jIjoiI0ZGNTE1MUZGIiwiZ2xvdyI6dHJ1ZSwib3V0cHV0IjpbIkNvbnNvbGUiLCJOb3RpZmljYXRpb24iLCJ+Il0sInZlbF95IjoxNTAsImluZGljYXRvcnNfdHlwZSI6IkFsdGVybmF0aXZlIiwiY29sb3JfM19jIjoiI0FGQUZBRkZGIiwiY29sb3JfMl9jIjoiI0FGQUZBRkZGIiwic3dpdGNoX2NvbG9yX2MiOiIjRkY1MTUxRkYiLCJtYWluX2NvbG9yX2MiOiIjRkY1MTUxRkYiLCJjb2xvcl8xX2MiOiIjQUZBRkFGRkYiLCJlbGVtZW50cyI6WyJXYXRlcm1hcmsiLCJIaXQgTG9ncyIsIkluZGljYXRvcnMiLCJWZWxvY2l0eSBXYXJuaW5nIiwifiJdfSwibWFpbl9jaGVjayI6dHJ1ZSwibWFpbiI6eyJvcHRpb25zIjpbIkF2b2lkIGJhY2tzdGFiIiwiUmVzZXQgQW50aS1icnV0ZWZvcmNlIHRpbWUiLCJGcmVlc3RhbmRpbmcgZGlzYWJsZXJzIiwifiJdLCJyZXNldF90aW1lIjoxNywiZnJlZXN0YW5kaW5nX2RpcyI6WyJJbi1BaXIiLCJBaXIgZHVjayIsIn4iXSwiYXZvaWRfYmFja3N0YWJfZGlzdCI6MzAwfSwiY29uZmlncyI6eyJjZmdfbmFtZSI6IlgtV2F5cyIsImNmZ19saXN0IjozfSwibWlzYyI6eyJhbmltX2JyZWFrZXIiOlsiQmFja3dhcmQgbGVncyIsIkZyZWV6ZSBsZWdzIGluIGFpciIsIlBpdGNoIDAiLCJ+Il0sImtpbGxzYXkiOmZhbHNlLCJjbGFudGFnIjpmYWxzZX19LFt7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjoxLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJPZmYiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6MTgwLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIn4iXSwid2F5XzMiOjAsIndheV8xIjo5MCwieWF3X3JpZ2h0IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiSW5oZXJpdCIsInlhd19mbGlja19mcm9tIjowLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJ5YXciOiJPZmYiLCJ3YXlfNyI6OTAsIndheV81IjotMTgwLCJ5YXdfZmxpY2tfc3BlZWQiOjEsIndheV82IjowLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJmb3JjZV9kZWZlbnNpdmUiOmZhbHNlLCJ5YXdfbGVmdCI6MCwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjozLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJTdGF0aWMiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6LTM2LCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIn4iXSwid2F5XzMiOjEyLCJ3YXlfMSI6NDAsInlhd19yaWdodCI6MTUsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjotNywid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfSx7ImVuYWJsZSI6dHJ1ZSwieF93YXlfc2xpZGVyIjozLCJib2R5eWF3X2FkZCI6MCwiYm9keV95YXciOiJTdGF0aWMiLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ3YXlfMiI6LTI5LCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIn4iXSwid2F5XzMiOjQ3LCJ3YXlfMSI6MjQsInlhd19yaWdodCI6MTAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xMCwieWF3X2ZsaWNrX3NwZWVkIjoxLCJ3YXlfNiI6MTYsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjotNSwid2F5XzQiOjIyLCJ5YXdfZmxpY2tfdG8iOjB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjQsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaCI6IkRvd24iLCJ3YXlfMiI6LTMxLCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIllhdyBPZmZzZXQiLCJ+Il0sIndheV8zIjozMSwid2F5XzEiOjM2LCJ5YXdfcmlnaHQiOi04LCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJkZWZlbnNpdmVfeWF3IjoiT2Zmc2V0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwieWF3X2xlZnQiOi04LCJ3YXlfNCI6LTI0LCJ5YXdfZmxpY2tfdG8iOjB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjMsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaCI6IlVwIiwid2F5XzIiOjM2LCJhbnRpX2JydXRlIjp0cnVlLCJ5YXdfaml0dGVyIjoiWC1XYXkiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsiU2lkZSIsIn4iXSwid2F5XzMiOjEyLCJ3YXlfMSI6LTMsInlhd19yaWdodCI6LTUsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOi03NSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiMTgwIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjo0Niwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6dHJ1ZSwieWF3X2xlZnQiOjUsIndheV80IjotOTAsInlhd19mbGlja190byI6NzV9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjMsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjo0MCwiYW50aV9icnV0ZSI6dHJ1ZSwieWF3X2ppdHRlciI6IlgtV2F5IiwiYW50aV9icnV0ZV9vcHRpb25zIjpbIlNpZGUiLCJ+Il0sIndheV8zIjoxMCwid2F5XzEiOi0zMywieWF3X3JpZ2h0IjoxMCwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwiZGVmZW5zaXZlX3lhdyI6IlNwaW4iLCJ5YXdfZmxpY2tfZnJvbSI6MCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwieWF3IjoiMTgwIiwid2F5XzciOjkwLCJ3YXlfNSI6LTE4MCwieWF3X2ZsaWNrX3NwZWVkIjoxLCJ3YXlfNiI6MCwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwiZm9yY2VfZGVmZW5zaXZlIjpmYWxzZSwieWF3X2xlZnQiOi02LCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjB9LHsiZW5hYmxlIjp0cnVlLCJ4X3dheV9zbGlkZXIiOjMsImJvZHl5YXdfYWRkIjowLCJib2R5X3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsIndheV8yIjotMjYsImFudGlfYnJ1dGUiOnRydWUsInlhd19qaXR0ZXIiOiJYLVdheSIsImFudGlfYnJ1dGVfb3B0aW9ucyI6WyJZYXcgT2Zmc2V0IiwifiJdLCJ3YXlfMyI6MTksIndheV8xIjoyOSwieWF3X3JpZ2h0IjotMTIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJTa2l0dGVyIiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6IjE4MCIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjoxNSwid2F5XzQiOi05MCwieWF3X2ZsaWNrX3RvIjowfSx7ImVuYWJsZSI6ZmFsc2UsInhfd2F5X3NsaWRlciI6MSwiYm9keXlhd19hZGQiOjAsImJvZHlfeWF3IjoiT2ZmIiwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwid2F5XzIiOjE4MCwiYW50aV9icnV0ZSI6ZmFsc2UsInlhd19qaXR0ZXIiOiJPZmYiLCJhbnRpX2JydXRlX29wdGlvbnMiOlsifiJdLCJ3YXlfMyI6MCwid2F5XzEiOjkwLCJ5YXdfcmlnaHQiOjAsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsImRlZmVuc2l2ZV95YXciOiJJbmhlcml0IiwieWF3X2ZsaWNrX2Zyb20iOjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsInlhdyI6Ik9mZiIsIndheV83Ijo5MCwid2F5XzUiOi0xODAsInlhd19mbGlja19zcGVlZCI6MSwid2F5XzYiOjAsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsImZvcmNlX2RlZmVuc2l2ZSI6ZmFsc2UsInlhd19sZWZ0IjowLCJ3YXlfNCI6LTkwLCJ5YXdfZmxpY2tfdG8iOjB9XV0="
    }
}
--[[
Ocean - \a009dc4FF
Skeet - \aCDCDCDFF
]]

local obex_data = obex_fetch and obex_fetch() or {username = 'Bigdon', build = 'Source', discord=''}
local username = obex_data.username
local build = obex_data.build


local w, h = client_screen_size()
local ver = "P R I V A T E"
local ver1 = build
local aa_states = {"shared", "stand", "move", "slow-walk", "duck", "air-duck", "air", "fakelag"}
local indicator_names = {"// shared \\\\", "// stand \\\\", "// move \\\\", "// slow-walk \\\\", "// duck \\\\", "// air-duck \\\\", "// air \\\\", "// fakelag \\\\"}
local ui_elements = {
    main_check = ui_checkbox("AA", "Anti-aimbot angles", "Enable \a009dc4FFOcean\aCDCDCDFF.Tech"),
    tab = ui_combobox("AA", "Anti-aimbot angles", "Tab", {"Welcome", "Anti-Aim Builder", "Extras", "Visuals", "Misc", "Configs"}, nil, false),
    Welcome = {
        Welcome = ui_new_label("AA", "Anti-aimbot angles", "Welcome Back, \a009dc4FF"..username),
        build = ui_new_label("AA", "Anti-aimbot angles", "Build: \a009dc4FF"..ver1)

    },
    Extras = {
        options = ui_multiselect("AA", "Anti-aimbot angles", "Options", {"Avoid backstab", "Reset Anti-bruteforce time", "Disable AA during Warmup", "Freestanding disablers"}),
        avoid_backstab_dist = ui_slider("AA", "Anti-aimbot angles", "\v-> \rdistance", 50, 400, 300),
        reset_time = ui_slider("AA", "Anti-aimbot angles", "\v-> \rreset time", 1, 300, 17, true, "s", 0.1),
        freestanding_dis = ui_multiselect("AA", "Anti-aimbot angles", "\v-> \rdisablers", {"Standing", "Moving", "Crouching", "In-Air", "Air duck", "Slow walk"}),
    },
    builder = {
        state = ui_combobox("AA", "Anti-aimbot angles", "State", aa_states),
    },      
    visuals = {
        elements = ui_multiselect("AA", "Anti-aimbot angles", "Elements", {"Watermark", "Hit Logs", "Indicators", "Velocity Warning"}),
        output = ui_multiselect("AA", "Anti-aimbot angles", "Output", {"Console", "Notification"}),
        glow = ui_checkbox("AA", "Anti-aimbot angles", "\v-> \rGlow"),
        glow_rad = ui_slider("AA", "Anti-aimbot angles", "\v-> \rRadius", 1, 10, 4),
        color_1 = ui_new_label("AA", "Anti-aimbot angles", "Start", {175, 175, 175, 255}),
        color_2 = ui_new_label("AA", "Anti-aimbot angles", "End", {175, 175, 175, 255}),
        color_3 = ui_new_label("AA", "Anti-aimbot angles", "Version", {175, 175, 175, 255}),
        color_4 = ui_new_label("AA", "Anti-aimbot angles", "Hitlogs", {255, 81, 81, 255}),
        indicators_type = ui_combobox("AA", "Anti-aimbot angles", "Indicators Type", "Default", "Alternative"),
        main_color = ui_new_label("AA", "Anti-aimbot angles", "\v-> \rMain Color", {255, 81, 81, 255}),
        switch_color = ui_new_label("AA", "Anti-aimbot angles", "\v-> \rSwitch Color", {255, 81, 81, 255}),
        vel_y = ui_slider("AA", "Anti-aimbot angles", "\v-> \rVelocity Y", 1, h-40, 250),
    },
    misc = {
        anim_breaker = ui_multiselect("AA", "Anti-aimbot angles", "Animation breaker", {"Backward legs", "Walking Legs in air", "Freeze legs in air", "Pitch 0"}),
        killsay = ui_checkbox("AA", "Anti-aimbot angles", "Killsay"),
        clantag = ui_checkbox("AA", "Anti-aimbot angles", "Clantag"),
    },
    configs = {
        cfg_list = ui.listbox("AA", "Anti-aimbot angles", 'Cfg List', 'no'),
        cfg_name =  ui.new_textbox("AA", "Anti-aimbot angles", 'Config name'),
        load_btn = ui.button("AA", "Anti-aimbot angles", "Load", function() end),
        save_btn = ui.button("AA", "Anti-aimbot angles", "Save", function() end),
        del_btn = ui.button("AA", "Anti-aimbot angles", "Delete", function() end),
        create_btn = ui.button("AA", "Anti-aimbot angles", "Create", function() end),
        import_cfg = ui.button("AA", "Other", "Import", function() 
            local raw = clipboard.get()
            local s = pcall(function() ui.load(json.parse(base64.decode(raw))) end)
            if s then
            print("Config Imported!")
            else
            print("Invalid Config!")
            end
        end, true, "Imports a config from the clipboard"),
        export_btn = ui.button("AA", "Other", "Export", function() end),
    }
}

local aa_builder = {}

for i=1, #aa_states do
    aa_builder[i] = {
        enable = ui_new_checkbox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rToggle"),
        yaw = ui_combobox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rYaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair", "Flick"),
        yaw_flick_from = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rFrom\n" .. aa_states[i], -180, 180, 0),
        yaw_flick_to = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rTo\n" .. aa_states[i], -180, 180, 0),
        yaw_flick_speed = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rSpeed\n" .. aa_states[i], 1, 100),
        yaw_left = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rLeft\n" .. aa_states[i], -180, 180, 0),
        yaw_right = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rRight\n" .. aa_states[i], -180, 180, 0),
        yaw_jitter = ui_combobox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rYaw Jitter", "Off", "Offset", "Center", "Random", "Skitter", "X-Way"),
        yaw_jitter_slider_r = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \r Right Jitter", -180, 180, 0),
        yaw_jitter_slider_l = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \r Left Jitter", -180, 180, 0),
        sep = ui_new_label("AA", "Anti-aimbot angles", "---------------------\a6BFFA1FFX-Way\r---------------------"),
        x_way_slider = ui_slider("AA", "Anti-aimbot angles", "\nWays" .. aa_states[i], 1, 7, 0, 1, "w"),
        way_1 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF1\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, 90),
        way_2 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF2\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, 180),
        way_3 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF3\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, 0),
        way_4 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF4\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, -90),
        way_5 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF5\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, -180),
        way_6 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF6\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, 0),
        way_7 = ui_slider("AA", "Anti-aimbot angles", "[\a6BFFA1FF7\aCDCDCDFF] Way\n" .. aa_states[i], -180, 180, 90),
        body_yaw = ui_combobox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] ..  ": \rBody yaw", "Off", "Opposite", "Jitter", "Static"),
        bodyyaw_add = ui_slider("AA", "Anti-aimbot angles", "\v" .. aa_states[i] ..  ": \rFake", -180, 180, 0),
        defensive_aa = ui_new_checkbox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rDefensive AA"),
        defensive_pitch = ui_combobox("AA", "Anti-aimbot angles", "Pitch\a00000000" .. aa_states[i], "Off", "Down", "Up", "Random"),
        defensive_yaw = ui_combobox("AA", "Anti-aimbot angles", "Yaw\a00000000" .. aa_states[i], "Inherit", "Offset", "Center", "Random", "Skitter", "Spin"),
        force_defensive = ui_new_checkbox("AA", "Anti-aimbot angles", "Force Defensive\a00000000" .. aa_states[i]),
        anti_brute = ui_new_checkbox("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rAnti-brute"),
        anti_brute_options = ui_multiselect("AA", "Anti-aimbot angles", "\v" .. aa_states[i] .. ": \rOptions", {"Side", "Yaw Offset"}),
    }
end

ui.setup({ui_elements, aa_builder})

local ignored_elements = {
    main_check = true,
    tab = true
}

local aa_refs = {
    leg_movement = ui_reference("AA", "other", "leg movement"),
    main_check = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    aa_yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "body yaw")},
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    freestanding_body = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    doubletap = ui_reference("RAGE", "aimbot", "Double tap"),
    on_shot = ui_reference("AA", "Other", "On shot anti-aim"),
    slow_walk = ui_reference('aa', 'other', 'Slow motion'),
    duck_assist = ui_reference("RAGE", "Other", "Duck peek assist"),
    quickpeek = ui_reference("RAGE", "Other", "Quick peek assist")
}

local hide_elements = {
    leg_movement = ref("AA", "other", "leg movement"),
    main_check = ref("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ref("AA", "Anti-aimbot angles", "Pitch"),
    yaw = {ref("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ref("AA", "Anti-aimbot angles", "Yaw jitter")},
    aa_yaw_base = ref("AA", "Anti-aimbot angles", "Yaw base"),
    body_yaw = {ref("AA", "Anti-aimbot angles", "body yaw")},
    freestanding_body = ref("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    roll = ref("AA", "Anti-aimbot angles", "Roll")
}

local set_visible_func = function()
ui.traverse(ui_elements, function(element, path)
    if not ignored_elements[path[1]] then
    element:depend(ui_elements.main_check, {ui_elements.tab, path[1]})
    end
end)
ui.traverse(aa_builder, function(element, path)
    element:depend(ui_elements.main_check, {ui_elements.tab, "Anti-Aim Builder"}, {ui_elements.builder.state, aa_states[path[1]]})
end)
for i=1, #aa_states do
    local builder = aa_builder[i]
    builder.yaw_flick_from:depend({builder.yaw, "Flick"})
    builder.yaw_flick_to:depend({builder.yaw, "Flick"})
    builder.yaw_flick_speed:depend({builder.yaw, "Flick"})
    builder.yaw_left:depend({builder.yaw, function() return builder.yaw.value ~= "Flick" end})
    builder.yaw_right:depend({builder.yaw, function() return builder.yaw.value ~= "Flick" end})
    builder.x_way_slider:depend({builder.yaw_jitter, "X-Way"})
    builder.sep:depend({builder.yaw_jitter, "X-Way"})
    builder.yaw_jitter_slider_r:depend({builder.yaw_jitter, "X-Way", true})
    builder.yaw_jitter_slider_l:depend({builder.yaw_jitter, "X-Way", true})
    builder.defensive_pitch:depend(builder.defensive_aa)
    builder.defensive_yaw:depend(builder.defensive_aa)
    builder.force_defensive:depend(builder.defensive_aa)
    builder.anti_brute_options:depend(builder.anti_brute)
    
    for h=1, 7 do
        aa_builder[i]["way_" .. h]:depend({builder.yaw_jitter, "X-Way"}, {builder.x_way_slider, function() return builder.x_way_slider.value >= h end})
    end
end
    ui_elements.tab:depend(ui_elements.main_check)
    ui_elements.Extras.avoid_backstab_dist:depend({ui_elements.Extras.options, function() return contains(ui_elements.Extras.options.value, "Avoid backstab") end})
    ui_elements.Extras.reset_time:depend({ui_elements.Extras.options, function() return contains(ui_elements.Extras.options.value, "Reset Anti-bruteforce time") end})
    ui_elements.Extras.freestanding_dis:depend({ui_elements.Extras.options, function() return contains(ui_elements.Extras.options.value, "Freestanding disablers") end})
    ui_elements.visuals.color_1:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Watermark") end})
    ui_elements.visuals.color_2:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Watermark") end})
    ui_elements.visuals.color_3:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Watermark") end})
    ui_elements.visuals.color_4:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Hit Logs") end})
    ui_elements.visuals.output:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Hit Logs") end})
    ui_elements.visuals.glow:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Hit Logs") end})
    ui_elements.visuals.glow_rad:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Hit Logs") end})
    ui_elements.visuals.main_color:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Indicators") end})
    ui_elements.visuals.switch_color:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Indicators") end})
    ui_elements.visuals.indicators_type:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Indicators") end})
    ui_elements.visuals.vel_y:depend({ui_elements.visuals.elements, function() return contains(ui_elements.visuals.elements.value, "Velocity Warning") end})
end
set_visible_func()

local hide_elements_func = function()
    for name, ref in pairs(hide_elements) do
        if type(ref) == "table" then
            for n, r in pairs(ref) do
                ui.set_visible(r, not ui_elements.main_check.value)
            end
        else
        ui.set_visible(ref, not ui_elements.main_check.value)
        end
     end
end

local warning = images.get_panorama_image("icons/ui/warning.svg")
local deftbl = {
    cmd = 0,
    check = 0,
    defensive = 0,
}
client.set_event_callback("run_command", function(arg)
    local ent = entity.get_local_player()
    deftbl.cmd = arg.command_number
    ladder = (entity.get_prop(ent, "m_MoveType") == 9)
end)
client.set_event_callback("predict_command", function(arg)
    if arg.command_number == deftbl.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        deftbl.defensive = math.abs(tickbase - deftbl.check)
        deftbl.check = math.max(tickbase, deftbl.check or 0)
        deftbl.cmd = 0
    end
end)
client.set_event_callback("level_init", function()
    deftbl.check, deftbl.defensive = 0, 0
end)
isdefensive = function()

    if aa_refs.on_shot.value and aa_refs.on_shot.hotkey:get() then
        return
    else
        return (deftbl.defensive > 1 and deftbl.defensive < 14)
    end
end
whiledefensive = function()

    if aa_refs.on_shot.value and aa_refs.on_shot.hotkey:get() then
        return
    else
        return (deftbl.defensive > 1 and deftbl.defensive < 9)
    end
end

local main_funcs = {
delay_air = 0,
in_air = function(self)
    local ent = entity_get_local_player()
    local flag = bit_band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 1)
    if flag == 1 then
        if self.delay_air < 15 then
        self.delay_air = self.delay_air + 1
        end
    else
        self.delay_air = 0
    end 
    return flag == 0 or self.delay_air < 15
end,
create_clantag = function(text)
    local value = {" "}
    for i=1, #text do
        value[#value+1] = text:sub(1, i)
    end

    for i=#value-1, 1, -1 do
        value[#value+1] = value[i]
    end
  return value
end,
blocked_types = {
    ["knife"] = true,
    ["c4"] = true,
    ["grenade"] = true,
    ["taser"] = true
},
is_freezetime = function()
    return entity_get_prop(entity_get_game_rules(), "m_bFreezePeriod") == 1
end,
is_warmup = function()
    return entity_get_prop(entity_get_game_rules(), "m_bWarmupPeriod") == 1
 end,
get_weapon_type = function(_, player)
    local wpn = entity_get_player_weapon(player)
    if wpn == nil then return end
    local wep = weapons[entity_get_prop(wpn, "m_iItemDefinitionIndex")]
    if wep == nil then return end
    return wep.type
end,
def = 0,
crouching_in_air = function(self)
    return self:in_air() and bit.band(entity_get_prop(entity_get_local_player(), "m_fFlags"), 2) == 2
end,
in_move = function(_, e)
   return e.in_forward == 1 or e.in_back == 1 or e.in_moveleft == 1 or e.in_moveright == 1
end,
current_state = 1,
get_aa_state = function(self, e)
    local ent = entity_get_local_player()
    if not ui_elements.main_check.value or not entity_is_alive(ent) then return end
    local state = 1
    local standing = vector(entity_get_prop(ent, "m_vecVelocity")):length2d() < 2
    if not (aa_refs.doubletap.value and aa_refs.doubletap.hotkey:get()) and not (aa_refs.on_shot.value and aa_refs.on_shot.hotkey:get()) and aa_builder[8].enable.value then
    state = 8 
    elseif self:crouching_in_air() and aa_builder[6].enable.value then
    state = 6
    elseif self:in_air() and aa_builder[7].enable.value then
    state = 7
    elseif aa_refs.slow_walk.hotkey:get() and aa_builder[4].enable.value then
    state = 4
    elseif e.in_duck == 1 and aa_builder[5].enable.value then
    state = 5
    elseif self:in_move(e) and aa_builder[3].enable.value then
    state = 3
    elseif standing and aa_builder[2].enable.value then
    state = 2
    end
    self.current_state = state
    local check = state ~= 1 and true or aa_builder[1].enable.value
    return state, check
end,
freestanding_state = function(self, e, index)
    local tbl = {
        ["Air duck"] = function() return self:crouching_in_air() end,
        ["In-Air"] = function() return self:in_air() end,
        ["Slow walk"] = function() return aa_refs.slow_walk.hotkey:get() end,
        ["Moving"] = function() return self:in_move(e) end,
        ["Crouching"] = function() return e.in_duck == 1 end,
        ["Standing"] = function() local ent = entity_get_local_player() return vector(entity_get_prop(ent, "m_vecVelocity")):length2d() < 2 end
    }
    return tbl[index]()
end,
rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end,
lerp = function(_, a, b, t)
    return a + (b - a) * t
end,
clamp = function(_, value, minimum, maximum)
    return math_min( math_max( value, minimum ), maximum )
end,
text_animation = function(self, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 30)
        local color = self.rgba_to_hex(
            self:lerp(color1[1], color2[1], self:clamp(wave, 0, 1)),
            self:lerp(color1[2], color2[2], self:clamp(wave, 0, 1)),
            self:lerp(color1[3], color2[3], self:clamp(wave, 0, 1)),
            color1[4]
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    return final_text
end,
hex_to_rgba = function(hex) return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)), tonumber('0x' .. hex:sub(7, 8)) or 255 end,
hex_color_log = function(self, str)  
    for color_code, message in str:gmatch("(%x%x%x%x%x%x%x%x)([^\aFFFFFFFF]+)") do
        local r, g, b = self.hex_to_rgba(color_code)
        message = message:gsub("\a" .. color_code, "")

        client.color_log(r, g, b, message .. "\0")
    end
    client.color_log(255, 255, 255, " ")
end,
closest_point_on_ray = function(ray_from, ray_to, desired_point)
    local to = desired_point - ray_from
    local direction = ray_to - ray_from
    local ray_length = #direction
    direction = vector(direction.x / ray_length, direction.y / ray_length, direction.z / ray_length)
    local dir = direction.x * to.x + direction.y * to.y + direction.z * to.z
    if dir < 0 then return ray_from end
    if dir > ray_length then return ray_to end
    return vector(ray_from.x + direction.x * dir, ray_from.y + direction.y * dir, ray_from.z + direction.z * dir)
end,
glow_box = function(x, y, w, h, radius, r, g, b, a)
    local rounding = 2
    local rad, a = rounding + 2, a/1.1
    renderer_rectangle(x, y + radius + rad - 2, 1, h - rad * 2 - radius * 2 + 4, r, g, b, a)
    renderer_rectangle(x + w - 1, y + radius + rad - 2, 1, h - rad * 2 - radius * 2 + 4, r, g, b, a)
    renderer_rectangle(x + radius + rad - 4, y + 2, w - rad * 2 - radius * 2 + 8, 1, r, g, b, a)
    renderer_rectangle(x + radius + rad - 4, y + h - 3, w - rad * 2 - radius * 2 + 8, 1, r, g, b, a)
    
    renderer_circle_outline(x+radius+rad-4,y+radius+rad-2,r,g,b,a,radius+rounding-2,180,0.25,1)
    renderer_circle_outline(x+radius+rad-4,y+h-radius-rad+2,r,g,b,a,radius+rounding-2,90,0.25,1)

    renderer_circle_outline(x+w-radius-rad+4,y+radius+rad-2,r,g,b,a,radius+rounding-2,270,0.25,1)
    renderer_circle_outline(x+w-radius-rad+4,y+h-radius-rad+2,r,g,b,a,radius+rounding-2,0,0.25,1)
end,
rectangle_outline = function(x, y, w, h, r, g, b, a, s)
	renderer_rectangle(x, y, w, s, r, g, b, a)
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a)
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
end,
draw_velocity = function(self,modifier,r,g,b,alpha,y)	
	local text_width = renderer_measure_text("b", ("%s %d%%"):format("Slowed down ", modifier*100))
	local x, y = w/2-text_width+15, y
	local iw, ih = warning:measure(nil, 35)
	warning:draw(x-3, y-4, iw+6, ih+6, 16, 16, 16, 255)
	renderer_rectangle(x+13, y+11, 8, 20, 16, 16, 16, 255)
	warning:draw(x, y, nil, 35, r,g,b, alpha)

	renderer_text(x+iw+8, y+3, 255, 255, 255, 255, "b", 0, ("%s %d%%"):format("Slowed down ", modifier*100))
	local rx, ry, rw, rh = x+iw+8, y+3+17, text_width, 12

	self.rectangle_outline(rx, ry, rw, rh, 0, 0, 0, 255, 1)
	renderer_rectangle(rx+1, ry+1, rw-2, rh-2, 16, 16, 16, 180)
	renderer_rectangle(rx+1, ry+1, math_floor((rw-2)*modifier), rh-2, r, g, b, 180)
end
}

local icon = images.load_svg([[<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="360" height="360">
<path d="M0 0 C11.52359356 9.70407879 17.86686456 21.87750405 22.2109375 36 C22.2109375 36.66 22.2109375 37.32 22.2109375 38 C18.66495293 37.42866799 16.02081137 36.50252246 12.8984375 34.75 C8.37100713 32.40799091 3.81304697 30.7573434 -1.0390625 29.25 C-1.71235596 29.03956055 -2.38564941 28.82912109 -3.0793457 28.61230469 C-16.33493724 24.6082674 -30.80368384 24.27234583 -43.51171875 30.2890625 C-55.68467092 37.15585603 -62.99513062 47.45972805 -67.2265625 60.75 C-73.2376925 85.90865186 -66.99294953 111.26804912 -53.7890625 133 C-45.94999132 144.70751412 -36.73879212 154.49070076 -24.7890625 162 C-23.79777344 162.64710938 -22.80648437 163.29421875 -21.78515625 163.9609375 C-4.31921385 174.72507201 16.80107676 180.07609684 37.2109375 181 C38.30535156 181.05285156 39.39976562 181.10570312 40.52734375 181.16015625 C80.30824823 182.11423425 119.51460267 169.7606387 155.16210938 152.96484375 C157.35480481 151.93224933 159.55569742 150.91858789 161.7578125 149.90625 C168.52844647 146.77615503 175.22637879 143.63073551 181.64453125 139.8125 C183.2109375 139 183.2109375 139 185.2109375 139 C185.2109375 141 185.2109375 141 183.91796875 142.33984375 C182.98017578 143.13068359 182.98017578 143.13068359 182.0234375 143.9375 C181.28609375 144.56140625 180.54875 145.1853125 179.7890625 145.828125 C178.93828125 146.54484375 178.0875 147.2615625 177.2109375 148 C176.27765625 148.81984375 175.344375 149.6396875 174.3828125 150.484375 C133.35832301 186.34867569 82.76295437 205.16253605 28.2109375 202 C-1.19459496 199.41027198 -29.80538663 187.45961072 -52.7890625 169 C-53.61905762 168.33701904 -53.61905762 168.33701904 -54.46582031 167.66064453 C-61.95262689 161.62448708 -69.47908854 155.27854785 -75.7890625 148 C-75.7890625 147.34 -75.7890625 146.68 -75.7890625 146 C-76.4490625 146 -77.1090625 146 -77.7890625 146 C-79.42608491 144.14085373 -80.9273558 142.28742488 -82.4140625 140.3125 C-82.85991699 139.72380127 -83.30577148 139.13510254 -83.76513672 138.52856445 C-102.58569654 113.30121999 -114.40613696 83.90213137 -110.1640625 52 C-107.83303339 40.01883637 -103.01403517 28.82662568 -95.7890625 19 C-95.33015625 18.36964844 -94.87125 17.73929688 -94.3984375 17.08984375 C-82.83937586 2.50815392 -63.66898544 -8.64446771 -45.37109375 -11.71875 C-28.76881639 -13.5271675 -13.6507527 -9.78877504 0 0 Z " fill="#FAFAFA" transform="translate(154.7890625,110)"/>
<path d="M0 0 C8.07569769 7.19976223 14.2652201 14.89379676 20 24 C20.5775 24.89332031 21.155 25.78664062 21.75 26.70703125 C27.91938031 36.99447292 31.99802026 50.61361707 29.45703125 62.55078125 C27.237516 70.82797901 23.86663881 75.76869833 16.8046875 80.60546875 C8.76739851 84.60172525 1.25710844 85.41874314 -7.625 85.1875 C-8.62917969 85.17396484 -9.63335937 85.16042969 -10.66796875 85.14648438 C-13.11256864 85.11156152 -15.55597734 85.06252748 -18 85 C-16.23929177 81.19847086 -14.00682657 78.9384896 -11 76 C-4.33211528 69.16070436 0.0091077 61.13008556 0.3125 51.4375 C0.16451888 40.25670414 -5.64142075 30.58146235 -13 22.5 C-29.54312099 6.79496664 -52.21231089 -0.582973 -74.6796875 -0.2109375 C-98.79016583 0.66758195 -120.81785606 12.01470623 -137.36230469 29.20947266 C-155.88166106 49.45708142 -162.17360048 74.28420549 -161.421875 101.06640625 C-160.09799492 128.46998017 -146.90295093 153.09873396 -130.375 174.375 C-129.9318042 174.94621582 -129.4886084 175.51743164 -129.03198242 176.10595703 C-126.7225827 179.020982 -124.33728863 181.7005016 -121.6640625 184.2890625 C-119 187 -119 187 -119 189 C-118.34 189 -117.68 189 -117 189 C-115.74772516 190.47704212 -114.49833478 191.95827399 -113.31640625 193.4921875 C-111.88235909 195.26762944 -111.88235909 195.26762944 -109 197 C-109 197.66 -109 198.32 -109 199 C-108.47535156 199.21398437 -107.95070313 199.42796875 -107.41015625 199.6484375 C-104.04407338 201.53606258 -101.31036066 204.0774428 -98.4375 206.625 C-92.52311005 211.79248966 -86.45734887 216.51939058 -80 221 C-80.66 221.33 -81.32 221.66 -82 222 C-84.58525363 220.85817965 -87.01877285 219.65321873 -89.5 218.3125 C-90.25031494 217.91039307 -91.00062988 217.50828613 -91.77368164 217.09399414 C-104.22899598 210.27565528 -116.24806413 202.28921668 -127 193 C-127.79148438 192.31808594 -128.58296875 191.63617188 -129.3984375 190.93359375 C-155.52091739 167.90131259 -175.44267045 139.70747671 -178.22753906 104.08984375 C-179.93509362 71.14155836 -169.44294817 40.60446485 -147.5625 15.875 C-146.04893503 14.24322792 -144.52826751 12.61801033 -143 11 C-142.32582031 10.26136719 -141.65164062 9.52273437 -140.95703125 8.76171875 C-102.91325028 -31.42336321 -42.12238313 -35.95241725 0 0 Z " fill="#F8F8F8" transform="translate(196,89)"/>
<path d="M0 0 C-1.55603771 3.81936528 -3.95604931 6.26044438 -7 9 C-7.66 9 -8.32 9 -9 9 C-9.27328125 9.59554687 -9.5465625 10.19109375 -9.828125 10.8046875 C-10.96075016 12.92647198 -12.11662872 14.37746836 -13.75 16.125 C-23.26132303 27.05142231 -28.46239461 40.73090206 -28.203125 55.25 C-26.76438266 74.72835789 -14.99956885 90.62803547 -1.3125 103.625 C15.84633367 118.38267613 35.83555831 128.36360646 57 136 C57 136.33 57 136.66 57 137 C25.30055369 141.24542276 -10.1977609 131.78950763 -36 113 C-39.51074455 110.15989768 -42.79546183 107.17905476 -46 104 C-47.299375 102.7625 -47.299375 102.7625 -48.625 101.5 C-49.800625 100.2625 -49.800625 100.2625 -51 99 C-51.59167969 98.3915625 -52.18335937 97.783125 -52.79296875 97.15625 C-68.06596815 80.84929513 -75.94862621 60.5458524 -75.28515625 38.3125 C-74.62847493 25.78335011 -69.99985867 15.32345331 -61.49609375 6.14453125 C-44.34321379 -8.59245012 -20.12807616 -7.15526664 0 0 Z " fill="#FBFBFB" transform="translate(166,148)"/>
<path d="M0 0 C27.49503185 0.88693651 52.75891754 19.05876828 71.0625 38.125 C86.76551114 55.82792293 93.1988003 77.01194411 92.19970703 100.41748047 C91.11322524 114.46736358 85.25649328 127.37183243 75 137 C63.74344613 145.97725167 52.30182064 149.12293466 38 148 C30.92820942 146.26273769 24.64308693 143.0292711 20.5625 136.80859375 C17.33428397 130.94828112 16.15587136 125.6599581 16 119 C16.94359375 118.78085938 17.8871875 118.56171875 18.859375 118.3359375 C30.59437485 115.48936665 43.04504324 111.67351089 51 102 C57.92123372 90.3384027 59.58516626 79.58167378 57.38671875 66.29296875 C53.92468522 52.94812585 47.07451625 41.28215149 38 31 C37.30132812 30.16984375 36.60265625 29.3396875 35.8828125 28.484375 C27.54749377 18.81421875 17.83321511 11.64352921 7.06640625 4.9453125 C4.61097084 3.38759679 2.28886631 1.78835254 0 0 Z " fill="#FAFAFA" transform="translate(196,55)"/>
<path d="M0 0 C19.57213618 15.03437697 35.09210208 34.66927985 39.15234375 59.46484375 C40.11681735 68.89894758 39.00513255 77.72476606 33.52734375 85.65234375 C25.9703504 94.81681491 15.64035382 100.53000656 3.83984375 102.27734375 C2.50953125 102.37015625 2.50953125 102.37015625 1.15234375 102.46484375 C2.23515625 101.47484375 2.23515625 101.47484375 3.33984375 100.46484375 C9.90878441 93.87724133 13.4326405 86.1787859 13.46484375 76.83984375 C13.01447143 54.17900496 -0.07290856 35.37956789 -15.8671875 20.09765625 C-37.03735867 1.39687595 -62.01120033 -6.87156659 -90.06152344 -5.74365234 C-97.17052694 -5.21166067 -103.99859283 -3.42950443 -110.84765625 -1.53515625 C-112.60916016 -1.07302734 -112.60916016 -1.07302734 -114.40625 -0.6015625 C-116.89539146 0.06115159 -119.374352 0.74573326 -121.84765625 1.46484375 C-89.44947553 -32.96569517 -34.87721979 -25.22023928 0 0 Z " fill="#F9F9F9" transform="translate(213.84765625,68.53515625)"/>
<path d="M0 0 C18.79550238 2.21389331 34.5553899 13.08231971 46.71875 27.08203125 C62.14621547 46.81545027 68.40734017 69.25805183 67 94 C65.52651293 104.87131802 61.50350217 113.68373799 52.90625 120.62890625 C46.43189318 125.28566699 39.36078807 125.36480826 31.75 124.1875 C28.13975034 123.56552694 25.19747754 122.8042909 22 121 C23.3932248 117.93353953 25.07090044 115.61950647 27.25 113.0625 C37.81560159 99.52532297 41.53323291 82.14988942 39.56640625 65.28125 C36.04254486 39.72655275 21.88042477 19.0976801 2 3 C1.34 2.67 0.68 2.34 0 2 C0 1.34 0 0.68 0 0 Z " fill="#F9F9F9" transform="translate(250,74)"/>
<path d="" fill="#989898" transform="translate(0,0)"/>
<path d="" fill="#979797" transform="translate(0,0)"/>
</svg>
]])

local notification = (function(self)
    local notification = {}
    local notif = {callback_created = false, max_count = 5}
    notif.register_callback = function(self)
    if self.callback_created then return end
    local screen_x, screen_y = client_screen_size()
    local pos = {x = screen_x / 2, y = screen_y / 1.2}
    client_set_event_callback("paint_ui", function()
    local extra_space = 0
    for i = #notification, 1, -1 do
    local data = notification[i]
    if data == nil then return end
    if data.alpha < 1 and data.real_time + data.time < globals_realtime() then
        table.remove(notification, i)
    else
        data.alpha = main_funcs:lerp(data.alpha, data.real_time + data.time - 0.1 < globals_realtime() and 0 or 255, 4 * globals_frametime())
        if data.alpha <= 120 then
            data.move = data.move - 0.2
        end
        local text_size_x, text_size_y = renderer_measure_text(nil, data.text)
        local col = data.color
        local img_w, img_h = 35, 36
        local x, y = pos.x-text_size_x/2-img_w/2, pos.y-data.move-extra_space
        local smooth_location = math.floor(data.alpha + .5)/255
        if data.glow then
            for i=1, ui_elements.visuals.glow_rad:get() do main_funcs.glow_box(x - i, y - i, text_size_x+img_w+5 + i * 2, img_h/2+7 + i * 2, i, col[1], col[2], col[3], (60 - 6 * i) * (data.alpha / 340)) end
        end
        renderer_rectangle(x, y, text_size_x+img_w+5, img_h/2+7, 20, 20, 20, data.alpha/1.3)    
        renderer_rectangle(x+img_w-7, y, 2, img_h/2+7, 100, 100, 100, data.alpha/2)
        renderer_rectangle(x, y, 2, (img_h/2+7)*smooth_location, col[1], col[2], col[3], data.alpha)
        icon:draw(x+7, y+4, nil, 18, col[1], col[2], col[3], data.alpha)
        renderer.text(x+img_w, y+6, 255, 255, 255, data.alpha, nil, 0, data.text)
        extra_space = extra_space + math.floor(data.alpha/255 * (text_size_y + 23) + .5)
    end
    end
    end)
    self.callback_created = true
    end
    notif.add = function(self, t, txt)
        for i = self.max_count, 2, -1 do notification[i] = notification[i - 1] end
        local col = ui_elements.visuals.color_4.color.value
        notification[1] = {alpha = 0, text = txt, real_time = globals_realtime(), time = t, move = 0, color = col, glow = ui_elements.visuals.glow.value}
        self:register_callback()
    end
    return notif
end)()

local restore_ui = {}
local function restore_func()
for k, v in pairs(restore_ui) do
ui_set(k.ref, v)
end
restore_ui = {}
end

local function closest_target()
    local ent = entity_get_local_player()
    if not ui_elements.main_check.value or not entity_is_alive(ent) then
        return
    end
    local threat = client_current_threat()
    if threat ~= nil and not entity_is_dormant(threat) then return threat end
    local players = entity_get_players(true)
    local closest_pl
    local last_dist = 0
    local ent_pos = vector(entity_get_prop(ent, "m_vecOrigin"))
    for i, player in pairs(players) do
        local pl_pos = vector(entity_get_prop(player, "m_vecOrigin"))
        local dist = ent_pos:dist(pl_pos)
        if last_dist <= 0 then
            closest_pl = player
            last_dist = dist
        end
        if dist < last_dist then
            last_dist = dist
            closest_pl = player
        end
    end
    return closest_pl
end

local avoid_active = false
local function avoid_backstab_func()
local ent = entity_get_local_player()
if not contains(ui_elements.Extras.options.value, "Avoid backstab") or not entity_is_alive(ent) then avoid_active = false return end
local target = closest_target()
if target == nil then
   restore_func()
   avoid_active = false
   return
end
local ent_pos = vector(entity_get_prop(ent, "m_vecAbsOrigin"))
local wpn_type = main_funcs:get_weapon_type(target)
local pl_pos = vector(entity_get_prop(target, "m_vecAbsOrigin"))
local distance = ent_pos:dist(pl_pos)
if ent_pos ~= nil and pl_pos ~= nil and wpn_type ~= nil and wpn_type == "knife" and distance <= ui_elements.Extras.avoid_backstab_dist.value then
if aa_refs.yaw[1].value ~= "Off" then
restore_ui[aa_refs.yaw[2]] = aa_refs.yaw[2].value
aa_refs.yaw[2]:override(180)
avoid_active = true
end
else
restore_func()
avoid_active = false
end
end

local freestanding_disablers = function(e)
if not contains(ui_elements.Extras.options.value, "Freestanding disablers") then aa_refs.freestanding[1]:override() return end
local options = ui_elements.Extras.freestanding_dis.value
local enabled = true
for k, v in pairs(options) do
local check = main_funcs:freestanding_state(e, v)
if check then enabled = false break end
end
aa_refs.freestanding[1]:override(enabled)
end

local function animation_breaker()
local ent = entity_get_local_player()
if not ui_elements.main_check.value or #ui_elements.misc.anim_breaker.value <= 0 or not entity_is_alive(ent) then return end
local _ent = _entity.get_local_player()
if contains(ui_elements.misc.anim_breaker.value, "Walking Legs in air") and main_funcs:in_air() then
    local anim = _ent:get_anim_overlay(6)
    if not anim then return end
    anim.weight = 1
end
if contains(ui_elements.misc.anim_breaker.value, "Backward legs") then
aa_refs.leg_movement:set("Always Slide")
entity_set_prop(ent, "m_flPoseParameter", 1, 0)
end
if contains(ui_elements.misc.anim_breaker.value, "Freeze legs in air") and main_funcs:in_air() then
entity_set_prop(ent, "m_flPoseParameter", 1, 6) 
end
if contains(ui_elements.misc.anim_breaker.value, "Pitch 0") then
    local anim_state = _ent:get_anim_state()
    if not anim_state.hit_in_ground_animation or main_funcs:in_air() then 
        return 
    end
    entity_set_prop(ent, "m_flPoseParameter", 0.5, 12)
end
end

local clantag, prev_tag = main_funcs.create_clantag("Ocean.Tech ")
local clantag_func = function()
if not ui_elements.misc.clantag.value then return end
local ent = entity_get_local_player()
local ly = client_latency()
local tickcount = globals_tickcount() + toticks(ly)
local sw = math_floor(tickcount / toticks(0.3))
local tag_cur = clantag[sw % #clantag+1]
if tag_cur ~= prev_tag then
    client_set_clan_tag(tag_cur)
end
prev_tag = tag_cur
end

local function clantag_change()
if ui_elements.misc.clantag.value then return end
    client_set_clan_tag()
end

local killsay_mes = {
    'Schade, dass du nicht länger dabei sein konntest. Besser Glück beim nächsten Mal!',
    'Du hast dich tapfer geschlagen, aber gegen mich gibt es kein Entkommen!',
    'Ich habe gerade deinen Highscore eingestellt. Kannst du ihn überbieten?',
    'Danke für den Unterhaltungswert! Du hast das Spiel auf jeden Fall aufgewürzt.',
    'Du warst ein würdiger Gegner. Ich fühle mich geehrt, dich besiegt zu haben.',
    'Tut mir leid, dass ich dich auf die harte Tour aussortieren musste. Ich konnte einfach nicht widerstehen.',
    'Dein Spiel war beeindruckend, aber ich habe die Oberhand behalten. Gut gespielt!',
    'Ich hoffe, du hast etwas aus dieser Niederlage gelernt. Bleib dran und werde stärker!',
    'Dein Widerstand war bewundernswert, aber am Ende triumphiert die Stärke!',
    'Ich werde dir eine Autogrammkarte schicken, um deine Teilnahme an meinem legendären Sieg zu würdigen.',
    'Du hast es geschafft, mein Adrenalin in die Höhe zu treiben. Danke für die Spannung!',
    'Ich hoffe, du hast eine Versicherung gegen Schamverlust, denn ich habe dich gerade demütig geschlagen.',
    'Ich habe dich nach allen Regeln der Kunst besiegt. Vielleicht sollten wir eine Revanche planen?',
    'Du warst ein Hindernis auf meinem Weg zum Sieg, aber ich habe es genossen, dich zu überwinden.',
    'Dein Spiel war wie ein Feuerwerk: spektakulär, aber schnell vorbei.',
    'Du kannst stolz darauf sein, dass du Teil meiner glorreichen Siegesserie warst.',
    'Ich hoffe, du hast ein Notizbuch, um all die Lektionen festzuhalten, die ich dir gerade erteilt habe.',
    'Danke, dass du mir gezeigt hast, wie ein richtiger Verlierer aussieht. Bleib bescheiden!',
    'Ich habe schon bessere Gegner gesehen... in meinen Albträumen!',
    'Es ist eine Schande, dass du so schnell eliminiert wurdest. Aber hey, das Leben ist hart!',
    'Du warst wie ein Sandkorn im Getriebe meines Siegeszuges. Leider hat es nicht gereicht.',
    'Deine Strategie war beeindruckend, aber meine war unbesiegbar.',
    'Dein Versuch war tapfer, aber gegen meine Überlegenheit chancenlos.',
    'Beeindruckend, wie du dich selbst in jeder Runde übertreffen konntest... mit Niederlagen!',
    'Keine Sorge, ich habe ein Plätzchen in meiner Trophäensammlung für dich freigehalten.',
    'Deine Anstrengungen verdienen eine Auszeichnung für den besten letzten Platz.',
    'Danke, dass du mich zum Lachen gebracht hast. Es war köstlich, dich zu eliminieren!',
    'Du hast das Spiel mit Stil verlassen. Ich hoffe, du lernst daraus und kommst stärker zurück.',
    'Ich habe dich gerade auf den Ehrenplatz der Verliererliste gesetzt. Genieße den Ruhm!',
    'Keine Sorge, es ist nicht persönlich. Ich eliminiere einfach nur gerne meine Gegner.',
    'Du hast mich dazu gebracht, mein Bestes zu geben. Es war ein aufregendes Duell!',
    'Dein Ausscheiden war unvermeidlich, aber ich schätze deinen Einsatz!',
    'Du hast dich nicht gerade mit Ruhm bekleckert, aber zumindest hast du versucht.',
    'Dein Schicksal lag in meinen Händen, und ich habe es mit Freude besiegelt.',
    'Ich wusste nicht, dass ich gegen kleine Kätzchen spiele. Du warst zu einfach zu besiegen!',
    'Du hast den Geschmack der Niederlage probiert. Wie hat es geschmeckt?',
    'Wenn das Leben ein Spiel ist, dann bist du ein Meister darin, zu verlieren.',
    'Schon bald wirst du Geschichten über meinen epischen Sieg erzählen können. Sei dankbar!',
    'Es war eine Freude, dich zu besiegen. Die nächste Runde geht auf mich!',
    'Deine Strategie hatte so viel Potenzial, aber leider nicht gegen mich.',
    'Du hast gerade eine Meisterklasse im Verlieren erlebt. Nimm es als Lehre!',
    'Du hast dein Bestes gegeben, und das ist mehr, als ich von dir erwartet hätte.',
    'Ich habe gerade einen Weltrekord aufgestellt: Die meisten Siege gegen dich!',
    'Du kannst immer noch ein großartiger Verlierer sein. Arbeitest du daran?',
    'Ich bin froh, dass du an meiner Seite standest, um meinen glorreichen Sieg zu bezeugen.',
    'Du warst eine willkommene Abwechslung von den schwierigen Gegnern. Danke dafür!',
    'Ich bin beeindruckt, wie schnell du dich eliminieren lassen konntest. Bist du Profi?',
    'Es tut mir leid, dass ich dich nicht länger leiden lassen konnte. Vielleicht beim nächsten Mal!',
    'Ich habe gerade einen neuen Rekord aufgestellt: Die meisten Tränen von besiegten Gegnern!',
    'Deine Niederlage wird in die Geschichte eingehen. Mach das Beste daraus!'
}

local death_say = {
    'Verdammt, das war knapp!',
    'Ich werde es beim nächsten Mal besser machen.',
    'Na toll, das war ein Reinfall.',
    'Ich hätte das vermeiden können.',
    'Das war nicht fair!',
    'Ich hätte mich besser konzentrieren sollen.',
    'Verdammt, ich habe es wieder vermasselt!',
    'Das ist nicht mein Tag.',
    'Ich kann es nicht fassen, wie schlecht ich bin.',
    'Das war ein schwerer Fehler.',
    'Okay, ich gebe zu, das war nicht mein bester Moment.',
    'Ich muss meine Taktik überdenken.',
    'Das war ein harter Kampf.',
    'Ich bin einfach nicht gut genug.',
    'Ich habe es versucht, aber es hat nicht geklappt.',
    'Ich sollte vorsichtiger sein.',
    'Ich hätte besser aufpassen sollen.',
    'Das war ein dummer Fehler von mir.',
    'Ich muss meine Strategie ändern.',
    'Das war ein blödes Missgeschick.',
    'Ich habe es nicht kommen sehen.',
    'Ich war zu unvorsichtig.',
    'Ich sollte mehr üben.',
    'Das war ein teurer Fehler.',
    'Ich hätte geduldiger sein sollen.',
    'Ich habe es verkackt.',
    'Ich habe mich zu sehr ablenken lassen.',
    'Das war ein krasser Fehler.',
    'Ich habe den Überblick verloren.',
    'Ich war zu übermütig.',
    'Ich sollte mich besser vorbereiten.',
    'Ich habe es einfach nicht drauf.',
    'Das war ein totaler Reinfall.',
    'Ich war zu risikofreudig.',
    'Ich sollte besser auf meine Gesundheit achten.',
    'Das war ein großer Rückschlag.',
    'Ich muss meine Reflexe trainieren.',
    'Ich war zu langsam.',
    'Ich hätte besser ausweichen sollen.',
    'Ich habe den Gegner unterschätzt.',
    'Das war ein peinlicher Fehler.',
    'Ich habe die Kontrolle verloren.',
    'Ich sollte mich besser konzentrieren.',
    'Das war ein schwerwiegender Fehler.',
    'Ich hätte geduldiger sein sollen.',
    'Ich war zu ungeschickt.',
    'Ich habe nicht aufgepasst.',
    'Ich habe den Moment verpasst.',
    'Ich sollte besser auf meine Umgebung achten.',
    'Das war ein herber Rückschlag.'
}

local function killsay_func(e)
    if not ui_elements.misc.killsay.value then return end
    local ent = entity_get_local_player()
    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end
    local attacker_entindex = client_userid_to_entindex(attacker_userid)
    local victim_entindex = client_userid_to_entindex(victim_userid)
    if attacker_entindex ~= ent or not entity_is_enemy(victim_entindex) then 
        return
     end
    client_exec("say " .. killsay_mes[client_random_int(1, #killsay_mes)])
end

local watermark_func = function()
if not contains(ui_elements.visuals.elements.value, "Watermark") then return end
local x = renderer_measure_text(nil, "   O C E A N . T E C H")
local start, en, ver_color = ui_elements.visuals.color_1.color.value, ui_elements.visuals.color_2.color.value, ui_elements.visuals.color_3.color.value
local text = main_funcs:text_animation(5, start, en, "   O C E A N . T E C H")
renderer_text(5, h/2, 255, 255, 255, 255, nil, 0, text)
renderer_text(x + 7, h/2, ver_color[1], ver_color[2], ver_color[3], ver_color[4], nil, 0, "[" .. ver .. ']')
end

local function rgb_based(p)
	local r = 124*2 - 124 * p
	local g = 195 * p
	local b = 13
	return r, g, b
end

local velocity_warning = function()
if not contains(ui_elements.visuals.elements.value, "Velocity Warning") then return end
local ent = entity_get_local_player()
local modifier = entity_get_prop(ent, "m_flVelocityModifier") or 1
local r, g, b = rgb_based(modifier)
local menu = ui_is_menu_open()
local y = ui_elements.visuals.vel_y.value
if modifier == 1 then if menu then main_funcs:draw_velocity(0.5, 255, 255, 255, 255, y) end return end
local a = 255*math_abs(globals_curtime()*3 % 2 - 1)
main_funcs:draw_velocity(modifier, r, g, b, a, y)
end

local tbl_data = {}
setmetatable(tbl_data, {__index = function(...) return ... end})
local current_stage = 1
local aa_builder_func = function(e)
if not ui_elements.main_check.value or avoid_active then return end
if contains(ui_elements.Extras.options.value, "Disable AA during Warmup") and main_funcs:is_warmup() then
    aa_refs.pitch:override("off")
    aa_refs.aa_yaw_base:override("Local view")
    aa_refs.yaw[1]:override("off")
    aa_refs.body_yaw[1]:override("Off")
    return
end
local state, check = main_funcs:get_aa_state(e)
local builder_state = aa_builder[state]
if not builder_state.enable.value or not check then return end
local ticks = globals_tickcount()
local yaw_jitter = builder_state.yaw_jitter.value
if yaw_jitter == "X-Way" and ticks % 3 > 1 then
    local max_value = builder_state.x_way_slider.value
    if max_value <= 1 then return end
    current_stage = current_stage + 1
    if current_stage > max_value then current_stage = 1 end
end
if builder_state.defensive_aa.value and builder_state.force_defensive.value then e.force_defensive = true end
if builder_state.defensive_aa.value and isdefensive() then
    aa_refs.pitch:override(builder_state.defensive_pitch.value) 
    if builder_state.defensive_yaw.value == "Spin" then
        spincheck = true
        aa_refs.yaw_jitter[1]:override("Off")
        aa_refs.yaw[1]:override("Spin")
    else
        if builder_state.force_defensive.value then

        else

            aa_refs.yaw_jitter[1]:override(builder_state.defensive_yaw.value == "Inherit" and yaw_jitter or builder_state.defensive_yaw.value)
            spincheck = false
        end
    end
else
    
    if builder_state.defensive_yaw.value == "Spin" and whiledefensive()then 

    else
        spincheck = false
        aa_refs.pitch:override("Down")
        aa_refs.yaw_jitter[1]:override(yaw_jitter == "X-Way" and "Center" or yaw_jitter)
    end
    
end

aa_refs.aa_yaw_base:override("At targets")
aa_refs.yaw[1]:override(builder_state.yaw.value == "Flick" and "180" or builder_state.yaw.value)
local offset = type(tbl_data[state].yaw_offset) ~= "number" and 0 or tbl_data[state].yaw_offset
if yaw_jitter == "X-Way" then
    aa_refs.yaw[2]:override(yaw_jitter == "X-Way" and aa_builder[state]["way_" .. current_stage].value+offset)
else
    local yaw_val
    if builder_state.yaw.value == "Flick" then
       yaw_val = globals_tickcount() % 10 > 5*(builder_state.yaw_flick_speed.value/100) and builder_state.yaw_flick_from.value or builder_state.yaw_flick_to.value
    else
       yaw_val = anti_aims.get_desync(1) <= 0 and builder_state.yaw_right.value or builder_state.yaw_left.value
    end
    if spincheck then
        aa_refs.yaw[2]:override(70)
        aa_refs.yaw[1]:override("Spin")
    else
        aa_refs.yaw[2]:override(yaw_val+offset)
    end
end
local yaw_jit = anti_aims.get_desync(1) <= 0 and builder_state.yaw_jitter_slider_r.value or builder_state.yaw_jitter_slider_l.value
aa_refs.yaw_jitter[2]:override(yaw_jit)
aa_refs.body_yaw[1]:override(builder_state.body_yaw.value)
aa_refs.body_yaw[2]:override(tbl_data[state].swap == true and -builder_state.bodyyaw_add.value or builder_state.bodyyaw_add.value)
end

local indicator_tbl = {
    {
        value = false,
        custom_name = '',
        custom_color = {255, 255, 255},
        alpha = 0
    },
    {
        reference = ui_reference("RAGE", "aimbot", "Double tap").hotkey,
        custom_name = "DT",
        custom_color = {255, 255, 255},
        alpha = 0
    },
    {
        reference = ui_reference('aa', 'other', 'On shot anti-aim').hotkey,
        custom_name = 'ON-SHOT',
        custom_color = {170, 255, 100},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'aimbot', 'Force safe point'),
        custom_name = 'SAFE',
        custom_color = {241, 218, 255},
        alpha = 0
    },
    {
        reference = ui_reference('rage', 'aimbot', 'Force body aim'),
        custom_name = 'BAIM',
        custom_color = {255, 255, 255},
        alpha = 0
    },

    {
        reference = ui_reference('rage', 'other', 'Duck peek assist'),
        custom_name = 'DUCK',
        custom_color = {240, 240, 240},
        alpha = 0
    },
    {
        reference = ui_reference('aa', 'anti-aimbot angles', 'Freestanding').hotkey,
        custom_name = 'FS',
        custom_color = {240, 240, 240},
        alpha = 0
    },
}

local func = function() end
local function func_switcher(v)
  return setmetatable({v}, {
    __call = function (tbl, func)
      local check = #tbl == 0 and  {} or tbl[1]
      return (func[check] or func[func] or {})(check)
    end
 })
end

local function doubletap_charged()
    if not aa_refs.doubletap.value or not aa_refs.doubletap.hotkey:get() or aa_refs.duck_assist:get() then return end    
    local me = entity_get_local_player()
    if me == nil or not entity_is_alive(me) then return end
    local weapon = entity_get_prop(me, "m_hActiveWeapon")
    if weapon == nil then return end
    local next_attack = entity_get_prop(me, "m_flNextAttack")
    local next_primary_attack = entity_get_prop(weapon, "m_flNextPrimaryAttack")
    if next_attack == nil or next_primary_attack == nil then return end
    next_attack = next_attack + 0.25
    next_primary_attack = next_primary_attack + 0.5
    return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
end

local extra_x = 28
local center = { w/2,h/2 }
local text_flags = "c-"
local indicators_func = function()
    local ent = entity_get_local_player()
    if not contains(ui_elements.visuals.elements.value, "Indicators") or not entity_is_alive(ent) then return end
     local extra_space = 18
     local r, g, b, a = ui_elements.visuals.main_color.color:get()
     local r1, g1, b1, a1 = ui_elements.visuals.switch_color.color:get()
     local scoped = entity_get_prop(ent, "m_bIsScoped") == 1
     extra_x = main_funcs:lerp(extra_x, scoped and 28 or 0, 9 * globals_frametime())
     func_switcher(ui_elements.visuals.indicators_type.value) {
     ["Default"] = function()
     local desync = anti_aims.get_desync(1) <= 0
     local hex, hex2 = main_funcs.rgba_to_hex(r, g, b, a), main_funcs.rgba_to_hex(r1, g1, b1, a1)
     renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, a, "cb-", 0, main_funcs:text_animation(5, {r,g,b,a}, {r1,g1,b1,a1}, "Ocean.Tech"))
     extra_space = extra_space + 9
     indicator_tbl[1].value = false
     indicator_tbl[2].custom_color = {main_funcs:lerp(indicator_tbl[2].custom_color[1], doubletap_charged() and r or 230, 9 * globals_frametime()), main_funcs:lerp(indicator_tbl[2].custom_color[2], doubletap_charged() and g or 43, 9 * globals_frametime()), main_funcs:lerp(indicator_tbl[2].custom_color[3], doubletap_charged() and b or 39, 9 * globals_frametime())}

     for k, v in pairs(indicator_tbl) do
     local check = v.reference ~= nil and v.reference:get() or v.value
     if not check then if v.alpha > 0 then v.alpha = main_funcs:lerp(v.alpha, -0.1, 6 * globals_frametime()) end if v.alpha <= 0 then goto continue end end
     local r, g, b = unpack(v.custom_color)
     if check then v.alpha = main_funcs:lerp(v.alpha, 1.1, 9 * globals_frametime()) if v.alpha >= 1 then v.alpha = 1 end end
     local text_x = renderer_measure_text(text_flags, v.custom_name)
     renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, v.alpha*255, text_flags, (text_x*v.alpha)+1, v.custom_name)
     extra_space = extra_space + math.floor(8 * v.alpha + .5)
     ::continue::
     end
    end,
    ["Alternative"] = function()
        renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, a, "c-", 0, main_funcs:text_animation(5, {r,g,b,a}, {r1,g1,b1,a1}, "O C E A N . T E C H"))
        extra_space = extra_space + 9
        indicator_tbl[1].value = true
        indicator_tbl[1].custom_name = indicator_names[main_funcs.current_state]:upper()
        indicator_tbl[1].custom_color = {r, g, b}
        indicator_tbl[2].custom_color = {main_funcs:lerp(indicator_tbl[2].custom_color[1], doubletap_charged() and 255 or 230, 9 * globals_frametime()), main_funcs:lerp(indicator_tbl[2].custom_color[2], doubletap_charged() and 255 or 43, 9 * globals_frametime()), main_funcs:lerp(indicator_tbl[2].custom_color[3], doubletap_charged() and 255 or 39, 9 * globals_frametime())} 
        

        for k, v in pairs(indicator_tbl) do
        local check = v.reference ~= nil and v.reference:get() or v.value
        if not check then if v.alpha > 0 then v.alpha = main_funcs:lerp(v.alpha, -0.1, 6 * globals_frametime()) end if v.alpha <= 0 then goto continue end end
        local r, g, b = unpack(v.custom_color)
        if check then v.alpha = main_funcs:lerp(v.alpha, 1.1, 9 * globals_frametime()) if v.alpha >= 1 then v.alpha = 1 end end
        local text_x = renderer_measure_text(text_flags, v.custom_name)
        renderer_text(center[1] + extra_x, center[2] + extra_space, r, g, b, v.alpha*255, text_flags, (text_x*v.alpha)+1, v.custom_name)
        extra_space = extra_space + math.floor(8 * v.alpha + .5)
        ::continue::
        end
       end,
    }
end

local console_log = function(r, g, b, text)
    client.color_log(158, 158, 158, "[Ocean.Tech] \0")
	main_funcs:hex_color_log(text)
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local aim_fire_data = {}
local function aim_fire(e)
if not ui_elements.main_check.value or not contains(ui_elements.visuals.elements.value, "Hit Logs") then return end
aim_fire_data[e.id] = {
aimed_hitbox = hitgroup_names[e.hitgroup + 1] or '?',
pred_dmg = e.damage,
bt = e.backtrack
}
end


local function aim_hit(e)
if not ui_elements.main_check.value or not contains(ui_elements.visuals.elements.value, "Hit Logs") or aim_fire_data[e.id] == nil then return end
local name = (entity_get_player_name(e.target)):lower()
local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
local health = entity_get_prop(e.target, 'm_iHealth')
local r, g, b = ui_elements.visuals.color_4.color:get()
local hex = ("%02X%02X%02XFF"):format(r, g, b)
local hitchance = math_floor(e.hit_chance + 0.5)
local data = aim_fire_data[e.id]
if contains(ui_elements.visuals.output.value, "Console") then
    console_log(r, g, b, ("\a%sHurt\aFFFFFFFF %s in \a%s%s\aFFFFFFFF for \a%s%i\aFFFFFFFF damage (hp: \a%s%i\aFFFFFFFF, bt: \a%s%i\aFFFFFFFF,  hc: \a%s%i\aFFFFFFFF)"):format(hex, name, hex, hitgroup, hex, e.damage, hex, health, hex, data.bt, hex, hitchance))
end
if not contains(ui_elements.visuals.output.value, "Notification") then return end
notification:add(5, ("Hit %s in %s for %i damage (%i health remaining)"):format(name, hitgroup, e.damage, health))
end

local reason = {
    ["?"] = "resolver"
}

local function aim_miss(e)
if not ui_elements.main_check.value or not contains(ui_elements.visuals.elements.value, "Hit Logs") or aim_fire_data[e.id] == nil then return end
local name = (entity_get_player_name(e.target)):lower()
local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
local hitchance = math_floor(e.hit_chance + 0.5)
local data = aim_fire_data[e.id]
local r, g, b = ui_elements.visuals.color_4.color:get()
local hex = ("%02X%02X%02XFF"):format(r, g, b)
if contains(ui_elements.visuals.output.value, "Console") then
    console_log(r, g, b, ("\a%sMissed\aFFFFFFFF %s's \a%s%s\aFFFFFFFF due to \a%s%s\aFFFFFFFF (dmg: \a%s%i\aFFFFFFFF, bt: \a%s%i\aFFFFFFFF, hc: \a%s%i\aFFFFFFFF)"):format(hex, name, hex, data.aimed_hitbox, hex, reason[e.reason] ~= nil and reason[e.reason] or e.reason, hex, data.pred_dmg, hex, data.bt, hex, hitchance))
end
if not contains(ui_elements.visuals.output.value, "Notification") then return end
notification:add(5, ("Missed shot at %s due to %s (aimed: %s, %ihp, bt=%i, hc=%i)"):format(name, e.reason, data.aimed_hitbox, data.pred_dmg, data.bt, hitchance))
end

local weapon_to_verb = { hegrenade = "Naded", inferno = "Burned"}
local function player_hurt(e)
local id = client_userid_to_entindex(e.attacker)
local ent = entity_get_local_player()
if not ui_elements.main_check.value or not contains(ui_elements.visuals.elements.value, "Hit Logs") or id == nil or id ~= ent then return end
local hitgroup = hitgroup_names[e.hitgroup + 1] or '?'
if hitgroup ~= "generic" or weapon_to_verb[e.weapon] == nil then return end
local target = client_userid_to_entindex(e.userid)
local name = (entity_get_player_name(target)):lower()
local r, g, b = ui_elements.visuals.color_4.color:get()
local hex = ("%02X%02X%02XFF"):format(r, g, b)
if contains(ui_elements.visuals.output.value, "Console") then
    console_log(r, g, b, ("\a%s%s\aFFFFFFFF %s for \a%s%i\aFFFFFFFF damage (hp: \a%s%i\aFFFFFFFF)"):format(hex, weapon_to_verb[e.weapon], name, hex, e.dmg_health, hex, e.health))
end
if not contains(ui_elements.visuals.output.value, "Notification") then return end
notification:add(5, ("%s %s for %i damage (%ihp remaining)"):format(weapon_to_verb[e.weapon], name, e.dmg_health, e.health))
end

local function reset_anti_brute(state)
    notification:add(5, "Switched anti-bruteforce due to reset")
    tbl_data[state] = {}
end    

local last_shot_t = globals_curtime()
local anti_brute_func = function(e)
local ent = entity_get_local_player()
local tick = globals_curtime()
local state, check = main_funcs:get_aa_state(e)
if not ui_elements.main_check.value or not entity_is_alive(ent) or not aa_builder[state].enable.value or not check or not aa_builder[state].anti_brute.value or #aa_builder[state].anti_brute_options.value <= 0 or last_shot_t+1 > tick then return end
local user = e.userid
if user == nil then return end
local shooter = client_userid_to_entindex(user)
if entity_is_dormant(shooter) or not entity_is_enemy(shooter) then return end
local bullet_impact = vector(e.x, e.y, e.z)
local eye_pos = vector(entity_get_prop(shooter, "m_vecOrigin"))
eye_pos.z = eye_pos.z + entity_get_prop(shooter, "m_vecViewOffset[2]")
if not eye_pos then
    return
end
local local_eye_pos = vector(client.eye_position())
if not local_eye_pos then
    return
end
local distance = main_funcs.closest_point_on_ray(eye_pos, bullet_impact, local_eye_pos):dist(local_eye_pos)
if distance < 100 then
    last_shot_t = globals_curtime()
    if contains(aa_builder[state].anti_brute_options.value, "Side") then tbl_data[state].swap = type(tbl_data[state].swap) ~= "boolean" and true or not tbl_data[state].swap end
    local num = contains(aa_builder[state].anti_brute_options.value, "Yaw Offset") and client_random_int(-7, 7) or 0
    tbl_data[state].yaw_offset = num
    if tbl_data[state].f_called ~= true then
        if contains(ui_elements.Extras.options.value, "Reset Anti-bruteforce time") then client_delay_call(ui_elements.Extras.reset_time.value/10, reset_anti_brute, state) end
        tbl_data[state].f_called = true
    end
    notification:add(5, "Switched anti-bruteforce due to enemy shot")
end
end
local reset_on_round_start = function()
    notification:add(5, "Switched anti-bruteforce due to round start")
    tbl_data = {}
    setmetatable(tbl_data, {__index = function(...) return ... end})
end

local cfg_manager = function(tbl)
    ui_elements.configs.cfg_list:update(tbl)
end
 
local error_func = function()
    print("If this error continues to popup please contact the staff")
end

local config_data = database.read("Ocean_Tech_cfgs") or {}
local list_tbl = {}

local config_system = {
    get_cfg_list = function()
        local update_tbl = {}
        for _, data in pairs(cfg_tbl) do
            table.insert(update_tbl, data.name)
            data.data = json.parse(base64.decode(data.data))
        end
        xpcall(function() for name, data in pairs(config_data) do table.insert(update_tbl, name) end end, error_func)

        cfg_manager(update_tbl)
        list_tbl = update_tbl
    end,
    create_btn_callback = function()
        local name = ui_elements.configs.cfg_name:get()
        if #name <= 0 then print("Can't use an empty name!") return end
        if config_data[name] ~= nil then print("Config with this name already exists!") return end
        
        local list, cfg = list_tbl, ui.save()
        list[#list+1] = name
        config_data[name] = cfg
        database.write("Ocean_Tech_cfgs", config_data)
        cfg_manager(list)
    end,
    save_btn_callback = function()
        local list, selected = list_tbl, ui_elements.configs.cfg_list:get()+1
        local sel_name = list[selected]
        if selected > #cfg_tbl then
            config_data[sel_name] = ui.save()
            database.write("Ocean_Tech_cfgs", config_data)
            print("Config Saved!")
        else
            print("Can't save into a built-in cfg!")
        end
        cfg_manager(list)
    end,
    load_btn_callback = function()
        local selected = ui_elements.configs.cfg_list:get()+1
        local sel_name = list_tbl[selected]
        local s = pcall(function()
            if selected <= #cfg_tbl then
                ui.load(cfg_tbl[selected].data)
            else
                ui.load(config_data[sel_name])
            end
        end)
        if s then
            print("Config Loaded!")
        else
            print("This config is broken!")
        end
    end,
    del_btn_callback = function()
        local list = list_tbl
        local selected = ui_elements.configs.cfg_list:get()+1
        local sel_name = list[selected]
        if #list > 1 and selected > #cfg_tbl then
            table.remove(list, selected)
            config_data[sel_name] = nil
            database.write("Ocean_Tech_cfgs", config_data)
        end
        cfg_manager(list)
    end,
    export_callback = function()
        local list = list_tbl
        local selected = ui_elements.configs.cfg_list:get()+1
        local sel_name = list[selected]
        if selected > #cfg_tbl then
            clipboard.set(base64.encode(json.stringify(config_data[sel_name])))
            print("Config Exported!")
        else
            print("Can't export a built-in cfg!")
        end
    end,    
}
config_system.get_cfg_list()

defer(function()
    aa_refs.pitch:override()
    aa_refs.yaw_jitter[1]:override()
    aa_refs.yaw_jitter[2]:override()
    aa_refs.body_yaw[1]:override()
    aa_refs.body_yaw[2]:override()
end)

client_set_event_callback("paint_ui", watermark_func)
client_set_event_callback("paint_ui", indicators_func)
client_set_event_callback("paint_ui", velocity_warning)
client_set_event_callback("paint_ui", hide_elements_func)
client_set_event_callback("setup_command", avoid_backstab_func)
client_set_event_callback("setup_command", aa_builder_func)
client_set_event_callback("setup_command", freestanding_disablers)
client_set_event_callback("paint", clantag_func)
client_set_event_callback("pre_render", animation_breaker)
client_set_event_callback("player_death", killsay_func)
client_set_event_callback('aim_fire', aim_fire)
client_set_event_callback('aim_hit', aim_hit)
client_set_event_callback('aim_miss', aim_miss)
client_set_event_callback('player_hurt', player_hurt)
client_set_event_callback("bullet_impact", anti_brute_func)
client_set_event_callback("round_start", reset_on_round_start)

ui_elements.misc.clantag:set_callback(clantag_change)
ui_elements.configs.create_btn:set_callback(config_system.create_btn_callback)
ui_elements.configs.export_btn:set_callback(config_system.export_callback)
ui_elements.configs.save_btn:set_callback(config_system.save_btn_callback)
ui_elements.configs.load_btn:set_callback(config_system.load_btn_callback)
ui_elements.configs.del_btn:set_callback(config_system.del_btn_callback)