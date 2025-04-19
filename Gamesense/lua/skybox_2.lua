local type = type
local unpack = unpack
local table_insert = table.insert
local table_concat = table.concat
local client_color_log = client.color_log
local package_searchpath = package.searchpath
local materialsystem_find_materials = materialsystem.find_materials
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_local_player = entity.get_local_player
local client_delay_call = client.delay_call
local client_set_event_callback = client.set_event_callback
local client_unset_event_callback = client.unset_event_callback
local ui_set_callback = ui.set_callback
local ui_get = ui.get
local globals_realtime = globals.realtime
local tSkyboxList = {
  {
    sName = "Tibet",
    sPath = "cs_tibet",
    bThirdparty = false
  },
  {
    sName = "Baggage",
    sPath = "cs_baggage_skybox_",
    bThirdparty = false
  },
  {
    sName = "Monastery",
    sPath = "embassy",
    bThirdparty = false
  },
  {
    sName = "Italy",
    sPath = "italy",
    bThirdparty = false
  },
  {
    sName = "Aztec",
    sPath = "jungle",
    bThirdparty = false
  },
  {
    sName = "Vertigo",
    sPath = "office",
    bThirdparty = false
  },
  {
    sName = "Daylight",
    sPath = "sky_cs15_daylight01_hdr",
    bThirdparty = false
  },
  {
    sName = "Daylight (2)",
    sPath = "vertigoblue_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds",
    sPath = "sky_cs15_daylight02_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds (2)",
    sPath = "vertigo",
    bThirdparty = false
  },
  {
    sName = "Gray",
    sPath = "sky_day02_05_hdr",
    bThirdparty = false
  },
  {
    sName = "Clear",
    sPath = "nukeblank",
    bThirdparty = false
  },
  {
    sName = "Canals",
    sPath = "sky_venice",
    bThirdparty = false
  },
  {
    sName = "Cobblestone",
    sPath = "sky_cs15_daylight03_hdr",
    bThirdparty = false
  },
  {
    sName = "Assault",
    sPath = "sky_cs15_daylight04_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds (Dark)",
    sPath = "sky_csgo_cloudy01",
    bThirdparty = false
  },
  {
    sName = "Night",
    sPath = "sky_csgo_night02",
    bThirdparty = false
  },
  {
    sName = "Night (2)",
    sPath = "sky_csgo_night02b",
    bThirdparty = false
  },
  {
    sName = "Night (Flat)",
    sPath = "sky_csgo_night_flat",
    bThirdparty = false
  },
  {
    sName = "Dusty",
    sPath = "sky_dust",
    bThirdparty = false
  },
  {
    sName = "Rainy",
    sPath = "vietnam",
    bThirdparty = false
  },
  {
    sName = "amethyst",
    sPath = "amethyst",
    bThirdparty = true
  },
  {
    sName = "clear_night_sky",
    sPath = "clear_night_sky",
    bThirdparty = true
  },
  {
    sName = "cloudynight",
    sPath = "cloudynight",
    bThirdparty = true
  },
  {
    sName = "dreamyocean",
    sPath = "dreamyocean",
    bThirdparty = true
  },
  {
    sName = "grimmnight",
    sPath = "grimmnight",
    bThirdparty = true
  },
  {
    sName = "lakesky",
    sPath = "lakesky",
    bThirdparty = true
  },
  {
    sName = "mars",
    sPath = "mars",
    bThirdparty = true
  },
  {
    sName = "mpa119",
    sPath = "mpa119",
    bThirdparty = true
  },
  {
    sName = "mr1",
    sPath = "mr1",
    bThirdparty = true
  },
  {
    sName = "mr_01",
    sPath = "mr_01",
    bThirdparty = true
  },
  {
    sName = "mr_02",
    sPath = "mr_02",
    bThirdparty = true
  },
  {
    sName = "mr_03",
    sPath = "mr_03",
    bThirdparty = true
  },
  {
    sName = "mr_04",
    sPath = "mr_04",
    bThirdparty = true
  },
  {
    sName = "mr_05",
    sPath = "mr_05",
    bThirdparty = true
  },
  {
    sName = "mr_06",
    sPath = "mr_06",
    bThirdparty = true
  },
  {
    sName = "mr_07",
    sPath = "mr_07",
    bThirdparty = true
  },
  {
    sName = "mr_08",
    sPath = "mr_08",
    bThirdparty = true
  },
  {
    sName = "mr_10",
    sPath = "mr_10",
    bThirdparty = true
  },
  {
    sName = "mr_12",
    sPath = "mr_12",
    bThirdparty = true
  },
  {
    sName = "mr_13",
    sPath = "mr_13",
    bThirdparty = true
  },
  {
    sName = "mr_15",
    sPath = "mr_15",
    bThirdparty = true
  },
  {
    sName = "mr_16",
    sPath = "mr_16",
    bThirdparty = true
  },
  {
    sName = "mr_ice",
    sPath = "mr_ice",
    bThirdparty = true
  },
  {
    sName = "mr_moon",
    sPath = "mr_moon",
    bThirdparty = true
  },
  {
    sName = "mr_night_",
    sPath = "mr_night_",
    bThirdparty = true
  },
  {
    sName = "mr_space",
    sPath = "mr_space",
    bThirdparty = true
  },
  {
    sName = "otherworld",
    sPath = "otherworld",
    bThirdparty = true
  },
  {
    sName = "pandora_b",
    sPath = "pandora_b",
    bThirdparty = true
  },
  {
    sName = "pandora_f",
    sPath = "pandora_f",
    bThirdparty = true
  },
  {
    sName = "ptr_amethyst",
    sPath = "ptr_amethyst",
    bThirdparty = true
  },
  {
    sName = "ptr_clear_night_sky",
    sPath = "ptr_clear_night_sky",
    bThirdparty = true
  },
  {
    sName = "ptr_cloudynight",
    sPath = "ptr_cloudynight",
    bThirdparty = true
  },
  {
    sName = "ptr_dreamyocean",
    sPath = "ptr_dreamyocean",
    bThirdparty = true
  },
  {
    sName = "ptr_grimmnight",
    sPath = "ptr_grimmnight",
    bThirdparty = true
  },
  {
    sName = "ptr_otherworld",
    sPath = "ptr_otherworld",
    bThirdparty = true
  },
  {
    sName = "ptr_sky051",
    sPath = "ptr_sky051",
    bThirdparty = true
  },
  {
    sName = "ptr_sky081",
    sPath = "ptr_sky081",
    bThirdparty = true
  },
  {
    sName = "ptr_sky091",
    sPath = "ptr_sky091",
    bThirdparty = true
  },
  {
    sName = "ptr_sky561",
    sPath = "ptr_sky561",
    bThirdparty = true
  },
  {
    sName = "Real_SkySunset",
    sPath = "Real_SkySunset",
    bThirdparty = true
  },
  {
    sName = "red_planet",
    sPath = "red_planet",
    bThirdparty = true
  },
  {
    sName = "retrosun",
    sPath = "retrosun",
    bThirdparty = true
  },
  {
    sName = "sky002",
    sPath = "sky002",
    bThirdparty = true
  },
  {
    sName = "sky003",
    sPath = "sky003",
    bThirdparty = true
  },
  {
    sName = "sky004",
    sPath = "sky004",
    bThirdparty = true
  },
  {
    sName = "sky051",
    sPath = "sky051",
    bThirdparty = true
  },
  {
    sName = "sky081",
    sPath = "sky081",
    bThirdparty = true
  },
  {
    sName = "sky091",
    sPath = "sky091",
    bThirdparty = true
  },
  {
    sName = "sky100",
    sPath = "sky100",
    bThirdparty = true
  },
  {
    sName = "sky101",
    sPath = "sky101",
    bThirdparty = true
  },
  {
    sName = "sky103",
    sPath = "sky103",
    bThirdparty = true
  },
  {
    sName = "sky104",
    sPath = "sky104",
    bThirdparty = true
  },
  {
    sName = "sky105",
    sPath = "sky105",
    bThirdparty = true
  },
  {
    sName = "sky106",
    sPath = "sky106",
    bThirdparty = true
  },
  {
    sName = "sky107",
    sPath = "sky107",
    bThirdparty = true
  },
  {
    sName = "sky108",
    sPath = "sky108",
    bThirdparty = true
  },
  {
    sName = "sky109",
    sPath = "sky109",
    bThirdparty = true
  },
  {
    sName = "sky110",
    sPath = "sky110",
    bThirdparty = true
  },
  {
    sName = "sky111",
    sPath = "sky111",
    bThirdparty = true
  },
  {
    sName = "sky112",
    sPath = "sky112",
    bThirdparty = true
  },
  {
    sName = "sky113",
    sPath = "sky113",
    bThirdparty = true
  },
  {
    sName = "sky114",
    sPath = "sky114",
    bThirdparty = true
  },
  {
    sName = "sky115",
    sPath = "sky115",
    bThirdparty = true
  },
  {
    sName = "sky116",
    sPath = "sky116",
    bThirdparty = true
  },
  {
    sName = "sky117",
    sPath = "sky117",
    bThirdparty = true
  },
  {
    sName = "sky118",
    sPath = "sky118",
    bThirdparty = true
  },
  {
    sName = "sky119",
    sPath = "sky119",
    bThirdparty = true
  },
  {
    sName = "sky121",
    sPath = "sky121",
    bThirdparty = true
  },
  {
    sName = "sky122",
    sPath = "sky122",
    bThirdparty = true
  },
  {
    sName = "sky123",
    sPath = "sky123",
    bThirdparty = true
  },
  {
    sName = "sky124",
    sPath = "sky124",
    bThirdparty = true
  },
  {
    sName = "sky125",
    sPath = "sky125",
    bThirdparty = true
  },
  {
    sName = "sky126",
    sPath = "sky126",
    bThirdparty = true
  },
  {
    sName = "sky127",
    sPath = "sky127",
    bThirdparty = true
  },
  {
    sName = "sky128",
    sPath = "sky128",
    bThirdparty = true
  },
  {
    sName = "sky129c",
    sPath = "sky129c",
    bThirdparty = true
  },
  {
    sName = "sky129",
    sPath = "sky129",
    bThirdparty = true
  },
  {
    sName = "sky130",
    sPath = "sky130",
    bThirdparty = true
  },
  {
    sName = "sky131",
    sPath = "sky131",
    bThirdparty = true
  },
  {
    sName = "sky132",
    sPath = "sky132",
    bThirdparty = true
  },
  {
    sName = "sky133",
    sPath = "sky133",
    bThirdparty = true
  },
  {
    sName = "sky134",
    sPath = "sky134",
    bThirdparty = true
  },
  {
    sName = "sky135",
    sPath = "sky135",
    bThirdparty = true
  },
  {
    sName = "sky136",
    sPath = "sky136",
    bThirdparty = true
  },
  {
    sName = "sky137",
    sPath = "sky137",
    bThirdparty = true
  },
  {
    sName = "sky138a",
    sPath = "sky138a",
    bThirdparty = true
  },
  {
    sName = "sky138",
    sPath = "sky138",
    bThirdparty = true
  },
  {
    sName = "sky139a",
    sPath = "sky139a",
    bThirdparty = true
  },
  {
    sName = "sky139",
    sPath = "sky139",
    bThirdparty = true
  },
  {
    sName = "sky140",
    sPath = "sky140",
    bThirdparty = true
  },
  {
    sName = "sky141",
    sPath = "sky141",
    bThirdparty = true
  },
  {
    sName = "sky142",
    sPath = "sky142",
    bThirdparty = true
  },
  {
    sName = "sky143",
    sPath = "sky143",
    bThirdparty = true
  },
  {
    sName = "sky144",
    sPath = "sky144",
    bThirdparty = true
  },
  {
    sName = "sky145",
    sPath = "sky145",
    bThirdparty = true
  },
  {
    sName = "sky147",
    sPath = "sky147",
    bThirdparty = true
  },
  {
    sName = "sky148",
    sPath = "sky148",
    bThirdparty = true
  },
  {
    sName = "sky149",
    sPath = "sky149",
    bThirdparty = true
  },
  {
    sName = "sky150day",
    sPath = "sky150day",
    bThirdparty = true
  },
  {
    sName = "sky150",
    sPath = "sky150",
    bThirdparty = true
  },
  {
    sName = "sky151",
    sPath = "sky151",
    bThirdparty = true
  },
  {
    sName = "sky152",
    sPath = "sky152",
    bThirdparty = true
  },
  {
    sName = "sky153",
    sPath = "sky153",
    bThirdparty = true
  },
  {
    sName = "sky154",
    sPath = "sky154",
    bThirdparty = true
  },
  {
    sName = "sky155",
    sPath = "sky155",
    bThirdparty = true
  },
  {
    sName = "sky156",
    sPath = "sky156",
    bThirdparty = true
  },
  {
    sName = "sky157",
    sPath = "sky157",
    bThirdparty = true
  },
  {
    sName = "sky158",
    sPath = "sky158",
    bThirdparty = true
  },
  {
    sName = "sky159",
    sPath = "sky159",
    bThirdparty = true
  },
  {
    sName = "sky161s",
    sPath = "sky161s",
    bThirdparty = true
  },
  {
    sName = "sky161",
    sPath = "sky161",
    bThirdparty = true
  },
  {
    sName = "sky162",
    sPath = "sky162",
    bThirdparty = true
  },
  {
    sName = "sky163",
    sPath = "sky163",
    bThirdparty = true
  },
  {
    sName = "sky164",
    sPath = "sky164",
    bThirdparty = true
  },
  {
    sName = "sky165",
    sPath = "sky165",
    bThirdparty = true
  },
  {
    sName = "sky166",
    sPath = "sky166",
    bThirdparty = true
  },
  {
    sName = "sky167",
    sPath = "sky167",
    bThirdparty = true
  },
  {
    sName = "sky168",
    sPath = "sky168",
    bThirdparty = true
  },
  {
    sName = "sky169",
    sPath = "sky169",
    bThirdparty = true
  },
  {
    sName = "sky170",
    sPath = "sky170",
    bThirdparty = true
  },
  {
    sName = "sky171",
    sPath = "sky171",
    bThirdparty = true
  },
  {
    sName = "sky172",
    sPath = "sky172",
    bThirdparty = true
  },
  {
    sName = "sky173",
    sPath = "sky173",
    bThirdparty = true
  },
  {
    sName = "sky174",
    sPath = "sky174",
    bThirdparty = true
  },
  {
    sName = "sky175",
    sPath = "sky175",
    bThirdparty = true
  },
  {
    sName = "sky176",
    sPath = "sky176",
    bThirdparty = true
  },
  {
    sName = "sky177",
    sPath = "sky177",
    bThirdparty = true
  },
  {
    sName = "sky178",
    sPath = "sky178",
    bThirdparty = true
  },
  {
    sName = "sky179",
    sPath = "sky179",
    bThirdparty = true
  },
  {
    sName = "sky180",
    sPath = "sky180",
    bThirdparty = true
  },
  {
    sName = "sky181",
    sPath = "sky181",
    bThirdparty = true
  },
  {
    sName = "sky182",
    sPath = "sky182",
    bThirdparty = true
  },
  {
    sName = "sky183",
    sPath = "sky183",
    bThirdparty = true
  },
  {
    sName = "sky184",
    sPath = "sky184",
    bThirdparty = true
  },
  {
    sName = "sky185",
    sPath = "sky185",
    bThirdparty = true
  },
  {
    sName = "sky186",
    sPath = "sky186",
    bThirdparty = true
  },
  {
    sName = "sky187",
    sPath = "sky187",
    bThirdparty = true
  },
  {
    sName = "sky190",
    sPath = "sky190",
    bThirdparty = true
  },
  {
    sName = "sky191",
    sPath = "sky191",
    bThirdparty = true
  },
  {
    sName = "sky192",
    sPath = "sky192",
    bThirdparty = true
  },
  {
    sName = "sky1",
    sPath = "sky1",
    bThirdparty = true
  },
  {
    sName = "sky200",
    sPath = "sky200",
    bThirdparty = true
  },
  {
    sName = "sky26_HDR",
    sPath = "sky26_HDR",
    bThirdparty = true
  },
  {
    sName = "sky28_HDR",
    sPath = "sky28_HDR",
    bThirdparty = true
  },
  {
    sName = "sky302",
    sPath = "sky302",
    bThirdparty = true
  },
  {
    sName = "sky303",
    sPath = "sky303",
    bThirdparty = true
  },
  {
    sName = "sky561",
    sPath = "sky561",
    bThirdparty = true
  },
  {
    sName = "sky77",
    sPath = "sky77",
    bThirdparty = true
  },
  {
    sName = "sky78",
    sPath = "sky78",
    bThirdparty = true
  },
  {
    sName = "sky_001",
    sPath = "sky_001",
    bThirdparty = true
  },
  {
    sName = "sky_79",
    sPath = "sky_79",
    bThirdparty = true
  },
  {
    sName = "sky_descent",
    sPath = "sky_descent",
    bThirdparty = true
  },
  {
    sName = "sky_l",
    sPath = "sky_l",
    bThirdparty = true
  },
  {
    sName = "sky_moon",
    sPath = "sky_moon",
    bThirdparty = true
  },
  {
    sName = "sky_z",
    sPath = "sky_z",
    bThirdparty = true
  },
  {
    sName = "space_10",
    sPath = "space_10",
    bThirdparty = true
  },
  {
    sName = "space_11",
    sPath = "space_11",
    bThirdparty = true
  },
  {
    sName = "space_12",
    sPath = "space_12",
    bThirdparty = true
  },
  {
    sName = "space_13",
    sPath = "space_13",
    bThirdparty = true
  },
  {
    sName = "space_14",
    sPath = "space_14",
    bThirdparty = true
  },
  {
    sName = "space_15",
    sPath = "space_15",
    bThirdparty = true
  },
  {
    sName = "space_16",
    sPath = "space_16",
    bThirdparty = true
  },
  {
    sName = "space_17",
    sPath = "space_17",
    bThirdparty = true
  },
  {
    sName = "space_18",
    sPath = "space_18",
    bThirdparty = true
  },
  {
    sName = "space_19",
    sPath = "space_19",
    bThirdparty = true
  },
  {
    sName = "space_1",
    sPath = "space_1",
    bThirdparty = true
  },
  {
    sName = "space_20",
    sPath = "space_20",
    bThirdparty = true
  },
  {
    sName = "space_22",
    sPath = "space_22",
    bThirdparty = true
  },
  {
    sName = "space_23",
    sPath = "space_23",
    bThirdparty = true
  },
  {
    sName = "space_2",
    sPath = "space_2",
    bThirdparty = true
  },
  {
    sName = "space_3",
    sPath = "space_3",
    bThirdparty = true
  },
  {
    sName = "space_4",
    sPath = "space_4",
    bThirdparty = true
  },
  {
    sName = "space_5",
    sPath = "space_5",
    bThirdparty = true
  },
  {
    sName = "space_6",
    sPath = "space_6",
    bThirdparty = true
  },
  {
    sName = "space_7",
    sPath = "space_7",
    bThirdparty = true
  },
  {
    sName = "space_8",
    sPath = "space_8",
    bThirdparty = true
  },
  {
    sName = "space_9",
    sPath = "space_9",
    bThirdparty = true
  },
  {
    sName = "stormymountain_hdr",
    sPath = "stormymountain_hdr",
    bThirdparty = true
  },
  {
    sName = "sunsetmountain",
    sPath = "sunsetmountain",
    bThirdparty = true
  },
  {
    sName = "WhiteDwarf",
    sPath = "WhiteDwarf",
    bThirdparty = true
  }
}
local multicolor_log
multicolor_log = function(...)
  local args = {
    ...
  }
  local len = #args
  for i = 1, len do
    local arg = args[i]
    local r, g, b = unpack(arg)
    local msg = { }
    if #arg == 3 then
      table_insert(msg, " ")
    else
      for i = 4, #arg do
        table_insert(msg, arg[i])
      end
    end
    msg = table_concat(msg)
    if len > i then
      msg = msg .. "\0"
    end
    client_color_log(r, g, b, msg)
  end
