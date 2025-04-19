local L_1_ = "bozo"
local L_2_ = "Nightly"
local function L_3_func(L_149_arg0, L_150_arg1)
	local L_151_, L_152_ = pcall(require, L_149_arg0)
	if L_151_ then
		return L_152_
	else
		return error(L_150_arg1)
	end
end;
local L_4_ = L_3_func("gamesense/images", "Download images library: https://gamesense.pub/forums/viewtopic.php?id=22917")
local L_5_ = L_3_func("bit")
local L_6_ = L_3_func("gamesense/base64", "Download base64 encode/decode library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local L_7_ = L_3_func("gamesense/antiaim_funcs", "Download anti-aim functions library: https://gamesense.pub/forums/viewtopic.php?id=29665")
local L_8_ = L_3_func("ffi", "Failed to require FFI, please make sure Allow unsafe scripts is enabled!")
local L_9_ = L_3_func("vector", "Missing vector")
local L_10_ = L_3_func("gamesense/http", "Download HTTP library: https://gamesense.pub/forums/viewtopic.php?id=21619")
local L_11_ = L_3_func("gamesense/clipboard", "Download Clipboard library: https://gamesense.pub/forums/viewtopic.php?id=28678")
local L_12_ = L_3_func("gamesense/entity", "Download Entity Object library: https://gamesense.pub/forums/viewtopic.php?id=27529")
local L_13_ = L_3_func("gamesense/csgo_weapons", "Download CS:GO weapon data library: https://gamesense.pub/forums/viewtopic.php?id=18807")
local L_14_ = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local L_15_ = L_3_func("gamesense/steamworks") or error("Missing https://gamesense.pub/forums/viewtopic.php?id=26526")
local L_16_ = L_3_func("gamesense/trace", "https://gamesense.pub/forums/viewtopic.php?id=32949")
local L_17_ = require"gamesense/surface"
local L_18_ = L_17_.draw_line;
local L_19_ = "BOUNTY"
local L_20_ = true;
local L_21_ = 0;
function sway()
	if L_20_ == true then
		L_21_ = L_21_ + 1;
		if L_21_ > 255 then
			L_20_ = false
		end
	else
		L_21_ = L_21_ - 1;
		if L_21_ == 0 then
			L_20_ = true
		end
	end;
	return L_21_
end;
function lerp(L_153_arg0, L_154_arg1, L_155_arg2)
	if not L_154_arg1 or not L_153_arg0 or not L_155_arg2 then
		return
	end;
	return L_153_arg0 + (L_154_arg1 - L_153_arg0) * L_155_arg2
end;
function text_clamp(L_156_arg0, L_157_arg1, L_158_arg2)
	if L_156_arg0 < L_157_arg1 then
		return L_157_arg1
	elseif L_156_arg0 > L_158_arg2 then
		return L_158_arg2
	else
		return L_156_arg0
	end
end;
function ui.multiReference(L_159_arg0, L_160_arg1, L_161_arg2)
	local L_162_, L_163_, L_164_ = ui.reference(L_159_arg0, L_160_arg1, L_161_arg2)
	return {
		L_162_,
		L_163_,
		L_164_
	}
end;
rgba_to_hex = function(L_165_arg0, L_166_arg1, L_167_arg2, L_168_arg3)
	return L_5_.tohex(math.floor(L_165_arg0 + 0.5) * 16777216 + math.floor(L_166_arg1 + 0.5) * 65536 + math.floor(L_167_arg2 + 0.5) * 256 + math.floor(L_168_arg3 + 0.5))
end;
animate_text = function(L_169_arg0, L_170_arg1, L_171_arg2, L_172_arg3, L_173_arg4, L_174_arg5, L_175_arg6, L_176_arg7, L_177_arg8, L_178_arg9)
	local L_179_, L_180_, L_181_, L_182_ = L_175_arg6, L_176_arg7, L_177_arg8, L_178_arg9;
	local L_183_ = {}
	local L_184_ = L_170_arg1:len() - 1;
	local L_185_ = L_179_ - L_171_arg2;
	local L_186_ = L_180_ - L_172_arg3;
	local L_187_ = L_181_ - L_173_arg4;
	local L_188_ = L_182_ - L_174_arg5;
	for L_189_forvar0 = 1, # L_170_arg1 do
		local L_190_ = (L_189_forvar0 - 1) / (# L_170_arg1 - 1) + L_169_arg0;
		L_183_[# L_183_ + 1] = "\a" .. rgba_to_hex(L_171_arg2 + L_185_ * math.abs(math.cos(L_190_)), L_172_arg3 + L_186_ * math.abs(math.cos(L_190_)), L_173_arg4 + L_187_ * math.abs(math.cos(L_190_)), L_174_arg5 + L_188_ * math.abs(math.cos(L_190_)))
		L_183_[# L_183_ + 1] = L_170_arg1:sub(L_189_forvar0, L_189_forvar0)
	end;
	return table.concat(L_183_)
end;
function animate_color(L_191_arg0, L_192_arg1, L_193_arg2, L_194_arg3, L_195_arg4, L_196_arg5, L_197_arg6, L_198_arg7, L_199_arg8)
	local L_200_ = false;
	local L_201_, L_202_, L_203_, L_204_ = L_192_arg1, L_193_arg2, L_194_arg3, L_195_arg4;
	if L_201_ == L_196_arg5 and L_202_ == L_197_arg6 and L_203_ == L_198_arg7 and L_204_ == L_199_arg8 then
		L_201_ = lerp(L_192_arg1, L_196_arg5, L_191_arg0)
		L_202_ = lerp(L_193_arg2, L_197_arg6, L_191_arg0)
		L_203_ = lerp(L_194_arg3, L_198_arg7, L_191_arg0)
		L_204_ = lerp(L_195_arg4, L_199_arg8, L_191_arg0)
	else
		L_201_ = lerp(L_196_arg5, L_192_arg1, L_191_arg0)
		L_202_ = lerp(L_197_arg6, L_193_arg2, L_191_arg0)
		L_203_ = lerp(L_198_arg7, L_194_arg3, L_191_arg0)
		L_204_ = lerp(L_199_arg8, L_195_arg4, L_191_arg0)
	end;
	return L_201_, L_202_, L_203_, L_204_
end;
local L_22_ = client.unix_time()
local function L_23_func()
	local L_205_ = client.unix_time() - L_22_;
	local L_206_ = math.floor(L_205_ / 3600)
	local L_207_ = math.floor((L_205_ - L_206_ * 3600) / 60)
	local L_208_ = math.floor(L_205_ - L_206_ * 3600 - L_207_ * 60)
	return string.format("%02d:%02d:%02d", L_206_, L_207_, L_208_)
end;
local function L_24_func(L_209_arg0)
	return globals.curtime() >= entity.get_prop(L_209_arg0, "m_flNextAttack")
end;
local function L_25_func(L_210_arg0)
	return globals.curtime() >= entity.get_prop(L_210_arg0, "m_flNextPrimaryAttack")
end;
function create_data(L_211_arg0, L_212_arg1)
	return {
		flags = L_211_arg0 or 0,
		velocity = L_212_arg1 or L_9_()
	}
end;
local function L_26_func(L_213_arg0, L_214_arg1)
	local L_215_ = math.sin(math.rad(L_214_arg1))
	local L_216_ = math.cos(math.rad(L_214_arg1))
	local L_217_ = math.sin(math.rad(L_213_arg0))
	local L_218_ = math.cos(math.rad(L_213_arg0))
	return L_218_ * L_216_, L_218_ * L_215_, - L_217_
end;
local L_27_ = create_data()
local L_28_ = create_data()
local function L_29_func(L_219_arg0, L_220_arg1)
	local L_221_ = entity.get_local_player()
	if L_221_ == nil then
		return
	end;
	local L_222_ = L_27_.velocity;
	local L_223_ = L_222_:length2d()
	local L_224_ = L_9_(L_222_:angles())
	local L_225_ = L_9_(client.camera_angles())
	L_224_.y = L_225_.y - L_224_.y;
	local L_226_ = L_9_(L_26_func(L_224_.x, L_224_.y))
	local L_227_ = - cvar.cl_sidespeed:get_float()
	local L_228_ = L_227_ * L_226_;
	L_219_arg0.in_speed = 1;
	L_219_arg0.forwardmove = L_228_.x;
	L_219_arg0.sidemove = L_228_.y
end;
local function L_30_func(L_229_arg0, L_230_arg1)
	L_230_arg1 = L_230_arg1 or ""
	local L_231_ = {
		{
			L_229_arg0,
			L_230_arg1
		}
	}
	while # L_231_ > 0 do
		local L_232_ = table.remove(L_231_)
		local L_233_ = L_232_[1]
		local L_234_ = L_232_[2]
		for L_235_forvar0, L_236_forvar1 in pairs(L_233_) do
			local L_237_ = L_234_ .. L_235_forvar0;
			if type(L_236_forvar1) == "table" then
				table.insert(L_231_, {
					L_236_forvar1,
					L_237_ .. "."
				})
			else
				ui.set_visible(L_236_forvar1, false)
			end
		end
	end
end;
local function L_31_func(L_238_arg0, L_239_arg1)
	L_239_arg1 = L_239_arg1 or ""
	local L_240_ = {
		{
			L_238_arg0,
			L_239_arg1
		}
	}
	while # L_240_ > 0 do
		local L_241_ = table.remove(L_240_)
		local L_242_ = L_241_[1]
		local L_243_ = L_241_[2]
		for L_244_forvar0, L_245_forvar1 in pairs(L_242_) do
			local L_246_ = L_243_ .. L_244_forvar0;
			if type(L_245_forvar1) == "table" then
				table.insert(L_240_, {
					L_245_forvar1,
					L_246_ .. "."
				})
			else
				ui.set_visible(L_245_forvar1, true)
			end
		end
	end
end;
local L_32_ = 0;
local L_33_ = 0;
local L_34_ = true;
local L_35_ = true;
local L_36_ = false;
client.set_event_callback("paint_ui", function()
	local L_247_ = L_9_(client.screen_size())
	local L_248_ = L_9_(L_247_.x, L_247_.y)
	if L_34_ == true then
		local L_249_, L_250_ = {
			184,
			184,
			184,
			L_33_
		}, {
			62,
			62,
			62,
			100
		}
		local L_251_ = "welcome back!"
		local L_252_ = lerp(0, 360, globals.realtime() % 1)
		if L_35_ == true then
			L_33_ = lerp(L_33_, 255, globals.frametime() * 24)
		end;
		renderer.blur(0, 0, L_248_.x, L_248_.y)
		renderer.text(L_247_.x / 2, L_247_.y / 2 + 50, 255, 255, 255, L_33_, "c", 0, L_251_)
		if L_33_ > 210 then
			if L_35_ == true then
				L_32_ = lerp(L_32_, 150, globals.frametime() * 24)
			end
		end;
		if L_32_ > 149 then
			L_35_ = false;
			L_33_ = lerp(L_33_, 0, globals.frametime() * 24)
			if L_33_ < 1 then
				L_34_ = false
			end
		end;
		if L_36_ == true then
			renderer.text(L_247_.x / 2, L_247_.y - L_32_ / 2 + 65, 184, 184, 184, L_33_, "c", 0, "")
		end
	end
end)
local L_37_ = {
	antiaim = {
		anti_aim = ui.multiReference("AA", "Anti-aimbot angles", "Enabled"),
		pitch = ui.multiReference("AA", "Anti-aimbot angles", "Pitch"),
		yaw = {
			ui.reference("AA", "Anti-aimbot angles", "Yaw")
		},
		yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
		jitter = {
			ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
		},
		body_yaw = {
			ui.reference("AA", "Anti-aimbot angles", "Body yaw")
		},
		fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
		rollslider = ui.reference("AA", "Anti-aimbot angles", "Roll"),
		slow_motion = {
			ui.reference("AA", "Other", "Slow motion")
		},
		freestand,
		freestandkey = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
		fd = ui.reference("RAGE", "Other", "Duck peek assist"),
		edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
		fakelaglimit = ui.multiReference("AA", "Fake lag", "Limit"),
		fakelagvariance = ui.multiReference("AA", "Fake lag", "Variance"),
		fakelagamount = ui.multiReference("AA", "Fake lag", "Amount"),
		fakelagenabled = ui.multiReference("AA", "Fake lag", "Enabled"),
		legmovement = ui.multiReference("AA", "Other", "Leg movement"),
		fakepeek = ui.multiReference("AA", "Other", "Fake peek"),
		onshotaa = ui.multiReference("AA", "Other", "On shot anti-aim")
	}
}
uistate = 7;
UI_Label_Empty = ui.new_label("AA", "Anti-aimbot angles", " ")
UI_Label_Empty2 = ui.new_label("AA", "Anti-aimbot angles", " ")
UI_Button_Back = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFBack", function()
	ui.set_visible(UI_Button_Back, false)
	ui.set_visible(UI_Button_Visuals, true)
	ui.set_visible(UI_Button_AA, true)
	ui.set_visible(UI_Button_Configs, true)
	ui.set_visible(UI_Button_Keybinds, true)
	ui.set_visible(UI_Button_Ragebot, true)
	uistate = 7
end)
ui.set_visible(UI_Button_Back, false)
UI_Button_Ragebot = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFRage", function()
	ui.set_visible(UI_Button_Back, true)
	ui.set_visible(UI_Button_Visuals, false)
	ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 2
end)
UI_Button_AA = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFAnti-aim", function()
	ui.set_visible(UI_Button_Back, true)
	ui.set_visible(UI_Button_Visuals, false)
	ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 1
end)
UI_Button_Keybinds = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFBinds", function()
	ui.set_visible(UI_Button_Back, true)
	ui.set_visible(UI_Button_Visuals, false)
	ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 6
end)
UI_Button_Visuals = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFVisuals", function()
	ui.set_visible(UI_Button_Back, true)
	ui.set_visible(UI_Button_Visuals, false)
	ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 3
