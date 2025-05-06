--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.8) ~  Much Love, Ferib 

]]--

local govno = "peg.lr(4y7u812uy8u8asu8jaseu8jsaeu8a6G6A9G6a6g96SH00S77agh7hu4aH7U00A73h707A37Y8a3A78903A773897893A789A3789a37890A78309a789037890A7890a7890A78a3787A38789a378A3789a3789A37897A3897a38978Aey78ae8Y78A07089A0UE8a0ye8-eaUJ08E0am,,AM30a07yA3Y7a370yA3Y7a37y0A3Y703a7y0A3Y77AY8emY70EYa3TA9036Eae0A3aey83m,A 3E0-a8pyA0M3a)";
local v0 = error;
local v1 = setmetatable;
local v2 = ipairs;
local v3 = pairs;
local v4 = next;
local v5 = printf;
local v6 = rawequal;
local v7 = rawset;
local v8 = rawlen;
local v9 = readfile;
local v10 = writefile;
local v11 = require;
local v12 = tonumber;
local v13 = toticks;
local v14 = type;
local v15 = unpack;
local v16 = pcall;
local function v17(v51)
	local v52 = {};
	for v663, v664 in v4, v51 do
		v52[v663] = v664;
	end
	return v52;
end
local v18 = v17(table);
local v19 = v17(math);
local v20 = v17(string);
local v21 = v17(ui);
local v22 = v17(client);
local v23 = v17(database);
local v24 = v17(entity);
local v25 = v17(v11("ffi"));
local v26 = v17(globals);
local v27 = v17(panorama);
local v28 = v17(renderer);
local v29 = v17(bit);
local function v30(v53)
	if v53 then
		return v11(v53);
	else
		v0("nope" .. v53);
	end
end
local v31 = v30("vector");
local v32 = v30("gamesense/pui");
local v33 = v30("gamesense/base64");
local v34 = v30("gamesense/clipboard");
local v35 = v30("gamesense/entity");
local v36 = v30("gamesense/http");
local v37 = {color={164,210,212},offset=0,blured=false};
local v38 = function(v54, v55, v56)
	return (function()
		local v666 = {};
		local v667, v668, v669, v670, v671, v672, v673, v674, v675, v676, v677, v678, v679, v680;
		local v681 = {__index={drag=function(v823, ...)
			local v824, v825 = v823:get();
			local v826, v827 = v666.drag(v824, v825, ...);
			if ((v824 ~= v826) or (v825 ~= v827)) then
				v823:set(v826, v827);
			end
			return v826, v827;
		end,set=function(v828, v829, v830)
			local v831, v832 = v22.screen_size();
			v21.set(v828.x_reference, (v829 / v831) * v828.res);
			v21.set(v828.y_reference, (v830 / v832) * v828.res);
		end,get=function(v833, v834, v835)
			local v836, v837 = v22.screen_size();
			return ((v21.get(v833.x_reference) / v833.res) * v836) + (v834 or 0), ((v21.get(v833.y_reference) / v833.res) * v837) + (v835 or 0);
		end}};
		v666.new = function(v838, v839, v840, v841)
			v841 = v841 or 10000;
			local v842, v843 = v22.screen_size();
			local v844 = v21.new_slider("misc", "settings", "one::x:" .. v838, 0, v841, (v839 / v842) * v841);
			local v845 = v21.new_slider("misc", "settings", "one::y:" .. v838, 0, v841, (v840 / v843) * v841);
			v21.set_visible(v844, false);
			v21.set_visible(v845, false);
			return v1({name=v838,x_reference=v844,y_reference=v845,res=v841}, v681);
		end;
		v666.drag = function(v846, v847, v848, v849, v850, v851, v852)
			if (v26.framecount() ~= v667) then
				v668 = v21.is_menu_open();
				v671, v672 = v669, v670;
				v669, v670 = v21.mouse_position();
				v674 = v673;
				v673 = v22.key_state(1) == true;
				v678 = v677;
				v677 = {};
				v680 = v679;
				v679 = false;
				v675, v676 = v22.screen_size();
			end
			if (v668 and (v674 ~= nil)) then
				if ((not v674 or v680) and v673 and (v671 > v846) and (v672 > v847) and (v671 < (v846 + v848)) and (v672 < (v847 + v849))) then
					v28.rectangle(v846, v847, v848, v849, 255, 255, 255, 5);
					v679 = true;
					v846, v847 = (v846 + v669) - v671, (v847 + v670) - v672;
					if not v851 then
						v846 = v19.max(0, v19.min(v675 - v848, v846));
						v847 = v19.max(0, v19.min(v676 - v849, v847));
					end
				end
			end
			v18.insert(v677, {v846,v847,v848,v849});
			return v846, v847, v848, v849;
		end;
		return v666;
	end)().new(v54, v55, v56);
end;
local v39 = v27.open();
local v40 = v39.MyPersonaAPI.GetName();
local v41 = {round=8,name=v40,build="beta",vers="1.7"};
local v42 = v28.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0B\x00\x00\x00\x0B\x08\x06\x00\x00\x00\xA9\xAC\x77\x26\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x01\x33\x49\x44\x41\x54\x28\x53\x35\x91\xBD\x4A\x03\x51\x10\x85\xEF\x4F\x88\x91\x25\x60\x14\x35\x85\x58\xA9\x28\xDA\x08\xC1\x22\x0A\x62\x97\x07\x08\xA9\xD5\xD6\x07\xF0\x21\xB4\xB4\xD3\xD2\x32\xA6\x48\x61\x61\x23\x69\x2C\x14\x41\xB0\x51\x0B\x21\xC1\x42\xB0\x10\x7F\xD6\x80\xEE\xDD\xF5\x3B\x62\x06\x3E\xCE\xCC\x99\xB9\x73\xEF\x26\x36\x49\x92\x21\xE7\xDC\xBA\xB5\x76\x33\xCB\xB2\x37\xB8\x4A\xD3\xB4\x4D\xED\xF1\x47\x8C\x31\x29\x14\xE0\xD1\xD0\xA8\x31\x70\x8D\x9E\x42\x39\x8E\x63\x4B\x43\xFE\x22\xFE\x19\x5C\xC2\x7E\x08\x61\xD4\xB1\xA1\x4E\x6F\x1E\xDA\x6C\x7A\x8E\xA2\x28\xA3\xE1\x18\xC8\xE1\x8D\x43\xE5\x5F\xFB\x32\x6B\x24\x79\x0E\x7D\xA1\x83\x28\x52\xAF\xA1\x31\x9C\xC3\x24\xF5\x94\x36\x97\x28\x3C\x87\x56\x51\xC3\x37\x38\x44\x79\x09\x6F\x17\xB6\x78\x52\x93\x7A\x45\x6F\x7B\xC0\x50\xF4\xB8\x7E\x8E\xE1\x3C\x5A\xC1\x9F\xD0\x73\xB4\x80\x7C\x09\x8E\x95\x1C\x30\xF8\x23\xC8\x4F\x60\x81\x03\x7F\x1F\xA9\xA0\x2E\xD0\x6B\xC0\xAD\x8A\x2A\xC9\x1D\x28\xFA\xD0\xC1\xDB\x81\x65\x98\x85\x6D\xBC\x0B\xB8\x37\x5C\x35\x8C\x71\x48\xF1\x0D\x83\x08\xF0\x09\xEF\xA0\x05\x1F\xCC\xEC\xE9\x4D\xD3\xF0\x8A\x71\x84\x76\x75\x33\xC8\x8F\xA0\x08\x01\x3A\xD0\xD2\x3F\x38\x43\x92\x63\xF8\xC9\x7B\x5F\x25\xAF\xF3\x0B\x6D\xA0\x63\x78\x2F\x68\x93\xBA\x15\x42\xB8\xF9\x05\xD4\x19\x01\x8D\xAD\x75\xE9\x3B\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 11, 11);
local v43 = {clamp=function(v57, v58, v59)
	assert(v57 and v58 and v59, "");
	if (v58 > v59) then
		v58, v59 = v59, v58;
	end
	return v19.max(v58, v19.min(v59, v57));
end,rect_v=function(v60, v61, v62, v63, v64, v65, v66, v67)
	local v68, v69, v70, v71 = v15(v64);
	local v72, v73, v74, v75;
	v28.circle(v60 + v65, v61 + v65, v68, v69, v70, v71, v65, 180, 0.25);
	v28.rectangle(v60 + v65, v61, (v62 - v65) - v65, v65, v68, v69, v70, v71);
	v28.circle((v60 + v62) - v65, v61 + v65, v68, v69, v70, v71, v65, 90, 0.25);
	v28.rectangle(v60, v61 + v65, v62, v63 - v65, v68, v69, v70, v71);
	if v66 then
		v72, v73, v74, v75 = v15(v66);
		v28.rectangle(v60, v61 + v63, v62, v63 - (v63 + (v67 or 2)), v72, v73, v74, v75);
	end
end};
local v44 = (function()
	local v76 = v31;
	local v77 = function(v684, v685, v686)
		return ((v685 - v684) * v686) + v684;
	end;
	local v78 = function(v687, v688, v689)
		v689 = v43.clamp(v26.absoluteframetime() * (v689 or 0.005) * 175, 0.01, 1);
		local v690 = v77(v687, v688, v689);
		return v690;
	end;
	local v79 = function()
		return v76(v22.screen_size());
	end;
	local v80 = function(v691, ...)
		local v692 = {...};
		local v692 = v18.concat(v692, "");
		return v76(v28.measure_text(v691, v692));
	end;
	local v81 = {notifications={bottom={}},max={bottom=6}};
	v81.__index = v81;
	v81.create_new = function(...)
		v18.insert(v81.notifications.bottom, {started=false,instance=v1({active=false,timeout=5,color={r=0,g=0,b=0,a=0},x=(v79().x / 2),y=v79().y,text=...}, v81)});
	end;
	v81.handler = function(v693)
		local v694 = 0;
		local v695 = 0;
		for v853, v854 in v3(v81.notifications.bottom) do
			if (not v854.instance.active and v854.started) then
				v18.remove(v81.notifications.bottom, v853);
			end
		end
		for v855 = 1, #v81.notifications.bottom do
			if v81.notifications.bottom[v855].instance.active then
				v695 = v695 + 1;
			end
		end
		for v856, v857 in v3(v81.notifications.bottom) do
			if (v856 > v81.max.bottom) then
				return;
			end
			if v857.instance.active then
				v857.instance:render_bottom(v694, v695);
				v694 = v694 + 1;
			end
			if not v857.started then
				v857.instance:start();
				v857.started = true;
			end
		end
	end;
	v81.start = function(v696)
		v696.active = true;
		v696.delay = v26.realtime() + v696.timeout;
	end;
	v81.get_text = function(v699)
		local v700 = "";
		for v858, v858 in v3(v699.text) do
			local v859 = v80("", v858[1]);
			local v859, v860, v861 = 255, 255, 255;
			if v858[2] then
				v859, v860, v861 = v37.color[1], v37.color[2], v37.color[3];
			end
			v700 = v700 .. ("\a%02x%02x%02x%02x%s"):format(v859, v860, v861, v699.color.a, v858[1]);
		end
		return v700;
	end;
	local v87 = (function()
		local v701 = {};
		v701.rect = function(v862, v863, v864, v865, v866, v867, v868, v869, v870)
			v870 = v19.min(v862 / 2, v863 / 2, v870);
			v28.rectangle(v862, v863 + v870, v864, v865 - (v870 * 2), v866, v867, v868, v869);
			v28.rectangle(v862 + v870, v863, v864 - (v870 * 2), v870, v866, v867, v868, v869);
			v28.rectangle(v862 + v870, (v863 + v865) - v870, v864 - (v870 * 2), v870, v866, v867, v868, v869);
			v28.circle(v862 + v870, v863 + v870, v866, v867, v868, v869, v870, 180, 0.25);
			v28.circle((v862 - v870) + v864, v863 + v870, v866, v867, v868, v869, v870, 90, 0.25);
			v28.circle((v862 - v870) + v864, (v863 - v870) + v865, v866, v867, v868, v869, v870, 0, 0.25);
			v28.circle(v862 + v870, (v863 - v870) + v865, v866, v867, v868, v869, v870, -90, 0.25);
		end;
		v701.rect_o = function(v871, v872, v873, v874, v875, v876, v877, v878, v879, v880)
			v879 = v19.min(v873 / 2, v874 / 2, v879);
			if (v879 == 1) then
				v28.rectangle(v871, v872, v873, v880, v875, v876, v877, v878);
				v28.rectangle(v871, (v872 + v874) - v880, v873, v880, v875, v876, v877, v878);
			else
				v28.rectangle(v871 + v879, v872, v873 - (v879 * 2), v880, v875, v876, v877, v878);
				v28.rectangle(v871 + v879, (v872 + v874) - v880, v873 - (v879 * 2), v880, v875, v876, v877, v878);
				v28.rectangle(v871, v872 + v879, v880, v874 - (v879 * 2), v875, v876, v877, v878);
				v28.rectangle((v871 + v873) - v880, v872 + v879, v880, v874 - (v879 * 2), v875, v876, v877, v878);
				v28.circle_outline(v871 + v879, v872 + v879, v875, v876, v877, v878, v879, 180, 0.25, v880);
				v28.circle_outline(v871 + v879, (v872 + v874) - v879, v875, v876, v877, v878, v879, 90, 0.25, v880);
				v28.circle_outline((v871 + v873) - v879, v872 + v879, v875, v876, v877, v878, v879, -90, 0.25, v880);
				v28.circle_outline((v871 + v873) - v879, (v872 + v874) - v879, v875, v876, v877, v878, v879, 0, 0.25, v880);
			end
		end;
		v701.glow = function(v881, v882, v883, v884, v885, v886, v887, v888, v889, v890, v891, v892, v893, v894, v894)
			local v895 = 1;
			local v896 = 1;
			if v894 then
				v701.rect(v881, v882, v883, v884, v887, v888, v889, v890, v886);
			end
			for v948 = 0, v885 do
				local v949 = (v890 / 2) * ((v948 / v885) ^ 3);
				v701.rect_o(v881 + (((v948 - v885) - v896) * v895), v882 + (((v948 - v885) - v896) * v895), v883 - (((v948 - v885) - v896) * v895 * 2), v884 - (((v948 - v885) - v896) * v895 * 2), v891, v892, v893, v949 / 1.5, v886 + (v895 * ((v885 - v948) + v896)), v895);
			end
		end;
		return v701;
	end)();
	v81.render_bottom = function(v705, v706, v707)
		local v708 = v79();
		local v709 = 16;
		local v710 = "     " .. v705:get_text();
		local v711 = v80("", v710);
		local v712 = v41.round;
		local v713, v714, v715 = v37.color[1], v37.color[2], v37.color[3];
		local v716, v717, v718 = 15, 15, 15;
		local v719 = 2;
		local v720 = 0 + v709 + v711.x;
		local v720, v721 = v720 + (v719 * 2), 23;
		local v722, v723 = v705.x - (v720 / 2), v19.ceil((v705.y - 40) + 0.4);
		local v724 = v26.frametime();
		if (v26.realtime() < v705.delay) then
			v705.y = v78(v705.y, (v708.y - v37.offset) - ((v707 - v706) * v721 * 1.5), v724 * 7);
			v705.color.a = v78(v705.color.a, 255, v724 * 2);
		else
			v705.y = v78(v705.y, v705.y + 5, v724 * 15);
			v705.color.a = v78(v705.color.a, 0, v724 * 20);
			if (v705.color.a <= 1) then
				v705.active = false;
			end
		end
		local v725, v708, v706, v707 = v705.color.r, v705.color.g, v705.color.b, v705.color.a;
		local v726 = (v37.blured and 18) or 0;
		local v727 = v719 + 2;
		v727 = v727 + 0 + v709;
		if not v37.blured then
			v87.glow(v722 + 26, v723, v720 - 15, v721, 12, v712, v716, v717, v718, v707, v713, v714, v715, v707, true);
			v87.glow(v722 - 5, v723, 25, v721, 12, v712, v716, v717, v718, v707, v713, v714, v715, v707, true);
			v28.texture(v42, (v722 + v727) - 18, ((v723 + (v721 / 2)) - (v711.y / 2)) + 1, 11, 11, v713, v714, v715, v707);
		else
			v43.rect_v(v722 + 5, v723, v720 - 12, v721 + 1, {v716,v717,v718,(170 * (v707 / 255))}, 6, {v713,v714,v715,v707});
		end
		v28.text((v722 + v727) - v726, (v723 + (v721 / 2)) - (v711.y / 2), v725, v708, v706, v707, "", nil, v710);
	end;
	v22.set_event_callback("paint_ui", function()
		v81:handler();
	end);
	return v81;
end)();
v22.delay_call(1, function()
	v44.create_new({{"Welcome back, "},{v41.name,true},{" to onesense "},{v41.build,true},{(" " .. v41.vers),false}});
end);
local v45 = [[struct {char         __pad_0x0000[0x1cd]; bool         hide_vm_scope; }]];
local v46 = v22.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0");
local v47 = v25.cast("void****", v25.cast("char*", v46) + 2)[0];
local v48 = vtable_thunk(2, v45 .. "*(__thiscall*)(void*, unsigned int)");
local v49 = function()
	local v89, v90, v91 = {}, {}, {};
	v89.__metatable = false;
	v90.struct = function(v728, v729)
		assert(v14(v729) == "string", "invalid class name");
		assert(rawget(v728, v729) == nil, "cannot overwrite subclass");
		return function(v897)
			assert(v14(v897) == "table", "invalid class data");
			v7(v728, v729, v1(v897, {__metatable=false,__index=function(v954, v955)
				return rawget(v89, v955) or rawget(v91, v955);
			end}));
			return v91;
		end;
	end;
	v91 = v1(v90, v89);
	return v91;
