-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require "ffi"
local inspect = require("gamesense/inspect")
local csgo_weapons = require("gamesense/csgo_weapons")
json.encode_sparse_array(true)

--region refs
local ref_md = ui.reference("RAGE", "Aimbot", "Minimum damage")
local ref_sp_key = ui.reference("RAGE", "Aimbot", "Force safe point")
local ref_baim_key = ui.reference("RAGE", "Other", "Force body aim")
local ref_qp, ref_qp_key = ui.reference("RAGE", "Other", "Quick peek assist")
local ref_fd = ui.reference("RAGE", "Other", "Duck peek assist")
local ref_dt, ref_dt_key = ui.reference("RAGE", "Other", "Double tap")
local ref_dt_mode = ui.reference("RAGE", "Other", "Double tap mode")
local ref_dt_hc = ui.reference("RAGE", "Other", "Double tap hit chance")
local ref_dt_fl = ui.reference("RAGE", "Other", "Double tap fake lag limit")
local ref_pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local ref_aa_enabled = ui.reference("AA", "Anti-aimbot angles" , "Enabled")
local ref_yaw, ref_yawadd = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local ref_yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local ref_yawj, ref_yawjadd = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local ref_bodyyaw, ref_bodyyawadd = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local ref_fs_bodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local ref_fakelimit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local ref_edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
local ref_hs, ref_hs_key = ui.reference("AA", "Other", "On shot anti-aim")
local ref_fl = ui.reference("AA", "Fake lag", "Enabled")
local ref_fl_amt = ui.reference("AA", "Fake lag", "Amount")
local ref_fl_var = ui.reference("AA", "Fake lag", "Variance")
local ref_fl_limit = ui.reference("AA", "Fake lag", "Limit")
local ref_maxprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local ref_freestand, ref_freestand_key = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local ref_slowmotion, ref_slowmotion_key = ui.reference("AA", "Other", "Slow motion")
local ref_slowmotion_type = ui.reference("AA", "Other", "Slow motion type")
local dt_hit_chance = ui.reference("RAGE", "Other", "Double tap hit chance")
local ref_fd = ui.reference("RAGE", "Other", "Duck peek assist")
local ref_legs = ui.reference("AA", "other", "leg movement")
local ref_roll = ui.reference("aa", "anti-aimbot angles", "Roll")
local ref_mindamage = ui.reference("RAGE", "Aimbot", "Minimum damage")
local ref_untrusted = ui.reference("MISC", "Settings", "Anti-untrusted")
local ref_plist_players = ui.reference("Players", "Players", "Player list")
local ref_plist_reset = ui.reference("Players", "Players", "Reset all")
local ref_delay_shot = ui.reference("Rage", "Other", "Delay shot")
local ref_menu_color = ui.reference("MISC", "Settings", "Menu color")
local ref_nade_helper_success, ref_nade_helper, ref_nade_helper_key = pcall(ui.reference, "Visuals", "Other ESP", "Helper")
--endregion refs

local revival = {
	menu_visibility = function(bool)
		ui.set_visible(ref_aa_enabled, bool)
		ui.set_visible(ref_bodyyaw, bool)
		ui.set_visible(ref_bodyyawadd, bool)
		ui.set_visible(ref_yawadd, bool)
		ui.set_visible(ref_yawj, bool)
		ui.set_visible(ref_yawjadd, bool)
		ui.set_visible(ref_fs_bodyyaw, bool)
		ui.set_visible(ref_fakelimit, bool)
		ui.set_visible(ref_pitch, bool)
		ui.set_visible(ref_yaw, bool)
		ui.set_visible(ref_yaw_base, bool)
		ui.set_visible(ref_roll, bool)
		ui.set_visible(ref_freestand, bool)
		ui.set_visible(ref_freestand_key, bool)
		ui.set_visible(ref_edgeyaw, bool)
	end,
	scope_frac = 0,
	state_time = 0,
	m_records = {},
	config_data = database.read("revival_presets") or {},
	pre_render = {
		end_time = 0,
		ground_ticks = 0
	},
	state = nil,
	last_state = nil,
	obex_data = obex_fetch and obex_fetch() or {},
	desync_switch = false,
	shots = {
		impacts = {},
		hits = {},
		misses = {},
		bruteforce = {}
	},
	preset = {
		default = {
			["default"] = "eyJjb3VudGVyIHRlcnJvcmlzdCI6eyJzbG93IG1vdmUiOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJmYWtlbGFnIjp7ImJvZHlfeWF3IjpbIm9mZiJdLCJ5YXdfbW9kaWZpZXJzIjpbe31dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMF0sInlhd19yaWdodCI6WzBdLCJmYWtlX2xpbWl0IjpbNjBdfSwicnVuIjp7ImJvZHlfeWF3IjpbIm9mZiJdLCJ5YXdfbW9kaWZpZXJzIjpbe31dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMF0sInlhd19yaWdodCI6WzBdLCJmYWtlX2xpbWl0IjpbNjBdfSwiZHVjayBqdW1wIjp7ImJvZHlfeWF3IjpbIm9mZiJdLCJ5YXdfbW9kaWZpZXJzIjpbe31dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMF0sInlhd19yaWdodCI6WzBdLCJmYWtlX2xpbWl0IjpbNjBdfSwiZ2xvYmFsIjp7ImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sInlhd19yaWdodCI6WzMzXSwieWF3X2ppdHRlciI6WzBdLCJib2R5X3lhdyI6WyJqaXR0ZXIiXSwieWF3X2xlZnQiOlstMzNdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIl1dLCJmYWtlX2xpbWl0IjpbNjBdfSwiZHVjayI6eyJib2R5X3lhdyI6WyJqaXR0ZXIiXSwieWF3X21vZGlmaWVycyI6W1sibGVmdFwvcmlnaHQgeWF3IGFkZCIsInlhdyBqaXR0ZXIiXV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMjhdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOlstMTJdLCJ5YXdfcmlnaHQiOlsxMF0sImZha2VfbGltaXQiOls0Ml19LCJzdGFuZCI6eyJib2R5X3lhdyI6WyJqaXR0ZXIiXSwieWF3X21vZGlmaWVycyI6W1sibGVmdFwvcmlnaHQgeWF3IGFkZCIsInlhdyBqaXR0ZXIiXV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbNDJdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOlstMTRdLCJ5YXdfcmlnaHQiOlsxN10sImZha2VfbGltaXQiOls2MF19LCJoZWlnaHQgYWR2YW50YWdlIjp7ImJvZHlfeWF3IjpbInN0YXRpYyJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIl1dLCJib2R5X3lhd19hZGQiOls2MF0sInlhd19qaXR0ZXIiOlswXSwieWF3X2ppdHRlcl90eXBlIjpbIm9mZnNldCJdLCJtYWluIjpbdHJ1ZV0sInlhd19sZWZ0IjpbMTJdLCJ5YXdfcmlnaHQiOlsxMl0sImZha2VfbGltaXQiOlsyMV19LCJqdW1wIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIl1dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOlstMzBdLCJ5YXdfcmlnaHQiOlszNV0sImZha2VfbGltaXQiOlsyMV19fSwidGVycm9yaXN0Ijp7InNsb3cgbW92ZSI6eyJib2R5X3lhdyI6WyJvZmYiXSwieWF3X21vZGlmaWVycyI6W3t9XSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOlswXSwieWF3X2ppdHRlcl90eXBlIjpbIm9mZnNldCJdLCJtYWluIjpbZmFsc2VdLCJ5YXdfbGVmdCI6WzBdLCJ5YXdfcmlnaHQiOlswXSwiZmFrZV9saW1pdCI6WzYwXX0sImZha2VsYWciOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJydW4iOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJkdWNrIGp1bXAiOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJnbG9iYWwiOnsiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwieWF3X3JpZ2h0IjpbMzNdLCJ5YXdfaml0dGVyIjpbMF0sImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbGVmdCI6Wy0zM10sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiXV0sImZha2VfbGltaXQiOls2MF19LCJkdWNrIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIiwieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOlsyOF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6Wy0xMl0sInlhd19yaWdodCI6WzEwXSwiZmFrZV9saW1pdCI6WzQyXX0sInN0YW5kIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIiwieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOls0Ml0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6Wy0xNF0sInlhd19yaWdodCI6WzE3XSwiZmFrZV9saW1pdCI6WzYwXX0sImhlaWdodCBhZHZhbnRhZ2UiOnsiYm9keV95YXciOlsic3RhdGljIl0sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiXV0sImJvZHlfeWF3X2FkZCI6WzYwXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOlsxMl0sInlhd19yaWdodCI6WzEyXSwiZmFrZV9saW1pdCI6WzIxXX0sImp1bXAiOnsiYm9keV95YXciOlsiaml0dGVyIl0sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiXV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6Wy0zMF0sInlhd19yaWdodCI6WzM1XSwiZmFrZV9saW1pdCI6WzIxXX19fQ==",
			["fake desync"] = "eyJjb3VudGVyIHRlcnJvcmlzdCI6eyJzbG93IG1vdmUiOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJmYWtlbGFnIjp7ImJvZHlfeWF3IjpbIm9mZiJdLCJ5YXdfbW9kaWZpZXJzIjpbe31dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMF0sInlhd19yaWdodCI6WzBdLCJmYWtlX2xpbWl0IjpbNjBdfSwicnVuIjp7ImJvZHlfeWF3IjpbIm9mZiJdLCJ5YXdfbW9kaWZpZXJzIjpbe31dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMF0sInlhd19yaWdodCI6WzBdLCJmYWtlX2xpbWl0IjpbNjBdfSwiZHVjayBqdW1wIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIiwieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOls2MF0sInlhd19qaXR0ZXJfdHlwZSI6WyJjZW50ZXIiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6WzVdLCJ5YXdfcmlnaHQiOls1XSwiZmFrZV9saW1pdCI6WzIxXX0sImdsb2JhbCI6eyJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlcl90eXBlIjpbImNlbnRlciJdLCJ5YXdfcmlnaHQiOlszM10sInlhd19qaXR0ZXIiOls2Nl0sImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbGVmdCI6Wy0zM10sInlhd19tb2RpZmllcnMiOltbInlhdyBqaXR0ZXIiXV0sImZha2VfbGltaXQiOls2MF19LCJkdWNrIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIiwieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOls0OF0sInlhd19qaXR0ZXJfdHlwZSI6WyJjZW50ZXIiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6Wy0yXSwieWF3X3JpZ2h0IjpbLTJdLCJmYWtlX2xpbWl0IjpbNDJdfSwic3RhbmQiOnsiYm9keV95YXciOlsiaml0dGVyIl0sInlhd19tb2RpZmllcnMiOltbInlhdyBqaXR0ZXIiXV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbNzVdLCJ5YXdfaml0dGVyX3R5cGUiOlsiY2VudGVyIl0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOlstMTRdLCJ5YXdfcmlnaHQiOlsxN10sImZha2VfbGltaXQiOls2MF19LCJoZWlnaHQgYWR2YW50YWdlIjp7ImJvZHlfeWF3IjpbInN0YXRpYyJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIl1dLCJib2R5X3lhd19hZGQiOls2MF0sInlhd19qaXR0ZXIiOlswXSwieWF3X2ppdHRlcl90eXBlIjpbIm9mZnNldCJdLCJtYWluIjpbZmFsc2VdLCJ5YXdfbGVmdCI6WzEyXSwieWF3X3JpZ2h0IjpbMTJdLCJmYWtlX2xpbWl0IjpbMjFdfSwianVtcCI6eyJib2R5X3lhdyI6WyJqaXR0ZXIiXSwieWF3X21vZGlmaWVycyI6W1sibGVmdFwvcmlnaHQgeWF3IGFkZCIsInlhdyBqaXR0ZXIiXV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbNjBdLCJ5YXdfaml0dGVyX3R5cGUiOlsiY2VudGVyIl0sIm1haW4iOlt0cnVlXSwieWF3X2xlZnQiOls1XSwieWF3X3JpZ2h0IjpbNV0sImZha2VfbGltaXQiOlsyMV19fSwidGVycm9yaXN0Ijp7InNsb3cgbW92ZSI6eyJib2R5X3lhdyI6WyJvZmYiXSwieWF3X21vZGlmaWVycyI6W3t9XSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOlswXSwieWF3X2ppdHRlcl90eXBlIjpbIm9mZnNldCJdLCJtYWluIjpbZmFsc2VdLCJ5YXdfbGVmdCI6WzBdLCJ5YXdfcmlnaHQiOlswXSwiZmFrZV9saW1pdCI6WzYwXX0sImZha2VsYWciOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJydW4iOnsiYm9keV95YXciOlsib2ZmIl0sInlhd19tb2RpZmllcnMiOlt7fV0sImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyIjpbMF0sInlhd19qaXR0ZXJfdHlwZSI6WyJvZmZzZXQiXSwibWFpbiI6W2ZhbHNlXSwieWF3X2xlZnQiOlswXSwieWF3X3JpZ2h0IjpbMF0sImZha2VfbGltaXQiOls2MF19LCJkdWNrIGp1bXAiOnsiYm9keV95YXciOlsiaml0dGVyIl0sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiLCJ5YXcgaml0dGVyIl1dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzYwXSwieWF3X2ppdHRlcl90eXBlIjpbImNlbnRlciJdLCJtYWluIjpbdHJ1ZV0sInlhd19sZWZ0IjpbNV0sInlhd19yaWdodCI6WzVdLCJmYWtlX2xpbWl0IjpbMjFdfSwiZ2xvYmFsIjp7ImJvZHlfeWF3X2FkZCI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsiY2VudGVyIl0sInlhd19yaWdodCI6WzMzXSwieWF3X2ppdHRlciI6WzY2XSwiYm9keV95YXciOlsiaml0dGVyIl0sInlhd19sZWZ0IjpbLTMzXSwieWF3X21vZGlmaWVycyI6W1sieWF3IGppdHRlciJdXSwiZmFrZV9saW1pdCI6WzYwXX0sImR1Y2siOnsiYm9keV95YXciOlsiaml0dGVyIl0sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiLCJ5YXcgaml0dGVyIl1dLCJib2R5X3lhd19hZGQiOlswXSwieWF3X2ppdHRlciI6WzQ4XSwieWF3X2ppdHRlcl90eXBlIjpbImNlbnRlciJdLCJtYWluIjpbdHJ1ZV0sInlhd19sZWZ0IjpbLTJdLCJ5YXdfcmlnaHQiOlstMl0sImZha2VfbGltaXQiOls0Ml19LCJzdGFuZCI6eyJib2R5X3lhdyI6WyJqaXR0ZXIiXSwieWF3X21vZGlmaWVycyI6W1sieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOls3NV0sInlhd19qaXR0ZXJfdHlwZSI6WyJjZW50ZXIiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6Wy0xNF0sInlhd19yaWdodCI6WzE3XSwiZmFrZV9saW1pdCI6WzYwXX0sImhlaWdodCBhZHZhbnRhZ2UiOnsiYm9keV95YXciOlsic3RhdGljIl0sInlhd19tb2RpZmllcnMiOltbImxlZnRcL3JpZ2h0IHlhdyBhZGQiXV0sImJvZHlfeWF3X2FkZCI6WzYwXSwieWF3X2ppdHRlciI6WzBdLCJ5YXdfaml0dGVyX3R5cGUiOlsib2Zmc2V0Il0sIm1haW4iOltmYWxzZV0sInlhd19sZWZ0IjpbMTJdLCJ5YXdfcmlnaHQiOlsxMl0sImZha2VfbGltaXQiOlsyMV19LCJqdW1wIjp7ImJvZHlfeWF3IjpbImppdHRlciJdLCJ5YXdfbW9kaWZpZXJzIjpbWyJsZWZ0XC9yaWdodCB5YXcgYWRkIiwieWF3IGppdHRlciJdXSwiYm9keV95YXdfYWRkIjpbMF0sInlhd19qaXR0ZXIiOls2MF0sInlhd19qaXR0ZXJfdHlwZSI6WyJjZW50ZXIiXSwibWFpbiI6W3RydWVdLCJ5YXdfbGVmdCI6WzVdLCJ5YXdfcmlnaHQiOls1XSwiZmFrZV9saW1pdCI6WzIxXX19fQ==",
			["five way"] = ""
		},
		selected = json.parse(database.read("revival_default_preset") or "{}") or {
			name = nil,
			editing = nil,
			data = nil
		}
	},
	binds = {
		{
			name = "DT",
			cond = function()
				return ui.get(ref_dt) and ui.get(ref_dt_key) and not ui.get(ref_fd)
			end,
			fraction = 0,
		},
		{
			name = "HIDE",
			cond = function()
				return not (ui.get(ref_dt) and ui.get(ref_dt_key)) and not ui.get(ref_fd) and ui.get(ref_hs) and ui.get(ref_hs_key)
			end,
			fraction = 0,
		},
		{
			name = "DUCK",
			cond = function() 
				return ui.get(ref_fd)
			end,
			fraction = 0,
		},
		{
			name = "BAIM",
			cond = function() 
				return ui.get(ref_baim_key)
			end,
			fraction = 0,
		},
		{
			name = "SAFE",
			cond = function() 
				return ui.get(ref_sp_key)
			end,
			fraction = 0,
		},
		{
			name = "AUTO",
			cond = function() 
				return ui.get(ref_qp_key)
			end,
			fraction = 0,
		},
	},
	freestand_side = nil
}