end)
UI_Button_Configs = ui.new_button("AA", "Anti-aimbot angles", "\a96D6DBFFConfig", function()
	ui.set_visible(UI_Button_Back, true)
	ui.set_visible(UI_Button_Visuals, false)
	ui.set_visible(UI_Button_AA, false)
	ui.set_visible(UI_Button_Configs, false)
	ui.set_visible(UI_Button_Keybinds, false)
	ui.set_visible(UI_Button_Ragebot, false)
	uistate = 5
end)
labelhead = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFizanasense")
label345 = ui.new_label("AA", "Fake lag", "\a292929FF━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
label34e5 = ui.new_label("AA", "Fake lag", "\nspace121")
lableoth = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFUser: \a8AECF1FFtester")
lableoth = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFLast update: \a8AECF1FF06.09.2024")
Timezone = ui.new_label("AA", "Fake lag", "\a8AECF1FF•  \aFFFFFFFFTime session: \a8AECF1FFtime")
label35435 = ui.new_label("AA", "Fake lag", "\nspace12432")
label346 = ui.new_label("AA", "Fake lag", "\a292929FF━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
client.set_event_callback("paint_ui", function()
	if ui.is_menu_open() then
		ui.set(Timezone, "\a8AECF1FF•  \aFFFFFFFFTime session: \a8AECF1FF" .. L_23_func())
	end
end)
local L_38_ = ui.new_combobox("AA", "Anti-aimbot angles", "Preset", {
	"Ai-based",
	"Meta",
	"Custom"
})
local L_39_ = ui.new_combobox("AA", "Anti-aimbot angles", "State", {
	"Crouching",
	"Crouchrunning",
	"Standing",
	"Slowmotion",
	"Running",
	"Jumping",
	"Aircrouching",
	"Fakelag"
})
local L_40_ = {
	Crouching = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[c] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[c] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[c] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[c] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[c] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[c] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[c] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[c] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[c] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[c] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[c] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[c] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[c] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[cd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[cd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[cd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[cd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[cd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[cd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[cd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Crouchrunning = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[cr] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[cr] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[cr] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[cr] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[cr] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[cr] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[cr] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[crd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[crd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[crd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[crd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[crd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[crd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[crd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Standing = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[s] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[s] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[s] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[s] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[s] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[s] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[s] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[s] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[s] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[s] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[s] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[s] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[s] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[sd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[sd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[sd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[sd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[sd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[sd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[sd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Slowmotion = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[sm] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[sm] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[sm] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[sm] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[sm] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[sm] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[sm] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[smd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[smd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[smd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[smd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[smd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[smd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[smd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Running = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[m] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[m] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[m] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[m] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[m] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[m] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[m] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[m] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[m] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[m] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[m] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[m] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[m] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[md] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[md] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[md] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[md] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[md] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[md] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[md] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Jumping = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[j] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[j] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[j] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[j] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[j] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[j] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[j] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[j] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[j] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[j] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[j] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[j] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[j] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[jd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[jd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[jd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[jd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[jd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[jd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[jd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Aircrouching = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[ac] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[ac] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[ac] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[ac] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[ac] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Speed", 1, 10, 6, true, nil, 1, {}),
		fakelagmode = ui.new_combobox("AA", "Anti-aimbot angles", "[ac] Fake lag mode", {
			"Maximum",
			"Dynamic",
			"Fluctuate"
		}),
		fakelagslider = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Fake lag amount", 1, 15, 1, true, nil, 1, {}),
		fakelagvariance = ui.new_slider("AA", "Anti-aimbot angles", "[ac] Fake lag variance", 0, 100, 0, true, nil, 1, {}),
		defensive = {
			aa = ui.new_combobox("AA", "Anti-aimbot angles", "[acd] Defensive AA", {
				"Off",
				"On peek",
				"Force"
			}),
			pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[acd] Pitch", {
				"Local view",
				"Semi-up",
				"Semi-down",
				"Sway",
				"Sideways",
				"Jitter",
				"Down",
				"Up",
				"Random",
				"Custom"
			}),
			pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[acd] Custom pitch", -89, 89, 0, true, nil, 1, {}),
			at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[acd] At targets"),
			yaw = ui.new_combobox("AA", "Anti-aimbot angles", "[acd] Yaw", {
				"Sideways",
				"Slow spin",
				"Medium spin",
				"Fast spin",
				"All the sides",
				"Custom"
			}),
			left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[acd] First yaw", -180, 180, 0, true, nil, 1, {}),
			right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[acd] Second yaw", -180, 180, 0, true, nil, 1, {})
		}
	},
	Fakelag = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "[lag] Pitch", {
			"Local view",
			"Custom",
			"Down",
			"Up",
			"Random"
		}),
		pitch_slider = ui.new_slider("AA", "Anti-aimbot angles", "[lag] Custom pitch", -89, 89, 0, true, nil, 1, {}),
		at_targets = ui.new_checkbox("AA", "Anti-aimbot angles", "[lag] At targets"),
		left_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[lag] Yaw ~ left", -180, 180, 0, true, nil, 1, {}),
		right_yaw = ui.new_slider("AA", "Anti-aimbot angles", "[lag] Yaw ~ right", -180, 180, 0, true, nil, 1, {}),
		jitter_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[lag] Jitter", {
			"Center",
			"Offset",
			"Random",
			"3 Way"
		}),
		jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", "[lag] Jitter ~ amount", -180, 180, 0, true, " ", 1, {}),
		lby = ui.new_combobox("AA", "Anti-aimbot angles", "[lag] Body yaw", {
			"Off",
			"Tickcount",
			"Delayed",
			"Static",
			"Opposite"
		}),
		lbyside = ui.new_combobox("AA", "Anti-aimbot angles", "[lag] side", {
			"Left",
			"Right",
			"Auto"
		}),
		lbyspeed = ui.new_slider("AA", "Anti-aimbot angles", "[lag] Speed", 1, 10, 6, true, nil, 1, {})
	},
	other = {
		safe_knife = ui.new_checkbox("AA", "Other", "Safe knife"),
		safe_zeus = ui.new_checkbox("AA", "Other", "Safe taser"),
		safe_head = ui.new_checkbox("AA", "Other", "Safe head on height advantage"),
		avoid_backstab = ui.new_checkbox("AA", "Other", "Svoid backstab"),
		static_freestand = ui.new_checkbox("AA", "Other", "Static on fs"),
		flickonmanuls = ui.new_checkbox("AA", "Other", "Slick opposite e on manual & fs"),
		bombsiteefix = ui.new_checkbox("AA", "Other", "Bombsite e fix"),
		legitaa = ui.new_combobox("AA", "Other", "Legit aa", {
			"off",
			"2 way",
			"static",
			"3 way"
		})
	}
}
keybinds_tab = {
	edgeyaw = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Edge yaw", false),
	freestand = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Freestand", false),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Manual left", false),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Manual right", false),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Manual forward", false),
	no_defensive = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Disable Defensive AA", false),
	hideshots = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Hideshots", false),
	airstop = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8AECF1FF•  \aFFFFFFFF Scount quickstop in air", false)
}
ragebot_tab = {
	custom_exploits = ui.new_checkbox("AA", "Anti-aimbot angles", "Improve exploits"),
	aipeek = ui.new_checkbox("AA", "Anti-aimbot angles", "Ai ~ peekbot"),
	resolver = ui.new_checkbox("AA", "Anti-aimbot angles", "Defensive ~ Currect"),
	resolver_lc = ui.new_checkbox("AA", "Anti-aimbot angles", "Resolver ~ lagcomp")
}
visuals_tab = {
	pitchzero = ui.new_checkbox("AA", "Anti-aimbot angles", "Pitch zero on land"),
	staticlegs = ui.new_checkbox("AA", "Anti-aimbot angles", "Static legs in air"),
	animfix = ui.new_combobox("AA", "Anti-aimbot angles", "Animfix", {
		"Off",
		"Moonwalk",
		"Nasawalk",
		"Shake player model"
	}),
	indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "Replace skeet indicators"),
	watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "Watermark"),
	eventlogs = ui.new_checkbox("AA", "Anti-aimbot angles", "Event logs"),
	center_indicators = ui.new_combobox("AA", "Anti-aimbot angles", "Crosshair inds", {
		"off",
		"Modern",
		"izanasense"
	}),
	onscope = ui.new_combobox("AA", "Anti-aimbot angles", "On scope animation", {
		"Off",
		"Right",
		"Alpha"
	}),
	accentlabel = ui.new_label("AA", "Anti-aimbot angles", "Accent color"),
	accent = ui.new_color_picker("AA", "Anti-aimbot angles", "Accent color"),
	arrows = ui.new_combobox("AA", "Anti-aimbot angles", "Arrows", {
		"Off",
		"TS4",
		"izanasense"
	}),
	clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Clantag"),
	trashtalk = ui.new_combobox("AA", "Anti-aimbot angles", "Trashtalk", {
		"Off",
		"English",
		"Russian",
		"Ukrainian",
		"Dutch"
	})
}
local L_41_ = "izanasense_cfg"
local L_42_ = database.read(L_41_) or {
	configs = {}
}
local L_43_ = {}
local L_44_ = {}
function ui.multiReference(L_253_arg0, L_254_arg1, L_255_arg2)
	local L_256_, L_257_, L_258_ = ui.reference(L_253_arg0, L_254_arg1, L_255_arg2)
	return {
		L_256_,
		L_257_,
		L_258_
	}
end;
local L_45_ = {}
local L_46_ = {}
local L_47_ = {}
do
	L_47_.update_list = function(L_260_arg0)
		L_43_ = {}
		for L_261_forvar0, L_262_forvar1 in pairs(L_42_.configs) do
			table.insert(L_43_, L_262_forvar1.name)
		end;
		if L_260_arg0 then
			ui.update(L_47_.listbox, L_43_)
		end;
		return L_43_
	end;
	L_47_.listbox = ui.new_listbox("AA", "Anti-aimbot angles", "Anti-aim config list", L_47_.update_list(false))
	L_47_.textbox = ui.new_textbox("AA", "Anti-aimbot angles", "Anti-aim config name")
	ui.set_callback(L_47_.listbox, function()
		local L_263_ = ui.get(L_47_.listbox)
		if L_263_ == nil then
			return
		end;
		local L_264_ = L_43_[L_263_ + 1]
		for L_266_forvar0, L_267_forvar1 in pairs(L_44_) do
			ui.set_visible(L_267_forvar1.ref, false)
		end;
		local L_265_ = L_44_[L_264_]
		if L_265_ == nil then
			L_44_[L_264_] = {
				ref = ui.new_hotkey("AA", "Fake lag", string.format("Load the config: \ac17f82ff%s", L_264_)),
				state = false,
				deleted = false
			}
		else
			ui.set_visible(L_265_.ref, true)
		end;
		ui.set(L_47_.textbox, L_264_)
	end)
	L_46_.Load = ui.new_button("AA", "Anti-aimbot angles", "\a8AECF1FFLoad", function()
		local L_268_ = ui.get(L_47_.listbox)
		if L_268_ == nil then
			client.error_log("Select a config from listbox before loading")
			return
		end;
		local L_269_ = L_42_.configs[L_43_[L_268_ + 1]]
		if type(L_269_) ~= "table" then
			client.error_log("Attempt to load a corrupted or non-existent config")
			return
		end;
		for L_270_forvar0, L_271_forvar1 in pairs(L_269_.values) do
			local L_272_ = true;
			local L_273_ = L_45_[L_270_forvar0]
			if type(L_273_) == "table" then
				L_272_ = pcall(ui.set, L_273_[1], L_271_forvar1[1])
				if not L_272_ then
					client.error_log("Attempt to load an outdated config")
					return
				end;
				L_272_ = pcall(ui.set, L_273_[2], L_271_forvar1[2])
				if not L_272_ then
					client.error_log("Attempt to load an outdated config")
					return
				end
			else
				L_272_ = pcall(ui.set, L_273_, L_271_forvar1)
				if not L_272_ then
					client.error_log("Attempt to load an outdated config")
					return
				end
			end
		end;
		L_47_.update_list(true)
	end)
	L_46_.Save = ui.new_button("AA", "Anti-aimbot angles", "\a8AECF1FFSave", function()
		local L_274_ = ui.get(L_47_.textbox)
		if L_274_ == "" then
			client.error_log("Fill in the config name textbox before saving")
			return
		end;
		local L_275_ = {
			["name"] = L_274_,
			["values"] = {}
		}
		for L_276_forvar0, L_277_forvar1 in pairs(L_45_) do
			if type(L_277_forvar1) == "table" then
				L_275_.values[L_276_forvar0] = {
					ui.get(L_277_forvar1[1]),
					ui.get(L_277_forvar1[2])
				}
			else
				L_275_.values[L_276_forvar0] = ui.get(L_277_forvar1)
			end
		end;
		L_42_.configs[L_274_] = L_275_;
		database.write(L_41_, L_42_)
		L_47_.update_list(true)
	end)
	L_46_.Delete = ui.new_button("AA", "Anti-aimbot angles", "\a8AECF1FFDelete", function()
		local L_278_ = ui.get(L_47_.listbox)
		if L_278_ == nil then
			client.error_log("Select a config from listbox before deleting")
			return
		end;
		local L_279_ = L_43_[L_278_ + 1]
		if L_279_ == "nil" then
			client.error_log("Attempt to delete non-existent config")
			return
		end;
		L_44_[L_279_].deleted = true;
		L_42_.configs[L_279_] = nil;
		database.write(L_41_, L_42_)
		L_47_.update_list(true)
	end)
	L_46_.Import = ui.new_button("AA", "Anti-aimbot angles", "\a8AECF1FFImport from clipboard", function()
		local L_280_, L_281_ = pcall(json.parse, L_11_.get())
		if not L_280_ then
			client.error_log("Attempt to load an invalid config")
			return
		end;
		for L_282_forvar0, L_283_forvar1 in pairs(L_281_) do
			local L_284_ = true;
			local L_285_ = L_45_[L_282_forvar0]
			if type(L_285_) == "table" then
				L_284_ = pcall(ui.set, L_285_[1], L_283_forvar1[1])
				if not L_284_ then
					client.error_log("Attempt to load an outdated config")
					return
				end;
				L_284_ = pcall(ui.set, L_285_[2], L_283_forvar1[2])
				if not L_284_ then
					client.error_log("Attempt to load an outdated config")
					return
				end
			else
				L_284_ = pcall(ui.set, L_285_, L_283_forvar1)
				if not L_284_ then
					client.error_log("Attempt to load an outdated config")
					return
				end
			end
		end
	end)
	L_46_.Export = ui.new_button("AA", "Anti-aimbot angles", "\a8AECF1FFExport to clipboard", function()
		local L_286_ = {}
		for L_287_forvar0, L_288_forvar1 in pairs(L_45_) do
			if type(L_288_forvar1) == "table" then
				L_286_[L_287_forvar0] = {
					ui.get(L_288_forvar1[1]),
					ui.get(L_288_forvar1[2])
				}
			else
				L_286_[L_287_forvar0] = ui.get(L_288_forvar1)
			end
		end;
		L_11_.set(json.stringify(L_286_))
	end)
	local L_259_ = true
end;
function flattenTable(L_289_arg0, L_290_arg1, L_291_arg2)
	for L_292_forvar0, L_293_forvar1 in pairs(L_289_arg0) do
		local L_294_ = L_291_arg2 and L_291_arg2 .. "." .. L_292_forvar0 or L_292_forvar0;
		if type(L_293_forvar1) == "table" then
			flattenTable(L_293_forvar1, L_290_arg1, L_294_)
		else
			L_290_arg1[L_294_] = L_293_forvar1
		end
	end
end;
flattenTable(L_40_, L_45_)
flattenTable(visuals_tab, L_45_)
flattenTable(ragebot_tab, L_45_)
function flattenTableValues(L_295_arg0)
	local L_296_ = {}
	local function L_297_func(L_298_arg0)
		for L_299_forvar0, L_300_forvar1 in pairs(L_298_arg0) do
			if type(L_300_forvar1) == "table" then
				L_297_func(L_300_forvar1)
			else
				table.insert(L_296_, L_300_forvar1)
			end
		end
	end;
	L_297_func(L_295_arg0)
	return L_296_
end;
UI_Export_Condition = ui.new_button("AA", "Fake lag", "\a8AECF1FFExport current condition", function()
	local L_301_ = {}
	currentcondui = L_40_[ui.get(L_39_)]
	for L_302_forvar0, L_303_forvar1 in ipairs(flattenTableValues(currentcondui)) do
		table.insert(L_301_, ui.get(L_303_forvar1))
	end;
	L_11_.set(L_6_.encode(L_6_.encode(json.stringify(L_301_), "base64"), "base64"))
end)
UI_Import_Condition = ui.new_button("AA", "Fake lag", "\a8AECF1FFImport to current condition", function()
	local L_304_ = json.parse(L_6_.decode(L_6_.decode(L_11_.get(), "base64"), "base64"))
	currentcondui = L_40_[ui.get(L_39_)]
	for L_305_forvar0 = 1, # L_304_ do
		ui.set(flattenTableValues(currentcondui)[L_305_forvar0], L_304_[L_305_forvar0])
	end
end)
client.set_event_callback("paint_ui", function()
	if uistate == 1 then
		ui.set_visible(UI_Export_Condition, true)
		ui.set_visible(UI_Import_Condition, true)
	else
		ui.set_visible(UI_Export_Condition, false)
		ui.set_visible(UI_Import_Condition, false)
	end;
	L_30_func(L_37_)
	if uistate == 5 then
		ui.set_visible(L_47_.listbox, true)
		ui.set_visible(L_47_.textbox, true)
		L_31_func(L_46_)
	else
		ui.set_visible(L_47_.listbox, false)
		ui.set_visible(L_47_.textbox, false)
		L_30_func(L_46_)
		for L_306_forvar0, L_307_forvar1 in pairs(L_44_) do
			ui.set_visible(L_307_forvar1.ref, false)
		end
	end;
	if uistate ~= 1 then
		L_30_func(L_40_)
		ui.set_visible(L_39_, false)
		ui.set_visible(L_38_, false)
	else
		currentcondition = L_40_[ui.get(L_39_)]
		ui.set_visible(L_38_, true)
		L_30_func(L_40_)
		L_31_func(L_40_.other)
		if ui.get(L_38_) == "Custom" then
			L_31_func(currentcondition)
			ui.set_visible(L_39_, true)
			if ui.get(currentcondition.pitch) ~= "Custom" then
				ui.set_visible(currentcondition.pitch_slider, false)
			else
				ui.set_visible(currentcondition.pitch_slider, true)
			end;
			if ui.get(currentcondition.lby) == "Tickcount" then
				ui.set_visible(currentcondition.lbyside, false)
				ui.set_visible(currentcondition.lbyspeed, false)
			end;
			if ui.get(currentcondition.lby) == "Static" or ui.get(currentcondition.lby) == "Opposite" then
				ui.set_visible(currentcondition.lbyside, true)
				ui.set_visible(currentcondition.lbyspeed, false)
			end;
			if ui.get(currentcondition.lby) == "Delayed" then
				ui.set_visible(currentcondition.lbyside, false)
				ui.set_visible(currentcondition.lbyspeed, true)
			end;
			if ui.get(currentcondition.lby) == "Off" then
				ui.set_visible(currentcondition.lbyside, false)
				ui.set_visible(currentcondition.lbyspeed, false)
			end;
			if ui.get(L_39_) ~= "Fakelag" then
				if ui.get(currentcondition.defensive.aa) == "Off" then
					L_30_func(currentcondition.defensive)
					ui.set_visible(currentcondition.defensive.aa, true)
				else
					L_31_func(currentcondition.defensive)
					if ui.get(currentcondition.defensive.pitch) ~= "Custom" then
						ui.set_visible(currentcondition.defensive.pitch_slider, false)
					else
						ui.set_visible(currentcondition.defensive.pitch_slider, true)
					end;
					if ui.get(currentcondition.defensive.yaw) ~= "Custom" then
						ui.set_visible(currentcondition.defensive.left_yaw, false)
						ui.set_visible(currentcondition.defensive.right_yaw, false)
					else
						ui.set_visible(currentcondition.defensive.left_yaw, true)
						ui.set_visible(currentcondition.defensive.right_yaw, true)
					end
				end
			end
		else
			L_30_func(currentcondition.defensive)
			L_30_func(currentcondition)
			ui.set_visible(L_39_, false)
		end
	end;
	if uistate == 6 then
		L_31_func(keybinds_tab)
	else
		L_30_func(keybinds_tab)
	end;
	if uistate == 2 then
		L_31_func(ragebot_tab)
	else
		L_30_func(ragebot_tab)
	end;
	if uistate == 3 then
		L_31_func(visuals_tab)
	else
		L_30_func(visuals_tab)
	end
end)
local L_48_ = function(L_308_arg0, L_309_arg1)
	local L_310_ = {}
	for L_311_forvar0 = 1, L_309_arg1 do
		L_310_[L_311_forvar0] = L_308_arg0
	end;
	return L_310_
end;
local L_49_ = function(L_312_arg0, L_313_arg1, L_314_arg2)
	local L_315_ = L_312_arg0;
	if L_314_arg2 or L_315_[# L_315_] ~= L_313_arg1 then
		table.insert(L_315_, L_313_arg1)
		table.remove(L_315_, 1)
	end;
	L_312_arg0 = L_315_
end;
local L_50_ = function(L_316_arg0)
	local L_317_, L_318_ = 0, 0;
	for L_319_forvar0, L_320_forvar1 in pairs(L_316_arg0) do
		L_318_ = L_318_ + L_320_forvar1;
		L_317_ = L_317_ + 1
	end;
	return L_318_ / L_317_
end;
breaker = {
	defensive = 0,
	defensive_check = 0,
	cmd = 0,
	last_origin = nil,
	origin = nil,
	tp_dist = 0,
	tp_data = L_48_(0, 3),
	chokes = 0
}
function get_velocity(L_321_arg0)
	local L_322_, L_323_, L_324_ = entity.get_prop(L_321_arg0, "m_vecVelocity")
	if L_322_ == nil then
		return
	end;
	return math.sqrt(L_322_ * L_322_ + L_323_ * L_323_ + L_324_ * L_324_)
end;
tickbase = nil;
forrealtime = 0;
function smoothJitter(L_325_arg0, L_326_arg1, L_327_arg2)
	if globals.curtime() > forrealtime + 1 / (L_327_arg2 * 2) then
		finalyawgg = L_325_arg0;
		if globals.curtime() - forrealtime > 2 / (L_327_arg2 * 2) then
			forrealtime = globals.curtime(entity.get_local_player(), "m_flPoseParameter")
		end
	else
		finalyawgg = L_326_arg1
	end;
	return finalyawgg
end;
client.set_event_callback("run_command", function(L_328_arg0)
	breaker.cmd = L_328_arg0.command_number;
	me = entity.get_local_player()
	if not me or not entity.is_alive(me) then
		breaker.defensive_check = 0;
		return
	end;
	if math.abs(tickbase - breaker.defensive_check - 1) > 128 then
		breaker.defensive_check = 0
	end
end)
client.set_event_callback("predict_command", function(L_329_arg0)
	me = entity.get_local_player()
	tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
	breaker.defensive_check = math.max(tickbase, breaker.defensive_check)
	if not me or not entity.is_alive(me) then
		breaker.defensive_check = 0;
		return
	end;
	if math.abs(tickbase - breaker.defensive_check - 1) > 128 then
		breaker.defensive_check = 0;
		return
	end;
	breaker.defensive = 0;
	if breaker.cmd == L_329_arg0.command_number then
		if tickbase > breaker.defensive_check then
			breaker.defensive_check = tickbase
		elseif breaker.defensive_check > tickbase then
			breaker.defensive = tickbase - breaker.defensive_check
		end
	end;
	if math.abs(tickbase - breaker.defensive_check - 2) > 128 then
		breaker.defensive_check = 0;
		return
	end
end)
client.set_event_callback("level_init", function()
	breaker.cmd = 0;
	breaker.defensive_check = 0;
	forrealtime = 0
end)
client.set_event_callback("round_start", function()
	breaker.cmd = 0;
	breaker.defensive_check = 0
end)
function desyncside()
	if not entity.get_local_player() or not entity.is_alive(entity.get_local_player()) then
		return
	end;
	local L_330_ = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60;
	local L_331_ = L_330_ > 0 and -1 or 1;
	return L_331_
end;
condtotake = ""
function calculate_body_fs()
	if not entity.get_local_player() or not client.current_threat() then
		return 1
	end;
	local L_332_, L_333_, L_334_ = entity.hitbox_position(entity.get_local_player(), 0)
	local L_335_, L_336_, L_337_ = entity.hitbox_position(client.current_threat(), 0)
	local L_338_;
	if L_335_ - L_332_ < 10 then
		L_338_ = -1
	else
		L_338_ = 1
	end;
	return L_338_
end;
local L_51_ = {
	condition = ""
}
local L_52_ = {
	lp = entity.get_local_player(),
	ground_ticks = 0
}
skeetfakelaglimit = ui.reference("AA", "Fake lag", "Limit")
skeetfakelagamount = ui.reference("AA", "Fake lag", "Amount")
local L_53_ = {
	multipoint = ui.multiReference("RAGE", "Aimbot", "Multi-point scale"),
	doubletap = ui.multiReference("RAGE", "Aimbot", "Double tap"),
	hideshots = ui.multiReference("AA", "Other", "On shot anti-aim"),
	freestand = ui.multiReference("AA", "Anti-aimbot angles", "Freestanding"),
	dmg = ui.multiReference("RAGE", "Aimbot", "Minimum damage override")
}
function L_52_:is_on_ground()
	lp = entity.get_local_player()
	if not lp then
		return
	end;
	local L_339_ = entity.get_prop(lp, "m_fFlags")
	if L_5_.band(L_339_, 1) == 0 then
		L_52_.ground_ticks = 0
	elseif L_52_.ground_ticks <= 45 then
		L_52_.ground_ticks = L_52_.ground_ticks + 1
	end;
	return L_52_.ground_ticks >= 45
end;
function L_51_:get_condition_type()
	lp = entity.get_local_player()
	if not lp or not entity.is_alive(lp) then
		return
	end;
	if not entity.is_alive(lp) then
		return
	end;
	local L_340_ = entity.get_prop(lp, "m_flDuckAmount")
	local L_341_ = L_9_(entity.get_prop(lp, "m_vecVelocity")):length()
	if ui.get(L_53_.doubletap[1]) and ui.get(L_53_.doubletap[2]) and not ui.get(L_37_.antiaim.fd) or ui.get(L_53_.hideshots[1]) and not ui.get(L_37_.antiaim.fd) and ui.get(L_53_.hideshots[2]) then
		if not L_52_:is_on_ground() and L_340_ == 0 then
			return "Jumping"
		elseif L_340_ > 0 and not L_52_:is_on_ground() then
			return "Aircrouching"
		elseif L_340_ > 0 and L_341_ < 3 and L_52_:is_on_ground() and not ui.get(L_37_.antiaim.fd) then
			return "Crouching"
		elseif L_340_ > 0 and L_341_ > 3 and L_52_:is_on_ground() and not ui.get(L_37_.antiaim.fd) then
			return "Crouchrunning"
		elseif L_341_ > 2 and not ui.get(L_37_.antiaim.slow_motion[2]) then
			return "Running"
		elseif ui.get(L_37_.antiaim.slow_motion[2]) then
			return "Slowmotion"
		else
			return "Standing"
		end
	else
		return "Fakelag"
	end
end;
function L_51_:get_fakelag_cond()
	lp = entity.get_local_player()
	if not lp or not entity.is_alive(lp) then
		return
	end;
	if not entity.is_alive(lp) then
		return
	end;
	local L_342_ = entity.get_prop(lp, "m_flDuckAmount")
	local L_343_ = L_9_(entity.get_prop(lp, "m_vecVelocity")):length()
	if not L_52_:is_on_ground() and L_342_ == 0 then
		return "Jumping"
	elseif L_342_ > 0 and not L_52_:is_on_ground() then
		return "Aircrouching"
	elseif L_342_ > 0 and L_343_ < 3 and L_52_:is_on_ground() and not ui.get(L_37_.antiaim.fd) then
		return "Crouching"
	elseif L_342_ > 0 and L_343_ > 3 and L_52_:is_on_ground() and not ui.get(L_37_.antiaim.fd) then
		return "Crouchrunning"
	elseif L_343_ > 2 and not ui.get(L_37_.antiaim.slow_motion[2]) then
		return "Running"
	elseif ui.get(L_37_.antiaim.slow_motion[2]) then
		return "Slowmotion"
	else
		return "Standing"
	end
end;
local L_54_ = true;
local L_55_ = 0;
function customsway()
	if L_54_ == true then
		L_55_ = L_55_ + 0.11;
		if L_55_ > 1 then
			L_54_ = false
		end
	else
		L_55_ = L_55_ - 0.11;
		if L_55_ < 0 then
			L_55_ = 0;
			L_54_ = true
		end
	end;
	return L_55_
end;
local function L_56_func(L_344_arg0, L_345_arg1)
	local L_346_ = L_9_(entity.get_prop(L_344_arg0, "m_vecOrigin"))
	local L_347_ = L_9_(entity.get_prop(L_345_arg1, "m_vecOrigin"))
	local L_348_ = L_346_:dist(L_347_)
	return L_348_
end;
local function L_57_func(L_349_arg0)
	local L_350_ = entity.get_local_player()
	local L_351_, L_352_, L_353_ = entity.hitbox_position(L_350_, 0)
	local L_354_, L_355_, L_356_ = entity.hitbox_position(L_349_arg0, 0)
	local L_357_, L_358_ = client.trace_line(L_350_, L_351_, L_352_, L_353_, L_354_, L_355_, L_356_)
	return L_357_ > 0.65
end;
client.set_event_callback("setup_command", function(L_359_arg0)
	me = entity.get_local_player()
	if not me or not entity.is_alive(me) then
		return
	end;
	breaker.tickbase_check = globals.tickcount() > entity.get_prop(me, "m_nTickbase")
end)
local function L_58_func()
	local L_360_ = client.current_threat()
	local L_361_ = entity.get_local_player()
	if not L_360_ or not L_361_ then
		return false
	end;
	if entity.get_classname(entity.get_player_weapon(L_360_)) == "CKnife" and L_57_func(L_360_) and L_56_func(L_361_, L_360_) < 450 and L_360_ ~= nil then
		return true
	else
		return false
	end
end;
function safeheadtarget()
	local L_362_ = client.current_threat()
	if L_362_ == nil then
		return false
	end;
	if entity.get_classname(entity.get_player_weapon(L_362_)) ~= "CKnife" and L_56_func(lp, L_362_) > 25 then
		local L_363_ = L_9_(entity.get_origin(entity.get_local_player()))
		local L_364_ = L_9_(entity.get_origin(L_362_))
		return L_363_.z - L_364_.z > 70
	else
		return false
	end
end;
freestand, freestandkey = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
last_press_t = 0;
client.set_event_callback("paint_ui", function()
	if ui.get(keybinds_tab.hideshots) then
		ui.set(L_53_.hideshots[1], true)
		ui.set(L_53_.hideshots[2], "Always on")
	else
		ui.set(L_53_.hideshots[1], false)
		ui.set(L_53_.hideshots[2], "On hotkey")
	end;
	if ui.get(keybinds_tab.edgeyaw) then
		ui.set(L_37_.antiaim.edgeyaw, true)
	else
		ui.set(L_37_.antiaim.edgeyaw, false)
	end;
	ui.set(keybinds_tab.manual_right, "On hotkey")
	ui.set(keybinds_tab.manual_left, "On hotkey")
	ui.set(keybinds_tab.manual_forward, "On hotkey")
	if ui.get(keybinds_tab.manual_right) and last_press_t + 0.2 < globals.curtime() then
		manual_dir = manual_dir == 2 and 0 or 2;
		last_press_t = globals.curtime()
	elseif ui.get(keybinds_tab.manual_left) and last_press_t + 0.2 < globals.curtime() then
		manual_dir = manual_dir == 1 and 0 or 1;
		last_press_t = globals.curtime()
	elseif ui.get(keybinds_tab.manual_forward) and last_press_t + 0.2 < globals.curtime() then
		manual_dir = manual_dir == 3 and 0 or 3;
		last_press_t = globals.curtime()
	elseif last_press_t > globals.curtime() then
		last_press_t = globals.curtime()
	end;
	if ui.get(keybinds_tab.freestand) and manual_dir == 0 then
		ui.set(freestand, true)
		ui.set(freestandkey, "Always on")
	else
		ui.set(freestand, false)
		ui.set(freestandkey, "On hotkey")
	end
end)
abstoflick = 0;
clamper = function(L_365_arg0)
	if L_365_arg0 > 180 then
		return -180 + L_365_arg0 - 180
	elseif L_365_arg0 < -180 then
		return 180 - (-180 - L_365_arg0)
	end
end;
manual_dir = 0;
client.set_event_callback("setup_command", function(L_366_arg0)
	local L_367_ = L_50_(breaker.tp_data) / get_velocity(entity.get_local_player()) * 100;
	exploiting = ui.get(L_53_.doubletap[1]) and ui.get(L_53_.doubletap[2]) and not ui.get(L_37_.antiaim.fd) or ui.get(L_53_.hideshots[1]) and not ui.get(L_37_.antiaim.fd) and ui.get(L_53_.hideshots[2])
	is_defensive = not ui.get(keybinds_tab.no_defensive) and breaker.tickbase_check and breaker.defensive < -2 and not breaker.defensive ~= -15 and exploiting;
	handle_aa = function(L_378_arg0, L_379_arg1, L_380_arg2, L_381_arg3, L_382_arg4, L_383_arg5, L_384_arg6, L_385_arg7, L_386_arg8, L_387_arg9, L_388_arg10, L_389_arg11, L_390_arg12, L_391_arg13, L_392_arg14, L_393_arg15, L_394_arg16, L_395_arg17, L_396_arg18, L_397_arg19)
		if ui.get(L_38_) == "Custom" then
			if L_391_arg13 == "Force" then
				L_366_arg0.force_defensive = 1
			end;
			if L_378_arg0 == "Local view" then
				ui.set(L_37_.antiaim.pitch[1], "Off")
			elseif L_378_arg0 == "Custom" then
				ui.set(L_37_.antiaim.pitch[1], "Custom")
				ui.set(L_37_.antiaim.pitch[2], L_379_arg1)
			elseif L_378_arg0 == "Down" then
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
			else
				ui.set(L_37_.antiaim.pitch[1], L_378_arg0)
			end;
			if L_380_arg2 then
				ui.set(L_37_.antiaim.yaw_base, "At targets")
			else
				ui.set(L_37_.antiaim.yaw_base, "Local view")
			end;
			ui.set(L_37_.antiaim.yaw[1], "180")
			if desyncside() == -1 then
				ui.set(L_37_.antiaim.yaw[2], L_381_arg3)
			else
				ui.set(L_37_.antiaim.yaw[2], L_382_arg4)
			end;
			if L_383_arg5 == "3 Way" then
				ui.set(L_37_.antiaim.jitter[1], "Skitter")
				ui.set(L_37_.antiaim.jitter[2], L_384_arg6)
			else
				ui.set(L_37_.antiaim.jitter[1], L_383_arg5)
				ui.set(L_37_.antiaim.jitter[2], L_384_arg6)
			end;
			ui.set(L_37_.antiaim.fs_body_yaw, false)
			if L_385_arg7 == "Opposite" then
				ui.set(L_37_.antiaim.body_yaw[1], "Opposite")
				ui.set(L_37_.antiaim.fs_body_yaw, true)
			elseif L_385_arg7 == "Static" then
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				if L_386_arg8 == "Left" then
					ui.set(L_37_.antiaim.body_yaw[2], -58)
				elseif L_386_arg8 == "Right" then
					ui.set(L_37_.antiaim.body_yaw[2], 58)
				elseif L_386_arg8 == "Auto" then
					ui.set(L_37_.antiaim.body_yaw[2], 58 * calculate_body_fs())
				end
			elseif L_385_arg7 == "Tickcount" then
				ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
				ui.set(L_37_.antiaim.body_yaw[2], -1)
			elseif L_385_arg7 == "Delayed" then
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], smoothJitter(1, -1, L_387_arg9))
			elseif L_385_arg7 == "Off" then
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
			end;
			ui.set(L_37_.antiaim.fakelagenabled[1], true)
			ui.set(L_37_.antiaim.fakelagamount[1], L_388_arg10)
			ui.set(skeetfakelaglimit, L_390_arg12)
			ui.set(L_37_.antiaim.fakelagvariance[1], L_389_arg11)
		elseif ui.get(L_38_) == "Ai-based" then
			ui.set(L_37_.antiaim.fakelagenabled[1], true)
			ui.set(L_37_.antiaim.fakelagamount[1], "Maximum")
			ui.set(skeetfakelaglimit, 14)
			ui.set(L_37_.antiaim.fakelagvariance[1], 1)
			if L_51_:get_condition_type() == "Crouching" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
				ui.set(L_37_.antiaim.body_yaw[2], -1)
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -25)
				else
					ui.set(L_37_.antiaim.yaw[2], 44)
				end
			elseif L_51_:get_condition_type() == "Crouchrunning" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], smoothJitter(-60, 60, 3))
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -31)
				else
					ui.set(L_37_.antiaim.yaw[2], 56)
				end
			elseif L_51_:get_condition_type() == "Standing" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
				ui.set(L_37_.antiaim.body_yaw[2], -1)
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -1)
				else
					ui.set(L_37_.antiaim.yaw[2], 24)
				end
			elseif L_51_:get_condition_type() == "Slowmotion" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], -1)
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 0)
			elseif L_51_:get_condition_type() == "Running" then
				L_366_arg0.force_defensive = 0;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Random")
				ui.set(L_37_.antiaim.jitter[2], -3)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], smoothJitter(-60, 60, 3))
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -30)
				else
					ui.set(L_37_.antiaim.yaw[2], 48)
				end
			elseif L_51_:get_condition_type() == "Jumping" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
				ui.set(L_37_.antiaim.body_yaw[2], -1)
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -6)
				else
					ui.set(L_37_.antiaim.yaw[2], 27)
				end
			elseif L_51_:get_condition_type() == "Aircrouching" then
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], smoothJitter(-60, 60, 10))
				ui.set(L_37_.antiaim.yaw[1], "180")
				if desyncside() == -1 then
					ui.set(L_37_.antiaim.yaw[2], -31)
				else
					ui.set(L_37_.antiaim.yaw[2], 57)
				end
			elseif L_51_:get_condition_type() == "Fakelag" then
				L_366_arg0.force_defensive = 0;
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.jitter[1], "Center")
				ui.set(L_37_.antiaim.jitter[2], 66)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 7)
			end
		end;
		if ui.get(L_40_.other.safe_knife) and L_51_:get_condition_type() == "Aircrouching" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" then
			ui.set(L_37_.antiaim.pitch[1], "Minimal")
			ui.set(L_37_.antiaim.yaw_base, "At targets")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 0)
			ui.set(L_37_.antiaim.jitter[1], "Offset")
			ui.set(L_37_.antiaim.jitter[2], 0)
			ui.set(L_37_.antiaim.body_yaw[1], "Static")
			ui.set(L_37_.antiaim.body_yaw[2], 0)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		end;
		if ui.get(L_40_.other.safe_zeus) and L_51_:get_condition_type() == "Aircrouching" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CWeaponTaser" then
			ui.set(L_37_.antiaim.pitch[1], "Custom")
			ui.set(L_37_.antiaim.pitch[2], 89)
			ui.set(L_37_.antiaim.yaw_base, "At targets")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 0)
			ui.set(L_37_.antiaim.jitter[1], "Random")
			ui.set(L_37_.antiaim.jitter[2], 0)
			ui.set(L_37_.antiaim.body_yaw[1], "Static")
			ui.set(L_37_.antiaim.body_yaw[2], 0)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		end;
		if ui.get(L_40_.other.safe_head) and safeheadtarget() and (L_51_:get_condition_type() == "Aircrouching" or L_51_:get_condition_type() == "Crouching" or L_51_:get_condition_type() == "Crouchrunning" or L_51_:get_condition_type() == "Standing" or L_51_:get_condition_type() == "Fakelag") then
			ui.set(L_37_.antiaim.pitch[1], "Minimal")
			ui.set(L_37_.antiaim.yaw_base, "At targets")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 0)
			ui.set(L_37_.antiaim.jitter[1], "Offset")
			ui.set(L_37_.antiaim.jitter[2], 0)
			ui.set(L_37_.antiaim.body_yaw[1], "Static")
			ui.set(L_37_.antiaim.body_yaw[2], 0)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		end;
		if ui.get(L_40_.other.static_freestand) and ui.get(keybinds_tab.freestand) then
			if ui.get(L_40_.other.flickonmanuls) then
				L_366_arg0.force_defensive = 1
			end;
			if ui.get(L_40_.other.flickonmanuls) and is_defensive then
				L_366_arg0.yaw = abstoflick + 180 + math.random(-10, 10)
				L_366_arg0.pitch = 1080 + math.random(-25, 10)
				L_366_arg0.force_defensive = 1;
				ui.set(L_37_.antiaim.pitch[1], "Custom")
				ui.set(L_37_.antiaim.pitch[2], 0)
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], clamper(abstoflick))
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			else
				abstoflick = L_7_.get_abs_yaw()
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "At targets")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 0)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Static")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, true)
			end
		end;
		if ui.get(L_38_) == "Custom" then
			if is_defensive and L_391_arg13 ~= "Off" then
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				if L_392_arg14 == "Local view" then
					ui.set(L_37_.antiaim.pitch[1], "Off")
				elseif L_392_arg14 == "Sideways" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], -69 - 19 * customsway())
				elseif L_392_arg14 == "Jitter" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], smoothJitter(45, -45, 7.5))
				elseif L_392_arg14 == "Sway" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], -80 * customsway())
				elseif L_392_arg14 == "Custom" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], L_393_arg15)
				elseif L_392_arg14 == "Semi-up" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], -45)
				elseif L_392_arg14 == "Semi-down" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], 45)
				elseif L_392_arg14 == "Up" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], -89)
				elseif L_392_arg14 == "Down" then
					ui.set(L_37_.antiaim.pitch[1], "Minimal")
				elseif L_392_arg14 == "Random" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], math.random(-80, 80))
				end;
				if L_394_arg16 then
					ui.set(L_37_.antiaim.yaw_base, "At targets")
				else
					ui.set(L_37_.antiaim.yaw_base, "Local view")
				end;
				if L_395_arg17 ~= "All the sides" then
					ui.set(L_37_.antiaim.jitter[1], "Random")
					ui.set(L_37_.antiaim.jitter[2], 0)
					if L_395_arg17 == "Slow spin" then
						ui.set(L_37_.antiaim.yaw[1], "Spin")
						ui.set(L_37_.antiaim.yaw[2], math.random(5, 8))
					elseif L_395_arg17 == "Medium spin" then
						ui.set(L_37_.antiaim.yaw[1], "Spin")
						ui.set(L_37_.antiaim.yaw[2], 38)
					elseif L_395_arg17 == "Fast spin" then
						ui.set(L_37_.antiaim.yaw[1], "Spin")
						ui.set(L_37_.antiaim.yaw[2], math.random(119, 121))
					elseif L_395_arg17 == "Sideways" then
						ui.set(L_37_.antiaim.yaw[1], "180")
						ui.set(L_37_.antiaim.yaw[2], smoothJitter(math.random(-81, -109), math.random(81, 109), 10))
					elseif L_395_arg17 == "Custom" then
						ui.set(L_37_.antiaim.yaw[1], "180")
						ui.set(L_37_.antiaim.yaw[2], smoothJitter(L_396_arg18, L_397_arg19, 10))
					end
				else
					ui.set(L_37_.antiaim.yaw[1], "180")
					ui.set(L_37_.antiaim.yaw[2], smoothJitter(math.random(20, 160), math.random(-160, -20), 10))
				end
			end
		elseif ui.get(L_38_) == "Ai-based" then
			if is_defensive then
				if L_51_:get_condition_type() == "Crouching" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], 0)
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "Spin")
					ui.set(L_37_.antiaim.yaw[2], math.random(5, 8))
				elseif L_51_:get_condition_type() == "Crouchrunning" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], ui.set(L_37_.antiaim.pitch[2], -80 * customsway()))
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "180")
					ui.set(L_37_.antiaim.yaw[2], smoothJitter(math.random(-70, -92), math.random(90, 112), 12))
				elseif L_51_:get_condition_type() == "Standing" then
					ui.set(L_37_.antiaim.pitch[1], "Up")
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "Spin")
					ui.set(L_37_.antiaim.yaw[2], math.random(5, 8))
				elseif L_51_:get_condition_type() == "Slowmotion" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], -45)
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "Spin")
					ui.set(L_37_.antiaim.yaw[2], math.random(5, 8))
				elseif L_51_:get_condition_type() == "Running" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], 0)
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "Spin")
					ui.set(L_37_.antiaim.yaw[2], math.random(119, 121))
				elseif L_51_:get_condition_type() == "Jumping" then
					ui.set(L_37_.antiaim.pitch[1], "Custom")
					ui.set(L_37_.antiaim.pitch[2], smoothJitter(45, -45, smoothJitter(15, 8, 9)))
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "180")
					ui.set(L_37_.antiaim.yaw[2], smoothJitter(math.random(-70, -92), math.random(90, 112), 12))
				elseif L_51_:get_condition_type() == "Aircrouching" then
					ui.set(L_37_.antiaim.pitch[1], "Minimal")
					ui.set(L_37_.antiaim.yaw_base, "At targets")
					ui.set(L_37_.antiaim.jitter[1], "Offset")
					ui.set(L_37_.antiaim.jitter[2], 0)
					ui.set(L_37_.antiaim.body_yaw[1], "Off")
					ui.set(L_37_.antiaim.yaw[1], "180")
					ui.set(L_37_.antiaim.yaw[2], smoothJitter(-130, 142, 10))
				end
			end
		end;
		local L_398_ = entity.get_local_player()
		local L_399_ = entity.get_prop(L_398_, "m_flNextAttack")
		local L_400_ = entity.get_prop(entity.get_player_weapon(L_398_), "m_flNextPrimaryAttack")
		local L_401_ = false;
		local L_402_ = ui.get(L_53_.doubletap[1]) and ui.get(L_53_.doubletap[2])
		if L_400_ ~= nil then
			L_401_ = not (math.max(L_400_, L_399_) > globals.curtime())
		end;
		if not is_defensive and L_391_arg13 == "Force" and ui.get(ragebot_tab.custom_exploits) and L_402_ and L_401_ and L_51_:get_condition_type() ~= "Fakelag" then
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 0)
			ui.set(L_37_.antiaim.jitter[1], "Off")
			ui.set(L_37_.antiaim.body_yaw[1], "Off")
		end;
		if manual_dir == 2 then
			L_366_arg0.force_defensive = 1;
			if not is_defensive or not ui.get(L_40_.other.flickonmanuls) then
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 90)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			else
				ui.set(L_37_.antiaim.pitch[1], "Custom")
				ui.set(L_37_.antiaim.pitch[2], 0)
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], -90)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			end
		elseif manual_dir == 1 then
			L_366_arg0.force_defensive = 1;
			if not is_defensive or not ui.get(L_40_.other.flickonmanuls) then
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], -90)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			else
				ui.set(L_37_.antiaim.pitch[1], "Custom")
				ui.set(L_37_.antiaim.pitch[2], 0)
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 90)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			end
		elseif manual_dir == 3 then
			L_366_arg0.force_defensive = 1;
			if not is_defensive or not ui.get(L_40_.other.flickonmanuls) then
				ui.set(L_37_.antiaim.pitch[1], "Minimal")
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 180)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			else
				ui.set(L_37_.antiaim.pitch[1], "Custom")
				ui.set(L_37_.antiaim.pitch[2], 0)
				ui.set(L_37_.antiaim.yaw_base, "Local view")
				ui.set(L_37_.antiaim.yaw[1], "180")
				ui.set(L_37_.antiaim.yaw[2], 0)
				ui.set(L_37_.antiaim.jitter[1], "Offset")
				ui.set(L_37_.antiaim.jitter[2], 0)
				ui.set(L_37_.antiaim.body_yaw[1], "Off")
				ui.set(L_37_.antiaim.body_yaw[2], 0)
				ui.set(L_37_.antiaim.fs_body_yaw, false)
			end
		end
	end;
	condtotake = L_40_[L_51_:get_condition_type()]
	condtotakeflags = L_40_[L_51_:get_fakelag_cond()]
	local L_368_ = ui.get(condtotake.pitch)
	local L_369_ = ui.get(condtotake.pitch_slider)
	local L_370_ = ui.get(condtotake.at_targets)
	local L_371_ = ui.get(condtotake.left_yaw)
	local L_372_ = ui.get(condtotake.right_yaw)
	local L_373_ = ui.get(condtotake.jitter_mode)
	local L_374_ = ui.get(condtotake.jitter_amount)
	local L_375_ = ui.get(condtotake.lby)
	local L_376_ = ui.get(condtotake.lbyside)
	local L_377_ = ui.get(condtotake.lbyspeed)
	if L_51_:get_condition_type() ~= "Fakelag" then
		fakelagmode = ui.get(condtotake.fakelagmode)
		fakelagvariance = ui.get(condtotake.fakelagvariance)
		fakelagslider = ui.get(condtotake.fakelagslider)
		defensivemode = ui.get(condtotake.defensive.aa)
		defensivepitch = ui.get(condtotake.defensive.pitch)
		defensiveslider = ui.get(condtotake.defensive.pitch_slider)
		defensiveattargets = ui.get(condtotake.defensive.at_targets)
		defensiveyaw = ui.get(condtotake.defensive.yaw)
		defensiveleft = ui.get(condtotake.defensive.left_yaw)
		defensiveright = ui.get(condtotake.defensive.right_yaw)
	else
		fakelagmode = ui.get(condtotakeflags.fakelagmode)
		fakelagvariance = ui.get(condtotakeflags.fakelagvariance)
		fakelagslider = ui.get(condtotakeflags.fakelagslider)
		defensivemode = ui.get(condtotakeflags.defensive.aa)
		defensivepitch = ui.get(condtotakeflags.defensive.pitch)
		defensiveslider = ui.get(condtotakeflags.defensive.pitch_slider)
		defensiveattargets = ui.get(condtotakeflags.defensive.at_targets)
		defensiveyaw = ui.get(condtotakeflags.defensive.yaw)
		defensiveleft = ui.get(condtotakeflags.defensive.left_yaw)
		defensiveright = ui.get(condtotakeflags.defensive.right_yaw)
	end;
	if exploiting and ui.get(ragebot_tab.custom_exploits) then
		ui.set(L_37_.antiaim.fakelagenabled[1], false)
	end;
	handle_aa(L_368_, L_369_, L_370_, L_371_, L_372_, L_373_, L_374_, L_375_, L_376_, L_377_, fakelagmode, fakelagvariance, fakelagslider, defensivemode, defensivepitch, defensiveslider, defensiveattargets, defensiveyaw, defensiveleft, defensiveright)