end
do
  local _accum_0 = { }
  local _len_0 = 1
  for _index_0 = 1, #tSkyboxList do
    local tSkyboxData = tSkyboxList[_index_0]
    if (function()
      if tSkyboxData.bThirdparty then
        local sPath = "./csgo/materials/skybox/" .. tostring(tSkyboxData.sPath) .. "up.vmt"
        local bIsFileExists = package_searchpath("", sPath) == sPath
        if bIsFileExists then
          multicolor_log({
            127,
            255,
            0,
            " + "
          }, {
            255,
            255,
            255,
            "Found ["
          }, {
            0,
            255,
            255,
            "materials\\skybox\\" .. tostring(tSkyboxData.sPath) .. "up.vmt"
          }, {
            255,
            255,
            255,
            "]"
          })
        else
          multicolor_log({
            255,
            127,
            0,
            " - "
          }, {
            255,
            255,
            255,
            "Not Found ["
          }, {
            0,
            255,
            255,
            "materials\\skybox\\" .. tostring(tSkyboxData.sPath) .. "up.vmt"
          }, {
            255,
            255,
            255,
            "] ("
          }, {
            0,
            255,
            255,
            "No such file!"
          }, {
            255,
            255,
            255,
            ")"
          })
        end
        return bIsFileExists
      else
        return true
      end
    end)() then
      _accum_0[_len_0] = tSkyboxData
      _len_0 = _len_0 + 1
    end
  end
  tSkyboxList = _accum_0