function math.sign(x)
	return (x<0 and -1) or 1
end

local modules = {
	vector = function()
		return require("vector")
	end,

	images = function()
		return require "gamesense/images"
	end,

	color = function()
		--- @class color_c
		local color_c = {}
		local color_mt = {__metatable = {}, __index = color_c}
		
		--- @return number, number, number
		--- @param r number
		--- @param g number
		--- @param b number
		color_mt.to_hsl = function(r, g, b)
		   r, g, b = r/255, g/255, b/255
		   local min = math.min(r, g, b)
		   local max = math.max(r, g, b)
		   local delta = max - min
		
		   local h, s, l = 0, 0, ((min+max)/2)
		
		   if l > 0 and l < 0.5 then s = delta/(max+min) end
		   if l >= 0.5 and l < 1 then s = delta/(2-max-min) end
		
		   if delta > 0 then
			  if max == r and max ~= g then h = h + (g-b)/delta end
			  if max == g and max ~= b then h = h + 2 + (b-r)/delta end
			  if max == b and max ~= r then h = h + 4 + (r-g)/delta end
			  h = h / 6;
		   end
		
		   if h < 0 then h = h + 1 end
		   if h > 1 then h = h - 1 end
		
		   return h, s, l
		end
		
		--- @return number, number, number
		--- @param h number
		--- @param s number
		--- @param l number
		color_mt.to_rgb = function(h, s, l)
			local r, g, b
		  
			if s == 0 then
			  r, g, b = l, l, l -- achromatic
			else
			  function hue2rgb(p, q, t)
				if t < 0   then t = t + 1 end
				if t > 1   then t = t - 1 end
				if t < 1/6 then return p + (q - p) * 6 * t end
				if t < 1/2 then return q end
				if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
				return p
			  end
		  
			  local q
			  if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
			  local p = 2 * l - q
		  
			  r = hue2rgb(p, q, h + 1/3)
			  g = hue2rgb(p, q, h)
			  b = hue2rgb(p, q, h - 1/3)
			end
		  
			return r * 255, g * 255, b * 255
		end
		
		-- Creates new color instance from RGBA.
		--- @return color_c
		--- @param r number
		--- @param g number
		--- @param b number
		--- @param a number
		color_mt.new = function(r, g, b, a)
			local h, s, l = color_mt.to_hsl(r, g, b)
			return setmetatable({
				h = math.max(math.min(1,h),0) or error("missing parameter: h, type: number"),
				s = math.max(math.min(1,s),0) or error("missing parameter: s, type: number"),
				l = math.max(math.min(1,l),0) or error("missing parameter: l, type: number"),
				a = math.max(math.min(1,a/255),0) or 1
			}, color_mt)
		end
		
		-- Creates new color instance from HSLA.
		--- @return color_c
		--- @param h number
		--- @param s number
		--- @param l number
		--- @param a number
		color_mt.hsla = function(h, s, l, a)
			return setmetatable({
				h = math.max(math.min(1,h),0) or error("missing parameter: h, type: number"),
				s = math.max(math.min(1,s),0) or error("missing parameter: s, type: number"),
				l = math.max(math.min(1,l),0) or error("missing parameter: l, type: number"),
				a = math.max(math.min(1,a),0) or 1
			}, color_mt)
		end
		
		color_mt.rgba_lerp = function(from, to, percent)
			local arr = {}
			for i, v in ipairs(from) do
				arr[i] = v + (to[i] - v) * percent
			end
			return color_mt.new(unpack(arr))
		end
		
		-- Allows the color table to create a new color instance when called.
		color_mt.__call = function(_, ...)
			return color_mt.new(...)
		end
		
		function color_c:unpack()
			local r, g, b = color_mt.to_rgb(self.h, self.s, self.l)
			return r, g, b, self.a*255
		end
		
		function color_c:to_string()
			local r, g, b, a = self:unpack()
			return string.format("\a%02x%02x%02x%02x", r, g, b, a)
		end
		
		function color_c:hue_offet(delta)
			return color(((self.h + delta) % 360)/360, self.s, self.l, self.a)
		end
		
		function color_c:complementary()
			return self:hue_offet(180)
		end
		
		function color_c:neighbors(angle)
			local angle = angle or 30
			return self:hue_offet(angle), self:hue_offet(360 - angle)
		end
		
		function color_c:triadic() 
			return self:neighbors(120)
		end
		
		function color_c:split_complementary(angle)
			return self:neighbors(180-(angle or 30))
		end
		
		function color_c:desaturate_to(saturation)
			return color_mt.hsla(self.h, saturation, self.l, self.a)
		end
		
		function color_c:desaturate_by(r)
			return color_mt.hsla(self.h, self.s*r, self.l, self.a)
		end
		
		function color_c:lighten_to(lightness)
			return color_mt.hsla(self.h, self.s, lightness, a)
		end
		
		function color_c:lighten_by(r)
			return color_mt.hsla(self.h, self.s, self.l*r, a)
		end
		
		function color_c:variations(f, n)
			n = n or 5
			local results = {}
			for i=1,n do
			   table.insert(results, f(self, i, n))
			end
			return results
		end
		
		function color_c:tints(n)
			local f = function (color, i, n) 
				return self:lighten_to(color.l + (1-color.l)/n*i)
			end
			return self:variations(f, n)
		end
		 
		function color_c:shades(n)
			local f = function (color, i, n) 
				return self:lighten_to(color.l - (color.l)/n*i)
			end
			return self:variations(f, n)
		end
		 
		function color_c:tint(r)
			return self:lighten_to(self.l + (1-self.l)*r)
		end
		 
		function color_c:shade(r)
			return self:lighten_to(self.l - self.l*r)
		end
		
		function color_c:lerp(to, percentage)
			local percentage = math.max(math.min(1, percentage),0)
			return color.hsla(
				self.h + (to.h - self.h)*percentage,
				self.s + (to.s - self.s)*percentage,
				self.l + (to.l - self.l)*percentage,
				self.a + (to.a - self.a)*percentage
			)
		end
		
		-- Creates color functable.
		--- @return color_c
		local color = (function()
			local o = {
			}
			for k, v in pairs(color_mt) do
				o[k] = v
			end
			return setmetatable(o, color_mt)
		end)()
		
		return color
	end,

	utility = function(vector, base64)
		local this = {}

		function this:contains(tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end

		function this:iterate(tbl, cond, func)
			for k, v in pairs(tbl) do
				if cond(k, v) then
					func(k, v)
				elseif type(v) == "table" then
					this:iterate(v, cond, func)
				end
			end
		end

		function this:get_velocity(ent)
			return vector(entity.get_prop(ent, "m_vecVelocity")):length()
		end

		function this:in_air(_ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
	
			if bit.band(flags, 1) == 0 then
				return true
			end
			
			return false
		end

		function this:in_duck(_ent)
			local flags = entity.get_prop(_ent, "m_fFlags")
			
			if bit.band(flags, 4) == 4 then
				return true
			end
			
			return false
		end

		function this:get_delta(ent)
			return entity.get_prop(ent, "m_flPoseParameter", 11) * math.deg(2) - math.deg(1)
		end

		function this:normalize_yaw(angle)
			angle =  angle % 360 
			angle = (angle + 360) % 360
			if (angle > 180)  then
				angle = angle - 360
			end
			return angle
		end

		function this:clamp(val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end

		function this:round(num, decimals)
			local mult = 10^(decimals or 0)
			return math.floor(num * mult + 0.5) / mult
		end

		function this:closest_point_on_ray(target, start, final)
			local to = target - start
			local dir = (final - start):normalized()
			local length = (final - start):length()
			local range_along = dir.x * to.x + dir.y * to.y + dir.z * to.z
			if range_along < 0 then
				return start
			end
			if range_along > length then
				return final
			end	
			return start + dir * range_along
		end	

		function this:removeKey(tbl, key)
			for k,v in pairs(tbl) do
				if (v == key) then
					table.remove(tbl, key)
				end
			end
		end

		-- returns a `counts` map such that `counts[value]`
		-- is the number of times that `value` appears in `list`
		function this:countMap(list)
		    local counts = {}
		    for _, value in ipairs(list) do
		        -- "default" counts[value] to 0 if it's not already there
		        counts[value] = (counts[value] or 0) + 1
		    end
		    return counts
		end

		-- returns a `key` such that `map[key]` is as large as possible
		function this:keyLargest(map)
		    local best = next(map) -- get an arbitrary key
		    for key in pairs(map) do
		        if map[best] < map[key] then
		            best = key
		        end
		    end
		    return best
		end

		-- returns an element that appears the most number of times in `list`
		function this:mostCommon(list)
		    return this:keyLargest(this:countMap(list))
		end

		function this:encode_preset(data)
			local arr = {}
			for state, tbl in pairs(data) do
				arr[state] = {}
				for k, v in pairs(tbl) do
					arr[state][k] = v:get()
				end
			end
			return base64.encode(json.stringify(arr))
		end

		function this:decode_preset(data)
			local data = base64.decode(data)
			local success, arr = pcall(json.parse, data)
			return arr
		end

		function this:get_body_yaw()
			local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * (360/math.pi) - (180/math.pi)
			return body_yaw > 0 and 1 or 0, body_yaw
		end

		function this:split(inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end

		return this
	end,

	m_render = function(color)
		local m_render = {}

		m_render.rec = function(x, y, w, h, accent, radius)
			local r, g, b, a = accent:unpack()
			radius = math.min(x/2, y/2, radius)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end

		m_render.rec_outline = function(x, y, w, h, accent, radius, thickness)
			radius = math.min(w/2, h/2, radius)
			local r, g, b, a = accent:unpack()
			if radius == 1 then
				renderer.rectangle(x, y, w, thickness, r, g, b, a)
				renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
			else
				renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
				renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
			end
		end

		m_render.glow_module = function(x, y, w, h, accent, width, rounding, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = accent:unpack()
			if accent_inner then
				m_render.rec(x , y, w, h, accent_inner, rounding)
				--renderer.blur(x , y, w, h)
				--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
			end
			for k = 0, width do
				local accent = color(r, g, b, a * (k/width)^(2.3))
				m_render.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h - (k - width - offset)*thickness*2, accent, rounding + thickness * (width - k + offset), thickness)
			end
		end

		return m_render
	end,

	notifications = function(images, color, m_render, utility)
		local this = {
			list = {},
			info_svg = images.get_panorama_image("icons/ui/warning.svg"),
			warn_svg = [[]]
		}

		local split = function(inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end

		function this:new(mode, str, accent)
			table.insert(this.list, {
				time = globals.realtime() + 5,
				mode = mode,
				accent = accent,
				str = str,
				frac = 1
			})
		end

		function this:run()
			local x, y = client.screen_size()
			local anim_time = 0.33
			local offset = 0

			for i = #this.list, 1, -1 do
				local item = this.list[i]

				if #this.list - i + 1 > 6 and item.time > anim_time + globals.realtime() then
					item.time = anim_time + globals.realtime()
				elseif 5 + globals.realtime() - item.time < anim_time then
					item.frac = utility:clamp((5 + globals.realtime() - item.time)/anim_time, 0, 1)^(1/3)
				else
					item.frac = utility:clamp((item.time - globals.realtime())/anim_time, 0, 1)^3
				end

				if item.time - globals.realtime() <= 0 then
					table.remove(this.list, i)
				end

				offset = offset - item.frac * 30

				item.offset = offset
			end

			for i, item in ipairs(this.list) do
				local r, g, b, a = item.accent:unpack()
				local accent = color(r, g, b, 255 * item.frac):to_string()
				local white = color(255,255,255,255 * item.frac):to_string()

				local str = ""
				for i, s in ipairs(split(item.str, "$")) do
					str = str .. (i % 2 ==( item.str:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
				end

				local strw, strh = renderer.measure_text("", str)
				local strw2 = renderer.measure_text("b", "revival: ")
				local paddingx, paddingy = 6, 4
				m_render.glow_module(x/2 - (strw + strw2)/2 - paddingx, y - 150 - strh/2 - paddingy - item.frac * 30 + item.offset, strw + strw2 + paddingx*2, strh + paddingy*2, color(r, g, b, 55 * item.frac), 10, 5, color(25,25,25,255 * item.frac))
				renderer.text(x/2 + strw2/2, y - 151 - item.frac * 30 + item.offset, 255,255,255,255 * item.frac, "c", 0, str)
				renderer.text(x/2 - strw/2, y - 151 - item.frac * 30 + item.offset, 255,255,255,255 * item.frac, "cb", 0, accent .. "revival: ")
			end
		end

		return this
	end,

	trace = function(vector, utility)
		local trace = require 'gamesense/trace'

		trace.get_edge_yaw = function()
			local me = entity.get_local_player()
			local _, yaw = client.camera_angles()
			local data = {
				damage = 0,
				angle = 0,
				min_damage = math.huge,
				min_except_zero = {
					min = math.huge,
					angle = 0
				},
				tr = nil
			}
			local start_damage = 0
			local steps = 7
			for angle = 0, 120, 120/steps do
				if angle > 60 then
					angle = 60-angle
				end
				local from = vector(client.eye_position()) + vector():init_from_angles(0, yaw + angle + 180, 0):scaled(12)
				local to = from + vector():init_from_angles(0,  yaw, 0):scaled(40) + vector():init_from_angles(0,  yaw + 90, 0):scaled(angle)
				local _, damage = client.trace_bullet(me, from.x, from.y, from.z, to.x, to.y, to.z, me)

				if angle == 0 then
					start_damage = damage
				end
				
				if data.min_except_zero.min > damage then
					data.min_except_zero = {
						min = math.min(data.min_except_zero.min, damage),
						angle = angle
					}
				end

				if not data.tr or data.tr.plane.normal:length() == 0 then
					local tr = trace.line(from, to, { skip = me, mask = "MASK_SHOT" })
					if tr.plane.normal:length() ~= 0 then
						data.tr = tr
					end
				end

				if damage > data.damage * 1.1 then
					if angle > 0 then
						angle = 90 - (math.sqrt(math.abs(angle)/60))*90
					elseif angle < 0 then
						angle = -90 + (math.sqrt(math.abs(angle)/60))*90
					end

					data = {
						damage = damage,
						angle = 180 - angle,
						min_damage = math.min(data.min_damage, damage),
						tr = data.tr,
						min_except_zero = data.min_except_zero
					}
				end

				data.min_damage = math.min(data.min_damage, damage)
			end

			if data.angle == 180 then
				if data.min_except_zero.angle < 0 then
					data.angle = 90
				elseif data.min_except_zero.angle > 0 then
					data.angle = -90
				end
			end

			if data.tr and false then
				local dir = vector():init_from_angles(0,  yaw, 0)
				local _, normal_yaw = (-data.tr.plane.normal):angles()

				local _, yaw2 = dir:to(-data.tr.plane.normal):angles()

				local ang = utility:clamp(utility:normalize_yaw((90 - yaw2)*2)*2, -90, 90)
				if math.abs(ang) > 20 then
					if math.abs(utility:normalize_yaw(-180 + data.angle)) < ang then
						data.angle = 180 - yaw - normal_yaw + ang
					end
				elseif math.abs(utility:normalize_yaw(-180 + data.angle)) < 20 then
					data.angle = 180 - yaw - normal_yaw
				end
			end

			if data.min_damage * 1.1 >= data.damage then --and start_damage == data.min_damage
				return
			end

			return yaw + data.angle -- (new_yaw - yaw)
		end

		return trace
	end,

	clipboard = function()
		return require("gamesense/clipboard")
	end,

	base64 = function()
		local base64 = {}
		
		local extract = _G.bit32 and _G.bit32.extract -- Lua 5.2/Lua 5.3 in compatibility mode
		if not extract then
			if _G.bit then -- LuaJIT
				local shl, shr, band = _G.bit.lshift, _G.bit.rshift, _G.bit.band
				extract = function( v, from, width )
					return band( shr( v, from ), shl( 1, width ) - 1 )
				end
			elseif _G._VERSION == "Lua 5.1" then
				extract = function( v, from, width )
					local w = 0
					local flag = 2^from
					for i = 0, width-1 do
						local flag2 = flag + flag
						if v % flag2 >= flag then
							w = w + 2^i
						end
						flag = flag2
					end
					return w
				end
			else -- Lua 5.3+
				extract = load[[return function( v, from, width )
					return ( v >> from ) & ((1 << width) - 1)
				end]]()
			end
		end
		
		
		function base64.makeencoder( s62, s63, spad )
			local encoder = {}
			for b64code, char in pairs{[0]='A','B','C','D','E','F','G','H','I','J',
				'K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y',
				'Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
				'o','p','q','r','s','t','u','v','w','x','y','z','0','1','2',
				'3','4','5','6','7','8','9',s62 or '+',s63 or'/',spad or'='} do
				encoder[b64code] = char:byte()
			end
			return encoder
		end
		
		function base64.makedecoder( s62, s63, spad )
			local decoder = {}
			for b64code, charcode in pairs( base64.makeencoder( s62, s63, spad )) do
				decoder[charcode] = b64code
			end
			return decoder
		end
		
		local DEFAULT_ENCODER = base64.makeencoder()
		local DEFAULT_DECODER = base64.makedecoder()
		
		local char, concat = string.char, table.concat
		
		function base64.encode( str, encoder, usecaching )
			encoder = encoder or DEFAULT_ENCODER
			local t, k, n = {}, 1, #str
			local lastn = n % 3
			local cache = {}
			for i = 1, n-lastn, 3 do
				local a, b, c = str:byte( i, i+2 )
				local v = a*0x10000 + b*0x100 + c
				local s
				if usecaching then
					s = cache[v]
					if not s then
						s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
						cache[v] = s
					end
				else
					s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
				end
				t[k] = s
				k = k + 1
			end
			if lastn == 2 then
				local a, b = str:byte( n-1, n )
				local v = a*0x10000 + b*0x100
				t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
			elseif lastn == 1 then
				local v = str:byte( n )*0x10000
				t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
			end
			return concat( t )
		end
		
		function base64.decode( b64, decoder, usecaching )
			decoder = decoder or DEFAULT_DECODER
			local pattern = '[^%w%+%/%=]'
			if decoder then
				local s62, s63
				for charcode, b64code in pairs( decoder ) do
					if b64code == 62 then s62 = charcode
					elseif b64code == 63 then s63 = charcode
					end
				end
				pattern = ('[^%%w%%%s%%%s%%=]'):format( char(s62), char(s63) )
			end
			b64 = b64:gsub( pattern, '' )
			local cache = usecaching and {}
			local t, k = {}, 1
			local n = #b64
			local padding = b64:sub(-2) == '==' and 2 or b64:sub(-1) == '=' and 1 or 0
			for i = 1, padding > 0 and n-4 or n, 4 do
				local a, b, c, d = b64:byte( i, i+3 )
				local s
				if usecaching then
					local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
					s = cache[v0]
					if not s then
						local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
						s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
						cache[v0] = s
					end
				else
					local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
					s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
				end
				t[k] = s
				k = k + 1
			end
			if padding == 1 then
				local a, b, c = b64:byte( n-3, n-1 )
				local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
				t[k] = char( extract(v,16,8), extract(v,8,8))
			elseif padding == 2 then
				local a, b = b64:byte( n-3, n-2 )
				local v = decoder[a]*0x40000 + decoder[b]*0x1000
				t[k] = char( extract(v,16,8))
			end
			return concat( t )
		end
		
		return base64
	end,

	menu = function(color)
		--- @author vald
		--- This is an improved version of the custom colored ui library. Following is the documentation for creating these items:
		--- menu:new(type: {
		---	   ["checkbox"] => (color: accent, string: name)
		---	   ["combobox"] => (color: accent, string: name, table: args)
		---	   ["multiselect"] => (color: accent, string: name, table: args)
		---	   ["hotkey"] => (color: accent, string: name, number: inline, number: default_key)
		---	   ["slider"] => (color: accent, string: name, number: min, number: max, numbder: default, boolean: show_tooltip, string: unit, number: scale, table: tooltips)
		---	   ["color_picker"] => (color: accent, string: name, number: inline color: default_color)
		---})
		---
		---Updating them is very basic just use the following functions:
		---menu:set(value)
		---menu:get()
		---menu:set_callback(function: func)
		---menu:update_color(color: accent)
		
		local M = {}
		
		local menu_c = {}
		local menu_mt = {__index = menu_c}
		
		local split = function(inputstr, sep)
			if sep == nil then
					sep = "%s"
			end
			local t={}
			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
					table.insert(t, str)
			end
			return t
		end
		
		local get_colored_name = function(name, accent)
			local white = color(255,255,255,200):to_string()
			local arr = split(name, "$")
			local accent = accent:to_string()
			local new_name = ""
			for i, s in ipairs(arr) do
				new_name = new_name .. (i % 2 ==( name:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end
			return new_name
		end
		
		local new = function(type, accent, ...)
			local args = {...}
			local name = table.remove(args, 1)
			local o = setmetatable({
				tab = "aa",
				container = "anti-aimbot angles",
				type = type,
				name = name,
			}, menu_mt)
			o:create_item(type, accent, name, unpack(args))
			return o
		end
		
		M.new = new
		
		function menu_c:create_item(type, accent, name, ...)
			local name = get_colored_name(name, accent)
			local funcs = {
				["checkbox"] = function(name)
					local item = ui.new_checkbox(self.tab, self.container, "\n".. name)
					local label = ui.new_label(self.tab, self.container, name)
					return item, label
				end,
				["combobox"] = function(name, args)
					local label = ui.new_label(self.tab, self.container, name)
					local item = ui.new_combobox(self.tab, self.container, "\n" .. name, args)
					return item, label
				end,
				["multiselect"] = function(name, args)
					local label = ui.new_label(self.tab, self.container, name)
					local item = ui.new_multiselect(self.tab, self.container, "\n" .. name, args)
					return item, label 
				end,
				["hotkey"] = function(name, inline, default_key)
					local item, label
					if inline == 1 then
						item = ui.new_hotkey(self.tab, self.container, name, 1, default_key and default_key or 0)
						label = ui.new_label(self.tab, self.container, "\n" .. name)
					else
						label = ui.new_label(self.tab, self.container, name)
						item = ui.new_hotkey(self.tab, self.container, "\n" .. name, 0, default_key and default_key or 0)
					end
					return item, label 
				end,
				["slider"] = function(name, min, max, default, show_tooltip, unit, scale, tooltips)
					local label = ui.new_label(self.tab, self.container, name)
					local item = ui.new_slider(self.tab, self.container, "\n" .. name, min, max, default, show_tooltip, unit, scale, tooltips)
					return item, label  
				end,
				["color_picker"] = function(name, inline, accent)
					local r, g, b, a = accent:unpack()
					local item, label
					if inline == 1 then
						item = ui.new_color_picker(self.tab, self.container, "\n" .. name, r, g, b, a)
					else
						label = ui.new_label(self.tab, self.container, name)
						item = ui.new_color_picker(self.tab, self.container, "\n" .. name, r, g, b, a)
					end
					return item, label
				end,
				["listbox"] = function(name, args)
					local label = ui.new_label(self.tab, self.container, name)
					local item = ui.new_listbox(self.tab, self.container, "\n" .. name, args)
					return item, label
				end
			}
		
			self.item, self.label = funcs[type](name, ...)
		end
		
		function menu_c:get()
			return ui.get(self.item)
		end
		
		function menu_c:set(v)
			return ui.set(self.item, v)
		end
		
		function menu_c:update_color(accent)
			if self.label ~= nil then
				ui.set(self.label, get_colored_name(self.name, accent))
			end
		end
		
		function menu_c:set_callback(func)
			ui.set_callback(self.item, func)
		end
		
		function menu_c:set_visible(visibility)
			ui.set_visible(self.item, visibility)
			ui.set_visible(self.label, visibility)
		end
		
		setmetatable(M, {__call=function(_, ...) return new(...) end, __metatable = menu_mt})
		
		return M	
	end,

	entities = function() --return require("lua-project/modules/entity")
	end,

	net_channel = function(utility) 
		local this = {}

		local native_GetNetChannelInfo = vtable_bind("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)");
		local native_GetLatency = vtable_thunk(9, "float(__thiscall*)(void*, int)");
		
		function this:get_lerp_time()
			local ud_rate = cvar.cl_updaterate:get_int()
			
			local min_ud_rate = cvar.sv_minupdaterate:get_int()
			local max_ud_rate = cvar.sv_maxupdaterate:get_int()
			
			if (min_ud_rate and max_ud_rate) then
				ud_rate = max_ud_rate
			end

			local ratio = cvar.cl_interp_ratio:get_float()
			
			if (ratio == 0) then
				ratio = 1
			end

			local lerp = cvar.cl_interp:get_float()
			local c_min_ratio = cvar.sv_client_min_interp_ratio:get_float()
			local c_max_ratio = cvar.sv_client_max_interp_ratio:get_float()
			
			if (c_min_ratio and  c_max_ratio and  c_min_ratio ~= 1) then
				ratio = utility:clamp(ratio, c_min_ratio, c_max_ratio)
			end

			return math.max(lerp, (ratio / ud_rate));
		end
		
		function this:is_tick_valid(record)
			local nci = native_GetNetChannelInfo();
		
			local sv_maxunlag = cvar.sv_maxunlag:get_float()
			local is_dead = record.m_simulation_time*globals.tickinterval() < math.floor(entity.get_prop(entity.get_local_player(), "m_nTickBase")*globals.tickinterval() - sv_maxunlag)--flDeadTime
		
			if not nci or not sv_maxunlag or is_dead then
				return false
			end
			local outgoing, incoming = native_GetLatency(nci, 0), native_GetLatency(nci, 1)
		
			local correct = utility:clamp( outgoing + incoming + this:get_lerp_time(), 0, sv_maxunlag );
		
			local delta = correct - ( globals.curtime() - record.m_simulation_time*globals.tickinterval())
		
			return math.abs(delta) <= sv_maxunlag
		end
		
		return this
	end,

	extrapolation = function(vector, utility)
		local this = {}

		this.run_basic = function(ent, ticks)
			return vector(entity.get_origin(ent)) + vector(entity.get_prop(ent, "m_vecVelocity")):scaled(ticks)
		end

		this.run_default = function(ent, ticks, pos)
			local on_ground = not utility:in_air(ent)

			local sim_data = {
				origin = pos or vector(entity.get_origin(ent)),
				m_vecvelocity = vector(entity.get_prop(ent, "m_vecVelocity")),
				on_ground = on_ground,
				view_offset = entity.get_prop(ent, "m_vecViewOffset[2]")
			}

			local simulate_movement = function(record_data)
				local sv_gravity = cvar.sv_gravity:get_int()

				local data = record_data
				local predicted_origin = data.origin

				if not data.on_ground then
					local gravity_per_tick = sv_gravity * globals.tickinterval()
					data.m_vecvelocity.z = data.m_vecvelocity.z - gravity_per_tick
				end

				predicted_origin = predicted_origin + data.m_vecvelocity:scaled(globals.tickinterval())

				local predicted_origin2 = predicted_origin + data.m_vecvelocity:scaled(16/data.m_vecvelocity:length())
				local fraction = client.trace_line(ent, data.origin.x, data.origin.y, data.origin.z + data.view_offset, predicted_origin2.x, predicted_origin2.y, data.origin.z + data.view_offset)
				local gf = client.trace_line(ent,  predicted_origin.x, predicted_origin.y, predicted_origin.z + data.view_offset, predicted_origin.x, predicted_origin.y, predicted_origin.z-2)

				if fraction == 1 then
					data.origin = predicted_origin
					data.on_ground = gf ~= 1
					if data.on_ground then
						if not on_ground then
							data.m_vecvelocity.z = cvar.sv_jump_impulse:get_int()
							data.on_ground = false
						else
							data.m_vecvelocity.z = 0
						end
					end
				end

				return data
			end

			if ticks > 0 then
				for i = 1, ticks do
					sim_data = simulate_movement(sim_data)
				end
			end
		
			return sim_data
		end

		function this:run(mode, ent, ticks, pos)
			if type(mode) ~= "string" then
				return error("invalid mode")
			end

			return this["run_"..mode](ent, ticks, pos)
		end

		return this
	end,

	record = function(vector, utility)
		local this = {}

		---@return record_data
		---@param ent number
		local get_record = function(ent)
			local _, yaw = entity.get_prop(ent, "m_angEyeAngles")
			return {
				simtime = entity.get_prop(ent, "m_flSimulationTime")/globals.tickinterval(),
				origin = vector(entity.get_prop(ent, "m_vecOrigin")),
				yaw = yaw,
				view_offset = entity.get_prop(ent, "m_vecViewOffset[2]"),
				hitboxes = (function()
					local arr = {}
					for hitbox = 0, 18 do
						table.insert(arr, vector(entity.hitbox_position(ent, hitbox)))
					end
					return arr
				end)()
			}
		end

		---@return void
		this.save = function()
			local entities = entity.get_players(true)
			table.insert(entities, entity.get_local_player())
			for _, ent in ipairs(entities) do
				revival.m_records[ent] = revival.m_records[ent] or {}
				local simtime = entity.get_prop(ent, "m_flSimulationTime")/globals.tickinterval()
				if not revival.m_records[ent][1] or simtime > revival.m_records[ent][1].simtime then
					table.insert(revival.m_records[ent], 1, get_record(ent))
				end
				if #revival.m_records[ent] > 2 then
					table.remove(revival.m_records[ent], #revival.m_records[ent])
				end
			end
		end

		---@return defensive_time
		---@param ent number
		this.get_defensive_time = function(ent)
			if not entity.is_alive(ent) or entity.is_dormant(ent) or not revival.m_records[ent] or not revival.m_records[ent][1] then
				return
			end
			local simtime = entity.get_prop(ent, "m_flSimulationTime")/globals.tickinterval()
			local delta = simtime - revival.m_records[ent][1].simtime
			if delta <= 0 then
				return math.abs(delta)
			end
		end

		this.update_body_yaw = function(active)
			for ent, m_records in pairs(revival.m_records) do
				if m_records[2] ~= nil and m_records[1] ~= nil and active then
					local delta = utility:normalize_yaw(m_records[2].yaw - m_records[1].yaw)
					if math.abs(delta) >= 28 then
						plist.set(ent, "Force body yaw", true)
						plist.set(ent, "Force body yaw value", delta < 0 and 60 or -60)
					else
						plist.set(ent, "Force body yaw", false)
					end
				else
					plist.set(ent, "Force body yaw", false)
				end
			end
		end

		return this
	end,

	config = function(utility, base64, clipboard, menu, color, notifications)
		local this = {}

		this.get_local_presets = function()
			local arr = {}
			for k, _ in pairs(revival.config_data) do
				table.insert(arr, k)
			end
			return arr
		end

		this.get_preset_list = function(use_colors)
			local arr = {
				"+ create local preset",
				"+ import from clipboard"
			}

			local r, g, b, a = ui.get(ref_menu_color)
			local clr = color.rgba_lerp({r, g, b, a}, {r, g, b, 0}, math.abs(math.sin(globals.realtime() * 1.5)) ^ 3)

			if use_colors then
				for str, data in pairs(revival.preset.default) do
					if str == revival.preset.selected.name then
						table.insert(arr,  clr:to_string() .. "*" .. str)
					else
						table.insert(arr,  "*" .. str)
					end
				end

				for _, str in ipairs(this.get_local_presets()) do
					if str ==  revival.preset.selected.name then
						table.insert(arr,  clr:to_string() .. "custom: " .. str)
					else
						table.insert(arr,  "custom: " .. str)
					end
				end
			else
				for str, _ in pairs(revival.preset.default) do
					table.insert(arr,  str)
				end

				for _, str in ipairs(this.get_local_presets()) do
					table.insert(arr, str)
				end
			end

			return arr
		end

		this.get_selected_preset = function(index)
			local preset_list = this.get_preset_list()
			return preset_list[index + 1]
		end

		this.get_selected_preset_data = function(index)
			local name = this.get_selected_preset(index)
			local presets = this.get_local_presets()
			if not utility:contains(presets, name) then
				return true, name
			elseif not revival.config_data[name] then
				notifications:new(nil,"no $existing$ data for " .. name .. " preset", color(gui.vis.notifications_accent:get()))
				return
			end
			
			return revival.config_data[name], name
		end

		this.export_preset = function(state)
			local function loop(tbl, arr)
				local arr = arr or {}
				for k, v in pairs(tbl) do
					if getmetatable(v) == getmetatable(menu) then
						arr[k] = {v:get()}
					elseif type(v) == "table" then
						arr[k] = {}
						loop(v, arr[k])
					end
				end
				return arr
			end
			return loop(state)
		end

		this.import_preset = function(state, data)
			local function loop(arr, gui)
				for k, v in pairs(gui) do
					if getmetatable(v) == getmetatable(menu) and unpack(arr[k]) ~= nil then
						v:set(unpack(arr[k]))
					elseif type(v) == "table" then
						loop(arr[k], gui[k])
					end
				end
			end
			loop(data, state)
		end

		this.export = function(states)
			local function loop(tbl, arr)
				local arr = arr or {}
				for k, v in pairs(tbl) do
					if getmetatable(v) == getmetatable(menu) then
						arr[k] = {v:get()}
					elseif type(v) == "table" then
						arr[k] = {}
						loop(v, arr[k])
					end
				end
				return arr
			end
			local data = base64.encode(json.stringify(loop(states)))
			return data
		end

		this.import = function(states, data)
			local data = json.parse(base64.decode(data))
			local function loop(arr, gui)
				for k, v in pairs(gui) do
					if getmetatable(v) == getmetatable(menu) and unpack(arr[k]) ~= nil then
						v:set(unpack(arr[k]))
					elseif type(v) == "table" then
						loop(arr[k], gui[k])
					end
				end
			end
			loop(data, states)
		end

		this.clear_builder = function(gui)
			local data = json.parse([[{"body_yaw":["off"],"yaw_modifiers":[{}],"body_yaw_add":[0],"yaw_jitter":[0],"yaw_jitter_type":["offset"],"main":[false],"yaw_left":[0],"yaw_right":[0],"fake_limit":[60]}]])
			for _, team in pairs(gui.aa.main.states) do
				for _, state in pairs(team) do
					this.import_preset(state, data)
				end
			end
		end

		this.on_create = function(gui, name)
			this.clear_builder(gui)
			revival.preset.selected.name = name
			if name:match("%w") ~= nil then
				revival.config_data[name] = {}
				revival.preset.selected.editing = true
				notifications:new(nil,'successfully $created$ preset: ["'.. name .. '"]', color(gui.vis.notifications_accent:get()))
			else
				notifications:new(nil,"failed to $create$ preset due to $invalid name$", color(gui.vis.notifications_accent:get()))
				return
			end
			local preset_list = this.get_preset_list()
			ui.update(gui.aa.main.presets.item, preset_list)
			local index = (function()
				for i, v in ipairs(preset_list) do
					if v == name then
						return i
					end
				end
			end)()
			ui.set(gui.aa.main.presets.item, index - 1)
		end

		this.on_save = function(gui)
			revival.preset.selected.editing = false
			local data = this.export(gui.aa.main.states)
			revival.config_data[revival.preset.selected.name] = data
			database.write("revival_presets", revival.config_data)
			notifications:new(nil,'successfully $saved$ preset: ["'.. revival.preset.selected.name .. '"]', color(gui.vis.notifications_accent:get()))
			revival.preset.selected.data = data
		end

		this.on_import = function(gui)
			local data = clipboard.get()
			local arr = utility:split(data, "?")
			local name = arr[1]
			if name:match("%w") ~= nil and arr[2] ~= nil then
				revival.config_data[name] = arr[2]
				--notifications:new(nil,'successfully $created$ preset: ["'.. name .. '"]')
			else
				notifications:new(nil,"failed to $import$ preset due to $invalid data$", color(gui.vis.notifications_accent:get()))
				return
			end
			local preset_list = this.get_preset_list()
			ui.update(gui.aa.main.presets.item, preset_list)
			local index = (function()
				for i, v in ipairs(preset_list) do
					if v == name then
						return i
					end
				end
			end)()
			ui.set(gui.aa.main.presets.item, index - 1)
			notifications:new(nil,'successfully $imported$ preset: ["'.. name .. '"]', color(gui.vis.notifications_accent:get()))
		end

		this.on_export = function(gui)
			local data = this.export(gui.aa.main.states)
			local index = ui.get(gui.aa.main.presets.item) == -1 and 0 or ui.get(gui.aa.main.presets.item)
			local name = this.get_selected_preset(index)
			clipboard.set(name .. "?" .. data)
			notifications:new(nil,'successfully $exported$ preset: ["'.. name .. '"]', color(gui.vis.notifications_accent:get()))
		end

		this.on_edit = function(gui)
			revival.preset.selected.editing = true
			notifications:new(nil,'now $editing$ preset: ["'.. revival.preset.selected.name .. '"]', color(gui.vis.notifications_accent:get()))
		end

		this.on_delete = function(gui)
			local index = ui.get(gui.aa.main.presets.item) == -1 and 0 or ui.get(gui.aa.main.presets.item)
			local name = this.get_selected_preset(index)
			revival.config_data[name] = nil
			notifications:new(nil,'successfully $deleted$ preset: ["'.. name .. '"]', color(gui.vis.notifications_accent:get()))
			ui.set(gui.aa.main.presets.item, index - 1)
		end

		return this
	end,

	gui = function(color, utility, menu, config, clipboard, base64)
		local accent = color(ui.get(ref_menu_color))
		local this = {
			tab = menu.new("combobox", accent, "revival anti-aim system", {"anti-aim", "visuals", "misc"}), --"rage"
			space = ui.new_label("aa", "anti-aimbot angles", "»»»»»»»»»»»"),
			aa = {
				target_mode = menu.new("combobox", accent, "$>aa$ target selection", {"threat", "crosshair"}),
				subtab = menu.new("combobox", accent, "$>aa$ subtab", {"main", "extra"}),
				main = {
					presets = menu.new("listbox", accent, "\n$>aa$ presets", {}),
					exploit_toggle = menu.new("checkbox", accent, "\ab6b665ff" .. ">activate exploits"),
					flick_exploit = menu.new("hotkey", accent, "\ab6b665ff" .. ">exploits" .. "\affffff9b" .. " toggle defensive fake"),
					flick_mode = menu.new("combobox", accent, "\ab6b665ff" .. ">exploits" .. "\affffff9b" .. " defensive fake mode", {"freestand", "jitter", "inverter"}),
					flick_inverter_key = menu.new("hotkey", accent, "\ab6b665ff" .. ">exploits" .. "\affffff9b" .. " invert side"),
					selected_team = menu.new("combobox", accent, "$>editing$ team", {"terrorist", "counter terrorist"}),
					selected_state = menu.new("combobox", accent, "<$>editing$ selected state:", {"global", "stand", "duck", "slow move", "run", "jump", "duck jump", "fakelag", "height advantage"}),
					states = {},
				},
				extra  = {
					main = menu.new("checkbox", accent, "$>evade$ activate anti-brute"),
					triggers = menu.new("multiselect", accent, "$>evade$ on", {"hit", "miss"}),
					time = menu.new("slider", accent, "$>evade$ max time", 0, 10, 5, true, "s", 1, { [0] = "∞"}),
					mode = menu.new("combobox", accent, "$>evade$ anti-brute mode", {"default", "customized"}),
					yaw_min = menu.new("slider", accent, "$>evade$ " .. "yaw add min", -180, 180, -12, true, "°", 1),
					yaw_max = menu.new("slider", accent, "$>evade$ " .. "yaw add max", -180, 180, 12, true, "°", 1),
					jitter_min = menu.new("slider", accent, "$>evade$ " .. "jitter add min", -180, 180, 40, true, "°", 1),
					jitter_max = menu.new("slider", accent, "$>evade$ " .. "jitter add max", -180, 180, 60, true, "°", 1),
					limit_min = menu.new("slider", accent, "$>evade$ " .. "fake limit min", 0, 60, 45, true, "°", 1),
					limit_max = menu.new("slider", accent, "$>evade$ " .. "fake limit max", 0, 60, 60, true, "°", 1),
				}
			},
			rage = {
				rage_improvements = menu.new("multiselect", accent, "$>rage$ ragebot improvements", {"resolver logic", "defensive logic"}), -- "safepoint logic", "baim logic", "autostop logic"
				defensive_triggers = menu.new("multiselect", accent, "$>rage$ defensive triggers", {"always", "lagcomp break", "avoid height", "weapon switch", "ragebot fire"}) -- "accelerate", "in air"
			},
			misc = {
				resolver = menu.new("checkbox", accent, "$>misc$ custom resolver"),
				anim_breakers = menu.new("multiselect", accent, "$>misc$ animation breakers", {"break legs", "freeze legs", "break duck", "disable lean", "zero pitch on land"}),
				break_legs_mode = menu.new("combobox", accent, "$>misc$ break legs mode", {"inverted", "backwards", "broken"}),
				freestanding = menu.new("hotkey", accent, "$>misc$ freestanding key", 0),
				freestanding_disablers = menu.new("multiselect", accent, "    $>>$ disablers", {"stand", "duck", "slow move", "run", "jump", "duck jump"}),
				edge_yaw = menu.new("hotkey", accent, "$>misc$ edge yaw key", 0),
				manual = menu.new("checkbox", accent, "$>misc$ manual aa"),
				manual_left = menu.new("hotkey", accent, "    $>>$ manual left"),
				manual_right = menu.new("hotkey", accent, "    $>>$ manual right"),
				manual_forward = menu.new("hotkey", accent, "    $>>$ manual forward"),
			},
			vis = {
				style = menu.new("combobox", accent, "$>visuals$ indicator style", {"-", "#1", "#2", "#3"}),
				options = menu.new("multiselect", accent, "    $>>$ indicator options", {"build", "name", "delta", "state", "binds"}),
				positioning = menu.new("combobox", accent, "$>visuals$ indicator positioning", {"centered", "right aligned", "dynamic"}),
				primary_accent = menu.new("color_picker", accent, "    $>>$ primary accent", 0, color(212, 179, 255, 255)),
				secondary_accent = menu.new("color_picker", accent, "    $>>$ secondary accent", 0, color(212, 179, 255, 255)),
				third_accent = menu.new("color_picker", accent, "    $>>$ third accent", 0, color(212, 179, 255, 255)),
				keybind_accent = menu.new("color_picker", accent, "    $>>$ keybind accent", 0, color(212, 179, 255, 255)),
				glow_accent = menu.new("color_picker", accent, "    $>>$ glow accent", 0, color(212, 179, 255, 255)),
				extras = menu.new("multiselect", accent, "$>visuals$ visual extras", {"notifications", "side panel", "manual arrows"}), --"peek arrows"
				notifications_accent = menu.new("color_picker", accent, "    $>>$ notifications accent", 0, color(212, 179, 255, 255)),
				manual_accent = menu.new("color_picker", accent, "    $>>$ manual arrows accent", 0, color(212, 179, 255, 255)),
				peek_accent = menu.new("color_picker", accent, "    $>>$ peek arrows accent", 0, color(212, 179, 255, 255)),
			}
		}

		for _, team in pairs({"terrorist", "counter terrorist"}) do
			this.aa.main.states[team] = {}
			for k, v in pairs({"global", "stand", "duck", "slow move", "run", "jump", "duck jump", "fakelag", "height advantage"}) do
				this.aa.main.states[team][v] = {
					main = ((v ~= "global") and menu.new("checkbox", accent, "activate" .. " <$"..v.."$> " .. "\n" .. team)) or nil,
					body_yaw = menu.new("combobox", accent, "<$"..v.."$> " .. "body yaw" .. "\n" .. team, {"off", "static", "jitter", "opposite"}),
					body_yaw_add = menu.new("slider", accent, "<$"..v.."$> " .. "body yaw add" .. "\n" .. team, -180, 180, 0, true, "°", 1),
					yaw_modifiers = menu.new("multiselect", accent, "<$"..v.."$> " .. "yaw modifiers" .. "\n" .. team, {"left/right yaw add", "yaw jitter"}),
					yaw_left = menu.new("slider", accent, "<$"..v.."$> " .. "yaw add left" .. "\n" .. team, -180, 180, 0, true, "°", 1),
					yaw_right = menu.new("slider", accent, "<$"..v.."$> " .. "yaw add right" .. "\n" .. team, -180, 180, 0, true, "°", 1),
					yaw_jitter_type = menu.new("combobox", accent, "<$"..v.."$> " .. "yaw jitter type" .. "\n" .. team, {"offset", "center", "random"}),
					yaw_jitter = menu.new("slider", accent, "<$"..v.."$> " .. "yaw jitter" .. "\n" .. team, -180, 180, 0, true, "°", 1),
					fake_limit = menu.new("slider", accent, "<$"..v.."$> " .. "fake limit" .. "\n" .. team, 0, 60, 60, true, "°", 1)
				}
			end
		end

		this.aa.main.name = ui.new_textbox("aa", "anti-aimbot angles", "+ create local preset")
		this.aa.main.select = ui.new_button("aa", "anti-aimbot angles", "select preset", function() end)
		this.aa.main.create = ui.new_button("aa", "anti-aimbot angles", "create", function() end)
		this.aa.main.edit = ui.new_button("aa", "anti-aimbot angles", "edit", function() end)
		this.aa.main.export = ui.new_button("aa", "anti-aimbot angles", "export to clipboard", function() end)
		this.aa.main.import = ui.new_button("aa", "anti-aimbot angles", "import from clipboard", function() end)
		this.aa.main.save = ui.new_button("aa", "anti-aimbot angles", "save", function() end)
		this.aa.main.delete = ui.new_button("aa", "anti-aimbot angles", "delete", function() revival.preset.delete = true end)
		this.aa.main.delete_confirm = ui.new_button("aa", "anti-aimbot angles", "confirm delete", function() end)
		this.aa.main.delete_cancel = ui.new_button("aa", "anti-aimbot angles", "cancel", function() revival.preset.delete = false end)
		this.aa.main.export_state = ui.new_button("aa", "anti-aimbot angles", "copy state to clipboard", function() end)
		this.aa.main.import_state = ui.new_button("aa", "anti-aimbot angles", "save state from clipboard", function() end)

		ui.update(this.aa.main.presets.item, config.get_preset_list(true))

		this.callback = function()
			ui.update(this.aa.main.presets.item, config.get_preset_list(true))

			local index = ui.get(this.aa.main.presets.item) == -1 and 0 or ui.get(this.aa.main.presets.item)

			local main = true
			local tab = this.tab:get()
			local selected_settings = this.aa.subtab:get()
			local exploit_toggle = this.aa.main.exploit_toggle:get()
			local selected_state = this.aa.main.selected_state:get()
			local selected_team = this.aa.main.selected_team:get()
			local antibrute = this.aa.extra.main:get()
			local antibrute_mode = this.aa.extra.mode:get()
			local anim_breakers = this.misc.anim_breakers:get()
			local manual = this.misc.manual:get()
			local style = this.vis.style:get()
			local extras = this.vis.extras:get()
			local rage_improvements = this.rage.rage_improvements:get()
			--local additives = this.aa.additives:get()

			local selected_preset = config.get_selected_preset(index)

			ui.set_visible(this.space, main)

			this.aa.target_mode:set_visible(main and tab == "anti-aim" and not revival.preset.selected.editing)
			this.aa.subtab:set_visible(main and tab == "anti-aim" and not revival.preset.selected.editing)
			this.aa.main.presets:set_visible(main and tab == "anti-aim" and selected_settings == "main" and not revival.preset.selected.editing)
			this.aa.main.exploit_toggle:set_visible(main and tab == "anti-aim" and selected_settings == "main" and not revival.preset.selected.editing)
			this.aa.main.flick_exploit:set_visible(main and tab == "anti-aim" and selected_settings == "main" and not revival.preset.selected.editing and exploit_toggle)
			this.aa.main.flick_mode:set_visible(main and tab == "anti-aim" and selected_settings == "main" and not revival.preset.selected.editing and exploit_toggle)
			this.aa.main.flick_inverter_key:set_visible(main and tab == "anti-aim" and selected_settings == "main" and not revival.preset.selected.editing and exploit_toggle and this.aa.main.flick_mode:get() == "inverter")
			this.aa.main.selected_state:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing)
			this.aa.main.selected_team:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing)
			--ui.set_visible(this.aa.main.label, main and tab == "aa" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and not revival.preset.selected.editing)
			ui.set_visible(this.aa.main.name, main and tab == "anti-aim" and selected_settings == "main" and selected_preset == "+ create local preset")
			ui.set_visible(this.aa.main.select, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and not revival.preset.delete and selected_preset ~= revival.preset.selected.name)
			ui.set_visible(this.aa.main.create, main and tab == "anti-aim" and selected_settings == "main" and selected_preset == "+ create local preset")
			ui.set_visible(this.aa.main.edit, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and utility:contains(config.get_local_presets(), selected_preset) and not revival.preset.selected.editing and not revival.preset.delete and selected_preset == revival.preset.selected.name)
			ui.set_visible(this.aa.main.export, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and utility:contains(config.get_local_presets(), selected_preset) and not revival.preset.selected.editing and not revival.preset.delete)
			ui.set_visible(this.aa.main.import, main and tab == "anti-aim" and selected_settings == "main" and selected_preset == "+ import from clipboard" )
			ui.set_visible(this.aa.main.save, main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing)
			ui.set_visible(this.aa.main.delete, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and utility:contains(config.get_local_presets(), selected_preset) and not revival.preset.selected.editing and not revival.preset.delete)
			ui.set_visible(this.aa.main.delete_cancel, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and utility:contains(config.get_local_presets(), selected_preset) and not revival.preset.selected.editing and revival.preset.delete)
			ui.set_visible(this.aa.main.delete_confirm, main and tab == "anti-aim" and selected_settings == "main" and selected_preset ~= "+ create local preset" and selected_preset ~= "+ import from clipboard" and utility:contains(config.get_local_presets(), selected_preset) and not revival.preset.selected.editing and revival.preset.delete)
			ui.set_visible(this.aa.main.export_state, main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing)
			ui.set_visible(this.aa.main.import_state, main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing)

			this.aa.extra.main:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and not revival.preset.selected.editing)
			this.aa.extra.mode:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing)
			this.aa.extra.time:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing)
			this.aa.extra.triggers:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing)
			this.aa.extra.yaw_min:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")
			this.aa.extra.yaw_max:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")
			this.aa.extra.jitter_min:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")
			this.aa.extra.jitter_max:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")
			this.aa.extra.limit_max:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")
			this.aa.extra.limit_min:set_visible(main and tab == "anti-aim" and selected_settings == "extra" and antibrute and not revival.preset.selected.editing and antibrute_mode == "customized")

			this.misc.anim_breakers:set_visible(main and tab == "misc")
			this.misc.break_legs_mode:set_visible(main and tab == "misc" and utility:contains(anim_breakers, "break legs"))
			this.misc.freestanding:set_visible(main and tab == "misc")
			this.misc.freestanding_disablers:set_visible(main and tab == "misc")
			this.misc.edge_yaw:set_visible(main and tab == "misc")
			this.misc.manual:set_visible(main and tab == "misc")
			this.misc.manual_forward:set_visible(main and tab == "misc" and manual)
			this.misc.manual_left:set_visible(main and tab == "misc" and manual)
			this.misc.manual_right:set_visible(main and tab == "misc" and manual)
			this.misc.resolver:set_visible(main and tab == "misc")

			this.rage.rage_improvements:set_visible(main and tab == "rage")
			this.rage.defensive_triggers:set_visible(main and tab == "rage" and utility:contains(rage_improvements, "defensive logic"))

			this.vis.style:set_visible(main and tab == "visuals")
			this.vis.options:set_visible(main and tab == "visuals" and style == "#2")
			this.vis.positioning:set_visible(main and tab == "visuals" and style ~= "-")
			this.vis.primary_accent:set_visible(main and tab == "visuals" and style ~= "-")
			this.vis.secondary_accent:set_visible(main and tab == "visuals" and style ~= "-" and style ~= "#3")
			this.vis.third_accent:set_visible(main and tab == "visuals" and style == "#2")
			this.vis.keybind_accent:set_visible(main and tab == "visuals" and style ~= "-" and style ~= "#3")
			this.vis.glow_accent:set_visible(main and tab == "visuals" and style == "#2")
			this.vis.extras:set_visible(main and tab == "visuals")
			this.vis.notifications_accent:set_visible(main and tab == "visuals" and utility:contains(extras, "notifications"))
			this.vis.manual_accent:set_visible(main and tab == "visuals" and utility:contains(extras, "manual arrows"))
			this.vis.peek_accent:set_visible(main and tab == "visuals" and utility:contains(extras, "peek arrows"))

			for team, states in pairs(this.aa.main.states) do
				for k, v in pairs(states) do
					local yaw_modifiers = v.yaw_modifiers:get()
					local active = true
					if v.main ~= nil then
						active = v.main:get()
						v.main:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and selected_team == team)
					end
					v.body_yaw:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and selected_team == team)
					v.body_yaw_add:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and selected_team == team)
					v.yaw_modifiers:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and selected_team == team)
					v.yaw_left:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and utility:contains(yaw_modifiers, "left/right yaw add") and selected_team == team)
					v.yaw_right:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and utility:contains(yaw_modifiers, "left/right yaw add") and selected_team == team)
					v.yaw_jitter_type:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and utility:contains(yaw_modifiers, "yaw jitter") and selected_team == team)
					v.yaw_jitter:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and utility:contains(yaw_modifiers, "yaw jitter") and selected_team == team)
					v.fake_limit:set_visible(main and tab == "anti-aim" and selected_settings == "main" and revival.preset.selected.editing and selected_state == k and active and selected_team == team)
				end
			end
		end

		utility:iterate(this, function(k, v) return getmetatable(v) == getmetatable(menu) end, function(k, v) v:set_callback(this.callback) end)
	
		local function update_color(accent)
			utility:iterate(this, function(k, v) return getmetatable(v) == getmetatable(menu) end, function(k, v) v:update_color(accent) end)
		end

		ui.set_callback(ref_menu_color, function()
			update_color(color(ui.get(ref_menu_color)), this)
		end)
	
		return this
	end,

	fakelag = function(utility, record, vector, extrapolation)
		local this = {
			weap = nil,
			last_shot = 0,
			last_defensive_tick = 0,
			has_switched_tick = false
		}

		this.get_limit = function()
			local me = entity.get_local_player()
			local limit = 15
			if not ui.get(ref_fd) then
				if ui.get(ref_dt) and ui.get(ref_dt_key) then
					limit = ui.get(ref_dt_fl)
				elseif utility:in_air(me) then
					limit = math.random(13,15)
				end
			end
			return limit
		end

		this.run = function(cmd)
			local limit = this.get_limit()
			if globals.chokedcommands() < limit then
				cmd.allow_send_packet = 0
				revival.send_packet = false
			else
				cmd.allow_send_packet = 1
				revival.send_packet = true
			end

		end

		this.get_defensive_triggers = function(triggers)
			if utility:contains(triggers, "always") then
				local me = entity.get_local_player()
				local defensive_time = record.get_defensive_time(me)

				if defensive_time ~= nil and defensive_time > 0 then
					this.last_defensive_tick = globals.tickcount()
				end

				if globals.tickcount() - this.last_defensive_tick > 1 then
					return true
				end

				--print(defensive_time)

				--if defensive_time ~= nil and (defensive_time == 2 or defensive_time == 1) then
				--	ui.set(ref_dt_fl, 6)
				--	this.has_switched_tick = true
				--	return false
				--elseif defensive_time == nil or defensive_time == 0 then
				--	ui.set(ref_dt_fl, 1)
				--	this.has_switched_tick = false
				--	return true
				--end

				return true
			end
			local me = entity.get_local_player()
			if not revival.m_records[me] or record.get_defensive_time(me) > 0 then
				return false
			end
			local origin = revival.m_records[me][1].origin
			local data = extrapolation:run("default", me, 12, origin)
			if utility:contains(triggers, "lagcomp break") then
				if data.origin:dist2d(origin) >= 64 then
					return true
				end
			end
			
			if utility:contains(triggers, "avoid height") then
				local velocity = vector(entity.get_prop(me, "m_vecVelocity"))
				if data.origin.z < origin.z and velocity.z > 0 then
					return true
				end
			end

			if utility:contains(triggers, "weapon switch") then
				local weapon = entity.get_player_weapon(me)
				if this.weapon ~= weapon then
					this.weapon = weapon
					return true
				end
				this.weapon = weapon
			end

			if utility:contains(triggers, "ragebot fire") then
				if this.last_shot == globals.tickcount() then	
					return true
				end
			end

			return false
		end

		this.run_defensive = function(cmd, triggers)
			cmd.force_defensive = this.get_defensive_triggers(triggers)
		end

		return this
	end,

	functions = function(vector, trace, utility, notifications, record, extrapolation, gui, fakelag, menu, clipboard, base64, color)
		local desync = (function()
			local desync = {
				flip = false,
				last_throw_time = 0
			}

			desync.can_desync = function(cmd)
				local me = entity.get_local_player()

				if not entity.is_alive(me) then
					return false
				end

				if cmd.in_use == 1 then
					return false
				end

				local weapon_ent = entity.get_player_weapon(me)
				if cmd.in_attack == 1 then
					if weapon_ent then
						local class_name = entity.get_classname(weapon_ent)
						if class_name:find("Grenade") then
							desync.last_throw_time = globals.tickcount()
						else
							if math.max(entity.get_prop(weapon_ent, "m_flNextPrimaryAttack"), entity.get_prop(me, "m_flNextAttack")) - globals.tickinterval() < globals.curtime() then
								return false
							end
						end
					end
				end

				local throw_time = entity.get_prop(weapon_ent, "m_fThrowTime")

				if desync.last_throw_time + 8 == globals.tickcount() or (desync.last_throw_time + 8 - globals.tickcount() < 0 and throw_time ~= nil and throw_time ~= 0) then
					return false
				end

				if entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1 then
					return false
				end

				if entity.get_prop(me, "m_MoveType") == 9 and utility:get_velocity(me) ~= 0 then
					return false
				end

				return true
			end

			desync.get_base_yaw = function()
				local target = client.current_threat()

				if not target then
					local _, yaw = client.camera_angles()
					return yaw
				else
					local forward = vector(entity.get_origin(entity.get_local_player())):to(vector(entity.get_origin(target)))
					local _, yaw = forward:angles()
					return yaw
				end
			end

			desync.get_freestand = function()
				if not revival.target.ent then
					return
				end

				local me = entity.get_local_player()
				local from = revival.target.origin + vector(0,0,64)
				local data = {
					left = 0,
					right = 0,
					mid = 0
				}
				for _, angle in ipairs({-90, 0, 90}) do
					local to = vector(client.eye_position()) + vector():init_from_angles(0, revival.target.angles.yaw + 180 + angle, 0):scaled(40)
					local _, damage = client.trace_bullet(revival.target.ent, from.x, from.y, from.z, to.x, to.y, to.z, me)

					if angle > 0 then
						data.left = damage
					elseif angle < 0 then
						data.right = damage
					else
						data.mid = damage
					end
				end

				if data.left > data.right and data.right == 0 and data.mid * 1.1 < data.left then
					return -90
				elseif data.right > data.left and data.left == 0 and data.mid * 1.1 < data.right then
					return 90
				end
				--opposite
				local from = vector(client.eye_position())
				local data = {
					left = 0,
					right = 0,
					mid = 0
				}
				for _, angle in ipairs({-90, 0, 90}) do
					local to = revival.target.origin + vector(0,0,64) + vector():init_from_angles(0, revival.target.angles.yaw + 180 + angle, 0):scaled(48)
					local _, damage = client.trace_bullet(me, from.x, from.y, from.z, to.x, to.y, to.z, revival.target.ent)

					if angle > 0 then
						data.right = damage
					elseif angle < 0 then
						data.left = damage
					else
						data.mid = damage
					end
				end

				if data.left > data.right and data.right == 0 and data.mid * 1.1 < data.left then
					return -90
				elseif data.right > data.left and data.left == 0 and data.mid * 1.1 < data.right then
					return 90
				end
			end

			desync.get_yaw = function(cmd, data, manual_offset)
				local yaw = desync.get_base_yaw()
				if gui.misc.freestanding:get() then
					local angle = desync.get_freestand()
					if angle then
						yaw = yaw + angle
					end
				end
				if gui.misc.edge_yaw:get() then
					local angle = trace.get_edge_yaw()
					if angle then
						yaw = angle
					end
				end
				local offset = revival.desync_switch and data.yaw_add_left or data.yaw_add_right
				if data.yaw_jitter == "offset" then
					offset = offset + (revival.desync_switch and 0 or data.yaw_jitter_add)
				elseif data.yaw_jitter == "center" then
					offset = offset + (revival.desync_switch and -1 or 1) * data.yaw_jitter_add/2
				elseif data.yaw_jitter == "random" then
					offset = offset + math.random(-data.yaw_jitter_add/2, data.yaw_jitter_add/2)
				end
					
				local defensive_time = record.get_defensive_time(entity.get_local_player())
				local defensive_active = defensive_time ~= 0
				if globals.chokedcommands() ~= 0 then --revival.send_packet
					yaw = yaw + 180 + offset + manual_offset
					if revival.had_defensive ~= defensive_active and defensive_active then
						yaw = yaw + 180 + offset + manual_offset + (revival.desync_switch and 90 or -90)
					end
					revival.had_defensive = defensive_active
				else
					revival.desync_switch = not revival.desync_switch
					cmd.allow_send_packet = 0
					local fake_limit = data.fake_limit/60 * math.deg(1)
					if data.body_yaw == "static" or data.body_yaw == "opposite" then
						yaw = yaw + 180 + manual_offset + (data.body_yaw_add > 0 and 1 or (data.body_yaw_add < 0 and -1 or 0)) * (math.deg(1) + fake_limit)
					elseif data.body_yaw == "jitter" then
						yaw = yaw + 180 + manual_offset + (revival.desync_switch and 1 or -1) * (math.deg(1) + fake_limit)
					else
						yaw = yaw + 180 + manual_offset
					end
				end

				return yaw
			end

			desync.do_micromovements = function(cmd)
				local me = entity.get_local_player()
				local speed = 1.01
				local vel = utility:get_velocity(me)

				if vel > 1.2 then
					return
				end

				if utility:in_duck(me) or ui.get(ref_fd) then
					speed = speed * 2.94117647
				end
		
				revival.switch_move = revival.switch_move or false
		
				if revival.switch_move then
					cmd.sidemove = cmd.sidemove + speed
				else
					cmd.sidemove = cmd.sidemove - speed
				end
		
				revival.switch_move = not revival.switch_move
			end

			desync.do_anti_layer_six = function(cmd) -- LAYER 6 ANTI EXLOIT RESOLVING SYSTEM

			end

			desync.run = function(cmd, data, manual_yaw)
				if not desync.can_desync(cmd) then
					return
				end

				desync.do_micromovements(cmd)

				local yaw = desync.get_yaw(cmd, data, manual_yaw)
				cmd.pitch, cmd.yaw, cmd.roll = 88.9, yaw, 0
				ui.set(ref_aa_enabled, false)
			end

			desync.run_alt = function(cmd, manual_yaw)
				if not desync.can_desync(cmd) then
					return
				end

				desync.do_micromovements(cmd)

				local yaw = desync.get_base_yaw()
				local angle = 180 + yaw + manual_yaw
				if gui.misc.freestanding:get() then
					local yaw = desync.get_freestand()
					if yaw then
						angle = angle + yaw
					end
				end
				if gui.misc.edge_yaw:get() then
					local yaw = trace.get_edge_yaw()
					if yaw then
						angle = yaw
					end
				end
				if globals.chokedcommands() >= 1 then
					revival.desync_switch = not revival.desync_switch
					angle = angle + (revival.desync_switch and -33 or 33)
				else
					cmd.allow_send_packet = false
				end

				cmd.yaw = angle
				cmd.pitch = 89
			end

			return desync
		end)()

		local antiaim = (function()
			local antiaim = {
				_set = false,
				keys = {false, false, false},
				state = 4,
				antibrute = {},
				max_achieved = false,
				five_way_counter = 1,
				defensive_timer = 0,
				flicker_switch = true,
				defensive = 0,
				checker = 0,
			}

			antiaim.get_target = function(use_threat)
				local me = entity.get_local_player()
				local _, c_yaw = client.camera_angles()
				local from = vector(entity.get_origin(me))
				local data = {
					ent = nil,
					fov = 180
				}
				if use_threat then
					local ent = client.current_threat()
					if ent ~= nil and not entity.is_dormant(ent) and entity.is_alive(ent) then
						local to = vector(entity.get_origin(ent))
						local pitch, yaw = (to - from):angles()
						local fov = math.abs(utility:normalize_yaw(c_yaw - yaw))
						data = {
							ent = ent,
							fov = fov,
							origin = to,
							angles = {
								pitch = pitch,
								yaw = yaw
							}
						}
					end

					return data
				else
					local players = entity.get_players(true)
					for i, ent in ipairs(players) do
						local to = vector(entity.get_origin(ent))
						local pitch, yaw = (to - from):angles()
						local fov = math.abs(utility:normalize_yaw(c_yaw - yaw))
						if fov < data.fov then
							data = {
								ent = ent,
								fov = fov,
								origin = to,
								angles = {
									pitch = pitch,
									yaw = yaw
								}
							}
						end
					end
					return data
				end
			end

			antiaim.get_state = function(ent)
				local vel = utility:get_velocity(ent)
				local air = utility:in_air(ent)
				local duck = utility:in_duck(ent)

				local state = vel > 3 and "run" or "stand"
				if air or (ent == entity.get_local_player() and revival.was_in_air) then
					state = duck and "duck jump" or "jump"
				elseif ui.get(ref_slowmotion_key) and ui.get(ref_slowmotion) and ent == entity.get_local_player() then
					state = "slow move"
				elseif duck then
					state = "duck"
				end

				if ent == entity.get_local_player() then
					revival.was_in_air = air
				end

				return state
			end

			antiaim.get_freestand = function()
				if not revival.target.ent then
					return
				end
				local me = entity.get_local_player()
				local leye = vector(client.eye_position())
				local teye = revival.target.origin + vector(0,0,64)

				local data = {left = 0, right = 0}
				for index, val in ipairs({{leye, teye, me, 1}, {teye, leye, revival.target.ent, -1}}) do
					local from = val[1]
					local to = val[2]
					local ent = val[3]
					for _, angle in ipairs({-90,90}) do
						local to = to + vector():init_from_angles(0, revival.target.angles.yaw + val[4] *angle, 0) * 64
						local _, damage = client.trace_bullet(ent, from.x, from.y, from.z, to.x, to.y, to.z, ent)

						local side = (angle < 0) and "left" or "right"
						if index ~= 1 then
							side = (side == "left") and "right" or "left"
						end

						data[side] = data[side] + damage
					end
				end

				if data.left > data.right then
					return 0
				elseif data.right > data.left then
					return 1
				elseif data.right + data.left ~= 0 then
					return 2
				else
					return nil
				end
			end

			antiaim.get_world_freestand = function()
				local me = entity.get_local_player()
				local pos = vector(client.eye_position())
				local _, yaw = client.camera_angles()
				local data = {left = 0, right = 0}
				for _, ang in ipairs({-90, -45, 45, 90}) do
					local vec = vector():init_from_angles(0, yaw + ang, 0)
					local to = vec:scaled(8192) + pos

					local trace = client.trace_line(me, pos.x, pos.y, pos.z, to.x, to.y, to.z)

					data[ang > 0 and "left" or "right"] = data[ang > 0 and "left" or "right"] + trace
				end

				if data.left > data.right then
					return 0
				elseif data.right > data.left then
					return 1
				end
			end

			antiaim.do_micromovements = function(cmd)
				local me = entity.get_local_player()
				local speed = 1.01
				local vel = utility:get_velocity(me)

				if vel > 1.2 then
					return
				end

				if utility:in_duck(me) or ui.get(ref_fd) then
					speed = speed * 2.94117647
				end
		
				revival.switch_move = revival.switch_move or false
		
				if revival.switch_move then
					cmd.sidemove = cmd.sidemove + speed
				else
					cmd.sidemove = cmd.sidemove - speed
				end
		
				revival.switch_move = not revival.switch_move
			end

			antiaim.do_movement_jitter = function()
				local me = entity.get_local_player()
				local weapon_ent = entity.get_player_weapon(me)
				if not weapon_ent then
					return
				end

				local weapon = csgo_weapons(weapon_ent)
				if not weapon then
					return
				end
				
				local velocity = math.floor(vector(entity.get_prop(me, "m_vecvelocity")):length())

				local max_player_speed = (entity.get_prop(me, "m_bIsScoped") == 1) and weapon.max_player_speed_alt or weapon.max_player_speed
				
				local speed = antiaim.max_achieved and max_player_speed or max_player_speed * 0.95
				if antiaim.max_achieved then
					if velocity >= max_player_speed * 0.99 then
						antiaim.max_achieved = false
					end
				elseif velocity <= max_player_speed * 0.95 then
					antiaim.max_achieved = true
				end

				cvar.cl_sidespeed:set_int(speed)
				cvar.cl_forwardspeed:set_int(speed)
				cvar.cl_backspeed:set_int(speed)
			end

			antiaim.get_manual_yaw = function()
				if not gui.misc.manual:get() then
					return 0
				end
				local left, right, forward = gui.misc.manual_left:get(), gui.misc.manual_right:get(), gui.misc.manual_forward:get()

				for k, v in ipairs({left, right, forward}) do
					if v ~= antiaim.keys[k] then
						if antiaim.state == k then
							antiaim.state = 4
						else
							antiaim.state = k
						end
						break
					end
				end

				antiaim.keys = {left, right, forward}

				local yaw = {-90, 90, -179, 0}
				return yaw[antiaim.state]
			end

			antiaim.create_data = function(body, body_add, yaw_add_left, yaw_add_right, yaw_j, yaw_jadd, limit)
				return {
					body_yaw = body,
					body_yaw_add = body_add,
					yaw_add_left = yaw_add_left,
					yaw_add_right = yaw_add_right,
					yaw_jitter = yaw_j,
					yaw_jitter_add = yaw_jadd,
					fake_limit = limit
				}
			end

			antiaim.get_bruteforce = function(data)
				local time = gui.aa.extra.time:get() / globals.tickinterval()
				if not gui.aa.extra.main:get() or revival.shots.bruteforce[revival.target.ent] == nil then
					return
				end

				if revival.shots.bruteforce[revival.target.ent].inactive or (time ~= 0 and revival.shots.bruteforce[revival.target.ent].tick + time < globals.tickcount()) then
					if time ~= 0 and revival.shots.bruteforce[revival.target.ent].tick + time < globals.tickcount() and revival.shots.bruteforce[revival.target.ent].inactive ~= true then
						revival.shots.bruteforce[revival.target.ent].inactive = true
						notifications:new(nil, "reset $evade$ data due to timer", color(gui.vis.notifications_accent:get()))
					end
					return
				end

				local custom = gui.aa.extra.mode:get() == "customized"

				antiaim.antibrute[revival.target.ent] = antiaim.antibrute[revival.target.ent] or {}

				if revival.shots.bruteforce[revival.target.ent].shots ~= antiaim.antibrute[revival.target.ent].shots then
					local body_add = (revival.shots.bruteforce[revival.target.ent].shots % 2 == 1) and -data.body_yaw_add or data.body_yaw_add
					local yaw_add_left = data.yaw_add_left
					local yaw_add_right = data.yaw_add_right
					if yaw_add_right + yaw_add_left ~= 0 then
						yaw_add_left = custom and math.random(gui.aa.extra.yaw_min:get(), gui.aa.extra.yaw_max:get()) or math.random(-12, 17)
						yaw_add_right = custom and math.random(gui.aa.extra.yaw_min:get(), gui.aa.extra.yaw_max:get()) or math.random(-12, 17)
					end
					local yaw_jitter_add = custom and math.random(gui.aa.extra.jitter_min:get(), gui.aa.extra.jitter_max:get()) or math.random(40, 66)
					local limit = custom and math.random(gui.aa.extra.limit_min:get(), gui.aa.extra.limit_max:get()) or math.random(21, 60)

					antiaim.antibrute[revival.target.ent] = {
						shots = revival.shots.bruteforce[revival.target.ent].shots,
						data = antiaim.create_data(data.body_yaw, body_add, yaw_add_left, yaw_add_right, data.yaw_jitter, yaw_jitter_add, limit)
					}

					notifications:new(nil, "generated new $antiaim$ settings due to $evade$", color(gui.vis.notifications_accent:get()))
				end

				if data.body_yaw == "opposite" or data.body_yaw == "static" then
					return antiaim.create_data(data.body_yaw, antiaim.antibrute[revival.target.ent].data.body_yaw_add, data.yaw_add_left, data.yaw_add_right, data.yaw_jitter, data.yaw_jitter_add, antiaim.antibrute[revival.target.ent].data.fake_limit)
				else
					return antiaim.create_data(data.body_yaw, antiaim.antibrute[revival.target.ent].data.body_yaw_add, antiaim.antibrute[revival.target.ent].data.yaw_add_left, antiaim.antibrute[revival.target.ent].data.yaw_add_right, data.yaw_jitter, antiaim.antibrute[revival.target.ent].data.yaw_jitter_add, antiaim.antibrute[revival.target.ent].data.fake_limit)
				end
			end

			antiaim.set = function(data)
				if data == nil then
					return
				end

				local me = entity.get_local_player()
				local delta = utility:get_delta(me)
				local defensive_time = record.get_defensive_time(me)

				local yaw_add = (delta > 0 and data.yaw_add_left or data.yaw_add_right)

				local manual_yaw = antiaim.get_manual_yaw()
				if data.body_yaw == "static" then
					ui.set(ref_bodyyaw, "static")
					antiaim._set = false
				elseif not antiaim._set then
					ui.set(ref_bodyyaw, "static")
					ui.set(ref_bodyyawadd, 60)
					antiaim._set = true
				else
					ui.set(ref_bodyyaw, data.body_yaw)
				end

				ui.set(ref_bodyyawadd, data.body_yaw_add)
				if globals.chokedcommands() == 0 then
					ui.set(ref_yawadd, utility:normalize_yaw(yaw_add + manual_yaw))
				end

				ui.set(ref_yawj, data.yaw_jitter)
				ui.set(ref_yawjadd, data.yaw_jitter_add)
				ui.set(ref_fakelimit, data.fake_limit)

				ui.set(ref_aa_enabled, true)
				if defensive_time ~= nil and defensive_time > 0 and revival.target.ent ~= nil then
					ui.set(ref_untrusted, true)
					ui.set(ref_pitch, "Minimal")
				else
					ui.set(ref_untrusted, true)
					ui.set(ref_pitch, "Minimal")
				end
				ui.set(ref_yaw_base, "At targets")
				ui.set(ref_yaw, "180")
				ui.set(ref_fs_bodyyaw, false)
				ui.set(ref_roll, 0)
			end

			antiaim.run = function(cmd, exploit)
				local me = entity.get_local_player()
				revival.freestand_side = antiaim.get_world_freestand()

				local team = entity.get_prop(me, "m_iTeamNum") == 3 and "counter terrorist" or "terrorist"

				local data

				antiaim.do_movement_jitter()

				if fakelag.last_shot >= 0 then
					fakelag.last_shot = fakelag.last_shot - 1
				end

				if gui.aa.main.exploit_toggle:get() then
					if utility:in_air(me) or gui.aa.main.flick_exploit:get() then
						cmd.force_defensive = true
						antiaim.defensive_timer = antiaim.defensive_timer + 1
						ui.set(ref_dt_mode, ui.get(ref_dt_mode) == "Offensive" and "Defensive" or "Defensive")

						if antiaim.defensive_timer == 3 then
							cmd.force_defensive = false
							cmd.allow_shift_tickbase = false
							antiaim.defensive_timer = 0
						end

						if fakelag.last_shot >= 0 then
							cmd.allow_shift_tickbase = false
						end
					end
				end

				if exploit and revival.freestand_side and revival.freestand_side ~= 2 then
					local side = revival.freestand_side == 1
					if gui.aa.main.flick_mode:get() == "jitter" then
						side = antiaim.flicker_switch
					elseif gui.aa.main.flick_mode:get() == "inverter" then
						side = gui.aa.main.flick_inverter_key:get()
					end

					local body_yaw = "static"
					local body_yaw_add = side and 60 or -60
					local yaw_add = side and -20 or 20

					if antiaim.defensive_timer == 2 then
						if antiaim.defensive ~= 0 then
							antiaim.flicker_switch = not antiaim.flicker_switch
							body_yaw = "static"
							yaw_add = side and 90 or -90
						else
							body_yaw = "off"
							yaw_add = side and 20 or -20
						end
					end

					if not ref_nade_helper_success or (ref_nade_helper_success and not ui.get(ref_nade_helper_key)) then
						antiaim.do_micromovements(cmd)
					end

					data = antiaim.create_data(body_yaw, body_yaw_add, yaw_add, yaw_add, "off", 0, 60)
				else
					if cmd.chokedcommands == 0 then
						cmd.allow_send_packet = false
					end

					if revival.preset.selected.data == true then
						if revival.preset.selected.name == "default" then
						if type(revival.preset.default["default"]) == "string" then 
							revival.preset.default["default"] = json.parse(base64.decode(revival.preset.default["default"]))
						end

						local preset = revival.preset.default["default"]

						if unpack(preset[team]["fakelag"].main) and not (ui.get(ref_dt) or ui.get(ref_dt_key)) and not (ui.get(ref_hs) or ui.get(ref_hs_key)) and not ui.get(ref_fd) then
							revival.state = "fakelag"
						elseif unpack(preset[team]["height advantage"].main) and revival.target ~= nil and revival.target.angles ~= nil and revival.target.angles.pitch > 45 then
							revival.state = "height advantage"
						end

						local arr = preset[team][revival.state]
						if not unpack(arr.main) then
							arr = preset[team]["global"]
						end
		
						local body = unpack(arr.body_yaw)
						local body_add = unpack(arr.body_yaw_add)
						local yaw_add_left = unpack(arr.yaw_left)
						local yaw_add_right = unpack(arr.yaw_right)
						if not utility:contains(unpack(arr.yaw_modifiers), "left/right yaw add") then
							yaw_add_left = 0
							yaw_add_right = 0
						end
						local yaw_j = utility:contains(unpack(arr.yaw_modifiers), "yaw jitter") and unpack(arr.yaw_jitter_type) or "off"
						local yaw_jadd = utility:contains(unpack(arr.yaw_modifiers), "yaw jitter") and unpack(arr.yaw_jitter) or 0
						local limit = unpack(arr.fake_limit)
		
						data = antiaim.create_data(body, body_add, yaw_add_left, yaw_add_right, yaw_j, yaw_jadd, limit)
						elseif revival.preset.selected.name == "fake desync" then
						if type(revival.preset.default["fake desync"]) == "string" then 
							revival.preset.default["fake desync"] = json.parse(base64.decode(revival.preset.default["fake desync"]))
						end

						local preset = revival.preset.default["fake desync"]

						if preset[team]["fakelag"].main and not (ui.get(ref_dt) and ui.get(ref_dt_key)) and not (ui.get(ref_hs) or ui.get(ref_hs_key)) and not ui.get(ref_fd) then
							revival.state = "fakelag"
						elseif preset[team]["height advantage"].main and revival.target ~= nil and revival.target.angles ~= nil and revival.target.angles.pitch > 45 then
							revival.state = "height advantage"
						end

						local arr = preset[team][revival.state]
						if not unpack(arr.main) then
							arr = preset[team]["global"]
						end
		
						local body = "off"
						local body_add = unpack(arr.body_yaw_add)
						local yaw_add_left = unpack(arr.yaw_left)
						local yaw_add_right = unpack(arr.yaw_right)
						if not utility:contains(unpack(arr.yaw_modifiers), "left/right yaw add") then
							yaw_add_left = 0
							yaw_add_right = 0
						end
						local yaw_j = utility:contains(unpack(arr.yaw_modifiers), "yaw jitter") and unpack(arr.yaw_jitter_type) or "off"
						local yaw_jadd = utility:contains(unpack(arr.yaw_modifiers), "yaw jitter") and unpack(arr.yaw_jitter) or 0
						local limit = unpack(arr.fake_limit)
		
						data = antiaim.create_data(body, body_add, yaw_add_left, yaw_add_right, yaw_j, yaw_jadd, limit)

						if not ref_nade_helper_success or (ref_nade_helper_success and not ui.get(ref_nade_helper_key)) then
							antiaim.do_micromovements(cmd)
						end
						elseif revival.preset.selected.name == "five way" then

						local command_dif = -cmd.chokedcommands + cmd.command_number - globals.lastoutgoingcommand() - 1

						local limit = fakelag.get_limit()

						local stages = {33,-33, 16, -16}

						if cmd.chokedcommands < limit and command_dif == 0 then -- chokePacket
							cmd.allow_send_packet = false
							if desync.can_desync(cmd) then
								cmd.yaw = desync.get_base_yaw() + 180 + stages[antiaim.five_way_counter] + math.sign(stages[antiaim.five_way_counter]) * -120
								cmd.pitch = 90
							end
						else -- sendPacket
							cmd.allow_send_packet = true
							antiaim.five_way_counter = (antiaim.five_way_counter == #stages) and 1 or antiaim.five_way_counter + 1
						end

						local yaw_add = stages[antiaim.five_way_counter]
						data = antiaim.create_data("off", 0, yaw_add, yaw_add, "off", 0, 59)

						if not ref_nade_helper_success or (ref_nade_helper_success and not ui.get(ref_nade_helper_key)) then
							antiaim.do_micromovements(cmd)
						end
						elseif revival.preset.selected.name == "adaptive" then

						end
					else
						if gui.aa.main.states[team]["fakelag"].main:get() and not ui.get(ref_dt_key) and not ui.get(ref_hs_key) and not ui.get(ref_fd) then
							revival.state = "fakelag"
						elseif gui.aa.main.states[team]["height advantage"].main:get() and revival.target ~= nil and revival.target.angles ~= nil and revival.target.angles.pitch > 45 then
							revival.state = "height advantage"
						end

						local arr = gui.aa.main.states[team][revival.state]
						if not arr.main:get() then
							arr = gui.aa.main.states[team]["global"]
						end
					
						local body = arr.body_yaw:get()
						local body_add = arr.body_yaw_add:get()
						local yaw_add_left = arr.yaw_left:get()
						local yaw_add_right = arr.yaw_right:get()
						if not utility:contains(arr.yaw_modifiers:get(), "left/right yaw add") then
							yaw_add_left = 0
							yaw_add_right = 0
						end
						local yaw_j = utility:contains(arr.yaw_modifiers:get(), "yaw jitter") and arr.yaw_jitter_type:get() or "off"
						local yaw_jadd = utility:contains(arr.yaw_modifiers:get(), "yaw jitter") and arr.yaw_jitter:get() or 0
						local limit = arr.fake_limit:get()

						data = antiaim.create_data(body, body_add, yaw_add_left, yaw_add_right, yaw_j, yaw_jadd, limit)
					end
				end

				if revival.target.ent ~= nil then
					local brute_data = antiaim.get_bruteforce(data)
					if brute_data then
						data = brute_data
					end
				end

				antiaim.set(data)
			end

			return antiaim
		end)()

		local indicators = (function()
			local this = {
				speed = 8/64,
				side_fraction = 0,
				colors = {},
				side = 0,
				keys = {
					{
						name = "dt",
						active = function()
							return ui.get(ref_dt) and ui.get(ref_dt_key) and not ui.get(ref_fd)
						end,
						last_state = true,
						time = 0,
						fraction = 0,
					},
					{
						name = "hide",
						active = function()
							return ui.get(ref_hs) and ui.get(ref_hs_key) and not ui.get(ref_fd)
						end,
						last_state = true,
						time = 0
					},
					{
						name = "duck",
						active = function()
							return ui.get(ref_fd)
						end,
						last_state = true,
						time = 0
					},
					{
						name = "fs",
						active = function()
							return gui.misc.freestanding:get()
						end,
						last_state = true,
						time = 0
					},
					{
						name = "safe",
						active = function()
							return ui.get(ref_sp_key)
						end,
						last_state = true,
						time = 0
					},
					{
						name = "baim",
						active = function()
							return ui.get(ref_baim_key)
						end,
						last_state = true,
						time = 0
					}
					
				}
			}

			this.render_primary = function(x, y, accent, build)
				local me = entity.get_local_player()
				if this.side_fraction == 0 or this.side_fraction == 1 then
					this.side = utility:get_body_yaw(me)
				end
				if this.side == 0 then
					this.side_fraction = utility:clamp(this.side_fraction - globals.frametime() * 64/16, 0, 1)
				else
					this.side_fraction = utility:clamp(this.side_fraction + globals.frametime() * 64/16, 0, 1)
				end

				local sec_accent = color(0,0,0,200)

				local str = "revival"
				local new_str = ""
				for k = 1, #str do
					local frac = (k)/(#str)
					if this.side == 1 then
						frac = (#str - k + 1)/(#str)
					end
					this.colors[k] = this.colors[k] or sec_accent
					local clr = color.rgba_lerp({sec_accent:unpack()}, {gui.vis.primary_accent:get()}, frac)
					this.colors[k] = color.rgba_lerp({this.colors[k]:unpack()}, {clr:unpack()}, globals.frametime()* 1/this.speed)
					new_str = new_str .. this.colors[k]:to_string() .. string.sub(str, k, k)
				end

				renderer.text(x/2, y/2 + 30, 255, 255, 255, 255, "c", 0, new_str)
				renderer.text(x/2, y/2 + 42, 255, 255, 255, 255 * math.abs(math.cos(globals.curtime() * 2)), "c", 0, string.lower(build))
				local offset = 0
				for i, item in pairs(this.keys) do
					local state = item.active()
					if state ~= item.last_state then
						item.time = globals.curtime() - (1/10 - utility:clamp((globals.curtime() - item.time), 0, 1/10))
					end

					local fraction = utility:clamp((globals.curtime() - item.time)*10, 0, 1)

					if not state then
						fraction = 1 - fraction
					end

					local clr = color(255, 255, 255, 255)

					if item.name == "dt" then
						local defensive_time = record.get_defensive_time(me)
						local weapon_ent = entity.get_player_weapon(me)
						local next_attack = entity.get_prop(me, "m_flNextAttack")
						local next_primary_attack = entity.get_prop(weapon_ent, "m_flNextPrimaryAttack")
						if math.max(next_primary_attack, next_attack) + globals.tickinterval() * 8 > globals.curtime() or (defensive_time and defensive_time > 0) then
							item.fraction = utility:clamp(item.fraction + globals.frametime()*5, 0, 1)
						else
							item.fraction = utility:clamp(item.fraction - globals.frametime()*5, 0, 1)
						end

						clr = color.rgba_lerp({255, 255, 255, 255}, {255, 100, 100, 255}, item.fraction)
					end

					if fraction ~= 0 then
						local r, g, b = clr:unpack()
						offset = offset + 12 * fraction^(1/2)
						renderer.text(x/2, y/2 + 42 + offset, r, g, b, utility:clamp(510 * fraction - 255, 0, 255), "c", 0, item.name)
					end

					item.last_state = state
				end
			end

			this.run = function()
				local style = gui.vis.style:get()
				local x, y = client.screen_size()
				local accent = {gui.vis.primary_accent:get()}
				local build = revival.obex_data.build or "debug"
				if style == "#3" then
					this.render_primary(x, y, accent, build)
				elseif style == "#4" then
					this.render_secondary()
				end
			end

			return this
		end)()

		return antiaim, desync, indicators
	end
}

local vector = modules.vector() -- finished
local images = modules.images()
local base64 = modules.base64()
local utility = modules.utility(vector, base64) -- wip
local trace = modules.trace(vector, utility)
local clipboard = modules.clipboard()
local color = modules.color() -- finished
local m_render = modules.m_render(color)
local notifications = modules.notifications(images, color, m_render, utility)
local menu = modules.menu(color) -- colored ui finished; custom menu todo
local entities = modules.entities() -- todo
local net_channel = modules.net_channel(utility) -- todo
local extrapolation = modules.extrapolation(vector, utility) -- todo
local record = modules.record(vector, utility)
local config = modules.config(utility, base64, clipboard, menu, color, notifications)
local gui = modules.gui(color, utility, menu, config, clipboard, base64)
local fakelag = modules.fakelag(utility, record, vector, extrapolation)
local antiaim, desync, indicators = modules.functions(vector, trace, utility, notifications, record, extrapolation, gui, fakelag, menu, clipboard, base64, color)

if revival.experimental_data ~= nil then
	revival.experimental_data = utility:decode_preset(revival.experimental_data)
end

client.delay_call(0.1, function()
	notifications:new(nil, "loading...", color(gui.vis.notifications_accent:get()))
end)

client.delay_call(0.5, function()
	notifications:new(nil, "welcome back $" .. (revival.obex_data.username or entity.get_player_name(entity.get_local_player())) .. "$ have a nice stay!", color(gui.vis.notifications_accent:get()))
end)

for _, cid in ipairs({
	{
		"paint", 0, function()
			local me = entity.get_local_player()
			if me == nil or not entity.is_alive(me) then
				return
			end

			local username = revival.obex_data.username or entity.get_player_name(me)
			local build = revival.obex_data.build or "debug"

			local prim = color(gui.vis.primary_accent:get())
			local sec = color(gui.vis.secondary_accent:get())
			local third = color(gui.vis.third_accent:get())
			local keys = color(gui.vis.keybind_accent:get())
			local glow = color(gui.vis.glow_accent:get())

			local x, y = client.screen_size()

			local positioning = gui.vis.positioning:get()
			local scoped = entity.get_prop(me, "m_bIsScoped") == 1
			if positioning == "centered" then
				scoped = false
			elseif positioning == "right aligned" then
				scoped = true
			end
			if scoped then
				revival.scope_frac = utility:clamp(revival.scope_frac - globals.frametime()*5, 0, 1)
			else
				revival.scope_frac = utility:clamp(revival.scope_frac + globals.frametime()*5, 0, 1)
			end
			local fr = revival.scope_frac ^ 3

			local additives = gui.vis.extras:get()

			if gui.vis.style:get() == "#1" then
				local str = "R E V I V A L"
				local time = 1/string.len(str)
				local f = ""
				for k = 1, #str do
					local clr = color.rgba_lerp({gui.vis.primary_accent:get()}, {gui.vis.secondary_accent:get()}, math.abs(math.sin(globals.realtime()*4 + time*k)))
					f = f .. clr:to_string() .. string.sub(str, k, k)
				end
				local size = vector(renderer.measure_text("-", f))
				renderer.text(x/2 - ((size.x/2 + 4) * fr) + 4, y/2 + 20, 255, 255, 255, 255, "-", 0, f)
				local state_to_letter = {
					["run"] = "R",
					["slow move"] = "M",
					["stand"] = "S",
					["jump"] = "J",
					["duck jump"] = "J+",
					["duck"] = "D",
					["height advantage"] = "H",
					["fakelag"] = "FL"
				}
				local clr = color(255,255,255,255 * math.abs(math.sin(globals.curtime())))
				local size2 = vector(renderer.measure_text("-", "STATE:" .. clr:to_string() .. " " .. tostring(state_to_letter[revival.state or "~"])))
				renderer.text(x/2 - ((size2.x/2 + 4) * fr) + 4, y/2 + 30, 255, 255, 255, 255, "-", 0, "STATE:" .. clr:to_string() .. " " .. tostring(state_to_letter[revival.state]))
				local r, g, b, a = prim:unpack()
				local r2, g2, b2, a2 = sec:unpack()
				local dt = ui.get(ref_dt) and ui.get(ref_dt_key)
				local size3 = vector(renderer.measure_text("-", "DT"))
				if dt then
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 40, r, g, b, a, "-", 0, keys:to_string() .. "DT")
				else
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 40, 255, 255, 255, 155, "-", 0, "DT")
				end
				local os = ui.get(ref_hs) and ui.get(ref_hs_key) and not dt
				local size4 = vector(renderer.measure_text("-", "OS"))
				if os then
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 50, r, g, b, a, "-", 0, keys:to_string() .. "OS")
				else
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 50, 255, 255, 255, 155, "-", 0, "OS")
				end
				local fs = utility:contains(ui.get(ref_freestand), "Default") and ui.get(ref_freestand_key)
				local size5 = vector(renderer.measure_text("-", "FS"))
				if fs then
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 60, r, g, b, a, "-", 0, keys:to_string() .. "FS")
				else
					renderer.text(x/2 - ((size3.x/2 + 4) * fr) + 4, y/2 + 60, 255, 255, 255, 155, "-", 0, "FS")
				end
			elseif gui.vis.style:get() == "#2" then
				local r, g, b, a = prim:unpack()
				local r2, g2, b2, a2 = sec:unpack()

				local options = gui.vis.options:get()

				local offset = 10
				local offset2 = 4

				if utility:contains(options, "build") then
					local s1, w1 = renderer.measure_text("-", string.upper(build))
					renderer.text(x/2 - (s1/2 + 4)*fr + 3, y/2 + 20, r, g, b, 255 * math.max(math.cos(globals.curtime()), 0), "-", 0, string.upper(build))
					offset2 = offset2 - 11
				end

				local delta = math.floor(math.abs(utility:get_delta(me)))

				if utility:contains(options, "delta") and delta > 1 then
					renderer.rectangle(x/2 - (delta/2 + 4)*fr + 4, y/2 + 20 + offset2 + 1, delta + 2, 4, 20, 20, 20, 200)
					renderer.rectangle(x/2 - (delta/2 + 4)*fr + 5, y/2 + 20 + offset2 + 2, delta, 2, r2, g2, b2, 255)
				end

				if utility:contains(options, "name") then
					local str = "revivalyaw"
					local time = 1/string.len(str)
					local f = ""
					for k = 1, #str do
						local clr = color.rgba_lerp({gui.vis.primary_accent:get()}, {gui.vis.secondary_accent:get()}, math.abs(math.cos(globals.realtime()*4 + time*k)))
						f = f .. clr:to_string() .. string.sub(str, k, k)
					end
					local s2, w2 = renderer.measure_text("b", f)
					local x_txt, y_txt = x/2 - (s2/2 + 3) * fr + 4, y/2 + 20 + offset
					if ({glow:unpack()})[4] > 10 then
						local r, g, b, a = glow:unpack()
						renderer.rectangle(x_txt +1, y_txt + 5, s2 - 1, w2 - 7, r, g, b, a * math.abs(math.cos(globals.realtime() * 2)))
						m_render.glow_module(x_txt +1, y_txt + 5, s2 - 2, w2 - 7, color(r, g, b, a * math.abs(math.cos(globals.realtime() * 2))), 12, 0)
					end
					renderer.text(x_txt, y_txt, 255, 255, 255, 255, "b", 0, f)
					offset = offset + w2
				end

				if utility:contains(options, "state") then
					local defensive_time = record.get_defensive_time(me)
					if defensive_time ~= nil and defensive_time > 0 then
						revival.state = "defensive"
						r2, g2, b2 = 255, 100, 100
					end

					if revival.state ~= revival.last_state then
						revival.render_state = revival.last_state
						if revival.state_time - 0.5 > 0 or true then
							revival.state_time = 0
						end
					end

					revival.state_time = utility:clamp(revival.state_time + globals.frametime() * 5, 0, 1)

					local state = revival.state

					if revival.render_state ~= nil and revival.state_time - 0.5 < 0 then
						state = revival.render_state
					end

					local state_alpha = math.abs(revival.state_time - 0.5) * 2

					local state_to_letter = {
						["run"] = "running",
						["slow move"] = "slow-motion",
						["stand"] = "T-90",
						["jump"] = "aerobic",
						["duck jump"] = "aerobic+c",
						["duck"] = "crouch",
						["height advantage"] = "height advantage",
						["fakelag"] = "fakelag",
						["defensive"] = "defensive+/-"
					}
					local s3, w3 = renderer.measure_text("-", "<" .. string.upper(state_to_letter[state]) .. ">")
					local r3, g3, b3, a3 = third:unpack()
					renderer.text(x/2 - ((s3/2 + 4) * fr) + 3, y/2 + 20 + offset, r3, g3, b3, a3 * state_alpha, "-", 0, "<" .. string.upper(state_to_letter[state]) .. ">")
					offset = offset + w3
				end

				if utility:contains(options, "binds") then
					local speed = 0.1
					for i, bind in ipairs(revival.binds) do
						i = i - 1
						if bind.cond() then
							bind.fraction = utility:clamp(bind.fraction + 1/speed * globals.frametime(), 0, 1)
						else
							bind.fraction = utility:clamp(bind.fraction - 1/speed * globals.frametime(), 0, 1)
						end

						if bind.fraction > 0 then
							local s4, w4 = renderer.measure_text("-", bind.name)
							local r, g, b, a = keys:unpack()
							renderer.text(x/2 - ((s4/2 + 4) * fr) + 3, y/2 + 20 + offset * bind.fraction, r, g, b, a * bind.fraction, "-", 0, bind.name)
							offset = offset + w4 * bind.fraction
						end
					end
					
				end

			elseif gui.vis.style:get() == "#3" then
				local side = utility:get_body_yaw()
				local str = "revival"
				indicators.run()
			end

			if utility:contains(additives, "peek arrows") then
				local r, g, b, a = gui.vis.peek_accent:get()
				local clr_reset = color(0,0,0,0):to_string()
				if revival.freestand_side == 0 then -- left
					renderer.text(x/2 - 52, y/2 - 3, r, g, b, a, "c+", 0, "«")
					renderer.text(x/2 + 52, y/2 - 3, r, g, b, a, "c+", 0, clr_reset .. "»")
				elseif revival.freestand_side == 1 then -- right
					renderer.text(x/2 - 52, y/2 - 3, r, g, b, a, "c+", 0, clr_reset .. "«")
					renderer.text(x/2 + 52, y/2 - 3, r, g, b, a, "c+", 0, "»")
				elseif revival.freestand_side == 2 then
					renderer.text(x/2 - 52, y/2 - 3, r, g, b, a, "c+", 0, "«")
					renderer.text(x/2 + 52, y/2 - 3, r, g, b, a, "c+", 0, "»")
				end
			end

			if utility:contains(additives, "manual arrows") then
				local r, g, b, a = gui.vis.manual_accent:get()
				local clr_reset = color(0,0,0,0):to_string()
				if antiaim.state == 1 then -- left
					renderer.text(x/2 - 50, y/2 - 3, r, g, b, a, "c+", 0, "‹")
					renderer.text(x/2 + 50, y/2 - 3, r, g, b, a, "c+", 0, clr_reset .. "›")
				elseif antiaim.state == 2 then -- right
					renderer.text(x/2 - 50, y/2 - 3, r, g, b, a, "c+", 0, clr_reset .. "‹")
					renderer.text(x/2 + 50, y/2 - 3, r, g, b, a, "c+", 0, "›")
				elseif antiaim.state == 3 then -- forward
					renderer.text(x/2 - 50, y/2 - 3, r, g, b, a, "c+", 0, "‹")
					renderer.text(x/2 + 50, y/2 - 3, r, g, b, a, "c+", 0, "›")
				end
			end

			if utility:contains(additives, "side panel") then
				local str = "revival anti-aim system"
				local speed = 4
				local time = speed/string.len(str)
				local f = ""
				for k = 1, #str do
					local clr = color.rgba_lerp({gui.vis.primary_accent:get()}, {gui.vis.secondary_accent:get()}, math.max(math.cos(globals.realtime()*2 - time*k), 0))
					f = f .. clr:to_string() .. string.sub(str, k, k)
				end
				renderer.text(10, y/2, 255, 255, 255, 255, "", 0, f)
				local str = "[" .. build .. "]"
				local add_k = #("user: " .. username)
				local f = ""
				for k = 1, #str do
					local clr = color.rgba_lerp({gui.vis.primary_accent:get()}, {gui.vis.secondary_accent:get()}, math.max(math.cos(globals.realtime()*2 - time*(k+add_k)), 0))
					f = f .. clr:to_string() .. string.sub(str, k, k)
				end
				renderer.text(10, y/2 + 10, 255, 255, 255, 255, "", 0, sec:to_string() .. "user: " .. username .. f)
			end
		end
	},
	{
		"paint_ui", 0, function()
			revival.menu_visibility(false)

			local additives = gui.vis.extras:get()
			if utility:contains(additives, "notifications") then
				notifications:run()
			end

			local r, g, b, a = ui.get(ref_menu_color)
			local str = "-----------"
			local time = 2/string.len(str)
			local f = ""
			for k = 1, #str/2 do
				local clr
				if k > #str/4 then
					clr = color.rgba_lerp({r, g, b, a}, {r, g, b, 0}, math.max(math.sin(globals.realtime()*3 - time*k), 0))
				else
					clr = color.rgba_lerp({r, g, b, a}, {r, g, b, 0}, math.max(math.sin(globals.realtime()*3 - time*(#str/2 - k)), 0))
				end
				f = f .. clr:to_string() .. string.sub(str, k, k + 1)
			end

			ui.set(gui.space, "                  " .. f)
			--ui.set(gui.aa.space, "                  " .. f)
			ui.update(gui.aa.main.presets.item, config.get_preset_list(true))
		end
	},
	{
		"setup_command", 0, function(cmd)

			revival.choke = globals.chokedcommands()

			if globals.chokedcommands() == 0 then
				if revival.switch then
					revival.switch = false
				else
					revival.switch = true
				end
			end

			local me = entity.get_local_player()

			revival.last_state = revival.state
			revival.state = antiaim.get_state(me)
			revival.target = antiaim.get_target()
			antiaim.run(cmd, gui.aa.main.flick_exploit:get() and gui.aa.main.exploit_toggle:get())

			if utility:contains(gui.rage.rage_improvements:get(), "defensive logic") then
				fakelag.run_defensive(cmd, gui.rage.defensive_triggers:get())
			end

			ui.set(ref_freestand_key, "Always on")
			if gui.misc.freestanding:get() and not utility:contains(gui.misc.freestanding_disablers:get(), revival.state) then
				ui.set(ref_freestand, {"Default"})
			else
				ui.set(ref_freestand, {})
			end

			ui.set(ref_edgeyaw, gui.misc.edge_yaw:get())
		end
	},
	{
		"run_command", 0, function(cmd)
		end
	},
	{
		"predict_command", 0, function(cmd)
			local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
			antiaim.defensive = math.abs(tickbase - antiaim.checker)
			antiaim.checker = math.max(tickbase, antiaim.checker or 0)
		end
	},
	{
		"net_update_start", 0, function(cmd)
			record.save()

			record.update_body_yaw(gui.misc.resolver:get())
		end
	},
	{
		"pre_render", 0, function()
			local me = entity.get_local_player()
			if me == nil or not entity.is_alive(me) then
				return
			end

			local anim_breaker = {
				["break legs"] = function()
					local modes = {
						["inverted"] = function()
							local move_yaw = entity.get_prop(me, "m_flPoseParameter", 7)
							move_yaw = move_yaw + 0.5
							if move_yaw > 1 then
								move_yaw = move_yaw - 1
							end
							return move_yaw
						end,
						["backwards"] = function()
							return 1
						end,
						["broken"] = function()
							return math.random()
						end
					}
					local yaw = modes[gui.misc.break_legs_mode:get()]()
					entity.set_prop(me, "m_flPoseParameter", yaw, 0)
					if globals.chokedcommands() == 0 then
						ui.set(ref_legs, ui.get(ref_legs) == "Always slide" and "always slide" or "always slide")
					end
				end,
				["freeze legs"] = function()
					entity.set_prop(me, "m_flPoseParameter", 1, 6)
				end,
				["break duck"] = function()
					entity.set_prop(me, "m_flPoseParameter", revival.switch and 1 or 0, 8)
				end,
				["disable lean"] = function()
					entity.set_prop(me, "m_flPoseParameter", 0, 2)
				end,
				["zero pitch on land"] = function()
					local on_ground = not utility:in_air(me)

					if on_ground then
						revival.pre_render.ground_ticks = revival.pre_render.ground_ticks + 1
					else
						revival.pre_render.ground_ticks = 0
						revival.pre_render.end_time = globals.curtime() + 1
					end 

					if revival.pre_render.ground_ticks > ui.get(ref_fl_limit)+1 and revival.pre_render.end_time > globals.curtime() then
						entity.set_prop(me, "m_flPoseParameter", 0.5, 12)
					end
				end
			}

			for _, v in ipairs(gui.misc.anim_breakers:get()) do
				anim_breaker[v]()
			end
		end
	},
	{
		"bullet_impact", 0, function(e)
			local me = entity.get_local_player()
			local ent = client.userid_to_entindex(e.userid)
			if me == nil or not entity.is_alive(me) or not entity.is_enemy(ent) or me == ent then
				return
			end
			
			revival.shots.impacts[ent] = {
				origin = vector(e.x, e.y, e.z),
				tick = globals.tickcount()
			}
		end
	},
	{
		"player_hurt", 0, function(e)
			if entity.get_local_player() ~= client.userid_to_entindex(e.userid) then
				return
			end

			local ent = client.userid_to_entindex(e.attacker)
			if not revival.shots.impacts[ent] then
				return
			end

			revival.shots.hits[ent] = {
				tick = revival.shots.impacts[ent].tick,
				origin = revival.shots.impacts[ent].origin,
				shots = (revival.shots.hits[ent] == nil) and 1 or revival.shots.hits[ent].shots + 1
			}

			if utility:contains(gui.aa.extra.triggers:get(), "hit") then
				revival.shots.bruteforce[ent] = {
					tick = revival.shots.impacts[ent].tick,
					origin = revival.shots.impacts[ent].origin,
					shots = (revival.shots.bruteforce[ent] == nil) and 1 or revival.shots.bruteforce[ent].shots + 1
				}
			end

			--notifications:new(nil, "[" .. revival.shots.hits[ent].shots .. "] registered $hit$ shot from $" .. string.lower(entity.get_player_name(ent)) .. "$", color(gui.vis.notifications_accent:get()))

			revival.shots.impacts[ent] = nil
		end
	},
	{
		"net_update_end", 0, function(e)
			local me = entity.get_local_player()
			for ent, impact in pairs(revival.shots.impacts) do
				local head_pos = vector(entity.get_prop(me, "m_vecOrigin")) + vector(0, 0, entity.get_prop(me, "m_vecViewOffset[2]"))
				local eye = vector(entity.get_prop(ent, "m_vecOrigin")) + vector(0, 0, entity.get_prop(ent, "m_vecViewOffset[2]"))
				local point = utility:closest_point_on_ray(head_pos, eye, impact.origin)

				if point:dist(head_pos) <= 64 then
					revival.shots.misses[ent] = {
						tick = impact.tick,
						origin = impact.origin,
						shots = (revival.shots.misses[ent] == nil) and 1 or revival.shots.misses[ent].shots + 1
					}

					if utility:contains(gui.aa.extra.triggers:get(), "miss") then
						revival.shots.bruteforce[ent] = {
							tick = impact.tick,
							origin = impact.origin,
							shots = (revival.shots.bruteforce[ent] == nil) and 1 or revival.shots.bruteforce[ent].shots + 1
						}
					end

					--notifications:new(nil, "[" .. revival.shots.misses[ent].shots .. "] registered $missed$ shot from $" .. string.lower(entity.get_player_name(ent)) .. "$", color(gui.vis.notifications_accent:get()))
				end
			end

			revival.shots.impacts = {}
		end
	},
	{
		"aim_fire", 0, function(e)
			fakelag.last_shot = 2
		end
	},
	{
		"shutdown", 0, function()
			cvar.cl_sidespeed:set_int(455)
			cvar.cl_forwardspeed:set_int(455)
			cvar.cl_backspeed:set_int(455)
			database.write("revival_default_preset", json.stringify({
				name = revival.preset.selected.name,
				editing = false,
				data = revival.preset.selected.data
			}))
			revival.menu_visibility(true)
		end
	},
	{
		"round_start", 0, function()
			revival.m_records = {}
			revival.shots = {
				impacts = {},
				hits = {},
				misses = {},
				bruteforce = {}
			}
			notifications:new(nil, "reset $evade$ data due to round start", color(gui.vis.notifications_accent:get()))
		end
	}
}) do
	if cid[1] == 'ui_callback' then
        cid[3]()
    else
        client.delay_call(cid[2], function()
            client.set_event_callback(cid[1], cid[3])
        end)
    end
end

gui.callback()

gui.aa.main.presets:set_callback(function()
	gui.callback()
end)
ui.set_callback(gui.aa.main.select, function()
	local index = ui.get(gui.aa.main.presets.item) == -1 and 0 or ui.get(gui.aa.main.presets.item)
	revival.preset.selected.data, revival.preset.selected.name = config.get_selected_preset_data(index)
	if type(revival.preset.selected.data) ~= "boolean" then
		antiaim._set = false
		config.import(gui.aa.main.states, revival.preset.selected.data)
	end
	gui.callback()
end)
ui.set_callback(gui.aa.main.create, function()
	config.on_create(gui, ui.get(gui.aa.main.name))
	gui.callback()
end)
ui.set_callback(gui.aa.main.save, function()
	config.on_save(gui)
	gui.callback()
end)
ui.set_callback(gui.aa.main.import, function()
	config.on_import(gui)
	gui.callback()
end)
ui.set_callback(gui.aa.main.export, function()
	config.on_export(gui)
	gui.callback()
end)
ui.set_callback(gui.aa.main.edit, function()
	config.on_edit(gui)
	gui.callback()
end)
ui.set_callback(gui.aa.main.delete, function()
	revival.preset.delete = true
	gui.callback()
end)
ui.set_callback(gui.aa.main.delete_cancel, function()
	revival.preset.delete = false
	gui.callback()
end)
ui.set_callback(gui.aa.main.delete_confirm, function()
	revival.preset.delete = false
	config.on_delete(gui)
	gui.callback()
end)
ui.set_callback(gui.aa.main.export_state, function()
	local state = gui.aa.main.selected_state:get()
	local team = gui.aa.main.selected_team:get()
	local data = config.export_preset(gui.aa.main.states[team][state])
	clipboard.set(json.stringify(data))
	gui.callback()
end)
ui.set_callback(gui.aa.main.import_state, function()
	local state = gui.aa.main.selected_state:get()
	local team = gui.aa.main.selected_team:get()
	config.import_preset(gui.aa.main.states[team][state], json.parse(clipboard.get()))
	gui.callback()
end)

ui.set_visible(ref_maxprocessticks, true)