end)
client.set_event_callback("setup_command", function()
	if ui.get(L_40_.other.avoid_backstab) and L_58_func() then
		ui.set(L_37_.antiaim.pitch[1], "Down")
		ui.set(L_37_.antiaim.yaw_base, "At targets")
		ui.set(L_37_.antiaim.yaw[1], "180")
		ui.set(L_37_.antiaim.yaw[2], 180)
		ui.set(L_37_.antiaim.jitter[1], "Offset")
		ui.set(L_37_.antiaim.jitter[2], 0)
		ui.set(L_37_.antiaim.body_yaw[1], "Static")
		ui.set(L_37_.antiaim.body_yaw[2], 0)
		ui.set(L_37_.antiaim.fs_body_yaw, false)
	end
end)
function distance3d(L_403_arg0, L_404_arg1, L_405_arg2, L_406_arg3, L_407_arg4, L_408_arg5)
	return math.sqrt((L_406_arg3 - L_403_arg0) * (L_406_arg3 - L_403_arg0) + (L_407_arg4 - L_404_arg1) * (L_407_arg4 - L_404_arg1) + (L_408_arg5 - L_405_arg2) * (L_408_arg5 - L_405_arg2))
end;
function entity_has_c4(L_409_arg0)
	local L_410_ = entity.get_all("CC4")[1]
	return L_410_ ~= nil and entity.get_prop(L_410_, "m_hOwnerEntity") == L_409_arg0
