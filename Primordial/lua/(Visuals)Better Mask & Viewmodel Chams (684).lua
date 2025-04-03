-->> Create Required FFI Elements <<
local ffi = require("ffi")
ffi.cdef([[
	typedef void* (*get_interface_fn)();
	
    typedef struct {
        get_interface_fn get;
        char* name;
        void* next;
    } interface;	
]]);

local GetModuleHandle = ffi.cast("void*(__stdcall*)(const char*)",ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B")) + 2)[0][0])
local GetProcAddress = ffi.cast("void*(__stdcall*)(void*, const char*)",ffi.cast("uint32_t**", ffi.cast("uint32_t", memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05")) + 2)[0][0])

local function BetterCreateInterface(module, interface_name)
    local ModuleInterface = ffi.cast("int", GetProcAddress(GetModuleHandle(module), "CreateInterface"))
    local interface = ffi.cast("interface***", ModuleInterface + ffi.cast("int*", ModuleInterface + 5)[0] + 15)[0][0];
    while interface~=ffi.NULL do 
		if ffi.string(interface.name):match(interface_name.."%d+") then return interface.get() end 
		interface = ffi.cast("interface*", interface.next) ;
	end
end

local VEngineClient = ffi.cast(ffi.typeof("void***"), BetterCreateInterface("engine.dll", "VEngineClient")) or error("VEngineClient Not Found!!!")



-->> Create Main Materials Data Table
local CHAM_MATERIALS = {
	NORMAL_FLAGS = [[
		"$basetexture"  "VGUI/white_additive"
		"$color" "[1 1 1]" 
		"$nofog" "1"
		"$mod2x" "1" 
		"$envmap" "env_cubemap" 
		"$phong" "1" 
		"$basemapalphaphongmask"  "1" 
		"$phongboost" "0" 
		"$phonginput" "0"
		"$rimlight" "1" 
		"$rimlightexponent" "9999999"
		"$rimlightboost" "0" 
		"$pearlescent" "0" 
		"$pearlescentinput" "0"
		"$devidebyten" "10"
		"$alpha" "1" 
		"$selfillum" "1" 
		"$envmaptint" "[0 0 0]" 
		"$envmaptintr" "0" 
		"$envmaptintg" "0" 
		"$envmaptintb" "0"
		"$envmaptintmod" "24000" 
		"$phongtint" "[0 0 0]" 
		"$phongtintr" "0" 
		"$phongtintg" "0" 
		"$phongtintb" "0" 
		"$phongtintmod" "255"
		"$rimlightboosta" "0"
		"$rimlightboostb" "10"
		"Proxies"
		{
			"Divide"
			{
				"srcVar1" "$phonginput"
				"srcVar2" "$devidebyten"
				"resultVar" "$phongboost"
			}
			"Divide"
			{
				"srcVar1" "$pearlescentinput"
				"srcVar2" "$devidebyten"
				"resultVar" "$pearlescent"
			}
			"Divide" 
			{ 
				"srcVar1" "$envmaptintr" 
				"srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[0]" 
			}
	
			"Divide" 
			{ 
				"srcVar1" "$envmaptintg" 
				"srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[1]" 
			}

			"Divide" 
			{ 
				"srcVar1" "$envmaptintb"
				 "srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[2]" 
			}

			"Divide" 
			{
				"srcVar1" "$phongtintr" 
				"srcVar2" "$phongtintmod" 
				"resultVar" "$phongtint[0]" 
			}

			"Divide" 
			{
				"srcVar1" "$phongtintg" 
				"srcVar2" "$phongtintmod" 
				"resultVar" "$phongtint[1]" 
			}

			"Divide" 
			{ 
				"srcVar1" "$phongtintb" 
				"srcVar2" "$phongtintmod" 
				"resultVar" "$phongtint[2]" 
			}

			"Divide"
			{
				"srcVar1" "$rimlightboosta" 
				"srcVar2" "$rimlightboostb" 
				"resultVar" "$rimlightboost" 	
			}
		}
	]];

	ANIMATED_FLAGS = [[
		"$color" 					"[1 1 1]"
		"$alpha" 					"1"
		"$additive"					"1"
		"$selfillum" 				"1"
		"$wireframe"				"1"
		"$ignorez"					"0"
		"$translate"				"[0.0 0.0]"
		"$angle" 					"90"
		"$centervar"                "[-0.5 -0.5]"
		"$scalevar"                 "[1.0 1.0]"
		"$scaleinput"               "100"
		"$texturescrollrate"        "0.25"
		"$texturescrollangle"       "180"
		"$texturescrollinput"       "25"
		"$devidebyonehundred"         "100"
		"Proxies"
		{
			"Divide"
			{
				"srcVar1" "$scaleinput"
				"srcVar2" "$devidebyonehundred"
				"resultVar" "$scalevar[0]"
			}
			"Divide"
			{
				"srcVar1" "$scaleinput"
				"srcVar2" "$devidebyonehundred"
				"resultVar" "$scalevar[1]"
			}
			"Divide"
			{
				"srcVar1" "$texturescrollinput"
				"srcVar2" "$devidebyonehundred"
				"resultVar" "$texturescrollrate"
			}
			"TextureScroll"
			{
				"textureScrollVar" "$translate"
				"textureScrollRate" "$texturescrollrate"
				"textureScrollAngle" "$texturescrollangle"
			}
			
			"TextureTransform"
			{
				"translateVar" "$translate"
				"scalevar" "$scalevar"
				"rotateVar" "$angle"
				"centerVar" "$centervar"
				"resultVar" "$basetexturetransform"
			}
		}
	]];

	GLOW = [["VertexLitGeneric" {
		"$additive" "1" 
		"$envmap" "models/effects/cube_white" 
		"$envmaptint" "[1.00 1.00 1.00]" 
		"$envmaptintr" "0"
		"$envmaptintg" "0" 
		"$envmaptintb" "0" 
		"$envmaptintmod" "255" 
		"$envmapfresnel" "1" 
		"$envmapfresnelminmaxexp" "[0 1 2]"
		"$envmapfresnelbrightnessdiv" "500" 
		"$envmapfresnelbrightness" "1" 
		"$envmapfresnelfilldiv" "4" 
		"$envmapfresnelfill" "1"
		"$selfillum" "1" 
		"$wireframe" "0" 
		"$ignorez" "0"
		"Proxies"
		{
			"Divide" 
			{ 
				"srcVar1" "$envmaptintr" 
				"srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[0]" 
			}

			"Divide" 
			{ 
				"srcVar1" "$envmaptintg" 
				"srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[1]" 
			}

			"Divide" 
			{ 
				"srcVar1" "$envmaptintb" 
				"srcVar2" "$envmaptintmod" 
				"resultVar" "$envmaptint[2]" 
			}

			"Divide" 
			{ 
				"srcVar1" "$envmapfresnelbrightness" 
				"srcVar2" "$envmapfresnelbrightnessdiv" 
				"resultVar" "$envmapfresnelminmaxexp[1]" 
			}

			"Divide" 
			{
				"srcVar1" "$envmapfresnelfill" 
				"srcVar2" "$envmapfresnelfilldiv" 
				"resultVar" "$envmapfresnelminmaxexp[2]" 
			}
		}
	}]];
	
	CREATE = function(self, name)
		return {
			[1] = { -- Base materials
				[1] = materials.create(name .. "__mod", [[ "Modulate" { 
					]].. self.NORMAL_FLAGS ..[[
				} ]]);

				[2] = materials.create(name .. "__vlg", [[ "VertexLitGeneric" { 
					]].. self.NORMAL_FLAGS ..[[
				} ]]);

				[3] = materials.create(name .. "__ulg", [[ "UnlitGeneric" { 
					]].. self.NORMAL_FLAGS ..[[
				} ]]);
			};
			
			[2] = materials.create(name .. "__glw", self.GLOW); -- Glow material

			[3] = { -- Animated materials
				[1] = materials.create(name .. "__an1",  [[ "UnlitGeneric" { 
					"$basetexture" "particle/beam_taser"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[2] = materials.create(name .. "__an2", [[ "UnlitGeneric" { 
					"$basetexture" "cable/phonecable"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[3] = materials.create(name .. "__an3", [[ "UnlitGeneric" { 
					"$basetexture" "dev/hemisphere_normal"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[4] = materials.create(name .. "__an4", [[ "UnlitGeneric" { 
					"$basetexture" "dev/zone_warning"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[5] = materials.create(name .. "__an5", [[ "UnlitGeneric" { 
					"$basetexture" "particle/bendibeam"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[6] = materials.create(name .. "__an6", [[ "UnlitGeneric" { 
					"$basetexture" "effects/metalfence007a"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);

				[7] = materials.create(name .. "__an7", [[ "UnlitGeneric" { 
					"$basetexture" "particle/particle_ring_wave_2"
					]].. self.ANIMATED_FLAGS ..[[
				} ]]);
			};
		};
	end
};



-->> Create Configuration Tab <<
local UI = {
    category = menu.add_selection("Chams", "Category", {"Mask", "Arms", "Sleeves", "Weapon"});
    spacer = menu.add_separator("Chams");

    mask = {}; arms = {}; sleeves = {}; weapon = {};

    organize = function(self)
        local a = self.category:get()

        self.mask:set_visible(a==1)
		self.arms:set_visible(a==2)
		self.sleeves:set_visible(a==3)
		self.weapon:set_visible(a==4)
    end;
}

local function GenerateChamGroup(name)
	local cfg_name = "["..name.."] ";

	tbl = CHAM_MATERIALS:CREATE(name);

	tbl.BASE_MAT = menu.add_selection("Chams", cfg_name.."Base|Shine|Ref", {"Off", "Invisible", "Material", "Vertex Lit", "Unlit"});
	tbl.REFLECTIVITY = tbl.BASE_MAT:add_color_picker(cfg_name.."Reflectivity Color", color_t(255,255,255,0));
	tbl.SHINE = tbl.BASE_MAT:add_color_picker(cfg_name.."Shine Color", color_t(255,255,255,0));
	tbl.BASE_CLR = tbl.BASE_MAT:add_color_picker(cfg_name.."Base Color", color_t(255,255,255,255));
	tbl.PEARLESCENT = menu.add_slider("Chams", cfg_name.."Pearlescent", -100, 100, 5, 0);
	tbl.RIMLIGHT = menu.add_slider("Chams", cfg_name.."Rimlight", 0, 100, 5, 0, "%");

	tbl.SPACER_1 = menu.add_text("Chams", " ");

	tbl.ANIM_MAT = menu.add_selection("Chams", cfg_name.."Animated", {"Off", "Tazer Beam", "Phonecable", "Hemishpere", "Zone Warning", "Bendibeam", "MetalFence", "Ring Wave"});
	tbl.ANIM_CLR = tbl.ANIM_MAT:add_color_picker(cfg_name.."Anim Color", color_t(255,255,255,255));
	tbl.SCALE = menu.add_slider("Chams", cfg_name.."Texture Scale", 0, 1000, 25, 0, "%");
	tbl.ANGLE = menu.add_slider("Chams", cfg_name.."Texture Angle", -180, 180, 15, 0, "°");
	tbl.SCROLL = menu.add_slider("Chams", cfg_name.."Anim Angle", -180, 180, 15, 0, "°");
	tbl.SPEED = menu.add_slider("Chams", cfg_name.."Anim Speed", 0, 500, 10, 0, "%");

	tbl.SPACER_2 = menu.add_text("Chams", " ");
	
	tbl.WIREFRAME = menu.add_multi_selection("Chams", cfg_name.."Wireframe", {"Base Material", "Animated Material", "Glow Material"});
	tbl.FILL = menu.add_slider("Chams", cfg_name.."Glow Fill", 0, 100, 1, 0, "%");
	tbl.GLOW_CLR = tbl.FILL:add_color_picker(cfg_name.."Glow Color", color_t(255,255,255,255));

	tbl.is_visible = true;
	tbl.set_visible = function(a,b)
		if b==a.is_visible then return end

		a.BASE_MAT:set_visible(b)
		a.PEARLESCENT:set_visible(b)
		a.RIMLIGHT:set_visible(b)
		a.SPACER_1:set_visible(b)
		a.ANIM_MAT:set_visible(b)
		a.SCALE:set_visible(b)
		a.ANGLE:set_visible(b)
		a.SCROLL:set_visible(b)
		a.SPEED:set_visible(b)
		a.SPACER_2:set_visible(b)
		a.WIREFRAME:set_visible(b)
		a.FILL:set_visible(b)

		a.is_visible=b
	end; return tbl
end

UI.mask=GenerateChamGroup("m")
UI.arms=GenerateChamGroup("a")
UI.sleeves=GenerateChamGroup("s")
UI.weapon=GenerateChamGroup("w")

GenerateChamGroup=nil;



-->> Create Main Cham Override Table <<
local chamOverride={
	glow_fix = 1;

    is_hdr_enabled = ffi.cast("bool (__thiscall*)(void*)", VEngineClient[0][109]);

    update_glow_fix = function(self)
        self.glow_fix = self.is_hdr_enabled(VEngineClient) and 1 or 15
    end;

	set = function(self, ctx, disable, group)
		if disable then return false end

		local BASE_MAT, ANIM_MAT, GLOW = group.BASE_MAT:get()-2, group.ANIM_MAT:get()-1, group.FILL:get()>0;
		if not (BASE_MAT>=0 or ANIM_MAT>=1 or GLOW) then return false end

		local wireframe = group.WIREFRAME;


		-- Base Section
		if BASE_MAT<1 then if BASE_MAT==-1 then ctx:draw_original() end else 
			local mat, clr = group[1][BASE_MAT], group.BASE_CLR:get();
			
			if BASE_MAT == 1 then ctx:draw_original(clr) else
				local ref, ref_mod, shine = group.REFLECTIVITY:get(), (group.REFLECTIVITY:get().a/2.55), group.SHINE:get();

				mat:color_modulate(clr.r/255, clr.g/255, clr.b/255) 
				mat:alpha_modulate(clr.a/255)

				mat:set_shader_param("$pearlescentinput", group.PEARLESCENT:get()*0.5) 
				mat:set_shader_param("$rimlightboosta", (group.RIMLIGHT:get()*0.5)^2)

				mat:set_shader_param("$envmaptintr", ref.r*ref_mod) 
				mat:set_shader_param("$envmaptintg", ref.g*ref_mod) 
				mat:set_shader_param("$envmaptintb", ref.b*ref_mod)

				mat:set_shader_param("$phongtintr", shine.r) 
				mat:set_shader_param("$phongtintg", shine.g) 
				mat:set_shader_param("$phongtintb", shine.b)
			 	mat:set_shader_param("$phonginput", shine.a/2.55)
			end

			mat:set_flag(e_material_flags.WIREFRAME, wireframe:get(1))

			ctx:draw_material(mat, color_t(255, 255, 255, clr.a))
		end

		
		-- Anim Section
		if ANIM_MAT >= 1 then 
			local mat, clr = group[3][ANIM_MAT], group.ANIM_CLR:get();

			mat:color_modulate(clr.r/255, clr.g/255, clr.b/255) 
			mat:alpha_modulate(clr.a/255)

			mat:set_shader_param("$scaleinput", group.SCALE:get()) 
			mat:set_shader_param("$angle", group.ANGLE:get())
			mat:set_shader_param("$texturescrollangle", group.SCROLL:get()) 
			mat:set_shader_param("$texturescrollinput", group.SPEED:get())

			mat:set_flag(e_material_flags.WIREFRAME, wireframe:get(2))

			ctx:draw_material(mat) 
		end


		-- Glow Section
		if GLOW then 
			local mat, clr = group[2], group.GLOW_CLR:get();

			mat:set_shader_param("$envmaptintr", clr.r) 
			mat:set_shader_param("$envmaptintg", clr.g) 
			mat:set_shader_param("$envmaptintb", clr.b)
			
			mat:set_shader_param("$envmapfresnelbrightness", (clr.a/2.55)*self.glow_fix)
			mat:set_shader_param("$envmapfresnelfill", 100-group.FILL:get())

			mat:set_flag(e_material_flags.WIREFRAME, wireframe:get(3))

			ctx:draw_material(mat) 
		end 


		return true
	end;
};



-->> Local Vars <<
local pLocal, m_bIsScoped, WeaponID, wasInGame = nil, false, 0, false;



-->> Create Callbacks <<
callbacks.add(e_callbacks.DRAW_MODEL, function(ctx) pcall(function()
	local name = ctx.model_name;

	if name:find("weapons/v_") then
		
		if not name:find("weapons/v_models") then ctx.override_original = chamOverride:set(ctx, (m_bIsScoped and (WeaponID==8 or WeaponID==39)), UI.weapon); return
		
		elseif name:find("weapons/v_models/arms/glove") then ctx.override_original = chamOverride:set(ctx, false, UI.arms); return
		
		else ctx.override_original = chamOverride:set(ctx, false, UI.sleeves); return end

	elseif name:find("facemasks") then ctx.override_original = chamOverride:set(ctx, false, UI.mask); return end
end) end)


callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
	pLocal = entity_list:get_local_player();
    if not pLocal then return end

    local Weapon = pLocal:get_active_weapon(); 
    if not Weapon then return end

	local WeaponData = Weapon:get_weapon_data(); 
    if not WeaponData then return end

	WeaponID = e_items[(WeaponData.console_name):upper()];
    m_bIsScoped = pLocal:get_prop("m_bIsScoped") == 1;
end)


callbacks.add(e_callbacks.PAINT, function()
    if menu.is_open() then 
        UI:organize() 
    end

    if not pLocal then return end

    local InGame = engine.is_in_game();
    if InGame~=wasInGame then
        wasInGame=InGame;

        if not InGame then 
            pLocal=nil;
            return
        end

        chamOverride:update_glow_fix()
    end
end)