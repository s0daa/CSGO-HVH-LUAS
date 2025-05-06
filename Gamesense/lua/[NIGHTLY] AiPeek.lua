
--#region lua
local lua = {}
lua.configs = {}
--#endregion

--#region require
local pui = require('gamesense/pui')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local antiaim_data = require('gamesense/antiaim_funcs')
local vector = require('vector')
local ffi = require('ffi')
local weapons = require('gamesense/csgo_weapons')
lua.entity = require('gamesense/entity')
local surface = require 'gamesense/surface'
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
local L_19_ = "BOUNTY"
local L_20_ = true;
local L_21_ = 0;
--#endregions

ragebot_tab = {
}

local tabs = {
    angle = pui.group('aa', 'anti-aimbot angles'),
    fake = pui.group('aa', 'fake lag'),
    other = pui.group('aa', 'other')
}

exploits_tab = {
	aipeek = ui.new_checkbox("AA", "other", "\v⮂ AI Peek \aA1A1A190(Pls on Retreat on key release)"),
}

--#region :: dependencies


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

-- @region Defensive resolve / exploits

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
		local L_502_ = L_9_(math.cos(math.rad(L_500_ + 90)), math.sin(math.rad(L_500_ + 90)), 0):scaled(L_501_forvar0 * 0.95)
		local L_503_ = L_9_(math.cos(math.rad(L_500_ - 90)), math.sin(math.rad(L_500_ - 90)), 0):scaled(L_501_forvar0 * 0.95)
		local L_504_ = L_502_ + L_498_;
		local L_505_ = L_502_ + L_499_;
		local L_506_ = L_503_ + L_498_;
		local L_507_ = L_503_ + L_499_;
	end;
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
	if not ui.get(exploits_tab.aipeek) then
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
	if not ui.get(exploits_tab.aipeek) then
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
	if not ui.get(exploits_tab.aipeek) then
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
	if not ui.get(exploits_tab.aipeek) then
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


-- @region Defensive resolve / exploits end