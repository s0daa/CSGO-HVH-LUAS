local v0=gui.add_combo("Menu Selection","lua>tab b",{"Home","Ragebot Addons","AA Addons","Widgets","Others"});
local v1=gui.add_checkbox("Main colors","lua>tab b");
local v2=gui.add_colorpicker("lua>tab b>main colors",true);
local v3=gui.add_textbox("Main User","LUA>TAB B");
local v4=gui.get_config_item("rage>aimbot>aimbot>resolver mode");
local v5=gui.add_checkbox("Disable Fakelag on HS","lua>tab b");
local v6=gui.add_checkbox("Roll Resolver on key","lua>tab b");
gui.add_keybind("lua>tab b>Roll Resolver on key");
local v7=gui.add_checkbox("Watermark","lua>tab b");
local v8=gui.add_checkbox("Info Tab","lua>tab b");
local v9=gui.add_checkbox("Keybinds","lua>tab b");
local v10=gui.add_checkbox("Indicators","lua>tab b");
local v11=gui.add_combo("Indicators | Type","lua>tab b",{"Type 1","Old"});
local v12=gui.add_combo("Info Tab | Flag","lua>tab b",{"Russia","Germany","Estonia","Hungary","Reichsflagge"});
local v13=gui.add_checkbox("Trash talk","lua>tab b");
local v14=gui.add_checkbox("Custom Sounds","lua>tab b");
local v15=gui.add_checkbox("Clantag","lua>tab b");
local v16=gui.add_checkbox("Aspect ratio","lua>tab b");
local v17=gui.add_slider("[value]","lua>tab b",1,200,1);
local v18=gui.add_checkbox("Clock Inverter","lua>tab b");
local v19=gui.add_keybind("lua>tab b>Clock Inverter");
local v20=gui.add_checkbox("AntiAim Builder","lua>tab b");
local v21=gui.add_combo("Choose AntiAim Condition:","lua>tab b",{"[None]","[Standing]","[Moving]","[Slow Walking]","[Crouching]","[In Air]"})
local v22=gui.add_checkbox("[Standing] Jitter","lua>tab b");
local v23=gui.add_slider("[Standing] Jitter range","lua>tab b",0,360,0);
local v24=gui.add_checkbox("[Standing] Fake","lua>tab b");
local v25=gui.add_slider("[Standing] Fake Amount","lua>tab b",0,100,0);
local v26=gui.add_slider("[Standing] Compensate Angle","lua>tab b",0,100,0);
local v27=gui.add_checkbox("[Standing] Jitter Fake","lua>tab b");
local v28=gui.add_checkbox("[Moving] Jitter","lua>tab b");
local v29=gui.add_slider("[Moving] Jitter range","lua>tab b",0,360,0);
local v30=gui.add_checkbox("[Moving] Fake","lua>tab b");
local v31=gui.add_slider("[Moving] Fake Amount","lua>tab b",0,100,0);
local v32=gui.add_slider("[Moving] Compensate Angle","lua>tab b",0,100,0);
local v33=gui.add_checkbox("[Moving] Jitter Fake","lua>tab b");
local v34=gui.add_checkbox("[Slow Walking] Jitter","lua>tab b");
local v35=gui.add_slider("[Slow Walking] Jitter range","lua>tab b",0,360,0);
local v36=gui.add_checkbox("[Slow Walking] Fake","lua>tab b");
local v37=gui.add_slider("[Slow Walking] Fake Amount","lua>tab b",0,100,0);
local v38=gui.add_slider("[Slow Walking] Compensate Angle","lua>tab b",0,100,0);
local v39=gui.add_checkbox("[Slow Walking] Jitter Fake","lua>tab b");
local v40=gui.add_checkbox("[Crouching] Jitter","lua>tab b");
local v41=gui.add_slider("[Crouching] Jitter range","lua>tab b",0,360,0);
local v42=gui.add_checkbox("[Crouching] Fake","lua>tab b");
local v43=gui.add_slider("[Crouching] Fake Amount","lua>tab b",0,100,0);
local v44=gui.add_slider("[Crouching] Compensate Angle","lua>tab b",0,100,0);
local v45=gui.add_checkbox("[Crouching] Jitter Fake","lua>tab b");
local v46=gui.add_checkbox("[In Air] Jitter","lua>tab b");
local v47=gui.add_slider("[In Air] Jitter range","lua>tab b",0,360,0);
local v48=gui.add_checkbox("[In Air] Fake","lua>tab b");
local v49=gui.add_slider("[In Air] Fake Amount","lua>tab b",0,100,0);
local v50=gui.add_slider("[In Air] Compensate Angle","lua>tab b",0,100,0);
local v51=gui.add_checkbox("[In Air] Jitter Fake","lua>tab b");
local v52=render.create_font("calibri.ttf",23,render.font_flag_shadow);
local v53=render.create_font("calibri.ttf",13,render.font_flag_shadow);
local v54=render.create_font("calibrib.ttf",23,render.font_flag_shadow);
local v55=render.create_font("verdana.ttf",13,render.font_flag_shadow);
local v56=render.font_esp;local v57=render.create_font("calibri.ttf",11,render.font_flag_outline);
local v58=render.create_font("calibri.ttf",13,render.font_flag_shadow);
local v59=render.create_font("verdana.ttf",13,render.font_flag_outline);
local v60=render.create_font("tahoma.ttf",13,render.font_flag_shadow);
local v61=render.create_font("verdana.ttf",12,0);local v62,v63=render.get_screen_size();
local v64=gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot");
local v65=gui.get_config_item("Rage>Anti-Aim>Fakelag>Limit");
local v66={backup=v65:get_int(),override=false};
local v67={"renew poor cantina subscription","tapped my gs","kys poor freak","ur mom adored my black cum","smellin your mommas perfume","1","l2p botik","gamesense LOL","get gamesense today","u sell that hs?","ez nigga"};local v68=0;local v69={"❇ a ","❇ an ","❇ ant ","❇ ante ","❇ anter ","❇ anterr ","❇ melancholia ","❇ anterr ","❇ anter ","❇ ante ","❇ ant ","❇ an ","❇ a "};
local function v70()local v108=entities.get_entity(engine.get_local_player());
	if ( not v108 or  not v108:is_alive()) then return;end local v109=get_client_entity(engine.get_local_player());
	local v110=v108:get_weapon();if  not v110 then return;end local v111=get_client_entity(v110:get_index());
	local v112=v108:get_prop("m_hViewModel[0]");local v113=entities.get_entity_from_handle(v112);
	local v114=get_client_entity(v113:get_index());local v115=ffi.cast(interface_type,v114)[0];
	local v116=ffi.cast(interface_type,v111)[0];local v117=ffi.cast("c_entity_get_attachment_t",v115[84]);
	local v118=ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t",v116[468]);
	local v119=ffi.new("Vector");local v120=v118(v111,v114);local v121=v117(v114,v120,v119);
	local v122=math.vec3(v119.x,v119.y,v119.z);
	return v122;end function gui_system()currenttab=v0:get_int();
	if (currenttab==2) then AntiAim=true;
		if v20:get_bool() then AAON=true;
			if (v21:get_int()==1) then CS=true;
			else CS=false;end if (v21:get_int()==2) then CM=true;
			else CM=false;end if (v21:get_int()==3) then CSW=true;
			else CSW=false;end if (v21:get_int()==4) then CC=true;
			else CC=false;end if (v21:get_int()==5) then CA=true;
			else CA=false;end else AAON=false;CS=false;CM=false;
			CSW=false;CC=false;CA=false;end else AAON=false;CS=false;CM=false;
			CSW=false;CC=false;CA=false;AntiAim=false;
		end if  not gui.is_menu_open() then AntiAim=false;
			AAON=false;
			CS=false;
			CM=false;
			CSW=false;
			CC=false;
			CA=false;
		end gui.set_visible("lua>tab b>AntiAim Builder",AntiAim);
		gui.set_visible("lua>tab b>Choose AntiAim Condition:",AAON);
		gui.set_visible("lua>tab b>[Standing] Jitter",CS);
		gui.set_visible("lua>tab b>[Standing] Jitter range",CS);
		gui.set_visible("lua>tab b>[Standing] Fake",CS);
		gui.set_visible("lua>tab b>[Standing] Fake Amount",CS);
		gui.set_visible("lua>tab b>[Standing] Compensate Angle",CS);
		gui.set_visible("lua>tab b>[Standing] Jitter Fake",CS);
		gui.set_visible("lua>tab b>[Moving] Jitter",CM);
		gui.set_visible("lua>tab b>[Moving] Jitter range",CM);
		gui.set_visible("lua>tab b>[Moving] Fake",CM);
		gui.set_visible("lua>tab b>[Moving] Fake Amount",CM);
		gui.set_visible("lua>tab b>[Moving] Compensate Angle",CM);
		gui.set_visible("lua>tab b>[Moving] Jitter Fake",CM);
		gui.set_visible("lua>tab b>[Slow Walking] Jitter",CSW);
		gui.set_visible("lua>tab b>[Slow Walking] Jitter range",CSW);
		gui.set_visible("lua>tab b>[Slow Walking] Fake",CSW);
		gui.set_visible("lua>tab b>[Slow Walking] Fake Amount",CSW);
		gui.set_visible("lua>tab b>[Slow Walking] Compensate Angle",CSW);gui.set_visible("lua>tab b>[Slow Walking] Jitter Fake",CSW);
		gui.set_visible("lua>tab b>[Crouching] Jitter",CC);
		gui.set_visible("lua>tab b>[Crouching] Jitter range",CC);
		gui.set_visible("lua>tab b>[Crouching] Fake",CC);
		gui.set_visible("lua>tab b>[Crouching] Fake Amount",CC);
		gui.set_visible("lua>tab b>[Crouching] Compensate Angle",CC);
		gui.set_visible("lua>tab b>[Crouching] Jitter Fake",CC);
		gui.set_visible("lua>tab b>[In Air] Jitter",CA);
		gui.set_visible("lua>tab b>[In Air] Jitter range",CA);
		gui.set_visible("lua>tab b>[In Air] Fake",CA);
		gui.set_visible("lua>tab b>[In Air] Fake Amount",CA);
		gui.set_visible("lua>tab b>[In Air] Compensate Angle",CA);
		gui.set_visible("lua>tab b>[In Air] Jitter Fake",CA);
	end function guiscc()local v123=v0:get_int();
	local v124=v10:get_bool();
	local v125=v8:get_bool();
	local v126=v16:get_bool();
	gui.set_visible("lua>tab b>Disable Fakelag on HS",v123==1);
	gui.set_visible("lua>tab b>Roll Resolver on key",v123==1);
	gui.set_visible("lua>tab b>Clock Inverter",v123==2);
	gui.set_visible("lua>tab b>Watermark",v123==3);
	gui.set_visible("lua>tab b>info tab",v123==3);
	gui.set_visible("lua>tab b>keybinds",v123==3);
	gui.set_visible("lua>tab b>indicators",v123==3);
	gui.set_visible("lua>tab b>indicators | type",(v123==3) and v124);
	gui.set_visible("lua>tab b>Info Tab | Flag",(v123==3) and v125);
	gui.set_visible("lua>tab b>main colors",v123==0);
	gui.set_visible("lua>tab b>main user",v123==0);
	gui.set_visible("lua>tab b>custom sounds",v123==4);
	gui.set_visible("lua>tab b>Trash talk",v123==4);
	gui.set_visible("lua>tab b>Clantag",v123==4);
	gui.set_visible("lua>tab b>Aspect ratio",v123==4);
	gui.set_visible("lua>tab b>[value]",(v123==4) and v126);
