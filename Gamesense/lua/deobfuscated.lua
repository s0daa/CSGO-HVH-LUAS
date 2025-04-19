

local pipi = "obfuscated_string";
local var0 = error;
local var1 = setmetatable;
local var2 = ipairs;
local var3 = pairs;
local var4 = next;
local var5 = printf;
local var6 = rawequal;
local var7 = rawset;
local var8 = rawlen;
local var9 = readfile;
local var10 = writefile;
local var11 = require;
local var12 = tonumber;
local var13 = toticks;
local var14 = type;
local var15 = unpack;
local var16 = pcall;
local function var17(var50)
	local var51 = {};
	for var652, var653 in var4, var50 do
		var51[var652] = var653;
	end
	return var51;
end
local var18 = var17(table);
local var19 = var17(math);
local var20 = var17(string);
local var21 = var17(ui);
local var22 = var17(client);
local var23 = var17(database);
local var24 = var17(entity);
local var25 = var17(var11("ffi"));
local var26 = var17(globals);
local var27 = var17(panorama);
local var28 = var17(renderer);
local var29 = var17(bit);
local function var30(var52)
	if var52 then
		return var11(var52);
	else
		var0("nope" .. var52);
	end
end
local var31 = var30("vector");
local var32 = var30("gamesense/pui");
local var33 = var30("gamesense/base64");
local var34 = var30("gamesense/clipboard");
local var35 = var30("gamesense/entity");
local var36 = var30("gamesense/http");
local var37 = {color={164,210,212},offset=0,blured=false};
local var38 = function(var53, var54, var55)
	return (function()
		local var655 = {};
		local var656, var657, var658, var659, var660, var661, var662, var663, var664, var665, var666, var667, var668, var669;
		local var670 = {__index={drag=function(var804, ...)
			local var805, var806 = var804:get();
			local var807, var808 = var655.drag(var805, var806, ...);
			if ((var805 ~= var807) or (var806 ~= var808)) then
				var804:set(var807, var808);
			end
			return var807, var808;
		end,set=function(var809, var810, var811)
			local var812, var813 = var22.screen_size();
			var21.set(var809.x_reference, (var810 / var812) * var809.res);
			var21.set(var809.y_reference, (var811 / var813) * var809.res);
		end,get=function(var814, var815, var816)
			local var817, var818 = var22.screen_size();
			return ((var21.get(var814.x_reference) / var814.res) * var817) + (var815 or 0), ((var21.get(var814.y_reference) / var814.res) * var818) + (var816 or 0);
		end}};
		var655.new = function(var819, var820, var821, var822)
			var822 = var822 or 10000;
			local var823, var824 = var22.screen_size();
			local var825 = var21.new_slider("misc", "settings", "one::x:" .. var819, 0, var822, (var820 / var823) * var822);
			local var826 = var21.new_slider("misc", "settings", "one::y:" .. var819, 0, var822, (var821 / var824) * var822);
			var21.set_visible(var825, false);
			var21.set_visible(var826, false);
			return var1({name=var819,x_reference=var825,y_reference=var826,res=var822}, var670);
		end;
		var655.drag = function(var827, var828, var829, var830, var831, var832, var833)
			if (var26.framecount() ~= var656) then
				var657 = var21.is_menu_open();
				var660, var661 = var658, var659;
				var658, var659 = var21.mouse_position();
				var663 = var662;
				var662 = var22.key_state(1) == true;
				var667 = var666;
				var666 = {};
				var669 = var668;
				var668 = false;
				var664, var665 = var22.screen_size();
			end
			if (var657 and (var663 ~= nil)) then
				if ((not var663 or var669) and var662 and (var660 > var827) and (var661 > var828) and (var660 < (var827 + var829)) and (var661 < (var828 + var830))) then
					var28.rectangle(var827, var828, var829, var830, 255, 255, 255, 5);
					var668 = true;
					var827, var828 = (var827 + var658) - var660, (var828 + var659) - var661;
					if not var832 then
						var827 = var19.max(0, var19.min(var664 - var829, var827));
						var828 = var19.max(0, var19.min(var665 - var830, var828));
					end
				end
			end
			var18.insert(var666, {var827,var828,var829,var830});
			return var827, var828, var829, var830;
		end;
		return var655;
	end)().new(var53, var54, var55);
end;
local var39 = var27.open();
local var40 = var39.MyPersonaAPI.GetName();
local var41 = {round=8,name=var40,build="stable",vers="1.7"};
local var42 = var28.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0B\x00\x00\x00\x0B\x08\x06\x00\x00\x00\xA9\xAC\x77\x26\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x01\x33\x49\x44\x41\x54\x28\x53\x35\x91\xBD\x4A\x03\x51\x10\x85\xEF\x4F\x88\x91\x25\x60\x14\x35\x85\x58\xA9\x28\xDA\x08\xC1\x22\x0A\x62\x97\x07\x08\xA9\xD5\xD6\x07\xF0\x21\xB4\xB4\xD3\xD2\x32\xA6\x48\x61\x61\x23\x69\x2C\x14\x41\xB0\x51\x0B\x21\xC1\x42\xB0\x10\x7F\xD6\x80\xEE\xDD\xF5\x3B\x62\x06\x3E\xCE\xCC\x99\xB9\x73\xEF\x26\x36\x49\x92\x21\xE7\xDC\xBA\xB5\x76\x33\xCB\xB2\x37\xB8\x4A\xD3\xB4\x4D\xED\xF1\x47\x8C\x31\x29\x14\xE0\xD1\xD0\xA8\x31\x70\x8D\x9E\x42\x39\x8E\x63\x4B\x43\xFE\x22\xFE\x19\x5C\xC2\x7E\x08\x61\xD4\xB1\xA1\x4E\x6F\x1E\xDA\x6C\x7A\x8E\xA2\x28\xA3\xE1\x18\xC8\xE1\x8D\x43\xE5\x5F\xFB\x32\x6B\x24\x79\x0E\x7D\xA1\x83\x28\x52\xAF\xA1\x31\x9C\xC3\x24\xF5\x94\x36\x97\x28\x3C\x87\x56\x51\xC3\x37\x38\x44\x79\x09\x6F\x17\xB6\x78\x52\x93\x7A\x45\x6F\x7B\xC0\x50\xF4\xB8\x7E\x8E\xE1\x3C\x5A\xC1\x9F\xD0\x73\xB4\x80\x7C\x09\x8E\x95\x1C\x30\xF8\x23\xC8\x4F\x60\x81\x03\x7F\x1F\xA9\xA0\x2E\xD0\x6B\xC0\xAD\x8A\x2A\xC9\x1D\x28\xFA\xD0\xC1\xDB\x81\x65\x98\x85\x6D\xBC\x0B\xB8\x37\x5C\x35\x8C\x71\x48\xF1\x0D\x83\x08\xF0\x09\xEF\xA0\x05\x1F\xCC\xEC\xE9\x4D\xD3\xF0\x8A\x71\x84\x76\x75\x33\xC8\x8F\xA0\x08\x01\x3A\xD0\xD2\x3F\x38\x43\x92\x63\xF8\xC9\x7B\x5F\x25\xAF\xF3\x0B\x6D\xA0\x63\x78\x2F\x68\x93\xBA\x15\x42\xB8\xF9\x05\xD4\x19\x01\x8D\xAD\x75\xE9\x3B\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 11, 11);
local var43 = (function()
	local var56 = var31;
	local var57 = function(var673, var674, var675)
		return var673 + ((var674 - var673) * (var675 + 0.01));
	end;
	local var58 = function()
		return var56(var22.screen_size());
	end;
	local var59 = function(var676, ...)
		local var677 = {...};
		local var677 = var18.concat(var677, "");
		return var56(var28.measure_text(var676, var677));
	end;
	local var60 = {notifications={bottom={}},max={bottom=6}};
	var60.__index = var60;
	var60.create_new = function(...)
		var18.insert(var60.notifications.bottom, {started=false,instance=var1({active=false,timeout=5,color={r=0,g=0,b=0,a=0},x=(var58().x / 2),y=var58().y,text=...}, var60)});
	end;
	var60.handler = function(var678)
		local var679 = 0;
		local var680 = 0;
		for var834, var835 in var3(var60.notifications.bottom) do
			if (not var835.instance.active and var835.started) then
				var18.remove(var60.notifications.bottom, var834);
			end
		end
		for var836 = 1, #var60.notifications.bottom do
			if var60.notifications.bottom[var836].instance.active then
				var680 = var680 + 1;
			end
		end
		for var837, var838 in var3(var60.notifications.bottom) do
			if (var837 > var60.max.bottom) then
				return;
			end
			if var838.instance.active then
				var838.instance:render_bottom(var679, var680);
				var679 = var679 + 1;
			end
			if not var838.started then
				var838.instance:start();
				var838.started = true;
			end
		end
	end;
	var60.start = function(var681)
		var681.active = true;
		var681.delay = var26.realtime() + var681.timeout;
	end;
	var60.get_text = function(var684)
		local var685 = "";
		for var839, var839 in var3(var684.text) do
			local var840 = var59("", var839[1]);
			local var840, var841, var842 = 255, 255, 255;
			if var839[2] then
				var840, var841, var842 = var37.color[1], var37.color[2], var37.color[3];
			end
			var685 = var685 .. ("\a%02x%02x%02x%02x%s"):format(var840, var841, var842, var684.color.a, var839[1]);
		end
		return var685;
	end;
	local var66 = (function()
		local var686 = {};
		var686.rec = function(var843, var844, var845, var846, var847, var848, var849, var850, var851)
			var851 = var19.min(var843 / 2, var844 / 2, var851);
			var28.rectangle(var843, var844 + var851, var845, var846 - (var851 * 2), var847, var848, var849, var850);
			var28.rectangle(var843 + var851, var844, var845 - (var851 * 2), var851, var847, var848, var849, var850);
			var28.rectangle(var843 + var851, (var844 + var846) - var851, var845 - (var851 * 2), var851, var847, var848, var849, var850);
			var28.circle(var843 + var851, var844 + var851, var847, var848, var849, var850, var851, 180, 0.25);
			var28.circle((var843 - var851) + var845, var844 + var851, var847, var848, var849, var850, var851, 90, 0.25);
			var28.circle((var843 - var851) + var845, (var844 - var851) + var846, var847, var848, var849, var850, var851, 0, 0.25);
			var28.circle(var843 + var851, (var844 - var851) + var846, var847, var848, var849, var850, var851, -90, 0.25);
		end;
		var686.rec_outline = function(var852, var853, var854, var855, var856, var857, var858, var859, var860, var861)
			var860 = var19.min(var854 / 2, var855 / 2, var860);
			if (var860 == 1) then
				var28.rectangle(var852, var853, var854, var861, var856, var857, var858, var859);
				var28.rectangle(var852, (var853 + var855) - var861, var854, var861, var856, var857, var858, var859);
			else
				var28.rectangle(var852 + var860, var853, var854 - (var860 * 2), var861, var856, var857, var858, var859);
				var28.rectangle(var852 + var860, (var853 + var855) - var861, var854 - (var860 * 2), var861, var856, var857, var858, var859);
				var28.rectangle(var852, var853 + var860, var861, var855 - (var860 * 2), var856, var857, var858, var859);
				var28.rectangle((var852 + var854) - var861, var853 + var860, var861, var855 - (var860 * 2), var856, var857, var858, var859);
				var28.circle_outline(var852 + var860, var853 + var860, var856, var857, var858, var859, var860, 180, 0.25, var861);
				var28.circle_outline(var852 + var860, (var853 + var855) - var860, var856, var857, var858, var859, var860, 90, 0.25, var861);
				var28.circle_outline((var852 + var854) - var860, var853 + var860, var856, var857, var858, var859, var860, -90, 0.25, var861);
				var28.circle_outline((var852 + var854) - var860, (var853 + var855) - var860, var856, var857, var858, var859, var860, 0, 0.25, var861);
			end
		end;
		var686.glow_module_notify = function(var862, var863, var864, var865, var866, var867, var868, var869, var870, var871, var872, var873, var874, var875, var875)
			local var876 = 1;
			local var877 = 1;
			if var875 then
				var686.rec(var862, var863, var864, var865, var868, var869, var870, var871, var867);
			end
			for var930 = 0, var866 do
				local var931 = (var871 / 2) * ((var930 / var866) ^ 3);
				var686.rec_outline(var862 + (((var930 - var866) - var877) * var876), var863 + (((var930 - var866) - var877) * var876), var864 - (((var930 - var866) - var877) * var876 * 2), var865 - (((var930 - var866) - var877) * var876 * 2), var872, var873, var874, var931 / 1.5, var867 + (var876 * ((var866 - var930) + var877)), var876);
			end
		end;
		return var686;
	end)();
	var60.render_bottom = function(var690, var691, var692)
		local var693 = var58();
		local var694 = 16;
		local var695 = "     " .. var690:get_text();
		local var696 = var59("", var695);
		local var697 = var41.round;
		local var698, var699, var700 = var37.color[1], var37.color[2], var37.color[3];
		local var701, var702, var703 = 30, 30, 30;
		local var704 = 2;
		local var705 = 0 + var694 + var696.x;
		local var705, var706 = var705 + (var704 * 2), 23;
		local var707, var708 = var690.x - (var705 / 2), var19.ceil((var690.y - 40) + 0.4);
		local var709 = var26.frametime();
		if (var26.realtime() < var690.delay) then
			var690.y = var57(var690.y, (var693.y - var37.offset) - ((var692 - var691) * var706 * 1.5), var709 * 7);
			var690.color.a = var57(var690.color.a, (var37.blured and 125) or 255, var709 * 2);
		else
			var690.y = var57(var690.y, var690.y - 10, var709 * 15);
			var690.color.a = var57(var690.color.a, 0, var709 * 20);
			if (var690.color.a <= 1) then
				var690.active = false;
			end
		end
		local var710, var693, var691, var692 = var690.color.r, var690.color.g, var690.color.b, var690.color.a;
		if var37.blured then
			var701, var702, var703 = var698, var699, var700;
		else
			var701, var702, var703 = 20, 20, 20;
		end
		var66.glow_module_notify(var707 + 26, var708, var705 - 15, var706, 12, var697, var701, var702, var703, var692, var698, var699, var700, var692, true);
		var66.glow_module_notify(var707 - 5, var708, 25, var706, 12, var697, var701, var702, var703, var692, var698, var699, var700, var692, true);
		local var711 = var704 + 2;
		var711 = var711 + 0 + var694;
		var28.texture(var42, (var707 + var711) - 18, ((var708 + (var706 / 2)) - (var696.y / 2)) + 1, 11, 11, var698, var699, var700, var692);
		var28.text(var707 + var711, (var708 + (var706 / 2)) - (var696.y / 2), var710, var693, var691, var692, "", nil, var695);
	end;
	var22.set_event_callback("paint_ui", function()
		var60:handler();
	end);
	return var60;
end)();
var22.delay_call(1, function()
	var43.create_new({{"Welcome back, "},{var41.name,true},{" to onesense "},{var41.build,true},{(" " .. var41.vers),false}});
end);
local var44 = [[struct {char         __pad_0x0000[0x1cd]; bool         hide_vm_scope; }]];
local var45 = var22.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0");
local var46 = var25.cast("void****", var25.cast("char*", var45) + 2)[0];
local var47 = vtable_thunk(2, var44 .. "*(__thiscall*)(void*, unsigned int)");
local var48 = function()
	local var68, var69, var70 = {}, {}, {};
	var68.__metatable = false;
	var69.struct = function(var712, var713)
		assert(var14(var713) == "string", "invalid class name");
		assert(rawget(var712, var713) == nil, "cannot overwrite subclass");
		return function(var878)
			assert(var14(var878) == "table", "invalid class data");
			var7(var712, var713, var1(var878, {__metatable=false,__index=function(var936, var937)
				return rawget(var68, var937) or rawget(var70, var937);
			end}));
			return var70;
		end;
	end;
	var70 = var1(var69, var68);
	return var70;
