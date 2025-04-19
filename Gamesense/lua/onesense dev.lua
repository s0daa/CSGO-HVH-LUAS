local v0 = error
local v1 = setmetatable
local v2 = ipairs
local v3 = pairs
local v4 = next
local v5 = printf
local v6 = rawequal
local v7 = rawset
local v8 = rawlen
local v9 = readfile
local v10 = writefile
local v11 = require
local v12 = tonumber
local v13 = toticks
local v14 = type
local v15 = unpack
local v16 = pcall
local function v17(v54)
    local v55 = {}
    for v706, v707 in v4, v54 do
        v55[v706] = v707
    end
    return v55
end
local v18 = v17(table)
local v19 = v17(math)
local v20 = v17(string)
local v21 = v17(ui)
local v22 = v17(client)
local v23 = v17(database)
local v24 = v17(entity)
local v25 = v17(v11("ffi"))
local v26 = v17(globals)
local v27 = v17(panorama)
local v28 = v17(renderer)
local v29 = v17(bit)
local function v30(v56)
    if v56 then
        return v11(v56)
    else
        v0("nope" .. v56)
    end
end
local v31 = v30("vector")
local v32 = v30("gamesense/pui")
local v33 = v30("gamesense/base64")
local v34 = v30("gamesense/clipboard")
local v35 = v30("gamesense/entity")
local v36 = v30("gamesense/http")
local v37 = v27.open()
local v38 = {
    name = v37.MyPersonaAPI.GetName(),
    build = "dev",
    vers = "1.7",
    accent = {r = 0, g = 0, b = 0, a = 255},
    offset = 0,
    new_style = false
}
local v39, v40 = v22.screen_size()
local v41 = function(v57, v58, v59)
    return (function()
        local v709 = {}
        local v710, v711, v712, v713, v714, v715, v716, v717, v718, v719, v720, v721, v722, v723
        local v724 = {
            __index = {
                drag = function(v885, ...)
                    local v886, v887 = v885:get()
                    local v888, v889 = v709.drag(v886, v887, ...)
                    if ((v886 ~= v888) or (v887 ~= v889)) then
                        v885:set(v888, v889)
                    end
                    return v888, v889
                end,
                set = function(v890, v891, v892)
                    local v893, v894 = v22.screen_size()
                    v21.set(v890.x_reference, (v891 / v893) * v890.res)
                    v21.set(v890.y_reference, (v892 / v894) * v890.res)
                end,
                get = function(v895, v896, v897)
                    local v898, v899 = v22.screen_size()
                    return ((v21.get(v895.x_reference) / v895.res) * v898) + (v896 or 0), ((v21.get(v895.y_reference) /
                        v895.res) *
                        v899) +
                        (v897 or 0)
                end
            }
        }
        v709.new = function(v900, v901, v902, v903)
            v903 = v903 or 10000
            local v904, v905 = v22.screen_size()
            local v906 = v21.new_slider("misc", "settings", "one::x:" .. v900, 0, v903, (v901 / v904) * v903)
            local v907 = v21.new_slider("misc", "settings", "one::y:" .. v900, 0, v903, (v902 / v905) * v903)
            v21.set_visible(v906, false)
            v21.set_visible(v907, false)
            return v1({name = v900, x_reference = v906, y_reference = v907, res = v903}, v724)
        end
        v709.drag = function(v908, v909, v910, v911, v912, v913, v914)
            if (v26.framecount() ~= v710) then
                v711 = v21.is_menu_open()
                v714, v715 = v712, v713
                v712, v713 = v21.mouse_position()
                v717 = v716
                v716 = v22.key_state(1) == true
                v721 = v720
                v720 = {}
                v723 = v722
                v722 = false
                v718, v719 = v22.screen_size()
            end
            if (v711 and (v717 ~= nil)) then
                if
                    ((not v717 or v723) and v716 and (v714 > v908) and (v715 > v909) and (v714 < (v908 + v910)) and
                        (v715 < (v909 + v911)))
                 then
                    v28.rectangle(v908, v909, v910, v911, 255, 255, 255, 5)
                    v722 = true
                    v908, v909 = (v908 + v712) - v714, (v909 + v713) - v715
                    if not v913 then
                        v908 = v19.max(0, v19.min(v718 - v910, v908))
                        v909 = v19.max(0, v19.min(v719 - v911, v909))
                    end
                end
            end
            v18.insert(v720, {v908, v909, v910, v911})
            return v908, v909, v910, v911
        end
        return v709
    end)().new(v57, v58, v59)
end
local v42 =
    v28.load_png(
    "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0B\x00\x00\x00\x0B\x08\x06\x00\x00\x00\xA9\xAC\x77\x26\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x01\x33\x49\x44\x41\x54\x28\x53\x35\x91\xBD\x4A\x03\x51\x10\x85\xEF\x4F\x88\x91\x25\x60\x14\x35\x85\x58\xA9\x28\xDA\x08\xC1\x22\x0A\x62\x97\x07\x08\xA9\xD5\xD6\x07\xF0\x21\xB4\xB4\xD3\xD2\x32\xA6\x48\x61\x61\x23\x69\x2C\x14\x41\xB0\x51\x0B\x21\xC1\x42\xB0\x10\x7F\xD6\x80\xEE\xDD\xF5\x3B\x62\x06\x3E\xCE\xCC\x99\xB9\x73\xEF\x26\x36\x49\x92\x21\xE7\xDC\xBA\xB5\x76\x33\xCB\xB2\x37\xB8\x4A\xD3\xB4\x4D\xED\xF1\x47\x8C\x31\x29\x14\xE0\xD1\xD0\xA8\x31\x70\x8D\x9E\x42\x39\x8E\x63\x4B\x43\xFE\x22\xFE\x19\x5C\xC2\x7E\x08\x61\xD4\xB1\xA1\x4E\x6F\x1E\xDA\x6C\x7A\x8E\xA2\x28\xA3\xE1\x18\xC8\xE1\x8D\x43\xE5\x5F\xFB\x32\x6B\x24\x79\x0E\x7D\xA1\x83\x28\x52\xAF\xA1\x31\x9C\xC3\x24\xF5\x94\x36\x97\x28\x3C\x87\x56\x51\xC3\x37\x38\x44\x79\x09\x6F\x17\xB6\x78\x52\x93\x7A\x45\x6F\x7B\xC0\x50\xF4\xB8\x7E\x8E\xE1\x3C\x5A\xC1\x9F\xD0\x73\xB4\x80\x7C\x09\x8E\x95\x1C\x30\xF8\x23\xC8\x4F\x60\x81\x03\x7F\x1F\xA9\xA0\x2E\xD0\x6B\xC0\xAD\x8A\x2A\xC9\x1D\x28\xFA\xD0\xC1\xDB\x81\x65\x98\x85\x6D\xBC\x0B\xB8\x37\x5C\x35\x8C\x71\x48\xF1\x0D\x83\x08\xF0\x09\xEF\xA0\x05\x1F\xCC\xEC\xE9\x4D\xD3\xF0\x8A\x71\x84\x76\x75\x33\xC8\x8F\xA0\x08\x01\x3A\xD0\xD2\x3F\x38\x43\x92\x63\xF8\xC9\x7B\x5F\x25\xAF\xF3\x0B\x6D\xA0\x63\x78\x2F\x68\x93\xBA\x15\x42\xB8\xF9\x05\xD4\x19\x01\x8D\xAD\x75\xE9\x3B\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
    11,
    11
)
local v43 = {clamp = function(v60, v61, v62)
        assert(v60 and v61 and v62, "")
        if (v61 > v62) then
            v61, v62 = v62, v61
        end
        return v19.max(v61, v19.min(v62, v60))
    end, rect_v = function(v63, v64, v65, v66, v67, v68, v69, v70)
        local v71, v72, v73, v74 = v15(v67)
        local v75, v76, v77, v78
        v28.circle(v63 + v68, v64 + v68, v71, v72, v73, v74, v68, 180, 0.25)
        v28.rectangle(v63 + v68, v64, (v65 - v68) - v68, v68, v71, v72, v73, v74)
        v28.circle((v63 + v65) - v68, v64 + v68, v71, v72, v73, v74, v68, 90, 0.25)
        v28.rectangle(v63, v64 + v68, v65, v66 - v68, v71, v72, v73, v74)
        if v69 then
            v75, v76, v77, v78 = v15(v69)
            v28.rectangle(v63, v64 + v66, v65, v66 - (v66 + (v70 or 2)), v75, v76, v77, v78)
        end
    end}
local v44 =
    (function()
    local v79 = v31
    local v80 = function(v727, v728, v729)
        return ((v728 - v727) * v729) + v727
    end
    local v81 = function(v730, v731, v732)
        v732 = v43.clamp(v26.absoluteframetime() * ((v732 + 0.02) or 0.005) * 175, 0.01, 1)
        local v733 = v80(v730, v731, v732)
        return v733
    end
    local v82 = function(v734, ...)
        local v735 = {...}
        local v735 = v18.concat(v735, "")
        return v79(v28.measure_text(v734, v735))
    end
    local v83 = {notifications = {bottom = {}}, max = {bottom = 6}}
    v83.__index = v83
    v83.create_new = function(...)
        v18.insert(
            v83.notifications.bottom,
            {
                started = false,
                instance = v1(
                    {
                        active = false,
                        timeout = 5,
                        color = {r = 0, g = 0, b = 0, a = 0},
                        x = v39 / 2,
                        y = v40,
                        text = ...
                    },
                    v83
                )
            }
        )
    end
    v83.handler = function(v736)
        local v737 = 0
        local v738 = 0
        for v915, v916 in v3(v83.notifications.bottom) do
            if (not v916.instance.active and v916.started) then
                v18.remove(v83.notifications.bottom, v915)
            end
        end
        for v917 = 1, #v83.notifications.bottom do
            if v83.notifications.bottom[v917].instance.active then
                v738 = v738 + 1
            end
        end
        for v918, v919 in v3(v83.notifications.bottom) do
            if (v918 > v83.max.bottom) then
                return
            end
            if v919.instance.active then
                v919.instance:render_bottom(v737, v738)
                v737 = v737 + 1
            end
            if not v919.started then
                v919.instance:start()
                v919.started = true
            end
        end
    end
    v83.start = function(v739)
        v739.active = true
        v739.delay = v26.realtime() + v739.timeout
    end
    v83.get_text = function(v742)
        local v743 = ""
        for v920, v920 in v3(v742.text) do
            local v921 = v82("", v920[1])
            local v921, v922, v923 = 255, 255, 255
            if v920[2] then
                v921, v922, v923 = v38.accent.r, v38.accent.g, v38.accent.b
            end
            v743 = v743 .. ("\a%02x%02x%02x%02x%s"):format(v921, v922, v923, v742.color.a, v920[1])
        end
        return v743
    end
    local v89 =
        (function()
        local v744 = {}
        v744.rect = function(v924, v925, v926, v927, v928, v929, v930, v931, v932)
            v932 = v19.min(v924 / 2, v925 / 2, v932)
            v28.rectangle(v924, v925 + v932, v926, v927 - (v932 * 2), v928, v929, v930, v931)
            v28.rectangle(v924 + v932, v925, v926 - (v932 * 2), v932, v928, v929, v930, v931)
            v28.rectangle(v924 + v932, (v925 + v927) - v932, v926 - (v932 * 2), v932, v928, v929, v930, v931)
            v28.circle(v924 + v932, v925 + v932, v928, v929, v930, v931, v932, 180, 0.25)
            v28.circle((v924 - v932) + v926, v925 + v932, v928, v929, v930, v931, v932, 90, 0.25)
            v28.circle((v924 - v932) + v926, (v925 - v932) + v927, v928, v929, v930, v931, v932, 0, 0.25)
            v28.circle(v924 + v932, (v925 - v932) + v927, v928, v929, v930, v931, v932, -90, 0.25)
        end
        v744.rect_o = function(v933, v934, v935, v936, v937, v938, v939, v940, v941, v942)
            v941 = v19.min(v935 / 2, v936 / 2, v941)
            if (v941 == 1) then
                v28.rectangle(v933, v934, v935, v942, v937, v938, v939, v940)
                v28.rectangle(v933, (v934 + v936) - v942, v935, v942, v937, v938, v939, v940)
            else
                v28.rectangle(v933 + v941, v934, v935 - (v941 * 2), v942, v937, v938, v939, v940)
                v28.rectangle(v933 + v941, (v934 + v936) - v942, v935 - (v941 * 2), v942, v937, v938, v939, v940)
                v28.rectangle(v933, v934 + v941, v942, v936 - (v941 * 2), v937, v938, v939, v940)
                v28.rectangle((v933 + v935) - v942, v934 + v941, v942, v936 - (v941 * 2), v937, v938, v939, v940)
                v28.circle_outline(v933 + v941, v934 + v941, v937, v938, v939, v940, v941, 180, 0.25, v942)
                v28.circle_outline(v933 + v941, (v934 + v936) - v941, v937, v938, v939, v940, v941, 90, 0.25, v942)
                v28.circle_outline((v933 + v935) - v941, v934 + v941, v937, v938, v939, v940, v941, -90, 0.25, v942)
                v28.circle_outline(
                    (v933 + v935) - v941,
                    (v934 + v936) - v941,
                    v937,
                    v938,
                    v939,
                    v940,
                    v941,
                    0,
                    0.25,
                    v942
                )
            end
        end
        v744.glow = function(v943, v944, v945, v946, v947, v948, v949, v950, v951, v952, v953, v954, v955, v956, v956)
            local v957 = 1
            local v958 = 1
            if v956 then
                v744.rect(v943, v944, v945, v946, v949, v950, v951, v952, v948)
            end
            for v1011 = 0, v947 do
                local v1012 = (v952 / 2) * ((v1011 / v947) ^ 3)
                v744.rect_o(
                    v943 + (((v1011 - v947) - v958) * v957),
                    v944 + (((v1011 - v947) - v958) * v957),
                    v945 - (((v1011 - v947) - v958) * v957 * 2),
                    v946 - (((v1011 - v947) - v958) * v957 * 2),
                    v953,
                    v954,
                    v955,
                    v1012 / 1.5,
                    v948 + (v957 * ((v947 - v1011) + v958)),
                    v957
                )
            end
        end
        return v744
    end)()
    v83.render_bottom = function(v748, v749, v750)
        local v751 = 16
        local v752 = "     " .. v748:get_text()
        local v753 = v82("", v752)
        local v754 = 8
        local v755, v756, v757 = v38.accent.r, v38.accent.g, v38.accent.b
        local v758, v759, v760 = 15, 15, 15
        local v761 = 2
        local v762 = 0 + v751 + v753.x
        local v762, v763 = v762 + (v761 * 2), 23
        local v764, v765 = v748.x - (v762 / 2), v19.ceil((v748.y - 40) + 0.4)
        local v766 = v26.frametime()
        if (v26.realtime() < v748.delay) then
            v748.y = v81(v748.y, (v40 - v38.offset) - ((v750 - v749) * v763 * 1.5), v766 * 7)
            v748.color.a = v81(v748.color.a, 255, v766 * 2)
        else
            v748.y = v81(v748.y, v748.y + 5, v766 * 15)
            v748.color.a = v81(v748.color.a, 0, v766 * 20)
            if (v748.color.a <= 1) then
                v748.active = false
            end
        end
        local v767, v768, v749, v750 = v748.color.r, v748.color.g, v748.color.b, v748.color.a
        local v769 = (v38.new_style and 18) or 0
        local v770 = v761 + 2
        v770 = v770 + 0 + v751
        if not v38.new_style then
            v89.glow(v764 + 26, v765, v762 - 15, v763, 12, v754, v758, v759, v760, v750, v755, v756, v757, v750, true)
            v89.glow(v764 - 5, v765, 25, v763, 12, v754, v758, v759, v760, v750, v755, v756, v757, v750, true)
            v28.texture(
                v42,
                (v764 + v770) - 18,
                ((v765 + (v763 / 2)) - (v753.y / 2)) + 1,
                11,
                11,
                v755,
                v756,
                v757,
                v750
            )
        else
            v43.rect_v(
                v764 + 5,
                v765,
                v762 - 20,
                v763 + 1,
                {v758, v759, v760, 170 * (v750 / 255)},
                6,
                {v755, v756, v757, v750}
            )
        end
        v28.text((v764 + v770) - v769, (v765 + (v763 / 2)) - (v753.y / 2), v767, v768, v749, v750, "", nil, v752)
    end
    v22.set_event_callback(
        "paint_ui",
        function()
            v83:handler()
        end
    )
    return v83
end)()
v22.delay_call(
    4,
    function()
        v44.create_new(
            {{"Welcome back, "}, {v38.name, true}, {" to pastsense "}, {v38.build, true}, {" " .. v38.vers, false}}
        )
    end
)
local v45 = [[struct {char         __pad_0x0000[0x1cd]; bool         hide_vm_scope; }]]
local v46 = v22.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")
local v47 = v25.cast("void****", v25.cast("char*", v46) + 2)[0]
local v48 = vtable_thunk(2, v45 .. "*(__thiscall*)(void*, unsigned int)")
local v49 = function()
    local v91, v92, v93 = {}, {}, {}
    v91.__metatable = false
    v92.struct = function(v771, v772)
        assert(v14(v772) == "string", "invalid class name")
        assert(rawget(v771, v772) == nil, "cannot overwrite subclass")
        return function(v959)
            assert(v14(v959) == "table", "invalid class data")
            v7(
                v771,
                v772,
                v1(
                    v959,
                    {__metatable = false, __index = function(v1017, v1018)
                            return rawget(v91, v1018) or rawget(v93, v1018)
                        end}
                )
            )
            return v93
        end
    end
    v93 = v1(v92, v91)
    return v93