end;
classnames = {
	"CWorld",
	"CCSPlayer",
	"CFuncBrush"
}
trynna_plant = false;
using = false;
client.set_event_callback("setup_command", function(L_411_arg0)
	local L_412_ = entity.get_local_player()
	if L_411_arg0.in_use == 1 then
		if ui.get(L_40_.other.legitaa) == "off" then
			ui.set(L_37_.antiaim.pitch[1], "Off")
			ui.set(L_37_.antiaim.yaw_base, "Local view")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 180)
			ui.set(L_37_.antiaim.jitter[1], "Offset")
			ui.set(L_37_.antiaim.jitter[2], 0)
			ui.set(L_37_.antiaim.body_yaw[1], "Off")
			ui.set(L_37_.antiaim.body_yaw[2], 0)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		elseif ui.get(L_40_.other.legitaa) == "2 way" then
			ui.set(L_37_.antiaim.pitch[1], "Off")
			ui.set(L_37_.antiaim.yaw_base, "Local view")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 180)
			ui.set(L_37_.antiaim.jitter[1], "Center")
			ui.set(L_37_.antiaim.jitter[2], 90)
			ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
			ui.set(L_37_.antiaim.body_yaw[2], -1)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		elseif ui.get(L_40_.other.legitaa) == "3 way" then
			ui.set(L_37_.antiaim.pitch[1], "Off")
			ui.set(L_37_.antiaim.yaw_base, "Local view")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 180)
			ui.set(L_37_.antiaim.jitter[1], "Skitter")
			ui.set(L_37_.antiaim.jitter[2], 77)
			ui.set(L_37_.antiaim.body_yaw[1], "Jitter")
			ui.set(L_37_.antiaim.body_yaw[2], -1)
			ui.set(L_37_.antiaim.fs_body_yaw, false)
		elseif ui.get(L_40_.other.legitaa) == "static" then
			ui.set(L_37_.antiaim.pitch[1], "Off")
			ui.set(L_37_.antiaim.yaw_base, "Local view")
			ui.set(L_37_.antiaim.yaw[1], "180")
			ui.set(L_37_.antiaim.yaw[2], 180)
			ui.set(L_37_.antiaim.jitter[1], "Offset")
			ui.set(L_37_.antiaim.jitter[2], 0)
			ui.set(L_37_.antiaim.body_yaw[1], "Opposite")
			ui.set(L_37_.antiaim.fs_body_yaw, true)
		end
	end;
	if not L_412_ or not entity.is_alive(L_412_) then
		return
	end;
	local L_413_ = 100;
	local L_414_ = entity.get_all("CPlantedC4")[1]
	local L_415_, L_416_, L_417_ = entity.get_prop(L_414_, "m_vecOrigin")
	if L_415_ ~= nil then
		local L_436_, L_437_, L_438_ = entity.get_prop(L_412_, "m_vecOrigin")
		L_413_ = distance3d(L_415_, L_416_, L_417_, L_436_, L_437_, L_438_)
	end;
	local L_418_ = entity.get_prop(L_412_, "m_iTeamNum")
	local L_419_ = L_418_ == 3 and L_413_ < 62;
	local L_420_ = entity.get_prop(L_412_, "m_bInBombZone")
	local L_421_ = entity_has_c4(L_412_)
	local L_422_ = L_420_ ~= 0 and L_418_ == 2 and L_421_ and not ui.get(L_40_.other.bombsiteefix)
	local L_423_, L_424_, L_425_ = client.eye_position()
	local L_426_, L_427_ = client.camera_angles()
	local L_428_ = math.sin(math.rad(L_426_))
	local L_429_ = math.cos(math.rad(L_426_))
	local L_430_ = math.sin(math.rad(L_427_))
	local L_431_ = math.cos(math.rad(L_427_))
	local L_432_ = {
		L_429_ * L_431_,
		L_429_ * L_430_,
		- L_428_
	}
	local L_433_, L_434_ = client.trace_line(L_412_, L_423_, L_424_, L_425_, L_423_ + L_432_[1] * 8192, L_424_ + L_432_[2] * 8192, L_425_ + L_432_[3] * 8192)
	local L_435_ = true;
	if L_434_ ~= nil then
		for L_439_forvar0 = 0, # classnames do
			if entity.get_classname(L_434_) == classnames[L_439_forvar0] then
				L_435_ = false
			end
		end
	end;
	if not L_435_ and not L_422_ and not L_419_ then
		L_411_arg0.in_use = 0
	end
end)
local L_59_ = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local L_60_ = {}
local L_61_ = {
	records = {},
	get_max_desync = function(L_440_arg0)
		local L_441_ = text_clamp(L_440_arg0.feet_speed_forwards_or_sideways, 0, 1)
		local L_442_ = (L_440_arg0.stop_to_full_running_fraction * - 0.3 - 0.2) * L_441_ + 1;
		local L_443_ = L_440_arg0.duck_amount;
		if L_443_ > 0 then
			local L_444_ = L_443_ * L_441_;
			L_442_ = L_442_ + L_444_ * (0.5 - L_442_)
		end;
		return text_clamp(L_442_, .5, 1)
	end,
	normalize_pitch = function(L_445_arg0)
		if x == nil then
			return math.clamp(-89, 89)
		end
	end,
	get_simtime = function(L_446_arg0)
		local L_447_ = L_59_(L_446_arg0)
		if L_447_ then
			return entity_get_prop(L_446_arg0, "m_flSimulationTime"), L_8_.cast("float*", L_8_.cast("uintptr_t", L_447_) + 620)[0]
		else
			return 0
		end
	end,
	get_animstate = function(L_448_arg0)
		local L_449_ = L_59_(L_448_arg0)
		if L_449_ then
			return L_8_.cast(L_8_.typeof"struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int	 last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **", L_8_.cast("char*", L_8_.cast("void***", L_449_)) + 39264)[0]
		end
	end
}
local L_62_ = function()
	if ui.get(ragebot_tab.resolver) then
		if not entity.is_alive(local_player) then
			return
		end;
		client.update_player_list()
		for L_450_forvar0 = 1, # L_60_ do
			local L_451_ = L_60_[L_450_forvar0]
			if entity.is_enemy(L_451_) then
				local L_452_, L_453_ = L_61_.get_simtime(L_451_)
				L_452_, L_453_ = toticks(L_452_), toticks(L_453_)
				if not L_61_.records[L_451_] then
					L_61_.records[L_451_] = {}
				end;
				local L_454_ = L_61_.records[L_451_]
				L_454_[L_452_] = {
					pose = entity.get_prop(L_451_, "m_flPoseParameter", 1) * 120 - 60,
					eye = select(2, entity.get_prop(L_451_, "m_angEyeAngles"))
				}
				local L_455_;
				local L_456_ = (L_454_[L_453_] and L_454_[L_452_]) ~= nil;
				if L_456_ then
					local L_457_ = L_61_.get_animstate(L_451_)
					local L_458_ = L_61_.get_max_desync(L_457_)
					if L_454_[L_453_] and L_454_[L_452_] and normalize_pitch < 0.85 and L_452_ - L_453_ < 2 then
						local L_459_ = text_clamp(normalize_pitch(L_457_.last_origin - L_454_[L_452_].eye), -89, 89)
						L_455_ = L_454_[L_453_] and L_454_[L_453_].pose * L_459_ or nil
					end;
					if L_455_ then
						plist.set(L_451_, "Force pitch value", L_455_)
					end
				end;
				plist.set(L_451_, "Force pitch", L_455_ ~= nil)
				plist.set(L_451_, "Correction active", true)
			else
				plist.set(L_450_forvar0, "Force pitch", false)
				L_61_.records = {}
			end
		end
	end
end;
client.set_event_callback("net_update_end", function()
	if ui.get(ragebot_tab.resolver) then
		L_62_()
	end
end)
local function L_63_func(L_460_arg0)
	local L_461_, L_462_ = entity.get_prop(L_460_arg0, "m_vecVelocity")
	return math.sqrt(L_461_ ^ 2 + L_462_ ^ 2)
end;
local L_64_ = {}
local L_65_ = {}
local function L_66_func(L_463_arg0)
	local L_464_ = L_14_(L_463_arg0)
	local L_465_ = L_8_.cast("float*", L_8_.cast("uintptr_t", L_464_) + 620)[0]
	local L_466_ = entity.get_prop(L_463_arg0, "m_flSimulationTime")
	if L_466_ - L_465_ == 0 then
		return L_65_[L_463_arg0]
	end;
	local L_467_ = L_9_(entity.get_origin(L_463_arg0))
	L_64_[L_463_arg0] = L_64_[L_463_arg0] or L_467_;
	if entity.is_dormant(L_463_arg0) or not entity.is_alive(L_463_arg0) then
		return false
	end;
	if L_466_ < L_465_ then
		return true
	end;
	if (L_467_ - L_64_[L_463_arg0]):lengthsqr() > 4096 then
		L_64_[L_463_arg0] = L_467_;
		return true
	end;
	L_64_[L_463_arg0] = L_467_;
	return false
end;
local function L_67_func(L_468_arg0, L_469_arg1, L_470_arg2, L_471_arg3, L_472_arg4)
	local L_473_, L_474_, L_475_ = entity.get_prop(L_468_arg0, "m_vecVelocity")
	local L_476_ = L_470_arg2 + globals.tickinterval() * L_473_ * L_469_arg1;
	local L_477_ = L_471_arg3 + globals.tickinterval() * L_474_ * L_469_arg1;
	local L_478_ = L_472_arg4 + globals.tickinterval() * L_475_ * L_469_arg1;
	return L_476_, L_477_, L_478_
end;
local function L_68_func(L_479_arg0, L_480_arg1, L_481_arg2)
	local L_482_ = entity.get_local_player()
	if not entity.is_alive(L_482_) then
		return false
	end;
	local L_483_, L_484_, L_485_ = entity.get_prop(L_482_, "m_vecOrigin")
	if not L_483_ or not L_484_ or not L_485_ then
		print("Failed to get local player position")
		return false
	end;
	local L_486_ = entity.get_prop(L_482_, "m_vecViewOffset[2]")
	if not L_486_ then
		print("Failed to get local player view offset")
		return false
	end;
	L_485_ = L_485_ + L_486_;
	local L_487_, L_488_ = client.trace_line(L_482_, L_483_, L_484_, L_485_, L_479_arg0, L_480_arg1, L_481_arg2)
	if L_487_ == nil then
		print("Trace line failed")
		return false
	end;
	return L_487_ == 1
end;
local function L_69_func(L_489_arg0, L_490_arg1, L_491_arg2, L_492_arg3, L_493_arg4, L_494_arg5, L_495_arg6, L_496_arg7, L_497_arg8)
	local L_498_ = L_9_(L_489_arg0, L_490_arg1, 0)
	local L_499_ = L_9_(L_491_arg2, L_492_arg3, 0)
	local L_500_ = ({
		L_498_:to(L_499_):angles()
	})[2]
	for L_501_forvar0 = 1, L_497_arg8 do
		renderer.circle_outline(L_489_arg0, L_490_arg1, L_493_arg4, L_494_arg5, L_495_arg6, L_497_arg8 - L_501_forvar0, L_501_forvar0, L_500_ + 90, 0.5, 1)
		renderer.circle_outline(L_491_arg2, L_492_arg3, L_493_arg4, L_494_arg5, L_495_arg6, L_497_arg8 - L_501_forvar0, L_501_forvar0, L_500_ - 90, 0.5, 1)
		local L_502_ = L_9_(math.cos(math.rad(L_500_ + 90)), math.sin(math.rad(L_500_ + 90)), 0):scaled(L_501_forvar0 * 0.95)
		local L_503_ = L_9_(math.cos(math.rad(L_500_ - 90)), math.sin(math.rad(L_500_ - 90)), 0):scaled(L_501_forvar0 * 0.95)
		local L_504_ = L_502_ + L_498_;
		local L_505_ = L_502_ + L_499_;
		local L_506_ = L_503_ + L_498_;
		local L_507_ = L_503_ + L_499_;
		L_18_(L_504_.x, L_504_.y, L_505_.x, L_505_.y, L_493_arg4, L_494_arg5, L_495_arg6, L_497_arg8 - L_501_forvar0)
		L_18_(L_506_.x, L_506_.y, L_507_.x, L_507_.y, L_493_arg4, L_494_arg5, L_495_arg6, L_497_arg8 - L_501_forvar0)
	end;
	L_18_(L_489_arg0, L_490_arg1, L_491_arg2, L_492_arg3, L_493_arg4, L_494_arg5, L_495_arg6, L_496_arg7)