end;
local var49 = var48():struct("globals")({states={"stand","slow walk","run","crouch","sneak","aerobic","aerobic+","manual left","manual right","fakelag","hideshots"},extended_states={"global","stand","slow walk","run","crouch","sneak","aerobic","aerobic+","manual left","manual right","fakelag","hideshots"},def_ways={"1-way","2-way","3-way","4-way","5-way"},keylist_icon=var28.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 15, 15)}):struct("ref")({aa={enabled={var21.reference("aa", "anti-aimbot angles", "enabled")},pitch={var21.reference("aa", "anti-aimbot angles", "pitch")},yaw_base={var21.reference("aa", "anti-aimbot angles", "Yaw base")},yaw={var21.reference("aa", "anti-aimbot angles", "Yaw")},yaw_jitter={var21.reference("aa", "anti-aimbot angles", "Yaw Jitter")},body_yaw={var21.reference("aa", "anti-aimbot angles", "Body yaw")},freestanding_body_yaw={var21.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},freestand={var21.reference("aa", "anti-aimbot angles", "Freestanding")},roll={var21.reference("aa", "anti-aimbot angles", "Roll")},edge_yaw={var21.reference("aa", "anti-aimbot angles", "Edge yaw")},fake_peek={var21.reference("aa", "other", "Fake peek")}},misc={log={var21.reference("misc", "miscellaneous", "Log damage dealt")},fov=var21.reference("misc", "miscellaneous", "Override FOV"),override_zf=var21.reference("misc", "miscellaneous", "Override zoom FOV")},fakelag={enable={var21.reference("aa", "fake lag", "enabled")},amount={var21.reference("aa", "fake lag", "amount")},variance={var21.reference("aa", "fake lag", "variance")},limit={var21.reference("aa", "fake lag", "limit")},lg={var21.reference("aa", "other", "Leg movement")}},aa_other={sw={var21.reference("aa", "other", "Slow motion")},hide_shots={var21.reference("aa", "other", "On shot anti-aim")}},rage={enable=var21.reference("rage", "aimbot", "Enabled"),dt={var21.reference("rage", "aimbot", "Double tap")},fd={var21.reference("rage", "other", "Duck peek assist")},os={var21.reference("aa", "other", "On shot anti-aim")},mindmg={var21.reference("rage", "aimbot", "minimum damage")},ovr={var21.reference("rage", "aimbot", "minimum damage override")}},slow_motion={var21.reference("aa", "other", "Slow motion")}}):struct("ui")({menu={global={},home={},antiaim={},tools={}},header=function(var73, var74, var75)
	local var76 = "\a373737FF";
	local var77 = "──────────────────────────";
	if not var75 then
		return var74:label(var76 .. var77);
	else
		return var74:label(var76 .. " " .. var75 .. " ");
	end
end,execute=function(var78)
	local var79 = var32.group("AA", "anti-aimbot angles");
	local var80 = var32.group("AA", "Fake lag");
	local var81 = var32.group("AA", "Other");
	local var82 = "\a808080FF•\r  ";
	var78.menu.global.title_name = var80:label("\v~⋆⋅☆⋅⋆⛧°/\r  " .. var78.helpers:limit_ch(var40, 13, "..."));
	var78.menu.global.tab = var80:combobox("\n tabs", {"home","antiaim","tools"});
	var78.menu.global.color = var80:color_picker("\naccent", 164, 210, 212, 255):depend({var78.menu.global.tab,"home"});
	var78:header(var80);
	var78.menu.global.export = var80:button("Export config", function()
		var34.set(var78.config:export("config"));
	end):depend({var78.menu.global.tab,"antiaim",true});
	var78.menu.global.import = var80:button("Import config", function()
		var78.config:import(var34.get(), "config");
	end):depend({var78.menu.global.tab,"antiaim",true});
	var78.menu.home.welcomer = var79:label("Welcome to \vonesense\r 1.6");
	var78.menu.home.space = var78:header(var79);
	var78.menu.home.list = var79:listbox("configs", {});
	var78.menu.home.list:set_callback(function()
		if var21.is_menu_open() then
			var78.config:update_name();
		end
	end);
	var78.menu.home.name = var79:textbox("config name");
	var78.menu.home.load = var79:button("Load", function()
		var78.config:load("config");
	end);
	var78.menu.home.save = var79:button("Save", function()
		var78.config:save();
	end);
	var78.menu.home.delete = var79:button("\aff0000ffDelete", function()
		var78.config:delete();
	end);
	var78.menu.home.discord_l = var81:label("\n");
	var78.menu.home.discord = var81:button("\a808080FFDiscord server\r", function()
		var39.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/zUKBpRrSss");
	end);
	var78.menu.home.youtube = var81:button("\a808080FFYoutube coder join\r", function()
		var39.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@reloadhvh");
	end);
	var78.menu.antiaim.mode = var79:combobox(var82 .. "Anti-aim tab", {"Constructor","Features"});
	var78.menu.antiaim.space = var78:header(var79):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.freestanding = var79:multiselect("Freestanding", {"Force static","Disablers"}, 0):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.freestanding_disablers = var79:multiselect("\nfreestanding disablers", var78.globals.states):depend({var78.menu.antiaim.freestanding,"Disablers"}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.edge_yaw = var79:label("Edge yaw", 0):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.manual_aa = var79:checkbox("Manual aa"):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.manual_static = var79:checkbox(var82 .. "Manual static"):depend({var78.menu.antiaim.manual_aa,true}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.manual_left = var79:hotkey(var82 .. "Manual left"):depend({var78.menu.antiaim.manual_aa,true}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.manual_right = var79:hotkey(var82 .. "Manual right"):depend({var78.menu.antiaim.manual_aa,true}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.manual_forward = var79:hotkey(var82 .. "Manual forward"):depend({var78.menu.antiaim.manual_aa,true}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.fakelag_type = var80:combobox("Fake lag type", {"Maximum","Dynamic","Fluctuate"}):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.fakelag_var = var80:slider(var82 .. "Variance", 0, 100, 100, true, "%"):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.fakelag_lim = var80:slider(var82 .. "Limit", 1, 15, 15):depend({var78.menu.antiaim.mode,"Features"});
	var78.menu.antiaim.state = var79:combobox("\n current condition", var78.globals.extended_states):depend({var78.menu.antiaim.mode,"Constructor"});
	var78.menu.antiaim.states = {};
	for var714, var715 in var2(var78.globals.extended_states) do
		var78.menu.antiaim.states[var715] = {};
		local var717 = var78.menu.antiaim.states[var715];
		if (var715 ~= "global") then
			var717.enable = var79:checkbox("Activate \v" .. var715);
		end
		local var718 = "\n" .. var715;
		var717.options = var81:multiselect(var82 .. "Features" .. var718, {"Enable defensive","Avoid backstab","Safe head"});
		var717.head_1 = var78:header(var81);
		var717.defensive_conditions = var81:multiselect("Defensive triggers" .. var718, {"Always","Tick-Base","On weapon switch","On reload","On hittable","On freestand"}):depend({var717.options,"Enable defensive"});
		var717.defensive_conditions_tick = var81:slider("\n Tick" .. var718, 1, 15, 8, true, "t", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_conditions,"Tick-Base"});
		var717.defensive_yaw = var79:checkbox("Defensive yaw" .. var718):depend({var717.options,"Enable defensive"});
		var717.defensive_yaw_mode = var79:combobox("\ndefensive yaw mode" .. var718, {"Jitter","Random","Custom spin","Spin-way","Switch 5-way"}):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true});
		var717.defensive_yaw_1_random = var79:slider("\n 1 random yaw def" .. var718, -359, 359, 180, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Random"});
		var717.defensive_yaw_2_random = var79:slider("\n 2 random yaw def" .. var718, -359, 359, -180, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Random"});
		var717.defensive_yaw_1_Spin_way = var79:slider("\n 1 stage Spin-way" .. var718, -180, 180, -180, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Spin-way"});
		var717.defensive_yaw_2_Spin_way = var79:slider("\n 2 stage Spin-way" .. var718, -180, 180, 180, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Spin-way"});
		var717.defensive_yaw_speed_Spin_way = var79:slider(var82 .. "Delay" .. var718, 0, 16, 6, true, "t", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Spin-way"});
		var717.defensive_yaw_randomizer_Spin_way = var79:slider(var82 .. "Randomizer" .. var718, 0, 180, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Spin-way"});
		var717.defensive_yaw_jitter_radius_1 = var79:slider("\n JiTter 1" .. var718, -180, 180, 30, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Jitter"});
		var717.defensive_yaw_jitter_delay = var79:slider(var82 .. "Delayed" .. var718, 1, 12, 6, true, "t", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Jitter"});
		var717.defensive_yaw_jitter_random = var79:slider(var82 .. "Randomize" .. var718, 0, 180, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Jitter"});
		for var879 = 1, 5 do
			var717["defensive_yaw_way_switch" .. var879] = var79:slider("\n way-" .. var879 .. var718, 0, 360, 30, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"});
		end
		var717.defensive_yaw_way_randomly = var79:checkbox(var82 .. "Increase yaw (random) " .. var718):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"});
		var717.defensive_yaw_way_randomly_value = var79:slider("\n ramdom yaw value" .. var718, 0, 360, 20, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"}, {var717.defensive_yaw_way_randomly,true});
		var717.defensive_yaw_way_delay = var79:slider(var82 .. "Interpolation (delay)" .. var718, 0, 16, 4, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"});
		var717.defensive_yaw_wayspin_combo = var79:combobox(var82 .. "Select spin way yaw" .. var718, var78.globals.def_ways):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"});
		for var881 = 1, 5 do
			local var882 = var881 .. "-way";
			var717["defensive_yaw_enable_way_spin" .. var881] = var79:checkbox("Enable spin \n " .. var881 .. var718):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"}, {var717.defensive_yaw_wayspin_combo,var882});
			var717["defensive_yaw_way_spin_limit" .. var881] = var79:slider("\n limit  way-" .. var881 .. " " .. var718, 0, 360, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"}, {var717["defensive_yaw_enable_way_spin" .. var881],true}, {var717.defensive_yaw_wayspin_combo,var882});
			var717["defensive_yaw_way_speed" .. var881] = var79:slider("\n speed way-" .. var881 .. " " .. var718, 1, 12, 8, true, "t", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Switch 5-way"}, {var717["defensive_yaw_enable_way_spin" .. var881],true}, {var717.defensive_yaw_wayspin_combo,var882});
		end
		var717.defensive_yaw_spin_limit = var79:slider("\n limit spin yaw" .. var718, 15, 360, 360, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}):depend({var717.defensive_yaw_mode,"Custom spin"});
		var717.defensive_yaw_speedtick = var79:slider("\n spin speed" .. var718, 1, 12, 6, true, "t", 0.5):depend({var717.options,"Enable defensive"}, {var717.defensive_yaw,true}, {var717.defensive_yaw_mode,"Custom spin"});
		var717.defensive_pitch_enable = var80:checkbox("Defensive pitch" .. var718):depend({var717.options,"Enable defensive"});
		var717.defensive_pitch_mode = var80:combobox("\n defensive pitch mode" .. var718, {"Static","Spin","Random","Clocking","Jitter","5way"}):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true});
		var717.defensive_pitch_custom = var80:slider("\n pitch custom limit" .. var718, -89, 89, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"Clocking",true});
		var717.defensive_pitch_spin_random2 = var80:slider("\n pitch def random2" .. var718, -89, 89, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"Random"});
		var717.defensive_pitch_spin_limit2 = var80:slider("\n spin speed 2" .. var718, -89, 89, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"Spin"});
		var717.defensive_pitch_speedtick = var80:slider("\n spin speed" .. var718, 1, 64, 32, true, "t", 0.1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"Spin"});
		var717.defensive_pitch_way_label = var80:label(var82 .. "On \var5-way\r yaw to more \vsettings"):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}, {var717.defensive_yaw_mode,"Switch 5-way",true});
		for var886 = 2, 5 do
			var717["defensive_pitch_way" .. var886] = var80:slider("\n pitch way " .. var886 .. var718, -89, 89, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
		end
		var717.defensive_pitch_way_randomly = var80:checkbox(var82 .. "Increase pitch (random) " .. var718):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
		var717.defensive_pitch_way_randomly_value = var80:slider("\n ramdom pitch value" .. var718, 0, 89, 20, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}, {var717.defensive_pitch_way_randomly,true}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
		var717.defensive_pitch_way_spin_combo = var80:combobox(var82 .. "Select spin way pitch" .. var718, var78.globals.def_ways):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
		for var888 = 1, #var78.globals.def_ways do
			local var889 = var78.globals.def_ways[var888];
			var717["defensive_pitch_enable_way_spin" .. var888] = var80:checkbox("Enable spin \n " .. var888 .. var718):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}, {var717.defensive_pitch_way_spin_combo,var889}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
			for var939 = 1, 2 do
				var717["defensive_pitch_way_spin_limit" .. var888 .. var939] = var80:slider("\n limit  way-" .. var888 .. var939 .. " " .. var718, -89, 89, 89, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717["defensive_pitch_enable_way_spin" .. var888],true}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}, {var717.defensive_pitch_way_spin_combo,var889}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
			end
			var717["defensive_pitch_way_speed" .. var888] = var80:slider("\n speed way-" .. var888 .. " " .. var718, 1, 12, 8, true, "t", 1):depend({var717.options,"Enable defensive"}, {var717["defensive_pitch_enable_way_spin" .. var888],true}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"5way"}, {var717.defensive_pitch_way_spin_combo,var889}):depend({var717.defensive_yaw_mode,"Switch 5-way"});
		end
		var717.defensive_pitch_clock = var80:slider("\n pitch clock limit" .. var718, -89, 89, 0, true, "°", 1):depend({var717.options,"Enable defensive"}, {var717.defensive_pitch_enable,true}, {var717.defensive_pitch_mode,"Jitter"});
		var717.head_2 = var78:header(var79);
		var717.yaw_base = var79:combobox(var82 .. "Yaw" .. var718, {"At targets","Local view"});
		var717.yaw_jitter = var79:combobox("\nyaw jitter" .. var718, {"Off","Offset","Center","Skitter","Smoothnes","Fractal","Random"});
		var717.yaw_jitter_add = var79:slider("\nyaw jitter add" .. var718, -90, 90, 0, true, "°", 1):depend({var717.yaw_jitter,"Off",true});
		var717.yaw_fractals = var79:slider(var82 .. "Fractals" .. var718, 1, 14, 0, true, "°", 1, {[14]="Random"}):depend({var717.yaw_jitter,"Off",true}, {var717.yaw_jitter,"Fractal"});
		var717.yaw_add = var79:slider(var82 .. "Yaw add \v(L/R)" .. var718, -180, 180, 0, true, "°", 1);
		var717.yaw_add_r = var79:slider("\n yaw add (R)" .. var718, -180, 180, 0, true, "°", 1);
		var717.jitter_delay = var79:slider(var82 .. "Yaw delay" .. var718, 0, 4, 0, true, "x", 1, {[1]="Randomly",[0]="Off"});
		var717.yaw_random = var79:slider(var82 .. "Yaw randomize" .. var718, 0, 100, 0, true, "%", 1):depend({var717.yaw_jitter,"Off",true});
		var717.head_3 = var78:header(var79);
		var717.body_yaw = var79:combobox(var82 .. "Body yaw" .. var718, {"Off","Opposite","Static","Jitter"});
		var717.body_yaw_side = var79:combobox("\n Body yaw side" .. var718, {"Left","Right","Freestanding"}):depend({var717.body_yaw,"Static",false});
		for var892, var893 in var3(var717) do
			local var894 = {{var78.menu.antiaim.state,var715},{var78.menu.antiaim.mode,"Constructor"}};
			if ((var892 ~= "enable") and (var715 ~= "global")) then
				var894 = {{var78.menu.antiaim.state,var715},{var78.menu.antiaim.mode,"Constructor"},{var717.enable,true}};
			end
			var893:depend(var18.unpack(var894));
		end
	end
	var78.menu.antiaim.export = var81:button("Export condition", function()
		data = var78.config:export("state", var78.menu.antiaim.state:get());
		var34.set(data);
	end):depend({var78.menu.antiaim.mode,"Constructor"});
	var78.menu.antiaim.import = var81:button("Import condition ", function()
		local var763 = var34.get();
		local var764 = var763:match("{onesense:(.+)}");
		var78.config:import(var763, var764, var78.menu.antiaim.state:get());
	end):depend({var78.menu.antiaim.mode,"Constructor"});
	var78.menu.tools.subtub = var79:combobox(var82 .. "Active tab", {"Rage-Misc","Visuals"});
	var78.menu.tools.subtub_n = var79:label("\n");
	local var117 = var78.menu.tools.subtub;
	var78.menu.tools.indicators = var79:checkbox("Crosshair indicators"):depend({var117,"Visuals"});
	var78.menu.tools.indicator_pos = var79:combobox("\n position ind", {"Left","Right"}):depend({var78.menu.tools.indicators,true}):depend({var117,"Visuals"});
	var78.menu.tools.indicatorfont = var79:combobox(var82 .. "Indicator style", {"Default","New","Renewed","Onesense"}):depend({var78.menu.tools.indicators,true}):depend({var117,"Visuals"});
	var78.menu.tools.indicator_bind = var79:checkbox(var82 .. "Show binds"):depend({var78.menu.tools.indicators,true}, {var117,"Visuals"}, {var78.menu.tools.indicatorfont,"Onesense"});
	var78.menu.tools.indicatoroffset = var79:slider("\n Offset indcator ", 0, 90, 35, true, "px"):depend({var78.menu.tools.indicators,true}):depend({var117,"Visuals"});
	var78.menu.tools.manuals = var79:checkbox("Manual arrows"):depend({var117,"Visuals"});
	var78.menu.tools.manuals_style = var79:combobox("\n arrows style", {"Onesense","New"}):depend({var117,"Visuals"}, {var78.menu.tools.manuals,true});
	var78.menu.tools.manuals_global = var79:checkbox("Arrows side"):depend({var117,"Visuals"}, {var78.menu.tools.manuals,true});
	var78.menu.tools.manuals_offset = var79:slider("\n arrows offset", 0, 100, 15, true, "px"):depend({var117,"Visuals"}, {var78.menu.tools.manuals,true});
	var78.menu.tools.animscope = var79:checkbox("Animated scope"):depend({var117,"Visuals"});
	var78.menu.tools.animscope_fov_slider = var79:slider(var82 .. "Fov value", 105, 135, 130, true, "%", 1):depend({var78.menu.tools.animscope,true}):depend({var117,"Visuals"});
	var78.menu.tools.animscope_slider = var79:slider("\n Anim scope value", 0, 100, 5, true, "%", 1):depend({var78.menu.tools.animscope,true}):depend({var117,"Visuals"});
	var78.menu.tools.animscope_speed = var79:slider(var82 .. "Speed", 6, 12, 8, true, "", 1):depend({var78.menu.tools.animscope,true}):depend({var117,"Visuals"});
	var78.menu.tools.indicator_dmg = var79:checkbox("Damage indicator"):depend({var117,"Visuals"});
	var78.menu.tools.indicator_dmg_color = var79:color_picker("\ncolor dmg", 255, 255, 255):depend({var78.menu.tools.indicator_dmg,true}):depend({var117,"Visuals"});
	var78.menu.tools.indicator_dmg_weapon = var79:checkbox(var82 .. "Only min damage"):depend({var78.menu.tools.indicator_dmg,true}):depend({var117,"Visuals"});
	var78.menu.tools.visual_head_1 = var79:label("\n"):depend({var117,"Visuals"});
	var78.menu.tools.watermark = var79:checkbox("Watermark"):depend({var117,"Visuals"});
	var78.menu.tools.keylist = var79:checkbox("Keylist"):depend({var117,"Visuals"});
	var78.menu.tools.notify_master = var79:checkbox("Logging"):depend({var117,"Visuals"});
	var78.menu.tools.notify_vibor = var79:multiselect("\n Log type", {"New style","Hit","Miss","Get harmed","Detect shot","Preview"}):depend({var78.menu.tools.notify_master,true}):depend({var117,"Visuals"});
	var78.menu.tools.notify_offset = var79:slider("\n Offset notifys ", 0, 900, 45, true, "px", 1):depend({var78.menu.tools.notify_master,true}):depend({var117,"Visuals"});
	var78.menu.tools.notify_test = var79:button("Preview logg", function()
		var43.create_new({{"Example: "},{"logging ",true},{"12345"}});
	end):depend({var78.menu.tools.notify_vibor,"Preview"}, {var78.menu.tools.notify_master,true}):depend({var117,"Visuals"});
	var78.menu.tools.visual_head_2 = var79:label("\n"):depend({var117,"Visuals"});
	var78.menu.tools.gs_ind = var79:checkbox("Indicators left gs"):depend({var117,"Visuals"});
	var78.menu.tools.gs_inds = var79:multiselect("\n inds selc", {"Target","..."}):depend({var117,"Visuals"}, {var78.menu.tools.gs_ind,true});
	var78.menu.tools.viewmodel_on = var79:checkbox("Viewmodel modifier"):depend({var117,"Visuals"});
	var78.menu.tools.viewmodel_scope = var79:checkbox("Show weapon scoped"):depend({var117,"Visuals"});
	var78.menu.tools.viewmodel_mod = var79:combobox("\nstyleview", {"Without-scope","In-scope"}):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true});
	var78.menu.tools.viewmodel_x1 = var79:slider("\nviewwithoscope-x", -100, 100, 0, true, "x", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"Without-scope"});
	var78.menu.tools.viewmodel_y1 = var79:slider("\nviewwithoscope-y", -100, 100, -5, true, "y", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"Without-scope"});
	var78.menu.tools.viewmodel_z1 = var79:slider("\nviewwithoscope-z", -100, 100, -1, true, "z", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"Without-scope"});
	var78.menu.tools.viewmodel_fov1 = var79:slider(var82 .. "Fov\n without scope", 0, 170, 61, true, "x", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"Without-scope"});
	var78.menu.tools.viewmodel_inscope = var79:checkbox("Viewmodel scope"):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"In-scope"});
	var78.menu.tools.viewmodel_x2 = var79:slider("\nview with x", -100, 100, -4, true, "x", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"In-scope"}, {var78.menu.tools.viewmodel_inscope,true});
	var78.menu.tools.viewmodel_y2 = var79:slider("\nview with y", -100, 100, -5, true, "y", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"In-scope"}, {var78.menu.tools.viewmodel_inscope,true});
	var78.menu.tools.viewmodel_z2 = var79:slider("\nview with z", -100, 100, -1, true, "z", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"In-scope"}, {var78.menu.tools.viewmodel_inscope,true});
	var78.menu.tools.viewmodel_fov2 = var79:slider(var82 .. "Fov\n with ov", 0, 170, 61, true, "x", 1):depend({var117,"Visuals"}, {var78.menu.tools.viewmodel_on,true}, {var78.menu.tools.viewmodel_mod,"In-scope"}, {var78.menu.tools.viewmodel_inscope,true});
	var78.menu.tools.air_stop = var79:checkbox("Jumpscout", 0):depend({var117,"Rage-Misc"});
	var78.menu.tools.air_stop_distance = var79:slider("\n Distance", 1, 25, 2, true, "ft", 5, {[25]="Always"}):depend({var117,"Rage-Misc"}, {var78.menu.tools.air_stop,true});
	var78.menu.tools.unsafe_charge = var79:checkbox("Unsafe charge"):depend({var117,"Rage-Misc"});
	var78.menu.tools.m1sc_head_2 = var79:label("\n"):depend({var117,"Rage-Misc"});
	var78.menu.tools.fast_ladder = var79:checkbox("Fast ladder"):depend({var117,"Rage-Misc"});
	var78.menu.tools.trashtalk = var79:checkbox("Trashtalk"):depend({var117,"Rage-Misc"});
	var78.menu.tools.trashtalk_type = var79:combobox("\n trashtalk type", {"Default type","Custom phrase","1 MOD"}):depend({var78.menu.tools.trashtalk,true}):depend({var117,"Rage-Misc"});
	var78.menu.tools.trashtalk_check2 = var79:checkbox(var82 .. "with player name (enemy)"):depend({var78.menu.tools.trashtalk,true}, {var78.menu.tools.trashtalk_type,"1 MOD"}):depend({var117,"Rage-Misc"});
	var78.menu.tools.trashtalk_custom = var79:textbox("\n phrase"):depend({var78.menu.tools.trashtalk,true}, {var78.menu.tools.trashtalk_type,"Custom phrase"}):depend({var117,"Rage-Misc"});
	var78.menu.tools.animations = var79:checkbox("Animations breakers"):depend({var117,"Rage-Misc"});
	var78.menu.tools.animations_selector = var79:multiselect("\n Animations", {"Reset pitch on land","Body lean","Static legs","Jitter air","Jitter ground","Kangaroo","Moonwalk","Yaw break","Pitch break"}):depend({var78.menu.tools.animations,true}):depend({var117,"Rage-Misc"});
	var78.menu.tools.animations_body = var79:slider("\n Body lean ", 0, 100, 74, true, ""):depend({var78.menu.tools.animations,true}):depend({var78.menu.tools.animations_selector,"Body lean"}):depend({var117,"Rage-Misc"});
	var78.menu.tools.autobuy = var79:checkbox("Auto buy"):depend({var117,"Rage-Misc"});
	var78.menu.tools.autobuy_v = var79:combobox("\n auto buy vibor", {"Awp","Scar/g3sg1","Scout"}):depend({var78.menu.tools.autobuy,true}):depend({var117,"Rage-Misc"});
	for var765, var766 in var3(var78.menu) do
		if ((var14(var766) == "table") and (var765 ~= "global")) then
			function Loop(var961, var962)
				for var998, var999 in var3(var961) do
					if (var14(var999) == "table") then
						if (var999.__type == "pui::element") then
							var999:depend({var78.menu.global.tab,var962});
						else
							Loop(var999, var962);
						end
					end
				end
			end
			Loop(var766, var765);
		end
	end
