-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- fixed by shady#0559

_DEBUG = true

local ctx = {}

local sidebar_text = {
  "\a85d5ffff".."B",
  "\a7cd1ffff".."e",
  "\a77ccffff".."t",
  "\a79c6ffff".."t",
  "\a82bfffff".."e",
  "\a90b7ffff".."r",
  " ",
  "\aa2adffff".."C",
  "\ab7a2ffff".."h",
  "\acd95ffff".."a",
  "\ae286ffff".."m",
  "\af775ffff".."s"
}

function ctx.get_sidebar_text()
  local text = ""

  for i = 1, #sidebar_text do
    text = text..sidebar_text[i]
  end

  return text
end

ui.sidebar(ctx.get_sidebar_text(), "palette")

ctx.material_data = {
  shaders = {"None", "VertexLitGeneric", "UnlitGeneric"},
  basetextures = {"Light glow", "Firework", "Zone warning", "Palm", "Star", "Spark", "Beam taser", "Light sprite", "Ring wave", "Muzzle flash", "Blood puff", "Blood gore", "ZerogXPlode", "Mask", "Rico", "Leaf"},
  basetexture_to_material = {
    ["Light glow"] = "sprites/light_glow02",
    ["Firework"] = "models/weapons/customization/paints/anodized_multi/smoke",
    ["Zone warning"] = "dev/zone_warning",
    ["Palm"] = "models/props/de_dust/hr_dust/foliage/palm_bark_01",
    ["Star"] = "models/inventory_items/dreamhack_trophies/dreamhack_star_blur",
    ["Spark"] = "effects/spark",
    ["Beam taser"] = "particle/beam_taser",
    ["Light sprite"] = "engine/lightsprite",
    ["Ring wave"] = "particle/particle_ring_wave_12",
    ["Muzzle flash"] = "effects/muzzleflash3",
    ["Blood puff"] = "effects/blood_puff",
    ["Blood gore"] = "effects/blood_gore",
    ["ZerogXPlode"] = "sprites/zerogxplode",
    ["Mask"] = "models/player/custom_player/econ/head/tm_professional/tm_professional_mask_varf1",
    ["Rico"] = "sprites/rico1",
    ["Leaf"] = "particle/leaf/leafdead"
  },

  material_to_basetexture = {
    ["sprites/light_glow02"] = "Light glow",
    ["models/weapons/customization/paints/anodized_multi/smoke"] = "Firework",
    ["dev/zone_warning"] = "Zone warning",
    ["models/props/de_dust/hr_dust/foliage/palm_bark_01"] = "Palm",
    ["models/inventory_items/dreamhack_trophies/dreamhack_star_blur"] = "Star",
    ["effects/spark"] = "Spark",
    ["particle/beam_taser"] = "Beam taser",
    ["engine/lightsprite"] = "Light sprite",
    ["particle/particle_ring_wave_12"] = "Ring wave",
    ["effects/muzzleflash3"] = "Muzzle flash",
    ["effects/blood_puff"] = "Blood puff",
    ["effects/blood_gore"] = "Blood gore",
    ["sprites/zerogxplode"] = "ZerogXPlode",
    ["models/player/custom_player/econ/head/tm_professional/tm_professional_mask_varf1"] = "Mask",
    ["sprites/rico1"] = "Rico",
    ["particle/leaf/leafdead"] = "Leaf"
  },

  user_materials = {"Default"},
  user_materials_data = {
    ["Default"] = {material = materials.create("Default", [[
      "VertexLitGeneric" { 
        "$basetexture" "sprites/light_glow02"
        "proxies" {
          "texturescroll" { 
            "texturescrollrate" "1" 
            "texturescrollangle" "90" 
            "texturescrollvar" "$basetexturetransform"  
          } 
        }
        "$alphatest" "1"
        "$additive" "1"
        "$wireframe" "1" 
      }
    ]])}
  },

  user_materials_glow_data = {}
}

ffi.cdef([[
  //Никаких файлов суки
]])

ctx.configs = {
  configs_list = {"Default"},
  configs = {
    
  }
}