end;
local function L_70_func(L_508_arg0, L_509_arg1, L_510_arg2, L_511_arg3, L_512_arg4, L_513_arg5, L_514_arg6, L_515_arg7, L_516_arg8)
	local L_517_ = {
		{
			L_508_arg0 - L_511_arg3 / 2,
			L_509_arg1 - L_511_arg3 / 2,
			L_510_arg2
		},
		{
			L_508_arg0 + L_511_arg3 / 2,
			L_509_arg1 - L_511_arg3 / 2,
			L_510_arg2
		},
		{
			L_508_arg0 + L_511_arg3 / 2,
			L_509_arg1 + L_511_arg3 / 2,
			L_510_arg2
		},
		{
			L_508_arg0 - L_511_arg3 / 2,
			L_509_arg1 + L_511_arg3 / 2,
			L_510_arg2
		},
		{
			L_508_arg0 - L_511_arg3 / 2,
			L_509_arg1 - L_511_arg3 / 2,
			L_510_arg2 + L_512_arg4
		},
		{
			L_508_arg0 + L_511_arg3 / 2,
			L_509_arg1 - L_511_arg3 / 2,
			L_510_arg2 + L_512_arg4
		},
		{
			L_508_arg0 + L_511_arg3 / 2,
			L_509_arg1 + L_511_arg3 / 2,
			L_510_arg2 + L_512_arg4
		},
		{
			L_508_arg0 - L_511_arg3 / 2,
			L_509_arg1 + L_511_arg3 / 2,
			L_510_arg2 + L_512_arg4
		}
	}
	local L_518_ = {
		{
			1,
			2
		},
		{
			2,
			3
		},
		{
			3,
			4
		},
		{
			4,
			1
		},
		{
			5,
			6
		},
		{
			6,
			7
		},
		{
			7,
			8
		},
		{
			8,
			5
		},
		{
			1,
			5
		},
		{
			2,
			6
		},
		{
			3,
			7
		},
		{
			4,
			8
		}
	}
	for L_519_forvar0, L_520_forvar1 in ipairs(L_518_) do
		local L_521_, L_522_ = renderer.world_to_screen(L_517_[L_520_forvar1[1]][1], L_517_[L_520_forvar1[1]][2], L_517_[L_520_forvar1[1]][3])
		local L_523_, L_524_ = renderer.world_to_screen(L_517_[L_520_forvar1[2]][1], L_517_[L_520_forvar1[2]][2], L_517_[L_520_forvar1[2]][3])
		if L_521_ and L_522_ and L_523_ and L_524_ then
			L_69_func(L_521_, L_522_, L_523_, L_524_, L_513_arg5, L_514_arg6, L_515_arg7, L_516_arg8, 0)
		end
	end
end;
local L_71_ = {
	x = 0,
	y = 0,
	z = 0
}
local function L_72_func()
	if ui.get(ragebot_tab.resolver_lc) then
		local L_525_ = 10;
		local L_526_ = entity.get_local_player()
		if L_526_ == nil or not entity.is_alive(L_526_) then
			return
		end;
		local L_527_ = client.current_threat()
		if not L_527_ or not entity.is_alive(L_527_) or entity.is_dormant(L_527_) then
			return
		end;
		local L_528_, L_529_, L_530_ = entity.get_prop(L_527_, "m_vecOrigin")
		if L_528_ == nil or L_529_ == nil or L_530_ == nil then
			return
		end;
		if L_63_func(L_527_) < 20 then
			return
		end;
		if L_66_func(L_527_) then
			return
		end;
		local L_531_, L_532_, L_533_ = L_67_func(L_527_, L_525_, L_528_, L_529_, L_530_)
		local L_534_ = globals.framecount()
		smoothing_factor = 1 / L_534_;
		L_71_.x = lerp(L_531_, L_71_.x, smoothing_factor)
		L_71_.y = lerp(L_532_, L_71_.y, smoothing_factor)
		L_71_.z = lerp(L_533_, L_71_.z, smoothing_factor)
		local L_535_ = 20;
		local L_536_ = 72;
		if L_68_func(L_71_.x, L_71_.y, L_71_.z) then
			r, g, b, a = 255, 255, 255, 200
		else
			r, g, b, a = 255, 255, 255, 200
		end;
		L_70_func(L_71_.x, L_71_.y, L_71_.z, L_535_, L_536_, r, g, b, a)
		local L_537_, L_538_ = renderer.world_to_screen(L_528_, L_529_, L_530_)
		local L_539_, L_540_ = renderer.world_to_screen(L_71_.x, L_71_.y, L_71_.z)
		if L_537_ and L_538_ and L_539_ and L_540_ then
			L_69_func(L_537_, L_538_, L_539_, L_540_, r, g, b, a, 0)
		end
	end
end;
client.set_event_callback("net_update_end", function()
	if ui.get(ragebot_tab.resolver_lc) then
		for L_541_forvar0, L_542_forvar1 in pairs(entity.get_players()) do
			L_65_[L_542_forvar1] = L_66_func(L_542_forvar1)
		end
	end
end)
client.set_event_callback("paint", function()
	if ui.get(ragebot_tab.resolver_lc) then
		L_72_func()
	end
end)
local L_73_ = function(L_543_arg0, L_544_arg1)
	for L_545_forvar0 = 1, # L_543_arg0 do
		if L_543_arg0[L_545_forvar0] == L_544_arg1 then
			return true
		end
	end;
	return false
end;
local function L_74_func(L_546_arg0, L_547_arg1, L_548_arg2, L_549_arg3, L_550_arg4)
	local L_551_, L_552_, L_553_ = entity.get_prop(L_546_arg0, "m_vecVelocity")
	local L_554_ = L_548_arg2 + globals.tickinterval() * L_551_ * L_547_arg1;
	local L_555_ = L_549_arg3 + globals.tickinterval() * L_552_ * L_547_arg1;
	local L_556_ = L_550_arg4 + globals.tickinterval() * L_553_ * L_547_arg1;
	return L_554_, L_555_, L_556_
end;
local L_75_ = function(L_557_arg0)
	return L_5_.band(entity.get_prop(L_557_arg0, "m_fFlags"), 1) == 0
end;
local L_76_, L_77_, L_78_, L_79_ = 255, 255, 255, 255;
local L_80_ = L_9_(0, 0, 0)
local L_81_ = L_9_(0, 0, 0)
local L_82_ = ui.reference("rage", "aimbot", "Minimum damage")
local L_83_, L_84_, L_85_ = ui.reference("rage", "aimbot", "Minimum damage override")
local L_86_ = {
	ui.reference("RAGE", "Other", "Quick peek assist")
}
local L_87_ = {
	ui.reference("RAGE", "Other", "Quick peek assist mode")
}
local L_88_ = 0;
local function L_89_func()
	if ui.get(L_83_) and ui.get(L_84_) then
		L_88_ = ui.get(L_85_)
	else
		L_88_ = ui.get(L_82_)
	end
end;
local function L_90_func()
	local L_558_ = entity.get_local_player()
	if L_558_ == nil then
		return
	end;
	local L_559_, L_560_ = client.camera_angles()
	L_80_ = L_9_(L_559_, L_560_, 0)
	local L_561_, L_562_, L_563_ = entity.hitbox_position(L_558_, 3)
	L_81_ = L_9_(L_561_, L_562_, L_563_)
end;
local L_91_ = false;
local L_92_ = L_81_;
local function L_93_func(L_564_arg0, L_565_arg1, L_566_arg2, L_567_arg3, L_568_arg4, L_569_arg5)
	local L_570_, L_571_, L_572_;
	local L_573_, L_574_, L_575_;
	if L_567_arg3 == nil then
		L_573_, L_574_, L_575_ = L_564_arg0, L_565_arg1, L_566_arg2;
		L_570_, L_571_, L_572_ = client.eye_position()
		if L_570_ == nil then
			return
		end
	else
		L_570_, L_571_, L_572_ = L_564_arg0, L_565_arg1, L_566_arg2;
		L_573_, L_574_, L_575_ = L_567_arg3, L_568_arg4, L_569_arg5
	end;
	local L_576_, L_577_, L_578_ = L_573_ - L_570_, L_574_ - L_571_, L_575_ - L_572_;
	if L_576_ == 0 and L_577_ == 0 then
		return L_578_ > 0 and 270 or 90, 0
	else
		local L_579_ = math.deg(math.atan2(L_577_, L_576_))
		local L_580_ = math.sqrt(L_576_ * L_576_ + L_577_ * L_577_)
		local L_581_ = math.deg(math.atan2(- L_578_, L_580_))
		return L_581_, L_579_
	end
end;
local function L_94_func(L_582_arg0, L_583_arg1, L_584_arg2)
	local L_585_ = entity.get_local_player()
	local L_586_ = L_584_arg2;
	local L_587_ = L_80_;
	local L_588_ = L_586_ + L_9_(0, 0, 0):init_from_angles(0, 90 + L_587_.y + L_582_arg0, 0) * L_583_arg1;
	return L_588_
end;
local function L_95_func(L_589_arg0, L_590_arg1, L_591_arg2)
	local L_592_ = {}
	local L_593_ = entity.get_local_player()
	local L_594_ = L_591_arg2;
	L_590_arg1 = math.max(2, math.floor(L_590_arg1))
	local L_595_ = 360 / L_590_arg1;
	for L_596_forvar0 = 0, 360, L_595_ do
		local L_597_ = L_94_func(L_596_forvar0, L_589_arg0, L_594_)
		table.insert(L_592_, L_597_)
	end;
	return L_592_
end;
local function L_96_func(L_598_arg0, L_599_arg1, L_600_arg2, L_601_arg3)
	local L_602_ = L_9_(L_598_arg0.x, L_598_arg0.y, 0)
	local L_603_ = L_9_(L_599_arg1.x, L_599_arg1.y, 0)
	local L_604_ = L_9_(L_601_arg3.x, L_601_arg3.y, 0)
	local L_605_ = (L_602_ - L_603_) / L_600_arg2;
	local L_606_ = (L_604_ - L_603_):length()
	local L_607_ = {}
	for L_608_forvar0 = 1, L_600_arg2 do
		local L_609_ = L_605_ * L_608_forvar0;
		if L_609_:length() < L_606_ then
			table.insert(L_607_, L_599_arg1 + L_609_)
		end
	end;
	return L_607_
end;
local function L_97_func(L_610_arg0, L_611_arg1)
	local L_612_ = {}
	local L_613_ = entity.get_players()
	for L_617_forvar0, L_618_forvar1 in ipairs(L_613_) do
		if not entity.is_enemy(L_618_forvar1) then
			table.insert(L_612_, L_618_forvar1)
		end
	end;
	local L_614_ = entity.get_local_player()
	local L_615_ = L_16_.line(L_610_arg0, L_611_arg1, {
		skip = L_612_
	})
	local L_616_ = L_615_.end_pos;
	return L_616_, L_615_.fraction
end;
local function L_98_func(L_619_arg0, L_620_arg1, L_621_arg2, L_622_arg3, L_623_arg4, L_624_arg5, L_625_arg6, L_626_arg7, L_627_arg8, L_628_arg9, L_629_arg10, L_630_arg11, L_631_arg12, L_632_arg13, L_633_arg14, L_634_arg15, L_635_arg16)
	local L_636_ = L_627_arg8 ~= nil and L_627_arg8 or 3;
	local L_637_ = L_628_arg9 ~= nil and L_628_arg9 or 1;
	local L_638_ = L_629_arg10 ~= nil and L_629_arg10 or false;
	local L_639_ = L_630_arg11 ~= nil and L_630_arg11 or 0;
	local L_640_ = L_631_arg12 ~= nil and L_631_arg12 or 1;
	local L_641_, L_642_;
	if L_635_arg16 then
		L_641_, L_642_ = renderer.world_to_screen(L_619_arg0, L_620_arg1, L_621_arg2)
	end;
	local L_643_, L_644_;
	for L_645_forvar0 = L_639_, L_640_ * 360, L_636_ do
		local L_646_ = math.rad(L_645_forvar0)
		local L_647_, L_648_, L_649_ = L_622_arg3 * math.cos(L_646_) + L_619_arg0, L_622_arg3 * math.sin(L_646_) + L_620_arg1, L_621_arg2;
		local L_650_, L_651_ = renderer.world_to_screen(L_647_, L_648_, L_649_)
		if L_650_ ~= nil and L_643_ ~= nil then
			if L_635_arg16 and L_641_ ~= nil then
				renderer.triangle(L_650_, L_651_, L_643_, L_644_, L_641_, L_642_, L_632_arg13, L_633_arg14, L_634_arg15, L_635_arg16)
			end;
			for L_652_forvar0 = 1, L_637_ do
				local L_653_ = L_652_forvar0 - 1;
				renderer.line(L_650_, L_651_ - L_653_, L_643_, L_644_ - L_653_, L_623_arg4, L_624_arg5, L_625_arg6, L_626_arg7)
				renderer.line(L_650_ - 1, L_651_, L_643_ - L_653_, L_644_, L_623_arg4, L_624_arg5, L_625_arg6, L_626_arg7)
			end;
			if L_638_ then
				local L_654_ = L_626_arg7 / 255 * 160;
				renderer.line(L_650_, L_651_ - L_637_, L_643_, L_644_ - L_637_, 16, 16, 16, L_654_)
				renderer.line(L_650_, L_651_ + 1, L_643_, L_644_ + 1, 16, 16, 16, L_654_)
			end
		end;
		L_643_, L_644_ = L_650_, L_651_
	end
end;
local function L_99_func(L_655_arg0, L_656_arg1, L_657_arg2, L_658_arg3, L_659_arg4)
	local L_660_ = entity.get_local_player()
	local L_661_, L_662_, L_663_ = entity.get_origin(L_660_)
	local L_664_ = L_9_(L_659_arg4.x, L_659_arg4.y, L_663_ + 60)
	local L_665_ = L_9_(L_658_arg3.x, L_658_arg3.y, L_663_ + 60)
	local L_666_, L_667_ = L_97_func(L_659_arg4, L_658_arg3)
	local L_668_, L_669_ = L_97_func(L_664_, L_665_)
	local L_670_ = L_9_(L_668_.x, L_668_.y, L_658_arg3.z)
	if L_655_arg0 then
		local L_671_, L_672_ = renderer.world_to_screen(L_668_.x + 10, L_668_.y + 10, L_668_.z - 59)
		local L_673_, L_674_ = renderer.world_to_screen(L_664_.x + 10, L_664_.y + 10, L_664_.z - 59)
		renderer.line(L_671_, L_672_, L_673_, L_674_, L_76_, L_77_, L_78_, 100)
	end;
	if L_657_arg2 then
		local L_675_ = tostring(math.floor(L_667_) * 100)
		local L_676_, L_677_ = renderer.world_to_screen(L_665_.x, L_665_.y, L_665_.z)
		renderer.text(L_676_, L_677_, L_76_, L_77_, L_78_, L_79_, "c", 0, L_675_)
	end;
	return L_670_
end;
local function L_100_func(L_678_arg0, L_679_arg1, L_680_arg2, L_681_arg3)
	local L_682_ = {}
	local L_683_ = entity.get_local_player()
	local L_684_ = L_681_arg3;
	local L_685_ = L_95_func(30, 2, L_684_)
	for L_686_forvar0, L_687_forvar1 in pairs(L_685_) do
		local L_688_ = L_685_[L_686_forvar0 + 1]
		L_688_ = L_688_ == nil and L_685_[1] or L_688_;
		local L_689_ = L_9_((L_688_.x + L_687_forvar1.x) / 2, (L_688_.y + L_687_forvar1.y) / 2, L_687_forvar1.z)
		local L_690_ = L_99_func(L_678_arg0, L_679_arg1, L_680_arg2, L_689_, L_684_)
		table.insert(L_682_, {
			endpos = L_690_,
			ideal = L_689_
		})
		local L_691_ = L_99_func(L_678_arg0, L_679_arg1, L_680_arg2, L_687_forvar1, L_684_)
		table.insert(L_682_, {
			endpos = L_691_,
			ideal = L_687_forvar1
		})
	end;
	return L_682_
end;
local function L_101_func(L_692_arg0, L_693_arg1, L_694_arg2, L_695_arg3)
	local L_696_ = entity.get_local_player()
	local L_697_ = L_100_func(L_692_arg0, L_693_arg1, debug_fraction, L_695_arg3)
	local L_698_, L_699_, L_700_ = entity.get_origin(L_696_)
	local L_701_ = {}
	for L_702_forvar0, L_703_forvar1 in pairs(L_697_) do
		local L_704_ = L_703_forvar1.ideal;
		local L_705_ = L_703_forvar1.endpos;
		table.insert(L_701_, L_705_)
		if L_693_arg1 then
			L_70_func(L_705_.x, L_705_.y, L_705_.z - 40, 23, 50, 255, 255, 255, sway())
		end;
		if L_694_arg2 ~= 1 then
			for L_706_forvar0, L_707_forvar1 in pairs(L_96_func(L_704_, L_695_arg3, L_694_arg2, L_705_)) do
				table.insert(L_701_, L_707_forvar1)
				if L_693_arg1 then
					L_70_func(L_707_forvar1.x, L_707_forvar1.y, L_705_.z - 40, 23, 50, 255, 255, 255, sway())
				end
			end
		end
	end;
	return L_701_
end;
local function L_102_func()
	local L_708_ = {}
	table.insert(L_708_, 0)
	table.insert(L_708_, 1)
	table.insert(L_708_, 4)
	table.insert(L_708_, 5)
	table.insert(L_708_, 6)
	table.insert(L_708_, 2)
	table.insert(L_708_, 3)
	table.insert(L_708_, 13)
	table.insert(L_708_, 14)
	table.insert(L_708_, 15)
	table.insert(L_708_, 16)
	table.insert(L_708_, 17)
	table.insert(L_708_, 18)
	table.insert(L_708_, 7)
	table.insert(L_708_, 8)
	table.insert(L_708_, 9)
	table.insert(L_708_, 10)
	table.insert(L_708_, 11)
	table.insert(L_708_, 12)
	return L_708_
end;
local function L_103_func()
	return ui.get(L_86_[1]) and ui.get(L_86_[2])