end,shutdown=function(var170)
	var170.helpers:menu_visibility(true);
end}):struct("helpers")({anim={},contains=function(var171, var172, var173)
	for var767, var768 in var3(var172) do
		if (var768 == var173) then
			return true;
		end
	end
	return false;
end,lerp=function(var174, var175, var176, var177)
	local var178 = var175 + ((var176 - var175) * var177);
	return var12(var20.format("%.3f", var178));
end,math_anim2=function(var179, var180, var181, var182)
	return var179:lerp(var180, var181, var26.absoluteframetime() * (var182 or 8));
end,new_anim=function(var183, var184, var185, var186)
	if (var183.anim[var184] == nil) then
		var183.anim[var184] = var185;
	end
	local var187 = var183:math_anim2(var183.anim[var184], var185, var186);
	local var188 = 0.10000000149011612;
	if (var19.abs(var187) < var188) then
		var187 = 0;
	end
	var183.anim[var184] = var187;
	return var183.anim[var184];
end,rgba_to_hex=function(var190, var191, var192, var193, var194)
	return var29.tohex((var19.floor(var191 + 0.5) * 16777216) + (var19.floor(var192 + 0.5) * 65536) + (var19.floor(var193 + 0.5) * 256) + (var19.floor(var194 + 0.5)));
end,limit_ch=function(var195, var196, var197, var198)
	local var199 = {};
	local var200 = 1;
	for var769 in var20.gmatch(var196, ".[\x80-\xBF]*") do
		var200, var199[var200] = var200 + 1, var769;
		if (var197 < var200) then
			if var198 then
				var199[var200] = ((var198 == true) and "...") or var198;
			end
			break;
		end
	end
	return var18.concat(var199);
end,animate_pulse=function(var201, var202, var203)
	local var204, var205, var206, var207 = var15(var202);
	local var208 = var204 * var19.abs(var19.cos(var26.curtime() * var203));
	local var209 = var205 * var19.abs(var19.cos(var26.curtime() * var203));
	local var210 = var206 * var19.abs(var19.cos(var26.curtime() * var203));
	local var211 = var207 * var19.abs(var19.cos(var26.curtime() * var203));
	return var208, var209, var210, var211;
end,animate_text=function(var212, var213, var214, var215, var216, var217, var218)
	local var219, var220 = {}, 1;
	local var221 = var214:len() - 1;
	local var222 = 255 - var215;
	local var223 = 255 - var216;
	local var224 = 255 - var217;
	local var225 = 155 - var218;
	for var771 = 1, #var214 do
		local var772 = ((var771 - 1) / (#var214 - 1)) + var213;
		var219[var220] = "\a" .. var212:rgba_to_hex(var215 + (var222 * var19.abs(var19.cos(var772))), var216 + (var223 * var19.abs(var19.cos(var772))), var217 + (var224 * var19.abs(var19.cos(var772))), var218 + (var225 * var19.abs(var19.cos(var772))));
		var219[var220 + 1] = var214:sub(var771, var771);
		var220 = var220 + 2;
	end
	return var219;
end,clamp=function(var226, var227, var228, var229)
	assert(var227 and var228 and var229, "not very useful error message here");
	if (var228 > var229) then
		var228, var229 = var229, var228;
	end
	return var19.max(var228, var19.min(var229, var227));
end,rounded_side_v=function(var230, var231, var232, var233, var234, var235, var236, var237, var238, var239, var240, var241)
	var231, var232, var233, var234, var239 = var231 * 1, var232 * 1, var233 * 1, var234 * 1, (var239 or 0) * 1;
	var240, var241 = var240 or false, var241 or false;
	local var242 = var235;
	local var243 = var236;
	local var244 = var237;
	local var245 = var238;
	var28.rectangle(var231 + var239, var232, var233 - var239, var234, var242, var243, var244, var245);
	if var240 then
		var28.circle(var231 + var239, var232 + var239, var242, var243, var244, var245, var239, 180, 0.25);
		var28.circle(var231 + var239, (var232 + var234) - var239, var242, var243, var244, var245, var239, 270, 0.25);
		var28.rectangle(var231, var232 + var239, (var233 - var233) + var239, (var234 - var239) - var239, var242, var243, var244, var245);
	end
	if var241 then
		var28.circle(var231 + var233, var232 + var239, var242, var243, var244, var245, var239, 90, 0.25);
		var28.circle(var231 + var233, (var232 + var234) - var239, var242, var243, var244, var245, var239, 0, 0.25);
		var28.rectangle(var231 + var233, var232 + var239, (var233 - var233) + var239, (var234 - var239) - var239, var242, var243, var244, var245);
	end
end,get_camera_pos=function(var246, var247)
	local var248, var249, var250 = var24.get_prop(var247, "m_vecOrigin");
	if (var248 == nil) then
		return;
	end
	local var251, var251, var252 = var24.get_prop(var247, "m_vecViewOffset");
	var250 = var250 + (var252 - (var24.get_prop(var247, "m_flDuckAmount") * 16));
	return var248, var249, var250;
end,fired_shot=function(var253, var254, var255, var256)
	local var257 = {var253:get_camera_pos(var255)};
	if (var257[1] == nil) then
		return;
	end
	local var258 = {var24.hitbox_position(var254, 0)};
	local var259 = {(var258[1] - var257[1]),(var258[2] - var257[2]),(var258[3] - var257[3])};
	local var260 = {(var256[1] - var257[1]),(var256[2] - var257[2]),(var256[3] - var257[3])};
	local var261 = ((var259[1] * var260[1]) + (var259[2] * var260[2]) + (var259[3] * var260[3])) / (var19.pow(var260[1], 2) + var19.pow(var260[2], 2) + var19.pow(var260[3], 2));
	local var262 = {(var257[1] + (var260[1] * var261)),(var257[2] + (var260[2] * var261)),(var257[3] + (var260[3] * var261))};
	local var263 = var19.abs(var19.sqrt(var19.pow(var258[1] - var262[1], 2) + var19.pow(var258[2] - var262[2], 2) + var19.pow(var258[3] - var262[3], 2)));
	local var264 = var22.trace_line(var255, var256[1], var256[2], var256[3], var258[1], var258[2], var258[3]);
	local var265 = var22.trace_line(var254, var262[1], var262[2], var262[3], var258[1], var258[2], var258[3]);
	return (var263 < 69) and ((var264 > 0.99) or (var265 > 0.99));
end,get_damage=function(var266)
	local var267 = var21.get(var266.ref.rage.mindmg[1]);
	if (var21.get(var266.ref.rage.ovr[1]) and var21.get(var266.ref.rage.ovr[2])) then
		return var21.get(var266.ref.rage.ovr[3]);
	else
		return var267;
	end
end,normalize_yaw=function(var268, var269)
	var269 = var269 % 360;
	var269 = (var269 + 360) % 360;
	if (var269 > 180) then
		var269 = var269 - 360;
	end
	return var269;
end,normalize_pitch=function(var270, var271)
	return var270:clamp(var271, -89, 89);
end,distance=function(var272, var273, var274, var275, var276, var277, var278)
	return var19.sqrt(((var276 - var273) ^ 2) + ((var277 - var274) ^ 2) + ((var278 - var275) ^ 2));
end,flags={HIT={11,2048}},entity_has_flag=function(var279, var280, var281)
	if (not var280 or not var281) then
		return false;
	end
	local var282 = var279.flags[var281];
	if (var282 == nil) then
		return false;
	end
	local var283 = var24.get_esp_data(var280) or {};
	return var29.band(var283.flags or 0, var29.lshift(1, var282[1])) == var282[2];
end,menu_visibility=function(var284, var285)
	local var286 = {var284.ref.aa,var284.ref.fakelag,var284.ref.aa_other};
	for var775, var776 in var2(var286) do
		for var896, var897 in var3(var776) do
			for var941, var942 in var2(var897) do
				var21.set_visible(var942, var285);
			end
		end
	end
	var21.set_enabled(var284.ref.misc.log[1], var285);
	var21.set_enabled(var284.ref.misc.override_zf, var285);
	var21.set(var284.ref.misc.log[1], false);
end,in_air=function(var287, var288)
	local var289 = var24.get_prop(var288, "m_fFlags");
	return var29.band(var289, 1) == 0;
end,in_duck=function(var290, var291)
	local var292 = var24.get_prop(var291, "m_fFlags");
	return var29.band(var292, 4) == 4;
end,get_state=function(var293)
	local var294 = var24.get_local_player();
	local var295 = var24.get_prop(var294, "m_vecVelocity");
	local var296 = var31(var295):length2d();
	local var297 = var293:in_duck(var294) or var21.get(var293.ref.rage.fd[1]);
	local var298 = var293.ui.menu.antiaim.states;
	local var299 = var293.antiaim:get_manual();
	local var300 = var21.get(var293.ref.rage.dt[1]) and var21.get(var293.ref.rage.dt[2]);
	local var301 = var21.get(var293.ref.rage.os[1]) and var21.get(var293.ref.rage.os[2]);
	local var302 = var21.get(var293.ref.rage.fd[1]);
	local var303 = "global";
	if (var296 > 1.5) then
		if var298['run'].enable() then
			var303 = "run";
		end
	elseif var298['stand'].enable() then
		var303 = "stand";
	end
	if var293:in_air(var294) then
		if var297 then
			if var298["aerobic+"].enable() then
				var303 = "aerobic+";
			end
		elseif var298['aerobic'].enable() then
			var303 = "aerobic";
		end
	elseif (var297 and (var296 > 1.5) and var298['sneak'].enable()) then
		var303 = "sneak";
	elseif ((var296 > 1) and var21.get(var293.ref.slow_motion[1]) and var21.get(var293.ref.slow_motion[2]) and var298["slow walk"].enable()) then
		var303 = "slow walk";
	elseif ((var299 == -90) and var298["manual left"].enable()) then
		var303 = "manual left";
	elseif ((var299 == 90) and var298["manual right"].enable()) then
		var303 = "manual right";
	elseif (var297 and var298['crouch'].enable()) then
		var303 = "crouch";
	end
	if var296 then
		if (var298['fakelag'].enable() and ((not var300 and not var301) or var302)) then
			var303 = "fakelag";
		end
		if (var298['hideshots'].enable() and var301 and not var300 and not var302) then
			var303 = "hideshots";
		end
	end
	return var303;
end}):struct("config")({configs={},write_file=function(var304, var305, var306)
	if (not var306 or (var14(var305) ~= "string")) then
		return;
	end
	return var10(var305, json.stringify(var306));
end,update_name=function(var307)
	local var308 = var307.ui.menu.home.list();
	local var309 = 0;
	for var777, var778 in var3(var307.configs) do
		if (var308 == var309) then
			return var307.ui.menu.home.name(var777);
		end
		var309 = var309 + 1;
	end
end,update_configs=function(var310)
	local var311 = {};
	for var779, var780 in var3(var310.configs) do
		var18.insert(var311, var779);
	end
	if (#var311 > 0) then
		var310.ui.menu.home.list:update(var311);
	end
	var310:write_file("onesense_configs.txt", var310.configs);
	var310:update_name();
end,setup=function(var312)
	local var313 = var9("onesense_configs.txt");
	if (var313 == nil) then
		return;
	end
	var312.configs = json.parse(var313);
	var312:update_configs();
	var312:update_name();
end,export_config=function(var315, ...)
	local var316 = var315.ui.menu.home.name();
	local var317 = var32.setup({var315.ui.menu.global,var315.ui.menu.antiaim,var315.ui.menu.tools});
	local var318 = var317:save();
	local var319 = var33.encode(json.stringify(var318));
	print("Succsess cfg export");
	return var319;
end,export_state=function(var320, var321)
	local var322 = var32.setup({var320.ui.menu.antiaim.states[var321]});
	local var321 = var320.ui.menu.antiaim.state:get();
	local var323 = var322:save();
	local var324 = var33.encode(json.stringify(var323));
	var43.create_new({{"Condition "},{var321,true},{" export"}});
	return var324;
end,export=function(var325, var326, ...)
	local var327, var328 = var16(var325["export_" .. var326], var325, ...);
	if not var327 then
		print(var328);
		return;
	end
	print("Succsess");
	return "{onesense:" .. var326 .. "}:" .. var328;
end,import_config=function(var329, var330)
	local var331 = json.parse(var33.decode(var330));
	local var332 = var32.setup({var329.ui.menu.global,var329.ui.menu.antiaim,var329.ui.menu.tools});
	var332:load(var331);
	var43.create_new({{"Cfg import"},{"!",true}});
end,import_state=function(var333, var334, var335)
	local var336 = json.parse(var33.decode(var334));
	local var337 = var32.setup({var333.ui.menu.antiaim.states[var335]});
	var337:load(var336);
	var43.create_new({{"Condition import"},{"!",true}});
end,import=function(var338, var339, var340, ...)
	local var341 = var339:match("{onesense:(.+)}");
	if (not var341 or (var341 ~= var340)) then
		var43.create_new({{"Error: "},{"This not onesense config",true}});
		return var0("This not onesense config");
	end
	local var342, var343 = var16(var338["import_" .. var341], var338, var339:gsub("{onesense:" .. var341 .. "}:", ""), ...);
	if not var342 then
		print(var343);
		var43.create_new({{"Error: "},{"Failed data onesense",true}});
		return var0("Failed data onesense");
	end
end,save=function(var344)
	local var345 = var344.ui.menu.home.name();
	if (var345:match("%w") == nil) then
		var43.create_new({{"Invalid config "},{"name",true}});
		return print("Invalid config name");
	end
	local var346 = var344:export("config");
	var344.configs[var345] = var346;
	var43.create_new({{"Saved cfg "},{var345,true}});
	var344:update_configs();
end,load=function(var348, var349)
	local var350 = var348.ui.menu.home.name();
	local var351 = var348.configs[var350];
	if not var351 then
		var43.create_new({{"Invalid cfg "},{"name",true}});
		return var0("Inval. cfg name");
	end
	var348:import(var351, var349);
	var43.create_new({{"Loaded cfg "},{var350,true}});
end,delete=function(var352)
	local var353 = var352.ui.menu.home.name();
	local var354 = var352.configs[var353];
	if not var354 then
		return var0("Invalid config name");
	end
	var352.configs[var353] = nil;
	var43.create_new({{"Delete cfg "},{var353,true}});
	var352:update_configs();
end}):struct("antiaim")({side=0,last_rand=0,skitter_counter=0,last_skitter=0,cycle=0,manual_side=0,anti_backstab=function(var356)
	local var357 = var24.get_local_player();
	local var358 = var22.current_threat();
	if ((var357 == nil) or not var24.is_alive(var357)) then
		return false;
	end
	if not var358 then
		return false;
	end
	local var359 = var24.get_player_weapon(var358);
	if not var359 then
		return false;
	end
	local var360 = var24.get_classname(var359);
	if not var360:find("Knife") then
		return false;
	end
	local var361 = var31(var24.get_origin(var357));
	local var362 = var31(var24.get_origin(var358));
	local var363 = 168;
	return var362:dist2d(var361) < var363;
end,get_best_side=function(var364, var365)
	local var366 = var24.get_local_player();
	local var367 = var31(var22.eye_position());
	local var368 = var22.current_threat();
	local var369, var370 = var22.camera_angles();
	local var371;
	if var368 then
		var371 = var31(var24.get_origin(var368)) + var31(0, 0, 64);
		var369, var370 = (var371 - var367):angles();
	end
	local var372 = {60,45,30,-30,-45,-60};
	local var373 = {left=0,right=0};
	for var781, var782 in var2(var372) do
		local var783 = var31():init_from_angles(0, var370 + 180 + var782, 0);
		if var368 then
			local var943 = var367 + var783:scaled(128);
			local var944, var945 = var22.trace_bullet(var368, var371.x, var371.y, var371.z, var943.x, var943.y, var943.z, var366);
			var373[((var782 < 0) and "left") or "right"] = var373[((var782 < 0) and "left") or "right"] + var945;
		else
			local var947 = var367 + var783:scaled(8192);
			local var948 = var22.trace_line(var366, var367.x, var367.y, var367.z, var947.x, var947.y, var947.z);
			var373[((var782 < 0) and "left") or "right"] = var373[((var782 < 0) and "left") or "right"] + var948;
		end
	end
	if (var373.left == var373.right) then
		return 2;
	elseif (var373.left > var373.right) then
		return (var365 and 1) or 0;
	else
		return (var365 and 0) or 1;
	end
end,get_manual=function(var374)
	local var375 = var24.get_local_player();
	if ((var375 == nil) or not var374.ui.menu.antiaim.manual_aa:get()) then
		return;
	end
	local var376 = var374.ui.menu.antiaim.manual_left:get();
	local var377 = var374.ui.menu.antiaim.manual_right:get();
	local var378 = var374.ui.menu.antiaim.manual_forward:get();
	if (var374.last_forward == nil) then
		var374.last_forward, var374.last_right, var374.last_left = var378, var377, var376;
	end
	if (var376 ~= var374.last_left) then
		if (var374.manual_side == 1) then
			var374.manual_side = nil;
		else
			var374.manual_side = 1;
		end
	end
	if (var377 ~= var374.last_right) then
		if (var374.manual_side == 2) then
			var374.manual_side = nil;
		else
			var374.manual_side = 2;
		end
	end
	if (var378 ~= var374.last_forward) then
		if (var374.manual_side == 3) then
			var374.manual_side = nil;
		else
			var374.manual_side = 3;
		end
	end
	var374.last_forward, var374.last_right, var374.last_left = var378, var377, var376;
	if not var374.manual_side then
		return;
	end
	return ({-90,90,180})[var374.manual_side];
end,run=function(var382, var383)
	local var384 = var24.get_local_player();
	if not var24.is_alive(var384) then
		return;
	end
	local var385 = var382.helpers:get_state();
	var382:set_builder(var383, var385);
end,set_builder=function(var386, var387, var388)
	local var389 = {};
	for var784, var785 in var3(var386.ui.menu.antiaim.states[var388]) do
		var389[var784] = var785();
	end
	var386:set(var387, var389);
end,animations=function(var390)
	local var391 = var24.get_local_player();
	if not var24.is_alive(var391) then
		return;
	end
	local var392 = var35.new(var391);
	local var393 = var392:get_anim_state();
	local var394 = var390.ui.menu.tools.animations_body:get();
	local var395 = var390.ui.menu.tools.animations_selector:get();
	if not var393 then
		return;
	end
	local var396 = var24.get_prop(var391, "m_vecVelocity[0]");
	if var390.helpers:contains(var395, "Body lean") then
		local var901 = var392:get_anim_overlay(12);
		if not var901 then
			return;
		end
		if (var19.abs(var396) >= 3) then
			var901.weight = var394 / 100;
		end
	end
	if var390.helpers:contains(var395, "Static legs") then
		var24.set_prop(var391, "m_flPoseParameter", 1, 6);
	end
	if var390.helpers:contains(var395, "Yaw break") then
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 11);
	end
	if var390.helpers:contains(var395, "Pitch break") then
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 12);
	end
	if var390.helpers:contains(var395, "Jitter ground") then
		var21.set(var390.ref.fakelag.lg[1], "Always slide");
		if ((var26.tickcount() % 4) > 1) then
			var24.set_prop(var391, "m_flPoseParameter", 0, 0);
		end
	end
	if var390.helpers:contains(var395, "Kangaroo") then
		if not var390.helpers:contains(var395, "Jitter air") then
			var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 6);
		end
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 3);
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 10);
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 9);
	end
	if var390.helpers:contains(var395, "Jitter air") then
		var24.set_prop(var391, "m_flPoseParameter", var19.random(0, 10) / 10, 6);
	end
	if var390.helpers:contains(var395, "Moonwalk") then
		var21.set(var390.ref.fakelag.lg[1], "Never slide");
		var24.set_prop(var391, "m_flPoseParameter", 0, 7);
		if var390.helpers:in_air(var391) then
			var392:get_anim_overlay(4).weight = 0;
			var392:get_anim_overlay(6).weight = 1;
		end
	end
	if var390.helpers:contains(var395, "Reset pitch on land") then
		if not var393.hit_in_ground_animation then
			return;
		end
		var24.set_prop(var391, "m_flPoseParameter", 0.5, 12);
	end