end
table.sort(tSkyboxList, function(tA, tB)
  return tA.sName < tB.sName
end)
local tScriptData = {
  tMenuReferences = {
    nPadding = ui.new_label("LUA", "A", "\nSet Skybox"),
    nMasterSwitch = ui.new_checkbox("LUA", "A", "Set Skybox"),
    nSkyboxColor = ui.new_color_picker("LUA", "A", "Color\nSet Skybox", 255, 255, 255, 255),
    nSkyboxList = ui.new_listbox("LUA", "A", "List\nSet Skybox", (function()
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #tSkyboxList do
        local tSkyboxData = tSkyboxList[_index_0]
        _accum_0[_len_0] = tSkyboxData.sName
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)()),
    nSkyboxColorChangeDelay = ui.new_slider("LUA", "A", "Color Change Delay\nSet Skybox", 1, 5, 1, true, "s.", 1),
    nSkyboxCheckInterval = ui.new_slider("LUA", "A", "Check Inteval\nSet Skybox", 1, 5, 1, true, "s.", 1),
    nHide3dSkybox = ui.new_checkbox("LUA", "A", "Hide 3D Skybox\nSet Skybox")
  },
  tSkyboxIndexToPath = (function()
    local _tbl_0 = { }
    for nIterator1, tSkyboxData in ipairs(tSkyboxList) do
      _tbl_0[nIterator1] = tSkyboxData.sPath
    end
    return _tbl_0
  end)(),
  sSkyboxNameCustom = false,
  nSkyboxCheckTimestamp = 0
}
local tGameData = {
  udCvar_sv_skyname = cvar.sv_skyname,
  udCvar_r_3dsky = cvar.r_3dsky,
  sSkyboxNameDefault = false
}
local tScriptFunctions = {
  SetSkyboxName = function(bSetDefaultSkybox)
    if bSetDefaultSkybox and tGameData.sSkyboxNameDefault then
      if tGameData.udCvar_sv_skyname then
        return tGameData.udCvar_sv_skyname:set_string(tGameData.sSkyboxNameDefault)
      end
    else
      if tGameData.udCvar_sv_skyname then
        tScriptData.sSkyboxNameCustom = tScriptData.tSkyboxIndexToPath[ui_get(tScriptData.tMenuReferences.nSkyboxList) + 1]
        if tScriptData.sSkyboxNameCustom then
          return tGameData.udCvar_sv_skyname:set_string(tScriptData.sSkyboxNameCustom)
        end
      end
    end
  end,
  SetSkyboxColor = function(nR, nG, nB, nA)
    local tCurrentSkyboxMaterials = materialsystem_find_materials("skybox/" .. tostring(tScriptData.sSkyboxNameCustom))
    if tCurrentSkyboxMaterials then
      return client_delay_call(#tCurrentSkyboxMaterials == 0 and ui_get(tScriptData.tMenuReferences.nSkyboxColorChangeDelay) or 0, (function()
        local tMaterials = materialsystem_find_materials("skybox/")
        if tMaterials then
          for _index_0 = 1, #tMaterials do
            local udMaterial = tMaterials[_index_0]
            udMaterial:color_modulate(nR, nG, nB)
            udMaterial:alpha_modulate(nA)
          end
        end
      end))
    end
  end,
  CheckSkyboxName = function()
    local sSkyboxNameCurrent = tGameData.udCvar_sv_skyname:get_string()
    if tScriptData.sSkyboxNameCustom and sSkyboxNameCurrent ~= tScriptData.sSkyboxNameCustom then
      return tGameData.udCvar_sv_skyname:set_string(tScriptData.sSkyboxNameCustom)
    end
  end
}
local tScriptEventCallbacks = {
  OnPlayerConnectFull = function(e)
    if client_userid_to_entindex(e.userid) == entity_get_local_player() then
      tGameData.sSkyboxNameDefault = tGameData.udCvar_sv_skyname:get_string()
    end
    if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
      tScriptFunctions.SetSkyboxName()
      local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
      return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
    end
  end,
  OnPostConfigLoad = function()
    if entity_get_local_player() then
      tScriptFunctions.SetSkyboxName()
      local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
      return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
    end
  end,
  OnPaint = function()
    local nCurrentTimestamp = globals_realtime()
    if nCurrentTimestamp - tScriptData.nSkyboxCheckTimestamp > ui_get(tScriptData.tMenuReferences.nSkyboxCheckInterval) then
      tScriptData.nSkyboxCheckTimestamp = nCurrentTimestamp
      if entity_get_local_player() then
        tScriptFunctions.SetSkyboxName()
        local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
        return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
      end
    end
  end
}
ui_set_callback(tScriptData.tMenuReferences.nMasterSwitch, function(nUiElementReference)
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    client_set_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_set_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_set_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName()
    local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  else
    client_unset_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_unset_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_unset_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName(true)
    return tScriptFunctions.SetSkyboxColor(255, 255, 255, 255)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nSkyboxColor, function(nUiElementReference)
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    local nR, nG, nB, nA = ui_get(nUiElementReference)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nSkyboxList, function(nUiElementReference)
  tScriptData.sSkyboxNameCustom = tScriptData.tSkyboxIndexToPath[ui_get(tScriptData.tMenuReferences.nSkyboxList) + 1]
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    tScriptFunctions.SetSkyboxName()
    local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nHide3dSkybox, function(nUiElementReference)
  if ui_get(nUiElementReference) then
    return tGameData.udCvar_r_3dsky:set_raw_int(0)
  else
    return tGameData.udCvar_r_3dsky:set_raw_int(1)
  end
end)
client_set_event_callback("shutdown", function()
  client_unset_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
  client_unset_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
  client_unset_event_callback("paint", tScriptEventCallbacks.OnPaint)
  tScriptFunctions.SetSkyboxName(true)
  return tScriptFunctions.SetSkyboxColor(255, 255, 255, 255)
end)
if tGameData.udCvar_sv_skyname then
  tGameData.sSkyboxNameDefault = tGameData.udCvar_sv_skyname:get_string()
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    client_set_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_set_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_set_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName()
    local nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end