end;
local v50 = v49():struct("globals")({states={"stand","slow walk","run","crouch","sneak","aerobic","aerobic+","manual left","manual right","fakelag","hideshots"},extended_states={"global","stand","slow walk","run","crouch","sneak","aerobic","aerobic+","manual left","manual right","fakelag","hideshots"},def_ways={"1-way","2-way","3-way","4-way","5-way"},keylist_icon=v28.load_png("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", 15, 15)}):struct("ref")({aa={enabled={v21.reference("aa", "anti-aimbot angles", "enabled")},pitch={v21.reference("aa", "anti-aimbot angles", "pitch")},yaw_base={v21.reference("aa", "anti-aimbot angles", "Yaw base")},yaw={v21.reference("aa", "anti-aimbot angles", "Yaw")},yaw_jitter={v21.reference("aa", "anti-aimbot angles", "Yaw Jitter")},body_yaw={v21.reference("aa", "anti-aimbot angles", "Body yaw")},freestanding_body_yaw={v21.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},freestand={v21.reference("aa", "anti-aimbot angles", "Freestanding")},roll={v21.reference("aa", "anti-aimbot angles", "Roll")},edge_yaw={v21.reference("aa", "anti-aimbot angles", "Edge yaw")},fake_peek={v21.reference("aa", "other", "Fake peek")}},misc={log={v21.reference("misc", "miscellaneous", "Log damage dealt")},fov=v21.reference("misc", "miscellaneous", "Override FOV"),override_zf=v21.reference("misc", "miscellaneous", "Override zoom FOV")},fakelag={enable={v21.reference("aa", "fake lag", "enabled")},amount={v21.reference("aa", "fake lag", "amount")},variance={v21.reference("aa", "fake lag", "variance")},limit={v21.reference("aa", "fake lag", "limit")},lg={v21.reference("aa", "other", "Leg movement")}},aa_other={sw={v21.reference("aa", "other", "Slow motion")},hide_shots={v21.reference("aa", "other", "On shot anti-aim")}},rage={enable=v21.reference("rage", "aimbot", "Enabled"),dt={v21.reference("rage", "aimbot", "Double tap")},fd={v21.reference("rage", "other", "Duck peek assist")},os={v21.reference("aa", "other", "On shot anti-aim")},mindmg={v21.reference("rage", "aimbot", "minimum damage")},ovr={v21.reference("rage", "aimbot", "minimum damage override")}},slow_motion={v21.reference("aa", "other", "Slow motion")}}):struct("ui")({menu={global={},home={},antiaim={},tools={}},header=function(v94, v95)
	local v96 = "\a373737FF";
	local v97 = "──────────────────────────";
	return v95:label(v96 .. v97);
end,clr=function(v98, v99)
	local v100 = {gray="\a808080FF",l_gray="\a909090FF",d_gray="\a606060FF",red="\aff0000ff"};
	for v730, v731 in v3(v100) do
		if (v99 == v730) then
			return v731;
		end
	end
	return "error color";
end,execute=function(v101)
	local v102 = v32.group("AA", "anti-aimbot angles");
	local v103 = v32.group("AA", "Fake lag");
	local v104 = v32.group("AA", "Other");
	local v105 = "\a808080FF•\r  ";
	v101.menu.global.title_name = v103:label("\v~⋆⋅☆⋅⋆⛧°/\r  " .. v101.helpers:limit_ch(v40, 13, "..."));
	v101.menu.global.tab = v103:combobox("\n tabs", {" Home"," Anti-Aim"," Tools"});
	v101.menu.global.color = v103:color_picker("\naccent", 164, 210, 212, 255):depend({v101.menu.global.tab," Home"});
	v101:header(v103);
	v101.menu.global.export = v103:button(v101:clr("d_gray") .. "\r Export config", function()
		v34.set(v101.config:export("config"));
	end):depend({v101.menu.global.tab," Anti-Aim",true});
	v101.menu.global.import = v103:button(v101:clr("d_gray") .. "\r  Import config", function()
		v101.config:import(v34.get(), "config");
	end):depend({v101.menu.global.tab," Anti-Aim",true});
	v101.menu.home.welcomer = v102:label("Welcome to \vonesense\r " .. v41.vers .. "");
	v101.menu.home.space = v101:header(v102);
	v101.menu.home.list = v102:listbox("configs", {});
	v101.menu.home.list:set_callback(function()
		if v21.is_menu_open() then
			v101.config:update_name();
		end
	end);
	v101.menu.home.name = v102:textbox("config name");
	v101.menu.home.load = v102:button(v101:clr("d_gray") .. "\r  Load", function()
		v101.config:load("config");
	end);
	v101.menu.home.save = v102:button(v101:clr("d_gray") .. "\r Save", function()
		v101.config:save();
	end);
	v101.menu.home.delete = v102:button(v101:clr("red") .. " Delete", function()
		v101.config:delete();
	end);
	v101.menu.home.discord_l = v104:label("\n");
	v101.menu.home.discord = v104:button(v101:clr("gray") .. "  Discord server\r", function()
		v39.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/zUKBpRrSss");
	end);
	v101.menu.home.youtube = v104:button("\a808080FF  Youtube coder join\r", function()
		v39.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@reloadhvh");
	end);
	v101.menu.antiaim.mode = v102:combobox(v105 .. "Anti-aim tab", {"Constructor","Features"});
	v101.menu.antiaim.space = v101:header(v102):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.freestanding = v102:multiselect("Freestanding \v", {"Force static","Disablers"}, 0):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.freestanding_disablers = v102:multiselect("\nfreestanding disablers", v101.globals.states):depend({v101.menu.antiaim.freestanding,"Disablers"}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.edge_yaw = v102:label("Edge yaw", 0):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.manual_aa = v102:checkbox("Manual aa \v"):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.manual_static = v102:checkbox(v105 .. "Manual static"):depend({v101.menu.antiaim.manual_aa,true}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.manual_left = v102:hotkey(v105 .. "Manual left"):depend({v101.menu.antiaim.manual_aa,true}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.manual_right = v102:hotkey(v105 .. "Manual right"):depend({v101.menu.antiaim.manual_aa,true}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.manual_forward = v102:hotkey(v105 .. "Manual forward"):depend({v101.menu.antiaim.manual_aa,true}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.fakelag_type = v103:combobox("Fake lag type", {"Maximum","Dynamic","Fluctuate"}):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.fakelag_var = v103:slider(v105 .. "Variance", 0, 100, 100, true, "%"):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.fakelag_lim = v103:slider(v105 .. "Limit", 1, 15, 15):depend({v101.menu.antiaim.mode,"Features"});
	v101.menu.antiaim.state = v102:combobox("\n current condition", v101.globals.extended_states):depend({v101.menu.antiaim.mode,"Constructor"});
	v101.menu.antiaim.states = {};
	for v732, v733 in v2(v101.globals.extended_states) do
		v101.menu.antiaim.states[v733] = {};
		local v735 = v101.menu.antiaim.states[v733];
		if (v733 ~= "global") then
			v735.enable = v102:checkbox("Activate \v" .. v733);
		end
		local v736 = "\n" .. v733;
		v735.options = v104:multiselect(v105 .. "Features" .. v736, {"Enable defensive","Avoid backstab","Safe head"});
		v735.head_1 = v101:header(v104);
		v735.defensive_conditions = v104:multiselect(v105 .. "Defensive triggers\v" .. v736, {"Always","Tick-Base","On weapon switch","On reload","On hittable","On freestand"}):depend({v735.options,"Enable defensive"});
		v735.defensive_conditions_tick = v104:slider("\n Tick" .. v736, 1, 15, 8, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_conditions,"Tick-Base"});
		v735.defensive_yaw = v102:checkbox("Defensive yaw" .. v736):depend({v735.options,"Enable defensive"});
		v735.defensive_yaw_mode = v102:combobox("\ndefensive yaw mode" .. v736, {"Jitter","Random","Custom spin","Spin-way","Switch 5-way"}):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true});
		v735.defensive_yaw_1_random = v102:slider("\n 1 random yaw def" .. v736, -359, 359, 180, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Random"});
		v735.defensive_yaw_2_random = v102:slider("\n 2 random yaw def" .. v736, -359, 359, -180, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Random"});
		v735.defensive_yaw_1_Spin_way = v102:slider("\n 1 stage Spin-way" .. v736, -180, 180, -180, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Spin-way"});
		v735.defensive_yaw_2_Spin_way = v102:slider("\n 2 stage Spin-way" .. v736, -180, 180, 180, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Spin-way"});
		v735.defensive_yaw_speed_Spin_way = v102:slider(v105 .. "Delay" .. v736, 0, 16, 6, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Spin-way"});
		v735.defensive_yaw_randomizer_Spin_way = v102:slider(v105 .. "Randomizer" .. v736, 0, 180, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Spin-way"});
		v735.defensive_yaw_jitter_radius_1 = v102:slider("\n JiTter 1" .. v736, -180, 180, 30, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Jitter"});
		v735.defensive_yaw_jitter_delay = v102:slider(v105 .. "Delayed" .. v736, 1, 12, 6, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Jitter"});
		v735.defensive_yaw_jitter_random = v102:slider(v105 .. "Randomize" .. v736, 0, 180, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Jitter"});
		v735.defensive_yaw_way_delay = v102:slider(v105 .. "Interpolation \v" .. v736, 0, 16, 4, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"});
		for v898 = 1, 5 do
			v735["defensive_yaw_way_switch" .. v898] = v102:slider((((v898 == 1) and (v105 .. "Ways")) or "\n") .. "\v \n" .. v898 .. v736, 0, 360, 30, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"});
		end
		v735.defensive_yaw_way_randomly = v102:checkbox(v105 .. "Increase yaw \v" .. v736):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"});
		v735.defensive_yaw_way_randomly_value = v102:slider("\n ramdom yaw value" .. v736, 0, 360, 20, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"}, {v735.defensive_yaw_way_randomly,true});
		v735.defensive_yaw_wayspin_combo = v102:combobox(v105 .. "Select spin way yaw" .. v736, v101.globals.def_ways):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"});
		for v900 = 1, 5 do
			local v901 = v900 .. "-way";
			v735["defensive_yaw_enable_way_spin" .. v900] = v102:checkbox("Enable spin \n " .. v900 .. v736):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"}, {v735.defensive_yaw_wayspin_combo,v901});
			v735["defensive_yaw_way_spin_limit" .. v900] = v102:slider("\n limit  way-" .. v900 .. " " .. v736, 0, 360, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"}, {v735["defensive_yaw_enable_way_spin" .. v900],true}, {v735.defensive_yaw_wayspin_combo,v901});
			v735["defensive_yaw_way_speed" .. v900] = v102:slider("\n speed way-" .. v900 .. " " .. v736, 1, 12, 8, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Switch 5-way"}, {v735["defensive_yaw_enable_way_spin" .. v900],true}, {v735.defensive_yaw_wayspin_combo,v901});
		end
		v735.defensive_yaw_spin_limit = v102:slider("\n limit spin yaw" .. v736, 15, 360, 360, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}):depend({v735.defensive_yaw_mode,"Custom spin"});
		v735.defensive_yaw_speedtick = v102:slider("\n spin speed" .. v736, 1, 12, 6, true, "t", 0.5):depend({v735.options,"Enable defensive"}, {v735.defensive_yaw,true}, {v735.defensive_yaw_mode,"Custom spin"});
		v735.defensive_pitch_enable = v103:checkbox("Defensive pitch" .. v736):depend({v735.options,"Enable defensive"});
		v735.defensive_pitch_mode = v103:combobox("\n defensive pitch mode" .. v736, {"Static","Spin","Random","Clocking","Jitter","5way"}):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true});
		v735.defensive_pitch_custom = v103:slider("\n pitch custom limit" .. v736, -89, 89, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"Clocking",true});
		v735.defensive_pitch_spin_random2 = v103:slider("\n pitch def random2" .. v736, -89, 89, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"Random"});
		v735.defensive_pitch_spin_limit2 = v103:slider("\n spin speed 2" .. v736, -89, 89, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"Spin"});
		v735.defensive_pitch_speedtick = v103:slider("\n spin speed" .. v736, 1, 64, 32, true, "t", 0.1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"Spin"});
		v735.defensive_pitch_way_label = v103:label(v105 .. "On \v5-way\r yaw to more \vsettings"):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}, {v735.defensive_yaw_mode,"Switch 5-way",true});
		for v905 = 2, 5 do
			v735["defensive_pitch_way" .. v905] = v103:slider("\n pitch way " .. v905 .. v736, -89, 89, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
		end
		v735.defensive_pitch_way_randomly = v103:checkbox(v105 .. "Increase pitch \v" .. v736):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
		v735.defensive_pitch_way_randomly_value = v103:slider("\n ramdom pitch value" .. v736, 0, 89, 20, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}, {v735.defensive_pitch_way_randomly,true}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
		v735.defensive_pitch_way_spin_combo = v103:combobox(v105 .. "Select spin way pitch" .. v736, v101.globals.def_ways):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
		for v907 = 1, #v101.globals.def_ways do
			local v908 = v101.globals.def_ways[v907];
			v735["defensive_pitch_enable_way_spin" .. v907] = v103:checkbox("Enable spin \n " .. v907 .. v736):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}, {v735.defensive_pitch_way_spin_combo,v908}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
			for v957 = 1, 2 do
				v735["defensive_pitch_way_spin_limit" .. v907 .. v957] = v103:slider("\n limit  way-" .. v907 .. v957 .. " " .. v736, -89, 89, 89, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735["defensive_pitch_enable_way_spin" .. v907],true}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}, {v735.defensive_pitch_way_spin_combo,v908}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
			end
			v735["defensive_pitch_way_speed" .. v907] = v103:slider("\n speed way-" .. v907 .. " " .. v736, 1, 12, 8, true, "t", 1):depend({v735.options,"Enable defensive"}, {v735["defensive_pitch_enable_way_spin" .. v907],true}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"5way"}, {v735.defensive_pitch_way_spin_combo,v908}):depend({v735.defensive_yaw_mode,"Switch 5-way"});
		end
		v735.defensive_pitch_clock = v103:slider("\n pitch clock limit" .. v736, -89, 89, 0, true, "°", 1):depend({v735.options,"Enable defensive"}, {v735.defensive_pitch_enable,true}, {v735.defensive_pitch_mode,"Jitter"});
		v735.head_2 = v101:header(v102);
		v735.yaw_base = v102:combobox(v105 .. "Yaw" .. v736, {"At targets","Local view"});
		v735.yaw_jitter = v102:combobox("\nyaw jitter" .. v736, {"Off","Offset","Center","Skitter","Smoothnes","Fractal","Random"});
		v735.yaw_jitter_add = v102:slider("\nyaw jitter add" .. v736, -90, 90, 0, true, "°", 1):depend({v735.yaw_jitter,"Off",true});
		v735.yaw_fractals = v102:slider(v105 .. "Fractals \v" .. v736, 1, 14, 0, true, "°", 1, {[14]="Random"}):depend({v735.yaw_jitter,"Off",true}, {v735.yaw_jitter,"Fractal"});
		v735.yaw_add = v102:slider(v105 .. "Yaw add \v" .. v736, -180, 180, 0, true, "°", 1);
		v735.yaw_add_r = v102:slider("\n yaw add (R)" .. v736, -180, 180, 0, true, "°", 1);
		v735.jitter_delay = v102:slider(v105 .. "Yaw delay  \v" .. v736, 0, 4, 0, true, "x", 1, {[1]="Randomly",[0]="Off"});
		v735.yaw_random = v102:slider(v105 .. "Yaw randomize \v" .. v736, 0, 100, 0, true, "%", 1):depend({v735.yaw_jitter,"Off",true});
		v735.head_3 = v101:header(v102);
		v735.body_yaw = v102:combobox(v105 .. "Body yaw" .. v736, {"Off","Opposite","Static","Jitter"});
		v735.body_yaw_side = v102:combobox("\n Body yaw side" .. v736, {"Left","Right","Freestanding"}):depend({v735.body_yaw,"Static",false});
		for v911, v912 in v3(v735) do
			local v913 = {{v101.menu.antiaim.state,v733},{v101.menu.antiaim.mode,"Constructor"}};
			if ((v911 ~= "enable") and (v733 ~= "global")) then
				v913 = {{v101.menu.antiaim.state,v733},{v101.menu.antiaim.mode,"Constructor"},{v735.enable,true}};
			end
			v912:depend(v18.unpack(v913));
		end
	end
	v101.menu.antiaim.export = v104:button(v101:clr("d_gray") .. "\r  Export condition", function()
		data = v101.config:export("state", v101.menu.antiaim.state:get());
		v34.set(data);
	end):depend({v101.menu.antiaim.mode,"Constructor"});
	v101.menu.antiaim.import = v104:button(v101:clr("d_gray") .. "\r  Import condition ", function()
		local v781 = v34.get();
		local v782 = v781:match("{onesense:(.+)}");
		v101.config:import(v781, v782, v101.menu.antiaim.state:get());
	end):depend({v101.menu.antiaim.mode,"Constructor"});
	v101.menu.tools.subtub = v102:combobox(v105 .. "Active tab", {"Helpers","Visuals"});
	v101.menu.tools.subtub_n = v102:label("\n");
	local v140 = v101.menu.tools.subtub;
	v101.menu.tools.indicators = v102:checkbox("\v\r Crosshair indicators"):depend({v140,"Visuals"});
	v101.menu.tools.indicator_pos = v102:combobox("\n position ind", {"Left","Right"}):depend({v101.menu.tools.indicators,true}):depend({v140,"Visuals"});
	v101.menu.tools.indicatorfont = v102:combobox(v105 .. "Indicator style", {"Default","New","Renewed","Icons","Onesense"}):depend({v101.menu.tools.indicators,true}):depend({v140,"Visuals"});
	v101.menu.tools.indicator_bind = v102:checkbox(v105 .. "Show binds"):depend({v101.menu.tools.indicators,true}, {v140,"Visuals"}, {v101.menu.tools.indicatorfont,"Onesense"});
	v101.menu.tools.indicatoroffset = v102:slider("\n Offset indcator ", 0, 90, 35, true, "px"):depend({v101.menu.tools.indicators,true}):depend({v140,"Visuals"});
	v101.menu.tools.manuals = v102:checkbox("\v\r Manual arrows"):depend({v140,"Visuals"});
	v101.menu.tools.manuals_style = v102:combobox("\n arrows style", {"Onesense","New"}):depend({v140,"Visuals"}, {v101.menu.tools.manuals,true});
	v101.menu.tools.manuals_global = v102:checkbox("Arrows side"):depend({v140,"Visuals"}, {v101.menu.tools.manuals,true});
	v101.menu.tools.manuals_offset = v102:slider("\n arrows offset", 0, 100, 15, true, "px"):depend({v140,"Visuals"}, {v101.menu.tools.manuals,true});
	v101.menu.tools.animscope = v102:checkbox("\v\r Animated scope"):depend({v140,"Visuals"});
	v101.menu.tools.animscope_fov_slider = v102:slider(v105 .. "Fov value", 105, 135, 130, true, "%", 1):depend({v101.menu.tools.animscope,true}):depend({v140,"Visuals"});
	v101.menu.tools.animscope_slider = v102:slider("\n Anim scope value", 0, 100, 5, true, "%", 1):depend({v101.menu.tools.animscope,true}):depend({v140,"Visuals"});
	v101.menu.tools.indicator_dmg = v102:checkbox("\v\r Damage indicator"):depend({v140,"Visuals"});
	v101.menu.tools.indicator_dmg_color = v102:color_picker("\ncolor dmg", 255, 255, 255):depend({v101.menu.tools.indicator_dmg,true}):depend({v140,"Visuals"});
	v101.menu.tools.indicator_dmg_weapon = v102:checkbox(v105 .. "Only min damage"):depend({v101.menu.tools.indicator_dmg,true}):depend({v140,"Visuals"});
	v101.menu.tools.visual_head_1 = v102:label("\n"):depend({v140,"Visuals"});
	v101.menu.tools.style = v102:combobox("\v\r Widgets style", {"New","Default"}):depend({v140,"Visuals"});
	v101.menu.tools.watermark = v102:checkbox("\v\r Watermark"):depend({v140,"Visuals"});
	v101.menu.tools.keylist = v102:checkbox("\v\r Hotkeys"):depend({v140,"Visuals"});
	v101.menu.tools.notify_master = v102:checkbox("\v\r Logging"):depend({v140,"Visuals"});
	v101.menu.tools.notify_vibor = v102:multiselect("\n Log type", {"Hit","Miss","Get harmed","Detect shot","Preview"}):depend({v101.menu.tools.notify_master,true}):depend({v140,"Visuals"});
	v101.menu.tools.notify_offset = v102:slider("\n Offset notifys ", 0, 900, 45, true, "px", 1):depend({v101.menu.tools.notify_master,true}):depend({v140,"Visuals"});
	v101.menu.tools.notify_test = v102:button("\v✨", function()
		v44.create_new({{"Example: "},{"logging ",true},{"12345"}});
	end):depend({v101.menu.tools.notify_vibor,"Preview"}, {v101.menu.tools.notify_master,true}):depend({v140,"Visuals"});
	v101.menu.tools.visual_head_2 = v102:label("\n"):depend({v140,"Visuals"});
	v101.menu.tools.gs_ind = v102:checkbox("\v\r Indicators left gs"):depend({v140,"Visuals"});
	v101.menu.tools.gs_inds = v102:multiselect("\n inds selc", {"Target","..."}):depend({v140,"Visuals"}, {v101.menu.tools.gs_ind,true});
	v101.menu.tools.viewmodel_on = v102:checkbox("\v\r Viewmodel modifier"):depend({v140,"Visuals"});
	v101.menu.tools.viewmodel_scope = v102:checkbox("\v\r Show weapon scoped"):depend({v140,"Visuals"});
	v101.menu.tools.viewmodel_mod = v102:combobox("\nstyleview", {"Without-scope","In-scope"}):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true});
	v101.menu.tools.viewmodel_x1 = v102:slider("\nviewwithoscope-x", -100, 100, 0, true, "x", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"Without-scope"});
	v101.menu.tools.viewmodel_y1 = v102:slider("\nviewwithoscope-y", -100, 100, -5, true, "y", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"Without-scope"});
	v101.menu.tools.viewmodel_z1 = v102:slider("\nviewwithoscope-z", -100, 100, -1, true, "z", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"Without-scope"});
	v101.menu.tools.viewmodel_fov1 = v102:slider(v105 .. "Fov\n without scope", 0, 170, 61, true, "x", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"Without-scope"});
	v101.menu.tools.viewmodel_inscope = v102:checkbox("Override scope"):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"In-scope"});
	v101.menu.tools.viewmodel_x2 = v102:slider("\nview with x", -100, 100, -4, true, "x", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"In-scope"}, {v101.menu.tools.viewmodel_inscope,true});
	v101.menu.tools.viewmodel_y2 = v102:slider("\nview with y", -100, 100, -5, true, "y", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"In-scope"}, {v101.menu.tools.viewmodel_inscope,true});
	v101.menu.tools.viewmodel_z2 = v102:slider("\nview with z", -100, 100, -1, true, "z", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"In-scope"}, {v101.menu.tools.viewmodel_inscope,true});
	v101.menu.tools.viewmodel_fov2 = v102:slider(v105 .. "Fov\n with ov", 0, 170, 61, true, "x", 1):depend({v140,"Visuals"}, {v101.menu.tools.viewmodel_on,true}, {v101.menu.tools.viewmodel_mod,"In-scope"}, {v101.menu.tools.viewmodel_inscope,true});
	v101.menu.tools.air_stop = v102:checkbox("\v\r Jumpscout", 0):depend({v140,"Helpers"});
	v101.menu.tools.air_stop_distance = v102:slider("\n Distance", 1, 25, 2, true, "ft", 5, {[25]="Always"}):depend({v140,"Helpers"}, {v101.menu.tools.air_stop,true});
	v101.menu.tools.unsafe_charge = v102:checkbox("\v\r Unsafe charge"):depend({v140,"Helpers"});
	v101.menu.tools.m1sc_head_2 = v102:label("\n"):depend({v140,"Helpers"});
	v101.menu.tools.fast_ladder = v102:checkbox("\v\r Fast ladder"):depend({v140,"Helpers"});
	v101.menu.tools.trashtalk = v102:checkbox("\v\r Trashtalk"):depend({v140,"Helpers"});
	v101.menu.tools.trashtalk_type = v102:combobox("\n trashtalk type", {"Default type","Custom phrase","1 MOD"}):depend({v101.menu.tools.trashtalk,true}):depend({v140,"Helpers"});
	v101.menu.tools.trashtalk_check2 = v102:checkbox(v105 .. "with player name (enemy)"):depend({v101.menu.tools.trashtalk,true}, {v101.menu.tools.trashtalk_type,"1 MOD"}):depend({v140,"Helpers"});
	v101.menu.tools.trashtalk_custom = v102:textbox("\n phrase"):depend({v101.menu.tools.trashtalk,true}, {v101.menu.tools.trashtalk_type,"Custom phrase"}):depend({v140,"Helpers"});
	v101.menu.tools.animations = v102:checkbox("\v\r Animations breakers"):depend({v140,"Helpers"});
	v101.menu.tools.animations_selector = v102:multiselect("\n Animations", {"Reset pitch on land","Body lean","Static legs","Jitter air","Jitter ground","Kangaroo","Moonwalk","Yaw break","Pitch break"}):depend({v101.menu.tools.animations,true}):depend({v140,"Helpers"});
	v101.menu.tools.animations_body = v102:slider("\n Body lean ", 0, 100, 74, true, ""):depend({v101.menu.tools.animations,true}):depend({v101.menu.tools.animations_selector,"Body lean"}):depend({v140,"Helpers"});
	v101.menu.tools.autobuy = v102:checkbox("\v\r Auto buy"):depend({v140,"Helpers"});
	v101.menu.tools.autobuy_v = v102:combobox("\n auto buy vibor", {"Awp","Scar/g3sg1","Scout"}):depend({v101.menu.tools.autobuy,true}):depend({v140,"Helpers"});
	v32.traverse(v101.menu.home, function(v783)
		v783:depend({v101.menu.global.tab," Home"});
	end);
	v32.traverse(v101.menu.antiaim, function(v784)
		v784:depend({v101.menu.global.tab," Anti-Aim"});
	end);
	v32.traverse(v101.menu.tools, function(v785)
		v785:depend({v101.menu.global.tab," Tools"});
	end);