end
local v50 =
    v49():struct("globals")(
    {
        states = {
            "stand",
            "slow walk",
            "run",
            "crouch",
            "sneak",
            "aerobic",
            "aerobic+",
            "manual left",
            "manual right",
            "fakelag",
            "hideshots"
        },
        extended_states = {
            "global",
            "stand",
            "slow walk",
            "run",
            "crouch",
            "sneak",
            "aerobic",
            "aerobic+",
            "manual left",
            "manual right",
            "fakelag",
            "hideshots"
        },
        def_ways = {"1-way", "2-way", "3-way", "4-way", "5-way"},
        keylist_icon = v28.load_png(
            "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
            15,
            15
        ),
        tick = 0
    }
):struct("ref")(
    {
        aa = {
            enabled = {v21.reference("aa", "anti-aimbot angles", "enabled")},
            pitch = {v21.reference("aa", "anti-aimbot angles", "pitch")},
            yaw_base = {v21.reference("aa", "anti-aimbot angles", "Yaw base")},
            yaw = {v21.reference("aa", "anti-aimbot angles", "Yaw")},
            yaw_jitter = {v21.reference("aa", "anti-aimbot angles", "Yaw Jitter")},
            body_yaw = {v21.reference("aa", "anti-aimbot angles", "Body yaw")},
            freestanding_body_yaw = {v21.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},
            freestand = {v21.reference("aa", "anti-aimbot angles", "Freestanding")},
            roll = {v21.reference("aa", "anti-aimbot angles", "Roll")},
            edge_yaw = {v21.reference("aa", "anti-aimbot angles", "Edge yaw")},
            fake_peek = {v21.reference("aa", "other", "Fake peek")}
        },
        misc = {
            log = {v21.reference("misc", "miscellaneous", "Log damage dealt")},
            fov = v21.reference("misc", "miscellaneous", "Override FOV"),
            override_zf = v21.reference("misc", "miscellaneous", "Override zoom FOV")
        },
        fakelag = {
            enable = {v21.reference("aa", "fake lag", "enabled")},
            amount = {v21.reference("aa", "fake lag", "amount")},
            variance = {v21.reference("aa", "fake lag", "variance")},
            limit = {v21.reference("aa", "fake lag", "limit")},
            lg = {v21.reference("aa", "other", "Leg movement")}
        },
        aa_other = {
            sw = {v21.reference("aa", "other", "Slow motion")},
            hide_shots = {v21.reference("aa", "other", "On shot anti-aim")}
        },
        rage = {
            enable = v21.reference("rage", "aimbot", "Enabled"),
            dt = {v21.reference("rage", "aimbot", "Double tap")},
            always = {v21.reference("rage", "other", "Automatic fire")},
            fd = {v21.reference("rage", "other", "Duck peek assist")},
            os = {v21.reference("aa", "other", "On shot anti-aim")},
            mindmg = {v21.reference("rage", "aimbot", "minimum damage")},
            baim = {v21.reference("rage", "aimbot", "force body aim")},
            safe = {v21.reference("rage", "aimbot", "force safe point")},
            ovr = {v21.reference("rage", "aimbot", "minimum damage override")}
        },
        slow_motion = {v21.reference("aa", "other", "Slow motion")}
    }
):struct("ui")(
    {
        menu = {global = {}, home = {}, antiaim = {}, tools = {}},
        header = function(v96, v97)
            local v98 = "\a373737FF"
            local v99 = "──────────────────────────"
            return v97:label(v98 .. v99)
        end,
        clr = function(v100, v101)
            local v102 = {gray = "\a808080FF", l_gray = "\a909090FF", d_gray = "\a606060FF", red = "\aff0000ff"}
            for v773, v774 in v3(v102) do
                if (v101 == v773) then
                    return v774
                end
            end
            return "error color"
        end,
        execute = function(v103)
            local v104 = v32.group("AA", "anti-aimbot angles")
            local v105 = v32.group("AA", "Fake lag")
            local v106 = v32.group("AA", "Other")
            local v107 = "\a808080FF•\r  "
            v103.menu.global.title_name = v105:label("\vez crack //\r  " .. v103.helpers:limit_ch(v38.name, 13, "..."))
            v103.menu.global.tab = v105:combobox("\n tabs", {" Home", " Anti-Aim", " Tools"})
            v103.menu.global.color =
                v105:color_picker("\naccent", 164, 210, 212, 255):depend({v103.menu.global.tab, " Home"})
            v103:header(v105)
            v103.menu.global.export =
                v105:button(
                v103:clr("d_gray") .. "\r Export config",
                function()
                    v34.set(v103.config:export("config"))
                end
            ):depend({v103.menu.global.tab, " Anti-Aim", true})
            v103.menu.global.import =
                v105:button(
                v103:clr("d_gray") .. "\r  Import config",
                function()
                    v103.config:import(v34.get(), "config")
                end
            ):depend({v103.menu.global.tab, " Anti-Aim", true})
            v103.menu.home.welcomer = v104:label("Welcome to \vpastsense\r " .. v38.vers .. " ☭")
            v103.menu.home.space = v103:header(v104)
            v103.menu.home.list = v104:listbox("configs", {})
            v103.menu.home.list:set_callback(
                function()
                    if v21.is_menu_open() then
                        v103.config:update_name()
                    end
                end
            )
            v103.menu.home.name = v104:textbox("config name")
            v103.menu.home.load =
                v104:button(
                v103:clr("d_gray") .. "\r  Load",
                function()
                    v103.config:load("config")
                end
            )
            v103.menu.home.save =
                v104:button(
                v103:clr("d_gray") .. "\r Save",
                function()
                    v103.config:save()
                end
            )
            v103.menu.home.delete =
                v104:button(
                v103:clr("red") .. " Delete",
                function()
                    v103.config:delete()
                end
            )
            v103.menu.home.discord_l = v106:label("\n")
            v103.menu.home.discord =
                v106:button(
                v103:clr("gray") .. "\a708090FF  Discord server\r",
                function()
                    v37.SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/fastleaks")
                end
            )
            v103.menu.home.youtube =
                v106:button(
                "\aFFE4E1FF  Steam cracker join\r",
                function()
                    v37.SteamOverlayAPI.OpenExternalBrowserURL("https://steamcommunity.com/id/neverl141/")
                end
            )
            v103.menu.antiaim.mode = v104:combobox(v107 .. "Anti-aim tab", {"Constructor", "Features"})
            v103.menu.antiaim.space = v103:header(v104):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.freestanding =
                v104:multiselect("Freestanding \v", {"Force static", "Disablers"}, 0):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.freestanding_disablers =
                v104:multiselect("\nfreestanding disablers", v103.globals.states):depend(
                {v103.menu.antiaim.freestanding, "Disablers"}
            ):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.edge_yaw = v104:label("Edge yaw", 0):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.manual_aa = v104:checkbox("Manual aa \v"):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.manual_static =
                v104:checkbox(v107 .. "Manual static"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_left =
                v104:hotkey(v107 .. "Manual left"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_right =
                v104:hotkey(v107 .. "Manual right"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_forward =
                v104:hotkey(v107 .. "Manual forward"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.fakelag_type =
                v105:combobox("Fake lag type", {"Maximum", "Dynamic", "Fluctuate"}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.fakelag_var =
                v105:slider(v107 .. "Variance", 0, 100, 100, true, "%"):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.fakelag_lim =
                v105:slider(v107 .. "Limit", 1, 15, 15):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.state =
                v104:combobox("\n current condition", v103.globals.extended_states):depend(
                {v103.menu.antiaim.mode, "Constructor"}
            )
            v103.menu.antiaim.states = {}
            for v775, v776 in v2(v103.globals.extended_states) do
                v103.menu.antiaim.states[v776] = {}
                local v778 = v103.menu.antiaim.states[v776]
                if (v776 ~= "global") then
                    v778.enable = v104:checkbox("Activate \v" .. v776)
                end
                local v779 = "\n" .. v776
                v778.options =
                    v106:multiselect(v107 .. "Features" .. v779, {"Enable defensive", "Avoid backstab", "Safe head"})
                v778.head_1 = v103:header(v106)
                v778.defensive_conditions =
                    v106:multiselect(
                    v107 .. "Defensive triggers\v" .. v779,
                    {
                        "Always",
                        "On hide-shots",
                        "Tick-Base",
                        "On weapon switch",
                        "On reload",
                        "On hittable",
                        "On freestand"
                    }
                ):depend({v778.options, "Enable defensive"})
                v778.defensive_conditions_tick =
                    v106:slider("\n Tick" .. v779, 1, 15, 8, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_conditions, "Tick-Base"}
                )
                v778.defensive_yaw = v104:checkbox("Defensive yaw" .. v779):depend({v778.options, "Enable defensive"})
                v778.defensive_yaw_mode =
                    v104:combobox(
                    "\ndefensive yaw mode" .. v779,
                    {"Jitter", "Random", "Custom spin", "Spin-way", "Switch 5-way"}
                ):depend({v778.options, "Enable defensive"}, {v778.defensive_yaw, true})
                v778.defensive_yaw_1_random =
                    v104:slider("\n 1 random yaw def" .. v779, -359, 359, 180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Random"}
                )
                v778.defensive_yaw_2_random =
                    v104:slider("\n 2 random yaw def" .. v779, -359, 359, -180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Random"}
                )
                v778.defensive_yaw_1_Spin_way =
                    v104:slider("\n 1 stage Spin-way" .. v779, -180, 180, -180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_2_Spin_way =
                    v104:slider("\n 2 stage Spin-way" .. v779, -180, 180, 180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_speed_Spin_way =
                    v104:slider(v107 .. "Delay" .. v779, 0, 16, 6, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_randomizer_Spin_way =
                    v104:slider(v107 .. "Randomizer" .. v779, 0, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_jitter_radius_1 =
                    v104:slider("\n JiTter 1" .. v779, -180, 180, 30, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_jitter_delay =
                    v104:slider(v107 .. "Delayed" .. v779, 1, 12, 6, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_jitter_random =
                    v104:slider(v107 .. "Randomize" .. v779, 0, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_way_delay =
                    v104:slider(v107 .. "Interpolation \v" .. v779, 0, 16, 4, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                for v960 = 1, 5 do
                    v778["defensive_yaw_way_switch" .. v960] =
                        v104:slider(
                        (((v960 == 1) and (v107 .. "Ways")) or "\n") .. "\v \n" .. v960 .. v779,
                        0,
                        360,
                        30,
                        true,
                        "°",
                        1
                    ):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"}
                    )
                end
                v778.defensive_yaw_way_randomly =
                    v104:checkbox(v107 .. "Increase yaw \v" .. v779):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                v778.defensive_yaw_way_randomly_value =
                    v104:slider("\n ramdom yaw value" .. v779, 0, 360, 20, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"},
                    {v778.defensive_yaw_way_randomly, true}
                )
                v778.defensive_yaw_wayspin_combo =
                    v104:combobox(v107 .. "Select spin way yaw" .. v779, v103.globals.def_ways):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                for v962 = 1, 5 do
                    local v963 = v962 .. "-way"
                    v778["defensive_yaw_enable_way_spin" .. v962] =
                        v104:checkbox("Enable spin \n " .. v962 .. v779):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                    v778["defensive_yaw_way_spin_limit" .. v962] =
                        v104:slider("\n limit  way-" .. v962 .. " " .. v779, 0, 360, 0, true, "°", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778["defensive_yaw_enable_way_spin" .. v962], true},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                    v778["defensive_yaw_way_speed" .. v962] =
                        v104:slider("\n speed way-" .. v962 .. " " .. v779, 1, 12, 8, true, "t", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778["defensive_yaw_enable_way_spin" .. v962], true},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                end
                v778.defensive_yaw_spin_limit =
                    v104:slider("\n limit spin yaw" .. v779, 15, 360, 360, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true}
                ):depend({v778.defensive_yaw_mode, "Custom spin"})
                v778.defensive_yaw_speedtick =
                    v104:slider("\n spin speed" .. v779, 1, 12, 6, true, "t", 0.5):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Custom spin"}
                )
                v778.defensive_pitch_enable =
                    v105:checkbox("Defensive pitch" .. v779):depend({v778.options, "Enable defensive"})
                v778.defensive_pitch_mode =
                    v105:combobox(
                    "\n defensive pitch mode" .. v779,
                    {"Static", "Spin", "Random", "Clocking", "Jitter", "5way"}
                ):depend({v778.options, "Enable defensive"}, {v778.defensive_pitch_enable, true})
                v778.defensive_pitch_custom =
                    v105:slider("\n pitch custom limit" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Clocking", true}
                )
                v778.defensive_pitch_spin_random2 =
                    v105:slider("\n pitch def random2" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Random"}
                )
                v778.defensive_pitch_spin_limit2 =
                    v105:slider("\n spin speed 2" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Spin"}
                )
                v778.defensive_pitch_speedtick =
                    v105:slider("\n spin speed" .. v779, 1, 64, 32, true, "t", 0.1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Spin"}
                )
                v778.defensive_pitch_way_label =
                    v105:label(v107 .. "On \v5-way\r yaw to more \vsettings"):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"},
                    {v778.defensive_yaw_mode, "Switch 5-way", true}
                )
                for v967 = 2, 5 do
                    v778["defensive_pitch_way" .. v967] =
                        v105:slider("\n pitch way " .. v967 .. v779, -89, 89, 0, true, "°", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                end
                v778.defensive_pitch_way_randomly =
                    v105:checkbox(v107 .. "Increase pitch \v" .. v779):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                v778.defensive_pitch_way_randomly_value =
                    v105:slider("\n ramdom pitch value" .. v779, 0, 89, 20, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"},
                    {v778.defensive_pitch_way_randomly, true}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                v778.defensive_pitch_way_spin_combo =
                    v105:combobox(v107 .. "Select spin way pitch" .. v779, v103.globals.def_ways):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                for v969 = 1, #v103.globals.def_ways do
                    local v970 = v103.globals.def_ways[v969]
                    v778["defensive_pitch_enable_way_spin" .. v969] =
                        v105:checkbox("Enable spin \n " .. v969 .. v779):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"},
                        {v778.defensive_pitch_way_spin_combo, v970}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                    for v1020 = 1, 2 do
                        v778["defensive_pitch_way_spin_limit" .. v969 .. v1020] =
                            v105:slider("\n limit  way-" .. v969 .. v1020 .. " " .. v779, -89, 89, 89, true, "°", 1):depend(
                            {v778.options, "Enable defensive"},
                            {v778["defensive_pitch_enable_way_spin" .. v969], true},
                            {v778.defensive_pitch_enable, true},
                            {v778.defensive_pitch_mode, "5way"},
                            {v778.defensive_pitch_way_spin_combo, v970}
                        ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                    end
                    v778["defensive_pitch_way_speed" .. v969] =
                        v105:slider("\n speed way-" .. v969 .. " " .. v779, 1, 12, 8, true, "t", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778["defensive_pitch_enable_way_spin" .. v969], true},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"},
                        {v778.defensive_pitch_way_spin_combo, v970}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                end
                v778.defensive_pitch_clock =
                    v105:slider("\n pitch clock limit" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Jitter"}
                )
                v778.head_2 = v103:header(v104)
                v778.yaw_base = v104:combobox(v107 .. "Yaw" .. v779, {"At targets", "Local view"})
                v778.yaw_jitter =
                    v104:combobox(
                    "\nyaw jitter" .. v779,
                    {"Off", "Offset", "Center", "Skitter", "Smoothnes", "Fractal", "Random"}
                )
                v778.yaw_jitter_add =
                    v104:slider("\nyaw jitter add" .. v779, -90, 90, 0, true, "°", 1):depend(
                    {v778.yaw_jitter, "Off", true}
                )
                v778.yaw_fractals =
                    v104:slider(v107 .. "Fractals \v" .. v779, 1, 14, 0, true, "°", 1, {[14] = "Random"}):depend(
                    {v778.yaw_jitter, "Off", true},
                    {v778.yaw_jitter, "Fractal"}
                )
                v778.yaw_add = v104:slider(v107 .. "Yaw add \v" .. v779, -180, 180, 0, true, "°", 1)
                v778.yaw_add_r = v104:slider("\n yaw add (R)" .. v779, -180, 180, 0, true, "°", 1)
                v778.jitter_delay =
                    v104:slider(
                    v107 .. "Yaw delay  \v" .. v779,
                    0,
                    4,
                    0,
                    true,
                    "x",
                    1,
                    {[1] = "Randomly", [0] = "Off"}
                )
                v778.yaw_random =
                    v104:slider(v107 .. "Yaw randomize \v" .. v779, 0, 100, 0, true, "%", 1):depend(
                    {v778.yaw_jitter, "Off", true}
                )
                v778.head_3 = v103:header(v104)
                v778.body_yaw = v104:combobox(v107 .. "Body yaw" .. v779, {"Off", "Opposite", "Static", "Jitter"})
                v778.body_yaw_side =
                    v104:combobox("\n Body yaw side" .. v779, {"Left", "Right", "Freestanding"}):depend(
                    {v778.body_yaw, "Static", false}
                )
                for v973, v974 in v3(v778) do
                    local v975 = {{v103.menu.antiaim.state, v776}, {v103.menu.antiaim.mode, "Constructor"}}
                    if ((v973 ~= "enable") and (v776 ~= "global")) then
                        v975 = {
                            {v103.menu.antiaim.state, v776},
                            {v103.menu.antiaim.mode, "Constructor"},
                            {v778.enable, true}
                        }
                    end
                    v974:depend(v18.unpack(v975))
                end
            end
            v103.menu.antiaim.export =
                v106:button(
                v103:clr("d_gray") .. "\r  Export condition",
                function()
                    data = v103.config:export("state", v103.menu.antiaim.state:get())
                    v34.set(data)
                end
            ):depend({v103.menu.antiaim.mode, "Constructor"})
            v103.menu.antiaim.import =
                v106:button(
                v103:clr("d_gray") .. "\r  Import condition ",
                function()
                    local v824 = v34.get()
                    local v825 = v824:match("{pastsense:(.+)}")
                    v103.config:import(v824, v825, v103.menu.antiaim.state:get())
                end
            ):depend({v103.menu.antiaim.mode, "Constructor"})
            v103.menu.tools.subtub = v104:combobox(v107 .. "Active tab", {"Helpers", "Visuals"})
            v103.menu.tools.subtub_n = v104:label("\n")
            local v142 = v103.menu.tools.subtub
            v103.menu.tools.indicators_gamesense =
                v104:checkbox("\v\r Debug indicators \v[secret] \r☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicators = v104:checkbox("\v\r Crosshair indicators ☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicator_pos =
                v104:combobox("\n position ind", {"Left", "Right"}):depend({v103.menu.tools.indicators, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.indicatorfont =
                v104:combobox(v107 .. "Indicator style", {"Default", "New", "Renewed", "Icons", "pastsense"}):depend(
                {v103.menu.tools.indicators, true}
            ):depend({v142, "Visuals"})
            v103.menu.tools.indicator_bind =
                v104:checkbox(v107 .. "Show binds"):depend(
                {v103.menu.tools.indicators, true},
                {v142, "Visuals"},
                {v103.menu.tools.indicatorfont, "pastsense"}
            )
            v103.menu.tools.indicatoroffset =
                v104:slider("\n Offset indcator ", 0, 90, 35, true, "px"):depend({v103.menu.tools.indicators, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.manuals = v104:checkbox("\v\r Manual arrows ☭"):depend({v142, "Visuals"})
            v103.menu.tools.manuals_style =
                v104:combobox("\n arrows style", {"pastsense", "New"}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.manuals, true}
            )
            v103.menu.tools.manuals_global =
                v104:checkbox("Arrows side"):depend({v142, "Visuals"}, {v103.menu.tools.manuals, true})
            v103.menu.tools.manuals_offset =
                v104:slider("\n arrows offset", 0, 100, 15, true, "px"):depend(
                {v142, "Visuals"},
                {v103.menu.tools.manuals, true}
            )
            v103.menu.tools.animscope = v104:checkbox("\v\r Animated scope ☭"):depend({v142, "Visuals"})
            v103.menu.tools.animscope_fov_slider =
                v104:slider(v107 .. "Fov value", 105, 135, 130, true, "%", 1):depend({v103.menu.tools.animscope, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.animscope_slider =
                v104:slider("\n Anim scope value", 0, 100, 5, true, "%", 1):depend({v103.menu.tools.animscope, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.indicator_dmg = v104:checkbox("\v\r Damage indicator ☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicator_dmg_color =
                v104:color_picker("\ncolor dmg", 255, 255, 255):depend({v103.menu.tools.indicator_dmg, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.indicator_dmg_weapon =
                v104:checkbox(v107 .. "Only min damage"):depend({v103.menu.tools.indicator_dmg, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.visual_head_1 = v104:label("\n"):depend({v142, "Visuals"})
            v103.menu.tools.style = v104:combobox("\v\r Widgets style ☭", {"New", "Default"}):depend({v142, "Visuals"})
            v103.menu.tools.watermark = v104:checkbox("\v\r Watermark ☭"):depend({v142, "Visuals"})
            v103.menu.tools.keylist = v104:checkbox("\v\r Hotkeys ☭"):depend({v142, "Visuals"})
            v103.menu.tools.notify_master = v104:checkbox("\v\r Logging ☭"):depend({v142, "Visuals"})
            v103.menu.tools.notify_vibor =
                v104:multiselect("\n Log type", {"Hit", "Miss", "Get harmed", "Detect shot", "Preview"}):depend(
                {v103.menu.tools.notify_master, true}
            ):depend({v142, "Visuals"})
            v103.menu.tools.notify_offset =
                v104:slider("\n Offset notifys ", 0, 900, 45, true, "px", 1):depend(
                {v103.menu.tools.notify_master, true}
            ):depend({v142, "Visuals"})
            v103.menu.tools.notify_test =
                v104:button(
                "\v✨",
                function()
                    v44.create_new({{"Example: "}, {"logging ", true}, {"12345"}})
                end
            ):depend({v103.menu.tools.notify_vibor, "Preview"}, {v103.menu.tools.notify_master, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.visual_head_2 = v104:label("\n"):depend({v142, "Visuals"})
            v103.menu.tools.gs_ind = v104:checkbox("\v\r Indicators left gs ☭"):depend({v142, "Visuals"})
            v103.menu.tools.gs_inds =
                v104:multiselect("\n inds selc", {"Target", "..."}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.gs_ind, true}
            )
            v103.menu.tools.viewmodel_on = v104:checkbox("\v\r Viewmodel modifier ☭"):depend({v142, "Visuals"})
            v103.menu.tools.viewmodel_scope = v104:checkbox("\v\r Show weapon scoped ☭"):depend({v142, "Visuals"})
            v103.menu.tools.viewmodel_mod =
                v104:combobox("\nstyleview", {"Without-scope", "In-scope"}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true}
            )
            v103.menu.tools.viewmodel_x1 =
                v104:slider("\nviewwithoscope-x", -100, 100, 0, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_y1 =
                v104:slider("\nviewwithoscope-y", -100, 100, -5, true, "y", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_z1 =
                v104:slider("\nviewwithoscope-z", -100, 100, -1, true, "z", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_fov1 =
                v104:slider(v107 .. "Fov\n without scope", 0, 170, 61, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_inscope =
                v104:checkbox("Override scope"):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"}
            )
            v103.menu.tools.viewmodel_x2 =
                v104:slider("\nview with x", -100, 100, -4, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_y2 =
                v104:slider("\nview with y", -100, 100, -5, true, "y", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_z2 =
                v104:slider("\nview with z", -100, 100, -1, true, "z", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_fov2 =
                v104:slider(v107 .. "Fov\n with ov", 0, 170, 61, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.air_stop = v104:checkbox("\v\aFAF0E6FF Jumpscout ☭", 0):depend({v142, "Helpers"})
            v103.menu.tools.air_stop_distance =
                v104:slider("\n Distance", 1, 25, 2, true, "ft", 5, {[25] = "Always"}):depend(
                {v142, "Helpers"},
                {v103.menu.tools.air_stop, true}
            )
            v103.menu.tools.unsafe_charge = v104:checkbox("\v\a00BFFFFF Unsafe charge \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.fast_ladder = v104:checkbox("\v\aFF0000FF Fast ladder \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk = v104:checkbox("\v\aFAF0E6FF Trashtalk ☭"):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk_type =
                v104:combobox("\n trashtalk type", {"Default type", "Custom phrase", "1 MOD"}):depend(
                {v103.menu.tools.trashtalk, true}
            ):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk_check2 =
                v104:checkbox(v107 .. "with player name (enemy)"):depend(
                {v103.menu.tools.trashtalk, true},
                {v103.menu.tools.trashtalk_type, "1 MOD"}
            ):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk_custom =
                v104:textbox("\n phrase"):depend(
                {v103.menu.tools.trashtalk, true},
                {v103.menu.tools.trashtalk_type, "Custom phrase"}
            ):depend({v142, "Helpers"})
            v103.menu.tools.animations = v104:checkbox("\v\a00BFFFFF Animations breakers \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.animations_selector =
                v104:multiselect(
                "\n Animations",
                {
                    "Reset pitch on land",
                    "Body lean",
                    "Static legs",
                    "Jitter air",
                    "Jitter ground",
                    "Kangaroo",
                    "Moonwalk",
                    "Yaw break",
                    "Pitch break"
                }
            ):depend({v103.menu.tools.animations, true}):depend({v142, "Helpers"})
            v103.menu.tools.animations_body =
                v104:slider("\n Body lean ", 0, 100, 74, true, ""):depend({v103.menu.tools.animations, true}):depend(
                {v103.menu.tools.animations_selector, "Body lean"}
            ):depend({v142, "Helpers"})
            v103.menu.tools.autobuy = v104:checkbox("\v\aFF0000FF Auto buy \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.autobuy_v =
                v104:combobox("\n auto buy vibor", {"Awp", "Scar/g3sg1", "Scout"}):depend(
                {v103.menu.tools.autobuy, true}
            ):depend({v142, "Helpers"})
            v32.traverse(
                v103.menu.home,
                function(v826)
                    v826:depend({v103.menu.global.tab, " Home"})
                end
            )
            v32.traverse(
                v103.menu.antiaim,
                function(v827)
                    v827:depend({v103.menu.global.tab, " Anti-Aim"})
                end
            )
            v32.traverse(
                v103.menu.tools,
                function(v828)
                    v828:depend({v103.menu.global.tab, " Tools"})
                end
            )
        end,
        shutdown = function(v196)
            v196.helpers:menu_visibility(true)
        end
    }
):struct("helpers")(
    {
        anim = {},
        contains = function(v197, v198, v199)
            for v829, v830 in v3(v198) do
                if (v830 == v199) then
                    return true
                end
            end
            return false
        end,
        lerp = function(v200, v201, v202, v203)
            return ((v202 - v201) * v203) + v201
        end,
        math_anim2 = function(v204, v205, v206, v207)
            v207 = v43.clamp(v26.frametime() * ((v207 / 100) or 0.08) * 175, 0.01, 1)
            local v208 = v204:lerp(v205, v206, v207)
            return v12(v20.format("%.3f", v208))
        end,
        new_anim = function(v209, v210, v211, v212)
            if (v209.anim[v210] == nil) then
                v209.anim[v210] = v211
            end
            local v213 = v209:math_anim2(v209.anim[v210], v211, v212)
            v209.anim[v210] = v213
            return v209.anim[v210]
        end,
        rgba_to_hex = function(v215, v216, v217, v218, v219)
            return v29.tohex(
                (v19.floor(v216 + 0.5) * 16777216) + (v19.floor(v217 + 0.5) * 65536) + (v19.floor(v218 + 0.5) * 256) +
                    (v19.floor(v219 + 0.5))
            )
        end,
        limit_ch = function(v220, v221, v222, v223)
            local v224 = {}
            local v225 = 1
            for v831 in v20.gmatch(v221, ".[\x80-\xBF]*") do
                v225, v224[v225] = v225 + 1, v831
                if (v222 < v225) then
                    if v223 then
                        v224[v225] = ((v223 == true) and "...") or v223
                    end
                    break
                end
            end
            return v18.concat(v224)
        end,
        animate_pulse = function(v226, v227, v228)
            local v229, v230, v231, v232 = v15(v227)
            local v233 = v229 * v19.abs(v19.cos(v26.curtime() * v228))
            local v234 = v230 * v19.abs(v19.cos(v26.curtime() * v228))
            local v235 = v231 * v19.abs(v19.cos(v26.curtime() * v228))
            local v236 = v232 * v19.abs(v19.cos(v26.curtime() * v228))
            return v233, v234, v235, v236
        end,
        animate_text = function(v237, v238, v239, v240, v241, v242, v243)
            local v244, v245 = {}, 1
            local v246 = v239:len() - 1
            local v247 = 255 - v240
            local v248 = 255 - v241
            local v249 = 255 - v242
            local v250 = 155 - v243
            for v833 = 1, #v239 do
                local v834 = ((v833 - 1) / (#v239 - 1)) + v238
                v244[v245] =
                    "\a" ..
                    v237:rgba_to_hex(
                        v240 + (v247 * v19.abs(v19.cos(v834))),
                        v241 + (v248 * v19.abs(v19.cos(v834))),
                        v242 + (v249 * v19.abs(v19.cos(v834))),
                        v243 + (v250 * v19.abs(v19.cos(v834)))
                    )
                v244[v245 + 1] = v239:sub(v833, v833)
                v245 = v245 + 2
            end
            return v244
        end,
        rounded_side_v = function(v251, v252, v253, v254, v255, v256, v257, v258, v259, v260, v261, v262)
            v252, v253, v254, v255, v260 = v252 * 1, v253 * 1, v254 * 1, v255 * 1, (v260 or 0) * 1
            v261, v262 = v261 or false, v262 or false
            local v263 = v256
            local v264 = v257
            local v265 = v258
            local v266 = v259
            v28.rectangle(v252 + v260, v253, v254 - v260, v255, v263, v264, v265, v266)
            if v261 then
                v28.circle(v252 + v260, v253 + v260, v263, v264, v265, v266, v260, 180, 0.25)
                v28.circle(v252 + v260, (v253 + v255) - v260, v263, v264, v265, v266, v260, 270, 0.25)
                v28.rectangle(v252, v253 + v260, (v254 - v254) + v260, (v255 - v260) - v260, v263, v264, v265, v266)
            end
            if v262 then
                v28.circle(v252 + v254, v253 + v260, v263, v264, v265, v266, v260, 90, 0.25)
                v28.circle(v252 + v254, (v253 + v255) - v260, v263, v264, v265, v266, v260, 0, 0.25)
                v28.rectangle(
                    v252 + v254,
                    v253 + v260,
                    (v254 - v254) + v260,
                    (v255 - v260) - v260,
                    v263,
                    v264,
                    v265,
                    v266
                )
            end
        end,
        get_camera_pos = function(v267, v268)
            local v269, v270, v271 = v24.get_prop(v268, "m_vecOrigin")
            if (v269 == nil) then
                return
            end
            local v272, v272, v273 = v24.get_prop(v268, "m_vecViewOffset")
            v271 = v271 + (v273 - (v24.get_prop(v268, "m_flDuckAmount") * 16))
            return v269, v270, v271
        end,
        fired_shot = function(v274, v275, v276, v277)
            local v278 = {v274:get_camera_pos(v276)}
            if (v278[1] == nil) then
                return
            end
            local v279 = {v24.hitbox_position(v275, 0)}
            local v280 = {v279[1] - v278[1], v279[2] - v278[2], v279[3] - v278[3]}
            local v281 = {v277[1] - v278[1], v277[2] - v278[2], v277[3] - v278[3]}
            local v282 =
                ((v280[1] * v281[1]) + (v280[2] * v281[2]) + (v280[3] * v281[3])) /
                (v19.pow(v281[1], 2) + v19.pow(v281[2], 2) + v19.pow(v281[3], 2))
            local v283 = {v278[1] + (v281[1] * v282), v278[2] + (v281[2] * v282), v278[3] + (v281[3] * v282)}
            local v284 =
                v19.abs(
                v19.sqrt(v19.pow(v279[1] - v283[1], 2) + v19.pow(v279[2] - v283[2], 2) + v19.pow(v279[3] - v283[3], 2))
            )
            local v285 = v22.trace_line(v276, v277[1], v277[2], v277[3], v279[1], v279[2], v279[3])
            local v286 = v22.trace_line(v275, v283[1], v283[2], v283[3], v279[1], v279[2], v279[3])
            return (v284 < 69) and ((v285 > 0.99) or (v286 > 0.99))
        end,
        get_damage = function(v287)
            local v288 = v21.get(v287.ref.rage.mindmg[1])
            if (v21.get(v287.ref.rage.ovr[1]) and v21.get(v287.ref.rage.ovr[2])) then
                return v21.get(v287.ref.rage.ovr[3])
            else
                return v288
            end
        end,
        get_charge = function(v289)
            local v290 = v24.get_local_player()
            if (not v290 or not v24.is_alive(v290)) then
                return
            end
            local v291 = v24.get_prop(v290, "m_flNextAttack")
            local v292 = v24.get_prop(v24.get_player_weapon(v290), "m_flNextPrimaryAttack")
            local v293 = not (v19.max(v292, v291) > v26.curtime()) and (v289.globals.tick ~= 3)
            return v293
        end,
        normalize_yaw = function(v294, v295)
            v295 = v295 % 360
            v295 = (v295 + 360) % 360
            if (v295 > 180) then
                v295 = v295 - 360
            end
            return v295
        end,
        normalize_pitch = function(v296, v297)
            return v43.clamp(v297, -89, 89)
        end,
        distance = function(v298, v299, v300, v301, v302, v303, v304)
            return v19.sqrt(((v302 - v299) ^ 2) + ((v303 - v300) ^ 2) + ((v304 - v301) ^ 2))
        end,
        flags = {HIT = {11, 2048}},
        entity_has_flag = function(v305, v306, v307)
            if (not v306 or not v307) then
                return false
            end
            local v308 = v305.flags[v307]
            if (v308 == nil) then
                return false
            end
            local v309 = v24.get_esp_data(v306) or {}
            return v29.band(v309.flags or 0, v29.lshift(1, v308[1])) == v308[2]
        end,
        get_target = function(v310)
            local v311 = v24.get_local_player()
            local v312 = v22.current_threat()
            local v313 = "None"
            if (not v311 or not v312) then
                v313 = "None"
            else
                v313 = v24.get_player_name(v312)
            end
            return v313
        end,
        menu_visibility = function(v314, v315)
            local v316 = {v314.ref.aa, v314.ref.fakelag, v314.ref.aa_other}
            for v837, v838 in v2(v316) do
                for v977, v978 in v3(v838) do
                    for v1022, v1023 in v2(v978) do
                        v21.set_visible(v1023, v315)
                    end
                end
            end
            v21.set_enabled(v314.ref.misc.log[1], v315)
            v21.set_enabled(v314.ref.misc.override_zf, v315)
            v21.set(v314.ref.misc.log[1], false)
        end,
        in_air = function(v317, v318)
            local v319 = v24.get_prop(v318, "m_fFlags")
            return v29.band(v319, 1) == 0
        end,
        in_duck = function(v320, v321)
            local v322 = v24.get_prop(v321, "m_fFlags")
            return v29.band(v322, 4) == 4
        end,
        get_state = function(v323)
            local v324 = v24.get_local_player()
            local v325 = v24.get_prop(v324, "m_vecVelocity")
            local v326 = v31(v325):length2d()
            local v327 = v323:in_duck(v324) or v21.get(v323.ref.rage.fd[1])
            local v328 = v323.ui.menu.antiaim.states
            local v329 = v323.antiaim:get_manual()
            local v330 = v21.get(v323.ref.rage.dt[1]) and v21.get(v323.ref.rage.dt[2])
            local v331 = v21.get(v323.ref.rage.os[1]) and v21.get(v323.ref.rage.os[2])
            local v332 = v21.get(v323.ref.rage.fd[1])
            local v333 = "global"
            if (v326 > 1.5) then
                if v328["run"].enable() then
                    v333 = "run"
                end
            elseif v328["stand"].enable() then
                v333 = "stand"
            end
            if v323:in_air(v324) then
                if v327 then
                    if v328["aerobic+"].enable() then
                        v333 = "aerobic+"
                    end
                elseif v328["aerobic"].enable() then
                    v333 = "aerobic"
                end
            elseif (v327 and (v326 > 1.5) and v328["sneak"].enable()) then
                v333 = "sneak"
            elseif
                ((v326 > 1) and v21.get(v323.ref.slow_motion[1]) and v21.get(v323.ref.slow_motion[2]) and
                    v328["slow walk"].enable())
             then
                v333 = "slow walk"
            elseif ((v329 == -90) and v328["manual left"].enable()) then
                v333 = "manual left"
            elseif ((v329 == 90) and v328["manual right"].enable()) then
                v333 = "manual right"
            elseif (v327 and v328["crouch"].enable()) then
                v333 = "crouch"
            end
            if v326 then
                if (v328["fakelag"].enable() and ((not v330 and not v331) or v332)) then
                    v333 = "fakelag"
                end
                if (v328["hideshots"].enable() and v331 and not v330 and not v332) then
                    v333 = "hideshots"
                end
            end
            return v333
        end
    }
):struct("config")(
    {configs = {}, write_file = function(v334, v335, v336)
            if (not v336 or (v14(v335) ~= "string")) then
                return
            end
            return v10(v335, json.stringify(v336))
        end, update_name = function(v337)
            local v338 = v337.ui.menu.home.list()
            local v339 = 0
            for v839, v840 in v3(v337.configs) do
                if (v338 == v339) then
                    return v337.ui.menu.home.name(v839)
                end
                v339 = v339 + 1
            end
        end, update_configs = function(v340)
            local v341 = {}
            for v841, v842 in v3(v340.configs) do
                v18.insert(v341, v841)
            end
            if (#v341 > 0) then
                v340.ui.menu.home.list:update(v341)
            end
            v340:write_file("pastsense_configs.txt", v340.configs)
            v340:update_name()
        end, setup = function(v342)
            local v343 = v9("pastsense_configs.txt")
            if (v343 == nil) then
                return
            end
            v342.configs = json.parse(v343)
            v342:update_configs()
            v342:update_name()
        end, export_config = function(v345, ...)
            local v346 = v345.ui.menu.home.name()
            local v347 = v32.setup({v345.ui.menu.global, v345.ui.menu.antiaim, v345.ui.menu.tools})
            local v348 = v347:save()
            local v349 = v33.encode(json.stringify(v348))
            print("Succsess cfg export")
            return v349
        end, export_state = function(v350, v351)
            local v352 = v32.setup({v350.ui.menu.antiaim.states[v351]})
            local v351 = v350.ui.menu.antiaim.state:get()
            local v353 = v352:save()
            local v354 = v33.encode(json.stringify(v353))
            v44.create_new({{"Condition "}, {v351, true}, {" export"}})
            return v354
        end, export = function(v355, v356, ...)
            local v357, v358 = v16(v355["export_" .. v356], v355, ...)
            if not v357 then
                print(v358)
                return
            end
            print("Succsess")
            return "{pastsense:" .. v356 .. "}:" .. v358
        end, import_config = function(v359, v360)
            local v361 = json.parse(v33.decode(v360))
            local v362 = v32.setup({v359.ui.menu.global, v359.ui.menu.antiaim, v359.ui.menu.tools})
            v362:load(v361)
            v44.create_new({{"Cfg import"}, {"!", true}})
        end, import_state = function(v363, v364, v365)
            local v366 = json.parse(v33.decode(v364))
            local v367 = v32.setup({v363.ui.menu.antiaim.states[v365]})
            v367:load(v366)
            v44.create_new({{"Condition import"}, {"!", true}})
        end, import = function(v368, v369, v370, ...)
            local v371 = v369:match("{pastsense:(.+)}")
            if (not v371 or (v371 ~= v370)) then
                v44.create_new({{"Error: "}, {"This not pastsense config", true}})
                return v0("This not pastsense config")
            end
            local v372, v373 = v16(v368["import_" .. v371], v368, v369:gsub("{pastsense:" .. v371 .. "}:", ""), ...)
            if not v372 then
                print(v373)
                v44.create_new({{"Error: "}, {"Failed data pastsense", true}})
                return v0("Failed data pastsense")
            end
        end, save = function(v374)
            local v375 = v374.ui.menu.home.name()
            if (v375:match("%w") == nil) then
                v44.create_new({{"Invalid config "}, {"name", true}})
                return print("Invalid config name")
            end
            local v376 = v374:export("config")
            v374.configs[v375] = v376
            v44.create_new({{"Saved cfg "}, {v375, true}})
            v374:update_configs()
        end, load = function(v378, v379)
            local v380 = v378.ui.menu.home.name()
            local v381 = v378.configs[v380]
            if not v381 then
                v44.create_new({{"Invalid cfg "}, {"name", true}})
                return v0("Inval. cfg name")
            end
            v378:import(v381, v379)
            v44.create_new({{"Loaded cfg "}, {v380, true}})
        end, delete = function(v382)
            local v383 = v382.ui.menu.home.name()
            local v384 = v382.configs[v383]
            if not v384 then
                return v0("Invalid config name")
            end
            v382.configs[v383] = nil
            v44.create_new({{"Delete cfg "}, {v383, true}})
            v382:update_configs()
        end}
):struct("antiaim")(
    {
        side = 0,
        last_rand = 0,
        skitter_counter = 0,
        last_skitter = 0,
        cycle = 0,
        manual_side = 0,
        anti_backstab = function(v386)
            local v387 = v24.get_local_player()
            local v388 = v22.current_threat()
            if ((v387 == nil) or not v24.is_alive(v387)) then
                return false
            end
            if not v388 then
                return false
            end
            local v389 = v24.get_player_weapon(v388)
            if not v389 then
                return false
            end
            local v390 = v24.get_classname(v389)
            if not v390:find("Knife") then
                return false
            end
            local v391 = v31(v24.get_origin(v387))
            local v392 = v31(v24.get_origin(v388))
            local v393 = 168
            return v392:dist2d(v391) < v393
        end,
        get_best_side = function(v394, v395)
            local v396 = v24.get_local_player()
            local v397 = v31(v22.eye_position())
            local v398 = v22.current_threat()
            local v399, v400 = v22.camera_angles()
            local v401
            if v398 then
                v401 = v31(v24.get_origin(v398)) + v31(0, 0, 64)
                v399, v400 = (v401 - v397):angles()
            end
            local v402 = {60, 45, 30, -30, -45, -60}
            local v403 = {left = 0, right = 0}
            for v843, v844 in v2(v402) do
                local v845 = v31():init_from_angles(0, v400 + 180 + v844, 0)
                if v398 then
                    local v1024 = v397 + v845:scaled(128)
                    local v1025, v1026 = v22.trace_bullet(v398, v401.x, v401.y, v401.z, v1024.x, v1024.y, v1024.z, v396)
                    v403[((v844 < 0) and "left") or "right"] = v403[((v844 < 0) and "left") or "right"] + v1026
                else
                    local v1028 = v397 + v845:scaled(8192)
                    local v1029 = v22.trace_line(v396, v397.x, v397.y, v397.z, v1028.x, v1028.y, v1028.z)
                    v403[((v844 < 0) and "left") or "right"] = v403[((v844 < 0) and "left") or "right"] + v1029
                end
            end
            if (v403.left == v403.right) then
                return 2
            elseif (v403.left > v403.right) then
                return (v395 and 1) or 0
            else
                return (v395 and 0) or 1
            end
        end,
        get_manual = function(v404)
            local v405 = v24.get_local_player()
            if ((v405 == nil) or not v404.ui.menu.antiaim.manual_aa:get()) then
                return
            end
            local v406 = v404.ui.menu.antiaim.manual_left:get()
            local v407 = v404.ui.menu.antiaim.manual_right:get()
            local v408 = v404.ui.menu.antiaim.manual_forward:get()
            if (v404.last_forward == nil) then
                v404.last_forward, v404.last_right, v404.last_left = v408, v407, v406
            end
            if (v406 ~= v404.last_left) then
                if (v404.manual_side == 1) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 1
                end
            end
            if (v407 ~= v404.last_right) then
                if (v404.manual_side == 2) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 2
                end
            end
            if (v408 ~= v404.last_forward) then
                if (v404.manual_side == 3) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 3
                end
            end
            v404.last_forward, v404.last_right, v404.last_left = v408, v407, v406
            if not v404.manual_side then
                return
            end
            return ({-90, 90, 180})[v404.manual_side]
        end,
        run = function(v412, v413)
            local v414 = v24.get_local_player()
            if not v24.is_alive(v414) then
                return
            end
            local v415 = v412.helpers:get_state()
            v412:set_builder(v413, v415)
        end,
        set_builder = function(v416, v417, v418)
            local v419 = {}
            for v846, v847 in v3(v416.ui.menu.antiaim.states[v418]) do
                v419[v846] = v847()
            end
            v416:set(v417, v419)
        end,
        animations = function(v420)
            local v421 = v24.get_local_player()
            if not v24.is_alive(v421) then
                return
            end
            local v422 = v35.new(v421)
            local v423 = v422:get_anim_state()
            local v424 = v420.ui.menu.tools.animations_body:get()
            local v425 = v420.ui.menu.tools.animations_selector:get()
            if not v423 then
                return
            end
            local v426 = v24.get_prop(v421, "m_vecVelocity[0]")
            if v420.helpers:contains(v425, "Body lean") then
                local v982 = v422:get_anim_overlay(12)
                if not v982 then
                    return
                end
                if (v19.abs(v426) >= 3) then
                    v982.weight = v424 / 100
                end
            end
            if v420.helpers:contains(v425, "Static legs") then
                v24.set_prop(v421, "m_flPoseParameter", 1, 6)
            end
            if v420.helpers:contains(v425, "Yaw break") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 11)
            end
            if v420.helpers:contains(v425, "Pitch break") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 12)
            end
            if v420.helpers:contains(v425, "Jitter ground") then
                v21.set(v420.ref.fakelag.lg[1], "Always slide")
                if ((v26.tickcount() % 4) > 1) then
                    v24.set_prop(v421, "m_flPoseParameter", 0, 0)
                end
            end
            if v420.helpers:contains(v425, "Kangaroo") then
                if not v420.helpers:contains(v425, "Jitter air") then
                    v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 6)
                end
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 3)
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 10)
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 9)
            end
            if v420.helpers:contains(v425, "Jitter air") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 6)
            end
            if v420.helpers:contains(v425, "Moonwalk") then
                v21.set(v420.ref.fakelag.lg[1], "Never slide")
                v24.set_prop(v421, "m_flPoseParameter", 0, 7)
                if v420.helpers:in_air(v421) then
                    v422:get_anim_overlay(4).weight = 0
                    v422:get_anim_overlay(6).weight = 1
                end
            end
            if v420.helpers:contains(v425, "Reset pitch on land") then
                if not v423.hit_in_ground_animation then
                    return
                end
                v24.set_prop(v421, "m_flPoseParameter", 0.5, 12)
            end
        end,
        get_defensive = function(v427, v428, v429, v430)
            local v431 = v22.current_threat()
            local v432 = v24.get_local_player()
            if v427.helpers:contains(v428, "Always") then
                return true
            end
            if v427.helpers:contains(v428, "On weapon switch") then
                local v983 = v24.get_prop(v432, "m_flNextAttack") - v26.curtime()
                if ((v983 / v26.tickinterval()) > (v427.defensive.defensive + 2)) then
                    return true
                end
            end
            if v427.helpers:contains(v428, "Tick-Base") then
                local v984 = v430.defensive_conditions_tick * 2
                if ((v26.tickcount() % 32) >= v984) then
                    return true
                else
                    return false
                end
            end
            if v427.helpers:contains(v428, "On reload") then
                local v985 = v24.get_player_weapon(v432)
                if v985 then
                    local v1051 = v24.get_prop(v432, "m_flNextAttack") - v26.curtime()
                    local v1052 = v24.get_prop(v985, "m_flNextPrimaryAttack") - v26.curtime()
                    if ((v1051 > 0) and (v1052 > 0) and ((v1051 * v26.tickinterval()) > v427.defensive.defensive)) then
                        return true
                    end
                end
            end
            if (v427.helpers:contains(v428, "On hittable") and v427.helpers:entity_has_flag(v431, "HIT")) then
                return true
            end
            if
                (v427.helpers:contains(v428, "On freestand") and v427.ui.menu.antiaim.freestanding:get_hotkey() and
                    not (v427.ui.menu.antiaim.freestanding:get("Disablers") and
                        v427.ui.menu.antiaim.freestanding_disablers:get(v429)))
             then
                return true
            end
        end,
        spin_yaw = 0,
        spin_pitch_def = 0,
        switch_way = 1,
        spin_value = 0,
        jitter_side = 0,
        spin_way = 0,
        spin_pitch = 0,
        last_way = 0,
        switch_random = 0,
        switch_random_p = 0,
        random_spin_way = 0,
        spin_way_180 = 0,
        set = function(v433, v434, v435)
            local v436 = v433.helpers:get_state()
            local v437 = {v19.random(1, v19.random(3, 4)), 2, 4, 5}
            local v438 = v433:get_manual()
            local v439 = true
            if (v435.jitter_delay == 0) then
                v437[v435.jitter_delay] = 1
            end
            if ((v26.chokedcommands() == 0) and (v433.cycle == v437[v435.jitter_delay])) then
                v439 = false
                v433.side = ((v433.side == 1) and 0) or 1
            end
            local v440 = v433:get_best_side()
            local v441 = v433.side
            local v442 = v435.body_yaw
            local v443 = "default"
            local v444 = v19.random(-v435.yaw_random, v435.yaw_random)
            local v445 = v435.yaw_jitter_add + v444
            if (v442 == "Jitter") then
                v442 = "Static"
            elseif (v435.body_yaw_side == "Left") then
                v441 = 1
            elseif (v435.body_yaw_side == "Right") then
                v441 = 0
            else
                v441 = v440
            end
            local v446 = 0
            if (v435.yaw_jitter == "Offset") then
                if (v433.side == 1) then
                    v446 = v446 + v445
                end
            elseif (v435.yaw_jitter == "Center") then
                v446 = v446 + (((v433.side == 1) and (v445 / 2)) or (-v445 / 2)) + v444
            elseif (v435.yaw_jitter == "Random") then
                local v1080 = v19.random(0, v445) - (v445 / 2)
                if not v439 then
                    v446 = v446 + v1080
                    v433.last_rand = v1080
                else
                    v446 = v446 + v433.last_rand
                end
            elseif (v435.yaw_jitter == "Smoothnes") then
                local v1107 = v445
                local v1108 = v437[v435.jitter_delay] / 4
                local v1109 = v1107 * v19.sin((v26.curtime() / v1108) * v19.pi)
                v446 = v1109
            elseif (v435.yaw_jitter == "Fractal") then
                local v1132 = v445 * 2
                local v1133 = v437[v435.jitter_delay] * 0.5
                local v1134 = 0
                local v1135 = v435.yaw_fractals
                local v1136 = 0
                if (v1135 == 14) then
                    v1136 = v19.random(0, 13)
                else
                    v1136 = v1135
                end
                for v1148 = 1, v1136 do
                    v1134 = v1134 + ((0.5 ^ v1148) * v19.cos(((2 ^ v1148) * v1133 * v26.curtime() * 2 * v19.pi) + 10))
                end
                v446 = v1134 * v1132
            elseif (v435.yaw_jitter == "Skitter") then
                local v1149 = {0, 2, 1, 0, 2, 1, 0, 1, 2, 0, 1, 2, 0, 1, 2}
                local v1150
                if (v433.skitter_counter == #v1149) then
                    v433.skitter_counter = 1
                elseif not v439 then
                    v433.skitter_counter = v433.skitter_counter + 1
                end
                v1150 = v1149[v433.skitter_counter]
                v433.last_skitter = v1150
                if (v435.body_yaw == "jitter") then
                    v441 = v1150
                end
                if (v1150 == 0) then
                    v446 = (v446 - 16) - (v19.abs(v445) / 2)
                elseif (v1150 == 1) then
                    v446 = v446 + 16 + (v19.abs(v445) / 2)
                end
            end
            v446 = v446 + (((v441 == 0) and v435.yaw_add_r) or ((v441 == 1) and v435.yaw_add) or 0)
            if
                (v433.helpers:contains(v435.options, "Enable defensive") and
                    v433:get_defensive(v435.defensive_conditions, v436, v435))
             then
                v434.force_defensive = true
            end
            local v447 = v433.ui.menu.antiaim.edge_yaw:get_hotkey()
            v21.set(v433.ref.aa.freestand[1], false)
            v21.set(v433.ref.aa.edge_yaw[1], v447)
            v21.set(v433.ref.aa.freestand[2], "Always on")
            if v433.helpers:contains(v435.options, "Safe head") then
                local v989 = v24.get_local_player()
                local v990 = v22.current_threat()
                if v990 then
                    local v1053 = v24.get_player_weapon(v989)
                    if (v1053 and (v24.get_classname(v1053):find("Knife") or v24.get_classname(v1053):find("Taser"))) then
                        v446 = 0
                        v441 = 2
                    end
                end
            end
            if (v433.ui.menu.antiaim.manual_static:get() and ((v438 == -90) or (v438 == 90))) then
                v446 = 0
                v441 = 0
            end
            if v438 then
                v446 = v438
            elseif
                (v433.ui.menu.antiaim.freestanding:get_hotkey() and
                    not (v433.ui.menu.antiaim.freestanding:get("Disablers") and
                        v433.ui.menu.antiaim.freestanding_disablers:get(v436)))
             then
                v21.set(v433.ref.aa.freestand[1], true)
                if v433.ui.menu.antiaim.freestanding:get("Force static") then
                    v446 = 0
                    v441 = 0
                end
            elseif (v433.helpers:contains(v435.options, "Avoid backstab") and v433:anti_backstab()) then
                v446 = v446 + 180
            end
            local v448 =
                (((v433.defensive.ticks * v433.defensive.defensive) > 0) and
                v19.max(v433.defensive.defensive, v433.defensive.ticks)) or
                0
            local v449 = {
                {
                    speed = v435.defensive_yaw_way_speed1,
                    spin_limit = v435.defensive_yaw_way_spin_limit1,
                    enable_spin = v435.defensive_yaw_enable_way_spin1,
                    switch_value = v435.defensive_yaw_way_switch1
                },
                {
                    speed = v435.defensive_yaw_way_speed2,
                    spin_limit = v435.defensive_yaw_way_spin_limit2,
                    enable_spin = v435.defensive_yaw_enable_way_spin2,
                    switch_value = v435.defensive_yaw_way_switch2
                },
                {
                    speed = v435.defensive_yaw_way_speed3,
                    spin_limit = v435.defensive_yaw_way_spin_limit3,
                    enable_spin = v435.defensive_yaw_enable_way_spin3,
                    switch_value = v435.defensive_yaw_way_switch3
                },
                {
                    speed = v435.defensive_yaw_way_speed4,
                    spin_limit = v435.defensive_yaw_way_spin_limit4,
                    enable_spin = v435.defensive_yaw_enable_way_spin4,
                    switch_value = v435.defensive_yaw_way_switch4
                },
                {
                    speed = v435.defensive_yaw_way_speed5,
                    spin_limit = v435.defensive_yaw_way_spin_limit5,
                    enable_spin = v435.defensive_yaw_enable_way_spin5,
                    switch_value = v435.defensive_yaw_way_switch5
                }
            }
            local v450 = {
                {
                    speed = v435.defensive_pitch_way_speed1,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit11,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit12,
                    enable_spin = v435.defensive_pitch_enable_way_spin1,
                    switch_value = v435.defensive_pitch_custom
                },
                {
                    speed = v435.defensive_pitch_way_speed2,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit21,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit22,
                    enable_spin = v435.defensive_pitch_enable_way_spin2,
                    switch_value = v435.defensive_pitch_way2
                },
                {
                    speed = v435.defensive_pitch_way_speed3,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit31,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit32,
                    enable_spin = v435.defensive_pitch_enable_way_spin3,
                    switch_value = v435.defensive_pitch_way3
                },
                {
                    speed = v435.defensive_pitch_way_speed4,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit41,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit42,
                    enable_spin = v435.defensive_pitch_enable_way_spin4,
                    switch_value = v435.defensive_pitch_way4
                },
                {
                    speed = v435.defensive_pitch_way_speed5,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit51,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit52,
                    enable_spin = v435.defensive_pitch_enable_way_spin5,
                    switch_value = v435.defensive_pitch_way5
                }
            }
            local v451 = v26.tickcount() % 32
            if v435.defensive_yaw then
                if (v448 == 1) then
                end
                if ((v435.defensive_yaw_mode == "Jitter") and (v448 > 0)) then
                    local v1054 = v435.defensive_yaw_jitter_radius_1
                    local v1055 = v435.defensive_yaw_jitter_delay * 3
                    local v1056 = v435.defensive_yaw_jitter_random
                    if (v1055 == 1) then
                        v433.jitter_side = ((v433.jitter_side == -1) and 1) or -1
                    else
                        v433.jitter_side = (((((v26.tickcount() % v1055) * 2) + 1) <= v1055) and -1) or 1
                    end
                    v446 = (v433.jitter_side * v1054) + v19.random(-v1056, v1056)
                elseif ((v435.defensive_yaw_mode == "Random") and (v448 > 0)) then
                    local v1083 = v435.defensive_yaw_1_random
                    local v1084 = v435.defensive_yaw_2_random
                    v446 = v19.random(v1083, v1084)
                elseif ((v435.defensive_yaw_mode == "Custom spin") and (v448 > 0)) then
                    v433.spin_value = v433.spin_value + (8 * (v435.defensive_yaw_speedtick / 5))
                    if (v433.spin_value >= v435.defensive_yaw_spin_limit) then
                        v433.spin_value = 0
                    end
                    v446 = v433.spin_value
                elseif ((v435.defensive_yaw_mode == "Spin-way") and (v448 > 0)) then
                    local v1138 = v435.defensive_yaw_speed_Spin_way
                    local v1139 = v435.defensive_yaw_randomizer_Spin_way
                    local v1140 = v435.defensive_yaw_1_Spin_way
                    local v1141 = v435.defensive_yaw_2_Spin_way
                    local v1142 = 0
                    if (v451 >= (29 + v19.random(0, v1138))) then
                        v433.spin_way_180 = v433.spin_way_180 + 1
                        v433.random_spin_way = v19.random(-v1139, v1139)
                    end
                    if (v433.spin_way_180 == 0) then
                        v1142 = v1140 + v433.random_spin_way
                    elseif (v433.spin_way_180 == 1) then
                        v1142 = v1141 + v433.random_spin_way
                    end
                    if (v433.spin_way_180 == 2) then
                        v433.spin_way_180 = 0
                    end
                    local v1143 = v433.helpers:new_anim("antiaim_spin_way", v1142, 6)
                    v446 = v1143
                elseif ((v435.defensive_yaw_mode == "Switch 5-way") and (v448 > 0)) then
                    if (v451 >= (29 + v19.random(0, v435.defensive_yaw_way_delay))) then
                        v433.switch_way = v433.switch_way + 1
                        v433.switch_random =
                            v19.random(-v435.defensive_yaw_way_randomly_value, v435.defensive_yaw_way_randomly_value)
                    else
                        v446 = v433.last_way
                        if (v433.switch_way == #v449) then
                            v433.switch_way = 0
                        end
                    end
                    if ((v433.switch_way >= 0) and (v433.switch_way < #v449)) then
                        local v1168 = v449[v433.switch_way + 1]
                        v433.spin_way = v433.spin_way + (8 * (v1168.speed / 5))
                        if (v433.spin_way >= v1168.spin_limit) then
                            v433.spin_way = 0
                        end
                        if not v1168.enable_spin then
                            if v435.defensive_yaw_way_randomly then
                                v446 = v1168.switch_value + v433.switch_random
                                v433.last_way = v1168.switch_value + v433.switch_random
                            else
                                v446 = v1168.switch_value
                                v433.last_way = v1168.switch_value
                            end
                        else
                            v446 = v433.spin_way
                            v433.last_way = v433.spin_way
                        end
                    elseif (v433.switch_way == #v449) then
                        v433.switch_way = 0
                    end
                end
                if ((v435.defensive_pitch_mode == "Static") and (v448 > 0)) then
                    v443 = v435.defensive_pitch_custom
                elseif ((v435.defensive_pitch_mode == "Jitter") and (v448 > 0)) then
                    if (v19.random(0, 20) >= 10) then
                        v443 = v435.defensive_pitch_clock
                    else
                        v443 = v435.defensive_pitch_custom
                    end
                elseif ((v435.defensive_pitch_mode == "Spin") and (v448 > 0)) then
                    if (v435.defensive_pitch_custom < 0) then
                        v433.spin_pitch_def = v433.spin_pitch_def - (v435.defensive_pitch_speedtick / 5)
                    else
                        v433.spin_pitch_def = v433.spin_pitch_def + (v435.defensive_pitch_speedtick / 5)
                    end
                    if (v435.defensive_pitch_custom < 0) then
                        if (v433.spin_pitch_def <= v435.defensive_pitch_custom) then
                            v433.spin_pitch_def = v435.defensive_pitch_spin_limit2
                        end
                    elseif (v433.spin_pitch_def >= v435.defensive_pitch_custom) then
                        v433.spin_pitch_def = v435.defensive_pitch_spin_limit2
                    end
                    v443 = v433.spin_pitch_def
                elseif ((v435.defensive_pitch_mode == "Clocking") and (v448 > 0)) then
                    if (v451 >= 28) then
                        v433.spin_yaw = v433.spin_yaw + 15
                    end
                    if (v433.spin_yaw >= 89) then
                        v433.spin_yaw = -89
                    end
                    v443 = v433.spin_yaw
                elseif ((v435.defensive_pitch_mode == "Random") and (v448 > 0)) then
                    local v1162 = v435.defensive_pitch_custom
                    local v1163 = v435.defensive_pitch_spin_random2
                    v443 = v19.random(v1162, v1163)
                elseif ((v435.defensive_pitch_mode == "5way") and (v448 > 0)) then
                    if (v451 >= (29 + v19.random(0, v435.defensive_yaw_way_delay))) then
                        v433.switch_random_p =
                            v19.random(
                            -v435.defensive_pitch_way_randomly_value,
                            v435.defensive_pitch_way_randomly_value
                        )
                    else
                        v443 = v433.last_way
                    end
                    if ((v433.switch_way >= 0) and (v433.switch_way < #v450)) then
                        local v1178 = v450[v433.switch_way + 1]
                        if (v1178.spin_limit2 < 0) then
                            v433.spin_pitch = v433.spin_pitch - (8 * (v1178.speed / 5))
                        else
                            v433.spin_pitch = v433.spin_pitch + (8 * (v1178.speed / 5))
                        end
                        if (v1178.spin_limit2 < 0) then
                            if (v433.spin_pitch <= v1178.spin_limit2) then
                                v433.spin_pitch = v1178.spin_limit1
                            end
                        elseif (v433.spin_pitch >= v1178.spin_limit2) then
                            v433.spin_pitch = v1178.spin_limit1
                        end
                        if not v1178.enable_spin then
                            if v435.defensive_pitch_way_randomly then
                                v443 = v433.switch_random_p
                                v433.last_way = v433.switch_random_p
                            else
                                v443 = v1178.switch_value
                                v433.last_way = v1178.switch_value
                            end
                        else
                            v443 = v433.spin_pitch
                            v433.last_way = v433.spin_pitch
                        end
                    end
                end
            end
            v21.set(v433.ref.aa.enabled[1], true)
            v21.set(v433.ref.aa.pitch[1], ((v443 == "default") and v443) or "custom")
            v21.set(v433.ref.aa.pitch[2], v433.helpers:normalize_pitch(((v14(v443) == "number") and v443) or 0))
            v21.set(v433.ref.aa.yaw_base[1], v435.yaw_base)
            v21.set(v433.ref.aa.yaw[1], 180)
            v21.set(v433.ref.aa.yaw[2], v433.helpers:normalize_yaw(v446))
            v21.set(v433.ref.aa.yaw_jitter[1], "off")
            v21.set(v433.ref.aa.yaw_jitter[2], 0)
            v21.set(v433.ref.aa.body_yaw[1], v442)
            v21.set(v433.ref.aa.body_yaw[2], ((v441 == 2) and 0) or ((v441 == 1) and 90) or -90)
            if (v26.chokedcommands() == 0) then
                if (v433.cycle >= v437[v435.jitter_delay]) then
                    v433.cycle = 1
                else
                    v433.cycle = v433.cycle + 1
                end
            end
        end
    }
):struct("defensive")(
    {
        check = 0,
        defensive = 0,
        sim_time = v26.tickcount(),
        active_until = 0,
        ticks = 0,
        active = false,
        defensive_active = function(v452)
            local v453 = v24.get_local_player()
            if (not v453 or not v24.is_alive(v453)) then
                return
            end
            local v454 = v452.ui.menu.antiaim.states
            local v455 = v452.helpers:get_state()
            local v456 = v21.get(v452.ref.rage.dt[2])
            local v457 = v21.get(v452.ref.rage.os[2])
            local v458 = v454[v455].defensive_conditions
            if (not v454[v455].options:get("Enable defensive") or not (v456 or (v457 and v458:get("On hide-shots")))) then
                v452.check, v452.defensive = 0, 0
                return
            end
            local v459 = v24.get_prop(v24.get_local_player(), "m_nTickBase")
            v452.defensive = v19.abs(v459 - v452.check)
            v452.check = v19.max(v459, v452.check or 0)
            local v462 = v26.tickcount()
            local v463 = v24.get_prop(v453, "m_flSimulationTime")
            local v464 = v13(v463 - v452.sim_time)
            if (v464 < 0) then
                v452.active_until = v462 + v19.abs(v464)
            end
            v452.ticks = v43.clamp(v452.active_until - v462, 0, 16)
            v452.active = v452.active_until > v462
            v452.sim_time = v463
            v452.globals.tick = v452.defensive
        end,
        def_reset = function(v469)
            v469.check, v469.defensive = 0, 0
        end
    }
):struct("tools")(
    {
        widget_keylist = v41("keylist", 300, 100),
        widget_watermark = v41("watermark", 10, 10),
        scoped = 0,
        scoped_comp = 0,
        menu_setup = function(v472)
            local v473 = v472.ui.menu.tools.notify_offset:get()
            local v474, v475, v476, v477 = v472.ui.menu.global.color:get()
            v38.accent.r = v474
            v38.accent.g = v475
            v38.accent.b = v476
            v38.offset = v473
            if (v472.ui.menu.tools.style:get() == "New") then
                v38.new_style = true
            else
                v38.new_style = false
            end
            local v482 = v472.ui.menu.global.tab:get()
            local v483 = v472.ui.menu.antiaim.mode:get()
            local v484 = ((v482 == " Anti-Aim") and (v483 == "Constructor")) or (v482 == " Home")
            local v485 = {fakelag = v472.ref.fakelag, aa_other = v472.ref.aa_other}
            for v849, v850 in v3(v485) do
                local v851 = true
                if (v849 == "fakelag") then
                    v851 = false
                elseif (v849 == "aa_other") then
                    v851 = not v484
                end
                for v996, v997 in v3(v850) do
                    for v1031, v1032 in v2(v997) do
                        v21.set_visible(v1032, v851)
                    end
                end
            end
            if (v472.ref.fakelag.enable[1] ~= true) then
                v21.set(v472.ref.fakelag.enable[1], true)
            end
            v21.set(v472.ref.fakelag.amount[1], v472.ui.menu.antiaim.fakelag_type:get())
            v21.set(v472.ref.fakelag.variance[1], v472.ui.menu.antiaim.fakelag_var:get())
            v21.set(v472.ref.fakelag.limit[1], v472.ui.menu.antiaim.fakelag_lim:get())
        end,
        gs_ind = function(v486)
            if v486.helpers:contains(v486.ui.menu.tools.gs_inds:get(), "Target") then
                v28.indicator(255, 255, 255, 200, "Target: " .. v486.helpers:get_target())
            end
        end,
        crosshair = function(v487)
            local v488 = v24.get_local_player()
            if (not v488 or not v24.is_alive(v488)) then
                return
            end
            v487.scoped = v24.get_prop(v488, "m_bIsScoped")
            if not v487.ui.menu.tools.indicators:get() then
                return
            end
            local v490 = v487.ui.menu.tools.indicator_pos:get()
            v487.scoped_comp =
                v487.helpers:math_anim2(v487.scoped_comp, v487.scoped * (((v490 == "Left") and -1) or 1), 8)
            local v492 = v487.helpers:get_state()
            local v493, v494, v495, v496 = v38.accent.r, v38.accent.g, v38.accent.b
            local v497 = v487.ui.menu.tools.indicatorfont:get()
            local v498 = 0
            if (v497 == "Default") then
                v498 = 1
            elseif (v497 == "New") then
                v498 = 2
            elseif (v497 == "pastsense") then
                v498 = 3
            elseif (v497 == "Renewed") then
                v498 = 4
            elseif (v497 == "Icons") then
                v498 = 5
            end
            local v499 = v487.helpers:get_charge()
            local v500, v501, v502 = (v499 and 255) or v493, (v499 and 255) or v494, (v499 and 255) or v495
            local v503, v504, v505 = v487.helpers:animate_pulse({v493, v494, v495, 255}, 8)
            local v506 = {
                {
                    n = "DT",
                    c = {v500, v501, v502},
                    a = v21.get(v487.ref.rage.dt[1]) and v21.get(v487.ref.rage.dt[2]) and
                        not v21.get(v487.ref.rage.fd[1]),
                    s = v28.measure_text("-", "DT") + 13
                },
                {
                    n = "OSAA",
                    c = {255, 255, 255},
                    a = v21.get(v487.ref.rage.os[1]) and v21.get(v487.ref.rage.os[2]) and
                        not v21.get(v487.ref.rage.fd[1]),
                    s = v28.measure_text("-", "OSAA") + 13
                },
                {
                    n = "FAKE",
                    c = {v503, v504, v505},
                    a = v21.get(v487.ref.rage.fd[1]),
                    s = v28.measure_text("-", "FAKE") + 14
                },
                {
                    n = "FS",
                    c = {255, 255, 255},
                    a = v21.get(v487.ref.aa.freestand[1]) and v21.get(v487.ref.aa.freestand[2]),
                    s = v28.measure_text("-", "FS") + 13
                }
            }
            local v507 = v487.helpers:new_anim("indicator_pose", v487.ui.menu.tools.indicatoroffset:get(), 12)
            local v508 = 0
            local v509 = v487.antiaim:get_best_side()
            local v510 = v487.helpers:animate_text(v26.curtime() * 2, "pastsense", v493, v494, v495, 255)
            local v511 = v487.helpers:new_anim("indicator_mes_1", v28.measure_text("-", v492:upper()) or 0, 12)
            if (v498 == 1) then
                local v998 = v28.measure_text("c-", v38.build:upper())
                v28.text(
                    (v39 / 2) + (((v998 + 14) / 2) * v487.scoped_comp),
                    ((v40 / 2) + v507) - 10,
                    v493,
                    v494,
                    v495,
                    150,
                    "c-",
                    0,
                    v38.build:upper()
                )
                v28.text(
                    ((v39 / 2) - 22) + (30 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    0,
                    0,
                    0,
                    255,
                    "b",
                    0,
                    v15(v510)
                )
                v28.text(
                    (v39 / 2) + (((v511 + 14) / 2) * v487.scoped_comp),
                    (v40 / 2) + v507 + 13,
                    255,
                    255,
                    255,
                    255,
                    "c-",
                    0,
                    v492:upper()
                )
                for v1033, v1034 in v2(v506) do
                    local v1035 = v487.helpers:new_anim("indicators_alpha" .. v1034.n, (v1034.a and 255) or 0, 10)
                    local v1036 = v487.helpers:new_anim("indicators_pose_2" .. v1034.n, (v1034.a and 10) or 0, 10)
                    v508 = v508 + v1036
                    v28.text(
                        (v39 / 2) + ((v1034.s / 2) * v487.scoped_comp),
                        (v40 / 2) + v507 + v508 + 15,
                        v1034.c[1],
                        v1034.c[2],
                        v1034.c[3],
                        v1035,
                        "-ca",
                        nil,
                        v1034.n
                    )
                end
            elseif (v498 == 2) then
                local v1060, v1061, v1062 =
                    ((v509 == 2) and v493) or 200,
                    ((v509 == 2) and v494) or 200,
                    ((v509 == 2) and v495) or 200
                local v1063, v1064, v1065 =
                    ((v509 == 0) and v493) or 200,
                    ((v509 == 0) and v494) or 200,
                    ((v509 == 0) and v495) or 200
                v28.text(
                    ((v39 / 2) - 23) + (35 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    v1060,
                    v1061,
                    v1062,
                    255,
                    "b",
                    0,
                    "one"
                )
                v28.text(
                    ((v39 / 2) - 5) + (35 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    v1063,
                    v1064,
                    v1065,
                    255,
                    "b",
                    0,
                    "sense"
                )
                v28.text(
                    (v39 / 2) + 23 + (35 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    255,
                    255,
                    255,
                    255,
                    "b",
                    0,
                    "°"
                )
            elseif (v498 == 3) then
                local v1085, v1086, v1087 =
                    ((v509 == 2) and v493) or 200,
                    ((v509 == 2) and v494) or 200,
                    ((v509 == 2) and v495) or 200
                local v1088, v1089, v1090 =
                    ((v509 == 0) and v493) or 200,
                    ((v509 == 0) and v494) or 200,
                    ((v509 == 0) and v495) or 200
                local v1091, v1092, v1093 =
                    ((v509 == 1) and v493) or 255,
                    ((v509 == 1) and v494) or 255,
                    ((v509 == 1) and v495) or 255
                v28.text(
                    ((v39 / 2) - 33) + (45 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    255,
                    255,
                    255,
                    255,
                    "ab",
                    0,
                    "одно"
                )
                v28.text(
                    ((v39 / 2) - 5) + (45 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    v493,
                    v494,
                    v495,
                    255,
                    "ab",
                    0,
                    "чувство"
                )
                v28.text(
                    ((v39 / 2) - 11) + (23 * v487.scoped_comp),
                    (v40 / 2) + v507 + 6,
                    v1085,
                    v1086,
                    v1087,
                    255,
                    "ab",
                    0,
                    "•"
                )
                v28.text(
                    ((v39 / 2) - 3) + (23 * v487.scoped_comp),
                    (v40 / 2) + v507 + 6,
                    v1088,
                    v1089,
                    v1090,
                    255,
                    "ab",
                    0,
                    "•"
                )
                v28.text(
                    (v39 / 2) + 5 + (23 * v487.scoped_comp),
                    (v40 / 2) + v507 + 6,
                    v1091,
                    v1092,
                    v1093,
                    255,
                    "ab",
                    0,
                    "•"
                )
                if v487.ui.menu.tools.indicator_bind:get() then
                    for v1118, v1119 in v2(v506) do
                        local v1120 = v487.helpers:new_anim("indicators_alpha" .. v1119.n, (v1119.a and 255) or 0, 10)
                        local v1121 = v487.helpers:new_anim("indicators_pose_2" .. v1119.n, (v1119.a and 13) or 0, 10)
                        v508 = v508 + v1121
                        v28.text(
                            (v39 / 2) + (((v1119.s / 2) + 5) * v487.scoped_comp),
                            (v40 / 2) + v507 + v508 + 15,
                            v1119.c[1],
                            v1119.c[2],
                            v1119.c[3],
                            v1120,
                            "ca",
                            nil,
                            v1119.n:lower()
                        )
                    end
                end
            elseif (v498 == 4) then
                local v1114 = "₊‧.°.⋆✦⋆.°.₊"
                v28.text(
                    ((v39 / 2) - 27) + (35 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 13,
                    v493,
                    v494,
                    v495,
                    200,
                    "ab",
                    0,
                    v1114
                )
                v28.text(
                    ((v39 / 2) - 22) + (35 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 6,
                    255,
                    255,
                    255,
                    255,
                    "ab",
                    0,
                    v15(v510)
                )
                v28.text(
                    (v39 / 2) + (((v511 + 28) / 2) * v487.scoped_comp),
                    (v40 / 2) + v507 + 13,
                    255,
                    255,
                    255,
                    255,
                    "ac",
                    0,
                    v492
                )
                for v1122, v1123 in v2(v506) do
                    local v1124 = v487.helpers:new_anim("indicators_alpha" .. v1123.n, (v1123.a and 255) or 0, 10)
                    local v1125 = v487.helpers:new_anim("indicators_pose_2" .. v1123.n, (v1123.a and 13) or 0, 10)
                    v508 = v508 + v1125
                    v28.text(
                        (v39 / 2) + (((v1123.s / 2) + 8) * v487.scoped_comp),
                        (v40 / 2) + v507 + v508 + 15,
                        v1123.c[1],
                        v1123.c[2],
                        v1123.c[3],
                        v1124,
                        "ca",
                        nil,
                        v1123.n:lower()
                    )
                end
            elseif (v498 == 5) then
                local v1147 = v487.helpers:animate_text(v26.curtime() * 2, "pastsense", v493, v494, v495, 255)
                v28.texture(
                    v42,
                    ((v39 / 2) - 29) + (37 * v487.scoped_comp),
                    ((v40 / 2) + v507) - 4,
                    11,
                    11,
                    v493,
                    v494,
                    v495,
                    255
                )
                v28.text(
                    (v39 / 2) + 4 + (37 * v487.scoped_comp),
                    (v40 / 2) + v507,
                    255,
                    255,
                    255,
                    255,
                    "ac",
                    0,
                    v15(v1147)
                )
                v28.text(
                    (v39 / 2) + (((v511 + 28) / 2) * v487.scoped_comp),
                    (v40 / 2) + v507 + 13,
                    255,
                    255,
                    255,
                    255,
                    "ac",
                    0,
                    "-" .. v492 .. "-"
                )
            end
        end,
        view_x = 1,
        view_y = 1,
        view_z = -1,
        view_fov = 60,
        viewmodel = function(v512)
            local v513 = v24.get_local_player()
            local v514 = v512.ui.menu.tools.viewmodel_on:get()
            local v515 = v512.ui.menu.tools.viewmodel_scope:get()
            if not v24.is_alive(v513) then
                return
            end
            local v516 = v24.get_player_weapon(v513)
            if (v516 == nil) then
                return
            end
            local v517 = v24.get_prop(v516, "m_iItemDefinitionIndex")
            local v518 = v48(v47, v517)
            v518.hide_vm_scope = not v515
            if not v514 then
                return
            end
            local v520 = v512.ui.menu.tools.viewmodel_x1:get()
            local v521 = v512.ui.menu.tools.viewmodel_y1:get()
            local v522 = v512.ui.menu.tools.viewmodel_z1:get()
            local v523 = v512.ui.menu.tools.viewmodel_fov1:get()
            local v524 = v512.ui.menu.tools.viewmodel_x2:get()
            local v525 = v512.ui.menu.tools.viewmodel_y2:get()
            local v526 = v512.ui.menu.tools.viewmodel_z2:get()
            local v527 = v512.ui.menu.tools.viewmodel_fov2:get()
            if (v512.scoped == 1) then
                if v512.ui.menu.tools.viewmodel_inscope:get() then
                    v512.view_x = v524
                    v512.view_y = v525
                    v512.view_z = v526
                    v512.view_fov = v527
                end
            else
                v512.view_x = v520
                v512.view_y = v521
                v512.view_z = v522
                v512.view_fov = v523
            end
            v22.set_cvar("viewmodel_offset_x", v512.helpers:new_anim("view_x1", v512.view_x, 11))
            v22.set_cvar("viewmodel_offset_y", v512.helpers:new_anim("view_y1", v512.view_y, 11))
            v22.set_cvar("viewmodel_offset_z", v512.helpers:new_anim("view_z1", v512.view_z, 11))
            v22.set_cvar("viewmodel_fov", v512.helpers:new_anim("view_fov1", v512.view_fov, 11))
        end,
        manuals = function(v528)
            local v529 = v24.get_local_player()
            local v530 = ""
            local v531 = ""
            if (v528.ui.menu.tools.manuals_style:get() == "pastsense") then
                v530 = "‹"
                v531 = "›"
            elseif (v528.ui.menu.tools.manuals_style:get() == "New") then
                v530 = "«"
                v531 = "»"
            end
            if not v24.is_alive(v529) then
                return
            end
            local v532 = v528.antiaim:get_manual()
            local v533 = v528.antiaim:get_best_side()
            local v534, v535, v536, v537 = v38.accent.r, v38.accent.g, v38.accent.b
            local v538 =
                v528.helpers:new_anim("alpha_manual_global", (v528.ui.menu.tools.manuals_global:get() and 255) or 0, 16)
            local v539 = v528.helpers:new_anim("manual_scope", ((v528.scoped == 1) and 15) or 0, 8)
            local v540 = v528.helpers:new_anim("alpha_manual_right", ((v532 == 90) and 255) or 0, 16)
            local v541 = v528.helpers:new_anim("alpha_manual_left", ((v532 == -90) and 255) or 0, 16)
            local v542 = v528.helpers:new_anim("alpha_manual_right_global", ((v533 == 0) and 255) or 0, 8)
            local v543 = v528.helpers:new_anim("alpha_manual_left_global", ((v533 == 2) and 255) or 0, 8)
            local v544 = v528.helpers:new_anim("alpha_manual_offset", -v528.ui.menu.tools.manuals_offset:get() - 25, 12)
            v28.text((v39 / 2) + v544, ((v40 / 2) - 16) - v539, v534, v535, v536, v541, "d+", 0, v530)
            v28.text(((v39 / 2) - v544) - 11, ((v40 / 2) - 16) - v539, v534, v535, v536, v540, "d+", 0, v531)
            if (v538 < 0.1) then
                return
            end
            v28.text(
                (v39 / 2) + v544 + 11,
                ((v40 / 2) - 16) - v539,
                v534,
                v535,
                v536,
                v543 * (v538 / 255),
                "d+",
                0,
                v530
            )
            v28.text(
                ((v39 / 2) - v544) - 22,
                ((v40 / 2) - 16) - v539,
                v534,
                v535,
                v536,
                v542 * (v538 / 255),
                "d+",
                0,
                v531
            )
        end,
        ind_dmg = function(v545)
            local v546 = v24.get_local_player()
            if not v24.is_alive(v546) then
                return
            end
            local v547, v548, v549, v550 = v545.ui.menu.tools.indicator_dmg_color:get()
            local v551 = v545.ui.menu.tools.indicator_dmg_weapon:get()
            local v552 = v19.floor(v545.helpers:new_anim("dmg_indicator", v545.helpers:get_damage() + 0.1, 8))
            local v553 = ""
            if v545.ref.rage.ovr[2] then
                if v551 then
                    if v21.get(v545.ref.rage.ovr[2]) then
                        v553 = v545.helpers:get_damage()
                    else
                        v553 = ""
                    end
                elseif v21.get(v545.ref.rage.ovr[2]) then
                    v553 = v552
                else
                    v553 = v552
                end
            end
            v28.text((v39 / 2) + 5, (v40 / 2) - 17, v547, v548, v549, 255, "d", 0, v553 .. "")
        end,
        scopedu = function(v554)
            if not v554.ui.menu.tools.animscope:get() then
                return
            end
            local v555 = v24.get_local_player()
            local v556 = v554.ui.menu.tools.animscope_slider:get()
            local v557 = v554.ui.menu.tools.animscope_fov_slider:get()
            local v558 = v554.helpers:new_anim("animated_scoped", ((v554.scoped == 1) and v556) or 0, 8)
            if (v21.get(v554.ref.misc.override_zf) > 0) then
                v21.set(v554.ref.misc.override_zf, 0)
            end
            v21.set(v554.ref.misc.fov, v557 - v558)
        end,
        watermark = function(v559)
            local v560, v561, v562, v563 = v38.accent.r, v38.accent.g, v38.accent.b
            local v564, v565 = v559.widget_watermark:get(65, 10)
            local v566 = v38.build
            local v567, v568, v569 = 15, 15, 15
            local v570 = v38.name
            local v571, v572 = v22.system_time()
            local v573 = v20.format("%02d:%02d", v571, v572)
            local v574 = v19.floor(v22.latency() * 1000)
            local v575 = v28.measure_text("ca", v566)
            local v576 = v28.measure_text("ca", v570)
            local v577 = v28.measure_text("ca", v573)
            local v578 = v28.measure_text("ca", v574)
            local v579 = v575 - 38
            local v580 = 125 + v576
            if (v559.ui.menu.tools.style:get() == "Default") then
                v559.helpers:rounded_side_v(v564 - 100, v565 - 5, 1200 + v579, 45, v567, v568, v569, 260, 6, true, true)
                v559.helpers:rounded_side_v(
                    v564 + v579 + 31,
                    v565 - 25,
                    v580 + (v578 - 18),
                    45,
                    v567,
                    v568,
                    v569,
                    160,
                    15,
                    true,
                    true
                )
                v28.text(
                    v564 + v579 + 144 + v576 + (v577 / 2) + (v578 - 8),
                    v565 + 7,
                    255,
                    255,
                    255,
                    255,
                    "ca",
                    nil,
                    v573
                )
                v28.text(v564 + v579 + 135 + v576 + (v578 - 8), v565 + 7, v560, v561, v562, 255, "bca", nil, "•")
                v28.text(
                    v564 + v579 + 105 + v576 + (v578 / 2),
                    v565 + 7,
                    255,
                    255,
                    255,
                    255,
                    "ca",
                    nil,
                    v574 .. " ping"
                )
                v28.text(v564 + v579 + 84 + v576, v565 + 7, v560, v561, v562, 255, "bca", nil, "•")
                v28.text(v564 + v579 + 75 + (v576 / 2), v565 + 7, 255, 255, 255, 255, "ca", nil, v570)
                v28.text(v564 + v579 + 65, v565 + 7, v560, v561, v562, 255, "bca", nil, "•")
                v28.text(v564 - 30, v565 + 7, 255, 255, 255, 255, "ca", nil, "pastsense")
                v28.text(v564 + (v575 / 2), v565 + 7, v560, v561, v562, 255, "ca", nil, v566)
            else
                v43.rect_v(v564 - 60, v565 - 5, 105 + v579, 25, {v567, v568, v569, 160}, 6, {v560, v561, v562, 255})
                v43.rect_v(
                    v564 + v579 + 51,
                    v565 - 5,
                    v580 + (v578 - 63),
                    25,
                    {v567, v568, v569, 160},
                    6,
                    {v560, v561, v562, 255}
                )
                v43.rect_v(
                    v564 + v579 + v578 + v576 + 119,
                    v565 - 5,
                    v577 + 17,
                    25,
                    {v567, v568, v569, 160},
                    6,
                    {v560, v561, v562, 255}
                )
                v28.text(
                    v564 + v579 + 135 + v576 + (v577 / 2) + (v578 - 8),
                    v565 + 7,
                    255,
                    255,
                    255,
                    255,
                    "ca",
                    nil,
                    v573
                )
                v28.text(v564 + v579 + 90 + v576 + (v578 / 2), v565 + 7, 255, 255, 255, 255, "ca", nil, v574 .. " ping")
                v28.text(v564 + v579 + 70 + v576, v565 + 7, v560, v561, v562, 255, "ca", nil, "/")
                v28.text(v564 + v579 + 60 + (v576 / 2), v565 + 7, 255, 255, 255, 255, "ca", nil, v570)
                v28.text(v564 - 53, v565 + 1, 255, 255, 255, 255, "a", nil, "pastsense")
                v28.text(v564 + (v575 - v575), v565 + 1, v560, v561, v562, 255, "a", nil, v566)
            end
            v559.widget_watermark:drag(v580 + v575 + v576 + v577 + v578 + 5, 35)
        end,
        draw = false,
        keylist = function(v581)
            local v582, v583, v584, v585 = v38.accent.r, v38.accent.g, v38.accent.b
            local v586 = v581.helpers:new_anim("alpha_keybinds", (v581.draw and 160) or 0, 8)
            local v587 = 95
            if
                (not v21.is_menu_open() and not v21.get(v581.ref.rage.dt[2]) and not v21.get(v581.ref.rage.os[2]) and
                    not v21.get(v581.ref.rage.ovr[2]) and
                    not v21.get(v581.ref.aa.freestand[1]) and
                    not v21.get(v581.ref.rage.fd[1]))
             then
                v581.draw = false
            else
                v581.draw = true
            end
            if (v586 < 0.1) then
                return
            end
            local v588, v589 = v581.widget_keylist:get(25, 10)
            local v590 = 0
            local v591 = {
                {
                    n = "Double Tap",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.dt[1]) and v21.get(v581.ref.rage.dt[2]) and
                        not v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c", "Double tap")
                },
                {
                    n = "Hide Shots",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.os[1]) and v21.get(v581.ref.rage.os[2]) and
                        not v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c", "Hide shots") + 1
                },
                {
                    n = "Fake Duck",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c", "Fake duck") + 3
                },
                {
                    n = "Min. Damage",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.ovr[1]) and v21.get(v581.ref.rage.ovr[2]),
                    s = v28.measure_text("c", "Min dmg") + 16
                },
                {
                    n = "Edge yaw",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.aa.edge_yaw[1]) and v581.ui.menu.antiaim.edge_yaw:get_hotkey(),
                    s = v28.measure_text("c", "Edge yaw") + 3
                },
                {
                    n = "Freestand",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.aa.freestand[1]) and v21.get(v581.ref.aa.freestand[2]),
                    s = v28.measure_text("c", "Freestand") + 3
                }
            }
            local v592 = v581.ui.menu.tools.style:get() == "Default"
            if v592 then
                v581.helpers:rounded_side_v(v588 - 20, v589 - 5, v587, 25, 15, 15, 15, v586, 6, true, true)
            else
                v43.rect_v(v588 - 20, v589 - 5, v587 + 6, 25, {15, 15, 15, v586}, 6, {v582, v583, v584, v586})
            end
            local v593 = v586 / 160
            v28.rectangle(v588 + 8, v589 - 5, 1, 25 - ((v592 and 0) or 1), 255, 255, 255, 25 * v593)
            v28.texture(
                v581.globals.keylist_icon,
                v588 - 15,
                v589 - ((v592 and 0) or 1),
                15,
                15,
                255,
                255,
                255,
                255 * v593
            )
            v28.text(v588 + 35, (v589 + 7) - ((v592 and 0) or 1), 255, 255, 255, 255 * v593, "ca", nil, "Hotkeys")
            for v852, v853 in v2(v591) do
                local v854 = v581.helpers:new_anim("alpha_rect_keybinds" .. v853.n, (v853.a and 130) or 0, 8)
                local v855 = v581.helpers:new_anim("alpha_text_keybinds" .. v853.n, (v853.a and 255) or 0, 8)
                local v856 = v28.measure_text("ca", v21.get(v581.ref.rage.ovr[3])) - 12
                local v857 = v581.helpers:new_anim("move_keybinds" .. v853.n, (v853.a and 20) or 0, 12)
                v590 = v590 + v857
                v581.helpers:rounded_side_v(
                    v588 - 20,
                    v589 + 3 + v590,
                    v587,
                    18,
                    15,
                    15,
                    15,
                    v854 * v593,
                    6,
                    true,
                    true
                )
                if (v853.n == "Min. Damage") then
                    v28.text(
                        (v588 + (v587 - 27)) - (v856 / 2),
                        v589 + 11 + v590,
                        v582,
                        v583,
                        v584,
                        v855 * v593,
                        "ca",
                        nil,
                        v21.get(v581.ref.rage.ovr[3])
                    )
                else
                    v28.text(v588 + (v587 - 27), v589 + 11 + v590, v582, v583, v584, v855 * v593, "ca", nil, "on")
                end
                v28.text(
                    (v588 - 40) + v853.s,
                    v589 + 11 + v590,
                    v853.c[1],
                    v853.c[2],
                    v853.c[3],
                    v855 * v593,
                    "ca",
                    nil,
                    v853.n
                )
            end
            v581.widget_keylist:drag(v587 + 16, 35)
        end
    }
):struct("round_reset")(
    {auto_buy = function(v594)
            if not v594.ui.menu.tools.autobuy:get() then
                return
            end
            if (v594.ui.menu.tools.autobuy_v:get() == "Awp") then
                v22.exec("buy awp")
            elseif (v594.ui.menu.tools.autobuy_v:get() == "Scar/g3sg1") then
                v22.exec("buy g3sg1")
                v22.exec("buy scar20")
            elseif (v594.ui.menu.tools.autobuy_v:get() == "Scout") then
                v22.exec("buy ssg08")
            end
        end}
):struct("custom_gs")(
    {
        table = {binds = {}},
        y = 0,
        add = function(v595, v596, v597, v598)
            enabled_color = {[1] = 230, [2] = 230, [3] = 230, [4] = 230}
            disabled_color = {[1] = 155, [2] = 155, [3] = 155, [4] = 0}
            v595.table.binds[#v595.table.binds + 1] = {
                full_icon = v596,
                name = v20.sub(v597, 1, 2),
                full_name = v597,
                ref = v598,
                chars = 0,
                alpha = 0
            }
        end,
        text = function(v600, v601, v602, v603, v604, v605, v606, v607, v608, v609, v610, v611, v612, v613, v614)
            if (v614 == nil) then
                v614 = 1
            end
            if (v614 <= 0) then
                return
            end
            local v615 = v31(v28.measure_text("+", v611))
            local v616 = v31(v28.measure_text("+", v612))
            local v617, v618 = v22.screen_size()
            local v619 = v19.floor(v616.x / 2)
            local v602 = v602 + (v618 / 2) + 50
            v28.gradient(4, v602 + v616.y, v619 + 24, v616.y + 4, 5, 5, 5, 0, 5, 5, 5, 55 * v614, true)
            v28.gradient(28 + v619, v602 + v616.y, 29 + v619, v616.y + 4, 5, 5, 5, 55 * v614, 5, 5, 5, 0, true)
            v28.text(v601 * v614, v602 + v615.y, v607, v608, v609, v610 * v613, "+", nil, v611)
            v28.text(v601 + (v615.x * v613), v602 + v615.y + 1, v603, v604, v605, v606, "+", nil, v612)
            v600.y = v600.y + (40 * v614)
        end,
        clamp = function(v621, v622)
            return v19.max(0, v19.min(255, v622))
        end,
        general = function(v623)
            local v624 = v24.get_local_player()
            if ((v624 == nil) or not v624) then
                return
            end
            local v625 = v623.helpers:get_charge()
            v623.y = 15
            local v627 = v19.floor(v22.latency() * 1000)
            local v628 = v24.is_alive(v624)
            for v858, v859 in v2(v623.table.binds) do
                local v860 = v859.full_icon
                local v861 = (v623.ui.menu.tools.gs_ind:get() and v623.ui.menu.tools.gs_inds:get("Target")) or false
                local v862 = v21.get(v859.ref)
                local v863 = v860 == "t"
                local v864 = 0
                if v628 then
                    if (v863 and v861) then
                        v864 = 1
                    elseif v862 then
                        v864 = 1
                    end
                end
                local v865 = v623.helpers:math_anim2(v859.alpha, v864, 6)
                local v866 = v623.helpers:math_anim2(v859.chars, (v628 and v862 and 1) or 0, 6)
                local v867, v868, v869, v870 = 255, 255, 255, 255
                local v871 = v859.full_name
                local v872 = {v867, v868, v869, v870}
                if (v871 == "DT") then
                    v860 = (v625 and " ") or " "
                    v872 = {[1] = 140, [2] = 140 * ((v625 and 1) or 0), [3] = 170 * ((v625 and 1) or 0), [4] = v870}
                elseif (v871 == "PING") then
                    if (v627 < 55) then
                        v872[1] = v623:clamp(255 - ((70 - v627) * 2))
                        v872[3] = v623:clamp(255 - ((70 - v627) * 2))
                    elseif (v627 < 55) then
                        v872[1] = 255
                        v872[2] = 255
                        v872[3] = v623:clamp(255 - ((v627 - 70) * 17))
                    else
                        v872[1] = 255
                        v872[2] = v623:clamp(255 - ((v627 - 85) * 8))
                        v872[3] = 0
                    end
                    v872[4] = 255
                elseif (v871 == "OS") then
                    v860 = (v625 and " ") or "⭙ "
                    v872 = {[1] = 140, [2] = 140 * ((v625 and 1) or 0), [3] = 170 * ((v625 and 1) or 0), [4] = v870}
                elseif (v871 == "MD") then
                    v872 = {[1] = 191, [2] = 165, [3] = 170, [4] = v870}
                elseif (v871 == "FD") then
                    v872 = {[1] = 96, [2] = 156, [3] = 216, [4] = v870}
                elseif (v871 == "FS") then
                    v872 = {[1] = 198, [2] = 124, [3] = 158, [4] = v870}
                elseif (v860 == "t") then
                    v871 = "Target: " .. v623.helpers:get_target()
                end
                v623:text(
                    25,
                    v623.y,
                    v872[1],
                    v872[2],
                    v872[3],
                    v872[4] * v865,
                    v872[1],
                    v872[2],
                    v872[3],
                    v872[4] * v865,
                    v860,
                    v871,
                    v866,
                    v865
                )
                v623.table.binds[v858].alpha = v865
                v623.table.binds[v858].name = v871
                v623.table.binds[v858].chars = v866
                v623.table.binds[v858].color = v867, v868, v869, v870
            end
        end,
        create = function(v629)
            v629:add("t", "Target", v629.ref.misc.log[1])
            v629:add(" ", "DT", v629.ref.rage.dt[2])
            v629:add(" ", "OS", v629.ref.rage.os[2])
            v629:add(" ", "MD", v629.ref.rage.ovr[2])
            v629:add(" ", "FD", v629.ref.rage.fd[1])
            v629:add(" ", "FS", v629.ref.aa.freestand[1])
            v629:add(" ", "BA", v629.ref.rage.baim[1])
            v629:add(" ", "SAFE", v629.ref.rage.safe[1])
            v629:add(" ", "PING", v629.ref.rage.always[1])
        end
    }
):struct("misc")(
    {
        charged = false,
        call_reg = false,
        jumpscout = false,
        unsafe_charge = function(v630)
            local v631 = v630.ui.menu.tools.unsafe_charge:get()
            local v632 = v630.ref.rage.enable
            if not v631 then
                if v630.call_reg then
                    v21.set(v632, true)
                    v630.call_reg = false
                end
                return
            end
            local v633 = v24.get_local_player()
            if not v630.call_reg then
                v630.call_reg = true
            end
            local v634 = v22.current_threat()
            if
                (v21.get(v630.ref.rage.dt[2]) and v634 and not v630.jumpscout and v630.helpers:in_air(v633) and
                    v630.helpers:entity_has_flag(v634, "HIT"))
             then
                if (v21.get(v632) == true) then
                    v21.set(v632, false)
                end
            elseif (v21.get(v632) == false) then
                v21.set(v632, true)
            end
        end,
        air_stopchance = function(v635, v636)
            local v637 = v635.ui.menu.tools.air_stop
            if (not v637:get() or not v637:get_hotkey()) then
                v635.jumpscout = false
                return
            end
            local v638 = v24.get_local_player()
            if (not v638 or not v24.is_alive(v638)) then
                return
            end
            local v639 = v635.ui.menu.tools.air_stop_distance:get() * 5
            local v640 = v29.band(v24.get_prop(v24.get_player_weapon(v638), "m_iItemDefinitionIndex"), 65535)
            local v641 = v24.get_players(true)
            for v877 = 1, #v641 do
                if (v641 == nil) then
                    return
                end
                local v878, v879, v880 = v24.get_prop(v638, "m_vecOrigin")
                local v881, v882, v883 = v24.get_prop(v641[v877], "m_vecOrigin")
                local v884 = v635.helpers:distance(v878, v879, v880, v881, v882, v883) / 11.91
                if ((v884 < v639) and (v640 == 40)) then
                    if v635.helpers:in_air(v638) then
                        if v636.quick_stop then
                            v635.jumpscout = true
                            v636.in_speed = 1
                        end
                    end
                else
                    v635.jumpscout = false
                end
            end
        end,
        phrases = {
            kill = {
                "1, ПАСТАСЕНС ОВНИТ - discord.gg/fastleaks",
                "ПАСТАСЕНС ОВНИТ"
            },
            death = {
                "ТЫ КАК ПАСТАСЕНС 1.7 УБИЛ :(",
                "ТЫ КАК ПАСТАСЕНС 1.7 УБИЛ :("
            }
        },
        fast_ladder = function(v642, v643)
            local v644 = v24.get_local_player()
            local v645, v646 = v22.camera_angles()
            local v647 = v24.get_prop(v644, "m_MoveType")
            if (v647 == 9) then
                v643.yaw = v19.floor(v643.yaw + 0.5)
                v643.roll = 0
                if (v643.forwardmove > 0) then
                    if (v645 < 45) then
                        v643.pitch = 89
                        v643.in_moveright = 1
                        v643.in_moveleft = 0
                        v643.in_forward = 0
                        v643.in_back = 1
                        if (v643.sidemove == 0) then
                            v643.yaw = v643.yaw + 90
                        end
                        if (v643.sidemove < 0) then
                            v643.yaw = v643.yaw + 150
                        end
                        if (v643.sidemove > 0) then
                            v643.yaw = v643.yaw + 30
                        end
                    end
                end
                if (v643.forwardmove < 0) then
                    v643.pitch = 89
                    v643.in_moveleft = 1
                    v643.in_moveright = 0
                    v643.in_forward = 1
                    v643.in_back = 0
                    if (v643.sidemove == 0) then
                        v643.yaw = v643.yaw + 90
                    end
                    if (v643.sidemove > 0) then
                        v643.yaw = v643.yaw + 150
                    end
                    if (v643.sidemove < 0) then
                        v643.yaw = v643.yaw + 30
                    end
                end
            end
        end,
        trashtalk = function(v648, v649)
            local v650 = v24.get_local_player()
            local v651 = v22.userid_to_entindex(v649.userid)
            local v652 = v22.userid_to_entindex(v649.attacker)
            if (v650 == nil) then
                return
            end
            if ((v652 == v650) and (v651 ~= v650)) then
                if (v648.ui.menu.tools.trashtalk_type:get() == "Default type") then
                    v22.delay_call(
                        1,
                        function()
                            v22.exec(("say %s"):format(v648.phrases.kill[v19.random(0, #v648.phrases.kill)]))
                        end
                    )
                elseif (v648.ui.menu.tools.trashtalk_type:get() == "1 MOD") then
                    if v648.ui.menu.tools.trashtalk_check2:get() then
                        v22.exec(("say %s, 1"):format(v24.get_player_name(v651)))
                    else
                        v22.exec("say 1")
                    end
                elseif (v648.ui.menu.tools.trashtalk_type:get() == "Custom phrase") then
                    v22.exec("say " .. v648.ui.menu.tools.trashtalk_custom:get())
                end
            end
            if ((v652 ~= v650) and (v651 == v650)) then
                v22.delay_call(
                    2,
                    function()
                        v22.exec(("say %s"):format(v648.phrases.death[v19.random(0, #v648.phrases.death)]))
                    end
                )
            end
        end
    }
):struct("logs")(
    {
        hitboxes = {
            [0] = "body",
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
        },
        miss = function(v653, v654)
            local v655, v656, v657 = v38.accent.r, v38.accent.g, v38.accent.b
            local v658 = v24.get_player_name(v654.target)
            local v659 = v653.hitboxes[v654.hitgroup] or "?"
            local v660 = v653.helpers:limit_ch(v658, 15, "...")
            local v661 = v26.tickcount() - v654.tick
            local v662 = v19.floor(v654.hit_chance)
            v44.create_new({{"Missed "}, {v660, true}, {"'s in "}, {v659, true}, {" due "}, {v654.reason, true}})
            v22.color_log(
                v655,
                v656,
                v657,
                v20.format(
                    "[pastsense] ~ Missed %s in %s due to %s (hc: %s, bt: %s)",
                    v658,
                    v659,
                    v654.reason,
                    v662,
                    v661
                )
            )
        end,
        hit = function(v663, v664, v665)
            local v666, v667, v668 = v38.accent.r, v38.accent.g, v38.accent.b
            local v669 = v24.get_player_name(v664.target)
            local v670 = v663.hitboxes[v664.hitgroup] or "?"
            local v671 = v663.helpers:limit_ch(v669, 15, "...")
            local v672 = v19.max(0, v24.get_prop(v664.target, "m_iHealth"))
            local v673 = v664.damage
            local v674 = v26.tickcount() - v664.tick
            local v675 = v19.floor(v664.hit_chance)
            v44.create_new({{"Hit "}, {v671, true}, {"'s in "}, {v670, true}, {" for "}, {v673, true}})
            v22.color_log(
                v666,
                v667,
                v668,
                v20.format(
                    "[pastsense] ~ Hit %s in %s for %s (remaning hp %s, hc: %s, bt: %s)",
                    v669,
                    v670,
                    v673,
                    v672,
                    v675,
                    v674
                )
            )
        end,
        shot = 0,
        evade = function(v676, v677)
            local v678 = v24.get_local_player()
            local v679, v680, v681 = v38.accent.r, v38.accent.g, v38.accent.b
            if (v678 == nil) then
                return
            end
            local v682 = v22.userid_to_entindex(v677.userid)
            local v683 = v24.get_player_name(v682)
            local v684 = v19.floor(v22.latency() * 1000)
            local v685 = v676.antiaim:get_best_side()
            if ((v682 == v24.get_local_player()) or not v24.is_enemy(v682) or not v24.is_alive(v678)) then
                return nil
            end
            if v676.helpers:fired_shot(v678, v682, {v677.x, v677.y, v677.z}) then
                if (v676.shot ~= v26.tickcount()) then
                    v22.color_log(
                        v679,
                        v680,
                        v681,
                        v20.format("[pastsense] ~ Detected %s shot (%s ms, anti-aim side: %s)", v683, v684, v685)
                    )
                    v44.create_new({{"Detected "}, {v683, true}, {"'s shot "}, {"(" .. v684 .. "ms)", true}})
                end
                v676.shot = v26.tickcount()
            end
        end,
        evade2 = function(v686, v687)
            local v688 = v24.get_local_player()
            if (v688 == nil) then
                return
            end
            if ((enemy == v24.get_local_player()) or not v24.is_enemy(enemy) or not v24.is_alive(v688)) then
                return nil
            end
            if v686.helpers:fired_shot(v688, enemy, {v687.x, v687.y, v687.z}) then
                v686.defensive:def_reset()
            end
        end,
        harmed = function(v689, v690)
            local v691 = v24.get_local_player()
            local v692 = v22.userid_to_entindex(v690.attacker)
            local v693 = v22.userid_to_entindex(v690.userid)
            local v694 = v690.dmg_health
            local v695 = v24.get_player_name(v692)
            local v696 = v689.hitboxes[v690.hitgroup]
            if (v692 == v691) then
                return
            end
            if (v693 ~= v691) then
                return
            end
            v44.create_new({{"Get " .. v694 .. " damage by "}, {v695 .. "'s in " .. v696, true}})
        end
    }
):struct("unloads")(
    {setup = function(v697)
            local v698 = v697.ui.menu.tools.animscope:get()
            local v699 = v697.ui.menu.tools.animscope_fov_slider:get()
            if v698 then
                v21.set(v697.ref.misc.fov, v699)
            end
            v697.ui:shutdown()
            v21.set(v697.ref.rage.enable, true)
        end}
)
for v700, v701 in v2(
    {{"load", function()
                v50.ui:execute()
                v50.config:setup()
                v50.custom_gs:create()
            end}, {"aim_miss", function(shot)
                if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Miss")) then
                    v50.logs:miss(shot)
                end
            end}, {"aim_hit", function(shot)
                if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Hit")) then
                    v50.logs:hit(shot)
                end
            end}, {"bullet_impact", function(event)
                if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Detect shot")) then
                    v50.logs:evade(event)
                end
                v50.logs:evade2(event)
            end}, {"player_death", function(e)
                if v50.ui.menu.tools.trashtalk:get() then
                    v50.misc:trashtalk(e)
                end
            end}, {"player_hurt", function(event)
                if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Get harmed")) then
                    v50.logs:harmed(event)
                end
            end}, {"setup_command", function(cmd)
                v50.antiaim:run(cmd)
                v50.misc:air_stopchance(cmd)
                v50.misc:unsafe_charge()
                if v50.ui.menu.tools.fast_ladder:get() then
                    v50.misc:fast_ladder(cmd)
                end
            end}, {"paint", function()
                v50.tools:crosshair()
                if v50.ui.menu.tools.indicators_gamesense:get() then
                    v50.custom_gs:general()
                end
                if v50.ui.menu.tools.manuals:get() then
                    v50.tools:manuals()
                end
                if v50.ui.menu.tools.indicator_dmg:get() then
                    v50.tools:ind_dmg()
                end
                v50.tools:viewmodel()
                if v50.ui.menu.tools.keylist:get() then
                    v50.tools:keylist()
                end
                if v50.ui.menu.tools.watermark:get() then
                    v50.tools:watermark()
                end
                v50.tools:scopedu()
                if v50.ui.menu.tools.gs_ind:get() then
                    v50.tools:gs_ind()
                end
            end}, {"shutdown", function(self)
                v50.unloads:setup()
            end}, {"paint_ui", function()
                if v21.is_menu_open() then
                    v50.helpers:menu_visibility(false)
                    v50.tools:menu_setup()
                end
            end}, {"pre_render", function()
                if v50.ui.menu.tools.animations:get() then
                    v50.antiaim:animations()
                end
            end}, {"round_prestart", function()
                v50.round_reset:auto_buy()
            end}, {"net_update_end", function()
                v50.defensive:defensive_active()
            end}}
) do
    local v702 = v701[1]
    local v703 = v701[2]
    if (v702 == "load") then
        v703()
    else
        v22.set_event_callback(v702, v703)
    end
end
local v51 = {completing = false, showing = true, progress = 0}
v51.back = function()
    v51.progress = v50.helpers:math_anim2(v51.progress, (v51.showing and 1) or 0, 6)
    v28.rectangle(0, 0, 9999, 9999, v38.accent.r / 10, v38.accent.g / 10, v38.accent.b / 10, v51.progress * 200)
    v28.text(
        v39 / 2,
        (v40 / 2) + 35,
        255,
        255,
        255,
        v51.progress * 255,
        "cb",
        nil,
        "pastsense.\a" ..
            v50.helpers.rgba_to_hex(nil, v38.accent.r, v38.accent.g, v38.accent.b, v51.progress * 255) .. "lua"
    )
    if not v51.completing then
        v22.delay_call(
            3,
            function()
                if v51 then
                    v51.showing = false
                end
            end
        )
        v51.completing = true
    end
end
v51.returner = function()
    return
end
v50.ui.menu.tools.indicators_gamesense:set_event(
    "indicator",
    v51.returner,
    function(v705)
        return v705:get()
    end
)
v22.delay_call(
    0.5,
    function()
        v22.set_event_callback("paint_ui", v51.back)
    end
)
v22.delay_call(
    4,
    function()
        v22.unset_event_callback("paint_ui", v51.back)
        v51 = nil
    end
)