end function clantagfc()if v15:get_bool() then local v174=gui.get_config_item("misc>various>clan tag");
	local v175=math.floor(global_vars.realtime * 1.5);
	if (v68~=v175) then utils.set_clan_tag(v69[(v175% #v69) + 1]);
		v68=v175;v174:set_bool(false);
	end end end function on_player_death(v91)if v13:
	get_bool() then local v176=engine.get_local_player()
		;local v177=engine.get_player_for_user_id(v91:get_int("attacker"));
		local v178=engine.get_player_for_user_id(v91:get_int("userid"));
		local v179=engine.get_player_info(v178);
		if ((v177==v176) and (v178~=v176)) then engine.exec("w "   .. v67[utils.random_int(1, #v67)]   .. "");
		end else end end local v71=gui.get_config_item("Rage>Anti-Aim>Desync>Fake amount");
		function clock_inverter()if (engine.is_in_game()==false) then return;
		end if (v18:get_bool()==true) then v71:set_int( -v71:get_int());
		else v71:set_int(v71:get_int());
		end end function fakelagrgb()if v5:get_bool() then if v64:get_bool() then v65:set_int(1);end v66.v180=true;
	elseif v66.override then v65:set_int(v66.backup);v66.v230=false;else v66.v231=v65:get_int();
	end end function gui_controller()local v127="melancholia.ws anti-aim";
	local v128=v3:get_string();local v129,v130=render.get_text_size(v56,v127);
	local v131="user: "   .. v128   .. "";
	local v132,v133=render.get_text_size(v56,v131);
	local v134=v12:get_int();if v8:get_bool() then render.rect_filled_multicolor(5,v63/2,80,(v63/2) + 19,v2:get_color(),render.color(0,0,0,0),render.color(0,0,0,0),v2:get_color());render.text(v56,37,(v63/2) + 2,"melancholia.ws anti-aim",render.color(255,255,255,255));
		render.text(v56,37 + v129,(v63/2) + 1," experiments",v2:get_color());render.text(v56,37,(v63/2) + 10,"user: "   .. v128   .. "",render.color(255,255,255,255));render.text(v56,37 + v132,(v63/2) + 10," [alpha]",v2:get_color());
		if (v134==0) then render.rect_filled(7,(v63/2) + 2,32,(v63/2) + 7,render.color(255,255,255,255));
			render.rect_filled(7,(v63/2) + 7,32,(v63/2) + 12,render.color(28,53,120,255));
			render.rect_filled(7,(v63/2) + 12,32,(v63/2) + 17,render.color(2228,24,28,255));
		end if (v134==1) then render.rect_filled(7,(v63/2) + 2,32,(v63/2) + 7,render.color(0,0,0,255));
			render.rect_filled(7,(v63/2) + 7,32,(v63/2) + 12,render.color(221,0,0,255));
			render.rect_filled(7,(v63/2) + 12,32,(v63/2) + 17,render.color(255,204,0,255));
		end if (v134==2) then render.rect_filled(7,(v63/2) + 2,32,(v63/2) + 7,render.color(0,114,206,255));
			render.rect_filled(7,(v63/2) + 7,32,(v63/2) + 12,render.color(0,0,0,255));
			render.rect_filled(7,(v63/2) + 12,32,(v63/2) + 17,render.color(255,255,255,255));
		end if (v134==3) then render.rect_filled(7,(v63/2) + 2,32,(v63/2) + 7,render.color(206,41,57,255));
			render.rect_filled(7,(v63/2) + 7,32,(v63/2) + 12,render.color(255,255,255,255));
			render.rect_filled(7,(v63/2) + 12,32,(v63/2) + 17,render.color(71,112,80,255));
		end if (v134==4) then render.rect_filled(7,(v63/2) + 2,32,(v63/2) + 7,render.color(0,0,0,255));
			render.rect_filled(7,(v63/2) + 7,32,(v63/2) + 12,render.color(255,255,255,255));
			render.rect_filled(7,(v63/2) + 12,32,(v63/2) + 17,render.color(255,17,0,255));
		end end end local v72=cvar.r_aspectratio;
		local v73=v72:get_float();
		local function v74(v92)
			local v135,v136=render.get_screen_size();
			local v137=(v135 * v92)/v136;if (v92==1) then v137=0;end v72:set_float(v137);
		end function aspect_ratio2()local v138=v17:get_int() * 0.01;v138=2 -v138;v74(v138);
	end function watermark()local v139="melancholia.ws";
	if v7:get_bool() then render.rect_filled_rounded(1758,11,1949 -150,45,v2:get_color(),1.5,render.all);
		render.rect_filled_rounded(1808,10,1909,45,v2:get_color(),1.5,render.all);
		render.rect_filled_rounded(1809,10,1909,45,render.color(0,0,0,255),1.5,render.all);
		render.rect_filled_rounded(1759,10,1949 -150,45,render.color(0,0,0,255),1.5,render.all);
		render.text(render.font_esp,1830,16,"melancholia.ws",v2:get_color());
		render.text(render.font_esp,1817,30,"melancholia alpha v0.1",render.color(255,255,255,255));
		render.text(v54,1772,17,"A",v2:get_color());
	end end font=render.font_esp;local function v69(v93,v94,v95,v96)if v93 then return v94 + (((v95-v94) * global_vars.frametime * v96)/1.5);
	else return v94-(((v95 + v94) * global_vars.frametime * v96)/1.5);end end local v75=0;local v76=0;local v77=0;
	function indicators()local v140=entities.get_entity(engine.get_local_player());
		if  not v140 then return;
		end if  not v140:is_alive() then return;
		end local v141=v140:get_prop("m_bIsScoped");
		v75=v69(v141,v75,25,10);
		local function v142(v170,v171,v172)return ((v170v172) and v172) or v170;
		end local v143=math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255);
		local v140=entities.get_entity(engine.get_local_player());
		if  not v140 then return;end if  not v140:is_alive() then return;
		end local v144,v145=render.get_screen_size();local v146=v144/2;
		local v147=v145/2;
		local v148=0;
		if (v10:get_bool() and (v11:get_int()==0)) then local v181=math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255);
			local v182=entities.get_entity(engine.get_local_player());
			if  not v182 then return;
			end if  not v182:is_alive() then return;
			end local v183=entities.get_entity(engine.get_local_player());
			local v184=0;local v185=v142(math.abs((v183:get_prop("m_flPoseParameter",11) * 120) -60.5),0.5/60,60)/56;
			local v186,v187=35,3;
			local v188,v189=render.get_screen_size();
			local v190=v188/2;
			local v191=v189/2;
			local v192,v193=render.get_text_size(font,"melancholia");
			local v194=render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255);
			local v195=render.color(v2:get_color().r-70,v2:get_color().g-90,v2:get_color().b-70,185);
			local v196="melancholia.ws°";local v197="alpha";
			local v192,v193=render.get_text_size(v56,v196);
			local v198,v199=render.get_text_size(v56,v197);render.text(font,v190 + v75 + 7,v191 + 15 + v193,"melancholia",render.color("#FFFFFF"));
			local v192,v193=render.get_text_size(font,utils.random_int(15,100)   .. "%");
			render.text(font,v190 + v75 + 16,v191 + 25 + v193,utils.random_int(15,100)   .. "%",render.color("#FFFFFF"));
			local v200=gui.get_config_item("Rage>Aimbot>Aimbot>Double tap"):get_bool();
			local v201=gui.get_config_item("rage>aimbot>ssg08>scout>override"):get_bool();
			if v200 then v76=10;
			elseif  not v200 then v76=0;
			end if v200 then local v232,v233=render.get_text_size(font,"DT");
				render.text(font,((v190 + v75) -v232) + 27,v191 + 35 + v233,"DT",render.color("#A1FF97"));
			end if  not v201 then local v234,v235=render.get_text_size(font,"DMG");
				render.text(font,((v190 + v75) -v234) + 32,v191 + 35 + v235 + v76,"DMG",render.color(255,255,255,150));
			elseif v201 then local v240,v241=render.get_text_size(font,"DMG");
				render.text(font,((v190 + v75) -v240) + 32,v191 + 35 + v241 + v76,"DMG",render.color(255,255,255,255));
			end local v202=gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot"):get_bool();
			if  not v202 then local v236,v237=render.get_text_size(font,"HS");
				render.text(font,((v190 + v75) -v236) + 44,v191 + 35 + v237 + v76,"HS",render.color(255,255,255,150));
			elseif v202 then local v242,v243=render.get_text_size(font,"HS");
				render.text(font,((v190 + v75) -v242) + 44,v191 + 35 + v243 + v76,"HS",render.color(255,255,255,255));
			end local v203=gui.get_config_item("Rage>Aimbot>Aimbot>target dormant"):get_bool();
			if  not v203 then local v238,v239=render.get_text_size(font,"DA");
				render.text(font,((v190 + v75) -v238) + 14,v191 + 35 + v239 + v76,"DA",render.color(255,255,255,150));
			elseif v203 then local v244,v245=render.get_text_size(font,"DA");
				render.text(font,((v190 + v75) -v244) + 14,v191 + 35 + v245 + v76,"DA",render.color(255,255,255,255));
			end end end function ID()local v149=entities.get_entity(engine.get_local_player());
			if  not v149 then return;
			end if  not v149:is_alive() then return;
			end local v150=v149:get_prop("m_bIsScoped");
			v75=v69(v150,v75,25,10);
			local v151=math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255);
			local v149=entities.get_entity(engine.get_local_player());
			if  not v149 then return;
			end if  not v149:is_alive() then return;
			end local v152,v153=render.get_screen_size();
			local v154=v152/2;local v155=v153/2;local v156=0;if (v10:get_bool() and (v11:get_int()==1)) then local v204=math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255);
				local v205=entities.get_entity(engine.get_local_player());
				if  not v205 then return;
				end if  not v205:is_alive() then return;
				end local v206=entities.get_entity(engine.get_local_player());
				local v207=0;
				local v208,v209=35,3;
				local v210,v211=render.get_screen_size();
				local v212=v210/2;
				local v213=v211/2;
				local v214=render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255);
				local v215=render.color(v2:get_color().r-70,v2:get_color().g-90,v2:get_color().b-70,185);
				local v216="melancholia.ws°";local v217="alpha";local v218,v219=render.get_text_size(v56,v216);
				local v220,v221=render.get_text_size(v56,v217);render.text(v56,(v212 + v75) -4,v213 + 16,v216,render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255));
				render.text(v56,v212 + v75 + 11,v213 + 30,v217,render.color(71,71,71,v204));
				render.rect_filled(v212 + 0 + v75,v213 + 24,v212 + v75 + v208 + 9,v213 + 25 + v209 + 1,render.color("#000000"));
				render.rect_filled(v212 + v75 + 1,v213 + 25,v212 + v75 + v208 + 8,v213 + 25 + v209,render.color(255,255,255,255));
			end end local v78={render.get_screen_size()};
			local v59=render.font_esp;
			local v79=gui.add_slider("keybinds_x","lua>tab a",0,v78[1],1);
			local v80=gui.add_slider("keybinds_y","lua>tab a",0,v78[2],1);
			gui.set_visible("lua>tab a>keybinds_x",false);
			gui.set_visible("lua>tab a>keybinds_y",false);
			function animate(v97,v98,v99,v100,v101,v102)v100=v100 * global_vars.frametime * 20;
				if (v101==false) then if v98 then v97=v97 + v100;else v97=v97-v100;
				end elseif v98 then v97=v97 + ((v99-v97) * (v100/100));
				else v97=v97-((0 + v97) * (v100/100));
				end if v102 then if (v97>v99) then v97=v99;
				elseif (v97<0) then v97=0;
				end end return v97;
			end function drag(v103,v104,v105,v106)local v157,v158=input.get_cursor_pos();
			local v159=false;
			if input.is_key_down(1) then if ((v157>v103:get_int()) and (v158>v104:get_int()) and (v157<(v103:get_int() + v105)) and (v158<(v104:get_int() + v106))) then v159=true;
			end else v159=false;
		end if v159 then v103:set_int(v157-(v105/2));v104:set_int(v158-(v106/2));
		end end function on_keybinds()if  not v9:get_bool() then return;end local v160={v79:get_int(),v80:get_int()};
		local v161=0;
		local v162={gui.get_config_item("rage>aimbot>aimbot>double tap"):get_bool(),gui.get_config_item("rage>aimbot>aimbot>hide shot"):get_bool(),gui.get_config_item("rage>aimbot>ssg08>scout>override"):get_bool(),gui.get_config_item("rage>aimbot>aimbot>headshot only"):get_bool(),gui.get_config_item("misc>movement>fake duck"):get_bool()};
		local v163={"Doubletap","Hideshots","Min. Damage","HeadShot Only","Fake duck","HeadShot Only"};
		if  not v162[4] then if  not v162[5] then if  not v162[3] then if  not v162[1] then if  not v162[6] then if  not v162[2] then v161=0;
		else v161=38;end else v161=40;end else v161=41;end else v161=54;end else v161=63;end else v161=70;
	end animated_size_offset=animate(animated_size_offset or 0,true,v161,60,true,false);local v164={100 + animated_size_offset,22};
	local v165="[enabled]";
	local v166=render.get_text_size(v59,v165) + 7;
	local v167=v162[3] or v162[4] or v162[5] or v162[6] or v162[7] or v162[8];local v168=v162[1] or v162[2] or v162[9] or v162[10] or v162[11];
	drag(v79,v80,v164[1],v164[2]);v77=animate(v77 or 0,gui.is_menu_open() or v167 or v168,1,0.5,false,true);
	for v173=1,10 do render.rect_filled_rounded(v160[1] -v173,v160[2] -v173,v160[1] + v164[1] + v173,v160[2] + v164[2] + v173,render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,(20 -(2 * v173)) * v77),10);
	end render.push_clip_rect(v160[1],v160[2],v160[1] + v164[1],v160[2] + 5);
	render.rect_filled_rounded(v160[1],v160[2],v160[1] + v164[1],v160[2] + v164[2],render.color(0,0,0,105 * v77),5);
	render.pop_clip_rect();render.push_clip_rect(v160[1],v160[2] + 17,v160[1] + v164[1],v160[2] + 22);
	render.rect_filled_rounded(v160[1],v160[2],v160[1] + v164[1],v160[2] + 22,render.color(0,0,0,105 * v77),5);
	render.pop_clip_rect();render.rect_filled_multicolor(v160[1],v160[2] + 5,v160[1] + v164[1],v160[2] + 17,render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255 * v77),render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255 * v77),render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255 * v77),render.color(v2:get_color().r,v2:get_color().g,v2:get_color().b,255 * v77));render.rect_filled_rounded(v160[1] + 2,v160[2] + 2,(v160[1] + v164[1]) -2,v160[2] + 20,render.color(0,0,0,255 * v77),5);render.text(v59,((v160[1] + (v164[1]/2)) -(render.get_text_size(v59,"keybinds")/2)) -1,v160[2] + 7,"keybinds",render.color(255,255,255,255 * v77));
	local v169=0;dt_alpha=animate(dt_alpha or 0,v162[1],1,0.5,false,true);render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2,v163[1],render.color(255,255,255,255 * dt_alpha));
	render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2,v165,render.color(255,255,255,255 * dt_alpha));
	if v162[1] then v169=v169 + 11;
	end hs_alpha=animate(hs_alpha or 0,v162[2],1,0.5,false,true);
	render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2 + v169,v163[2],render.color(255,255,255,255 * hs_alpha));
	render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2 + v169,v165,render.color(255,255,255,255 * hs_alpha));
	if v162[2] then v169=v169 + 11;end dmg_alpha=animate(dmg_alpha or 0,v162[3],1,0.5,false,true);render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2 + v169,v163[3],render.color(255,255,255,255 * dmg_alpha));
	render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2 + v169,v165,render.color(255,255,255,255 * dmg_alpha));if v162[3] then v169=v169 + 11;
	end fs_alpha=animate(fs_alpha or 0,v162[4],1,0.5,false,true);render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2 + v169,v163[4],render.color(255,255,255,255 * fs_alpha));
	render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2 + v169,v165,render.color(255,255,255,255 * fs_alpha));
	if v162[4] then v169=v169 + 11;
	end ho_alpha=animate(ho_alpha or 0,v162[5],1,0.5,false,true);render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2 + v169,v163[5],render.color(255,255,255,255 * ho_alpha));render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2 + v169,v165,render.color(255,255,255,255 * ho_alpha));
	if v162[5] then v169=v169 + 11;end fd_alpha=animate(fd_alpha or 0,v162[6],1,0.5,false,true);render.text(v59,v160[1] + 6,v160[2] + v164[2] + 2 + v169,v163[6],render.color(255,255,255,255 * fd_alpha));render.text(v59,(v160[1] + v164[1]) -v166,v160[2] + v164[2] + 2 + v169,v165,render.color(255,255,255,255 * fd_alpha));