local _utils = {}
function _utils:initialize()
  local private = {}
    private.set_clipboard_text_native = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
    private.get_clipboard_text_length_native = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
    private.get_clipboard_text_native = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "void(__thiscall*)(void*, int, const char*, int)")

    private.alphabet = "ZV61Rdu/hzCeQAHOMrLFqfSIKwUNlEJt9xTiXY8pDnoyjG0cbmg7W5ka43+s2PBv" --shuffled default alphabet

  local public = {}
    function public:set_clipboard_text(text)
      if #text > 0 then
        private.set_clipboard_text_native(text, #text)
      end
    end

    function public:get_clipboard_text()
      local text_length = private.get_clipboard_text_length_native()
      if text_length > 0 then
        local buffer = ffi.new("char[?]", text_length)
        local size = text_length * ffi.sizeof(buffer)
        private.get_clipboard_text_native(0, buffer, size)

        return ffi.string(buffer, text_length - 1)
      end

      return ""
    end

    function public:encode(str)
      local b = private.alphabet
      return ((str:gsub('.', function(x) 
          local r,b='',x:byte()
          for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end

          return r;
      end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
          if (#x < 6) then return '' end
          local c=0
          for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end

          return b:sub(c+1,c+1)
      end)..({ '', '><', '>' })[#str%3+1])
    end

    function public:decode(str)
      local b = private.alphabet
      str = string.gsub(str, '[^'..b..'>]', '')
      return (str:gsub('.', function(x)
        if (x == '>') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        
        return r;
      end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        
        return string.char(c)
      end))
    end

    function public:get_configs_list()
      -- Мне не дали разрешения выкладывать это
    end

    function public:is_element_exist(tbl, value)
      for i = 1, #tbl do
        if tbl[i] == value then
          return true
        end
      end

      return false
    end

    function public:get_index_by_value(tbl, value)
      for i = 1, #tbl do
        if tbl[i] == value then
          return i
        end
      end

      return nil
    end

    function public:set_fresnel_fill(value)
      if value == 100 then return 0.1 end

      if value == 1 then return 10 end

      return 10 - value / 10
    end

    function public:get_fresnel_fill(value)
      if value == 1 then return 10 end

      if value == 100 then return 0.1 end

      return (10 - value) * 10
    end

    function public:get_material(name)
      if ctx.material_data.user_materials_data[name] ~= nil then
        return ctx.material_data.user_materials_data[name].material
      else --will be called after deleting material
        ctx.material_data.user_materials_data[name] = nil -- ??????????
        local last_material = ctx.material_data.user_materials_data[ctx.material_data.user_materials[#ctx.material_data.user_materials]]
        return last_material.material
      end
    end

    function public:get_glow(name)
      if ctx.material_data.user_materials_glow_data[name] ~= nil then
        return ctx.material_data.user_materials_glow_data[name].material
      end

      return nil
    end

    function public:update_visible(tbl, state)
      for name, element in pairs(tbl) do
        element:visibility(state)
      end
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.utils = _utils:initialize()

ctx.menu = {}

local menu = {}
function menu:builder()
  local menu = {}
    menu.builder_tab = ui.create(ui.get_icon("cog").." Settings", "Chams builder")
    menu.create_button = menu.builder_tab:button("\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("plus").."\a"..ui.get_style("Text"):to_hex().." Create new material", nil, true)

    menu.elements_text = {
      cancel_button = "\aFF0000FF"..ui.get_icon("fire").."\a"..ui.get_style("Text"):to_hex().." Cancel",
      save_button = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("download").."\a"..ui.get_style("Text"):to_hex().." Save"
    }

    menu.elements = {
      name = menu.builder_tab:input("Name"),
      shader = menu.builder_tab:combo("Shader", ctx.material_data.shaders),
      basetexture = menu.builder_tab:combo("Basetexture", ctx.material_data.basetextures),
      color = menu.builder_tab:color_picker("Texture color", color(255,255,255,255)),
      adjustments = menu.builder_tab:selectable("Adjustments", {"Additive", "Wireframe", "IgnoreZ", "Glow"}),
      effects = menu.builder_tab:selectable("Effects", {"Texture scroll", "Nocull"}),
      cancel_button = menu.builder_tab:button(menu.elements_text.cancel_button, nil, true),
      save_button = menu.builder_tab:button(menu.elements_text.save_button, nil, true)
    }

    menu.adjustments_settings = menu.elements.adjustments:create()
    menu.adjustments_elements = {
      color = menu.adjustments_settings:color_picker("Color"),
      wireframe = menu.adjustments_settings:switch("Wireframe", false),
      brightness = menu.adjustments_settings:slider("Brightness", 0, 30, 1, 0.1),
      fill = menu.adjustments_settings:slider("Fill", 0, 100, 100, 0.1)
    }

    menu.effects_settings = menu.elements.effects:create()
    menu.effects_elements = {
      direction = menu.effects_settings:slider("Direction", -180, 180, 90),
      velocity = menu.effects_settings:slider("Velocity", 0, 25, 10, 0.1)
    }

    ctx.utils:update_visible(menu.elements, false) --Set up default state
    menu.create_button:set_callback(function()
      ctx.utils:update_visible(menu.elements, true) --Set up visible on create
      
      menu.elements.shader:set_callback(function(reference)
        menu.elements.effects:visibility(reference:get() ~= "None" and menu.elements.basetexture:get_visible()) --$$$ Superior fix $$$
      end, true)

      menu.elements.effects:set_callback(function(reference)
        ctx.utils:update_visible(menu.effects_elements, reference:get(1) and menu.elements.effects:get_visible())
      end, true)
    end, true)

    menu.elements.adjustments:set_callback(function(reference)
      ctx.utils:update_visible(menu.adjustments_elements, reference:get(4)) --Set up adjustments settings visible
    end, true)

    menu.elements.cancel_button:set_callback(function()
      ctx.utils:update_visible(menu.elements, false) --Set up visible on create cancel
    end, true)

    menu.elements.save_button:set_callback(function()
      ctx.utils:update_visible(menu.elements, false) --Set up visible on save
    end, true)

  local public = {}
    function public:elements()
      return {
        elements = menu.elements,
        adjustments = menu.adjustments_elements,
        effects = menu.effects_elements
      }
    end

    function public:on_save(__function)
      menu.elements.save_button:set_callback(function()
        __function()
      end)
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.menu.builder = menu:builder()

function menu:editor()
  local menu = {}
    menu.editor_tab = ui.create(ui.get_icon("cog").." Settings", "Chams editor")
    menu.material_to_edit = menu.editor_tab:combo("Material", ctx.material_data.user_materials)

    menu.edit_button = menu.editor_tab:button("\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("cog").."\a"..ui.get_style("Text"):to_hex().." Edit material", nil, true)
    menu.delete_button = menu.editor_tab:button("\aFF0000FF"..ui.get_icon("trash").."\a"..ui.get_style("Text"):to_hex().." Delete material", nil, true)

    menu.elements_text = {
      cancel_button = "\aFF0000FF"..ui.get_icon("fire").."\a"..ui.get_style("Text"):to_hex().." Cancel",
      save_button = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("download").."\a"..ui.get_style("Text"):to_hex().." Save"
    }

    menu.elements = {
      shader = menu.editor_tab:combo("Shader", ctx.material_data.shaders),
      basetexture = menu.editor_tab:combo("Basetexture", ctx.material_data.basetextures),
      color = menu.editor_tab:color_picker("Texture color", color(255,255,255,255)),
      adjustments = menu.editor_tab:selectable("Adjustments", {"Additive", "Wireframe", "IgnoreZ", "Glow"}),
      effects = menu.editor_tab:selectable("Effects", {"Texture scroll", "Nocull"}),
      cancel_button = menu.editor_tab:button(menu.elements_text.cancel_button, nil, true),
      save_button = menu.editor_tab:button(menu.elements_text.save_button, nil, true)
    }
    
    menu.adjustments_settings = menu.elements.adjustments:create()
    menu.adjustments_elements = {
      color = menu.adjustments_settings:color_picker("Color", color(255,255,255,255)),
      wireframe = menu.adjustments_settings:switch("Wireframe", false),
      brightness = menu.adjustments_settings:slider("Brightness", 0, 30, 1, 0.1),
      fill = menu.adjustments_settings:slider("Fill", 0, 100, 100, 0.1)
    }

    menu.effects_settings = menu.elements.effects:create()
    menu.effects_elements = {
      direction = menu.effects_settings:slider("Direction", -180, 180, 90),
      velocity = menu.effects_settings:slider("Velocity", 0, 25, 10, 0.1)
    }

    ctx.utils:update_visible(menu.elements, false) --Set up default state
    menu.material_to_edit:set_callback(function()
      ctx.utils:update_visible(menu.elements, false) --Set up visible on material combo switch
    end, true)

    menu.edit_button:set_callback(function()
      menu.elements.shader:set_callback(function(reference)
        menu.elements.effects:visibility(reference:get() ~= "None" and menu.elements.basetexture:get_visible()) --Effects dont work without shaders >~<
      end, true)

      menu.elements.effects:set_callback(function(reference)
        ctx.utils:update_visible(menu.effects_elements, reference:get(1) and menu.elements.basetexture:get_visible())
      end, true)
    end, true)

    menu.elements.adjustments:set_callback(function(reference)
      ctx.utils:update_visible(menu.adjustments_elements, reference:get(4))
    end, true)

    menu.elements.cancel_button:set_callback(function()
      ctx.utils:update_visible(menu.elements, false) --Set up visibe on edit cancel
    end, true)

    menu.elements.save_button:set_callback(function()
      ctx.utils:update_visible(menu.elements, false) --Set up visible on save
    end, true)

  local public = {}
    function public:elements()
      return {
        material = menu.material_to_edit,
        elements = menu.elements,
        adjustments = menu.adjustments_elements,
        effects = menu.effects_elements
      }
    end

    function public:on_edit(__function)
      menu.edit_button:set_callback(function()
        __function()
      end)
    end

    function public:on_save(__function)
      menu.elements.save_button:set_callback(function()
        __function()
      end)
    end

    function public:on_delete(__function)
      menu.delete_button:set_callback(function()
        __function()
      end)
    end

    function public:update()
      menu.material_to_edit:update(ctx.material_data.user_materials)
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.menu.editor = menu:editor()

function menu:chams()
  local menu = {}
    menu.viewmodel_tab = ui.create(ui.get_icon("eye").." Chams", "Viewmodel")
    menu.viewmodel_elements = {
      arms = menu.viewmodel_tab:switch("Arms", false),
      sleeves = menu.viewmodel_tab:switch("Sleeves", false),
      weapon = menu.viewmodel_tab:switch("Weapon", false)
    }

    menu.arms_settings = menu.viewmodel_elements.arms:create()
    menu.arms_elements = {
      original = menu.arms_settings:switch("Force original model", true),
      material = menu.arms_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.sleeves_settings = menu.viewmodel_elements.sleeves:create()
    menu.sleeves_elements = {
      original = menu.sleeves_settings:switch("Force original model", true),
      material = menu.sleeves_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.weapon_settings = menu.viewmodel_elements.weapon:create()
    menu.weapon_elements = {
      original = menu.weapon_settings:switch("Force original model", true),
      material = menu.weapon_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.players_tab = ui.create(ui.get_icon("eye").." Chams", "Players")
    menu.players_elements = {
      local_model = menu.players_tab:switch("Local model"),
      enemy_model = menu.players_tab:switch("Enemy model"),
      ally_model = menu.players_tab:switch("Ally model")
    }

    menu.local_model_settings = menu.players_elements.local_model:create()
    menu.local_model_elements = {
      original = menu.local_model_settings:switch("Force original model", true),
      material = menu.local_model_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.enemy_model_settings = menu.players_elements.enemy_model:create()
    menu.enemy_model_elements = {
      original = menu.enemy_model_settings:switch("Force original model", true),
      material = menu.enemy_model_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.alies_model_settings = menu.players_elements.ally_model:create()
    menu.alies_model_elements = {
      original = menu.alies_model_settings:switch("Force original model", true),
      material = menu.alies_model_settings:combo("Material", ctx.material_data.user_materials)
    }

    menu.world_tab = ui.create(ui.get_icon("eye").." Chams", "World")
    menu.world_elements = {
      chicken = menu.world_tab:switch("Chicken"),
    }

    menu.chicken_settings = menu.world_elements.chicken:create()
    menu.chicken_elements = {
      original = menu.chicken_settings:switch("Force original model", true),
      material = menu.chicken_settings:combo("Material", ctx.material_data.user_materials)
    }

  local public = {}
    function public:arms()
      return {
        state = menu.viewmodel_elements.arms,
        original = menu.arms_elements.original,
        material = menu.arms_elements.material
      }
    end

    function public:sleeves()
      return {
        state = menu.viewmodel_elements.sleeves,
        original = menu.sleeves_elements.original,
        material = menu.sleeves_elements.material
      }
    end

    function public:weapon()
      return {
        state = menu.viewmodel_elements.weapon,
        original = menu.weapon_elements.original,
        material = menu.weapon_elements.material
      }
    end

    function public:local_model()
      return {
        state = menu.players_elements.local_model,
        original = menu.local_model_elements.original,
        material = menu.local_model_elements.material
      }
    end
    
    function public:enemy_model()
      return {
        state = menu.players_elements.enemy_model,
        original = menu.enemy_model_elements.original,
        material = menu.enemy_model_elements.material
      }
    end

    function public:ally_model()
      return {
        state = menu.players_elements.ally_model,
        original = menu.alies_model_elements.original,
        material = menu.alies_model_elements.material
      }
    end

    function public:chicken()
      return {
        state = menu.world_elements.chicken,
        original = menu.chicken_elements.original,
        material = menu.chicken_elements.material
      }
    end
  
    function public:update()
      menu.arms_elements.material:update(ctx.material_data.user_materials)
      menu.sleeves_elements.material:update(ctx.material_data.user_materials)
      menu.weapon_elements.material:update(ctx.material_data.user_materials)
      menu.local_model_elements.material:update(ctx.material_data.user_materials)
      menu.enemy_model_elements.material:update(ctx.material_data.user_materials)
      menu.alies_model_elements.material:update(ctx.material_data.user_materials)
      menu.chicken_elements.material:update(ctx.material_data.user_materials)
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.menu.chams = menu:chams()

function menu:configs()
  local menu = {}
    menu.configs_tab = ui.create(ui.get_icon("link").." Configs", "Configs")
    menu.elements_text = {
      update_list = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("atom").."\a"..ui.get_style("Text"):to_hex().." Update list",
      save_config = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("download").."\a"..ui.get_style("Text"):to_hex().." Save",
      load_config = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("upload").."\a"..ui.get_style("Text"):to_hex().." Load",
      export_to_clipboard = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("copy").."\a"..ui.get_style("Text"):to_hex().." Copy",
      import_from_clipboard = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("paste").."\a"..ui.get_style("Text"):to_hex().." Paste",
      delete_config = "\aFF0000FF"..ui.get_icon("trash").."\a"..ui.get_style("Text"):to_hex().." Delete",
      cancel_button = "\aFF0000FF"..ui.get_icon("fire").."\a"..ui.get_style("Text"):to_hex().." Cancel",
      confirm_button = "\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("check").."\a"..ui.get_style("Text"):to_hex().." Confirm"
    }
    
    menu.configs_elements = {
      config_list = menu.configs_tab:list("Config list", ctx.configs.configs_list),
      update_list = menu.configs_tab:button(menu.elements_text.update_list, nil, true),
      save_config = menu.configs_tab:button(menu.elements_text.save_config, nil, true),
      load_config = menu.configs_tab:button(menu.elements_text.load_config, nil, true),
      empty_label = menu.configs_tab:label(""),
      export_to_clipboard = menu.configs_tab:button(menu.elements_text.export_to_clipboard, nil, true),
      import_from_clipboard = menu.configs_tab:button(menu.elements_text.import_from_clipboard, nil, true),
      delete_config = menu.configs_tab:button(menu.elements_text.delete_config, nil, true)
    }

    menu.create_tab = ui.create(ui.get_icon("link").." Configs", "Create")
    menu.create_button = menu.create_tab:button("\a"..ui.get_style("Button Active"):to_hex()..ui.get_icon("plus").."\a"..ui.get_style("Text"):to_hex().." Create new config", nil, true)
    menu.create_elements = {
      config_name = menu.create_tab:input("Config name"),
      cancel_button = menu.create_tab:button(menu.elements_text.cancel_button, nil, true),
      confirm_button = menu.create_tab:button(menu.elements_text.confirm_button, nil, true)
    }
    ctx.utils:update_visible(menu.create_elements, false)

    menu.create_button:set_callback(function()
      ctx.utils:update_visible(menu.create_elements, true)
    end)

    menu.create_elements.confirm_button:set_callback(function()
      ctx.utils:update_visible(menu.create_elements, false)
    end)

    menu.create_elements.cancel_button:set_callback(function()
      ctx.utils:update_visible(menu.create_elements, false)
    end)

    menu.configs_elements.update_list:set_callback(function()
      menu.configs_elements.config_list:update({"Default", unpack(ctx.utils:get_configs_list())})
    end)

  local public = {}
    function public:selected_config()
      return menu.configs_elements.config_list:list()[menu.configs_elements.config_list:get()]
    end

    function public:update(list)
      local list = list == nil and {"Default"} or {"Default", unpack(list)}
      menu.configs_elements.config_list:update(list)
    end

    function public:on_save(__function)
      menu.configs_elements.save_config:set_callback(function()
        __function()
      end)
    end

    function public:on_load(__function)
      menu.configs_elements.load_config:set_callback(function()
        __function()
      end)
    end

    function public:on_import_from_clipboard(__function)
      menu.configs_elements.import_from_clipboard:set_callback(function()
        __function()
      end)
    end

    function public:on_export_to_clipboard(__function)
      menu.configs_elements.export_to_clipboard:set_callback(function()
        __function()
      end)
    end

    function public:on_delete(__function)
      menu.configs_elements.delete_config:set_callback(function()
        __function()
      end)
    end

    function public:new_config_name()
      return menu.create_elements.config_name:get()
    end

    function public:on_create(__function)
      menu.create_elements.confirm_button:set_callback(function()
        __function()
      end)
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.menu.configs = menu:configs()

ctx.menu.configs:update(ctx.utils:get_configs_list())

local material_system = {}
function material_system:initialize()
  local public = {}
    function public:new_material(name, shader, properties, color)
      local key_values = shader == "None" and "" or string.format('"%s" {', shader)
      for property_name, property_value in pairs(properties) do
        if property_name == "proxies" then
          key_values = key_values..'"proxies" {'

          for proxy_name, proxy_value in pairs(property_value) do
            key_values = key_values..'"'..proxy_name..'"'.." {"

            for prop_name, prop_value in pairs(proxy_value) do
              key_values = key_values..'"'..prop_name..'"'..' "'..prop_value..'"'
            end

            key_values = key_values.." }"
          end

          key_values = key_values.." }"
        else
          key_values = key_values..'"$'..property_name..'"'..' "'..property_value..'"'
        end
      end
      key_values = key_values.." }"

      local material = materials.create(name, key_values)
      material:color_modulate(color)
      material:alpha_modulate(color.a)
      
      return material
    end

    function public:new_glow(material_name, properties, color)
      local key_values = '"VertexLitGeneric" {'
      for property_name, property_value in pairs(properties) do
        key_values = key_values..'"$'..property_name..'"'..' "'..property_value..'"'
      end
      key_values = key_values.." }"

      local glow = materials.create(material_name.."_glow", key_values)
      return glow
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.material_system = material_system:initialize()

local builder = {}
function builder:initialize()
  local builder = {}
    function builder:get_data()
      local builder_settings = ctx.menu.builder:elements()

      local properties = {
        basetexture = ctx.material_data.basetexture_to_material[builder_settings.elements.basetexture:get()],
        alpha = builder_settings.elements.color:get().a / 255
      }

      local proxies = nil
      local glow = nil

      local adjustments = builder_settings.elements.adjustments
      local effects = builder_settings.elements.effects

      if adjustments:get(1) then properties["additive"] = "1" end
      if adjustments:get(2) then properties["wireframe"] = "1" end
      if adjustments:get(3) then properties["ignorez"] = "1" end
      if adjustments:get(4) then
        glow = {}
        glow.wireframe = builder_settings.adjustments.wireframe:get()
        glow.color = builder_settings.adjustments.color:get()
        glow.brightness = builder_settings.adjustments.brightness:get() /10
        glow.fill = ctx.utils:set_fresnel_fill(builder_settings.adjustments.fill:get())
        glow.properties = {}
        glow.properties["envmap"] = "models/effects/cube_white"
        glow.properties["alpha"] = tostring(glow.color.a /255)
        glow.properties["wireframe"] = (glow.wireframe and "1" or "0")
        glow.properties["additive"] = "1"
        glow.properties["envmaptint"] = "["..(glow.color.r /255).." "..(glow.color.g /255).." "..(glow.color.b /255).."]"
        glow.properties["envmapfresnel"] = "1"
        glow.properties["envmapfresnelminmaxexp"] = "[0 "..glow.brightness.." "..glow.fill.."]"
      end

      if #effects:get() ~= 0 and builder_settings.elements.shader:get() ~= "None" then
        proxies = {}
      end

      if effects:get(1) then
        proxies["texturescroll"] = {
          texturescrollvar = "$basetexturetransform",
          texturescrollangle = tostring(builder_settings.effects.direction:get()),
          texturescrollrate = tostring(builder_settings.effects.velocity:get() / 10)
        }
      end

      if effects:get(2) then properties["nocull"] = "1" end

      if proxies ~= nil then
        properties["proxies"] = proxies
      end

      return {
        name = builder_settings.elements.name:get(),
        shader = builder_settings.elements.shader:get(),
        properties = properties,
        color = builder_settings.elements.color:get(),
        glow = glow
      }
    end

    --[[
      Да благословит нас и сохранит Всемогущий Милосердный Бог Отец, Бог Сын, Бог Дух Святый.
      О, сладчайший Иисусе Христе, Всемогущий Царю неба и земли, Сыне Давидов, Иисусе Назорее, нас ради распятый на Кресте, смилуйся над этим домом, храни живущих в нем. Да будет Твое благословение Господне сопутствовать им  везде; да освятит Дух Cвятый мысли и сердца их; Всемогущество Его везде, во всяком месте: все, что находится  в  этом доме,  кто к ним входит и кто выходит от них, да благословит Пресвятая Троица и сохранит от всякого зла, чтобы ничто нечистое не приблизилось к ним.
      Имя Господа Иисуса Христа с девятью  чинами Ангелов  да будет в  сем  доме и даст ему свой покой. Да покроет своим материнским Покровом Пресвятая Дева Мария, да охраняют его святые Апостолы, благополучие  его  да  утвердят  и  укрепят  святые  Евангелисты.
      Крест Господа нашего Иисуса Христа да будет кровлей ему; гвозди  Господа  нашего  Иисуса Христа  да будут его защитой; венец  Господа нашего  Иисуса  Христа  да  будет  его  покровом.
      Пресвятая  Дева  Мария,  святый  праведный  Иосиф  и  вси святые, Ангелы Хранители, умолите Господа нашего Иисуса Христа, Единаго  от  Святыя Троицы, да сохранит сей дом от  грома, молнии, огня, града, наводнения, от нападения злых  людей, нужды, неверия, ереси, войны и всякого  несчастия, грозящего   душе  и  телу, в чем да поможет нам Бог  Отец,  Бог  Сын,  Бог  Дух  Святый. Аминь.
      Сподоби, Господи, в день сей (или: нощь сию) без греха  сохранитися нам.
      Господи, помилуй,  Господи, помилуй, Господи, помилуй.
      Буди, Господи, милость Твоя на нас, якоже уповахом на Тя. На Тя, Господи уповахом, да не постыдимся во веки. Аминь.
    ]]

    function builder:create_material()
      local data = builder:get_data()

      if data.name == "CFG_DEFAULT" then
        common.add_notify("ERROR", "This name is reserved")
        return
      end

      if ctx.utils:is_element_exist(ctx.material_data.user_materials, data.name) then
        data.name = data.name.."(2)"
      end

      table.insert(ctx.material_data.user_materials, data.name)

      ctx.material_data.user_materials_data[data.name] = {
        material = ctx.material_system:new_material(data.name, data.shader, data.properties, data.color),
        shader = data.shader,
        properties = data.properties,
        color = data.color,
      }

      if data.glow ~= nil then
        ctx.material_data.user_materials_glow_data[data.name] = {
          material = ctx.material_system:new_glow(data.name, data.glow.properties, data.glow.color),
          properties = data.glow.properties,
          color = data.glow.color,
          wireframe = data.glow.wireframe,
          brightness = data.glow.brightness,
          fill = data.glow.fill
        }
      end

      ctx.menu.editor:update()
      ctx.menu.chams:update()
    end

    ctx.menu.builder:on_save(function()
      builder:create_material()
    end)
end
ctx.builder = builder:initialize()

local editor = {}
function editor:initialize()
  local editor = {}
  function editor:get_data()
    local data = {}

    local material = ctx.menu.editor:elements().material
    local material_data = ctx.material_data.user_materials_data[material:get()]
    local glow_data = ctx.material_data.user_materials_glow_data[material:get()]

    if material_data.properties == nil then
      return nil
    end

    data.basetexture = ctx.material_data.material_to_basetexture[material_data.properties["basetexture"]]
    data.shader = material_data.shader
    data.properties = material_data.properties
    data.color = material_data.color

    if material_data.properties["additive"] ~= nil then data.additive = true end
    if material_data.properties["wireframe"] ~= nil then data.wireframe = true end
    if material_data.properties["ignorez"] ~= nil then data.ignorez = true end
    if glow_data ~= nil then
      data.glow = {}
      data.glow.wireframe = glow_data.wireframe
      data.glow.color = glow_data.color
      data.glow.brightness = glow_data.brightness * 10
      data.glow.fill = ctx.utils:get_fresnel_fill(glow_data.fill)
      data.glow.properties = {}
      data.glow.properties["envmap"] = "models/effects/cube_white"
      data.glow.properties["wireframe"] = data.glow.wireframe
      data.glow.properties["additive"] = "1"
      data.glow.properties["envmaptint"] = "["..(data.glow.color.r /255).." "..(data.glow.color.g /255).." "..(data.glow.color.b /255).."]"
      data.glow.properties["envmapfresnel"] = "1"
      data.glow.properties["envmapfresnelminmaxexp"] = "[0 "..data.glow.brightness.." "..data.glow.fill.."]"
    end

    if material_data.properties["proxies"] ~= nil then
      local proxies = material_data.properties["proxies"]
      if proxies["texturescroll"] ~= nil then
        data.texture_scroll = {}
        data.texture_scroll.velocity = tonumber(proxies["texturescroll"]["texturescrollrate"]) * 10
        data.texture_scroll.direction = tonumber(proxies["texturescroll"]["texturescrollangle"])
      end
    end

    if material_data.properties["nocull"] ~= nil then data.nocull = true end

    return data
  end

  function editor:update_data()
    local data = editor:get_data()
    if data == nil then
      common.add_notify("WARNING", "You aren`t allow to edit default material!")
      return
    end

    local elements = ctx.menu.editor:elements().elements
    local adjustments_elements = ctx.menu.editor:elements().adjustments
    local effects_elements = ctx.menu.editor:elements().effects
    
    elements.basetexture:set(data.basetexture)
    elements.shader:set(data.shader)
    elements.color:set(data.color)

    local adjustments = {}
    local effects = {}

    if data.additive == true then table.insert(adjustments, "Additive") end
    if data.wireframe == true then table.insert(adjustments, "Wireframe") end
    if data.ignorez == true then table.insert(adjustments, "IgnoreZ") end
    if data.glow ~= nil then 
      table.insert(adjustments, "Glow") 
      adjustments_elements.color:set(data.glow.color)
      adjustments_elements.wireframe:set(data.glow.wireframe)
      adjustments_elements.brightness:set(data.glow.brightness)
      adjustments_elements.fill:set(data.glow.fill)
    end
    elements.adjustments:set(unpack(adjustments))

    if data.texture_scroll ~= nil then
      table.insert(effects, "Texture scroll")
      effects_elements.velocity:set(data.texture_scroll.velocity)
      effects_elements.direction:set(data.texture_scroll.direction)
    end

    if data.nocull == true then table.insert(effects, "Nocull") end
    elements.effects:set(unpack(effects))

    ctx.utils:update_visible(ctx.menu.editor:elements().elements, true)
  end

  ctx.menu.editor:on_edit(function()
    editor:update_data()
  end)

  --[[
     Да благословит нас и сохранит Всемогущий Милосердный Бог Отец, Бог Сын, Бог Дух Святый.
     О, сладчайший Иисусе Христе, Всемогущий Царю неба и земли, Сыне Давидов, Иисусе Назорее, нас ради распятый на Кресте, смилуйся над этим домом, храни живущих в нем. Да будет Твое благословение Господне сопутствовать им  везде; да освятит Дух Cвятый мысли и сердца их; Всемогущество Его везде, во всяком месте: все, что находится  в  этом доме,  кто к ним входит и кто выходит от них, да благословит Пресвятая Троица и сохранит от всякого зла, чтобы ничто нечистое не приблизилось к ним.
     Имя Господа Иисуса Христа с девятью  чинами Ангелов  да будет в  сем  доме и даст ему свой покой. Да покроет своим материнским Покровом Пресвятая Дева Мария, да охраняют его святые Апостолы, благополучие  его  да  утвердят  и  укрепят  святые  Евангелисты.
     Крест Господа нашего Иисуса Христа да будет кровлей ему; гвозди  Господа  нашего  Иисуса Христа  да будут его защитой; венец  Господа нашего  Иисуса  Христа  да  будет  его  покровом.
     Пресвятая  Дева  Мария,  святый  праведный  Иосиф  и  вси святые, Ангелы Хранители, умолите Господа нашего Иисуса Христа, Единаго  от  Святыя Троицы, да сохранит сей дом от  грома, молнии, огня, града, наводнения, от нападения злых  людей, нужды, неверия, ереси, войны и всякого  несчастия, грозящего   душе  и  телу, в чем да поможет нам Бог  Отец,  Бог  Сын,  Бог  Дух  Святый. Аминь.
     Сподоби, Господи, в день сей (или: нощь сию) без греха  сохранитися нам.
     Господи, помилуй,  Господи, помилуй, Господи, помилуй.
     Буди, Господи, милость Твоя на нас, якоже уповахом на Тя. На Тя, Господи уповахом, да не постыдимся во веки. Аминь.
  ]]

  function editor:edit_material()
    local material = ctx.menu.editor:elements().material
    local elements = ctx.menu.editor:elements().elements
    local adjustments_elements = ctx.menu.editor:elements().adjustments
    local effects_elements = ctx.menu.editor:elements().effects

    local properties = {
      basetexture = ctx.material_data.basetexture_to_material[elements.basetexture:get()],
      alpha = elements.color:get().a / 255
    }

    local proxies = nil
    local glow = nil

    if elements.adjustments:get(1) then properties["additive"] = "1" end
    if elements.adjustments:get(2) then properties["wireframe"] = "1" end
    if elements.adjustments:get(3) then properties["ignorez"] = "1" end
    if elements.adjustments:get(4) then
      glow = {}
      glow.wireframe = adjustments_elements.wireframe:get()
      glow.color = adjustments_elements.color:get()
      glow.brightness = adjustments_elements.brightness:get() / 10
      glow.fill = ctx.utils:set_fresnel_fill(adjustments_elements.fill:get())
      glow.properties = {}
      glow.properties["envmap"] = "models/effects/cube_white"
      glow.properties["wireframe"] = (glow.wireframe and "1" or "0")
      glow.properties["additive"] = "1"
      glow.properties["envmaptint"] = "["..(glow.color.r /255).." "..(glow.color.g /255).." "..(glow.color.b /255).."]"
      glow.properties["envmapfresnel"] = "1"
      glow.properties["envmapfresnelminmaxexp"] = "[0 "..glow.brightness.." "..glow.fill.."]"
    end

    if #elements.effects:get() ~= 0 then
      proxies = {}
    end

    if elements.effects:get(1) then
      proxies["texturescroll"] = {
        texturescrollvar = "$basetexturetransform",
        texturescrollangle = tostring(effects_elements.direction:get()),
        texturescrollrate = tostring(effects_elements.velocity:get() / 10)
      }
    end

    if elements.effects:get(2) then
      properties["nocull"] = "1"
    end

    if proxies ~= nil then
      properties["proxies"] = proxies
    end

    local data = ctx.material_data.user_materials_data[material:get()]
    ctx.material_data.user_materials_data[material:get()] = {
      material = ctx.material_system:new_material(material:get(), elements.shader:get(), properties, elements.color:get()),
      shader = elements.shader:get(),
      properties = properties,
      color = elements.color:get(),
    }

    if glow == nil then
      ctx.material_data.user_materials_glow_data[material:get()] = nil
    else
      ctx.material_data.user_materials_glow_data[material:get()] = {
        material = ctx.material_system:new_glow(material:get(), glow.properties, glow.color),
        properties = glow.properties,
        color = glow.color,
        wireframe = glow.wireframe,
        brightness = glow.brightness,
        fill = glow.fill
      }
    end
  end

  function editor:delete_material()
    local material = ctx.menu.editor:elements().material
    if material:get() == "Default" then
      common.add_notify("WARNING", "You aren`t allow to delete default material")
      return
    end

    local idx = ctx.utils:get_index_by_value(ctx.material_data.user_materials, material:get())
    table.remove(ctx.material_data.user_materials, idx)
    table.remove(ctx.material_data.user_materials_data, idx)

    ctx.menu.editor:update()
    ctx.menu.chams:update()
  end

  ctx.menu.editor:on_save(function()
    editor:edit_material()
  end)

  ctx.menu.editor:on_delete(function()
    editor:delete_material()
    ctx.utils:update_visible(ctx.menu.editor:elements().elements, false)
  end)
end
ctx.editor = editor:initialize()

local configs_system = {}
function configs_system:initialize()
  local configs = {
    default = "JgzGwS35IkfjwS5YNpr7hinsh8djN/YtNSPXwSbTHYGsh85xEufgUSdjhiDTMWw/IWrdrXdfFdMTe6zcl8YpUS3xN6h+E/z5wLbTlarxEuqTHprgESfPILbTKIzGlgh+SajTNSdWwIznKSbTHTz1rXEtrRfuMffQf6hjh8PgUSEnN8djhinWlpfYe6z7EudWwLh+E/z5wI5Ee6ziUuYiUkf0hinNJgzGKIrYl8YxN6h+hXAur5PRrqwVfqmqhTbTNaznwkY0KSbTHprgESqjhpAWKIrYhinWlpfYtfWjh8f0wS53Ik5cwufjhinNJgzGKIrYl8YxN6h+hXrYw8d5N/MTe6zcl8YpUS3xN6h+E/z5wLbTlarxEuqTH8wxN/AYtfWjh8mcKkdjIk5cwufjhinNJgzGKIrYl8YxN6h+hXAur5PRrqwVfqmqhTbTNaznwkY0KSbTHprgESqjhpAWKIrYhin8KSm7wI5Ee6z7NufYE8f7hinNJgzGKIrYl8YxN6h+hXrYw8d5N/MTe6zcl8YpUS3xN6h+E/z5wLbTlarxEuqTH8wxN/AYtfWjhpEYKIVcNTh+SajTNSdWwIznKSbTHTz1rXEtrRfuMffQf6hjh8PgUSEnN8djhin8KSm7wLbTlarxEuqTHprgESfPIIWjhpf7wIztNSdWwIznKSm7hinNhXAur5PRrqwVfqmqhYWjhpf7wIztNSdWwIznKSm7IkrxEuRTHYGsh8AcNuPghinsh8RTHih5AL4be6zThiDgQFX0Q6bTwgh+QFMmeiZjhphTHih5AL4btLbTN8dGwLh+hXAur5PRrqwVfqmqhTbTl/zclufgEuYYlgh+JgzxwurnEuYkwLh+hiRTe6zxN/VDKLh+QL4be6zTKIAYEuf4E/fgwLh+h85cwufjlgPnNpwYNprclpYtUIrYNIQcw/zYKS5DKSAyIargNaVDUSf7ekrgwSdGUudiU5P7EudgIkzjEIhTe6zbl8P4USf7hinshprYJ/r5l8f7KazcNubTHpjTEuf4E/fgwIAil8PjNud0wkmYhiDTHFZTe6zWwIxWEIzYlkAgNkmjl8dWwLh+hiRTe6zWwIxWEIzYlkAgNkmjE8dghiDTzuzxlkfWwIxWEIzYE/zxNpA8NazGhp5Pe6zaUIzYwpzxNSqTHThmhpWjhpADKSrYlTh+hYf0NuYWrkf0wIznKgzPILbTEIAYlYPGKIrYl8YxN/AtwkmcE5PXKIrxhinNJgzTl8YpU/r0wIA7hiDbeiRjh8AcNuPghinsh8RTHih5AL4be6zThiDgAFq0Q6bTwgh+QFMgeiZjhphTHiRkQg4btLbTw8YjN6h+A1M0Q6bTN8dGwLh+hXAur5PRrqwVfqmqhTbTl/zclufgEuYYlgh+JgzxwurnEuYkwLh+hiRTe6zxN/VDKLh+hiRTe6zYNpwGKIZTHTzGNkrYN/QcwSw8wSAWlgPiESzYIaEDUIrYhTbTwS3kNSdbwpzYlk3YN6h+hiRTe6zYNpwGKIV8l8f7N8fjNSY0NSd4wIxbhiDTS7Z9Q64mh1M0AdWTe6zYNpwGKIVWUS3WhiDTS7Z0AiQ3QiR5Ai9kQilWAFR9Q645AFK4AihaA1qbHF9bA6ZmILhjhpEnl8f8l8dGwLh+hiZTtLbTEkYgwSwgKS5Yhin8KSm7wI5EtM><"
  }

  function configs:create_folder()
    files.create_folder("nl/Better chams")
  end
  configs:create_folder()

  function configs:create_config()
    local name = ctx.menu.configs:new_config_name()
    local configs_list = ctx.utils:get_configs_list()
    if ctx.utils:is_element_exist(configs_list, name) then
      common.add_notify("ERROR", string.format("Config %s already exist", name))
      return
    end

    if not files.write("nl/Better chams/"..name..".bc", "", false) then
      common.add_notify("ERROR", "Failed to create config")
      return
    end

    ctx.menu.configs:update(ctx.utils:get_configs_list())
  end

  function configs:parse_settings()
    local config = {
      user_materials = {},
      user_materials_data = {},
      user_materials_glow_data = {},
      menu_elements = {
        arms = {},
        sleeves = {},
        weapon = {},
        local_model = {},
        enemy_model = {},
        ally_model = {},
        chicken = {}                
      }
    }
    
    for _, name in pairs(ctx.material_data.user_materials) do
      if name == "CFG_DEFAULT" then
        common.add_notify("WARNING", "Material from default config wasn`t saved")
      end

      if name ~= "Default" and name ~= "CFG_DEFAULT" then
        table.insert(config.user_materials, name)
      end
    end

    for name, elements in pairs(ctx.material_data.user_materials_data) do
      if name ~= "Default" and name ~= "CFG_DEFAULT" then
        table.insert(config.user_materials_data, {
          name = name,
          shader = elements.shader,
          properties = elements.properties,
          color = {
            r = elements.color.r,
            g = elements.color.g,
            b = elements.color.b,
            a = elements.color.a
          }
        })
      end
    end

    for name, elements in pairs(ctx.material_data.user_materials_glow_data) do
      if name ~= nil then
        table.insert(config.user_materials_glow_data, {
          name = name,
          properties = elements.properties,
          color = {
            r = elements.color.r,
            g = elements.color.g,
            b = elements.color.b,
            a = elements.color.a
          },
          wireframe = elements.wireframe,
          brightness = elements.brightness,
          fill = elements.fill * 10
        })
      end
    end

    --ПОФИКСИТЬ ЭТУ СТРАШНУЮ ПОЕБЕНЬ
    local arms = ctx.menu.chams:arms()
    table.insert(config.menu_elements.arms, {
      state = arms.state:get(),
      original = arms.original:get(),
      material = arms.material:get()
    })

    local sleeves = ctx.menu.chams:sleeves()
    table.insert(config.menu_elements.sleeves, {
      state = sleeves.state:get(),
      original = sleeves.original:get(),
      material = sleeves.material:get()
    }) 

    local weapon = ctx.menu.chams:weapon()
    table.insert(config.menu_elements.weapon, {
      state = weapon.state:get(),
      original = weapon.original:get(),
      material = weapon.material:get()
    })

    local local_model = ctx.menu.chams:local_model()
    table.insert(config.menu_elements.local_model, {
      state = local_model.state:get(),
      original = local_model.original:get(),
      material = weapon.material:get()
    })

    local enemy_model = ctx.menu.chams:enemy_model()
    table.insert(config.menu_elements.enemy_model, {
      state = enemy_model.state:get(),
      original = enemy_model.original:get(),
      material = enemy_model.material:get()
    })

    local ally_model = ctx.menu.chams:ally_model()
    table.insert(config.menu_elements.ally_model, {
      state = ally_model.state:get(),
      original = ally_model.original:get(),
      material = ally_model.material:get()
    })

    local chicken = ctx.menu.chams:chicken()
    table.insert(config.menu_elements.chicken, {
      state = chicken.state:get(),
      original = chicken.original:get(),
      material = chicken.material:get()
    })

    return json.stringify(config)
  end

  function configs:save_config()
    local config = ctx.menu.configs:selected_config()
    if config == "Default" then
      common.add_notify("WARNING", "You aren`t allow to re-write default config")
      return
    end

    local config_data = files.read("nl/Better chams/"..config..".bc")
    if config_data == nil then
      common.add_notify("ERROR", "Cfg not exist")
      ctx.menu.configs:update(ctx.utils:get_configs_list())
      return
    end

    local json_data = configs:parse_settings()
    local json_encoded = ctx.utils:encode(json_data)
    
    if not files.write("nl/Better chams/"..config..".bc", json_encoded, false) then
      common.add_notify("ERROR", "Failed to save config")
    end

    common.add_notify("SUCCESS", string.format("Config %s successfully saved", config))
  end

  function configs:load_config(config)
    local config = files.read("nl/Better chams/"..config..".bc")
    local config_name = ctx.menu.configs:selected_config()
    if config_name == "Default" then config = configs.default end
    if config == nil then
      common.add_notify("ERROR", "Cfg not exist")
      ctx.menu.configs:update(ctx.utils:get_configs_list())
      return
    end

    if config == "" then
      common.add_notify("ERROR", "Config is empty")
      return
    end
    
    local json_decoded = ctx.utils:decode(config)
    local data = json.parse(json_decoded)

    ctx.material_data.user_materials = {"Default"}
    for i = 2, #ctx.material_data.user_materials_data do --Prepare config
      table.remove(ctx.material_data.user_materials_data, i)
      table.remove(ctx.material_data.user_materials_glow_data, i-1)
    end

    for _, element in pairs(data.user_materials) do
      table.insert(ctx.material_data.user_materials, element)
    end

    ctx.menu.editor:update()
    ctx.menu.chams:update()

    for _, element in pairs(data.user_materials_data) do
      ctx.material_data.user_materials_data[element.name] = {
        material = ctx.material_system:new_material(element.name, element.shader, element.properties, color(element.color.r, element.color.g, element.color.b, element.color.a)),
        shader = element.shader,
        properties = element.properties,
        color = color(element.color.r, element.color.g, element.color.b, element.color.a),
      }
    end

    for _, element in pairs(data.user_materials_glow_data) do
      ctx.material_data.user_materials_glow_data[element.name] = {
        material = ctx.material_system:new_glow(element.name, element.properties, color(element.color.r, element.color.g, element.color.b, element.color.a)),
        properties = element.properties,
        color = color(element.color.r, element.color.g, element.color.b, element.color.a),
        wireframe = element.wireframe,
        brightness = element.brightness,
        fill = element.fill * 10
      }
    end

    --Это выглядит очень страшно, нужно пофиксить как можно быстрее
    local arms_data = ctx.menu.chams:arms()
    for _, element in pairs(data.menu_elements.arms) do
      for _name, _element in pairs(element) do
        arms_data[_name]:set(_element)
      end
    end

    local sleeves_data = ctx.menu.chams:sleeves()
    for _, element in pairs(data.menu_elements.sleeves) do
      for _name, _element in pairs(element) do
        sleeves_data[_name]:set(_element)
      end
    end

    local weapon_data = ctx.menu.chams:weapon()
    for _, element in pairs(data.menu_elements.weapon) do
      for _name, _element in pairs(element) do
        weapon_data[_name]:set(_element)
      end
    end

    local local_model_data = ctx.menu.chams:local_model()
    for _, element in pairs(data.menu_elements.local_model) do
      for _name, _element in pairs(element) do
        local_model_data[_name]:set(_element)
      end
    end

    local enemy_model_data = ctx.menu.chams:enemy_model()
    for _, element in pairs(data.menu_elements.enemy_model) do
      for _name, _element in pairs(element) do
        enemy_model_data[_name]:set(_element)
      end
    end

    local ally_model_data = ctx.menu.chams:ally_model()
    for _, element in pairs(data.menu_elements.ally_model) do
      for _name, _element in pairs(element) do
        ally_model_data[_name]:set(_element)
      end
    end

    local chicken_data = ctx.menu.chams:chicken()
    for _, element in pairs(data.menu_elements.chicken) do
      for _name, _element in pairs(element) do
        chicken_data[_name]:set(_element)
      end
    end

    common.add_notify("SUCCESS", string.format("Config %s successfully loaded", config_name))
  end

  function configs:import_from_clipboard()
    local config = ctx.menu.configs:selected_config()
    if config == "Default" then
      common.add_notify("ERROR", "You are`nt allow to re-write default config")
      return
    end
    
    local config_data = files.read("nl/Better chams/"..config..".bc")
    if config_data == nil then
      common.add_notify("ERROR", "Cfg not exist")
      ctx.menu.configs:update(ctx.utils:get_configs_list())
      return
    end

    if not files.write("nl/Better chams/"..config..".bc", ctx.utils:get_clipboard_text(), false) then
      common.add_notify("ERROR", "Failed to import config")
    end

    common.add_notify("SUCCESS", string.format("Config %s successfully imported", config))
  end

  function configs:export_to_clipboard()
    local config = ctx.menu.configs:selected_config()
    if config == "Default" then
      common.add_notify("ERROR", "You aren`t allow to export default config")
      return
    end

    local config_data = files.read("nl/Better chams/"..config..".bc")
    if config_data == nil then
      common.add_notify("ERROR", "Cfg not exist")
      ctx.menu.configs:update(ctx.utils:get_configs_list())
      return
    end

    if config_data == "" then
      common.add_notify("ERROR", "Cfg is empty")
      return
    end

    ctx.utils:set_clipboard_text(config_data)

    common.add_notify("SUCCESS", string.format("Config %s successfully exported", config))
  end

  function configs:delete_config()
    local config = ctx.menu.configs:selected_config()
    if config == "Default" then
      common.add_notify("ERROR", "You are`nt allow to delete default config")
      return
    end

    local config_data = files.read("nl/Better chams/"..config..".bc")
    if config_data == nil then
      common.add_notify("ERROR", "Cfg not exist")
      ctx.menu.configs:update(ctx.utils:get_configs_list())
      return
    end

    ffi.C.DeleteFileA("nl/Better chams/"..config..".bc")
    ctx.menu.configs:update(ctx.utils:get_configs_list())

    common.add_notify("SUCCESS", string.format("Config %s successfully deleted", config))
  end

  ctx.menu.configs:on_save(function()
    configs:save_config()
  end)

  ctx.menu.configs:on_load(function()
    configs:load_config(ctx.menu.configs:selected_config())
  end)

  ctx.menu.configs:on_import_from_clipboard(function()
    configs:import_from_clipboard()
  end)

  ctx.menu.configs:on_export_to_clipboard(function()
    configs:export_to_clipboard()
  end)

  ctx.menu.configs:on_delete(function()
    configs:delete_config()
  end)

  ctx.menu.configs:on_create(function()
    configs:create_config()
  end)

  local public = {}
    function public:load_config(config)
      configs:load_config(config)
    end

  setmetatable(public, self)
  self.__index = self; return public
end
ctx.configs_system = configs_system:initialize()

events.draw_model:set(function(dme)
  local arms = ctx.menu.chams:arms()
  local sleeves = ctx.menu.chams:sleeves()
  local weapon = ctx.menu.chams:weapon()

  local localplayer = entity.get_local_player()
  local is_localplayer = localplayer ~= nil

  local local_model = ctx.menu.chams:local_model()
  local enemy_model = ctx.menu.chams:enemy_model()
  local ally_model = ctx.menu.chams:ally_model()

  local chicken = ctx.menu.chams:chicken()

  if arms.state:get() then
    if dme.name:find("arms") ~= nil and dme.name:find("sleeve") == nil then
      if arms.original:get() then
        dme:draw(nil)
      end

      dme:draw(ctx.utils:get_material(arms.material:get()))
      dme:draw(ctx.utils:get_glow(arms.material:get()))
      return false
    end
  end

  if sleeves.state:get() then
    if dme.name:find("sleeve") ~= nil then
      if sleeves.original:get() then
        dme:draw(nil)
      end

      dme:draw(ctx.utils:get_material(sleeves.material:get()))
      dme:draw(ctx.utils:get_glow(sleeves.material:get()))
      return false
    end
  end

  if weapon.state:get() then
    if is_localplayer then
      local weapon_entity = localplayer.m_hViewModel[0]
      if dme.entity == weapon_entity then
        if weapon.original:get() then
          dme:draw(nil)
        end

        dme:draw(ctx.utils:get_material(weapon.material:get()))
        dme:draw(ctx.utils:get_glow(weapon.material:get()))
        return false
      end
    end
  end

  if chicken.state:get() then
    if dme.name:find("chicken") ~= nil then
      if chicken.original:get() then
        dme:draw(nil)
      end

      dme:draw(ctx.utils:get_material(chicken.material:get()))
      dme:draw(ctx.utils:get_glow(chicken.material:get()))
      return false
    end
  end

  if local_model.state:get() then
    if is_localplayer then
      if dme.entity == localplayer  then
        if local_model.original:get() then
          dme:draw(nil)
        end

        dme:draw(ctx.utils:get_material(local_model.material:get()))
        dme:draw(ctx.utils:get_glow(local_model.material:get()))
        return false
      end
    end
  end

  if enemy_model.state:get() then
    if is_localplayer and dme.entity ~= nil then
      if dme.entity:is_player() and dme.entity.m_iTeamNum ~= localplayer.m_iTeamNum then
        if enemy_model.original:get() then
          dme:draw(nil)
        end

        dme:draw(ctx.utils:get_material(enemy_model.material:get()))
        dme:draw(ctx.utils:get_glow(enemy_model.material:get()))
        return false
      end
    end
  end

  if ally_model.state:get() then
    if is_localplayer and dme.entity ~= nil and dme.entity ~= localplayer then
      if dme.entity:is_player() and dme.entity.m_iTeamNum == localplayer.m_iTeamNum then
        if ally_model.original:get() then
          dme:draw(nil)
        end

        dme:draw(ctx.utils:get_material(ally_model.material:get()))
        dme:draw(ctx.utils:get_glow(ally_model.material:get()))
        return false
      end
    end
  end
end)