end,shutdown=function(v193)
	v193.helpers:menu_visibility(true);
end}):struct("helpers")({anim={},contains=function(v194, v195, v196)
	for v786, v787 in v3(v195) do
		if (v787 == v196) then
			return true;
		end
	end
	return false;
end,lerp=function(v197, v198, v199, v200)
	return ((v199 - v198) * v200) + v198;
end,math_anim2=function(v201, v202, v203, v204)
	v204 = v43.clamp(v26.frametime() * ((v204 / 100) or 0.08) * 175, 0.01, 1);
	local v205 = v201:lerp(v202, v203, v204);
	return v12(v20.format("%.3f", v205));
end,new_anim=function(v206, v207, v208, v209)
	if (v206.anim[v207] == nil) then
		v206.anim[v207] = v208;
	end
	local v210 = v206:math_anim2(v206.anim[v207], v208, v209);
	v206.anim[v207] = v210;
	return v206.anim[v207];
end,rgba_to_hex=function(v212, v213, v214, v215, v216)
	return v29.tohex((v19.floor(v213 + 0.5) * 16777216) + (v19.floor(v214 + 0.5) * 65536) + (v19.floor(v215 + 0.5) * 256) + (v19.floor(v216 + 0.5)));
end,limit_ch=function(v217, v218, v219, v220)
	local v221 = {};
	local v222 = 1;
	for v788 in v20.gmatch(v218, ".[\x80-\xBF]*") do
		v222, v221[v222] = v222 + 1, v788;
		if (v219 < v222) then
			if v220 then
				v221[v222] = ((v220 == true) and "...") or v220;
			end
			break;
		end
	end
	return v18.concat(v221);
end,animate_pulse=function(v223, v224, v225)
	local v226, v227, v228, v229 = v15(v224);
	local v230 = v226 * v19.abs(v19.cos(v26.curtime() * v225));
	local v231 = v227 * v19.abs(v19.cos(v26.curtime() * v225));
	local v232 = v228 * v19.abs(v19.cos(v26.curtime() * v225));
	local v233 = v229 * v19.abs(v19.cos(v26.curtime() * v225));
	return v230, v231, v232, v233;
end,animate_text=function(v234, v235, v236, v237, v238, v239, v240)
	local v241, v242 = {}, 1;
	local v243 = v236:len() - 1;
	local v244 = 255 - v237;
	local v245 = 255 - v238;
	local v246 = 255 - v239;
	local v247 = 155 - v240;
	for v790 = 1, #v236 do
		local v791 = ((v790 - 1) / (#v236 - 1)) + v235;
		v241[v242] = "\a" .. v234:rgba_to_hex(v237 + (v244 * v19.abs(v19.cos(v791))), v238 + (v245 * v19.abs(v19.cos(v791))), v239 + (v246 * v19.abs(v19.cos(v791))), v240 + (v247 * v19.abs(v19.cos(v791))));
		v241[v242 + 1] = v236:sub(v790, v790);
		v242 = v242 + 2;
	end
	return v241;
end,rounded_side_v=function(v248, v249, v250, v251, v252, v253, v254, v255, v256, v257, v258, v259)
	v249, v250, v251, v252, v257 = v249 * 1, v250 * 1, v251 * 1, v252 * 1, (v257 or 0) * 1;
	v258, v259 = v258 or false, v259 or false;
	local v260 = v253;
	local v261 = v254;
	local v262 = v255;
	local v263 = v256;
	v28.rectangle(v249 + v257, v250, v251 - v257, v252, v260, v261, v262, v263);
	if v258 then
		v28.circle(v249 + v257, v250 + v257, v260, v261, v262, v263, v257, 180, 0.25);
		v28.circle(v249 + v257, (v250 + v252) - v257, v260, v261, v262, v263, v257, 270, 0.25);
		v28.rectangle(v249, v250 + v257, (v251 - v251) + v257, (v252 - v257) - v257, v260, v261, v262, v263);
	end
	if v259 then
		v28.circle(v249 + v251, v250 + v257, v260, v261, v262, v263, v257, 90, 0.25);
		v28.circle(v249 + v251, (v250 + v252) - v257, v260, v261, v262, v263, v257, 0, 0.25);
		v28.rectangle(v249 + v251, v250 + v257, (v251 - v251) + v257, (v252 - v257) - v257, v260, v261, v262, v263);
	end
end,get_camera_pos=function(v264, v265)
	local v266, v267, v268 = v24.get_prop(v265, "m_vecOrigin");
	if (v266 == nil) then
		return;
	end
	local v269, v269, v270 = v24.get_prop(v265, "m_vecViewOffset");
	v268 = v268 + (v270 - (v24.get_prop(v265, "m_flDuckAmount") * 16));
	return v266, v267, v268;
end,fired_shot=function(v271, v272, v273, v274)
	local v275 = {v271:get_camera_pos(v273)};
	if (v275[1] == nil) then
		return;
	end
	local v276 = {v24.hitbox_position(v272, 0)};
	local v277 = {(v276[1] - v275[1]),(v276[2] - v275[2]),(v276[3] - v275[3])};
	local v278 = {(v274[1] - v275[1]),(v274[2] - v275[2]),(v274[3] - v275[3])};
	local v279 = ((v277[1] * v278[1]) + (v277[2] * v278[2]) + (v277[3] * v278[3])) / (v19.pow(v278[1], 2) + v19.pow(v278[2], 2) + v19.pow(v278[3], 2));
	local v280 = {(v275[1] + (v278[1] * v279)),(v275[2] + (v278[2] * v279)),(v275[3] + (v278[3] * v279))};
	local v281 = v19.abs(v19.sqrt(v19.pow(v276[1] - v280[1], 2) + v19.pow(v276[2] - v280[2], 2) + v19.pow(v276[3] - v280[3], 2)));
	local v282 = v22.trace_line(v273, v274[1], v274[2], v274[3], v276[1], v276[2], v276[3]);
	local v283 = v22.trace_line(v272, v280[1], v280[2], v280[3], v276[1], v276[2], v276[3]);
	return (v281 < 69) and ((v282 > 0.99) or (v283 > 0.99));
end,get_damage=function(v284)
	local v285 = v21.get(v284.ref.rage.mindmg[1]);
	if (v21.get(v284.ref.rage.ovr[1]) and v21.get(v284.ref.rage.ovr[2])) then
		return v21.get(v284.ref.rage.ovr[3]);
	else
		return v285;
	end
end,normalize_yaw=function(v286, v287)
	v287 = v287 % 360;
	v287 = (v287 + 360) % 360;
	if (v287 > 180) then
		v287 = v287 - 360;
	end
	return v287;
end,normalize_pitch=function(v288, v289)
	return v43.clamp(v289, -89, 89);
end,distance=function(v290, v291, v292, v293, v294, v295, v296)
	return v19.sqrt(((v294 - v291) ^ 2) + ((v295 - v292) ^ 2) + ((v296 - v293) ^ 2));
end,flags={HIT={11,2048}},entity_has_flag=function(v297, v298, v299)
	if (not v298 or not v299) then
		return false;
	end
	local v300 = v297.flags[v299];
	if (v300 == nil) then
		return false;
	end
	local v301 = v24.get_esp_data(v298) or {};
	return v29.band(v301.flags or 0, v29.lshift(1, v300[1])) == v300[2];
end,menu_visibility=function(v302, v303)
	local v304 = {v302.ref.aa,v302.ref.fakelag,v302.ref.aa_other};
	for v794, v795 in v2(v304) do
		for v915, v916 in v3(v795) do
			for v959, v960 in v2(v916) do
				v21.set_visible(v960, v303);
			end
		end
	end
	v21.set_enabled(v302.ref.misc.log[1], v303);
	v21.set_enabled(v302.ref.misc.override_zf, v303);
	v21.set(v302.ref.misc.log[1], false);
end,in_air=function(v305, v306)
	local v307 = v24.get_prop(v306, "m_fFlags");
	return v29.band(v307, 1) == 0;
end,in_duck=function(v308, v309)
	local v310 = v24.get_prop(v309, "m_fFlags");
	return v29.band(v310, 4) == 4;
end,get_state=function(v311)
	local v312 = v24.get_local_player();
	local v313 = v24.get_prop(v312, "m_vecVelocity");
	local v314 = v31(v313):length2d();
	local v315 = v311:in_duck(v312) or v21.get(v311.ref.rage.fd[1]);
	local v316 = v311.ui.menu.antiaim.states;
	local v317 = v311.antiaim:get_manual();
	local v318 = v21.get(v311.ref.rage.dt[1]) and v21.get(v311.ref.rage.dt[2]);
	local v319 = v21.get(v311.ref.rage.os[1]) and v21.get(v311.ref.rage.os[2]);
	local v320 = v21.get(v311.ref.rage.fd[1]);
	local v321 = "global";
	if (v314 > 1.5) then
		if v316['run'].enable() then
			v321 = "run";
		end
	elseif v316['stand'].enable() then
		v321 = "stand";
	end
	if v311:in_air(v312) then
		if v315 then
			if v316["aerobic+"].enable() then
				v321 = "aerobic+";
			end
		elseif v316['aerobic'].enable() then
			v321 = "aerobic";
		end
	elseif (v315 and (v314 > 1.5) and v316['sneak'].enable()) then
		v321 = "sneak";
	elseif ((v314 > 1) and v21.get(v311.ref.slow_motion[1]) and v21.get(v311.ref.slow_motion[2]) and v316["slow walk"].enable()) then
		v321 = "slow walk";
	elseif ((v317 == -90) and v316["manual left"].enable()) then
		v321 = "manual left";
	elseif ((v317 == 90) and v316["manual right"].enable()) then
		v321 = "manual right";
	elseif (v315 and v316['crouch'].enable()) then
		v321 = "crouch";
	end
	if v314 then
		if (v316['fakelag'].enable() and ((not v318 and not v319) or v320)) then
			v321 = "fakelag";
		end
		if (v316['hideshots'].enable() and v319 and not v318 and not v320) then
			v321 = "hideshots";
		end
	end
	return v321;
end}):struct("config")({configs={},write_file=function(v322, v323, v324)
	if (not v324 or (v14(v323) ~= "string")) then
		return;
	end
	return v10(v323, json.stringify(v324));
end,update_name=function(v325)
	local v326 = v325.ui.menu.home.list();
	local v327 = 0;
	for v796, v797 in v3(v325.configs) do
		if (v326 == v327) then
			return v325.ui.menu.home.name(v796);
		end
		v327 = v327 + 1;
	end
end,update_configs=function(v328)
	local v329 = {};
	for v798, v799 in v3(v328.configs) do
		v18.insert(v329, v798);
	end
	if (#v329 > 0) then
		v328.ui.menu.home.list:update(v329);
	end
	v328:write_file("onesense_configs.txt", v328.configs);
	v328:update_name();
end,setup=function(v330)
	local v331 = v9("onesense_configs.txt");
	if (v331 == nil) then
		return;
	end
	v330.configs = json.parse(v331);
	v330:update_configs();
	v330:update_name();
end,export_config=function(v333, ...)
	local v334 = v333.ui.menu.home.name();
	local v335 = v32.setup({v333.ui.menu.global,v333.ui.menu.antiaim,v333.ui.menu.tools});
	local v336 = v335:save();
	local v337 = v33.encode(json.stringify(v336));
	print("Succsess cfg export");
	return v337;
end,export_state=function(v338, v339)
	local v340 = v32.setup({v338.ui.menu.antiaim.states[v339]});
	local v339 = v338.ui.menu.antiaim.state:get();
	local v341 = v340:save();
	local v342 = v33.encode(json.stringify(v341));
	v44.create_new({{"Condition "},{v339,true},{" export"}});
	return v342;
end,export=function(v343, v344, ...)
	local v345, v346 = v16(v343["export_" .. v344], v343, ...);
	if not v345 then
		print(v346);
		return;
	end
	print("Succsess");
	return "{onesense:" .. v344 .. "}:" .. v346;
end,import_config=function(v347, v348)
	local v349 = json.parse(v33.decode(v348));
	local v350 = v32.setup({v347.ui.menu.global,v347.ui.menu.antiaim,v347.ui.menu.tools});
	v350:load(v349);
	v44.create_new({{"Cfg import"},{"!",true}});
end,import_state=function(v351, v352, v353)
	local v354 = json.parse(v33.decode(v352));
	local v355 = v32.setup({v351.ui.menu.antiaim.states[v353]});
	v355:load(v354);
	v44.create_new({{"Condition import"},{"!",true}});
end,import=function(v356, v357, v358, ...)
	local v359 = v357:match("{onesense:(.+)}");
	if (not v359 or (v359 ~= v358)) then
		v44.create_new({{"Error: "},{"This not onesense config",true}});
		return v0("This not onesense config");
	end
	local v360, v361 = v16(v356["import_" .. v359], v356, v357:gsub("{onesense:" .. v359 .. "}:", ""), ...);
	if not v360 then
		print(v361);
		v44.create_new({{"Error: "},{"Failed data onesense",true}});
		return v0("Failed data onesense");
	end
end,save=function(v362)
	local v363 = v362.ui.menu.home.name();
	if (v363:match("%w") == nil) then
		v44.create_new({{"Invalid config "},{"name",true}});
		return print("Invalid config name");
	end
	local v364 = v362:export("config");
	v362.configs[v363] = v364;
	v44.create_new({{"Saved cfg "},{v363,true}});
	v362:update_configs();
end,load=function(v366, v367)
	local v368 = v366.ui.menu.home.name();
	local v369 = v366.configs[v368];
	if not v369 then
		v44.create_new({{"Invalid cfg "},{"name",true}});
		return v0("Inval. cfg name");
	end
	v366:import(v369, v367);
	v44.create_new({{"Loaded cfg "},{v368,true}});
end,delete=function(v370)
	local v371 = v370.ui.menu.home.name();
	local v372 = v370.configs[v371];
	if not v372 then
		return v0("Invalid config name");
	end
	v370.configs[v371] = nil;
	v44.create_new({{"Delete cfg "},{v371,true}});
	v370:update_configs();
end}):struct("antiaim")({side=0,last_rand=0,skitter_counter=0,last_skitter=0,cycle=0,manual_side=0,anti_backstab=function(v374)
	local v375 = v24.get_local_player();
	local v376 = v22.current_threat();
	if ((v375 == nil) or not v24.is_alive(v375)) then
		return false;
	end
	if not v376 then
		return false;
	end
	local v377 = v24.get_player_weapon(v376);
	if not v377 then
		return false;
	end
	local v378 = v24.get_classname(v377);
	if not v378:find("Knife") then
		return false;
	end
	local v379 = v31(v24.get_origin(v375));
	local v380 = v31(v24.get_origin(v376));
	local v381 = 168;
	return v380:dist2d(v379) < v381;
end,get_best_side=function(v382, v383)
	local v384 = v24.get_local_player();
	local v385 = v31(v22.eye_position());
	local v386 = v22.current_threat();
	local v387, v388 = v22.camera_angles();
	local v389;
	if v386 then
		v389 = v31(v24.get_origin(v386)) + v31(0, 0, 64);
		v387, v388 = (v389 - v385):angles();
	end
	local v390 = {60,45,30,-30,-45,-60};
	local v391 = {left=0,right=0};
	for v800, v801 in v2(v390) do
		local v802 = v31():init_from_angles(0, v388 + 180 + v801, 0);
		if v386 then
			local v961 = v385 + v802:scaled(128);
			local v962, v963 = v22.trace_bullet(v386, v389.x, v389.y, v389.z, v961.x, v961.y, v961.z, v384);
			v391[((v801 < 0) and "left") or "right"] = v391[((v801 < 0) and "left") or "right"] + v963;
		else
			local v965 = v385 + v802:scaled(8192);
			local v966 = v22.trace_line(v384, v385.x, v385.y, v385.z, v965.x, v965.y, v965.z);
			v391[((v801 < 0) and "left") or "right"] = v391[((v801 < 0) and "left") or "right"] + v966;
		end
	end
	if (v391.left == v391.right) then
		return 2;
	elseif (v391.left > v391.right) then
		return (v383 and 1) or 0;
	else
		return (v383 and 0) or 1;
	end
end,get_manual=function(v392)
	local v393 = v24.get_local_player();
	if ((v393 == nil) or not v392.ui.menu.antiaim.manual_aa:get()) then
		return;
	end
	local v394 = v392.ui.menu.antiaim.manual_left:get();
	local v395 = v392.ui.menu.antiaim.manual_right:get();
	local v396 = v392.ui.menu.antiaim.manual_forward:get();
	if (v392.last_forward == nil) then
		v392.last_forward, v392.last_right, v392.last_left = v396, v395, v394;
	end
	if (v394 ~= v392.last_left) then
		if (v392.manual_side == 1) then
			v392.manual_side = nil;
		else
			v392.manual_side = 1;
		end
	end
	if (v395 ~= v392.last_right) then
		if (v392.manual_side == 2) then
			v392.manual_side = nil;
		else
			v392.manual_side = 2;
		end
	end
	if (v396 ~= v392.last_forward) then
		if (v392.manual_side == 3) then
			v392.manual_side = nil;
		else
			v392.manual_side = 3;
		end
	end
	v392.last_forward, v392.last_right, v392.last_left = v396, v395, v394;
	if not v392.manual_side then
		return;
	end
	return ({-90,90,180})[v392.manual_side];
end,run=function(v400, v401)
	local v402 = v24.get_local_player();
	if not v24.is_alive(v402) then
		return;
	end
	local v403 = v400.helpers:get_state();
	v400:set_builder(v401, v403);
end,set_builder=function(v404, v405, v406)
	local v407 = {};
	for v803, v804 in v3(v404.ui.menu.antiaim.states[v406]) do
		v407[v803] = v804();
	end
	v404:set(v405, v407);
end,animations=function(v408)
	local v409 = v24.get_local_player();
	if not v24.is_alive(v409) then
		return;
	end
	local v410 = v35.new(v409);
	local v411 = v410:get_anim_state();
	local v412 = v408.ui.menu.tools.animations_body:get();
	local v413 = v408.ui.menu.tools.animations_selector:get();
	if not v411 then
		return;
	end
	local v414 = v24.get_prop(v409, "m_vecVelocity[0]");
	if v408.helpers:contains(v413, "Body lean") then
		local v920 = v410:get_anim_overlay(12);
		if not v920 then
			return;
		end
		if (v19.abs(v414) >= 3) then
			v920.weight = v412 / 100;
		end
	end
	if v408.helpers:contains(v413, "Static legs") then
		v24.set_prop(v409, "m_flPoseParameter", 1, 6);
	end
	if v408.helpers:contains(v413, "Yaw break") then
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 11);
	end
	if v408.helpers:contains(v413, "Pitch break") then
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 12);
	end
	if v408.helpers:contains(v413, "Jitter ground") then
		v21.set(v408.ref.fakelag.lg[1], "Always slide");
		if ((v26.tickcount() % 4) > 1) then
			v24.set_prop(v409, "m_flPoseParameter", 0, 0);
		end
	end
	if v408.helpers:contains(v413, "Kangaroo") then
		if not v408.helpers:contains(v413, "Jitter air") then
			v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 6);
		end
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 3);
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 10);
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 9);
	end
	if v408.helpers:contains(v413, "Jitter air") then
		v24.set_prop(v409, "m_flPoseParameter", v19.random(0, 10) / 10, 6);
	end
	if v408.helpers:contains(v413, "Moonwalk") then
		v21.set(v408.ref.fakelag.lg[1], "Never slide");
		v24.set_prop(v409, "m_flPoseParameter", 0, 7);
		if v408.helpers:in_air(v409) then
			v410:get_anim_overlay(4).weight = 0;
			v410:get_anim_overlay(6).weight = 1;
		end
	end
	if v408.helpers:contains(v413, "Reset pitch on land") then
		if not v411.hit_in_ground_animation then
			return;
		end
		v24.set_prop(v409, "m_flPoseParameter", 0.5, 12);
	end
