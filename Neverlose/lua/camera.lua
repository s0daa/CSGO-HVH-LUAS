-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local l_mtools_0 = require("neverlose/mtools");
local l_minterface_0 = require("neverlose/minterface");
require("neverlose/print")({
    Inspect = true
});
local _ = {
    Username = common.get_username(), 
    Screen = render.screen_size()
};
Center = function(v3, v4)
    text = string.sub(v3, 1, v4);
    local v5 = string.len(v3);
    return " " .. ui.get_icon("angle-right") .. "  " .. v3 .. string.rep(" ", math.floor(v4 / 2 - v5 / 2)) .. string.rep(" ", math.ceil(v4 / 2 - v5 / 2));
end;
local v6 = {
    Info = {
        [1] = "MonixLITE", 
        [2] = ui.get_icon("caret-right") .. "  Info "
    }, 
    Settings = {
        [1] = "MonixLITE", 
        [2] = ui.get_icon("caret-right") .. "  Settings "
    }
};
local v7 = {
    Info = {
        Text1 = l_minterface_0.Text(v6.Info, "Wow! Welcome back, \a7D40FFFF" .. common.get_username() .. "\aDEFAULT!", {}, nil, nil), 
        Text2 = l_minterface_0.Text(v6.Info, "Also, if you find an error, please let me \nknow on Discord: \a7D40FFFFMonixLITE#8814", {}, nil, nil), 
        Text3 = l_minterface_0.Text(v6.Info, "I have other works, click on the button below to see them:", {}, nil, nil), 
        Market = l_minterface_0.Button(v6.Info, Center("Other Works [Market]", 60), {
            [1] = true
        }, nil, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/?page=0&search=author:MonixLITE&sort=dupd0&type=2&filter=0");
        end)
    }, 
    Settings = {
        Enabled = l_minterface_0.Switch(v6.Settings, "Enable this Script", {
            [1] = false
        }, nil, nil), 
        First = l_minterface_0.Combo(v6.Settings, "Firstperson", {
            [1] = {
                [1] = "Disabled", 
                [2] = "Smoothness XZ"
            }
        }, nil, nil), 
        FSpeed = l_minterface_0.Slider(v6.Settings, "First Speed", {
            [1] = 120, 
            [2] = 1, 
            [3] = 320, 
            [4] = 1
        }, nil, nil), 
        Third = l_minterface_0.Combo(v6.Settings, "Thirdperson", {
            [1] = {
                [1] = "Disabled", 
                [2] = "Smoothness Z", 
                [3] = "Like Skeet"
            }
        }, nil, nil), 
        TSpeed = l_minterface_0.Slider(v6.Settings, "Third Speed", {
            [1] = 120, 
            [2] = 1, 
            [3] = 320, 
            [4] = 1
        }, nil, nil)
    }
};
FixMenu = function()
    -- upvalues: v7 (ref)
    if ui.get_alpha() < 0.5 then
        return;
    else
        local v8 = v7.Settings.First:get();
        local v9 = v7.Settings.Third:get();
        v7.Settings.First:visibility(v7.Settings.Enabled:get());
        v7.Settings.FSpeed:visibility(v7.Settings.Enabled:get() and v8 == "Smoothness XZ");
        v7.Settings.Third:visibility(v7.Settings.Enabled:get());
        v7.Settings.TSpeed:visibility(v7.Settings.Enabled:get() and v9 == "Smoothness Z");
        return;
    end;
end;
GradientText = function(v10, v11, v12)
    local v13 = {
        Result = "", 
        Length = #v10 - 1
    };
    local v14 = {
        R = (v12.r - v11.r) / v13.Length, 
        G = (v12.g - v11.g) / v13.Length, 
        B = (v12.b - v11.b) / v13.Length, 
        A = (v12.a - v11.a) / v13.Length
    };
    for v15 = 1, v13.Length + 1 do
        v13.Result = v13.Result .. ("\a%02x%02x%02x%02x%s"):format(v11.r, v11.g, v11.b, v11.a, v10:sub(v15, v15));
        v11.r = v11.r + v14.R;
        v11.g = v11.g + v14.G;
        v11.b = v11.b + v14.B;
        v11.a = v11.a + v14.A;
    end;
    return v13.Result;
end;
MakeSideBar = function()
    -- upvalues: l_mtools_0 (ref)
    if ui.get_alpha() < 0.5 then
        return;
    else
        local v16 = l_mtools_0.Animation:Lerp("First", "ColorL", globals.tickcount % 100 >= 50, color(255, 255, 255, 255), color(128, 64, 255, 255), 3);
        local v17 = l_mtools_0.Animation:Lerp("Third", "ColorR", globals.tickcount % 100 <= 50, color(255, 255, 255, 255), color(128, 64, 255, 255), 3);
        ui.sidebar(GradientText("Excellent Camera", v16, v17), "camera");
        return;
    end;
end;
local v18 = nil;
local v19 = nil;
MakeCamera = function(v20)
    -- upvalues: v18 (ref), v19 (ref), v7 (ref), l_mtools_0 (ref)
    if v18 == nil or v19 == nil then
        v18 = v20.view;
        v19 = v20.camera;
    end;
    local v21 = entity.get_local_player();
    if v21 == nil or not v21:is_alive() then
        return;
    elseif not v7.Settings.Enabled:get() then
        return;
    else
        if common.is_in_thirdperson() then
            local v22 = v7.Settings.Third:get();
            if v22 == "Smoothness Z" then
                v19.z = v20.camera.z;
                local v23 = l_mtools_0.Animation:Lerp("Third", "Camera.Z", true, {
                    [1] = v19.z
                }, {
                    [1] = v19.z
                });
                v20.camera.z = v23[1];
            elseif v22 == "Like Skeet" and v21.m_flDuckAmount > 0 and l_mtools_0.AntiAims.Condition:GetDev("Air") then
                v20.camera.z = v21:get_origin().z + 54.5;
            end;
        elseif v7.Settings.First:get() == "Smoothness XZ" then
            v18.x = v20.view.x;
            v18.z = v20.view.z;
            local v24 = l_mtools_0.Animation:Lerp("First", "View.X", true, {
                [1] = v18.x
            }, {
                [1] = v18.x
            });
            local v25 = l_mtools_0.Animation:Lerp("First", "View.Z", true, {
                [1] = v18.z
            }, {
                [1] = v18.z
            });
            v20.view = vector(v24[1], v20.view.y, v25[1]);
        end;
        return;
    end;
end;
events.render:set(function()
    -- upvalues: l_mtools_0 (ref), v7 (ref)
    l_mtools_0.AntiAims.Condition:Update();
    l_mtools_0.Animation:Register("First");
    l_mtools_0.Animation:Register("Third");
    l_mtools_0.Animation:Update("First", v7.Settings.FSpeed:get() / 10);
    l_mtools_0.Animation:Update("Third", v7.Settings.TSpeed:get() / 10);
    FixMenu();
    MakeSideBar();
end);
events.override_view:set(function(v26)
    MakeCamera(v26);
end);