end;
local function L_104_func()
	local L_709_ = 0;
	local L_710_ = entity.get_local_player()
	if L_710_ == nil then
		return
	end;
	if entity.is_alive(L_710_) == false then
		return
	end;
	if not ui.get(L_86_[2]) then
		return
	end;
	local L_711_, L_712_, L_713_ = entity.hitbox_position(L_710_, 3)
	local L_714_ = L_9_(L_711_, L_712_, L_713_)
	local L_715_, L_716_ = client.camera_angles()
	if not ui.get(ragebot_tab.aipeek) then
		return
	end;
	local L_717_ = L_101_func(1, 1, 1, L_81_)
	local L_718_ = L_102_func()
	local L_719_ = {}
	local L_720_ = client.current_threat()
	if L_720_ == nil or entity.is_dormant(L_720_) then
		L_92_ = nil;
		L_91_ = false;
		return
	end;
	for L_724_forvar0, L_725_forvar1 in pairs(L_717_) do
		for L_726_forvar0, L_727_forvar1 in pairs(L_718_) do
			local L_728_, L_729_, L_730_ = entity.hitbox_position(L_720_, L_727_forvar1)
			local L_731_, L_732_, L_733_ = L_74_func(L_720_, L_709_, L_728_, L_729_, L_730_)
			local L_734_ = L_9_(L_731_, L_732_, L_733_)
			local L_735_, L_736_ = client.trace_bullet(L_710_, L_725_forvar1.x, L_725_forvar1.y, L_725_forvar1.z + 60, L_734_.x, L_734_.y, L_734_.z)
			if L_736_ > math.min(L_88_, entity.get_prop(L_720_, "m_iHealth")) then
				table.insert(L_719_, {
					TARGET = L_720_,
					damage = L_736_,
					vec = L_725_forvar1,
					enemy_vec = L_734_
				})
			end
		end;
		if # L_719_ >= 5 then
			break
		end
	end;
	table.sort(L_719_, function(L_737_arg0, L_738_arg1)
		return L_737_arg0.damage > L_738_arg1.damage
	end)
	for L_739_forvar0, L_740_forvar1 in pairs(L_719_) do
		if entity.is_alive(L_740_forvar1.TARGET) == false then
			table.remove(L_719_, L_739_forvar0)
		end
	end;
	local L_721_, L_722_, L_723_ = entity.get_origin(L_710_)
	if # L_719_ >= 1 then
		local L_741_ = L_719_[1]
		local L_742_ = L_741_.vec;
		local L_743_ = L_741_.damage;
		local L_744_ = L_741_.enemy_vec;
		local L_745_ = L_9_(L_742_.x, L_742_.y, L_723_ + 60)
		local L_746_, L_747_ = renderer.world_to_screen(L_745_.x, L_745_.y, L_745_.z)
		if L_747_ ~= nil then
			L_747_ = L_747_ - 12
		end;
		local L_748_ = tostring(math.floor(L_743_))
		renderer.text(L_746_, L_747_, L_76_, L_77_, L_78_, L_79_, 0, L_748_)
		L_91_ = true;
		L_92_ = L_742_
	else
		L_92_ = nil;
		L_91_ = false
	end
end;
local L_105_ = false;
local function L_106_func()
	if not ui.get(ragebot_tab.aipeek) then
		return
	end;
	L_105_ = false
end;
local function L_107_func(L_749_arg0, L_750_arg1)
	local L_751_ = entity.get_local_player()
	local L_752_, L_753_, L_754_ = entity.get_prop(L_751_, "m_vecAbsOrigin")
	local L_755_, L_756_ = L_93_func(L_752_, L_753_, L_754_, L_750_arg1.x, L_750_arg1.y, L_750_arg1.z)
	L_749_arg0.in_forward = 1;
	L_749_arg0.in_back = 0;
	L_749_arg0.in_moveleft = 0;
	L_749_arg0.in_moveright = 0;
	L_749_arg0.in_speed = 0;
	L_749_arg0.forwardmove = 800;
	L_749_arg0.sidemove = 0;
	L_749_arg0.move_yaw = L_756_
end;
local L_108_, L_109_, L_110_, L_111_ = 255, 255, 255, 255;
local function L_112_func(L_757_arg0)
	local L_758_ = entity.get_local_player()
	if L_758_ == nil then
		return
	end;
	if not ui.get(ragebot_tab.aipeek) then
		return
	end;
	if not entity.is_alive(L_758_) then
		return
	end;
	local L_759_ = L_757_arg0.in_forward == 1;
	local L_760_ = L_757_arg0.in_back == 1;
	local L_761_ = L_757_arg0.in_moveleft == 1;
	local L_762_ = L_757_arg0.in_moveright == 1;
	if ui.get(L_86_[2]) then
		local L_763_ = entity.get_player_weapon(L_758_)
		if L_763_ == nil then
			return
		end;
		local L_764_ = L_75_(L_758_)
		local L_765_ = globals.curtime()
		local L_766_ = entity.get_prop(L_758_, "m_flNextAttack") <= L_765_ and entity.get_prop(L_763_, "m_flNextPrimaryAttack") <= L_765_;
		local L_767_, L_768_, L_769_ = entity.get_origin(L_758_)
		if math.abs(L_767_ - L_81_.x) <= 10 then
			L_105_ = true
		end;
		if L_766_ == false then
			L_105_ = false
		end;
		L_108_, L_109_, L_110_, L_111_ = 255, 255, 0, 255;
		if L_91_ and L_105_ and L_764_ == false and L_92_ ~= nil then
			L_107_func(L_757_arg0, L_92_)
			L_108_, L_109_, L_110_, L_111_ = 0, 255, 0, 255
		elseif L_105_ == false and L_764_ == false and L_759_ == false and L_760_ == false and L_761_ == false and L_762_ == false then
			L_107_func(L_757_arg0, L_81_)
		end
	else
		L_108_, L_109_, L_110_, L_111_ = 0, 255, 0, 255
	end
end;
L_90_func()
client.set_event_callback("paint", function()
	if not ui.get(ragebot_tab.aipeek) then
		return
	end;
	L_89_func()
	L_104_func()
end)
client.set_event_callback("setup_command", L_112_func)
client.set_event_callback("run_command", function()
	local L_770_ = entity.get_local_player()
	if L_770_ == nil then
		return
	end;
	if entity.is_alive(L_770_) == false then
		return
	end;
	local L_771_, L_772_, L_773_ = entity.hitbox_position(L_770_, 3)
	local L_774_ = L_9_(L_771_, L_772_, L_773_)
	local L_775_, L_776_ = client.camera_angles()
	if not ui.get(L_86_[2]) then
		L_80_ = L_9_(L_775_, L_776_, 0)
	end;
	if not ui.get(L_86_[2]) then
		L_81_ = L_774_
	end
end)
client.set_event_callback("aim_fire", L_106_func)
client.set_event_callback("predict_command", function(L_777_arg0)
	local L_778_ = entity.get_local_player()
	if L_778_ == nil then
		return
	end;
	local L_779_ = entity.get_prop(L_778_, "m_fFlags")
	local L_780_ = L_9_(entity.get_prop(L_778_, "m_vecVelocity"))
end)
client.set_event_callback("setup_command", function(L_781_arg0)
	if not ui.get(keybinds_tab.airstop) then
		return
	end;
	local L_782_ = entity.get_local_player()
	local L_783_ = client.current_threat()
	if L_782_ == nil or L_783_ == nil then
		return
	end;
	airstop = false;
	local L_784_ = entity.get_player_weapon(L_782_)
	if L_784_ == nil then
		return
	end;
	local L_785_ = entity.get_classname(L_784_)
	if L_785_ ~= "CWeaponSSG08" then
		return
	end;
	if not L_24_func(L_782_) or not L_25_func(L_784_) then
		return
	end;
	local L_786_ = L_13_(L_784_)
	local L_787_ = L_9_(entity.get_origin(L_782_))
	local L_788_ = L_9_(entity.get_origin(L_783_))
	local L_789_ = 1;
	local L_790_, L_791_ = client.trace_bullet(L_782_, L_787_.x, L_787_.y, 0, L_788_.x, L_788_.y, 0)
	local L_792_ = entity.get_prop(L_783_, "m_iHealth")
	if L_791_ < L_789_ then
		return
	end;
	if not L_57_func(L_783_) then
		return
	end;
	if L_52_:is_on_ground() then
		return
	end;
	airstop = true;
	ui.set(L_37_.antiaim.slow_motion[1], true)
	L_29_func(L_781_arg0, 0)
end)
local L_113_ = {
	" ~ izanasense ",
	" ~ izanasense ",
	" ~ zanasense",
	" ~ anasense",
	" ~ nasense",
	" ~ asense",
	" ~ sense",
	" ~ izanasense ",
	" ~ izanasense "
}
local L_114_ = 1;
local L_115_ = 0;
local function L_116_func()
	local L_793_ = L_113_[L_114_]
	if L_114_ < 9 then
		L_114_ = L_114_ + 1
	else
		L_114_ = 1
	end;
	return L_793_
end;
client.set_event_callback("paint", function()
	if not ui.get(visuals_tab.clantag) then
		return
	end;
	if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then
		return
	end;
	if L_115_ + 0.3 < globals.curtime() then
		client.set_clan_tag(L_116_func())
		L_115_ = globals.curtime()
	elseif L_115_ > globals.curtime() then
		L_115_ = globals.curtime()
	end
end)
local L_117_ = {}
L_117_.phrases = {
	english = {
		{
			"𝙹𝚄𝚂𝚃 𝙶𝙴𝚃 🄱🄾🅄🄽🅃🅈 𝚈𝙾𝚄 𝚂𝚃𝚄𝙿𝙸𝙳 𝙵𝙰𝙶"
		},
		{
			"𝚃𝙷𝙰𝙽𝙺 𝚈𝙾𝚄 𝙳𝙰𝙳𝙳𝚈 𝕄𝕆ℝℕ𝕀ℕ𝔾𝕊𝕋𝔸ℝ ℂℕ 𝙵𝙾𝚁 𝙼𝙰𝙺𝙸𝙽𝙶 🄱🄾🅄🄽🅃🅈"
		},
		{
			"𝚈𝙾𝚄𝚁 𝙲𝙷𝙴𝙰𝚃 𝙸𝚂 𝙾𝙺, 𝙸𝚃 𝙹𝚄𝚂𝚃 𝙼𝚈 𝙰𝙰 𝙸𝚂 𝚄𝙽𝙷𝙸𝚃𝚃𝙰𝙱𝙻𝙴"
		},
		{
			"𝙸𝙼 𝚂𝙾𝚁𝚁𝚈"
		},
		{
			"(◣_◢)(◣_◢)(◣_◢)🄱🄾🅄🄽🅃🅈(◣_◢)(◣_◢)(◣_◢)"
		}
	},
	russian = {
		{
			"костыль сьебал в страхе"
		},
		{
			"танки онлайн тестовый сервер"
		},
		{
			"на банане подскользнулся пидарас"
		},
		{
			"я твоему деду армяшке монобровь выгрыз"
		},
		{
			"пробежка не удалась, пятки не засверкали"
		},
		{
			"удачи на банановых островах!"
		},
		{
			"а правда, что твой отец космонавт?"
		},
		{
			"это ты называешь анти аимы ублюдок"
		},
		{
			"проиграл мать 1в1, возможно навсегда..."
		},
		{
			"Ебень ебанная потренеруйся что ли нахуй уже"
		},
		{
			"танки онлайн тестовый сервер"
		},
		{
			"ты убивал меня, смеялся, но.. был поставлен на колени"
		}
	},
	ukrainian = {
		{
			"милиця в страху"
		},
		{
			"Сервер онлайн-тестування Tanki"
		},
		{
			"послизнувся на банані"
		},
		{
			"Я вигриз твій дідусь армійську унірландську"
		},
		{
			"Біг не вдався, п'яти не виблискували"
		},
		{
			"Удачі на бананових островах!"
		},
		{
			"Чи правда, що твій батько - космонавт?"
		},
		{
			"Це те, що ви називаєте анти аймі покидьком"
		},
		{
			"Втратила матір 1 на 1, можливо, назавжди..."
		},
		{
			"До біса тебе, тренуй вже до біса"
		},
		{
			"Сервер онлайн-тестування Tanki"
		},
		{
			"Ти мене вбив, сміявся, але... був поставлений на коліна"
		}
	},
	dutch = {
		{
			"De kruk in angst"
		},
		{
			"Tanki Online Test Server"
		},
		{
			"een gleed uit op een banaan"
		},
		{
			"Ik knaagde de unibrow van je grootvader uit het leger"
		},
		{
			"De run mislukte, de hakken schitterden niet"
		},
		{
			"Veel succes op de bananeneilanden!"
		},
		{
			"Is het waar dat je vader een astronaut is?"
		},
		{
			"Dat is wat je anti aimy noemt"
		},
		{
			"De moeder 1v1 verloren, mogelijk voor altijd..."
		},
		{
			"Fuck you, train de fuck al"
		},
		{
			"Tanki Online Test Server"
		},
		{
			"Je hebt me vermoord, gelachen, maar... werd op zijn knieën gebracht"
		}
	}
}
L_117_.phrase_count = {
	english = 0,
	russian = 0,
	ukrainian = 0,
	dutch = 0
}
L_117_.handle = function(L_794_arg0)
	local L_795_ = entity.get_local_player()
	if L_795_ == nil then
		return
	end;
	local L_796_ = client.userid_to_entindex(L_794_arg0.userid)
	if L_796_ == nil then
		return
	end;
	local L_797_ = client.userid_to_entindex(L_794_arg0.attacker)
	if L_797_ == nil then
		return
	end;
	if ui.get(visuals_tab.trashtalk) == "English" then
		L_117_.phrase_count.english = L_117_.phrase_count.english + 1;
		if L_117_.phrase_count.english > # L_117_.phrases.english then
			L_117_.phrase_count.english = 1
		end;
		local L_798_ = {
			english = L_117_.phrases.english[L_117_.phrase_count.english]
		}
		if ui.get(visuals_tab.trashtalk) ~= "Off" then
			if L_797_ == L_795_ and L_796_ ~= L_795_ then
				for L_799_forvar0 = 1, # L_798_.english do
					client.exec(("say %s"):format(L_798_.english[L_799_forvar0]))
				end
			end
		end
	elseif ui.get(visuals_tab.trashtalk) == "Russian" then
		L_117_.phrase_count.russian = L_117_.phrase_count.russian + 1;
		if L_117_.phrase_count.russian > # L_117_.phrases.russian then
			L_117_.phrase_count.russian = 1
		end;
		local L_800_ = {
			russian = L_117_.phrases.russian[L_117_.phrase_count.russian]
		}
		if ui.get(visuals_tab.trashtalk) ~= "Off" then
			if L_797_ == L_795_ and L_796_ ~= L_795_ then
				for L_801_forvar0 = 1, # L_800_.russian do
					client.exec(("say %s"):format(L_800_.russian[L_801_forvar0]))
				end
			end
		end
	elseif ui.get(visuals_tab.trashtalk) == "Dutch" then
		L_117_.phrase_count.dutch = L_117_.phrase_count.dutch + 1;
		if L_117_.phrase_count.dutch > # L_117_.phrases.dutch then
			L_117_.phrase_count.dutch = 1
		end;
		local L_802_ = {
			dutch = L_117_.phrases.dutch[L_117_.phrase_count.dutch]
		}
		if ui.get(visuals_tab.trashtalk) ~= "Off" then
			if L_797_ == L_795_ and L_796_ ~= L_795_ then
				for L_803_forvar0 = 1, # L_802_.dutch do
					client.exec(("say %s"):format(L_802_.dutch[L_803_forvar0]))
				end
			end
		end
	elseif ui.get(visuals_tab.trashtalk) == "Ukrainian" then
		L_117_.phrase_count.ukrainian = L_117_.phrase_count.ukrainian + 1;
		if L_117_.phrase_count.ukrainian > # L_117_.phrases.ukrainian then
			L_117_.phrase_count.ukrainian = 1
		end;
		local L_804_ = {
			ukrainian = L_117_.phrases.ukrainian[L_117_.phrase_count.ukrainian]
		}
		if ui.get(visuals_tab.trashtalk) ~= "Off" then
			if L_797_ == L_795_ and L_796_ ~= L_795_ then
				for L_805_forvar0 = 1, # L_804_.ukrainian do
					client.exec(("say %s"):format(L_804_.ukrainian[L_805_forvar0]))
				end
			end
		end
	end
end;
client.set_event_callback("player_death", L_117_.handle)
local L_118_ = false;
local L_119_ = {
	[1] = "Off",
	[2] = "Always slide",
	[3] = "Never slide"
}
local L_120_ = 0;
legMovement = ui.reference("AA", "Other", "Leg movement"), client.set_event_callback("pre_render", function()
	if not entity.get_local_player() then
		return
	end;
	local L_806_ = entity.get_prop(entity.get_local_player(), "m_fFlags")
	L_120_ = L_5_.band(L_806_, 1) == 0 and 0 or (L_120_ < 5 and L_120_ + 1 or L_120_)
	if ui.get(visuals_tab.staticlegs) then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
	end;
	if ui.get(visuals_tab.animfix) == "Shake player model" then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10) / 10, 3)
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10) / 10, 7)
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0, 10) / 10, 6)
	end;
	if ui.get(visuals_tab.animfix) == "Nasawalk" then
		if not L_118_ then
			L_118_ = ui.get(legMovement)
		end;
		ui.set_visible(legMovement, false)
		if ui.get(visuals_tab.animfix) == "nasawalk" then
			ui.set(legMovement, L_119_[math.random(1, 3)])
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 9, 0)
		end
	elseif L_118_ == "Off" or L_118_ == "Always slide" or L_118_ == "Never slide" then
		ui.set_visible(legMovement, true)
		ui.set(legMovement, L_118_)
		L_118_ = false
	end;
	if ui.get(visuals_tab.pitchzero) then
		L_120_ = L_5_.band(L_806_, 1) == 1 and L_120_ + 1 or 0;
		if L_120_ > 20 and L_120_ < 150 then
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
		end
	end;
	if ui.get(visuals_tab.animfix) == "Moonwalk" then
		if not L_118_ then
			L_118_ = ui.get(legMovement)
		end;
		ui.set_visible(legMovement, false)
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
		local L_807_ = L_12_.get_local_player()
		local L_808_ = L_807_:get_prop("m_fFlags")
		local L_809_ = L_5_.band(L_808_, 1) ~= 0;
		if not L_809_ then
			local L_810_ = L_807_:get_anim_overlay(6)
			L_810_.weight = 1
		end;
		ui.set(legMovement, "Off")
	elseif L_118_ == "Off" or L_118_ == "Always slide" or L_118_ == "Never slide" then
		ui.set_visible(legMovement, true)
		ui.set(legMovement, L_118_)
		L_118_ = false
	end
end)
local L_121_ = globals.curtime;
local L_122_ = client.unset_event_callback;
local L_123_, L_124_, L_125_ = renderer.circle_outline, renderer.measure_text, renderer.text;
local L_126_ = table.insert;
local L_127_ = ui.get;
local L_128_, L_129_ = client.screen_size()
local L_130_ = 6;
local L_131_ = L_129_ / 2 + L_129_ / 12;
function lerp(L_811_arg0, L_812_arg1, L_813_arg2)
	if not L_812_arg1 or not L_811_arg0 or not L_813_arg2 then
		return
	end;
	return L_811_arg0 + (L_812_arg1 - L_811_arg0) * L_813_arg2
end;
local L_132_ = {}
local L_133_ = 3;
local L_134_;
local function L_135_func()
	local L_814_ = L_121_() + L_133_ - L_134_;
	local L_815_ = L_814_ / L_133_ * 100 + 0.5;
	return L_815_ * 0.01