end,get_defensive=function(var397, var398, var399, var400)
	local var401 = var22.current_threat();
	local var402 = var24.get_local_player();
	if var397.helpers:contains(var398, "Always") then
		return true;
	end
	if var397.helpers:contains(var398, "On weapon switch") then
		local var902 = var24.get_prop(var402, "m_flNextAttack") - var26.curtime();
		if ((var902 / var26.tickinterval()) > (var397.defensive.defensive + 2)) then
			return true;
		end
	end
	if var397.helpers:contains(var398, "Tick-Base") then
		local var903 = var400.defensive_conditions_tick * 2;
		if ((var26.tickcount() % 32) >= var903) then
			return true;
		else
			return false;
		end
	end
	if var397.helpers:contains(var398, "On reload") then
		local var904 = var24.get_player_weapon(var402);
		if var904 then
			local var972 = var24.get_prop(var402, "m_flNextAttack") - var26.curtime();
			local var973 = var24.get_prop(var904, "m_flNextPrimaryAttack") - var26.curtime();
			if ((var972 > 0) and (var973 > 0) and ((var972 * var26.tickinterval()) > var397.defensive.defensive)) then
				return true;
			end
		end
	end
	if (var397.helpers:contains(var398, "On hittable") and var397.helpers:entity_has_flag(var401, "HIT")) then
		return true;
	end
	if (var397.helpers:contains(var398, "On freestand") and var397.ui.menu.antiaim.freestanding:get_hotkey() and not (var397.ui.menu.antiaim.freestanding:get("Disablers") and var397.ui.menu.antiaim.freestanding_disablers:get(var399))) then
		return true;
	end