end function on_shot_registered(v107)if v14:get_bool() then if (v107.server_damage<=0) then return;
end engine.exec("play aways.wav");end end local v81=render.font_esp;local v82=gui.get_config_item("rage>anti-aim>angles>jitter");
local v83=gui.get_config_item("rage>anti-aim>angles>jitter range");
local v84=gui.get_config_item("rage>anti-aim>desync>fake");
local v85=gui.get_config_item("rage>anti-aim>desync>fake amount");
local v86=gui.get_config_item("rage>anti-aim>desync>compensate angle");
local v87=gui.get_config_item("rage>anti-aim>desync>freestand fake");
local v88=gui.get_config_item("rage>anti-aim>desync>flip fake with jitter");
local v89=gui.get_config_item("misc>movement>slide");
function builder()if (engine.is_in_game()==false) then return;
end if v20:get_bool() then local v222=v89:get_bool();
	local v223=entities.get_entity(engine.get_local_player());
	local v224=v223:get_prop("m_fFlags");
	local v225=v223:get_prop("m_hGroundEntity")== -1;
	local v226=math.floor(v223:get_prop("m_vecVelocity[0]"));
	local v227=math.floor(v223:get_prop("m_vecVelocity[1]"));
	local v228=math.sqrt((v226^2) + (v227^2));
	local v229=input.is_key_down(17);
	if (v222 and  not v225 and (v224~=263)) then v82:set_bool(v34:get_bool());
		v83:set_int(v35:get_int());
		v84:set_bool(v36:get_bool());
		v85:set_int(v37:get_int());
		v86:set_int(v38:get_int());
		v88:set_bool(v39:get_bool());
	elseif ((v228>2) and  not v225 and  not v229) then v82:set_bool(v28:get_bool());
		v83:set_int(v29:get_int());v84:set_bool(v30:get_bool());v85:set_int(v31:get_int());v86:set_int(v32:get_int());v88:set_bool(v33:get_bool());
	elseif ((v228<=2) and (v224==257)) then v82:set_bool(v22:get_bool());v83:set_int(v23:get_int());v84:set_bool(v24:get_bool());v85:set_int(v25:get_int());v86:set_int(v26:get_int());v88:set_bool(v27:get_bool());
	elseif v229 then v82:set_bool(v40:get_bool());v83:set_int(v41:get_int());v84:set_bool(v42:get_bool());v85:set_int(v43:get_int());v86:set_int(v44:get_int());v88:set_bool(v45:get_bool());
	elseif (v225 and (v224~=262)) then v82:set_bool(v46:get_bool());
		v83:set_int(v47:get_int());v84:set_bool(v48:get_bool());
		v85:set_int(v49:get_int());v86:set_int(v50:get_int());
		v88:set_bool(v51:get_bool());
	elseif (v224==262) then v82:set_bool(v40:get_bool());
		v83:set_int(v41:get_int());
		v84:set_bool(v42:get_bool());
		v85:set_int(v43:get_int());
		v86:set_int(v44:get_int());
		v88:set_bool(v45:get_bool());
	end end end local v90=v4:get_int();
	function resolvermode()if v6:get_bool() then v4:set_int(0);else v4:set_int(v90);
	end end function on_shutdown()utils.set_clan_tag("");
	v4:set_int(v90);
end function on_paint()watermark();
gui_controller();
guiscc();
on_keybinds();
fakelagrgb();
clock_inverter();
clantagfc();
gui_system();
builder();
resolvermode();
aspect_ratio2();
end