end,get_defensive=function(v415, v416, v417, v418)
	local v419 = v22.current_threat();
	local v420 = v24.get_local_player();
	if v415.helpers:contains(v416, "Always") then
		return true;
	end
	if v415.helpers:contains(v416, "On weapon switch") then
		local v921 = v24.get_prop(v420, "m_flNextAttack") - v26.curtime();
		if ((v921 / v26.tickinterval()) > (v415.defensive.defensive + 2)) then
			return true;
		end
	end
	if v415.helpers:contains(v416, "Tick-Base") then
		local v922 = v418.defensive_conditions_tick * 2;
		if ((v26.tickcount() % 32) >= v922) then
			return true;
		else
			return false;
		end
	end
	if v415.helpers:contains(v416, "On reload") then
		local v923 = v24.get_player_weapon(v420);
		if v923 then
			local v988 = v24.get_prop(v420, "m_flNextAttack") - v26.curtime();
			local v989 = v24.get_prop(v923, "m_flNextPrimaryAttack") - v26.curtime();
			if ((v988 > 0) and (v989 > 0) and ((v988 * v26.tickinterval()) > v415.defensive.defensive)) then
				return true;
			end
		end
	end
	if (v415.helpers:contains(v416, "On hittable") and v415.helpers:entity_has_flag(v419, "HIT")) then
		return true;
	end
	if (v415.helpers:contains(v416, "On freestand") and v415.ui.menu.antiaim.freestanding:get_hotkey() and not (v415.ui.menu.antiaim.freestanding:get("Disablers") and v415.ui.menu.antiaim.freestanding_disablers:get(v417))) then
		return true;
	end