end,spin_yaw=0,spin_pitch_def=0,switch_way=1,spin_value=0,jitter_side=0,spin_way=0,spin_pitch=0,last_way=0,switch_random=0,switch_random_p=0,random_spin_way=0,spin_way_180=0,set=function(var403, var404, var405)
	local var406 = var403.helpers:get_state();
	local var407 = {var19.random(1, var19.random(3, 4)),2,4,5};
	local var408 = var403:get_manual();
	local var409 = true;
	if (var405.jitter_delay == 0) then
		var407[var405.jitter_delay] = 1;
	end
	if ((var26.chokedcommands() == 0) and (var403.cycle == var407[var405.jitter_delay])) then
		var409 = false;
		var403.side = ((var403.side == 1) and 0) or 1;
	end
	local var410 = var403:get_best_side();
	local var411 = var403.side;
	local var412 = var405.body_yaw;
	local var413 = "default";
	local var414 = var19.random(-var405.yaw_random, var405.yaw_random);
	local var415 = var405.yaw_jitter_add + var414;
	if (var412 == "Jitter") then
		var412 = "Static";
	elseif (var405.body_yaw_side == "Left") then
		var411 = 1;
	elseif (var405.body_yaw_side == "Right") then
		var411 = 0;
	else
		var411 = var410;
	end
	local var416 = 0;
	if (var405.yaw_jitter == "Offset") then
		if (var403.side == 1) then
			var416 = var416 + var415;
		end
	elseif (var405.yaw_jitter == "Center") then
		var416 = var416 + (((var403.side == 1) and (var415 / 2)) or (-var415 / 2)) + var414;
	elseif (var405.yaw_jitter == "Random") then
		local var1001 = var19.random(0, var415) - (var415 / 2);
		if not var409 then
			var416 = var416 + var1001;
			var403.last_rand = var1001;
		else
			var416 = var416 + var403.last_rand;
		end
	elseif (var405.yaw_jitter == "Smoothnes") then
		local var1026 = var415;
		local var1027 = var407[var405.jitter_delay] / 4;
		local var1028 = var1026 * var19.sin((var26.curtime() / var1027) * var19.pi);
		var416 = var1028;
	elseif (var405.yaw_jitter == "Fractal") then
		local var1046 = var415 * 2;
		local var1047 = var407[var405.jitter_delay] * 0.5;
		local var1048 = 0;
		local var1049 = var405.yaw_fractals;
		local var1050 = 0;
		if (var1049 == 14) then
			var1050 = var19.random(0, 13);
		else
			var1050 = var1049;
		end
		for var1061 = 1, var1050 do
			var1048 = var1048 + ((0.5 ^ var1061) * var19.cos(((2 ^ var1061) * var1047 * var26.curtime() * 2 * var19.pi) + 10));
		end
		var416 = var1048 * var1046;
	elseif (var405.yaw_jitter == "Skitter") then
		local var1062 = {0,2,1,0,2,1,0,1,2,0,1,2,0,1,2};
		local var1063;
		if (var403.skitter_counter == #var1062) then
			var403.skitter_counter = 1;
		elseif not var409 then
			var403.skitter_counter = var403.skitter_counter + 1;
		end
		var1063 = var1062[var403.skitter_counter];
		var403.last_skitter = var1063;
		if (var405.body_yaw == "jitter") then
			var411 = var1063;
		end
		if (var1063 == 0) then
			var416 = (var416 - 16) - (var19.abs(var415) / 2);
		elseif (var1063 == 1) then
			var416 = var416 + 16 + (var19.abs(var415) / 2);
		end
	end
	var416 = var416 + (((var411 == 0) and var405.yaw_add_r) or ((var411 == 1) and var405.yaw_add) or 0);
	if (var403.helpers:contains(var405.options, "Enable defensive") and var403:get_defensive(var405.defensive_conditions, var406, var405)) then
		var404.force_defensive = true;
	end
	local var417 = var403.ui.menu.antiaim.edge_yaw:get_hotkey();
	var21.set(var403.ref.aa.freestand[1], false);
	var21.set(var403.ref.aa.edge_yaw[1], var417);
	var21.set(var403.ref.aa.freestand[2], "Always on");
	if var403.helpers:contains(var405.options, "Safe head") then
		local var908 = var24.get_local_player();
		local var909 = var22.current_threat();
		if var909 then
			local var974 = var24.get_player_weapon(var908);
			if (var974 and (var24.get_classname(var974):find("Knife") or var24.get_classname(var974):find("Taser"))) then
				var416 = 0;
				var411 = 2;
			end
		end
	end
	if var408 then
		var416 = var408;
	elseif (var403.ui.menu.antiaim.freestanding:get_hotkey() and not (var403.ui.menu.antiaim.freestanding:get("Disablers") and var403.ui.menu.antiaim.freestanding_disablers:get(var406))) then
		var21.set(var403.ref.aa.freestand[1], true);
		if (var403.ui.menu.antiaim.freestanding:get("Force static") or var403.ui.menu.antiaim.manual_static:get()) then
			var416 = 0;
			var411 = 0;
		end
	elseif (var403.helpers:contains(var405.options, "Avoid backstab") and var403:anti_backstab()) then
		var416 = var416 + 180;
	end
	local var418 = (((var403.defensive.ticks * var403.defensive.defensive) > 0) and var19.max(var403.defensive.defensive, var403.defensive.ticks)) or 0;
	local var419 = {{speed=var405.defensive_yaw_way_speed1,spin_limit=var405.defensive_yaw_way_spin_limit1,enable_spin=var405.defensive_yaw_enable_way_spin1,switch_value=var405.defensive_yaw_way_switch1},{speed=var405.defensive_yaw_way_speed2,spin_limit=var405.defensive_yaw_way_spin_limit2,enable_spin=var405.defensive_yaw_enable_way_spin2,switch_value=var405.defensive_yaw_way_switch2},{speed=var405.defensive_yaw_way_speed3,spin_limit=var405.defensive_yaw_way_spin_limit3,enable_spin=var405.defensive_yaw_enable_way_spin3,switch_value=var405.defensive_yaw_way_switch3},{speed=var405.defensive_yaw_way_speed4,spin_limit=var405.defensive_yaw_way_spin_limit4,enable_spin=var405.defensive_yaw_enable_way_spin4,switch_value=var405.defensive_yaw_way_switch4},{speed=var405.defensive_yaw_way_speed5,spin_limit=var405.defensive_yaw_way_spin_limit5,enable_spin=var405.defensive_yaw_enable_way_spin5,switch_value=var405.defensive_yaw_way_switch5}};
	local var420 = {{speed=var405.defensive_pitch_way_speed1,spin_limit1=var405.defensive_pitch_way_spin_limit11,spin_limit2=var405.defensive_pitch_way_spin_limit12,enable_spin=var405.defensive_pitch_enable_way_spin1,switch_value=var405.defensive_pitch_custom},{speed=var405.defensive_pitch_way_speed2,spin_limit1=var405.defensive_pitch_way_spin_limit21,spin_limit2=var405.defensive_pitch_way_spin_limit22,enable_spin=var405.defensive_pitch_enable_way_spin2,switch_value=var405.defensive_pitch_way2},{speed=var405.defensive_pitch_way_speed3,spin_limit1=var405.defensive_pitch_way_spin_limit31,spin_limit2=var405.defensive_pitch_way_spin_limit32,enable_spin=var405.defensive_pitch_enable_way_spin3,switch_value=var405.defensive_pitch_way3},{speed=var405.defensive_pitch_way_speed4,spin_limit1=var405.defensive_pitch_way_spin_limit41,spin_limit2=var405.defensive_pitch_way_spin_limit42,enable_spin=var405.defensive_pitch_enable_way_spin4,switch_value=var405.defensive_pitch_way4},{speed=var405.defensive_pitch_way_speed5,spin_limit1=var405.defensive_pitch_way_spin_limit51,spin_limit2=var405.defensive_pitch_way_spin_limit52,enable_spin=var405.defensive_pitch_enable_way_spin5,switch_value=var405.defensive_pitch_way5}};
	local var421 = var26.tickcount() % 32;
	if (var405.defensive_yaw and var403.helpers:contains(var405.options, "Enable defensive")) then
		if (var418 == 1) then
		end
		if ((var405.defensive_yaw_mode == "Jitter") and (var418 > 0)) then
			local var975 = var405.defensive_yaw_jitter_radius_1;
			local var976 = var405.defensive_yaw_jitter_delay * 3;
			local var977 = var405.defensive_yaw_jitter_random;
			if (var976 == 1) then
				var403.jitter_side = ((var403.jitter_side == -1) and 1) or -1;
			else
				var403.jitter_side = (((((var26.tickcount() % var976) * 2) + 1) <= var976) and -1) or 1;
			end
			var416 = (var403.jitter_side * var975) + var19.random(-var977, var977);
		elseif ((var405.defensive_yaw_mode == "Random") and (var418 > 0)) then
			local var1004 = var405.defensive_yaw_1_random;
			local var1005 = var405.defensive_yaw_2_random;
			var416 = var19.random(var1004, var1005);
		elseif ((var405.defensive_yaw_mode == "Custom spin") and (var418 > 0)) then
			var403.spin_value = var403.spin_value + (8 * (var405.defensive_yaw_speedtick / 5));
			if (var403.spin_value >= var405.defensive_yaw_spin_limit) then
				var403.spin_value = 0;
			end
			var416 = var403.spin_value;
		elseif ((var405.defensive_yaw_mode == "Spin-way") and (var418 > 0)) then
			local var1052 = var405.defensive_yaw_speed_Spin_way;
			local var1053 = var405.defensive_yaw_randomizer_Spin_way;
			local var1054 = var405.defensive_yaw_1_Spin_way;
			local var1055 = var405.defensive_yaw_2_Spin_way;
			local var1056 = 0;
			if (var421 >= (29 + var19.random(0, var1052))) then
				var403.spin_way_180 = var403.spin_way_180 + 1;
				var403.random_spin_way = var19.random(-var1053, var1053);
			end
			if (var403.spin_way_180 == 0) then
				var1056 = var1054 + var403.random_spin_way;
			elseif (var403.spin_way_180 == 1) then
				var1056 = var1055 + var403.random_spin_way;
			end
			if (var403.spin_way_180 == 2) then
				var403.spin_way_180 = 0;
			end
			local var1057 = var403.helpers:new_anim("antiaim_spin_way", var1056, 6);
			var416 = var1057;
		elseif ((var405.defensive_yaw_mode == "Switch 5-way") and (var418 > 0)) then
			if (var421 >= (29 + var19.random(0, var405.defensive_yaw_way_delay))) then
				var403.switch_way = var403.switch_way + 1;
				var403.switch_random = var19.random(-var405.defensive_yaw_way_randomly_value, var405.defensive_yaw_way_randomly_value);
			else
				var416 = var403.last_way;
				if (var403.switch_way == #var419) then
					var403.switch_way = 0;
				end
			end
			if ((var403.switch_way >= 0) and (var403.switch_way < #var419)) then
				local var1081 = var419[var403.switch_way + 1];
				var403.spin_way = var403.spin_way + (8 * (var1081.speed / 5));
				if (var403.spin_way >= var1081.spin_limit) then
					var403.spin_way = 0;
				end
				if not var1081.enable_spin then
					if var405.defensive_yaw_way_randomly then
						var416 = var1081.switch_value + var403.switch_random;
						var403.last_way = var1081.switch_value + var403.switch_random;
					else
						var416 = var1081.switch_value;
						var403.last_way = var1081.switch_value;
					end
				else
					var416 = var403.spin_way;
					var403.last_way = var403.spin_way;
				end
			elseif (var403.switch_way == #var419) then
				var403.switch_way = 0;
			end
		end
		if ((var405.defensive_pitch_mode == "Static") and (var418 > 0)) then
			var413 = var405.defensive_pitch_custom;
		elseif ((var405.defensive_pitch_mode == "Jitter") and (var418 > 0)) then
			if (var19.random(0, 20) >= 10) then
				var413 = var405.defensive_pitch_clock;
			else
				var413 = var405.defensive_pitch_custom;
			end
		elseif ((var405.defensive_pitch_mode == "Spin") and (var418 > 0)) then
			if (var405.defensive_pitch_custom < 0) then
				var403.spin_pitch_def = var403.spin_pitch_def - (var405.defensive_pitch_speedtick / 5);
			else
				var403.spin_pitch_def = var403.spin_pitch_def + (var405.defensive_pitch_speedtick / 5);
			end
			if (var405.defensive_pitch_custom < 0) then
				if (var403.spin_pitch_def <= var405.defensive_pitch_custom) then
					var403.spin_pitch_def = var405.defensive_pitch_spin_limit2;
				end
			elseif (var403.spin_pitch_def >= var405.defensive_pitch_custom) then
				var403.spin_pitch_def = var405.defensive_pitch_spin_limit2;
			end
			var413 = var403.spin_pitch_def;
		elseif ((var405.defensive_pitch_mode == "Clocking") and (var418 > 0)) then
			if (var421 >= 28) then
				var403.spin_yaw = var403.spin_yaw + 15;
			end
			if (var403.spin_yaw >= 89) then
				var403.spin_yaw = -89;
			end
			var413 = var403.spin_yaw;
		elseif ((var405.defensive_pitch_mode == "Random") and (var418 > 0)) then
			local var1075 = var405.defensive_pitch_custom;
			local var1076 = var405.defensive_pitch_spin_random2;
			var413 = var19.random(var1075, var1076);
		elseif ((var405.defensive_pitch_mode == "5way") and (var418 > 0)) then
			if (var421 >= (29 + var19.random(0, var405.defensive_yaw_way_delay))) then
				var403.switch_random_p = var19.random(-var405.defensive_pitch_way_randomly_value, var405.defensive_pitch_way_randomly_value);
			else
				var413 = var403.last_way;
			end
			if ((var403.switch_way >= 0) and (var403.switch_way < #var420)) then
				local var1091 = var420[var403.switch_way + 1];
				if (var1091.spin_limit2 < 0) then
					var403.spin_pitch = var403.spin_pitch - (8 * (var1091.speed / 5));
				else
					var403.spin_pitch = var403.spin_pitch + (8 * (var1091.speed / 5));
				end
				if (var1091.spin_limit2 < 0) then
					if (var403.spin_pitch <= var1091.spin_limit2) then
						var403.spin_pitch = var1091.spin_limit1;
					end
				elseif (var403.spin_pitch >= var1091.spin_limit2) then
					var403.spin_pitch = var1091.spin_limit1;
				end
				if not var1091.enable_spin then
					if var405.defensive_pitch_way_randomly then
						var413 = var403.switch_random_p;
						var403.last_way = var403.switch_random_p;
					else
						var413 = var1091.switch_value;
						var403.last_way = var1091.switch_value;
					end
				else
					var413 = var403.spin_pitch;
					var403.last_way = var403.spin_pitch;
				end
			end
		end
	end
	var21.set(var403.ref.aa.enabled[1], true);
	var21.set(var403.ref.aa.pitch[1], ((var413 == "default") and var413) or "custom");
	var21.set(var403.ref.aa.pitch[2], var403.helpers:normalize_pitch(((var14(var413) == "number") and var413) or 0));
	var21.set(var403.ref.aa.yaw_base[1], var405.yaw_base);
	var21.set(var403.ref.aa.yaw[1], 180);
	var21.set(var403.ref.aa.yaw[2], var403.helpers:normalize_yaw(var416));
	var21.set(var403.ref.aa.yaw_jitter[1], "off");
	var21.set(var403.ref.aa.yaw_jitter[2], 0);
	var21.set(var403.ref.aa.body_yaw[1], var412);
	var21.set(var403.ref.aa.body_yaw[2], ((var411 == 2) and 0) or ((var411 == 1) and 90) or -90);
	if (var26.chokedcommands() == 0) then
		if (var403.cycle >= var407[var405.jitter_delay]) then
			var403.cycle = 1;
		else
			var403.cycle = var403.cycle + 1;
		end
	end
end}):struct("defensive")({check=0,defensive=0,sim_time=var26.tickcount(),active_until=0,ticks=0,active=false,defensive_active=function(var422)
	local var423 = var24.get_local_player();
	if (not var423 or not var24.is_alive(var423)) then
		return;
	end
	local var424 = var24.get_prop(var24.get_local_player(), "m_nTickBase");
	var422.defensive = var19.abs(var424 - var422.check);
	var422.check = var19.max(var424, var422.check or 0);
	local var427 = var26.tickcount();
	local var428 = var24.get_prop(var423, "m_flSimulationTime");
	local var429 = var13(var428 - var422.sim_time);
	if (var429 < 0) then
		var422.active_until = var427 + var19.abs(var429);
	end
	var422.ticks = var422.helpers:clamp(var422.active_until - var427, 0, 16);
	var422.active = var422.active_until > var427;
	var422.sim_time = var428;
end,def_reset=function(var433)
	var433.check, var433.defensive = 0, 0;
end}):struct("tools")({widget_keylist=var38("keylist", 300, 100),widget_watermark=var38("watermark", 10, 10),scoped=0,scoped_comp=0,menu_setup=function(var436)
	local var437 = var436.ui.menu.tools.notify_offset:get();
	local var438, var439, var440, var441 = var436.ui.menu.global.color:get();
	var37.color[1] = var438;
	var37.color[2] = var439;
	var37.color[3] = var440;
	var37.offset = var437;
	if var436.ui.menu.tools.notify_vibor:get("New style") then
		var37.blured = true;
	else
		var37.blured = false;
	end
	local var446 = var436.ui.menu.global.tab:get();
	local var447 = var436.ui.menu.antiaim.mode:get();
	local var448 = ((var446 == "antiaim") and (var447 == "Constructor")) or (var446 == "home");
	local var449 = {fakelag=var436.ref.fakelag,aa_other=var436.ref.aa_other};
	for var787, var788 in var3(var449) do
		local var789 = true;
		if (var787 == "fakelag") then
			var789 = false;
		elseif (var787 == "aa_other") then
			var789 = not var448;
		end
		for var913, var914 in var3(var788) do
			for var950, var951 in var2(var914) do
				var21.set_visible(var951, var789);
			end
		end
	end
	if (var436.ref.fakelag.enable[1] ~= true) then
		var21.set(var436.ref.fakelag.enable[1], true);
	end
	var21.set(var436.ref.fakelag.amount[1], var436.ui.menu.antiaim.fakelag_type:get());
	var21.set(var436.ref.fakelag.variance[1], var436.ui.menu.antiaim.fakelag_var:get());
	var21.set(var436.ref.fakelag.limit[1], var436.ui.menu.antiaim.fakelag_lim:get());
end,gs_ind=function(var450)
	if var450.helpers:contains(var450.ui.menu.tools.gs_inds:get(), "Target") then
		local var915 = var22.current_threat();
		local var916 = "None";
		if not var915 then
			var916 = "None";
		else
			var916 = var24.get_player_name(var915);
		end
		var28.indicator(255, 255, 255, 200, "Target: " .. var916);
	end
end,crosshair=function(var451)
	local var452 = var24.get_local_player();
	if (not var452 or not var24.is_alive(var452)) then
		return;
	end
	var451.scoped = var24.get_prop(var452, "m_bIsScoped");
	if not var451.ui.menu.tools.indicators:get() then
		return;
	end
	local var454 = var451.ui.menu.tools.indicator_pos:get();
	var451.scoped_comp = var451.helpers:math_anim2(var451.scoped_comp, var451.scoped * (((var454 == "Left") and -1) or 1), 8);
	local var456 = var451.helpers:get_state();
	local var457 = {var22.screen_size()};
	var451.ss = {x=var457[1],y=var457[2]};
	local var459, var460, var461, var462 = var451.ui.menu.global.color:get();
	local var463 = var451.ui.menu.tools.indicatorfont:get();
	local var464 = 0;
	if (var463 == "Default") then
		var464 = 1;
	elseif (var463 == "New") then
		var464 = 2;
	elseif (var463 == "Onesense") then
		var464 = 3;
	elseif (var463 == "Renewed") then
		var464 = 4;
	end
	local var465 = var24.get_prop(var452, "m_flNextAttack");
	local var466 = var24.get_prop(var24.get_player_weapon(var452), "m_flNextPrimaryAttack");
	local var467 = not (var19.max(var466, var465) > var26.curtime());
	local var468, var469, var470 = (var467 and 255) or var459, (var467 and 255) or var460, (var467 and 255) or var461;
	local var471, var472, var473 = var451.helpers:animate_pulse({var459,var460,var461,255}, 8);
	local var474 = {{n="DT",c={var468,var469,var470},a=(var21.get(var451.ref.rage.dt[1]) and var21.get(var451.ref.rage.dt[2]) and not var21.get(var451.ref.rage.fd[1])),s=(var28.measure_text("-", "DT") + 13)},{n="OSAA",c={255,255,255},a=(var21.get(var451.ref.rage.os[1]) and var21.get(var451.ref.rage.os[2]) and not var21.get(var451.ref.rage.fd[1])),s=(var28.measure_text("-", "OSAA") + 13)},{n="FAKE",c={var471,var472,var473},a=var21.get(var451.ref.rage.fd[1]),s=(var28.measure_text("-", "FAKE") + 14)},{n="FS",c={255,255,255},a=(var21.get(var451.ref.aa.freestand[1]) and var21.get(var451.ref.aa.freestand[2])),s=(var28.measure_text("-", "FS") + 13)}};
	local var475 = var451.helpers:new_anim("indicator_pose", var451.ui.menu.tools.indicatoroffset:get(), 12);
	local var476 = 0;
	local var477 = var451.antiaim:get_best_side();
	local var478 = var451.helpers:animate_text(var26.curtime() * 2, "onesense", var459, var460, var461, 255);
	if (var464 == 1) then
		local var917 = var28.measure_text("c-", var41.build:upper());
		var28.text((var451.ss.x / 2) + (((var917 + 14) / 2) * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 10, var459, var460, var461, 150, "c-", 0, var41.build:upper());
		var28.text(((var451.ss.x / 2) - 22) + (30 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, 0, 0, 0, 255, "b", 0, var15(var478));
		local var918 = var451.helpers:new_anim("indicator_mes_1", var28.measure_text("-", var456:upper()) or 0, 12);
		var28.text((var451.ss.x / 2) + (((var918 + 14) / 2) * var451.scoped_comp), (var451.ss.y / 2) + var475 + 13, 255, 255, 255, 255, "c-", 0, var456:upper());
		for var952, var953 in var2(var474) do
			local var954 = var451.helpers:new_anim("indicators_alpha" .. var953.n, (var953.a and 255) or 0, 10);
			local var955 = var451.helpers:new_anim("indicators_pose_2" .. var953.n, (var953.a and 10) or 0, 10);
			var476 = var476 + var955;
			var28.text((var451.ss.x / 2) + ((var953.s / 2) * var451.scoped_comp), (var451.ss.y / 2) + var475 + var476 + 15, var953.c[1], var953.c[2], var953.c[3], var954, "-ca", nil, var953.n);
		end
	elseif (var464 == 2) then
		local var981, var982, var983 = ((var477 == 2) and var459) or 200, ((var477 == 2) and var460) or 200, ((var477 == 2) and var461) or 200;
		local var984, var985, var986 = ((var477 == 0) and var459) or 200, ((var477 == 0) and var460) or 200, ((var477 == 0) and var461) or 200;
		var28.text(((var451.ss.x / 2) - 23) + (35 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, var981, var982, var983, 255, "b", 0, "one");
		var28.text(((var451.ss.x / 2) - 5) + (35 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, var984, var985, var986, 255, "b", 0, "sense");
		var28.text((var451.ss.x / 2) + 23 + (35 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, 255, 255, 255, 255, "b", 0, "°");
	elseif (var464 == 3) then
		local var1006, var1007, var1008 = ((var477 == 2) and var459) or 200, ((var477 == 2) and var460) or 200, ((var477 == 2) and var461) or 200;
		local var1009, var1010, var1011 = ((var477 == 0) and var459) or 200, ((var477 == 0) and var460) or 200, ((var477 == 0) and var461) or 200;
		local var1012, var1013, var1014 = ((var477 == 1) and var459) or 255, ((var477 == 1) and var460) or 255, ((var477 == 1) and var461) or 255;
		var28.text(((var451.ss.x / 2) - 33) + (45 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, 255, 255, 255, 255, "ab", 0, "одно");
		var28.text(((var451.ss.x / 2) - 5) + (45 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, var459, var460, var461, 255, "ab", 0, "чувство");
		var28.text(((var451.ss.x / 2) - 11) + (23 * var451.scoped_comp), (var451.ss.y / 2) + var475 + 6, var1006, var1007, var1008, 255, "ab", 0, "•");
		var28.text(((var451.ss.x / 2) - 3) + (23 * var451.scoped_comp), (var451.ss.y / 2) + var475 + 6, var1009, var1010, var1011, 255, "ab", 0, "•");
		var28.text((var451.ss.x / 2) + 5 + (23 * var451.scoped_comp), (var451.ss.y / 2) + var475 + 6, var1012, var1013, var1014, 255, "ab", 0, "•");
		if var451.ui.menu.tools.indicator_bind:get() then
			for var1038, var1039 in var2(var474) do
				local var1040 = var451.helpers:new_anim("indicators_alpha" .. var1039.n, (var1039.a and 255) or 0, 10);
				local var1041 = var451.helpers:new_anim("indicators_pose_2" .. var1039.n, (var1039.a and 13) or 0, 10);
				var476 = var476 + var1041;
				var28.text((var451.ss.x / 2) + (((var1039.s / 2) + 5) * var451.scoped_comp), (var451.ss.y / 2) + var475 + var476 + 15, var1039.c[1], var1039.c[2], var1039.c[3], var1040, "ca", nil, var1039.n:lower());
			end
		end
	elseif (var464 == 4) then
		local var1033 = "₊‧.°.⋆✦⋆.°.₊";
		var28.text(((var451.ss.x / 2) - 27) + (35 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 13, var459, var460, var461, 200, "ab", 0, var1033);
		var28.text(((var451.ss.x / 2) - 22) + (35 * var451.scoped_comp), ((var451.ss.y / 2) + var475) - 6, 255, 255, 255, 255, "ab", 0, var15(var478));
		local var1034 = var451.helpers:new_anim("indicator_mes_1", var28.measure_text("-", var456:upper()) or 0, 12);
		var28.text((var451.ss.x / 2) + (((var1034 + 32) / 2) * var451.scoped_comp), (var451.ss.y / 2) + var475 + 13, 255, 255, 255, 255, "ac", 0, var456);
		for var1042, var1043 in var2(var474) do
			local var1044 = var451.helpers:new_anim("indicators_alpha" .. var1043.n, (var1043.a and 255) or 0, 10);
			local var1045 = var451.helpers:new_anim("indicators_pose_2" .. var1043.n, (var1043.a and 13) or 0, 10);
			var476 = var476 + var1045;
			var28.text((var451.ss.x / 2) + (((var1043.s / 2) + 8) * var451.scoped_comp), (var451.ss.y / 2) + var475 + var476 + 15, var1043.c[1], var1043.c[2], var1043.c[3], var1044, "ca", nil, var1043.n:lower());
		end
	end
end,view_x=1,view_y=1,view_z=-1,view_fov=60,viewmodel=function(var479)
	local var480 = var24.get_local_player();
	local var481 = var479.ui.menu.tools.viewmodel_on:get();
	local var482 = var479.ui.menu.tools.viewmodel_scope:get();
	if not var24.is_alive(var480) then
		return;
	end
	local var483 = var24.get_player_weapon(var480);
	if (var483 == nil) then
		return;
	end
	local var484 = var24.get_prop(var483, "m_iItemDefinitionIndex");
	local var485 = var47(var46, var484);
	var485.hide_vm_scope = not var482;
	if not var481 then
		return;
	end
	local var487 = var479.ui.menu.tools.viewmodel_x1:get();
	local var488 = var479.ui.menu.tools.viewmodel_y1:get();
	local var489 = var479.ui.menu.tools.viewmodel_z1:get();
	local var490 = var479.ui.menu.tools.viewmodel_fov1:get();
	local var491 = var479.ui.menu.tools.viewmodel_x2:get();
	local var492 = var479.ui.menu.tools.viewmodel_y2:get();
	local var493 = var479.ui.menu.tools.viewmodel_z2:get();
	local var494 = var479.ui.menu.tools.viewmodel_fov2:get();
	if (var479.scoped == 1) then
		if var479.ui.menu.tools.viewmodel_inscope:get() then
			var479.view_x = var491;
			var479.view_y = var492;
			var479.view_z = var493;
			var479.view_fov = var494;
		end
	else
		var479.view_x = var487;
		var479.view_y = var488;
		var479.view_z = var489;
		var479.view_fov = var490;
	end
	var22.set_cvar("viewmodel_offset_x", var479.helpers:new_anim("view_x1", var479.view_x, 11));
	var22.set_cvar("viewmodel_offset_y", var479.helpers:new_anim("view_y1", var479.view_y, 11));
	var22.set_cvar("viewmodel_offset_z", var479.helpers:new_anim("view_z1", var479.view_z, 11));
	var22.set_cvar("viewmodel_fov", var479.helpers:new_anim("view_fov1", var479.view_fov, 11));
end,manuals=function(var495)
	local var496, var497 = var22.screen_size();
	local var498 = var24.get_local_player();
	local var499 = "";
	local var500 = "";
	if (var495.ui.menu.tools.manuals_style:get() == "Onesense") then
		var499 = "‹";
		var500 = "›";
	elseif (var495.ui.menu.tools.manuals_style:get() == "New") then
		var499 = "«";
		var500 = "»";
	end
	if not var24.is_alive(var498) then
		return;
	end
	local var501 = var495.antiaim:get_manual();
	local var502 = var495.antiaim:get_best_side();
	local var503, var504, var505, var506 = var495.ui.menu.global.color:get();
	local var507 = var495.helpers:new_anim("alpha_manual_global", (var495.ui.menu.tools.manuals_global:get() and 255) or 0, 16);
	local var508 = var495.helpers:new_anim("manual_scope", ((var495.scoped == 1) and 15) or 0, 8);
	local var509 = var495.helpers:new_anim("alpha_manual_right", ((var501 == 90) and 255) or 0, 16);
	local var510 = var495.helpers:new_anim("alpha_manual_left", ((var501 == -90) and 255) or 0, 16);
	local var511 = var495.helpers:new_anim("alpha_manual_right_global", ((var502 == 0) and 255) or 0, 8);
	local var512 = var495.helpers:new_anim("alpha_manual_left_global", ((var502 == 2) and 255) or 0, 8);
	local var513 = var495.helpers:new_anim("alpha_manual_offset", -var495.ui.menu.tools.manuals_offset:get() - 25, 12);
	var28.text((var496 / 2) + var513, ((var497 / 2) - 16) - var508, var503, var504, var505, var510, "d+", 0, var499);
	var28.text(((var496 / 2) - var513) - 11, ((var497 / 2) - 16) - var508, var503, var504, var505, var509, "d+", 0, var500);
	if (var507 < 0.1) then
		return;
	end
	var28.text((var496 / 2) + var513 + 11, ((var497 / 2) - 16) - var508, var503, var504, var505, var512 * (var507 / 255), "d+", 0, var499);
	var28.text(((var496 / 2) - var513) - 22, ((var497 / 2) - 16) - var508, var503, var504, var505, var511 * (var507 / 255), "d+", 0, var500);
end,ind_dmg=function(var514)
	local var515, var516 = var22.screen_size();
	local var517 = var24.get_local_player();
	if not var24.is_alive(var517) then
		return;
	end
	local var518, var519, var520, var521 = var514.ui.menu.tools.indicator_dmg_color:get();
	local var522 = var514.ui.menu.tools.indicator_dmg_weapon:get();
	local var523 = var19.floor(var514.helpers:new_anim("dmg_indicator", var514.helpers:get_damage() + 0.1, 8));
	local var524 = "";
	if var514.ref.rage.ovr[2] then
		if var522 then
			if var21.get(var514.ref.rage.ovr[2]) then
				var524 = var514.helpers:get_damage();
			else
				var524 = "";
			end
		elseif var21.get(var514.ref.rage.ovr[2]) then
			var524 = var523;
		else
			var524 = var523;
		end
	end
	var28.text((var515 / 2) + 5, (var516 / 2) - 17, var518, var519, var520, 255, "d", 0, var524 .. "");
end,scopedu=function(var525)
	if not var525.ui.menu.tools.animscope:get() then
		return;
	end
	local var526 = var24.get_local_player();
	local var527 = var525.ui.menu.tools.animscope_slider:get();
	local var528 = var525.ui.menu.tools.animscope_fov_slider:get();
	local var529 = var525.ui.menu.tools.animscope_speed:get();
	local var530 = var525.helpers:new_anim("animated_scoped", ((var525.scoped == 1) and var527) or 0, var529);
	if (var21.get(var525.ref.misc.override_zf) > 0) then
		var21.set(var525.ref.misc.override_zf, 0);
	end
	var21.set(var525.ref.misc.fov, var528 - var530);
end,watermark=function(var531)
	local var532, var533 = var22.screen_size();
	local var534, var535, var536, var537 = var531.ui.menu.global.color:get();
	local var538, var539 = var531.widget_watermark:get(65, 10);
	local var540, var541, var542 = 5 + (var534 / 5), 6 + (var535 / 5), 8 + (var536 / 5);
	local var543 = var41.name;
	local var544, var545 = var22.system_time();
	local var546 = var20.format("%02d:%02d", var544, var545);
	local var547 = var28.measure_text("ca", var41.build);
	local var548 = var28.measure_text("ca", var543);
	local var549 = var28.measure_text("ca", var546);
	local var550 = 38;
	local var551 = var19.floor(var22.latency() * 1000);
	local var552 = var28.measure_text("ca", var551);
	local var553 = 125 + var548;
	var531.helpers:rounded_side_v(var538 - 60, var539 - 5, 100 + (var547 - var550), 25, var540, var541, var542, 160, 6, true, true);
	var531.helpers:rounded_side_v(var538 + (var547 - var550) + 51, var539 - 5, var553 + (var552 - 8), 25, var540, var541, var542, 160, 6, true, true);
	var28.text(var538 + (var547 - var550) + 144 + var548 + (var549 / 2) + (var552 - 8), var539 + 7, 255, 255, 255, 255, "ca", nil, var546);
	var28.text(var538 + (var547 - var550) + 135 + var548 + (var552 - 8), var539 + 7, var534, var535, var536, 255, "bca", nil, "•");
	var28.text(var538 + (var547 - var550) + 105 + var548 + (var552 / 2), var539 + 7, 255, 255, 255, 255, "ca", nil, var551 .. " ping");
	var28.text(var538 + (var547 - var550) + 84 + var548, var539 + 7, var534, var535, var536, 255, "bca", nil, "•");
	var28.text(var538 + (var547 - var550) + 75 + (var548 / 2), var539 + 7, 255, 255, 255, 255, "ca", nil, var543);
	var28.text(var538 + (var547 - var550) + 65, var539 + 7, var534, var535, var536, 255, "bca", nil, "•");
	var28.text(var538 - 30, var539 + 7, 255, 255, 255, 255, "ca", nil, "onesense");
	var28.text(var538 + (var547 / 2), var539 + 7, var534, var535, var536, 255, "ca", nil, var41.build);
	var531.widget_watermark:drag(var553 + 126, 35);
end,draw=false,keylist=function(var554)
	local var555, var556 = var22.screen_size();
	local var557, var558, var559, var560 = var554.ui.menu.global.color:get();
	local var561, var562, var563, var564 = 5 + (var557 / 5), 6 + (var558 / 5), 8 + (var559 / 5), var554.helpers:new_anim("alpha_keybinds", (var554.draw and 160) or 0, 16);
	local var565 = 95;
	if (not var21.is_menu_open() and not var21.get(var554.ref.rage.dt[2]) and not var21.get(var554.ref.rage.os[2]) and not var21.get(var554.ref.rage.ovr[2]) and not var21.get(var554.ref.aa.freestand[1]) and not var21.get(var554.ref.slow_motion[2]) and not var21.get(var554.ref.rage.fd[1])) then
		var554.draw = false;
	else
		var554.draw = true;
	end
	if (var564 < 0.1) then
		return;
	end
	local var566, var567 = var554.widget_keylist:get(25, 10);
	var554.helpers:rounded_side_v(var566 - 20, var567 - 5, var565, 25, var561, var562, var563, var564, 6, true, true);
	var28.line(var566 + 10, var567, var566 + 9, var567 + 15, 255, 255, 255, 55 * (var564 / 160));
	var28.texture(var554.globals.keylist_icon, var566 - 14, var567, 15, 15, 255, 255, 255, 255 * (var564 / 160));
	var28.text(var566 + 35, var567 + 7, 255, 255, 255, 255 * (var564 / 160), "ca", nil, "Keylist");
	local var568 = 0;
	local var569 = {{n="Double Tap",c={255,255,255},a=(var21.get(var554.ref.rage.dt[1]) and var21.get(var554.ref.rage.dt[2]) and not var21.get(var554.ref.rage.fd[1])),s=var28.measure_text("c", "Double tap")},{n="Hide Shots",c={255,255,255},a=(var21.get(var554.ref.rage.os[1]) and var21.get(var554.ref.rage.os[2]) and not var21.get(var554.ref.rage.fd[1])),s=(var28.measure_text("c", "Hide shots") + 1)},{n="Fake Duck",c={255,255,255},a=var21.get(var554.ref.rage.fd[1]),s=(var28.measure_text("c", "Fake duck") + 3)},{n="Min. Damage",c={255,255,255},a=(var21.get(var554.ref.rage.ovr[1]) and var21.get(var554.ref.rage.ovr[2])),s=(var28.measure_text("c", "Min dmg") + 16)},{n="Edge yaw",c={255,255,255},a=(var21.get(var554.ref.aa.edge_yaw[1]) and var554.ui.menu.antiaim.edge_yaw:get_hotkey()),s=(var28.measure_text("c", "Edge yaw") + 3)},{n="Freestand",c={255,255,255},a=(var21.get(var554.ref.aa.freestand[1]) and var21.get(var554.ref.aa.freestand[2])),s=(var28.measure_text("c", "Freestand") + 3)}};
	for var790, var791 in var2(var569) do
		local var792 = var554.helpers:new_anim("alpha_rect_keybinds" .. var791.n, (var791.a and 130) or 0, 18);
		local var793 = var554.helpers:new_anim("alpha_text_keybinds" .. var791.n, (var791.a and 255) or 0, 18);
		local var794 = var28.measure_text("ca", var21.get(var554.ref.rage.ovr[3])) - 12;
		local var795 = var554.helpers:new_anim("move_keybinds" .. var791.n, (var791.a and 20) or 0, 15);
		var568 = var568 + var795;
		var554.helpers:rounded_side_v(var566 - 20, var567 + 3 + var568, var565, 18, var561, var562, var563, var792 * (var564 / 160), 6, true, true);
		if (var791.n == "Min. Damage") then
			var28.text((var566 + (var565 - 27)) - (var794 / 2), var567 + 11 + var568, var557, var558, var559, var793 * (var564 / 160), "ca", nil, var21.get(var554.ref.rage.ovr[3]));
		else
			var28.text(var566 + (var565 - 27), var567 + 11 + var568, var557, var558, var559, var793 * (var564 / 160), "ca", nil, "on");
		end
		var28.text((var566 - 40) + var791.s, var567 + 11 + var568, var791.c[1], var791.c[2], var791.c[3], var793 * (var564 / 160), "ca", nil, var791.n);
	end
	var554.widget_keylist:drag(var565 + 16, 35);
end}):struct("round_reset")({auto_buy=function(var570)
	if not var570.ui.menu.tools.autobuy:get() then
		return;
	end
	if (var570.ui.menu.tools.autobuy_v:get() == "Awp") then
		var22.exec("buy awp");
	elseif (var570.ui.menu.tools.autobuy_v:get() == "Scar/g3sg1") then
		var22.exec("buy g3sg1");
		var22.exec("buy scar20");
	elseif (var570.ui.menu.tools.autobuy_v:get() == "Scout") then
		var22.exec("buy ssg08");
	end
end}):struct("misc")({charged=false,call_reg=false,jumpscout=false,check_charge=function(var571)
	local var572 = var24.get_local_player();
	local var573 = var24.get_prop(var572, "m_nTickBase");
	local var574 = var22.latency();
	local var575 = var19.floor((((var573 - var26.tickcount()) - 3) - (var13(var574) * 0.5)) + (0.5 * var574 * 10));
	local var576 = -14 + 4;
	var571.charged = var575 <= var576;
end,unsafe_charge=function(var578)
	local var579 = var578.ui.menu.tools.unsafe_charge:get();
	if not var579 then
		if var578.call_reg then
			var22.unset_event_callback("run_command", var578.check_charge);
			var578.call_reg = false;
		end
		return;
	end
	local var580 = var24.get_local_player();
	if not var578.call_reg then
		var22.set_event_callback("run_command", var578.check_charge);
		var578.call_reg = true;
	end
	local var581 = var22.current_threat();
	local var582 = var578.ref.rage.enable;
	if (not var578.charged and var581 and not var578.jumpscout and var578.helpers:in_air(var580) and var578.helpers:entity_has_flag(var581, "HIT")) then
		if (var21.get(var582) == true) then
			var21.set(var582, false);
		end
	elseif (var21.get(var582) == false) then
		var21.set(var582, true);
	end
end,air_stopchance=function(var583, var584)
	local var585 = var583.ui.menu.tools.air_stop;
	if (not var585:get() or not var585:get_hotkey()) then
		var583.jumpscout = false;
		return;
	end
	local var586 = var24.get_local_player();
	if (not var586 or not var24.is_alive(var586)) then
		return;
	end
	local var587 = var583.ui.menu.tools.air_stop_distance:get() * 5;
	local var588 = var29.band(var24.get_prop(var24.get_player_weapon(var586), "m_iItemDefinitionIndex"), 65535);
	local var589 = var24.get_players(true);
	for var796 = 1, #var589 do
		if (var589 == nil) then
			return;
		end
		local var797, var798, var799 = var24.get_prop(var586, "m_vecOrigin");
		local var800, var801, var802 = var24.get_prop(var589[var796], "m_vecOrigin");
		local var803 = var583.helpers:distance(var797, var798, var799, var800, var801, var802) / 11.91;
		if ((var803 < var587) and (var588 == 40)) then
			if var583.helpers:in_air(var586) then
				if var584.quick_stop then
					var583.jumpscout = true;
					var584.in_speed = 1;
				end
			end
		else
			var583.jumpscout = false;
		end
	end
end,phrases={kill={"УШАСТЫЙ ПИДОРАС ПОЧЕМУ ОПЯТЬ УМЕР?","ОТРАХАННЫЙ БИЧ СНОВА УМЕР","1 раб ебаный","пизда те немощ ебаный","ЕБУ ТЯ БОМЖИК НЕ ПУКАЙ","ИДИ КОНФИГ МОЙ КУПИ С ЗЕЛЕННЫМИ ВИЗУАЛКАМИ ФАНАТИК ПОВРОТИКА","СКАЧАЙ УЖЕ ONESENSE (BEST LUA) А ТО ТЫ УМИРАЕШЬ","ВАНЯ СЕНС БУСТИТ, 1","бомж без onesense еще умеет wasd нажимать((","как ты умер? мисснул в 20 хп xdxdxdxd иди скачай ванька уже","ЛУЧШАЯ ЛУА discord.gg/zUKBpRrSss","БИЧ ТУПОЙ ТВОЯ ЛУА НИЩ, ЛУЧШАЯ ЛУА discord.gg/zUKBpRrSss","ВСЕ ИДИ ВАЛЯЙСЯ НЕ ДУРИ ГОЛОВУ","тише будь, onesense все слышет","ваня пришел к тебе и сломал тебя"},death={"я те ща вырежу мать, лакерное чудовище","как ты меня убил ты же кроме wasd не умеешь ниче нажимать","НУ Я ТЕБЯ КАК СВИНКУ РЕЗАЛ СУКА, Я ТВОЮ МАТУХУ СБИЛ ЩА ПИДОРАС","К А К Т Е Б Е В Е З Ё Т Л А К Е Р Н О Е С У Щ Е С Т В О","не знал, что тех кто ебал отчим могут убивать"}},fast_ladder=function(var590, var591)
	local var592 = var24.get_local_player();
	local var593, var594 = var22.camera_angles();
	local var595 = var24.get_prop(var592, "m_MoveType");
	if (var595 == 9) then
		var591.yaw = var19.floor(var591.yaw + 0.5);
		var591.roll = 0;
		if (var591.forwardmove > 0) then
			if (var593 < 45) then
				var591.pitch = 89;
				var591.in_moveright = 1;
				var591.in_moveleft = 0;
				var591.in_forward = 0;
				var591.in_back = 1;
				if (var591.sidemove == 0) then
					var591.yaw = var591.yaw + 90;
				end
				if (var591.sidemove < 0) then
					var591.yaw = var591.yaw + 150;
				end
				if (var591.sidemove > 0) then
					var591.yaw = var591.yaw + 30;
				end
			end
		end
		if (var591.forwardmove < 0) then
			var591.pitch = 89;
			var591.in_moveleft = 1;
			var591.in_moveright = 0;
			var591.in_forward = 1;
			var591.in_back = 0;
			if (var591.sidemove == 0) then
				var591.yaw = var591.yaw + 90;
			end
			if (var591.sidemove > 0) then
				var591.yaw = var591.yaw + 150;
			end
			if (var591.sidemove < 0) then
				var591.yaw = var591.yaw + 30;
			end
		end
	end
end,trashtalk=function(var596, var597)
	local var598 = var24.get_local_player();
	local var599 = var22.userid_to_entindex(var597.userid);
	local var600 = var22.userid_to_entindex(var597.attacker);
	if (var598 == nil) then
		return;
	end
	if ((var600 == var598) and (var599 ~= var598)) then
		if (var596.ui.menu.tools.trashtalk_type:get() == "Default type") then
			var22.delay_call(1, function()
				var22.exec(("say %s"):format(var596.phrases.kill[var19.random(0, #var596.phrases.kill)]));
			end);
		elseif (var596.ui.menu.tools.trashtalk_type:get() == "1 MOD") then
			if var596.ui.menu.tools.trashtalk_check2:get() then
				var22.exec(("say %s, 1"):format(var24.get_player_name(var599)));
			else
				var22.exec("say 1");
			end
		elseif (var596.ui.menu.tools.trashtalk_type:get() == "Custom phrase") then
			var22.exec("say " .. var596.ui.menu.tools.trashtalk_custom:get());
		end
	end
	if ((var600 ~= var598) and (var599 == var598)) then
		var22.delay_call(2, function()
			var22.exec(("say %s"):format(var596.phrases.death[var19.random(0, #var596.phrases.death)]));
		end);
	end
end}):struct("logs")({hitboxes={[0]="body","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"},miss=function(var601, var602)
	local var603, var604, var605 = var601.ui.menu.global.color:get();
	local var606 = var24.get_player_name(var602.target);
	local var607 = var601.hitboxes[var602.hitgroup] or "?";
	local var608 = var601.helpers:limit_ch(var606, 15, "...");
	local var609 = var26.tickcount() - var602.tick;
	local var610 = var19.floor(var602.hit_chance);
	var43.create_new({{"Missed "},{var608,true},{"'s in "},{var607,true},{" due "},{var602.reason,true}});
	var22.color_log(var603, var604, var605, var20.format("[onesense] ~ Missed %s in %s due to %s (hc: %s, bt: %s)", var606, var607, var602.reason, var610, var609));
end,hit=function(var611, var612, var613)
	local var614, var615, var616 = var611.ui.menu.global.color:get();
	local var617 = var24.get_player_name(var612.target);
	local var618 = var611.hitboxes[var612.hitgroup] or "?";
	local var619 = var611.helpers:limit_ch(var617, 15, "...");
	local var620 = var19.max(0, var24.get_prop(var612.target, "m_iHealth"));
	local var621 = var612.damage;
	local var622 = var26.tickcount() - var612.tick;
	local var623 = var19.floor(var612.hit_chance);
	var43.create_new({{"Hit "},{var619,true},{"'s in "},{var618,true},{" for "},{var621,true}});
	var22.color_log(var614, var615, var616, var20.format("[onesense] ~ Hit %s in %s for %s (remaning hp %s, hc: %s, bt: %s)", var617, var618, var621, var620, var623, var622));
end,shot=0,evade=function(var624, var625)
	local var626 = var24.get_local_player();
	local var627, var628, var629 = var624.ui.menu.global.color:get();
	if (var626 == nil) then
		return;
	end
	local var630 = var22.userid_to_entindex(var625.userid);
	local var631 = var24.get_player_name(var630);
	local var632 = var19.floor(var22.latency() * 1000);
	local var633 = var624.antiaim:get_best_side();
	if ((var630 == var24.get_local_player()) or not var24.is_enemy(var630) or not var24.is_alive(var626)) then
		return nil;
	end
	if var624.helpers:fired_shot(var626, var630, {var625.x,var625.y,var625.z}) then
		if (var624.shot ~= var26.tickcount()) then
			var22.color_log(var627, var628, var629, var20.format("[onesense] ~ Detected %s shot (%s ms, anti-aim side: %s)", var631, var632, var633));
			var43.create_new({{"Detected "},{var631,true},{"'s shot "},{("(" .. var632 .. "ms)"),true}});
		end
		var624.shot = var26.tickcount();
	end
end,evade2=function(var634, var635)
	local var636 = var24.get_local_player();
	if (var636 == nil) then
		return;
	end
	if ((enemy == var24.get_local_player()) or not var24.is_enemy(enemy) or not var24.is_alive(var636)) then
		return nil;
	end
	if var634.helpers:fired_shot(var636, enemy, {var635.x,var635.y,var635.z}) then
		var634.defensive:def_reset();
	end
end,harmed=function(var637, var638)
	local var639 = var24.get_local_player();
	local var640 = var22.userid_to_entindex(var638.attacker);
	local var641 = var22.userid_to_entindex(var638.userid);
	local var642 = var638.dmg_health;
	local var643 = var24.get_player_name(var640);
	local var644 = var637.hitboxes[var638.hitgroup];
	if (var640 == var639) then
		return;
	end
	if (var641 ~= var639) then
		return;
	end
	var43.create_new({{("Get " .. var642 .. " damage by ")},{(var643 .. "'s in " .. var644),true}});
end}):struct("unloads")({setup=function(var645)
	local var646 = var645.ui.menu.tools.animscope:get();
	local var647 = var645.ui.menu.tools.animscope_fov_slider:get();
	if var646 then
		var21.set(var645.ref.misc.fov, var647);
	end
	var645.ui:shutdown();
	var21.set(var645.ref.rage.enable, true);
end});
for var648, var649 in var2({{"load",function()
	var49.ui:execute();
	var49.config:setup();
end},{"aim_miss",function(shot)
	if (var49.ui.menu.tools.notify_master:get() and var49.ui.menu.tools.notify_vibor:get("Miss")) then
		var49.logs:miss(shot);
	end
end},{"aim_hit",function(shot)
	if (var49.ui.menu.tools.notify_master:get() and var49.ui.menu.tools.notify_vibor:get("Hit")) then
		var49.logs:hit(shot);
	end
end},{"bullet_impact",function(event)
	if (var49.ui.menu.tools.notify_master:get() and var49.ui.menu.tools.notify_vibor:get("Detect shot")) then
		var49.logs:evade(event);
	end
	var49.logs:evade2(event);
end},{"player_death",function(e)
	if var49.ui.menu.tools.trashtalk:get() then
		var49.misc:trashtalk(e);
	end
end},{"player_hurt",function(event)
	if (var49.ui.menu.tools.notify_master:get() and var49.ui.menu.tools.notify_vibor:get("Get harmed")) then
		var49.logs:harmed(event);
	end
end},{"setup_command",function(cmd)
	var49.antiaim:run(cmd);
	var49.misc:air_stopchance(cmd);
	var49.misc:unsafe_charge();
	if var49.ui.menu.tools.fast_ladder:get() then
		var49.misc:fast_ladder(cmd);
	end
end},{"paint",function()
	var49.tools:crosshair();
	if var49.ui.menu.tools.manuals:get() then
		var49.tools:manuals();
	end
	if var49.ui.menu.tools.indicator_dmg:get() then
		var49.tools:ind_dmg();
	end
	var49.tools:viewmodel();
	if var49.ui.menu.tools.keylist:get() then
		var49.tools:keylist();
	end
	if var49.ui.menu.tools.watermark:get() then
		var49.tools:watermark();
	end
	var49.tools:scopedu();
	if var49.ui.menu.tools.gs_ind:get() then
		var49.tools:gs_ind();
	end
end},{"shutdown",function(self)
	var49.unloads:setup();
end},{"paint_ui",function()
	if var21.is_menu_open() then
		var49.helpers:menu_visibility(false);
		var49.tools:menu_setup();
	end
end},{"pre_render",function()
	if var49.ui.menu.tools.animations:get() then
		var49.antiaim:animations();
	end
end},{"round_prestart",function()
	var49.round_reset:auto_buy();
end},{"net_update_end",function()
	var49.defensive:defensive_active();
end}}) do
	local var650 = var649[1];
	local var651 = var649[2];
	if (var650 == "load") then
		var651();
	else
		var22.set_event_callback(var650, var651);
	end
end