end;
local L_136_ = 40;
local L_137_ = 6;
local L_138_ = L_137_ / 2;
local L_139_ = L_137_ - 1;
local L_140_ = (L_137_ - 1) / 3;
dtcircle = 0;
lcbar = 0;
client.set_event_callback("paint", function()
	if safeheadtarget() and ui.get(L_40_.other.safe_head) and (L_51_:get_condition_type() == "Aircrouching" or L_51_:get_condition_type() == "Crouching" or L_51_:get_condition_type() == "Crouchrunning" or L_51_:get_condition_type() == "Standing" or L_51_:get_condition_type() == "Fakelag") then
		renderer.indicator(255, 255, 255, 200, "SAFEHEAD")
	end;
	if ui.get(L_40_.other.avoid_backstab) and L_58_func() then
		renderer.indicator(255, 255, 255, 200, "ANTI BACKSTAB")
	end;
	if ui.get(keybinds_tab.airstop) then
		renderer.indicator(255, 255, 255, 200, "AIR QUICKSTOP")
	end;
	renderer.indicator(255, 255, 255, 200, "LC")
	if not ui.get(visuals_tab.indicators) then
		return
	end;
	for L_816_forvar0 = 1, # L_132_ do
		local L_817_ = L_132_[L_816_forvar0]
		local L_818_ = L_817_.text;
		local L_819_, L_820_, L_821_, L_822_ = L_817_.r, L_817_.g, L_817_.b, L_817_.a;
		local L_823_ = is_defensive and 1 or 0;
		local L_824_ = L_131_ + L_816_forvar0 * - L_136_ + # L_132_ * L_136_;
		m_textW, m_textH = L_124_("+b", L_818_)
		renderer.gradient(L_130_, L_824_, m_textW + 20, m_textH + 6, 0, 0, 0, 255, 0, 0, 0, 100, true)
		renderer.blur(L_130_, L_824_, m_textW + 20, m_textH + 6)
		renderer.gradient(L_130_, L_824_, 1, 16, L_819_, L_820_, L_821_, 200, L_819_, L_820_, L_821_, 30, false)
		renderer.gradient(L_130_, L_824_, 16, 1, L_819_, L_820_, L_821_, 200, L_819_, L_820_, L_821_, 30, true)
		renderer.gradient(L_130_ + m_textW + 19, L_824_, 1, 16, L_819_, L_820_, L_821_, 200, L_819_, L_820_, L_821_, 30, false)
		renderer.gradient(L_130_ + m_textW + 4, L_824_, 16, 1, L_819_, L_820_, L_821_, 30, L_819_, L_820_, L_821_, 200, true)
		L_125_(L_130_ + 10, L_824_ + 2, L_819_, L_820_, L_821_, L_822_, "+b", 0, L_818_)
		if L_817_.r == 255 and L_817_.g == 0 and L_817_.b == 50 and L_818_:find("DT") then
			dtcircle = lerp(dtcircle, 0, globals.frametime() * 15)
		elseif L_818_:find("DT") then
			dtcircle = lerp(dtcircle, 24, globals.frametime() * 15)
		end;
		if L_823_ == 1 then
			lcbar = lerp(lcbar, 22, globals.frametime() * 5)
		else
			lcbar = lerp(lcbar, 0, globals.frametime() * 5)
		end;
		if L_818_:find("DT") then
			renderer.gradient(L_130_ + 23, L_824_ + 32, dtcircle, 3, L_819_, L_820_, L_821_, 130, L_819_, L_820_, L_821_, 100, true)
			renderer.gradient(L_130_ + 23, L_824_ + 32, - dtcircle + 1, 3, L_819_, L_820_, L_821_, 130, L_819_, L_820_, L_821_, 100, true)
		end;
		if L_818_:find("LC") then
			renderer.gradient(L_130_ + 22, L_824_ + 32, lcbar, 3, L_819_, L_820_, L_821_, 130, L_819_, L_820_, L_821_, 80, true)
			renderer.gradient(L_130_ + 22, L_824_ + 32, - lcbar, 3, L_819_, L_820_, L_821_, 130, L_819_, L_820_, L_821_, 80, true)
		end;
		if isBombBeingPlanted and L_818_:find("Bombsite") then
			local L_825_, L_826_ = L_124_("+b", L_818_)
			local L_827_ = L_130_ + L_825_ + L_137_ + 4;
			local L_828_ = L_824_ + L_826_ / 1.71;
			L_123_(L_827_, L_828_, 0, 0, 0, 200, L_137_, 0, 1.0, L_138_)
			L_123_(L_827_, L_828_, 255, 255, 255, 200, L_139_, 0, L_135_func(), L_140_)
		end
	end;
	L_132_ = {}
end)
client.set_event_callback("bomb_beginplant", function()
	L_134_ = L_121_() + L_133_;
	isBombBeingPlanted = true
end)
client.set_event_callback("bomb_abortplant", function()
	isBombBeingPlanted = false
end)
client.set_event_callback("bomb_planted", function()
	isBombBeingPlanted = false
end)
local function L_141_func(L_829_arg0)
	if not ui.get(visuals_tab.indicators) then
		return
	end;
	L_126_(L_132_, L_829_arg0)
end;
client.set_event_callback("shutdown", function()
	L_122_("indicator", L_141_func)
end)
client.set_event_callback("paint", function()
	if not ui.get(visuals_tab.indicators) then
		L_122_("indicator", L_141_func)
	else
		client.set_event_callback("indicator", L_141_func)
	end
end)
local L_142_ = {}
function notify_render()
	if ui.get(visuals_tab.eventlogs) then
		local L_830_, L_831_ = client.screen_size()
		for L_832_forvar0, L_833_forvar1 in ipairs(L_142_) do
			if L_832_forvar0 > 8 then
				table.remove(L_142_, L_832_forvar0)
			end;
			if L_833_forvar1.text ~= nil and L_833_forvar1.text ~= "" then
				local L_839_ = L_833_forvar1.color;
				local L_840_ = L_9_(renderer.measure_text("c", L_833_forvar1.text))
				if L_833_forvar1.timer + 7 < globals.realtime() then
					L_833_forvar1.length = lerp(L_833_forvar1.length, 0, globals.frametime() * 4.5)
					L_833_forvar1.alpha_text = lerp(L_833_forvar1.alpha_text, 0, globals.frametime() * 6)
					L_833_forvar1.alpha = lerp(L_833_forvar1.alpha, 0, globals.frametime() * 10)
					L_833_forvar1.alpha2 = lerp(L_833_forvar1.alpha2, 0, globals.frametime() * 2)
				else
					L_833_forvar1.length = lerp(L_833_forvar1.length, (L_840_.x + 22) / 2 + 1, globals.frametime() * 3)
					L_833_forvar1.alpha_text = lerp(L_833_forvar1.alpha_text, 200, globals.frametime() * 8)
					L_833_forvar1.alpha = lerp(L_833_forvar1.alpha, 150, globals.frametime() * 6)
					L_833_forvar1.alpha2 = lerp(L_833_forvar1.alpha2, 25, globals.frametime() * 4)
				end
			end;
			local_player = entity.get_local_player()
			if local_player == nil then
				return
			end;
			local L_834_ = L_9_(renderer.measure_text("c", L_833_forvar1.text))
			local L_835_, L_836_, L_837_, L_838_ = ui.get(visuals_tab.accent)
			renderer.rectangle(L_830_ / 2 - L_834_.x / 2 - 10, L_831_ + L_832_forvar0 * 28.5 - 300, L_834_.x + 22, L_834_.y + 5, 0, 0, 0, L_833_forvar1.alpha)
			renderer.rectangle(L_830_ / 2 - L_834_.x / 2 - 25 + (L_834_.x + 52) / 2, L_831_ + L_832_forvar0 * 28.5 - 284, L_833_forvar1.length, L_834_.y - 11, L_835_, L_836_, L_837_, L_833_forvar1.alpha)
			renderer.rectangle(L_830_ / 2 - L_834_.x / 2 - 25 + (L_834_.x + 52) / 2, L_831_ + L_832_forvar0 * 28.5 - 284, - L_833_forvar1.length, L_834_.y - 11, L_835_, L_836_, L_837_, L_833_forvar1.alpha)
			renderer.gradient(L_830_ / 2 - L_834_.x / 2 - 10, L_831_ + L_832_forvar0 * 28.5 - 300, 12, 1, L_835_, L_836_, L_837_, L_833_forvar1.alpha_text, L_835_, L_836_, L_837_, L_833_forvar1.alpha2, true)
			renderer.gradient(L_830_ / 2 - L_834_.x / 2 - 10, L_831_ + L_832_forvar0 * 28.5 - 300, 1, 12, L_835_, L_836_, L_837_, L_833_forvar1.alpha_text, L_835_, L_836_, L_837_, L_833_forvar1.alpha2, false)
			renderer.gradient(L_830_ / 2 + L_834_.x / 2, L_831_ + L_832_forvar0 * 28.5 - 300, 12, 1, L_835_, L_836_, L_837_, L_833_forvar1.alpha2, L_835_, L_836_, L_837_, L_833_forvar1.alpha_text, true)
			renderer.gradient(L_830_ / 2 + L_834_.x / 2 + 11, L_831_ + L_832_forvar0 * 28.5 - 300, 1, 12, L_835_, L_836_, L_837_, L_833_forvar1.alpha_text, L_835_, L_836_, L_837_, L_833_forvar1.alpha2, false)
			renderer.text(L_830_ / 2 - L_834_.x / 2, L_831_ + L_832_forvar0 * 28.5 - 300, L_835_, L_836_, L_837_, L_833_forvar1.alpha_text, "", nil, L_833_forvar1.text)
			if L_833_forvar1.timer + 9.15 < globals.realtime() then
				table.remove(L_142_, L_832_forvar0)
			end
		end
	end