end,spin_yaw=0,spin_pitch_def=0,switch_way=1,spin_value=0,jitter_side=0,spin_way=0,spin_pitch=0,last_way=0,switch_random=0,switch_random_p=0,random_spin_way=0,spin_way_180=0,set=function(v421, v422, v423)
	local v424 = v421.helpers:get_state();
	local v425 = {v19.random(1, v19.random(3, 4)),2,4,5};
	local v426 = v421:get_manual();
	local v427 = true;
	if (v423.jitter_delay == 0) then
		v425[v423.jitter_delay] = 1;
	end
	if ((v26.chokedcommands() == 0) and (v421.cycle == v425[v423.jitter_delay])) then
		v427 = false;
		v421.side = ((v421.side == 1) and 0) or 1;
	end
	local v428 = v421:get_best_side();
	local v429 = v421.side;
	local v430 = v423.body_yaw;
	local v431 = "default";
	local v432 = v19.random(-v423.yaw_random, v423.yaw_random);
	local v433 = v423.yaw_jitter_add + v432;
	if (v430 == "Jitter") then
		v430 = "Static";
	elseif (v423.body_yaw_side == "Left") then
		v429 = 1;
	elseif (v423.body_yaw_side == "Right") then
		v429 = 0;
	else
		v429 = v428;
	end
	local v434 = 0;
	if (v423.yaw_jitter == "Offset") then
		if (v421.side == 1) then
			v434 = v434 + v433;
		end
	elseif (v423.yaw_jitter == "Center") then
		v434 = v434 + (((v421.side == 1) and (v433 / 2)) or (-v433 / 2)) + v432;
	elseif (v423.yaw_jitter == "Random") then
		local v1015 = v19.random(0, v433) - (v433 / 2);
		if not v427 then
			v434 = v434 + v1015;
			v421.last_rand = v1015;
		else
			v434 = v434 + v421.last_rand;
		end
	elseif (v423.yaw_jitter == "Smoothnes") then
		local v1040 = v433;
		local v1041 = v425[v423.jitter_delay] / 4;
		local v1042 = v1040 * v19.sin((v26.curtime() / v1041) * v19.pi);
		v434 = v1042;
	elseif (v423.yaw_jitter == "Fractal") then
		local v1059 = v433 * 2;
		local v1060 = v425[v423.jitter_delay] * 0.5;
		local v1061 = 0;
		local v1062 = v423.yaw_fractals;
		local v1063 = 0;
		if (v1062 == 14) then
			v1063 = v19.random(0, 13);
		else
			v1063 = v1062;
		end
		for v1075 = 1, v1063 do
			v1061 = v1061 + ((0.5 ^ v1075) * v19.cos(((2 ^ v1075) * v1060 * v26.curtime() * 2 * v19.pi) + 10));
		end
		v434 = v1061 * v1059;
	elseif (v423.yaw_jitter == "Skitter") then
		local v1076 = {0,2,1,0,2,1,0,1,2,0,1,2,0,1,2};
		local v1077;
		if (v421.skitter_counter == #v1076) then
			v421.skitter_counter = 1;
		elseif not v427 then
			v421.skitter_counter = v421.skitter_counter + 1;
		end
		v1077 = v1076[v421.skitter_counter];
		v421.last_skitter = v1077;
		if (v423.body_yaw == "jitter") then
			v429 = v1077;
		end
		if (v1077 == 0) then
			v434 = (v434 - 16) - (v19.abs(v433) / 2);
		elseif (v1077 == 1) then
			v434 = v434 + 16 + (v19.abs(v433) / 2);
		end
	end
	v434 = v434 + (((v429 == 0) and v423.yaw_add_r) or ((v429 == 1) and v423.yaw_add) or 0);
	if (v421.helpers:contains(v423.options, "Enable defensive") and v421:get_defensive(v423.defensive_conditions, v424, v423)) then
		v422.force_defensive = true;
	end
	local v435 = v421.ui.menu.antiaim.edge_yaw:get_hotkey();
	v21.set(v421.ref.aa.freestand[1], false);
	v21.set(v421.ref.aa.edge_yaw[1], v435);
	v21.set(v421.ref.aa.freestand[2], "Always on");
	if v421.helpers:contains(v423.options, "Safe head") then
		local v927 = v24.get_local_player();
		local v928 = v22.current_threat();
		if v928 then
			local v990 = v24.get_player_weapon(v927);
			if (v990 and (v24.get_classname(v990):find("Knife") or v24.get_classname(v990):find("Taser"))) then
				v434 = 0;
				v429 = 2;
			end
		end
	end
	if (v421.ui.menu.antiaim.manual_static:get() and ((v426 == -90) or (v426 == 90))) then
		v434 = 0;
		v429 = 0;
	end
	if v426 then
		v434 = v426;
	elseif (v421.ui.menu.antiaim.freestanding:get_hotkey() and not (v421.ui.menu.antiaim.freestanding:get("Disablers") and v421.ui.menu.antiaim.freestanding_disablers:get(v424))) then
		v21.set(v421.ref.aa.freestand[1], true);
		if v421.ui.menu.antiaim.freestanding:get("Force static") then
			v434 = 0;
			v429 = 0;
		end
	elseif (v421.helpers:contains(v423.options, "Avoid backstab") and v421:anti_backstab()) then
		v434 = v434 + 180;
	end
	local v436 = (((v421.defensive.ticks * v421.defensive.defensive) > 0) and v19.max(v421.defensive.defensive, v421.defensive.ticks)) or 0;
	local v437 = {{speed=v423.defensive_yaw_way_speed1,spin_limit=v423.defensive_yaw_way_spin_limit1,enable_spin=v423.defensive_yaw_enable_way_spin1,switch_value=v423.defensive_yaw_way_switch1},{speed=v423.defensive_yaw_way_speed2,spin_limit=v423.defensive_yaw_way_spin_limit2,enable_spin=v423.defensive_yaw_enable_way_spin2,switch_value=v423.defensive_yaw_way_switch2},{speed=v423.defensive_yaw_way_speed3,spin_limit=v423.defensive_yaw_way_spin_limit3,enable_spin=v423.defensive_yaw_enable_way_spin3,switch_value=v423.defensive_yaw_way_switch3},{speed=v423.defensive_yaw_way_speed4,spin_limit=v423.defensive_yaw_way_spin_limit4,enable_spin=v423.defensive_yaw_enable_way_spin4,switch_value=v423.defensive_yaw_way_switch4},{speed=v423.defensive_yaw_way_speed5,spin_limit=v423.defensive_yaw_way_spin_limit5,enable_spin=v423.defensive_yaw_enable_way_spin5,switch_value=v423.defensive_yaw_way_switch5}};
	local v438 = {{speed=v423.defensive_pitch_way_speed1,spin_limit1=v423.defensive_pitch_way_spin_limit11,spin_limit2=v423.defensive_pitch_way_spin_limit12,enable_spin=v423.defensive_pitch_enable_way_spin1,switch_value=v423.defensive_pitch_custom},{speed=v423.defensive_pitch_way_speed2,spin_limit1=v423.defensive_pitch_way_spin_limit21,spin_limit2=v423.defensive_pitch_way_spin_limit22,enable_spin=v423.defensive_pitch_enable_way_spin2,switch_value=v423.defensive_pitch_way2},{speed=v423.defensive_pitch_way_speed3,spin_limit1=v423.defensive_pitch_way_spin_limit31,spin_limit2=v423.defensive_pitch_way_spin_limit32,enable_spin=v423.defensive_pitch_enable_way_spin3,switch_value=v423.defensive_pitch_way3},{speed=v423.defensive_pitch_way_speed4,spin_limit1=v423.defensive_pitch_way_spin_limit41,spin_limit2=v423.defensive_pitch_way_spin_limit42,enable_spin=v423.defensive_pitch_enable_way_spin4,switch_value=v423.defensive_pitch_way4},{speed=v423.defensive_pitch_way_speed5,spin_limit1=v423.defensive_pitch_way_spin_limit51,spin_limit2=v423.defensive_pitch_way_spin_limit52,enable_spin=v423.defensive_pitch_enable_way_spin5,switch_value=v423.defensive_pitch_way5}};
	local v439 = v26.tickcount() % 32;
	if (v423.defensive_yaw and v421.helpers:contains(v423.options, "Enable defensive")) then
		if (v436 == 1) then
		end
		if ((v423.defensive_yaw_mode == "Jitter") and (v436 > 0)) then
			local v991 = v423.defensive_yaw_jitter_radius_1;
			local v992 = v423.defensive_yaw_jitter_delay * 3;
			local v993 = v423.defensive_yaw_jitter_random;
			if (v992 == 1) then
				v421.jitter_side = ((v421.jitter_side == -1) and 1) or -1;
			else
				v421.jitter_side = (((((v26.tickcount() % v992) * 2) + 1) <= v992) and -1) or 1;
			end
			v434 = (v421.jitter_side * v991) + v19.random(-v993, v993);
		elseif ((v423.defensive_yaw_mode == "Random") and (v436 > 0)) then
			local v1018 = v423.defensive_yaw_1_random;
			local v1019 = v423.defensive_yaw_2_random;
			v434 = v19.random(v1018, v1019);
		elseif ((v423.defensive_yaw_mode == "Custom spin") and (v436 > 0)) then
			v421.spin_value = v421.spin_value + (8 * (v423.defensive_yaw_speedtick / 5));
			if (v421.spin_value >= v423.defensive_yaw_spin_limit) then
				v421.spin_value = 0;
			end
			v434 = v421.spin_value;
		elseif ((v423.defensive_yaw_mode == "Spin-way") and (v436 > 0)) then
			local v1065 = v423.defensive_yaw_speed_Spin_way;
			local v1066 = v423.defensive_yaw_randomizer_Spin_way;
			local v1067 = v423.defensive_yaw_1_Spin_way;
			local v1068 = v423.defensive_yaw_2_Spin_way;
			local v1069 = 0;
			if (v439 >= (29 + v19.random(0, v1065))) then
				v421.spin_way_180 = v421.spin_way_180 + 1;
				v421.random_spin_way = v19.random(-v1066, v1066);
			end
			if (v421.spin_way_180 == 0) then
				v1069 = v1067 + v421.random_spin_way;
			elseif (v421.spin_way_180 == 1) then
				v1069 = v1068 + v421.random_spin_way;
			end
			if (v421.spin_way_180 == 2) then
				v421.spin_way_180 = 0;
			end
			local v1070 = v421.helpers:new_anim("antiaim_spin_way", v1069, 6);
			v434 = v1070;
		elseif ((v423.defensive_yaw_mode == "Switch 5-way") and (v436 > 0)) then
			if (v439 >= (29 + v19.random(0, v423.defensive_yaw_way_delay))) then
				v421.switch_way = v421.switch_way + 1;
				v421.switch_random = v19.random(-v423.defensive_yaw_way_randomly_value, v423.defensive_yaw_way_randomly_value);
			else
				v434 = v421.last_way;
				if (v421.switch_way == #v437) then
					v421.switch_way = 0;
				end
			end
			if ((v421.switch_way >= 0) and (v421.switch_way < #v437)) then
				local v1095 = v437[v421.switch_way + 1];
				v421.spin_way = v421.spin_way + (8 * (v1095.speed / 5));
				if (v421.spin_way >= v1095.spin_limit) then
					v421.spin_way = 0;
				end
				if not v1095.enable_spin then
					if v423.defensive_yaw_way_randomly then
						v434 = v1095.switch_value + v421.switch_random;
						v421.last_way = v1095.switch_value + v421.switch_random;
					else
						v434 = v1095.switch_value;
						v421.last_way = v1095.switch_value;
					end
				else
					v434 = v421.spin_way;
					v421.last_way = v421.spin_way;
				end
			elseif (v421.switch_way == #v437) then
				v421.switch_way = 0;
			end
		end
		if ((v423.defensive_pitch_mode == "Static") and (v436 > 0)) then
			v431 = v423.defensive_pitch_custom;
		elseif ((v423.defensive_pitch_mode == "Jitter") and (v436 > 0)) then
			if (v19.random(0, 20) >= 10) then
				v431 = v423.defensive_pitch_clock;
			else
				v431 = v423.defensive_pitch_custom;
			end
		elseif ((v423.defensive_pitch_mode == "Spin") and (v436 > 0)) then
			if (v423.defensive_pitch_custom < 0) then
				v421.spin_pitch_def = v421.spin_pitch_def - (v423.defensive_pitch_speedtick / 5);
			else
				v421.spin_pitch_def = v421.spin_pitch_def + (v423.defensive_pitch_speedtick / 5);
			end
			if (v423.defensive_pitch_custom < 0) then
				if (v421.spin_pitch_def <= v423.defensive_pitch_custom) then
					v421.spin_pitch_def = v423.defensive_pitch_spin_limit2;
				end
			elseif (v421.spin_pitch_def >= v423.defensive_pitch_custom) then
				v421.spin_pitch_def = v423.defensive_pitch_spin_limit2;
			end
			v431 = v421.spin_pitch_def;
		elseif ((v423.defensive_pitch_mode == "Clocking") and (v436 > 0)) then
			if (v439 >= 28) then
				v421.spin_yaw = v421.spin_yaw + 15;
			end
			if (v421.spin_yaw >= 89) then
				v421.spin_yaw = -89;
			end
			v431 = v421.spin_yaw;
		elseif ((v423.defensive_pitch_mode == "Random") and (v436 > 0)) then
			local v1089 = v423.defensive_pitch_custom;
			local v1090 = v423.defensive_pitch_spin_random2;
			v431 = v19.random(v1089, v1090);
		elseif ((v423.defensive_pitch_mode == "5way") and (v436 > 0)) then
			if (v439 >= (29 + v19.random(0, v423.defensive_yaw_way_delay))) then
				v421.switch_random_p = v19.random(-v423.defensive_pitch_way_randomly_value, v423.defensive_pitch_way_randomly_value);
			else
				v431 = v421.last_way;
			end
			if ((v421.switch_way >= 0) and (v421.switch_way < #v438)) then
				local v1105 = v438[v421.switch_way + 1];
				if (v1105.spin_limit2 < 0) then
					v421.spin_pitch = v421.spin_pitch - (8 * (v1105.speed / 5));
				else
					v421.spin_pitch = v421.spin_pitch + (8 * (v1105.speed / 5));
				end
				if (v1105.spin_limit2 < 0) then
					if (v421.spin_pitch <= v1105.spin_limit2) then
						v421.spin_pitch = v1105.spin_limit1;
					end
				elseif (v421.spin_pitch >= v1105.spin_limit2) then
					v421.spin_pitch = v1105.spin_limit1;
				end
				if not v1105.enable_spin then
					if v423.defensive_pitch_way_randomly then
						v431 = v421.switch_random_p;
						v421.last_way = v421.switch_random_p;
					else
						v431 = v1105.switch_value;
						v421.last_way = v1105.switch_value;
					end
				else
					v431 = v421.spin_pitch;
					v421.last_way = v421.spin_pitch;
				end
			end
		end
	end
	v21.set(v421.ref.aa.enabled[1], true);
	v21.set(v421.ref.aa.pitch[1], ((v431 == "default") and v431) or "custom");
	v21.set(v421.ref.aa.pitch[2], v421.helpers:normalize_pitch(((v14(v431) == "number") and v431) or 0));
	v21.set(v421.ref.aa.yaw_base[1], v423.yaw_base);
	v21.set(v421.ref.aa.yaw[1], 180);
	v21.set(v421.ref.aa.yaw[2], v421.helpers:normalize_yaw(v434));
	v21.set(v421.ref.aa.yaw_jitter[1], "off");
	v21.set(v421.ref.aa.yaw_jitter[2], 0);
	v21.set(v421.ref.aa.body_yaw[1], v430);
	v21.set(v421.ref.aa.body_yaw[2], ((v429 == 2) and 0) or ((v429 == 1) and 90) or -90);
	if (v26.chokedcommands() == 0) then
		if (v421.cycle >= v425[v423.jitter_delay]) then
			v421.cycle = 1;
		else
			v421.cycle = v421.cycle + 1;
		end
	end
end}):struct("defensive")({check=0,defensive=0,sim_time=v26.tickcount(),active_until=0,ticks=0,active=false,defensive_active=function(v440)
	local v441 = v24.get_local_player();
	if (not v441 or not v24.is_alive(v441)) then
		return;
	end
	local v442 = v24.get_prop(v24.get_local_player(), "m_nTickBase");
	v440.defensive = v19.abs(v442 - v440.check);
	v440.check = v19.max(v442, v440.check or 0);
	local v445 = v26.tickcount();
	local v446 = v24.get_prop(v441, "m_flSimulationTime");
	local v447 = v13(v446 - v440.sim_time);
	if (v447 < 0) then
		v440.active_until = v445 + v19.abs(v447);
	end
	v440.ticks = v43.clamp(v440.active_until - v445, 0, 16);
	v440.active = v440.active_until > v445;
	v440.sim_time = v446;
end,def_reset=function(v451)
	v451.check, v451.defensive = 0, 0;
end}):struct("tools")({widget_keylist=v38("keylist", 300, 100),widget_watermark=v38("watermark", 10, 10),scoped=0,scoped_comp=0,menu_setup=function(v454)
	local v455 = v454.ui.menu.tools.notify_offset:get();
	local v456, v457, v458, v459 = v454.ui.menu.global.color:get();
	v37.color[1] = v456;
	v37.color[2] = v457;
	v37.color[3] = v458;
	v37.offset = v455;
	if (v454.ui.menu.tools.style:get() == "New") then
		v37.blured = true;
	else
		v37.blured = false;
	end
	local v464 = v454.ui.menu.global.tab:get();
	local v465 = v454.ui.menu.antiaim.mode:get();
	local v466 = ((v464 == " Anti-Aim") and (v465 == "Constructor")) or (v464 == " Home");
	local v467 = {fakelag=v454.ref.fakelag,aa_other=v454.ref.aa_other};
	for v806, v807 in v3(v467) do
		local v808 = true;
		if (v806 == "fakelag") then
			v808 = false;
		elseif (v806 == "aa_other") then
			v808 = not v466;
		end
		for v932, v933 in v3(v807) do
			for v968, v969 in v2(v933) do
				v21.set_visible(v969, v808);
			end
		end
	end
	if (v454.ref.fakelag.enable[1] ~= true) then
		v21.set(v454.ref.fakelag.enable[1], true);
	end
	v21.set(v454.ref.fakelag.amount[1], v454.ui.menu.antiaim.fakelag_type:get());
	v21.set(v454.ref.fakelag.variance[1], v454.ui.menu.antiaim.fakelag_var:get());
	v21.set(v454.ref.fakelag.limit[1], v454.ui.menu.antiaim.fakelag_lim:get());
end,gs_ind=function(v468)
	if v468.helpers:contains(v468.ui.menu.tools.gs_inds:get(), "Target") then
		local v934 = v22.current_threat();
		local v935 = "None";
		if not v934 then
			v935 = "None";
		else
			v935 = v24.get_player_name(v934);
		end
		v28.indicator(255, 255, 255, 200, "Target: " .. v935);
	end
end,crosshair=function(v469)
	local v470 = v24.get_local_player();
	if (not v470 or not v24.is_alive(v470)) then
		return;
	end
	v469.scoped = v24.get_prop(v470, "m_bIsScoped");
	if not v469.ui.menu.tools.indicators:get() then
		return;
	end
	local v472 = v469.ui.menu.tools.indicator_pos:get();
	v469.scoped_comp = v469.helpers:math_anim2(v469.scoped_comp, v469.scoped * (((v472 == "Left") and -1) or 1), 8);
	local v474 = v469.helpers:get_state();
	local v475 = {v22.screen_size()};
	v469.ss = {x=v475[1],y=v475[2]};
	local v477, v478, v479, v480 = v469.ui.menu.global.color:get();
	local v481 = v469.ui.menu.tools.indicatorfont:get();
	local v482 = 0;
	if (v481 == "Default") then
		v482 = 1;
	elseif (v481 == "New") then
		v482 = 2;
	elseif (v481 == "Onesense") then
		v482 = 3;
	elseif (v481 == "Renewed") then
		v482 = 4;
	elseif (v481 == "Icons") then
		v482 = 5;
	end
	local v483 = v24.get_prop(v470, "m_flNextAttack");
	local v484 = v24.get_prop(v24.get_player_weapon(v470), "m_flNextPrimaryAttack");
	local v485 = not (v19.max(v484, v483) > v26.curtime());
	local v486, v487, v488 = (v485 and 255) or v477, (v485 and 255) or v478, (v485 and 255) or v479;
	local v489, v490, v491 = v469.helpers:animate_pulse({v477,v478,v479,255}, 8);
	local v492 = {{n="DT",c={v486,v487,v488},a=(v21.get(v469.ref.rage.dt[1]) and v21.get(v469.ref.rage.dt[2]) and not v21.get(v469.ref.rage.fd[1])),s=(v28.measure_text("-", "DT") + 13)},{n="OSAA",c={255,255,255},a=(v21.get(v469.ref.rage.os[1]) and v21.get(v469.ref.rage.os[2]) and not v21.get(v469.ref.rage.fd[1])),s=(v28.measure_text("-", "OSAA") + 13)},{n="FAKE",c={v489,v490,v491},a=v21.get(v469.ref.rage.fd[1]),s=(v28.measure_text("-", "FAKE") + 14)},{n="FS",c={255,255,255},a=(v21.get(v469.ref.aa.freestand[1]) and v21.get(v469.ref.aa.freestand[2])),s=(v28.measure_text("-", "FS") + 13)}};
	local v493 = v469.helpers:new_anim("indicator_pose", v469.ui.menu.tools.indicatoroffset:get(), 12);
	local v494 = 0;
	local v495 = v469.antiaim:get_best_side();
	local v496 = v469.helpers:animate_text(v26.curtime() * 2, "onesense", v477, v478, v479, 255);
	local v497 = v469.helpers:new_anim("indicator_mes_1", v28.measure_text("-", v474:upper()) or 0, 12);
	if (v482 == 1) then
		local v936 = v28.measure_text("c-", v41.build:upper());
		v28.text((v469.ss.x / 2) + (((v936 + 14) / 2) * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 10, v477, v478, v479, 150, "c-", 0, v41.build:upper());
		v28.text(((v469.ss.x / 2) - 22) + (30 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, 0, 0, 0, 255, "b", 0, v15(v496));
		v28.text((v469.ss.x / 2) + (((v497 + 14) / 2) * v469.scoped_comp), (v469.ss.y / 2) + v493 + 13, 255, 255, 255, 255, "c-", 0, v474:upper());
		for v970, v971 in v2(v492) do
			local v972 = v469.helpers:new_anim("indicators_alpha" .. v971.n, (v971.a and 255) or 0, 10);
			local v973 = v469.helpers:new_anim("indicators_pose_2" .. v971.n, (v971.a and 10) or 0, 10);
			v494 = v494 + v973;
			v28.text((v469.ss.x / 2) + ((v971.s / 2) * v469.scoped_comp), (v469.ss.y / 2) + v493 + v494 + 15, v971.c[1], v971.c[2], v971.c[3], v972, "-ca", nil, v971.n);
		end
	elseif (v482 == 2) then
		local v997, v998, v999 = ((v495 == 2) and v477) or 200, ((v495 == 2) and v478) or 200, ((v495 == 2) and v479) or 200;
		local v1000, v1001, v1002 = ((v495 == 0) and v477) or 200, ((v495 == 0) and v478) or 200, ((v495 == 0) and v479) or 200;
		v28.text(((v469.ss.x / 2) - 23) + (35 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, v997, v998, v999, 255, "b", 0, "one");
		v28.text(((v469.ss.x / 2) - 5) + (35 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, v1000, v1001, v1002, 255, "b", 0, "sense");
		v28.text((v469.ss.x / 2) + 23 + (35 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, 255, 255, 255, 255, "b", 0, "°");
	elseif (v482 == 3) then
		local v1020, v1021, v1022 = ((v495 == 2) and v477) or 200, ((v495 == 2) and v478) or 200, ((v495 == 2) and v479) or 200;
		local v1023, v1024, v1025 = ((v495 == 0) and v477) or 200, ((v495 == 0) and v478) or 200, ((v495 == 0) and v479) or 200;
		local v1026, v1027, v1028 = ((v495 == 1) and v477) or 255, ((v495 == 1) and v478) or 255, ((v495 == 1) and v479) or 255;
		v28.text(((v469.ss.x / 2) - 33) + (45 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, 255, 255, 255, 255, "ab", 0, "одно");
		v28.text(((v469.ss.x / 2) - 5) + (45 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, v477, v478, v479, 255, "ab", 0, "чувство");
		v28.text(((v469.ss.x / 2) - 11) + (23 * v469.scoped_comp), (v469.ss.y / 2) + v493 + 6, v1020, v1021, v1022, 255, "ab", 0, "•");
		v28.text(((v469.ss.x / 2) - 3) + (23 * v469.scoped_comp), (v469.ss.y / 2) + v493 + 6, v1023, v1024, v1025, 255, "ab", 0, "•");
		v28.text((v469.ss.x / 2) + 5 + (23 * v469.scoped_comp), (v469.ss.y / 2) + v493 + 6, v1026, v1027, v1028, 255, "ab", 0, "•");
		if v469.ui.menu.tools.indicator_bind:get() then
			for v1051, v1052 in v2(v492) do
				local v1053 = v469.helpers:new_anim("indicators_alpha" .. v1052.n, (v1052.a and 255) or 0, 10);
				local v1054 = v469.helpers:new_anim("indicators_pose_2" .. v1052.n, (v1052.a and 13) or 0, 10);
				v494 = v494 + v1054;
				v28.text((v469.ss.x / 2) + (((v1052.s / 2) + 5) * v469.scoped_comp), (v469.ss.y / 2) + v493 + v494 + 15, v1052.c[1], v1052.c[2], v1052.c[3], v1053, "ca", nil, v1052.n:lower());
			end
		end
	elseif (v482 == 4) then
		local v1047 = "₊‧.°.⋆✦⋆.°.₊";
		v28.text(((v469.ss.x / 2) - 27) + (35 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 13, v477, v478, v479, 200, "ab", 0, v1047);
		v28.text(((v469.ss.x / 2) - 22) + (35 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 6, 255, 255, 255, 255, "ab", 0, v15(v496));
		v28.text((v469.ss.x / 2) + (((v497 + 28) / 2) * v469.scoped_comp), (v469.ss.y / 2) + v493 + 13, 255, 255, 255, 255, "ac", 0, v474);
		for v1055, v1056 in v2(v492) do
			local v1057 = v469.helpers:new_anim("indicators_alpha" .. v1056.n, (v1056.a and 255) or 0, 10);
			local v1058 = v469.helpers:new_anim("indicators_pose_2" .. v1056.n, (v1056.a and 13) or 0, 10);
			v494 = v494 + v1058;
			v28.text((v469.ss.x / 2) + (((v1056.s / 2) + 8) * v469.scoped_comp), (v469.ss.y / 2) + v493 + v494 + 15, v1056.c[1], v1056.c[2], v1056.c[3], v1057, "ca", nil, v1056.n:lower());
		end
	elseif (v482 == 5) then
		local v1074 = v469.helpers:animate_text(v26.curtime() * 2, "nesense", v477, v478, v479, 255);
		v28.texture(v42, ((v469.ss.x / 2) - 29) + (37 * v469.scoped_comp), ((v469.ss.y / 2) + v493) - 4, 11, 11, v477, v478, v479, 255);
		v28.text((v469.ss.x / 2) + 4 + (37 * v469.scoped_comp), (v469.ss.y / 2) + v493, 255, 255, 255, 255, "ac", 0, v15(v1074));
		v28.text((v469.ss.x / 2) + (((v497 + 28) / 2) * v469.scoped_comp), (v469.ss.y / 2) + v493 + 13, 255, 255, 255, 255, "ac", 0, "-" .. v474 .. "-");
	end
end,view_x=1,view_y=1,view_z=-1,view_fov=60,viewmodel=function(v498)
	local v499 = v24.get_local_player();
	local v500 = v498.ui.menu.tools.viewmodel_on:get();
	local v501 = v498.ui.menu.tools.viewmodel_scope:get();
	if not v24.is_alive(v499) then
		return;
	end
	local v502 = v24.get_player_weapon(v499);
	if (v502 == nil) then
		return;
	end
	local v503 = v24.get_prop(v502, "m_iItemDefinitionIndex");
	local v504 = v48(v47, v503);
	v504.hide_vm_scope = not v501;
	if not v500 then
		return;
	end
	local v506 = v498.ui.menu.tools.viewmodel_x1:get();
	local v507 = v498.ui.menu.tools.viewmodel_y1:get();
	local v508 = v498.ui.menu.tools.viewmodel_z1:get();
	local v509 = v498.ui.menu.tools.viewmodel_fov1:get();
	local v510 = v498.ui.menu.tools.viewmodel_x2:get();
	local v511 = v498.ui.menu.tools.viewmodel_y2:get();
	local v512 = v498.ui.menu.tools.viewmodel_z2:get();
	local v513 = v498.ui.menu.tools.viewmodel_fov2:get();
	if (v498.scoped == 1) then
		if v498.ui.menu.tools.viewmodel_inscope:get() then
			v498.view_x = v510;
			v498.view_y = v511;
			v498.view_z = v512;
			v498.view_fov = v513;
		end
	else
		v498.view_x = v506;
		v498.view_y = v507;
		v498.view_z = v508;
		v498.view_fov = v509;
	end
	v22.set_cvar("viewmodel_offset_x", v498.helpers:new_anim("view_x1", v498.view_x, 11));
	v22.set_cvar("viewmodel_offset_y", v498.helpers:new_anim("view_y1", v498.view_y, 11));
	v22.set_cvar("viewmodel_offset_z", v498.helpers:new_anim("view_z1", v498.view_z, 11));
	v22.set_cvar("viewmodel_fov", v498.helpers:new_anim("view_fov1", v498.view_fov, 11));
end,manuals=function(v514)
	local v515, v516 = v22.screen_size();
	local v517 = v24.get_local_player();
	local v518 = "";
	local v519 = "";
	if (v514.ui.menu.tools.manuals_style:get() == "Onesense") then
		v518 = "‹";
		v519 = "›";
	elseif (v514.ui.menu.tools.manuals_style:get() == "New") then
		v518 = "«";
		v519 = "»";
	end
	if not v24.is_alive(v517) then
		return;
	end
	local v520 = v514.antiaim:get_manual();
	local v521 = v514.antiaim:get_best_side();
	local v522, v523, v524, v525 = v514.ui.menu.global.color:get();
	local v526 = v514.helpers:new_anim("alpha_manual_global", (v514.ui.menu.tools.manuals_global:get() and 255) or 0, 16);
	local v527 = v514.helpers:new_anim("manual_scope", ((v514.scoped == 1) and 15) or 0, 8);
	local v528 = v514.helpers:new_anim("alpha_manual_right", ((v520 == 90) and 255) or 0, 16);
	local v529 = v514.helpers:new_anim("alpha_manual_left", ((v520 == -90) and 255) or 0, 16);
	local v530 = v514.helpers:new_anim("alpha_manual_right_global", ((v521 == 0) and 255) or 0, 8);
	local v531 = v514.helpers:new_anim("alpha_manual_left_global", ((v521 == 2) and 255) or 0, 8);
	local v532 = v514.helpers:new_anim("alpha_manual_offset", -v514.ui.menu.tools.manuals_offset:get() - 25, 12);
	v28.text((v515 / 2) + v532, ((v516 / 2) - 16) - v527, v522, v523, v524, v529, "d+", 0, v518);
	v28.text(((v515 / 2) - v532) - 11, ((v516 / 2) - 16) - v527, v522, v523, v524, v528, "d+", 0, v519);
	if (v526 < 0.1) then
		return;
	end
	v28.text((v515 / 2) + v532 + 11, ((v516 / 2) - 16) - v527, v522, v523, v524, v531 * (v526 / 255), "d+", 0, v518);
	v28.text(((v515 / 2) - v532) - 22, ((v516 / 2) - 16) - v527, v522, v523, v524, v530 * (v526 / 255), "d+", 0, v519);
end,ind_dmg=function(v533)
	local v534, v535 = v22.screen_size();
	local v536 = v24.get_local_player();
	if not v24.is_alive(v536) then
		return;
	end
	local v537, v538, v539, v540 = v533.ui.menu.tools.indicator_dmg_color:get();
	local v541 = v533.ui.menu.tools.indicator_dmg_weapon:get();
	local v542 = v19.floor(v533.helpers:new_anim("dmg_indicator", v533.helpers:get_damage() + 0.1, 8));
	local v543 = "";
	if v533.ref.rage.ovr[2] then
		if v541 then
			if v21.get(v533.ref.rage.ovr[2]) then
				v543 = v533.helpers:get_damage();
			else
				v543 = "";
			end
		elseif v21.get(v533.ref.rage.ovr[2]) then
			v543 = v542;
		else
			v543 = v542;
		end
	end
	v28.text((v534 / 2) + 5, (v535 / 2) - 17, v537, v538, v539, 255, "d", 0, v543 .. "");
end,scopedu=function(v544)
	if not v544.ui.menu.tools.animscope:get() then
		return;
	end
	local v545 = v24.get_local_player();
	local v546 = v544.ui.menu.tools.animscope_slider:get();
	local v547 = v544.ui.menu.tools.animscope_fov_slider:get();
	local v548 = v544.helpers:new_anim("animated_scoped", ((v544.scoped == 1) and v546) or 0, 8);
	if (v21.get(v544.ref.misc.override_zf) > 0) then
		v21.set(v544.ref.misc.override_zf, 0);
	end
	v21.set(v544.ref.misc.fov, v547 - v548);
end,watermark=function(v549)
	local v550, v551 = v22.screen_size();
	local v552, v553, v554, v555 = v549.ui.menu.global.color:get();
	local v556, v557 = v549.widget_watermark:get(65, 10);
	local v558 = v41.build;
	local v559, v560, v561 = 15, 15, 15;
	local v562 = v41.name;
	local v563, v564 = v22.system_time();
	local v565 = v20.format("%02d:%02d", v563, v564);
	local v566 = v19.floor(v22.latency() * 1000);
	local v567 = v28.measure_text("ca", v558);
	local v568 = v28.measure_text("ca", v562);
	local v569 = v28.measure_text("ca", v565);
	local v570 = v28.measure_text("ca", v566);
	local v571 = v567 - 38;
	local v572 = 125 + v568;
	if (v549.ui.menu.tools.style:get() == "Default") then
		v549.helpers:rounded_side_v(v556 - 60, v557 - 5, 100 + v571, 25, v559, v560, v561, 160, 6, true, true);
		v549.helpers:rounded_side_v(v556 + v571 + 51, v557 - 5, v572 + (v570 - 8), 25, v559, v560, v561, 160, 6, true, true);
		v28.text(v556 + v571 + 144 + v568 + (v569 / 2) + (v570 - 8), v557 + 7, 255, 255, 255, 255, "ca", nil, v565);
		v28.text(v556 + v571 + 135 + v568 + (v570 - 8), v557 + 7, v552, v553, v554, 255, "bca", nil, "•");
		v28.text(v556 + v571 + 105 + v568 + (v570 / 2), v557 + 7, 255, 255, 255, 255, "ca", nil, v566 .. " ping");
		v28.text(v556 + v571 + 84 + v568, v557 + 7, v552, v553, v554, 255, "bca", nil, "•");
		v28.text(v556 + v571 + 75 + (v568 / 2), v557 + 7, 255, 255, 255, 255, "ca", nil, v562);
		v28.text(v556 + v571 + 65, v557 + 7, v552, v553, v554, 255, "bca", nil, "•");
		v28.text(v556 - 30, v557 + 7, 255, 255, 255, 255, "ca", nil, "Onesense");
		v28.text(v556 + (v567 / 2), v557 + 7, v552, v553, v554, 255, "ca", nil, v558);
	else
		v43.rect_v(v556 - 60, v557 - 5, 105 + v571, 25, {v559,v560,v561,160}, 6, {v552,v553,v554,255});
		v43.rect_v(v556 + v571 + 51, v557 - 5, v572 + (v570 - 63), 25, {v559,v560,v561,160}, 6, {v552,v553,v554,255});
		v43.rect_v(v556 + v571 + v570 + v568 + 119, v557 - 5, v569 + 17, 25, {v559,v560,v561,160}, 6, {v552,v553,v554,255});
		v28.text(v556 + v571 + 135 + v568 + (v569 / 2) + (v570 - 8), v557 + 7, 255, 255, 255, 255, "ca", nil, v565);
		v28.text(v556 + v571 + 90 + v568 + (v570 / 2), v557 + 7, 255, 255, 255, 255, "ca", nil, v566 .. " ping");
		v28.text(v556 + v571 + 70 + v568, v557 + 7, v552, v553, v554, 255, "ca", nil, "/");
		v28.text(v556 + v571 + 60 + (v568 / 2), v557 + 7, 255, 255, 255, 255, "ca", nil, v562);
		v28.text(v556 - 53, v557 + 1, 255, 255, 255, 255, "a", nil, "Onesense");
		v28.text(v556 + (v567 - v567), v557 + 1, v552, v553, v554, 255, "a", nil, v558);
	end
	v549.widget_watermark:drag(v572 + v567 + v568 + v569 + v570 + 5, 35);
end,draw=false,keylist=function(v573)
	local v574, v575 = v22.screen_size();
	local v576, v577, v578, v579 = v573.ui.menu.global.color:get();
	local v580 = v573.helpers:new_anim("alpha_keybinds", (v573.draw and 160) or 0, 8);
	local v581 = 95;
	if (not v21.is_menu_open() and not v21.get(v573.ref.rage.dt[2]) and not v21.get(v573.ref.rage.os[2]) and not v21.get(v573.ref.rage.ovr[2]) and not v21.get(v573.ref.aa.freestand[1]) and not v21.get(v573.ref.rage.fd[1])) then
		v573.draw = false;
	else
		v573.draw = true;
	end
	if (v580 < 0.1) then
		return;
	end
	local v582, v583 = v573.widget_keylist:get(25, 10);
	local v584 = 0;
	local v585 = {{n="Double Tap",c={255,255,255},a=(v21.get(v573.ref.rage.dt[1]) and v21.get(v573.ref.rage.dt[2]) and not v21.get(v573.ref.rage.fd[1])),s=v28.measure_text("c", "Double tap")},{n="Hide Shots",c={255,255,255},a=(v21.get(v573.ref.rage.os[1]) and v21.get(v573.ref.rage.os[2]) and not v21.get(v573.ref.rage.fd[1])),s=(v28.measure_text("c", "Hide shots") + 1)},{n="Fake Duck",c={255,255,255},a=v21.get(v573.ref.rage.fd[1]),s=(v28.measure_text("c", "Fake duck") + 3)},{n="Min. Damage",c={255,255,255},a=(v21.get(v573.ref.rage.ovr[1]) and v21.get(v573.ref.rage.ovr[2])),s=(v28.measure_text("c", "Min dmg") + 16)},{n="Edge yaw",c={255,255,255},a=(v21.get(v573.ref.aa.edge_yaw[1]) and v573.ui.menu.antiaim.edge_yaw:get_hotkey()),s=(v28.measure_text("c", "Edge yaw") + 3)},{n="Freestand",c={255,255,255},a=(v21.get(v573.ref.aa.freestand[1]) and v21.get(v573.ref.aa.freestand[2])),s=(v28.measure_text("c", "Freestand") + 3)}};
	local v586 = v573.ui.menu.tools.style:get() == "Default";
	if v586 then
		v573.helpers:rounded_side_v(v582 - 20, v583 - 5, v581, 25, 15, 15, 15, v580, 6, true, true);
	else
		v43.rect_v(v582 - 20, v583 - 5, v581 + 6, 25, {15,15,15,v580}, 6, {v576,v577,v578,v580});
	end
	local v587 = v580 / 160;
	v28.rectangle(v582 + 8, v583 - 5, 1, 25 - ((v586 and 0) or 1), 255, 255, 255, 25 * v587);
	v28.texture(v573.globals.keylist_icon, v582 - 15, v583 - ((v586 and 0) or 1), 15, 15, 255, 255, 255, 255 * v587);
	v28.text(v582 + 35, (v583 + 7) - ((v586 and 0) or 1), 255, 255, 255, 255 * v587, "ca", nil, "Hotkeys");
	for v809, v810 in v2(v585) do
		local v811 = v573.helpers:new_anim("alpha_rect_keybinds" .. v810.n, (v810.a and 130) or 0, 8);
		local v812 = v573.helpers:new_anim("alpha_text_keybinds" .. v810.n, (v810.a and 255) or 0, 8);
		local v813 = v28.measure_text("ca", v21.get(v573.ref.rage.ovr[3])) - 12;
		local v814 = v573.helpers:new_anim("move_keybinds" .. v810.n, (v810.a and 20) or 0, 12);
		v584 = v584 + v814;
		v573.helpers:rounded_side_v(v582 - 20, v583 + 3 + v584, v581, 18, 15, 15, 15, v811 * v587, 6, true, true);
		if (v810.n == "Min. Damage") then
			v28.text((v582 + (v581 - 27)) - (v813 / 2), v583 + 11 + v584, v576, v577, v578, v812 * v587, "ca", nil, v21.get(v573.ref.rage.ovr[3]));
		else
			v28.text(v582 + (v581 - 27), v583 + 11 + v584, v576, v577, v578, v812 * v587, "ca", nil, "on");
		end
		v28.text((v582 - 40) + v810.s, v583 + 11 + v584, v810.c[1], v810.c[2], v810.c[3], v812 * v587, "ca", nil, v810.n);
	end
	v573.widget_keylist:drag(v581 + 16, 35);
end}):struct("round_reset")({auto_buy=function(v588)
	if not v588.ui.menu.tools.autobuy:get() then
		return;
	end
	if (v588.ui.menu.tools.autobuy_v:get() == "Awp") then
		v22.exec("buy awp");
	elseif (v588.ui.menu.tools.autobuy_v:get() == "Scar/g3sg1") then
		v22.exec("buy g3sg1");
		v22.exec("buy scar20");
	elseif (v588.ui.menu.tools.autobuy_v:get() == "Scout") then
		v22.exec("buy ssg08");
	end
end}):struct("misc")({charged=false,call_reg=false,jumpscout=false,unsafe_charge=function(v589)
	local v590 = v589.ui.menu.tools.unsafe_charge:get();
	local v591 = v589.ref.rage.enable;
	if not v590 then
		if v589.call_reg then
			v21.set(v591, true);
			v589.call_reg = false;
		end
		return;
	end
	local v592 = v24.get_local_player();
	if not v589.call_reg then
		v589.call_reg = true;
	end
	local v593 = v22.current_threat();
	if (v21.get(v589.ref.rage.dt[2]) and v593 and not v589.jumpscout and v589.helpers:in_air(v592) and v589.helpers:entity_has_flag(v593, "HIT")) then
		if (v21.get(v591) == true) then
			v21.set(v591, false);
		end
	elseif (v21.get(v591) == false) then
		v21.set(v591, true);
	end
end,air_stopchance=function(v594, v595)
	local v596 = v594.ui.menu.tools.air_stop;
	if (not v596:get() or not v596:get_hotkey()) then
		v594.jumpscout = false;
		return;
	end
	local v597 = v24.get_local_player();
	if (not v597 or not v24.is_alive(v597)) then
		return;
	end
	local v598 = v594.ui.menu.tools.air_stop_distance:get() * 5;
	local v599 = v29.band(v24.get_prop(v24.get_player_weapon(v597), "m_iItemDefinitionIndex"), 65535);
	local v600 = v24.get_players(true);
	for v815 = 1, #v600 do
		if (v600 == nil) then
			return;
		end
		local v816, v817, v818 = v24.get_prop(v597, "m_vecOrigin");
		local v819, v820, v821 = v24.get_prop(v600[v815], "m_vecOrigin");
		local v822 = v594.helpers:distance(v816, v817, v818, v819, v820, v821) / 11.91;
		if ((v822 < v598) and (v599 == 40)) then
			if v594.helpers:in_air(v597) then
				if v595.quick_stop then
					v594.jumpscout = true;
					v595.in_speed = 1;
				end
			end
		else
			v594.jumpscout = false;
		end
	end
end,phrases={kill={"УШАСТЫЙ ПИДОРАС ПОЧЕМУ ОПЯТЬ УМЕР?","ОТРАХАННЫЙ БИЧ СНОВА УМЕР","1 раб ебаный","пизда те немощ ебаный","ЕБУ ТЯ БОМЖИК НЕ ПУКАЙ","ИДИ КОНФИГ МОЙ КУПИ С ЗЕЛЕННЫМИ ВИЗУАЛКАМИ ФАНАТИК ПОВРОТИКА","СКАЧАЙ УЖЕ ONESENSE (BEST LUA) А ТО ТЫ УМИРАЕШЬ","ВАНЯ СЕНС БУСТИТ, 1","бомж без onesense еще умеет wasd нажимать((","как ты умер? мисснул в 20 хп xdxdxdxd иди скачай ванька уже","ЛУЧШАЯ ЛУА discord.gg/zUKBpRrSss","БИЧ ТУПОЙ ТВОЯ ЛУА НИЩ, ЛУЧШАЯ ЛУА discord.gg/zUKBpRrSss","ВСЕ ИДИ ВАЛЯЙСЯ НЕ ДУРИ ГОЛОВУ","тише будь, onesense все слышет","ваня пришел к тебе и сломал тебя"},death={"я те ща вырежу мать, лакерное чудовище","как ты меня убил ты же кроме wasd не умеешь ниче нажимать","НУ Я ТЕБЯ КАК СВИНКУ РЕЗАЛ СУКА, Я ТВОЮ МАТУХУ СБИЛ ЩА ПИДОРАС","К А К Т Е Б Е В Е З Ё Т Л А К Е Р Н О Е С У Щ Е С Т В О","не знал, что тех кто ебал отчим могут убивать"}},fast_ladder=function(v601, v602)
	local v603 = v24.get_local_player();
	local v604, v605 = v22.camera_angles();
	local v606 = v24.get_prop(v603, "m_MoveType");
	if (v606 == 9) then
		v602.yaw = v19.floor(v602.yaw + 0.5);
		v602.roll = 0;
		if (v602.forwardmove > 0) then
			if (v604 < 45) then
				v602.pitch = 89;
				v602.in_moveright = 1;
				v602.in_moveleft = 0;
				v602.in_forward = 0;
				v602.in_back = 1;
				if (v602.sidemove == 0) then
					v602.yaw = v602.yaw + 90;
				end
				if (v602.sidemove < 0) then
					v602.yaw = v602.yaw + 150;
				end
				if (v602.sidemove > 0) then
					v602.yaw = v602.yaw + 30;
				end
			end
		end
		if (v602.forwardmove < 0) then
			v602.pitch = 89;
			v602.in_moveleft = 1;
			v602.in_moveright = 0;
			v602.in_forward = 1;
			v602.in_back = 0;
			if (v602.sidemove == 0) then
				v602.yaw = v602.yaw + 90;
			end
			if (v602.sidemove > 0) then
				v602.yaw = v602.yaw + 150;
			end
			if (v602.sidemove < 0) then
				v602.yaw = v602.yaw + 30;
			end
		end
	end
end,trashtalk=function(v607, v608)
	local v609 = v24.get_local_player();
	local v610 = v22.userid_to_entindex(v608.userid);
	local v611 = v22.userid_to_entindex(v608.attacker);
	if (v609 == nil) then
		return;
	end
	if ((v611 == v609) and (v610 ~= v609)) then
		if (v607.ui.menu.tools.trashtalk_type:get() == "Default type") then
			v22.delay_call(1, function()
				v22.exec(("say %s"):format(v607.phrases.kill[v19.random(0, #v607.phrases.kill)]));
			end);
		elseif (v607.ui.menu.tools.trashtalk_type:get() == "1 MOD") then
			if v607.ui.menu.tools.trashtalk_check2:get() then
				v22.exec(("say %s, 1"):format(v24.get_player_name(v610)));
			else
				v22.exec("say 1");
			end
		elseif (v607.ui.menu.tools.trashtalk_type:get() == "Custom phrase") then
			v22.exec("say " .. v607.ui.menu.tools.trashtalk_custom:get());
		end
	end
	if ((v611 ~= v609) and (v610 == v609)) then
		v22.delay_call(2, function()
			v22.exec(("say %s"):format(v607.phrases.death[v19.random(0, #v607.phrases.death)]));
		end);
	end
end}):struct("logs")({hitboxes={[0]="body","head","chest","stomach","left arm","right arm","left leg","right leg","neck","?","gear"},miss=function(v612, v613)
	local v614, v615, v616 = v612.ui.menu.global.color:get();
	local v617 = v24.get_player_name(v613.target);
	local v618 = v612.hitboxes[v613.hitgroup] or "?";
	local v619 = v612.helpers:limit_ch(v617, 15, "...");
	local v620 = v26.tickcount() - v613.tick;
	local v621 = v19.floor(v613.hit_chance);
	v44.create_new({{"Missed "},{v619,true},{"'s in "},{v618,true},{" due "},{v613.reason,true}});
	v22.color_log(v614, v615, v616, v20.format("[onesense] ~ Missed %s in %s due to %s (hc: %s, bt: %s)", v617, v618, v613.reason, v621, v620));
end,hit=function(v622, v623, v624)
	local v625, v626, v627 = v622.ui.menu.global.color:get();
	local v628 = v24.get_player_name(v623.target);
	local v629 = v622.hitboxes[v623.hitgroup] or "?";
	local v630 = v622.helpers:limit_ch(v628, 15, "...");
	local v631 = v19.max(0, v24.get_prop(v623.target, "m_iHealth"));
	local v632 = v623.damage;
	local v633 = v26.tickcount() - v623.tick;
	local v634 = v19.floor(v623.hit_chance);
	v44.create_new({{"Hit "},{v630,true},{"'s in "},{v629,true},{" for "},{v632,true}});
	v22.color_log(v625, v626, v627, v20.format("[onesense] ~ Hit %s in %s for %s (remaning hp %s, hc: %s, bt: %s)", v628, v629, v632, v631, v634, v633));
end,shot=0,evade=function(v635, v636)
	local v637 = v24.get_local_player();
	local v638, v639, v640 = v635.ui.menu.global.color:get();
	if (v637 == nil) then
		return;
	end
	local v641 = v22.userid_to_entindex(v636.userid);
	local v642 = v24.get_player_name(v641);
	local v643 = v19.floor(v22.latency() * 1000);
	local v644 = v635.antiaim:get_best_side();
	if ((v641 == v24.get_local_player()) or not v24.is_enemy(v641) or not v24.is_alive(v637)) then
		return nil;
	end
	if v635.helpers:fired_shot(v637, v641, {v636.x,v636.y,v636.z}) then
		if (v635.shot ~= v26.tickcount()) then
			v22.color_log(v638, v639, v640, v20.format("[onesense] ~ Detected %s shot (%s ms, anti-aim side: %s)", v642, v643, v644));
			v44.create_new({{"Detected "},{v642,true},{"'s shot "},{("(" .. v643 .. "ms)"),true}});
		end
		v635.shot = v26.tickcount();
	end
end,evade2=function(v645, v646)
	local v647 = v24.get_local_player();
	if (v647 == nil) then
		return;
	end
	if ((enemy == v24.get_local_player()) or not v24.is_enemy(enemy) or not v24.is_alive(v647)) then
		return nil;
	end
	if v645.helpers:fired_shot(v647, enemy, {v646.x,v646.y,v646.z}) then
		v645.defensive:def_reset();
	end
end,harmed=function(v648, v649)
	local v650 = v24.get_local_player();
	local v651 = v22.userid_to_entindex(v649.attacker);
	local v652 = v22.userid_to_entindex(v649.userid);
	local v653 = v649.dmg_health;
	local v654 = v24.get_player_name(v651);
	local v655 = v648.hitboxes[v649.hitgroup];
	if (v651 == v650) then
		return;
	end
	if (v652 ~= v650) then
		return;
	end
	v44.create_new({{("Get " .. v653 .. " damage by ")},{(v654 .. "'s in " .. v655),true}});
end}):struct("unloads")({setup=function(v656)
	local v657 = v656.ui.menu.tools.animscope:get();
	local v658 = v656.ui.menu.tools.animscope_fov_slider:get();
	if v657 then
		v21.set(v656.ref.misc.fov, v658);
	end
	v656.ui:shutdown();
	v21.set(v656.ref.rage.enable, true);
end});
for v659, v660 in v2({{"load",function()
	v50.ui:execute();
	v50.config:setup();
end},{"aim_miss",function(shot)
	if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Miss")) then
		v50.logs:miss(shot);
	end
end},{"aim_hit",function(shot)
	if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Hit")) then
		v50.logs:hit(shot);
	end
end},{"bullet_impact",function(event)
	if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Detect shot")) then
		v50.logs:evade(event);
	end
	v50.logs:evade2(event);
end},{"player_death",function(e)
	if v50.ui.menu.tools.trashtalk:get() then
		v50.misc:trashtalk(e);
	end
end},{"player_hurt",function(event)
	if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Get harmed")) then
		v50.logs:harmed(event);
	end
end},{"setup_command",function(cmd)
	v50.antiaim:run(cmd);
	v50.misc:air_stopchance(cmd);
	v50.misc:unsafe_charge();
	if v50.ui.menu.tools.fast_ladder:get() then
		v50.misc:fast_ladder(cmd);
	end
end},{"paint",function()
	v50.tools:crosshair();
	if v50.ui.menu.tools.manuals:get() then
		v50.tools:manuals();
	end
	if v50.ui.menu.tools.indicator_dmg:get() then
		v50.tools:ind_dmg();
	end
	v50.tools:viewmodel();
	if v50.ui.menu.tools.keylist:get() then
		v50.tools:keylist();
	end
	if v50.ui.menu.tools.watermark:get() then
		v50.tools:watermark();
	end
	v50.tools:scopedu();
	if v50.ui.menu.tools.gs_ind:get() then
		v50.tools:gs_ind();
	end
end},{"shutdown",function(self)
	v50.unloads:setup();
end},{"paint_ui",function()
	if v21.is_menu_open() then
		v50.helpers:menu_visibility(false);
		v50.tools:menu_setup();
	end
end},{"pre_render",function()
	if v50.ui.menu.tools.animations:get() then
		v50.antiaim:animations();
	end
end},{"round_prestart",function()
	v50.round_reset:auto_buy();
end},{"net_update_end",function()
	v50.defensive:defensive_active();
end}}) do
	local v661 = v660[1];
	local v662 = v660[2];
	if (v661 == "load") then
		v662();
	else
		v22.set_event_callback(v661, v662);
	end
end