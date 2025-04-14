-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--- defines
local function MACRO(...)
    return ...;
end

--- macro

--- @diagnostic disable

if not LPH_OBFUSCATED then
    print("Macros enabled");
    LPH_NO_VIRTUALIZE = MACRO;
end

--- @diagnostic enable

LPH_NO_VIRTUALIZE(function()
    print(1);
end)();