end;
function new_notify(L_841_arg0, L_842_arg1, L_843_arg2, L_844_arg3, L_845_arg4)
	local L_846_ = {
		text = L_841_arg0,
		timer = globals.realtime(),
		color = {
			L_842_arg1,
			L_843_arg2,
			L_844_arg3,
			L_845_arg4
		},
		alpha = 0,
		alpha_text = 0,
		length = 0,
		alpha2 = 0
	}
	local L_847_ = select(1.25, client.screen_size())
	if # L_142_ == 0 then
		L_846_.y = L_847_ + 30
	else
		local L_848_ = L_142_[# L_142_]
		L_846_.y = L_848_.y + 30
	end;
	table.insert(L_142_, L_846_)
end;
local L_143_ = {
	"generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"?",
	"gear"
}
client.set_event_callback("aim_fire", function(L_849_arg0)
	if not ui.get(visuals_tab.eventlogs) then
		return
	end;
	stored_shot = {
		damage = L_849_arg0.damage,
		hitbox = L_143_[L_849_arg0.hitgroup + 1],
		lagcomp = L_849_arg0.teleported,
		backtrack = globals.tickcount() - L_849_arg0.tick
	}
end)
local function L_144_func(L_850_arg0)
	local L_851_ = L_143_[L_850_arg0.hitgroup + 1] or "?"
	local L_852_ = math.floor(L_850_arg0.hit_chance)
	if ui.get(visuals_tab.eventlogs) then
		new_notify(string.format("Hit %s in the %s for %s (%s) (%s health remaining) | bt=%s | hc=%s", entity.get_player_name(L_850_arg0.target), L_851_, L_850_arg0.damage, stored_shot.damage, entity.get_prop(L_850_arg0.target, "m_iHealth"), globals.tickcount() - L_850_arg0.tick, L_852_), 255, 255, 255, 255)
		local L_853_ = string.format("Hit %s in the %s for %s (%s) (%s health remaining) | bt=%s | hc=%s", entity.get_player_name(L_850_arg0.target), L_851_, L_850_arg0.damage, stored_shot.damage, entity.get_prop(L_850_arg0.target, "m_iHealth"), globals.tickcount() - L_850_arg0.tick, L_852_)
		print(L_853_)
	end
end;
client.set_event_callback("aim_hit", L_144_func)
local function L_145_func(L_854_arg0)
	local L_855_ = L_143_[L_854_arg0.hitgroup + 1] or "?"
	local L_856_ = math.floor(L_854_arg0.hit_chance)
	if ui.get(visuals_tab.eventlogs) then
		new_notify(string.format("missed %s in the %s(%s) for %s (%s health remaining) due to %s | bt=%s | hc=%s", entity.get_player_name(L_854_arg0.target), L_855_, L_855_, stored_shot.damage, entity.get_prop(L_854_arg0.target, "m_iHealth"), L_854_arg0.reason, globals.tickcount() - L_854_arg0.tick, L_856_), 255, 255, 255, 255)
		local L_857_ = string.format("missed %s in the %s(%s) for %s (%s health remaining) due to %s | bt=%s | hc=%s", entity.get_player_name(L_854_arg0.target), L_855_, L_855_, stored_shot.damage, entity.get_prop(L_854_arg0.target, "m_iHealth"), L_854_arg0.reason, globals.tickcount() - L_854_arg0.tick, L_856_)
		print(L_857_)
	end
end;
client.set_event_callback("aim_miss", L_145_func)
local function L_146_func(L_858_arg0)
	local L_859_ = client.userid_to_entindex(L_858_arg0.attacker)
	local L_860_ = client.userid_to_entindex(L_858_arg0.userid)
	local L_861_ = entity.get_local_player()
	local L_862_ = entity.get_local_player()
	local L_863_, L_864_, L_865_ = entity.get_prop(L_862_, "m_vecOrigin")
	local L_866_ = math.floor(L_67_func(L_862_, 10, L_863_, L_864_, L_865_))
	if L_866_ < 0 then
		L_866_ = 0
	end;
	if L_860_ == L_861_ and ui.get(visuals_tab.eventlogs) then
		new_notify(string.format("you've got killed by %s | safehead: %s | broken lc: %s | teleport: %s", entity.get_player_name(L_859_), safeheadtarget() and ui.get(L_40_.other.safe_head) and (L_51_:get_condition_type() == "Aircrouching" or L_51_:get_condition_type() == "Crouching" or L_51_:get_condition_type() == "Crouchrunning" or L_51_:get_condition_type() == "Standing" or L_51_:get_condition_type() == "Fakelag"), is_defensive, L_866_, 255, 255, 255, 255))
		local L_867_ = string.format("you've got killed by %s | safehead: %s | broken lc: %s | teleport: %s", entity.get_player_name(L_859_), safeheadtarget() and ui.get(L_40_.other.safe_head) and (L_51_:get_condition_type() == "Aircrouching" or L_51_:get_condition_type() == "Crouching" or L_51_:get_condition_type() == "Crouchrunning" or L_51_:get_condition_type() == "Standing" or L_51_:get_condition_type() == "Fakelag"), is_defensive, L_866_)
		print(L_867_)
	end
end;
client.set_event_callback("player_death", L_146_func)
local function L_147_func(L_868_arg0)
	local L_869_ = client.userid_to_entindex(L_868_arg0.userid)
	if L_869_ ~= local_player and ui.get(visuals_tab.eventlogs) then
		new_notify(string.format("%s bought %s", entity.get_player_name(L_869_), L_868_arg0.weapon), 255, 255, 255, 255)
	end
end;
client.set_event_callback("item_purchase", L_147_func)
client.set_event_callback("paint_ui", function()
	notify_render()
end)
local L_148_ = {
	desyncsize = 0,
	newsway = 0,
	dtalpha = 75,
	hsalpha = 75,
	fsalpha = 75,
	dmgalpha = 75,
	lcbar = 0,
	addiction = 0,
	baralpha = 1,
	scopedalpha = 1,
	scopedalign = 0,
	arrow_left = 0,
	arrow_right = 0,
	forarrows = 0,
	inactive_fraction = 0,
	active_fraction = 0,
	fraction = 0,
	hide_fraction = 0,
	dmg_fraction = 0,
	scoped_fraction = 0,
	lby_r = 0,
	lby_l = 0
}
ctx_clamp = function(L_870_arg0, L_871_arg1, L_872_arg2)
	assert(L_870_arg0 and L_871_arg1 and L_872_arg2, "not very useful error message here")
	if L_871_arg1 > L_872_arg2 then
		L_871_arg1, L_872_arg2 = L_872_arg2, L_871_arg1
	end;
	return math.max(L_871_arg1, math.min(L_872_arg2, L_870_arg0))
end;
easeInOut = function(L_873_arg0)
	return L_873_arg0 > 0.5 and 4 * (L_873_arg0 - 1) ^ 3 + 1 or 4 * L_873_arg0 ^ 3
end;
function round(L_874_arg0)
	return math.floor(L_874_arg0 + 0.5)
end;
client.set_event_callback("paint", function()
	local L_875_ = entity.get_local_player()
	if not L_875_ or not entity.is_alive(L_875_) then
		return
	end;
	cvet1, cvet2, cvet3, cvet4 = ui.get(visuals_tab.accent)
	local L_876_, L_877_ = client.screen_size()
	if ui.get(visuals_tab.watermark) then
		renderer.rectangle(L_876_ / 2 - 52, L_877_ - 13, 104, 13, 0, 0, 0, 100)
		renderer.gradient(L_876_ / 2 - 52, L_877_ - 13, 10, 1, cvet1, cvet2, cvet3, 255, cvet1, cvet2, cvet3, 30, true)
		renderer.gradient(L_876_ / 2 - 52, L_877_ - 13, 1, 10, cvet1, cvet2, cvet3, 255, cvet1, cvet2, cvet3, 30, false)
		renderer.gradient(L_876_ / 2 + 42, L_877_ - 13, 10, 1, cvet1, cvet2, cvet3, 40, cvet1, cvet2, cvet3, 255, true)
		renderer.gradient(L_876_ / 2 + 52, L_877_ - 13, 1, 10, cvet1, cvet2, cvet3, 255, cvet1, cvet2, cvet3, 30, false)
		renderer.text(L_876_ / 2 - renderer.measure_text("", "izanasense ~ " .. math.floor(client.latency() * 1000) .. "ms") / 2, L_877_ - 12, 255, 255, 255, 50, "", nil, animate_text(globals.curtime() * 1, "izanasense ~ " .. math.floor(client.latency() * 1000) .. "ms", 0, 0, 0, 255, cvet1, cvet2, cvet3, 255))
	end;
	local L_878_ = {
		client.screen_size()
	}
	local L_879_ = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
	local L_880_ = entity.get_local_player()
	if not L_880_ or not entity.is_alive(L_880_) then
		return
	end;
	if ui.get(visuals_tab.arrows) ~= "Off" then
		if L_879_ ~= 0 then
			L_148_.forarrows = lerp(L_148_.forarrows, 0, globals.frametime() * 24)
		else
			L_148_.forarrows = lerp(L_148_.forarrows, 1, globals.frametime() * 24)
		end;
		if ui.get(visuals_tab.arrows) == "TS4" then
			if manual_dir == 2 then
				L_148_.arrow_right = lerp(L_148_.arrow_right, 255, globals.frametime() * 24)
			else
				L_148_.arrow_right = lerp(L_148_.arrow_right, 0, globals.frametime() * 24)
			end;
			if manual_dir == 1 then
				L_148_.arrow_left = lerp(L_148_.arrow_left, 255, globals.frametime() * 24)
			else
				L_148_.arrow_left = lerp(L_148_.arrow_left, 0, globals.frametime() * 24)
			end;
			L_128_ = L_878_[1]
			L_129_ = L_878_[2]
			local L_881_ = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", "m_nTickbase", 11) * 120 - 60;
			renderer.triangle(L_128_ / 2 + 55, L_129_ / 2 + 2, L_128_ / 2 + 42, L_129_ / 2 - 7, L_128_ / 2 + 42, L_129_ / 2 + 11, manual_dir == 2 and cvet1 or 25, manual_dir == 2 and cvet2 or 25, manual_dir == 2 and cvet3 or 25, manual_dir == 2 and 255 * L_148_.forarrows or 160 * L_148_.forarrows)
			renderer.triangle(L_128_ / 2 - 55, L_129_ / 2 + 2, L_128_ / 2 - 42, L_129_ / 2 - 7, L_128_ / 2 - 42, L_129_ / 2 + 11, manual_dir == 1 and cvet1 or 25, manual_dir == 1 and cvet2 or 25, manual_dir == 1 and cvet3 or 25, manual_dir == 1 and 255 * L_148_.forarrows or 160 * L_148_.forarrows)
			renderer.rectangle(L_128_ / 2 + 38, L_129_ / 2 - 7, 2, 18, L_881_ < -10 and cvet1 or 25, L_881_ < -10 and cvet2 or 25, L_881_ < -10 and cvet3 or 25, L_881_ < -10 and 255 * L_148_.forarrows or 160 * L_148_.forarrows)
			renderer.rectangle(L_128_ / 2 - 40, L_129_ / 2 - 7, 2, 18, L_881_ > 10 and cvet1 or 25, L_881_ > 10 and cvet2 or 25, L_881_ > 10 and cvet3 or 25, L_881_ > 10 and 255 * L_148_.forarrows or 160 * L_148_.forarrows)
		elseif ui.get(visuals_tab.arrows) == "izanasense" then
			if manual_dir == 2 then
				L_148_.arrow_right = lerp(L_148_.arrow_right, 255, globals.frametime() * 14)
			else
				L_148_.arrow_right = lerp(L_148_.arrow_right, 0, globals.frametime() * 14)
			end;
			if manual_dir == 1 then
				L_148_.arrow_left = lerp(L_148_.arrow_left, 255, globals.frametime() * 14)
			else
				L_148_.arrow_left = lerp(L_148_.arrow_left, 0, globals.frametime() * 24)
			end;
			local L_882_ = L_7_.get_desync(1)
			if L_882_ <= -1 then
				L_148_.lby_l = lerp(L_148_.lby_l, 255, globals.frametime() * 14)
			else
				L_148_.lby_l = lerp(L_148_.lby_l, 0, globals.frametime() * 14)
			end;
			if L_882_ >= -1 then
				L_148_.lby_r = lerp(L_148_.lby_r, 255, globals.frametime() * 14)
			else
				L_148_.lby_r = lerp(L_148_.lby_r, 0, globals.frametime() * 14)
			end;
			renderer.text(L_878_[1] / 2 - 50, L_878_[2] / 2, 255, 255, 255, 255 * L_148_.forarrows, "+c", nil, "<")
			renderer.text(L_878_[1] / 2 + 50, L_878_[2] / 2, 255, 255, 255, 255 * L_148_.forarrows, "+c", nil, ">")
			renderer.text(L_878_[1] / 2 - 50, L_878_[2] / 2, cvet1, cvet2, cvet3, L_148_.arrow_left, "+c", nil, "<")
			renderer.text(L_878_[1] / 2 + 50, L_878_[2] / 2, cvet1, cvet2, cvet3, L_148_.arrow_right, "+c", nil, ">")
			renderer.text(L_878_[1] / 2 - 65, L_878_[2] / 2, cvet1, cvet2, cvet3, L_148_.lby_l * L_148_.forarrows, "+c", nil, "<")
			renderer.text(L_878_[1] / 2 + 65, L_878_[2] / 2, cvet1, cvet2, cvet3, L_148_.lby_r * L_148_.forarrows, "+c", nil, ">")
		end
	end;
	if ui.get(visuals_tab.center_indicators) == "Modern" then
		local L_883_, L_884_ = client.screen_size()
		local L_885_, L_886_ = renderer.measure_text("i", "izanasense°")
		local L_887_, L_888_, L_889_, L_890_ = cvet1, cvet2, cvet3, cvet4;
		state = L_51_:get_condition_type()
		if ui.get(visuals_tab.onscope) == "Right" then
			if L_879_ ~= 0 then
				L_148_.scoped_fraction = 1;
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 14)
				alphaforlogo = "\affffffff"
			else
				L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
				alphaforlogo = "\affffffff"
			end
		elseif ui.get(visuals_tab.onscope) == "Alpha" then
			L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
			if L_879_ ~= 0 then
				alphaforlogo = "\affffff00"
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 0, globals.frametime() * 24)
			else
				alphaforlogo = "\affffffff"
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
			end
		elseif ui.get(visuals_tab.onscope) == "Off" then
			alphaforlogo = "\affffffff"
			L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
			L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
		end;
		angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60))
		if angle > 35 then
			L_148_.desyncsize = lerp(L_148_.desyncsize, math.random(25, 36) + math.random(0, -20), globals.frametime() * 24)
		elseif angle > 10 then
			L_148_.desyncsize = lerp(L_148_.desyncsize, angle, globals.frametime() * 24)
		elseif angle < 10 or is_freezetime() then
			L_148_.desyncsize = lerp(L_148_.desyncsize, 0, globals.frametime() * 24)
		end;
		if shouldonfreezetime and is_freezetime() then
			L_148_.desyncsize = lerp(L_148_.desyncsize, 0, globals.frametime() * 24)
		end;
		if L_148_.desyncsize < 2 or entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
			L_148_.addiction = lerp(L_148_.addiction, 8, globals.frametime() * 24)
			L_148_.baralpha = lerp(L_148_.baralpha, 0, globals.frametime() * 24)
		else
			L_148_.addiction = lerp(L_148_.addiction, 0, globals.frametime() * 24)
			L_148_.baralpha = lerp(L_148_.baralpha, 1, globals.frametime() * 24)
		end;
		local L_891_ = L_148_.scoped_fraction;
		renderer.rectangle(L_883_ / 2 - 18 + (L_885_ + 2) / 2.1 * L_891_, L_884_ / 2 + 28, 36, 5, 0, 0, 0, 255 * L_148_.baralpha * L_148_.scopedalpha)
		renderer.rectangle(L_883_ / 2 - 17 + (L_885_ + 2) / 2.1 * L_891_, L_884_ / 2 + 29, L_148_.desyncsize * L_148_.scopedalpha, 3, cvet1, cvet2, cvet3, 255 * L_148_.baralpha * L_148_.scopedalpha)
		renderer.gradient(L_883_ / 2 - 17 + (L_885_ + 2) / 2.1 * L_891_, L_884_ / 2 + 29, L_148_.desyncsize * L_148_.scopedalpha, 3, 0, 0, 0, 0, 0, 0, 0, 200 * L_148_.baralpha * L_148_.scopedalpha, true)
		dangerouscolor = string.format("\a%s", rgba_to_hex(255, 255, 255, L_148_.scopedalpha))
		renderer.text(L_883_ / 2 + (L_885_ + 2) / 2.2 * L_891_, L_884_ / 2 + 20, 255, 255, 255, 255 * L_148_.scopedalpha, "cb", 0, animate_text(globals.curtime() * 2.5, "izanasense", 255, 255, 255, 255 * L_148_.scopedalpha, cvet1, cvet2, cvet3, 255 * L_148_.scopedalpha))
		local L_892_ = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
		local L_893_ = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_flNextPrimaryAttack")
		local L_894_ = ui.get(L_53_.doubletap[1]) and ui.get(L_53_.doubletap[2])
		local L_895_ = entity.get_local_player()
		local L_896_ = entity.get_prop(L_895_, "m_flNextAttack")
		local L_897_ = entity.get_prop(entity.get_player_weapon(L_895_), "m_flNextPrimaryAttack")
		local L_898_ = false;
		if L_897_ ~= nil then
			L_898_ = not (math.max(L_897_, L_896_) > globals.curtime())
		end;
		if L_894_ and L_898_ then
			L_148_.active_fraction = ctx_clamp(L_148_.active_fraction + globals.frametime() / 0.15, 0, 1)
		else
			L_148_.active_fraction = ctx_clamp(L_148_.active_fraction - globals.frametime() / 0.15, 0, 1)
		end;
		if L_894_ and not L_898_ then
			L_148_.inactive_fraction = ctx_clamp(L_148_.inactive_fraction + globals.frametime() / 0.15, 0, 1)
		else
			L_148_.inactive_fraction = ctx_clamp(L_148_.inactive_fraction - globals.frametime() / 0.15, 0, 1)
		end;
		if ui.get(L_53_.hideshots[1]) and ui.get(L_53_.hideshots[2]) and not L_894_ then
			L_148_.hide_fraction = ctx_clamp(L_148_.hide_fraction + globals.frametime() / 0.15, 0, 1)
		else
			L_148_.hide_fraction = ctx_clamp(L_148_.hide_fraction - globals.frametime() / 0.15, 0, 1)
		end;
		if math.max(L_148_.hide_fraction, L_148_.inactive_fraction, L_148_.active_fraction) > 0 then
			L_148_.fraction = ctx_clamp(L_148_.fraction + globals.frametime() / 0.2, 0, 1)
		else
			L_148_.fraction = ctx_clamp(L_148_.fraction - globals.frametime() / 0.2, 0, 1)
		end;
		local L_899_ = renderer.measure_text("-", "")
		local L_900_ = renderer.measure_text("-", "DT")
		renderer.text(L_883_ / 2 + (L_899_ + L_900_ + 2) / 2 * L_891_, L_884_ / 2 + 37 - L_148_.addiction, 255, 255, 255, L_148_.active_fraction * 255 * L_148_.scopedalpha, "-c", L_899_ + L_148_.active_fraction * L_900_ + 1, animate_text(globals.curtime() * 1.5, "", 50, 50, 50, 255 * L_148_.scopedalpha, cvet1, cvet2, cvet3, 255 * L_148_.scopedalpha), "\a" .. rgba_to_hex(155, 255, 155, 255 * L_148_.active_fraction * L_148_.scopedalpha) .. animate_text(globals.curtime() * 1.5, "DT", 200, 200, 200, 255 * L_148_.scopedalpha, 200, 200, 200, 255 * L_148_.scopedalpha))
		local L_901_ = renderer.measure_text("-", "DT")
		local L_902_ = animate_text(globals.curtime() * 1.5, "DT", 100, 0, 0, 255 * L_148_.scopedalpha, 100, 0, 0, 255 * L_148_.scopedalpha)
		renderer.text(L_883_ / 2 + (L_899_ + L_901_ + 2) / 2 * L_891_, L_884_ / 2 + 37 - L_148_.addiction, 255, 255, 255, L_148_.inactive_fraction * 255 * L_148_.scopedalpha, "-c", L_899_ + L_148_.inactive_fraction * L_901_ + 1, "", L_902_)
		local L_903_ = renderer.measure_text("-", "")
		local L_904_ = renderer.measure_text("-", "HS")
		renderer.text(L_883_ / 2 + (L_903_ + L_904_ + 2) / 2 * L_891_, L_884_ / 2 + 37 - L_148_.addiction, 255, 255, 255, L_148_.hide_fraction * 255 * L_148_.scopedalpha, "-c", L_903_ + L_148_.hide_fraction * L_904_ + 1, animate_text(globals.curtime() * 1.5, "HS", 200, 200, 200, 255 * L_148_.scopedalpha, 200, 200, 200, 255 * L_148_.scopedalpha), "\a" .. rgba_to_hex(155, 155, 200, 255 * L_148_.hide_fraction * L_148_.scopedalpha) .. "")
		local L_905_ = renderer.measure_text("-", "> " .. string.upper(state) .. " <")
		renderer.text(L_883_ / 2 + (L_905_ + 2) / 2 * L_891_, L_884_ / 2 + 37 + 8 * easeInOut(L_148_.fraction) - L_148_.addiction, 255, 255, 255, 255 * L_148_.scopedalpha, "-c", 0, animate_text(globals.curtime() * 1.5, string.format("> %s <", string.upper(state)), 200, 200, 200, 255 * L_148_.scopedalpha, 200, 200, 200, 255 * L_148_.scopedalpha))
	elseif ui.get(visuals_tab.center_indicators) == "Bounty" then
		local L_906_, L_907_ = client.screen_size()
		local L_908_, L_909_ = renderer.measure_text("c", "bounty°")
		local L_910_, L_911_, L_912_, L_913_ = cvet1, cvet2, cvet3, cvet4;
		state = L_51_:get_condition_type()
		angle = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60))
		if angle > 35 then
			L_148_.desyncsize = lerp(L_148_.desyncsize, math.random(25, 36) + math.random(0, -20), globals.frametime() * 24)
		elseif angle > 10 then
			L_148_.desyncsize = lerp(L_148_.desyncsize, angle, globals.frametime() * 24)
		elseif angle < 10 or is_freezetime() then
			L_148_.desyncsize = lerp(L_148_.desyncsize, 0, globals.frametime() * 24)
		end;
		if shouldonfreezetime and is_freezetime() then
			L_148_.desyncsize = lerp(L_148_.desyncsize, 0, globals.frametime() * 24)
		end;
		if L_148_.desyncsize < 2 or entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
			L_148_.addiction = lerp(L_148_.addiction, 8, globals.frametime() * 24)
			L_148_.baralpha = lerp(L_148_.baralpha, 0, globals.frametime() * 24)
		else
			L_148_.addiction = lerp(L_148_.addiction, 0, globals.frametime() * 24)
			L_148_.baralpha = lerp(L_148_.baralpha, 1, globals.frametime() * 24)
		end;
		if ui.get(visuals_tab.onscope) == "Right" then
			if L_879_ ~= 0 then
				L_148_.scoped_fraction = 1;
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 14)
				alphaforlogo = "\affffffff"
			else
				L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
				alphaforlogo = "\affffffff"
			end
		elseif ui.get(visuals_tab.onscope) == "Alpha" then
			L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
			if L_879_ ~= 0 then
				alphaforlogo = "\affffff00"
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 0, globals.frametime() * 24)
			else
				alphaforlogo = "\affffffff"
				L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
			end
		elseif ui.get(visuals_tab.onscope) == "Off" then
			alphaforlogo = "\affffffff"
			L_148_.scopedalpha = lerp(L_148_.scopedalpha, 1, globals.frametime() * 24)
			L_148_.scoped_fraction = lerp(L_148_.scoped_fraction, 0, globals.frametime() * 24, 0, 1)
		end;
		if L_879_ ~= 0 then
			L_148_.forarrows = lerp(L_148_.forarrows, 0, globals.frametime() * 24)
		else
			L_148_.forarrows = lerp(L_148_.forarrows, 1, globals.frametime() * 24)
		end;
		local L_914_ = L_148_.scoped_fraction;
		dangerouscolor = string.format("\a%s", rgba_to_hex(255, 255, 255, L_148_.scopedalpha))
		renderer.gradient(L_906_ / 2 - 38 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 12, 76, 14, cvet1, cvet2, cvet3, 75 * L_148_.forarrows, 0, 0, 0, 25 * L_148_.forarrows, false)
		renderer.gradient(L_906_ / 2 - 38 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 12, 10, 1, cvet1, cvet2, cvet3, 255 * L_148_.forarrows, cvet1, cvet2, cvet3, 0 * L_148_.forarrows, true)
		renderer.gradient(L_906_ / 2 - 38 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 12, 1, 10, cvet1, cvet2, cvet3, 255 * L_148_.forarrows, cvet1, cvet2, cvet3, 0 * L_148_.forarrows, false)
		renderer.gradient(L_906_ / 2 + 28 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 12, 10, 1, cvet1, cvet2, cvet3, 0 * L_148_.forarrows, cvet1, cvet2, cvet3, 255 * L_148_.forarrows, true)
		renderer.gradient(L_906_ / 2 + 38 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 12, 1, 10, cvet1, cvet2, cvet3, 255 * L_148_.forarrows, cvet1, cvet2, cvet3, 0 * L_148_.forarrows, false)
		renderer.gradient(L_906_ / 2, L_907_ / 2 + 25, L_148_.desyncsize, 1, cvet1, cvet2, cvet3, 255 * L_148_.scopedalpha, cvet1, cvet2, cvet3, 0 * L_148_.scopedalpha, true)
		renderer.gradient(L_906_ / 2 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 25, - L_148_.desyncsize, 1, cvet1, cvet2, cvet3, 255 * L_148_.forarrows, cvet1, cvet2, cvet3, 0 * L_148_.forarrows, true)
		renderer.text(L_906_ / 2 + (L_908_ + 2) / 2 * L_914_, L_907_ / 2 + 18, cvet1, cvet2, cvet3, 255 * L_148_.scopedalpha, "c", 0, "bounty°")
		local L_915_ = entity.get_local_player()
		local L_916_ = entity.get_prop(L_915_, "m_flNextAttack")
		local L_917_ = entity.get_prop(entity.get_player_weapon(L_915_), "m_flNextPrimaryAttack")
		local L_918_ = false;
		if L_917_ ~= nil then
			L_918_ = not (math.max(L_917_, L_916_) > globals.curtime())
		end;
		local L_919_ = L_918_;
		local L_920_ = ui.get(L_53_.doubletap[1]) and ui.get(L_53_.doubletap[2])
		if L_920_ then
			L_148_.active_fraction = ctx_clamp(L_148_.active_fraction + globals.frametime() / 0, 0, 1)
		else
			L_148_.active_fraction = ctx_clamp(L_148_.active_fraction - globals.frametime() / 0, 0, 1)
		end;
		if ui.get(L_53_.hideshots[1]) and ui.get(L_53_.hideshots[2]) and not L_920_ then
			L_148_.hide_fraction = ctx_clamp(L_148_.hide_fraction + globals.frametime() / 0, 0, 1)
		else
			L_148_.hide_fraction = ctx_clamp(L_148_.hide_fraction - globals.frametime() / 0, 0, 1)
		end;
		if ui.get(L_53_.dmg[2]) then
			L_148_.dmg_fraction = ctx_clamp(L_148_.dmg_fraction + globals.frametime() / 0, 0, 1)
		else
			L_148_.dmg_fraction = ctx_clamp(L_148_.dmg_fraction - globals.frametime() / 0, 0, 1)
		end;
		if math.max(L_148_.hide_fraction, L_148_.active_fraction) > 0 then
			L_148_.fraction = ctx_clamp(L_148_.fraction + globals.frametime() / 0.2, 0, 1)
		else
			L_148_.fraction = ctx_clamp(L_148_.fraction - globals.frametime() / 0.2, 0, 1)
		end;
		local L_921_ = renderer.measure_text("c", "")
		local L_922_ = renderer.measure_text("c", "dt")
		renderer.text(L_906_ / 2 + (L_921_ + L_922_ + 2) / 2 * L_914_, L_907_ / 2 + 40, 255, 255, 255, L_148_.active_fraction * 250 * L_148_.scopedalpha, "c", L_922_ + 1, "dt")
		local L_923_ = renderer.measure_text("c", "")
		local L_924_ = renderer.measure_text("c", "hs")
		renderer.text(L_906_ / 2 + (L_923_ + L_924_ + 2) / 2 * L_914_, L_907_ / 2 + 40, 255, 255, 255, L_148_.hide_fraction * 255 * L_148_.scopedalpha, "c", L_923_ + L_148_.hide_fraction * L_924_ + 1, animate_text(globals.curtime() * 1.5, "hs", 255, 255, 255, 250 * L_148_.scopedalpha, 255, 255, 255, 250 * L_148_.scopedalpha), "\a" .. rgba_to_hex(155, 155, 200, 255 * L_148_.hide_fraction * L_148_.scopedalpha) .. "")
		local L_925_ = renderer.measure_text("c", "dmg")
		renderer.text(L_906_ / 2 + (L_925_ + 2) / 2 * L_914_, L_907_ / 2 + 40 + 8 * easeInOut(L_148_.fraction), 255, 255, 255, L_148_.dmg_fraction * 255 * L_148_.scopedalpha, "c", L_148_.dmg_fraction * L_925_ + 1, animate_text(globals.curtime() * 1.5, "dmg", 255, 255, 255, 250 * L_148_.scopedalpha, 255, 255, 255, 250 * L_148_.scopedalpha), "\a" .. rgba_to_hex(155, 155, 200, 255 * L_148_.dmg_fraction * L_148_.scopedalpha) .. "")
		local L_926_ = renderer.measure_text("c", "~ " .. string.lower(state) .. " ~")
		renderer.text(L_906_ / 2 + (L_926_ + 2) / 2 * L_914_, L_907_ / 2 + 30, 255, 255, 255, 250 * L_148_.scopedalpha, "c", 0, animate_text(globals.curtime() * 2, string.format("~%s~", string.lower(state)), 0, 0, 0, 180 * L_148_.scopedalpha, cvet1, cvet2, cvet3, 250 * L_148_.scopedalpha))
	end
end)