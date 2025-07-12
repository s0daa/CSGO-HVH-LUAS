local v0 = {};
local v1 = {};
local v2 = {};
local v3 = {};
local v4 = {};
local v5 = {};
local v6 = db.acatel or {};
v5.clipboard = require("neverlose/clipboard");
v5.base64 = require("neverlose/sec-base64");
v5.easing = require("neverlose/easing");
v5.lagrecord = require("neverlose/lagrecord");
v5.lagrecord = v5.lagrecord ^ v5.lagrecord.SIGNED;
v5.events_extended = require("neverlose/events_extended");
v5.lagrecord.set_update_callback(function(v7)
    if v7 == entity.get_local_player() then
        return true;
    else
        return;
    end;
end);
local v8 = ffi.typeof("    struct { \n        float x; \n        float y; \n        float z; \n    }\n");
local v9 = ffi.typeof("void(__thiscall*)(void*, const $&)", v8);
local v10 = ffi.typeof("    struct {\n        int64_t         unknown;\n        int64_t         steamID64;\n        char            szName[128];\n        int             userId;\n        char            szSteamID[20];\n        char            pad_0x00A8[0x10];\n        unsigned long   iSteamID;\n        char            szFriendsName[128];\n        bool            fakeplayer;\n        bool            ishltv;\n        unsigned int    customfiles[4];\n        unsigned char   filesdownloaded;\n    }\n");
local v11 = ffi.typeof("\tstruct {\t\t\t\t\t\t\t\t\t\tchar pad_0x0000[0x18];\n\t\tuint32_t\tsequence;\n\t\tfloat\t\tprev_cycle;\n\t\tfloat\t\tweight;\n\t\tfloat\t\tweight_delta_rate;\n\t\tfloat\t\tplayback_rate;\n\t\tfloat\t\tcycle;\n\t\tvoid\t\t*entity;\t\t\t\t\t\tchar pad_0x0038[0x4];\n\t} **\n");
local v12 = ffi.cast("uintptr_t**", utils.opcode_scan("engine.dll", "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6", 1));
local v13 = utils.get_vfunc(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", v10));
local v14 = utils.opcode_scan("client.dll", "55 8B EC 83 E4 F8 83 EC 64 53 56 57 8B F1 E8") or error("Couldn't find set_angles signature");
local v15 = ffi.cast(v9, v14) or error("Couldn't cast set_angles_fn");
v1.cheat = {
    date = "may 27 2025", 
    highlight = "b6b665ff", 
    default_color = "DEFAULT", 
    build = "beta", 
    accent_color = "{Link Active}", 
    user = common.get_username(), 
    fonts = {
        arrow = render.load_font("Tahoma", 21, "ab")
    }
};
ui.sidebar(string.format("\a%sacatel\aDEFAULT anti-aim", v1.cheat.accent_color), "\240\159\146\171");
v1.cheat.scope_alpha = 0;
v1.cheat.config = v6.configs or {
    [1] = "main"
};
v1.cheat.config_value = v6.configs_values or {
    main = ""
};
v1.cheat.config_value.main = "eyJidWlsZGVycyI6eyJjdXJyZW50X3N0YXRlIjoic3RhbmRpbmciLCJwYW5lbCI6W1t7ImJhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXciOmZhbHNlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6NS4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6MC4wLCJvZmZzZXRfciI6MC4wLCJwaXRjaCI6ImRpc2FibGVkIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOnRydWUsInlhdyI6ImRpc2FibGVkIiwieWF3X2RlbGF5IjoxLjAsInlhd19kZWxheV9sIjowLjAsInlhd19kZWxheV9tYXN0ZXIiOmZhbHNlLCJ5YXdfZGVsYXlfciI6MC4wfSx7ImJhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXciOmZhbHNlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6Ny4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6MC4wLCJvZmZzZXRfciI6MC4wLCJwaXRjaCI6ImRpc2FibGVkIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOnRydWUsInlhdyI6ImRpc2FibGVkIiwieWF3X2RlbGF5IjoxLjAsInlhd19kZWxheV9sIjowLjAsInlhd19kZWxheV9tYXN0ZXIiOmZhbHNlLCJ5YXdfZGVsYXlfciI6MC4wfV0sW3siYmFzZSI6ImF0IHRhcmdldCIsImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbImppdHRlciIsImRvZGdlIl0sImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV9jb25kcyI6W10sImRlZmVuc2l2ZV9waXRjaCI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV9waXRjaF9zbGlkZXIiOjAuMCwiZGVmZW5zaXZlX3lhdyI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV95YXdfc2xpZGVyIjowLjAsImRvZGdlX3N0cmVuZ3RoIjozMC4wLCJkb2RnZV90aHJlc2hvbGQiOjUuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOi0yMi4wLCJvZmZzZXRfciI6MzUuMCwicGl0Y2giOiJkb3duIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOnRydWUsInlhdyI6ImJhY2t3YXJkIiwieWF3X2RlbGF5IjoxMDEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6dHJ1ZSwieWF3X2RlbGF5X3IiOjAuMH0seyJiYXNlIjoibG9jYWwgdmlldyIsImJvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfZnJlZXN0YW5kaW5nIjoib2ZmIiwiYm9keV95YXdfb3B0aW9ucyI6W10sImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV9jb25kcyI6W10sImRlZmVuc2l2ZV9waXRjaCI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV9waXRjaF9zbGlkZXIiOjAuMCwiZGVmZW5zaXZlX3lhdyI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV95YXdfc2xpZGVyIjowLjAsImRvZGdlX3N0cmVuZ3RoIjo3MC4wLCJkb2RnZV90aHJlc2hvbGQiOjcuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOjAuMCwib2Zmc2V0X3IiOjAuMCwicGl0Y2giOiJkaXNhYmxlZCIsInJpZ2h0X2xpbWl0Ijo2MC4wLCJzdGF0ZV9lbmFibGVkIjpmYWxzZSwieWF3IjoiZGlzYWJsZWQiLCJ5YXdfZGVsYXkiOjEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6ZmFsc2UsInlhd19kZWxheV9yIjowLjB9XSxbeyJiYXNlIjoiYXQgdGFyZ2V0IiwiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2ZyZWVzdGFuZGluZyI6Im9mZiIsImJvZHlfeWF3X29wdGlvbnMiOlsiaml0dGVyIiwiZG9kZ2UiXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjc1LjAsImRvZGdlX3RocmVzaG9sZCI6OC4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6LTMwLjAsIm9mZnNldF9yIjozNS4wLCJwaXRjaCI6ImRvd24iLCJyaWdodF9saW1pdCI6NjAuMCwic3RhdGVfZW5hYmxlZCI6dHJ1ZSwieWF3IjoiYmFja3dhcmQiLCJ5YXdfZGVsYXkiOjEwMS4wLCJ5YXdfZGVsYXlfbCI6MS4wLCJ5YXdfZGVsYXlfbWFzdGVyIjp0cnVlLCJ5YXdfZGVsYXlfciI6My4wfSx7ImJhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXciOmZhbHNlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6Ny4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6MC4wLCJvZmZzZXRfciI6MC4wLCJwaXRjaCI6ImRpc2FibGVkIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOmZhbHNlLCJ5YXciOiJkaXNhYmxlZCIsInlhd19kZWxheSI6MS4wLCJ5YXdfZGVsYXlfbCI6MC4wLCJ5YXdfZGVsYXlfbWFzdGVyIjpmYWxzZSwieWF3X2RlbGF5X3IiOjAuMH1dLFt7ImJhc2UiOiJhdCB0YXJnZXQiLCJib2R5X3lhdyI6dHJ1ZSwiYm9keV95YXdfZnJlZXN0YW5kaW5nIjoib2ZmIiwiYm9keV95YXdfb3B0aW9ucyI6WyJqaXR0ZXIiLCJkb2RnZSJdLCJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfY29uZHMiOltdLCJkZWZlbnNpdmVfcGl0Y2giOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfcGl0Y2hfc2xpZGVyIjowLjAsImRlZmVuc2l2ZV95YXciOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfeWF3X3NsaWRlciI6MC4wLCJkb2RnZV9zdHJlbmd0aCI6MzAuMCwiZG9kZ2VfdGhyZXNob2xkIjozLjAsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjoiZGlzYWJsZWQiLCJqaXR0ZXJfb2Zmc2V0IjowLjAsImxlZnRfbGltaXQiOjYwLjAsIm9mZnNldF9sIjotMzUuMCwib2Zmc2V0X3IiOjM1LjAsInBpdGNoIjoiZG93biIsInJpZ2h0X2xpbWl0Ijo2MC4wLCJzdGF0ZV9lbmFibGVkIjp0cnVlLCJ5YXciOiJiYWNrd2FyZCIsInlhd19kZWxheSI6MTAxLjAsInlhd19kZWxheV9sIjowLjAsInlhd19kZWxheV9tYXN0ZXIiOnRydWUsInlhd19kZWxheV9yIjowLjB9LHsiYmFzZSI6ImxvY2FsIHZpZXciLCJib2R5X3lhdyI6ZmFsc2UsImJvZHlfeWF3X2ZyZWVzdGFuZGluZyI6Im9mZiIsImJvZHlfeWF3X29wdGlvbnMiOltdLCJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfY29uZHMiOltdLCJkZWZlbnNpdmVfcGl0Y2giOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfcGl0Y2hfc2xpZGVyIjowLjAsImRlZmVuc2l2ZV95YXciOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfeWF3X3NsaWRlciI6MC4wLCJkb2RnZV9zdHJlbmd0aCI6NzAuMCwiZG9kZ2VfdGhyZXNob2xkIjo3LjAsImludmVydGVyIjpmYWxzZSwiaml0dGVyIjoiZGlzYWJsZWQiLCJqaXR0ZXJfb2Zmc2V0IjowLjAsImxlZnRfbGltaXQiOjYwLjAsIm9mZnNldF9sIjowLjAsIm9mZnNldF9yIjowLjAsInBpdGNoIjoiZGlzYWJsZWQiLCJyaWdodF9saW1pdCI6NjAuMCwic3RhdGVfZW5hYmxlZCI6ZmFsc2UsInlhdyI6ImRpc2FibGVkIiwieWF3X2RlbGF5IjoxLjAsInlhd19kZWxheV9sIjowLjAsInlhd19kZWxheV9tYXN0ZXIiOmZhbHNlLCJ5YXdfZGVsYXlfciI6MC4wfV0sW3siYmFzZSI6ImF0IHRhcmdldCIsImJvZHlfeWF3Ijp0cnVlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbImppdHRlciIsImRvZGdlIl0sImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV9jb25kcyI6W10sImRlZmVuc2l2ZV9waXRjaCI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV9waXRjaF9zbGlkZXIiOjAuMCwiZGVmZW5zaXZlX3lhdyI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV95YXdfc2xpZGVyIjowLjAsImRvZGdlX3N0cmVuZ3RoIjo1MC4wLCJkb2RnZV90aHJlc2hvbGQiOjUuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOi0yNS4wLCJvZmZzZXRfciI6MzcuMCwicGl0Y2giOiJkb3duIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOnRydWUsInlhdyI6ImJhY2t3YXJkIiwieWF3X2RlbGF5IjoxMDEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6dHJ1ZSwieWF3X2RlbGF5X3IiOjAuMH0seyJiYXNlIjoibG9jYWwgdmlldyIsImJvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfZnJlZXN0YW5kaW5nIjoib2ZmIiwiYm9keV95YXdfb3B0aW9ucyI6W10sImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV9jb25kcyI6W10sImRlZmVuc2l2ZV9waXRjaCI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV9waXRjaF9zbGlkZXIiOjAuMCwiZGVmZW5zaXZlX3lhdyI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV95YXdfc2xpZGVyIjowLjAsImRvZGdlX3N0cmVuZ3RoIjo3MC4wLCJkb2RnZV90aHJlc2hvbGQiOjcuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOjAuMCwib2Zmc2V0X3IiOjAuMCwicGl0Y2giOiJkaXNhYmxlZCIsInJpZ2h0X2xpbWl0Ijo2MC4wLCJzdGF0ZV9lbmFibGVkIjpmYWxzZSwieWF3IjoiZGlzYWJsZWQiLCJ5YXdfZGVsYXkiOjEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6ZmFsc2UsInlhd19kZWxheV9yIjowLjB9XSxbeyJiYXNlIjoiYXQgdGFyZ2V0IiwiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2ZyZWVzdGFuZGluZyI6Im9mZiIsImJvZHlfeWF3X29wdGlvbnMiOlsiaml0dGVyIiwiZG9kZ2UiXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjEwMC4wLCJkb2RnZV90aHJlc2hvbGQiOjUuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOi0zMC4wLCJvZmZzZXRfciI6NDAuMCwicGl0Y2giOiJkb3duIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOnRydWUsInlhdyI6ImJhY2t3YXJkIiwieWF3X2RlbGF5IjoxMDEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6dHJ1ZSwieWF3X2RlbGF5X3IiOjAuMH0seyJiYXNlIjoibG9jYWwgdmlldyIsImJvZHlfeWF3IjpmYWxzZSwiYm9keV95YXdfZnJlZXN0YW5kaW5nIjoib2ZmIiwiYm9keV95YXdfb3B0aW9ucyI6W10sImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV9jb25kcyI6W10sImRlZmVuc2l2ZV9waXRjaCI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV9waXRjaF9zbGlkZXIiOjAuMCwiZGVmZW5zaXZlX3lhdyI6ImluaGVyaXRlZCIsImRlZmVuc2l2ZV95YXdfc2xpZGVyIjowLjAsImRvZGdlX3N0cmVuZ3RoIjo3MC4wLCJkb2RnZV90aHJlc2hvbGQiOjcuMCwiaW52ZXJ0ZXIiOmZhbHNlLCJqaXR0ZXIiOiJkaXNhYmxlZCIsImppdHRlcl9vZmZzZXQiOjAuMCwibGVmdF9saW1pdCI6NjAuMCwib2Zmc2V0X2wiOjAuMCwib2Zmc2V0X3IiOjAuMCwicGl0Y2giOiJkaXNhYmxlZCIsInJpZ2h0X2xpbWl0Ijo2MC4wLCJzdGF0ZV9lbmFibGVkIjpmYWxzZSwieWF3IjoiZGlzYWJsZWQiLCJ5YXdfZGVsYXkiOjEuMCwieWF3X2RlbGF5X2wiOjAuMCwieWF3X2RlbGF5X21hc3RlciI6ZmFsc2UsInlhd19kZWxheV9yIjowLjB9XSxbeyJiYXNlIjoiYXQgdGFyZ2V0IiwiYm9keV95YXciOnRydWUsImJvZHlfeWF3X2ZyZWVzdGFuZGluZyI6Im9mZiIsImJvZHlfeWF3X29wdGlvbnMiOlsiaml0dGVyIiwiZG9kZ2UiXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6NS4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6LTMwLjAsIm9mZnNldF9yIjoyMC4wLCJwaXRjaCI6ImRvd24iLCJyaWdodF9saW1pdCI6NjAuMCwic3RhdGVfZW5hYmxlZCI6dHJ1ZSwieWF3IjoiYmFja3dhcmQiLCJ5YXdfZGVsYXkiOjEwMS4wLCJ5YXdfZGVsYXlfbCI6MC4wLCJ5YXdfZGVsYXlfbWFzdGVyIjp0cnVlLCJ5YXdfZGVsYXlfciI6MC4wfSx7ImJhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXciOmZhbHNlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6Ny4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6MC4wLCJvZmZzZXRfciI6MC4wLCJwaXRjaCI6ImRpc2FibGVkIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOmZhbHNlLCJ5YXciOiJkaXNhYmxlZCIsInlhd19kZWxheSI6MS4wLCJ5YXdfZGVsYXlfbCI6MC4wLCJ5YXdfZGVsYXlfbWFzdGVyIjpmYWxzZSwieWF3X2RlbGF5X3IiOjAuMH1dLFt7ImJhc2UiOiJhdCB0YXJnZXQiLCJib2R5X3lhdyI6dHJ1ZSwiYm9keV95YXdfZnJlZXN0YW5kaW5nIjoib2ZmIiwiYm9keV95YXdfb3B0aW9ucyI6WyJqaXR0ZXIiLCJkb2RnZSJdLCJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfY29uZHMiOltdLCJkZWZlbnNpdmVfcGl0Y2giOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfcGl0Y2hfc2xpZGVyIjowLjAsImRlZmVuc2l2ZV95YXciOiJpbmhlcml0ZWQiLCJkZWZlbnNpdmVfeWF3X3NsaWRlciI6MC4wLCJkb2RnZV9zdHJlbmd0aCI6MzAuMCwiZG9kZ2VfdGhyZXNob2xkIjoxMC4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6LTguMCwib2Zmc2V0X3IiOjEzLjAsInBpdGNoIjoiZG93biIsInJpZ2h0X2xpbWl0Ijo2MC4wLCJzdGF0ZV9lbmFibGVkIjp0cnVlLCJ5YXciOiJiYWNrd2FyZCIsInlhd19kZWxheSI6MS4wLCJ5YXdfZGVsYXlfbCI6MC4wLCJ5YXdfZGVsYXlfbWFzdGVyIjp0cnVlLCJ5YXdfZGVsYXlfciI6MC4wfSx7ImJhc2UiOiJsb2NhbCB2aWV3IiwiYm9keV95YXciOmZhbHNlLCJib2R5X3lhd19mcmVlc3RhbmRpbmciOiJvZmYiLCJib2R5X3lhd19vcHRpb25zIjpbXSwiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX2NvbmRzIjpbXSwiZGVmZW5zaXZlX3BpdGNoIjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3BpdGNoX3NsaWRlciI6MC4wLCJkZWZlbnNpdmVfeWF3IjoiaW5oZXJpdGVkIiwiZGVmZW5zaXZlX3lhd19zbGlkZXIiOjAuMCwiZG9kZ2Vfc3RyZW5ndGgiOjcwLjAsImRvZGdlX3RocmVzaG9sZCI6Ny4wLCJpbnZlcnRlciI6ZmFsc2UsImppdHRlciI6ImRpc2FibGVkIiwiaml0dGVyX29mZnNldCI6MC4wLCJsZWZ0X2xpbWl0Ijo2MC4wLCJvZmZzZXRfbCI6MC4wLCJvZmZzZXRfciI6MC4wLCJwaXRjaCI6ImRpc2FibGVkIiwicmlnaHRfbGltaXQiOjYwLjAsInN0YXRlX2VuYWJsZWQiOmZhbHNlLCJ5YXciOiJkaXNhYmxlZCIsInlhd19kZWxheSI6MS4wLCJ5YXdfZGVsYXlfbCI6MC4wLCJ5YXdfZGVsYXlfbWFzdGVyIjpmYWxzZSwieWF3X2RlbGF5X3IiOjAuMH1dXSwic3RhdGVfdG9fZXhwb3J0IjoiYWlyIGNyb3VjaCIsInRlYW1fc2xpZGVyIjoxLjAsInRlYW1fc3dpdGNoIjpmYWxzZX0sImRlYnVnIjpbXSwiZHJhdyI6eyJhcnJvd19wb3MiOjQ1LjAsImFycm93X3NpemUiOjguMCwiYXJyb3dfc3R5bGUiOiJyZS1zaXphYmxlIiwiYXNwZWN0X3JhdGlvIjoxMjUuMCwiaGl0bWFya2VyIjp0cnVlLCJoaXRtYXJrZXJfYXBwbHlfY29sb3IiOltdLCJoaXRtYXJrZXJfZGVmYXVsdF9jb2xvciI6WzI1NS4wLDI1NS4wLDI1NS4wLDI1NS4wXSwiaGl0bWFya2VyX2dhcCI6NS4wLCJoaXRtYXJrZXJfaGVhZHNob3RfY29sb3IiOlsyNTUuMCwxMDUuMCwxMDAuMCwyNTUuMF0sImhpdG1hcmtlcl9sZW5ndGgiOjUuMCwiaGl0bWFya2VyX2xldGhhbF9jb2xvciI6WzI1NS4wLDI1NS4wLDAuMCwyNTUuMF0sImhpdG1hcmtlcl90b2dnbGUiOlsic2NyZWVuIl0sImluZGljYXRvcl9iYXNlIjpbIkJBSU0iLCJTUCIsIkZTIl0sImluZGljYXRvcl9jZW50ZXIiOnRydWUsImluZGljYXRvcl9nYXAiOjEuMCwiaW5kaWNhdG9yX2lubGluZSI6WyJCQUlNIiwiU1AiLCJGUyJdLCJpbmRpY2F0b3JfaW52ZXJ0IjpmYWxzZSwiaW5kaWNhdG9yX3Jlc3BvbnNpdmUiOlsiZGFtYWdlIiwiZG9kZ2UiLCJ2ZWwuIG1vZGlmaWVyIl0sImluZGljYXRvcl9zdGFydCI6MzAuMCwiaW5kaWNhdG9ycyI6dHJ1ZSwibG9ncyI6dHJ1ZSwibG9nc19jb25zb2xlIjpbImhpdCIsIm1pc3MiLCJncmVuYWRlIGRtZyIsImtuaWZlZCJdLCJsb2dzX2Nvcm5lciI6dHJ1ZSwibG9nc19kcmF3IjpbXSwibG9nc19oaXQiOlsxNTAuMCwyMDAuMCw2MC4wLDI1NS4wXSwibG9nc19sZXRoYWwiOlsyMDAuMCwyMDAuMCwyNTUuMCwyNTUuMF0sImxvZ3NfbWlzcyI6WzI1NS4wLDEwNS4wLDEwMC4wLDE3NS4wXSwibG9nc19uYWRlIjpbMjU1LjAsMjU1LjAsMC4wLDIwMC4wXSwibG9nc19zbWFsbCI6ZmFsc2UsImxvZ3Nfc3RhcnQiOjIwMC4wLCJtYW51YWwiOnRydWUsInNjb3BlIjp0cnVlLCJzY29wZV9saW5lX2NvbG9yIjpbMjU1LjAsMjU1LjAsMjU1LjAsNjMuMF0sInNjb3BlX2xpbmVfZ2FwIjo1LjAsInNjb3BlX2xpbmVfbGVuZ3RoIjoxOTAuMCwic2NvcGVfbGluZV9zcGVlZCI6MTIuMCwid2F0ZXJtYXJrX2NvbG9yIjpbMjEyLjAsMjEyLjAsMjU1LjAsMTAzLjBdfSwia2V5YmluZHMiOnsiZnJlZXN0YW5kaW5nIjp0cnVlLCJmc19iaW5kIjpmYWxzZSwiZnNfZGlzYWJsZXJzIjpbImFpciIsImFpciBjcm91Y2giXSwiZnNfcHJpb3JpdGl6ZSI6dHJ1ZSwiZnNfc2FmZXR5Ijp0cnVlLCJtYW51YWxfYmluZCI6IkRpc2FibGVkIiwibWFudWFsX3RyaWdnZXJzIjpbInVzZSBsb2NhbCB2aWV3IiwiZm9yY2Ugc2FmZXR5Il0sIm1hbnVhbF95YXciOnRydWV9LCJtaXNjIjp7ImNsaWVudF9uYW1lIjpmYWxzZSwiY3VzdG9tX3ZpZXdtb2RlbCI6dHJ1ZSwiZHJvcHBpbmciOnRydWUsImhpZGVzaG90cyI6ZmFsc2UsImhpZGVzaG90c19zdGF0ZSI6W10sImxpc3RfbmFkZXMiOlsibW9sb3RvdiIsImRlY295Iiwic21va2UiLCJmbGFzaGJhbmciLCJoZSBncmVuYWRlIl0sInBpbmdzcGlrZSI6dHJ1ZSwicGluZ3NwaWtlX3RhcmdldCI6MTI1LjAsInRyYXNodGFsayI6ZmFsc2UsInRyYXNodGFsa19kZWxheSI6MS4wLCJ0cmFzaHRhbGtfbGV2ZWwiOjEuMCwidHJhc2h0YWxrX29wdGlvbnMiOltdLCJ2aWV3bW9kZWxfZm92IjowLjAsInZpZXdtb2RlbF9yb3RhdGlvbiI6MC4wLCJ2aWV3bW9kZWxfeCI6Mi4wLCJ2aWV3bW9kZWxfeSI6Mi4wLCJ2aWV3bW9kZWxfeiI6LTIuMCwid29ybGRfdG9uZSI6dHJ1ZX0sIm1vZGlmaWVycyI6eyJhbnRpX2JhY2tzdGFiIjp0cnVlLCJkZWZlbnNpdmUiOnRydWUsImRlZmVuc2l2ZV9hYV9vcHRpb25zIjpbInByZS1mbGljayJdLCJkZWZlbnNpdmVfYW50aWFpbSI6ZmFsc2UsImRlZmVuc2l2ZV9zdGF0ZSI6WyJhaXIiLCJhaXIgY3JvdWNoIl0sImhlaWdodF90aHJlc2hvbGQiOjEwMC4wLCJtb2RlIjoyLjAsInNhZmVfaGVhZCI6dHJ1ZSwic2FmZV9oZWFkX3N0YXRlcyI6WyJhaXIgc2FmZXR5IGtuaWZlIiwiYWlyIHNhZmV0eSB0YXNlciIsImhlaWdodCJdfSwicGxheWVyIjp7ImFuaW1fb3B0aW9ucyI6WyJzdGF0aWMgaW4gYWlyIiwiemVybyBwaXRjaCBvbiBsYW5kIiwiZHJhZyJdLCJhbmltYXRpb25zIjp0cnVlLCJmYWtlX3R1ZmYiOmZhbHNlLCJmYWxsX2RhbWFnZSI6dHJ1ZSwiZmFzdF9sYWRkZXIiOnRydWUsImZyZWV6ZXRpbWVfZmQiOnRydWUsImxhZGRlcl95YXciOjAuMCwibGVhbl9hbW91bnQiOjEwMC4wLCJzY29wZV90cmFuc3BhcmVuY3kiOnRydWUsInVubG9ja19zcGVlZCI6dHJ1ZX19";
v1.cheat.ratio_match = {};
v1.cheat.ratio_steps = 200;
v1.cheat.ratio_mutlipler = 0.01;
v1.cheat.watermark_pos = v6.position and vector(unpack(v6.position)) or vector(0, render.screen_size().y / 2);
v1.cheat.watermark_offset = 0;
v1.cheat.drag = false;
v1.cheat.hitgroup_names = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "neck", 
    [9] = "?", 
    [10] = "gear"
};
v1.cheat.item_names = {
    inferno = "Burned", 
    knife = "Knifed", 
    hegrenade = "Naded"
};
v1.cheat.log = {};
v1.cheat.log_total = 0;
v1.cheat.reply_list = {};
v1.grenade = {
    old_state = false, 
    list = {
        [1] = "molotov", 
        [2] = "decoy", 
        [3] = "smoke", 
        [4] = "flashbang", 
        [5] = "he grenade"
    }, 
    all_nades = {}
};
v1.grenades_mismatch = {
    weapon_molotov = "molotov", 
    weapon_hegrenade = "he grenade", 
    weapon_smokegrenade = "smoke", 
    weapon_flashbang = "flashbang", 
    weapon_decoy = "decoy", 
    weapon_incgrenade = "molotov"
};
v1.player = {
    invert = false, 
    local_state = 1, 
    delay = 0, 
    has_triggered_trace = false, 
    clear_previous = false, 
    get_offset = 0, 
    invert_yaw = 0, 
    local_state_names = {
        [1] = "standing", 
        [2] = "moving", 
        [3] = "crouch", 
        [4] = "crouch move", 
        [5] = "slow motion", 
        [6] = "air", 
        [7] = "air crouch"
    }, 
    team_state = {
        [1] = "terrorist", 
        [2] = "ct"
    }
};
v1.player.extra_state_names = {
    "fallback", 
    unpack(v1.player.local_state_names)
};
v1.exploits = {
    can_invalidate = false, 
    is_defensive = false, 
    is_active = false
};
v1.anti_aim = {
    anti_aim_array = {}, 
    menu_values = {}, 
    presets = {}, 
    manual_array = {
        Forward = 180, 
        Backward = 0, 
        Right = 90, 
        Left = -90, 
        Disabled = 0
    }, 
    manual_arrows = {
        Left = {
            "<", 
            vector(-35, 0)
        }, 
        Right = {
            ">", 
            vector(35, 0)
        }, 
        Backward = {
            "\203\133", 
            vector(0, 35)
        }, 
        Forward = {
            "^", 
            vector(0, -35)
        }
    }, 
    pitch_values = {
        up = -89, 
        ["safe up"] = -45, 
        zero = 0, 
        down = 89
    }
};
local l_menu_values_0 = v1.anti_aim.menu_values;
v1.cheat.death_tbl = {
    inferno = {
        [1] = "BURNN dumbass ape", 
        [2] = "LOL", 
        [3] = "PIG BURN", 
        [4] = "fire is hot btw"
    }, 
    hegrenade = {
        [1] = "EAT PIG", 
        [2] = "DUMBASS PIG CANT MOVE?", 
        [3] = "ur belly blocking the vision bro??", 
        [4] = "EATT OPEN UR EYES RETARD LOOL", 
        [5] = "ACE????"
    }, 
    taser = {
        [1] = "1", 
        [2] = "ez tase moron", 
        [3] = "wyd?", 
        [4] = "so shit LOL", 
        [5] = "tap"
    }, 
    smokegrenade = {
        [1] = "LOOOOOOOOOOOOOOL", 
        [2] = "dumbass SMOKED"
    }, 
    flashbang = {
        [1] = "blinded dumbass ape", 
        [2] = "LOL flashed shitbot", 
        [3] = "HAHAHHAHAHAHA UR SO BAD", 
        [4] = "LOL nice iq"
    }, 
    [1] = {
        [1] = "1"
    }, 
    [2] = {
        [1] = "1", 
        [2] = "ez", 
        [3] = "tap", 
        [4] = "hs bot", 
        [5] = "wyd?", 
        [6] = "wyd BRO LOOL", 
        [7] = "iq", 
        [8] = "HAHHHAHAHAHAHAHA", 
        [9] = "wake up"
    }, 
    [3] = {
        "LMAO", 
        "rofl", 
        "get fucked nn", 
        "? XD", 
        "ns", 
        "sit shit bot", 
        "u are so shit", 
        "shoot next time ?XD", 
        "?HAHAHAHA", 
        " retard hsbot", 
        "iq", 
        "baited LEL", 
        "moron", 
        "so shit", 
        "morons", 
        "by aimware...", 
        "izi", 
        "IZI", 
        "so fkn EZ", 
        "bots", 
        "ezzz", 
        "LAL", 
        "sit", 
        "hh", 
        "cry", 
        "nice animfix", 
        "grab a straw coz you suck", 
        "dump my 979", 
        "HHHHHHHH", 
        "wyd retard", 
        "nice shot LOL", 
        "u suck", 
        "wyd LOL", 
        "AHAHHAHAHA", 
        "retard", 
        v5.base64.decode("6buR56eR5oqALmx1YSBBQ0FURUwgTC5BIOWPr+S7peWQg+eahOWQl++8n++8n++8nyBHQU1FIEhBQ0sgR0FNRVNFTlNFIOWlveeUqOeahOWQl++8n++8nyAxMDAlIEhBQ0sg6buR56eR5oqALmx1YSBB Q0FURUzjgIJVU0Eg55qE56eR5oqA"), 
        v5.base64.decode("6buR56eR5oqALmx1YSBBQ0FURUwgTC5BIOWPr+S7peWQg+eahOWQl++8n++8n++8nyBHQU1FIEhBQ0sgR0FNRVNFTlNFIOWlveeUqOeahOWQl++8n++8nyAxMDAlIEhBQ0sg6buR56eR5oqALmx1YSBB Q0FURUzjgIJVU0Eg55qE56eR5oqA"), 
        v5.base64.decode("QU5HUlkg77yfIEdFVCBHT09EIEdFVCBBQ0FURUzjgIJVU0Eg55qE56eR5oqAIEAgU0hPUFBZLkdHL0BTSUdIVA=="), 
        v5.base64.decode("6buR56eR5oqALmx1YSBBQ0FURUwgTC5BIOWPr+S7peWQg+eahOWQl++8n++8n++8nyBHQU1FIEhBQ0sgR0FNRVNFTlNFIOWlveeUqOeahOWQl++8n++8nyAxMDAlIEhBQ0sg6buR56eR5oqALmx1YSBBQ0FURUzjgIJVU0Eg55qE56eR5oqA"), 
        v5.base64.decode("QU5HUlkg77yfIEdFVCBHT09EIEdFVCBBQ0FURUzjgIJVU0Eg55qE56eR5oqAIEAgU0hPUFBZLkdHL0BTSUdIVA=="), 
        v5.base64.decode("V09XIEFDQVRFTCAu44CCVVNBIOeahOenkeaKgCAoVEVDSE5PTE9HWSkg77yf"), 
        v5.base64.decode("WzF2MV1ORVRIRVJMQU5EUyDwnZmg8J2ZnvCdmaPwnZmcIFtkZXN0aW55XSDwnZmW8J2ZnPCdmZbwnZme8J2Zo/CdmajwnZmpIPCdmZnwnZmk8J2ZnCAiREVQUkVTU0lPTiIg8J2ZqPCdmaTwnZmk8J2ZoyBJIPCdmZnwnZme8J2Zmi4="), 
        v5.base64.decode("8J2VpvCdlajwnZWm4oCOIDog8J2VpPCdlaXwnZWX8J2VpiDwnZWU8J2VoPCdlaPwnZWW8J2VkvCdlZ8g8J2VnvCdlZcK")
    }
};
v1.cheat.replies_i = 1;
v1.cheat.replies = {
    [1] = "uid?", 
    [2] = "nah i asked actually", 
    [3] = "yep i care", 
    [4] = "stfu retard", 
    [5] = "keep crying retard", 
    [6] = "keep talking bruh", 
    [7] = "cry bruh ur shit", 
    [8] = "cool story keep talking i care", 
    [9] = "yep whatvere ujust said LOL", 
    [10] = "still talking?XD", 
    [11] = "crying cuz reefered?"
};
v1.cheat.fuel = {
    [1] = "this is boring af", 
    [2] = "so ez", 
    [3] = "LOL", 
    [4] = "faggots", 
    [5] = "all of u are poor", 
    [6] = "fucking hvh addict retards", 
    [7] = "quiet bro?? LOL ofc shitter", 
    [8] = "hello???", 
    [9] = "ofc ur quiet dog LOOOOOOOL", 
    [10] = "go 2v2 ugly bot", 
    [11] = "keep dodging lolf", 
    [12] = "pussy", 
    [13] = "kys moron", 
    [14] = "yeah stay quiet good boy"
};
v1.viewmodel = {
    cache = {}
};
v1.dodge = {
    active = false, 
    queue = {}, 
    last = {}
};
v1.hitmarker = {
    queue = {}, 
    last = {}, 
    screen_queue = {}
};
v1.anti_aim.presets.default = {
    [1] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 41, 
            offset_l = -21, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter", 
                [2] = "dodge"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 41, 
            offset_l = -21, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter", 
                [2] = "dodge"
            }
        }
    }, 
    [2] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 47, 
            offset_l = -25, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter", 
                [2] = "dodge"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 47, 
            offset_l = -21, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter", 
                [2] = "dodge"
            }
        }
    }, 
    [3] = {
        [1] = {
            right_limit = 40, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 32, 
            offset_l = -32, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 32, 
            offset_l = -32, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }
    }, 
    [4] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 27, 
            offset_l = -15, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 33, 
            offset_l = -11, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }
    }, 
    [5] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 40, 
            offset_l = -25, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 40, 
            offset_l = -25, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }
    }, 
    [6] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 33, 
            offset_l = -15, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 22, 
            offset_l = -5, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }
    }, 
    [7] = {
        [1] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 35, 
            offset_l = -14, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }, 
        [2] = {
            right_limit = 60, 
            left_limit = 60, 
            body_yaw = true, 
            hidden = false, 
            offset_r = 35, 
            offset_l = -14, 
            jitter_offset = 0, 
            jitter = "disabled", 
            yaw = "backward", 
            base = "at target", 
            pitch = "down", 
            yaw_delay_r = 0, 
            yaw_delay_l = 0, 
            yaw_delay = 101, 
            yaw_delay_master = true, 
            body_yaw_freestanding = "off", 
            body_yaw_options = {
                [1] = "jitter"
            }
        }
    }
};
v2.utils = {
    search = function(v17, v18, _)
        for v20, v21 in pairs(v17) do
            if not search_value and v21 == v18 or search_value and v20 == v18 then
                return true, v20;
            end;
        end;
        return false;
    end, 
    rotate_point = function(v22, v23, v24, v25)
        local v26 = v23 - v25;
        local v27 = v22 - v24;
        local v28 = math.atan(v26 / v27);
        v28 = helper_func.normalize_yaw(v28 * 180 / math.pi);
        if v27 >= 0 then
            v28 = helper_func.normalize_yaw(v28 + 180);
        end;
        return v28;
    end, 
    get_angle_between_points = function(v29, v30)
        local v31 = v30 - v29;
        local v32 = vector();
        v32.x = math.deg(math.atan2(-v31.z, math.sqrt(v31.x * v31.x + v31.y * v31.y)));
        v32.y = math.deg(math.atan2(v31.y, v31.x));
        v32.z = 0;
        return v32;
    end, 
    set_antiaim = function(v33)
        -- upvalues: v0 (ref)
        if v33 == nil then
            return;
        else
            for v34, v35 in pairs(v0.ref.anti_aim) do
                local v36 = v33[v34];
                if v36 ~= nil then
                    v35:set(v36);
                end;
            end;
            return;
        end;
    end, 
    generate_callback = function(v37)
        -- upvalues: v4 (ref)
        v4[v37] = {
            has_callback = {}
        };
    end, 
    bind = function(v38, v39)
        -- upvalues: v4 (ref), v2 (ref)
        if v4[v38] == nil then
            v2.utils.generate_callback(v38);
        end;
        if not v2.utils.search(v4[v38].has_callback, v39) then
            table.insert(v4[v38].has_callback, v39);
            v38:set_callback(v39);
        end;
    end, 
    gcd = function(v40, v41)
        while v40 ~= 0 do
            local v42 = math.fmod(v41, v40);
            v41 = v40;
            v40 = v42;
        end;
        return v41;
    end, 
    get_anim_overlay = function(v43, v44)
        -- upvalues: v11 (ref)
        return ffi.cast(v11, ffi.cast("char*", v43) + 10640)[0][v44];
    end, 
    is_hovering = function(v45, v46)
        local v47 = ui.get_mouse_position();
        local _ = render.screen_size();
        local v49 = vector(math.min(v45.x, v46.x), math.min(v45.y, v46.y));
        local v50 = vector(math.max(v45.x, v46.x), math.max(v45.y, v46.y));
        return v47.x >= v49.x and v47.x <= v50.x and v47.y >= v49.y and v47.y <= v50.y;
    end, 
    clamp = function(v51, v52, v53)
        return math.min(math.max(v51, v52), v53);
    end
};
v0.tabs = {
    home = ui.create(ui.get_icon("house") .. "  home", "\nmain", 1), 
    links = ui.create(ui.get_icon("house") .. "  home", "\nlinks", 2), 
    mode = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\nmode", 1), 
    modifiers = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\nmodifiers", 2), 
    default_branch = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\nbranch", 1), 
    keybinds = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\nkeybinds", 1), 
    draw = ui.create(ui.get_icon("gear") .. "  extra", "draw", 1), 
    misc = ui.create(ui.get_icon("gear") .. "  extra", "misc", 2), 
    player = ui.create(ui.get_icon("gear") .. "  extra", "player", 1), 
    aimbot = ui.create(ui.get_icon("gear") .. "  extra", "aimbot", 2), 
    pre_builder = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\nbuilder", 2), 
    builder = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "builder", 2), 
    debug = ui.create(ui.get_icon("bullseye") .. "  anti-aim", "\ndebug", 2)
};
v0.ref = {
    anti_aim = {
        enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
        yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
        base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
        jitter = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
        jitter_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
        backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        freestanding_disable_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        freestanding_body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
    }, 
    visuals = {
        scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
    }, 
    fake_lag = {
        enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
        limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
        variance = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
    }, 
    misc = {
        fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
        leg_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
        ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
    }, 
    rage = {
        hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        double_tap_mode = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
        double_tap_limit = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"), 
        double_tap_instant = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"), 
        body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        hc = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")
    }
};
v1.indicator = {
    inline_anim = 0, 
    responsive = 0, 
    list_names = {
        [1] = "DT", 
        [2] = "HS", 
        [3] = "DUCK", 
        [4] = "BAIM", 
        [5] = "SP", 
        [6] = "FS", 
        [7] = "DMG", 
        [8] = "HC"
    }
};
v1.indicator.list = {
    [1] = {
        name = v1.indicator.list_names[1], 
        color = color(255, 255, 255, 200), 
        menu_bound = v0.ref.rage.double_tap
    }, 
    [2] = {
        name = v1.indicator.list_names[2], 
        color = color(255, 255, 255, 200), 
        menu_bound = v0.ref.rage.hide_shots
    }, 
    [3] = {
        name = v1.indicator.list_names[3], 
        color = color(255, 255, 255, 200), 
        menu_bound = v0.ref.misc.fake_duck
    }, 
    [4] = {
        name = v1.indicator.list_names[4], 
        color = color(255, 255, 255, 200)
    }, 
    [5] = {
        name = v1.indicator.list_names[5], 
        color = color(255, 255, 255, 200)
    }, 
    [6] = {
        name = v1.indicator.list_names[6], 
        color = color(255, 255, 255, 200)
    }, 
    [7] = {
        name = v1.indicator.list_names[7], 
        color = color(255, 255, 255, 200)
    }, 
    [8] = {
        name = v1.indicator.list_names[8], 
        color = color(255, 255, 255, 200)
    }
};
v0.elem = {
    home = {
        welcome = v0.tabs.home:label(string.format("(\226\138\153_\226\138\153;) \a%s%s\a%s %s ~ \a%s%s\a%s", v1.cheat.accent_color, v1.cheat.build, v1.cheat.default_color, v1.cheat.date, v1.cheat.accent_color, v1.cheat.user, v1.cheat.default_color)), 
        discord = v0.tabs.home:button(string.format(" \a%s%s\a%s  discord ", v1.cheat.accent_color, ui.get_icon("discord"), v1.cheat.default_color), function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/6xcQqm7deK");
        end, true), 
        market = v0.tabs.home:button(string.format(" \a%s%s\a%s  market ", v1.cheat.accent_color, ui.get_icon("cart-shopping"), v1.cheat.default_color), function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=7SlpIk");
        end, true), 
        config_link = v0.tabs.home:button(string.format(" \a%s%s\a%s  config ", v1.cheat.accent_color, ui.get_icon("gears"), v1.cheat.default_color), function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=HEHHLH");
        end, true), 
        config = v0.tabs.links:list(string.format("\a%s%s\a%s  saved configuration", v1.cheat.accent_color, ui.get_icon("gear"), v1.cheat.default_color), v1.cheat.config), 
        config_name = v0.tabs.links:input("current config"), 
        save = v0.tabs.links:button(string.format("  \a%s%s\a%s  save  ", v1.cheat.accent_color, ui.get_icon("floppy-disk"), v1.cheat.default_color), nil, true), 
        load = v0.tabs.links:button(string.format("  \a%s%s\a%s  load  ", v1.cheat.accent_color, ui.get_icon("download"), v1.cheat.default_color), nil, true), 
        delete = v0.tabs.links:button(string.format("  \a%s%s\a%s  delete  ", v1.cheat.accent_color, ui.get_icon("trash"), v1.cheat.default_color), nil, true), 
        reset = v0.tabs.links:button(string.format("  \a%s%s\a%s  reset  ", v1.cheat.accent_color, ui.get_icon("arrows-rotate"), v1.cheat.default_color), nil, true), 
        import = v0.tabs.links:button(string.format("  \a%s%s\a%s  import  ", v1.cheat.accent_color, ui.get_icon("file-import"), v1.cheat.default_color), nil, true), 
        export = v0.tabs.links:button(string.format("  \a%s%s\a%s  export  ", v1.cheat.accent_color, ui.get_icon("file-export"), v1.cheat.default_color), nil, true)
    }, 
    modifiers = {
        mode = v0.tabs.mode:list(string.format("\a%s%s\a%s   anti-aim mode", v1.cheat.accent_color, ui.get_icon("gear"), v1.cheat.default_color), {
            string.format("\a%s%s\a%s   pre-configured", v1.cheat.accent_color, ui.get_icon("angles-right"), v1.cheat.default_color), 
            string.format("\a%s%s\a%s   custom", v1.cheat.accent_color, ui.get_icon("angles-right"), v1.cheat.default_color)
        }), 
        mode_label = v0.tabs.mode:label(string.format("\a%s%s\a%s  custom will \a%slock\a%s unnecessary \a%sfeatures\a%s", v1.cheat.highlight, ui.get_icon("cookie"), v1.cheat.default_color, v1.cheat.highlight, v1.cheat.default_color, v1.cheat.highlight, v1.cheat.default_color)), 
        anti_backstab = v0.tabs.default_branch:switch(string.format("\a%s%s\a%s  anti-backstab", v1.cheat.accent_color, ui.get_icon("shield"), v1.cheat.default_color)), 
        safe_head = v0.tabs.default_branch:switch(string.format("\a%s%s\a%s  safe head", v1.cheat.accent_color, ui.get_icon("helmet-safety"), v1.cheat.default_color)), 
        defensive = v0.tabs.default_branch:switch(string.format("\a%s%s\a%s   modify defensive triggers", v1.cheat.accent_color, ui.get_icon("sliders"), v1.cheat.default_color)), 
        defensive_antiaim = v0.tabs.default_branch:switch(string.format("\a%s%s\a%s   modify defensive anti-aim", v1.cheat.highlight, ui.get_icon("dash"), v1.cheat.highlight)), 
        init = function()
            -- upvalues: v0 (ref), v1 (ref)
            local v54 = v0.elem.modifiers.defensive:create();
            v0.elem.modifiers.defensive_state = v54:selectable("activation triggers", v1.player.local_state_names);
            local v55 = v0.elem.modifiers.defensive_antiaim:create();
            v0.elem.modifiers.defensive_aa_options = v55:selectable("defensive aa", {
                "pre-flick", 
                "visible only", 
                unpack(v1.player.local_state_names)
            });
            local v56 = v0.elem.modifiers.safe_head:create();
            v0.elem.modifiers.safe_head_states = v56:selectable("safety state", {
                [1] = "air safety knife", 
                [2] = "air safety taser", 
                [3] = "height"
            });
            v0.elem.modifiers.height_threshold = v56:slider("height threshold", 50, 350, 150, 1, function(v57)
                return string.format("%du", v57);
            end);
        end
    }, 
    builders = {
        team_switch = v0.tabs.pre_builder:switch(string.format("\a%s%s\a%s  use team-based states", v1.cheat.accent_color, ui.get_icon("user-plus"), v1.cheat.default_color)), 
        current_state = v0.tabs.pre_builder:combo(string.format("\a%s%s\a%s   current state", v1.cheat.accent_color, ui.get_icon("layer-group"), v1.cheat.default_color), v1.player.extra_state_names), 
        init = function()
            -- upvalues: v0 (ref), v1 (ref)
            local v58 = v0.elem.builders.current_state:create();
            local v59 = v0.elem.builders.team_switch:create();
            v0.elem.builders.team_slider = v59:slider("current team", 1, 2, 1, 1, function(v60)
                -- upvalues: v1 (ref)
                return v1.player.team_state[v60];
            end);
            v0.elem.builders.team_export = v59:button(string.format(" \a%s%s\a%s  sync current state ", v1.cheat.accent_color, ui.get_icon("rotate"), v1.cheat.default_color), function(_)

            end, true);
            v0.elem.builders.state_to_export = v58:combo(string.format(" \a%s%s\a%s  context state ", v1.cheat.accent_color, ui.get_icon("angles-right"), v1.cheat.default_color), v1.player.extra_state_names);
            v0.elem.builders.state_export = v58:button(string.format(" \a%s%s\a%s  export to state ", v1.cheat.accent_color, ui.get_icon("file-export"), v1.cheat.default_color), function(_)

            end, true);
            v0.elem.builders.panel = {};
            for v63, v64 in ipairs(v1.player.extra_state_names) do
                v0.elem.builders.panel[v63] = {};
                for v65, v66 in ipairs(v1.player.team_state) do
                    local l_builder_0 = v0.tabs.builder;
                    local v68 = {
                        [1] = v1.cheat.accent_color, 
                        [2] = ui.get_icon("caret-down"), 
                        [3] = v1.cheat.default_color, 
                        [4] = v64, 
                        [5] = v66
                    };
                    local v69 = {
                        [1] = v1.cheat.accent_color, 
                        [2] = ui.get_icon("slider"), 
                        [3] = v1.cheat.default_color, 
                        [4] = v64, 
                        [5] = v66
                    };
                    local v70 = {
                        [1] = v1.cheat.accent_color, 
                        [2] = ui.get_icon("bars"), 
                        [3] = v1.cheat.default_color, 
                        [4] = v64, 
                        [5] = v66
                    };
                    local v71 = {
                        [1] = v1.cheat.highlight, 
                        [2] = ui.get_icon("bars"), 
                        [3] = v1.cheat.highlight, 
                        [4] = v64, 
                        [5] = v66
                    };
                    local v72 = v0.elem.builders.panel[v63][v65] or {};
                    v72.state_enabled = l_builder_0:switch(string.format("\a%s%s\a%s - enabled (%s)", v1.cheat.accent_color, v64, v1.cheat.default_color, v65 == 1 and "t/all" or "ct"));
                    local _ = v72.state_enabled:create();
                    v72.pitch = l_builder_0:combo(string.format("\a%s%s\a%s   pitch\n%s%s", unpack(v68)), {
                        [1] = "disabled", 
                        [2] = "down", 
                        [3] = "fake down", 
                        [4] = "fake up"
                    });
                    v72.yaw = l_builder_0:combo(string.format("\a%s%s\a%s   yaw\n%s%s", unpack(v68)), {
                        [1] = "disabled", 
                        [2] = "backward", 
                        [3] = "static"
                    });
                    local v74 = v72.yaw:create();
                    v72.base = v74:combo(string.format("\a%s%s\a%s   base\n%s%s", unpack(v68)), "local view", "at target");
                    v72.offset_l = v74:slider(string.format("\a%s%s\a%s   left offset\n%s%s", unpack(v69)), -180, 180, 0);
                    v72.offset_r = v74:slider(string.format("\a%s%s\a%s   right offset\n%s%s", unpack(v69)), -180, 180, 0);
                    v72.jitter = l_builder_0:combo(string.format("\a%s%s\a%s   yaw modifier\n%s%s", unpack(v68)), {
                        [1] = "disabled", 
                        [2] = "center", 
                        [3] = "offset", 
                        [4] = "random", 
                        [5] = "spin", 
                        [6] = "3-way", 
                        [7] = "5-way"
                    });
                    v72.jitter_offset = v72.jitter:create():slider(string.format("\a%s%s\a%s   offset\n%s%s", unpack(v69)), -180, 180, 0);
                    v72.body_yaw = l_builder_0:switch(string.format("\a%s%s\a%s   body yaw\n%s%s", unpack(v70)));
                    local v75 = v72.body_yaw:create();
                    v72.inverter = v75:switch(string.format("\a%s%s\a%s   inverter\n%s%s", unpack(v70)));
                    v72.left_limit = v75:slider(string.format("\a%s%s\a%s   left limit\n%s%s", unpack(v69)), 0, 60, 60);
                    v72.right_limit = v75:slider(string.format("\a%s%s\a%s   right limit\n%s%s", unpack(v69)), 0, 60, 60);
                    v72.body_yaw_options = v75:selectable(string.format("\a%s%s\a%s   option\n%s%s", unpack(v68)), {
                        [1] = "jitter", 
                        [2] = "randomize jitter", 
                        [3] = "dodge"
                    });
                    v72.dodge_strength = v75:slider(string.format("\a%s%s\a%s   dodge strength\n%s%s", unpack(v69)), 30, 100, 70, 1, function(v76)
                        return string.format("%d%%", v76);
                    end);
                    v72.dodge_threshold = v75:slider(string.format("\a%s%s\a%s   dodge threshold\n%s%s", unpack(v69)), 3, 10, 5, 1, function(v77)
                        return string.format("%d\194\176", v77);
                    end);
                    v72.body_yaw_freestanding = v75:combo(string.format("\a%s%s\a%s   freestanding\n%s%s", unpack(v68)), {
                        [1] = "off", 
                        [2] = "peek fake", 
                        [3] = "peek real"
                    });
                    v72.yaw_delay_master = l_builder_0:switch(string.format("\a%s%s\a%s   yaw desync\n%s%s", unpack(v70)));
                    local v78 = v72.yaw_delay_master:create();
                    v72.yaw_delay = v78:slider(string.format("\a%s%s\a%s   delay\n%s%s", unpack(v69)), 1, 101, 1, 1, function(v79)
                        return v79 == 1 and "off" or v79 == 101 and "auto" or string.format("%d%%", v79);
                    end);
                    v72.yaw_delay_l = v78:slider(string.format("\a%s%s\a%s   left delay\n%s%s", unpack(v69)), 0, 15, 0, 1, function(v80)
                        return v80 == 0 and "sync" or v80 == 15 and "auto" or string.format("%dt", v80);
                    end);
                    v72.yaw_delay_r = v78:slider(string.format("\a%s%s\a%s   right delay\n%s%s", unpack(v69)), 0, 15, 0, 1, function(v81)
                        return v81 == 0 and "sync" or v81 == 15 and "auto" or string.format("%dt", v81);
                    end);
                    v72.defensive = l_builder_0:switch(string.format("\a%s%s\a%s   force defensive\n%s%s", unpack(v70)));
                    v72.defensive_aa = l_builder_0:switch(string.format("\a%s%s\a%s   defensive anti-aim\n%s%s", unpack(v71)));
                    local v82 = v72.defensive_aa:create();
                    v72.defensive_conds = v82:selectable(string.format("\a%s%s\a%s   conditions\n%s%s", unpack(v68)), {
                        [1] = "pre-flick", 
                        [2] = "visible only"
                    });
                    v72.defensive_pitch = v82:combo(string.format("\a%s%s\a%s   defensive pitch\n%s%s", unpack(v68)), {
                        [1] = "inherited", 
                        [2] = "down", 
                        [3] = "zero", 
                        [4] = "up", 
                        [5] = "safe up", 
                        [6] = "custom"
                    });
                    v72.defensive_yaw = v82:combo(string.format("\a%s%s\a%s   defensive yaw\n%s%s", unpack(v68)), {
                        [1] = "inherited", 
                        [2] = "static"
                    });
                    v72.defensive_pitch_slider = v82:slider(string.format("\a%s%s\a%s   defensive pitch\n%s%s", unpack(v69)), -89, 89, 0, 1, function(v83)
                        return string.format("%d\194\176", v83);
                    end);
                    v72.defensive_yaw_slider = v82:slider(string.format("\a%s%s\a%s   defensive yaw\n%s%s", unpack(v69)), -180, 181, 0, 1, function(v84)
                        return v84 == 181 and "auto" or v84;
                    end);
                    if v63 == 1 then
                        v72.state_enabled:disabled(true);
                    end;
                    v0.elem.builders.panel[v63][v65] = v72;
                end;
            end;
        end
    }, 
    keybinds = {
        freestanding = v0.tabs.keybinds:switch(string.format("\a%s%s\a%s   freestanding", v1.cheat.accent_color, ui.get_icon("eye-slash"), v1.cheat.default_color)), 
        manual_yaw = v0.tabs.keybinds:switch(string.format(" \a%s%s\a%s   manual anti-aim", v1.cheat.accent_color, ui.get_icon("arrows-up-down-left-right"), v1.cheat.default_color)), 
        init = function()
            -- upvalues: v0 (ref), v1 (ref)
            local v85 = v0.elem.keybinds.manual_yaw:create();
            local v86 = v0.elem.keybinds.freestanding:create();
            v0.elem.keybinds.manual_bind = v85:combo("Manual", {
                [1] = "Disabled", 
                [2] = "Left", 
                [3] = "Right", 
                [4] = "Backward", 
                [5] = "Forward"
            }):tooltip("bind this");
            v0.elem.keybinds.manual_triggers = v85:selectable("safety options", {
                [1] = "use local view", 
                [2] = "force safety"
            });
            v0.elem.keybinds.fs_bind = v86:switch("Freestanding"):tooltip("bind this");
            v0.elem.keybinds.fs_prioritize = v86:switch("prioritize manual");
            v0.elem.keybinds.fs_safety = v86:switch("force full static");
            v0.elem.keybinds.fs_disablers = v86:selectable("disablers", v1.player.local_state_names);
        end
    }, 
    draw = {
        manual = v0.tabs.draw:switch("draw manual arrows"), 
        logs = v0.tabs.draw:switch("draw aimbot logs"), 
        scope = v0.tabs.draw:switch("draw scope lines"), 
        hitmarker = v0.tabs.draw:switch("draw hitmarker"), 
        indicators = v0.tabs.draw:switch("draw indicators"), 
        watermark = v0.tabs.draw:label("draw watermark"), 
        aspect_ratio = v0.tabs.draw:slider(string.format("\a%s%s\a%s   aspect ratio", v1.cheat.accent_color, ui.get_icon("image-landscape"), v1.cheat.default_color), 0, v1.cheat.ratio_steps - 1, v1.cheat.ratio_steps / 2, 1, function(v87)
            -- upvalues: v1 (ref)
            return v1.cheat.ratio_match[v87] or string.format("%d%%", v87);
        end), 
        init = function()
            -- upvalues: v0 (ref), v1 (ref)
            local v88 = v0.elem.draw.manual:create();
            local v89 = v0.elem.draw.watermark:create();
            local v90 = v0.elem.draw.logs:create();
            local v91 = v0.elem.draw.scope:create();
            local v92 = v0.elem.draw.indicators:create();
            local v93 = v0.elem.draw.hitmarker:create();
            v0.elem.draw.arrow_style = v88:combo("arrow style", {
                [1] = "re-sizable", 
                [2] = "original"
            });
            v0.elem.draw.arrow_size = v88:slider("arrow size", 3, 20, 8, 1, function(v94)
                return v94 == 8 and "default" or string.format("%d%s", v94, "px");
            end);
            v0.elem.draw.arrow_pos = v88:slider("arrow position", 10, 100, 45, 1, function(v95)
                return v95 == 45 and "default" or string.format("%d%s", v95, "px");
            end);
            v0.elem.draw.indicator_start = v92:slider("start", 10, 30, 15, 1, function(v96)
                return string.format("%dpx", v96);
            end);
            v0.elem.draw.indicator_gap = v92:slider("text gap", 0, 5, 1, 1, function(v97)
                return string.format("%d%%", v97);
            end);
            v0.elem.draw.indicator_base = v92:selectable("draw base", v1.indicator.list_names);
            v0.elem.draw.indicator_inline = v92:selectable("inline", v1.indicator.list_names);
            v0.elem.draw.indicator_invert = v92:switch("top inline");
            v0.elem.draw.indicator_center = v92:switch("center flag");
            v0.elem.draw.indicator_responsive = v92:selectable("responsive", {
                [1] = "damage", 
                [2] = "dodge", 
                [3] = "vel. modifier"
            });
            v0.elem.draw.watermark_color = v89:color_picker("draw color", color(255, 255, 255, 255));
            v0.elem.draw.logs_start = v90:slider("draw offset", 100, 350, 200, 1, function(v98)
                return string.format("%dpx", v98);
            end);
            v0.elem.draw.logs_draw = v90:selectable("draw logs", {
                [1] = "hit", 
                [2] = "miss", 
                [3] = "grenade dmg", 
                [4] = "knifed"
            });
            v0.elem.draw.logs_console = v90:selectable("console logs", {
                [1] = "hit", 
                [2] = "miss", 
                [3] = "grenade dmg", 
                [4] = "knifed"
            });
            v0.elem.draw.logs_corner = v90:switch("draw corner logs");
            v0.elem.draw.logs_small = v90:switch("small fonts");
            v0.elem.draw.logs_hit = v90:color_picker("hit color", color(150, 200, 60, 255));
            v0.elem.draw.logs_miss = v90:color_picker("miss color", color(255, 105, 100, 175));
            v0.elem.draw.logs_nade = v90:color_picker("nades color", color(255, 255, 0, 200));
            v0.elem.draw.logs_lethal = v90:color_picker("lethal color", color(200, 200, 255, 255));
            v0.elem.draw.scope_line_length = v91:slider("length", 0, 500, 190);
            v0.elem.draw.scope_line_gap = v91:slider("gap", 0, 500, 15);
            v0.elem.draw.scope_line_speed = v91:slider("speed", 3, 20, 12, 1);
            v0.elem.draw.scope_line_color = v91:color_picker("scope color", color(255, 255, 255, 255));
            v0.elem.draw.arrow_style:set_callback(function()
                -- upvalues: v0 (ref)
                local v99 = v0.elem.draw.arrow_style:get();
                v0.elem.draw.arrow_size:visibility(v99 == "re-sizable");
                v0.elem.draw.arrow_pos:visibility(v99 == "re-sizable");
            end, true);
            v0.elem.draw.hitmarker_toggle = v93:selectable("types", {
                [1] = "screen", 
                [2] = "world"
            });
            v0.elem.draw.hitmarker_length = v93:slider("hitmarker length", 1, 10, 5);
            v0.elem.draw.hitmarker_gap = v93:slider("hitmarker gap", 1, 10, 5);
            v0.elem.draw.hitmarker_apply_color = v93:selectable("apply dynamic color", {
                [1] = "screen", 
                [2] = "world"
            });
            v0.elem.draw.hitmarker_default_color = v93:color_picker("default color", color(255, 255, 255, 255));
            v0.elem.draw.hitmarker_headshot_color = v93:color_picker("headshot color", color(255, 105, 100, 255));
            v0.elem.draw.hitmarker_lethal_color = v93:color_picker("lethal color", color(255, 255, 0, 255));
        end
    }, 
    player = {
        animations = v0.tabs.player:switch(string.format("\a%s%s\a%s   player animations", v1.cheat.highlight, ui.get_icon("triangle-exclamation"), v1.cheat.highlight)), 
        fake_tuff = v0.tabs.player:switch(string.format("\a%s%s\a%s   fake tuff", v1.cheat.highlight, ui.get_icon("dove"), v1.cheat.highlight)), 
        fall_damage = v0.tabs.player:switch(string.format("\a%s%s\a%s   no fall damage", v1.cheat.accent_color, ui.get_icon("wind"), v1.cheat.default_color)), 
        fast_ladder = v0.tabs.player:switch(string.format("\a%s%s\a%s   fast ladder", v1.cheat.accent_color, ui.get_icon("forward"), v1.cheat.default_color)), 
        unlock_speed = v0.tabs.player:switch(string.format("\a%s%s\a%s   modify fake duck speed", v1.cheat.accent_color, ui.get_icon("gauge"), v1.cheat.default_color)), 
        freezetime_fd = v0.tabs.player:switch(string.format("\a%s%s\a%s   freeze time fake duck", v1.cheat.accent_color, ui.get_icon("shield-virus"), v1.cheat.default_color)), 
        scope_transparency = v0.tabs.player:switch(string.format("\a%s%s\a%s   maintain transparency", v1.cheat.accent_color, ui.get_icon("eye"), v1.cheat.default_color)), 
        init = function()
            -- upvalues: v0 (ref)
            local v100 = v0.elem.player.animations:create();
            local v101 = v0.elem.player.fast_ladder:create();
            v0.elem.player.anim_options = v100:selectable("animations", {
                [1] = "static in air", 
                [2] = "zero pitch on land", 
                [3] = "drag"
            });
            v0.elem.player.lean_amount = v100:slider("lean amount", 0, 100, 0, 1, function(v102)
                return string.format("%d%%", v102);
            end);
            v0.elem.player.ladder_yaw = v101:slider("ladder yaw", -180, 180, 0, 1, function(v103)
                return string.format("%d\194\176", v103);
            end);
        end
    }, 
    misc = {
        pingspike = v0.tabs.misc:switch(string.format("\a%s%s\a%s   unlock ping spike", v1.cheat.accent_color, ui.get_icon("unlock"), v1.cheat.default_color)), 
        client_name = v0.tabs.misc:switch(string.format("\a%s%s\a%s   client-sided name", v1.cheat.accent_color, ui.get_icon("user"), v1.cheat.default_color)), 
        custom_viewmodel = v0.tabs.misc:switch(string.format("\a%s%s\a%s   custom viewmodel", v1.cheat.accent_color, ui.get_icon("bars"), v1.cheat.default_color)), 
        world_tone = v0.tabs.misc:switch(string.format("\a%s%s\a%s   world hdr fix (chams)", v1.cheat.accent_color, ui.get_icon("globe"), v1.cheat.default_color)), 
        trashtalk = v0.tabs.misc:switch(string.format("\a%s%s\a%s    trash talk", v1.cheat.accent_color, ui.get_icon("trash"), v1.cheat.default_color)), 
        dropping = v0.tabs.misc:switch(string.format("\a%s%s\a%s   drop nades", v1.cheat.accent_color, ui.get_icon("bomb"), v1.cheat.default_color)), 
        hideshots = v0.tabs.misc:switch(string.format("\a%s%s\a%s   automatic hide shots", v1.cheat.accent_color, ui.get_icon("gear"), v1.cheat.default_color)), 
        init = function()
            -- upvalues: v0 (ref), v1 (ref)
            local v104 = v0.elem.misc.pingspike:create();
            local v105 = v0.elem.misc.client_name:create();
            local v106 = v0.elem.misc.custom_viewmodel:create();
            local v107 = v0.elem.misc.trashtalk:create();
            local v108 = v0.elem.misc.dropping:create();
            local v109 = v0.elem.misc.hideshots:create();
            v0.elem.misc.pingspike_target = v104:slider("target ping", 0, 200, 0, 1, function(v110)
                return string.format("%dms", v110);
            end);
            v0.elem.misc.name_input = v105:input("override name");
            v0.elem.misc.name_update = v105:button("  update name  ", nil, true);
            v0.elem.misc.viewmodel_x = v106:slider("x", -20, 20, 2);
            v0.elem.misc.viewmodel_y = v106:slider("y", -100, 100, 2);
            v0.elem.misc.viewmodel_z = v106:slider("z", -20, 20, -2);
            v0.elem.misc.viewmodel_fov = v106:slider("additional fov", -60, 60, 0);
            v0.elem.misc.viewmodel_rotation = v106:slider("view rotation", 0, 360, 0);
            v0.elem.misc.trashtalk_options = v107:selectable("trashtalk options", {
                [1] = "add delay", 
                [2] = "reply", 
                [3] = "xyren"
            });
            v0.elem.misc.trashtalk_delay = v107:slider("trashtalk delay", 1, 10, 1, 1, function(v111)
                if v111 == 1 then
                    return "auto";
                else
                    return string.format("%ds", v111);
                end;
            end);
            v0.elem.misc.trashtalk_level = v107:slider("trashtalk level", 1, 3, 1);
            v0.elem.misc.drop_nades = v108:hotkey("drop");
            v0.elem.misc.list_nades = v108:selectable("nades list", v1.grenade.list);
            v0.elem.misc.hideshots_state = v109:selectable("hs states", v1.player.local_state_names);
        end
    }, 
    debug = {}, 
    init = function()
        -- upvalues: v0 (ref)
        v0.elem.modifiers.init();
        v0.elem.builders.init();
        v0.elem.keybinds.init();
        v0.elem.draw.init();
        v0.elem.player.init();
        v0.elem.misc.init();
    end
};
v0.elem.init();
v2.init = function()
    -- upvalues: v0 (ref), v1 (ref), v2 (ref)
    for _, v113 in pairs(v0.elem) do
        if type(v113) ~= "function" then
            for v114, v115 in pairs(v113) do
                if type(v115) == "function" or not (type(v115) ~= "table") or type(v115) == "userdata" and v115:type() == "label" then
                    if type(v115) == "table" then
                        v1.anti_aim.menu_values[v114] = v1.anti_aim.menu_values[v114] or {};
                        for v116, v117 in pairs(v115) do
                            local v118 = math.max(0, v116 - 1);
                            v1.anti_aim.menu_values[v114][v118] = v1.anti_aim.menu_values[v114][v118] or {};
                            for v119, v120 in pairs(v117) do
                                v1.anti_aim.menu_values[v114][v118][v119] = v1.anti_aim.menu_values[v114][v118][v119] or {};
                                for v121, v122 in pairs(v120) do
                                    v2.utils.bind(v122, v2.init);
                                    v1.anti_aim.menu_values[v114][v118][v119][v121] = v122:get();
                                end;
                            end;
                        end;
                    end;
                else
                    v2.utils.bind(v115, v2.init);
                    v1.anti_aim.menu_values[v114] = v115:get();
                end;
            end;
        end;
    end;
    v2.handle();
end;
misc = {
    update_aspect_ratio = function()
        -- upvalues: l_menu_values_0 (ref)
        local v123 = render.screen_size();
        local v124 = 2 - l_menu_values_0.aspect_ratio * 0.01;
        local v125 = v123.x * v124 / v123.y;
        if v124 == 1 then
            v125 = 0;
        end;
        cvar.r_aspectratio:float(v125);
    end, 
    setup_aspect_ratio = function()
        -- upvalues: v1 (ref), v2 (ref)
        local v126 = render.screen_size();
        for v127 = 1, v1.cheat.ratio_steps do
            local v128 = (v1.cheat.ratio_steps - v127) * v1.cheat.ratio_mutlipler;
            local v129 = v2.utils.gcd(v126.x * v128, v126.y);
            if v126.x * v128 / v129 < 100 or v128 == 1 then
                v1.cheat.ratio_match[v127] = v126.x * v128 / v129 .. ":" .. v126.y / v129;
            end;
        end;
    end, 
    update_ping_spike = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        local l_ping_0 = v0.ref.misc.ping;
        local l_pingspike_0 = l_menu_values_0.pingspike;
        local l_pingspike_target_0 = l_menu_values_0.pingspike_target;
        l_ping_0:disabled(l_pingspike_0);
        l_ping_0:override(l_pingspike_0 and l_pingspike_target_0 or nil);
        v0.elem.misc.pingspike:set_callback(misc.update_ping_spike);
        v0.elem.misc.pingspike_target:set_callback(misc.update_ping_spike);
    end, 
    update_world_tone = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        local l_world_tone_0 = v0.elem.misc.world_tone;
        cvar.mat_force_tonemap_scale:float(l_menu_values_0.world_tone and 1 or 0);
        l_world_tone_0:set_callback(misc.update_world_tone);
    end, 
    restore_client_name = function()
        -- upvalues: l_menu_values_0 (ref), v1 (ref)
        local _ = entity.get_local_player();
        local v135 = panorama.MyPersonaAPI.GetName();
        local l_name_input_0 = l_menu_values_0.name_input;
        local l_client_name_0 = l_menu_values_0.client_name;
        if v1.player.clear_previous and (not l_client_name_0 or l_name_input_0 == "") then
            misc.update_client_name(v135);
            v1.player.clear_previous = false;
        end;
    end, 
    update_client_name = function(v138)
        -- upvalues: v12 (ref), v13 (ref)
        local v139 = entity.get_local_player();
        if not v139 then
            return;
        else
            local v140 = v12[0][0];
            if not v140 then
                return;
            else
                local v141 = ffi.cast("void***", v140 + 21184)[0];
                if not v141 then
                    return;
                else
                    local v142 = v13(v141, v139:get_index() - 1, nil);
                    if not v142 then
                        return;
                    else
                        local _ = ffi.string(v142[0].szName);
                        ffi.copy(v142[0].szName, v138, #v138 + 1);
                        return;
                    end;
                end;
            end;
        end;
    end, 
    call_client_name = function()
        -- upvalues: l_menu_values_0 (ref), v1 (ref), v0 (ref)
        if not entity.get_local_player() then
            return;
        else
            local l_name_input_1 = l_menu_values_0.name_input;
            if l_menu_values_0.client_name and l_name_input_1 ~= "" then
                misc.update_client_name(l_name_input_1);
                v1.player.clear_previous = true;
            elseif l_name_input_1 == "" then
                misc.restore_client_name();
            end;
            v0.elem.misc.client_name:set_callback(misc.restore_client_name);
            v0.elem.misc.name_update:set_callback(misc.call_client_name);
            return;
        end;
    end, 
    update_localplayer_transparency = function()
        local v145 = entity.get_local_player();
        if not v145 or not v145:is_alive() then
            return;
        else
            local l_m_bIsScoped_0 = v145.m_bIsScoped;
            local l_m_bResumeZoom_0 = v145.m_bResumeZoom;
            if l_m_bIsScoped_0 or l_m_bResumeZoom_0 then
                return 50;
            else
                return;
            end;
        end;
    end, 
    call_local_transparency = function()
        -- upvalues: l_menu_values_0 (ref), v0 (ref)
        local l_scope_transparency_0 = l_menu_values_0.scope_transparency;
        v0.elem.player.scope_transparency:set_callback(misc.call_local_transparency);
        events.localplayer_transparency(misc.update_localplayer_transparency, l_scope_transparency_0);
    end, 
    update_viewmodel = function(v149)
        -- upvalues: l_menu_values_0 (ref), v8 (ref), v15 (ref)
        local v150 = entity.get_local_player();
        local l_viewmodel_rotation_0 = l_menu_values_0.viewmodel_rotation;
        local v152 = v150.m_hViewModel[0];
        if not v150 or not v152 then
            return;
        else
            local v153 = ffi.new(v8);
            local l_x_0 = v149.view.x;
            local l_y_0 = v149.view.y;
            v153.z = l_viewmodel_rotation_0;
            v153.y = l_y_0;
            v153.x = l_x_0;
            l_x_0 = v152[0];
            v15(l_x_0, v153);
            return;
        end;
    end, 
    call_viewmodel = function()
        -- upvalues: l_menu_values_0 (ref), v0 (ref), v1 (ref)
        local v156 = entity.get_local_player();
        if not v156 or not v156:is_alive() then
            return;
        else
            local l_custom_viewmodel_0 = l_menu_values_0.custom_viewmodel;
            events.override_view(misc.update_viewmodel, l_custom_viewmodel_0);
            v0.elem.misc.custom_viewmodel:set_callback(misc.call_viewmodel);
            v0.elem.misc.viewmodel_x:set_callback(misc.call_viewmodel);
            v0.elem.misc.viewmodel_y:set_callback(misc.call_viewmodel);
            v0.elem.misc.viewmodel_z:set_callback(misc.call_viewmodel);
            v0.elem.misc.viewmodel_fov:set_callback(misc.call_viewmodel);
            if not l_custom_viewmodel_0 then
                if v1.viewmodel.reset then
                    cvar.viewmodel_offset_x:int(v1.viewmodel.cache.x, false);
                    cvar.viewmodel_offset_y:int(v1.viewmodel.cache.y, false);
                    cvar.viewmodel_offset_z:int(v1.viewmodel.cache.z, false);
                    cvar.viewmodel_fov:int(v1.viewmodel.cache.fov, false);
                    v1.viewmodel.reset = false;
                    v1.viewmodel.cache = {};
                end;
                return;
            else
                if v1.viewmodel.cache.x == nil then
                    v1.viewmodel.cache = {
                        x = cvar.viewmodel_offset_x:float(), 
                        y = cvar.viewmodel_offset_y:float(), 
                        z = cvar.viewmodel_offset_z:float(), 
                        fov = cvar.viewmodel_fov:float()
                    };
                    v1.viewmodel.reset = true;
                end;
                local l_viewmodel_x_0 = l_menu_values_0.viewmodel_x;
                local l_viewmodel_y_0 = l_menu_values_0.viewmodel_y;
                local l_viewmodel_z_0 = l_menu_values_0.viewmodel_z;
                local l_viewmodel_fov_0 = l_menu_values_0.viewmodel_fov;
                cvar.viewmodel_offset_x:int(l_viewmodel_x_0, true);
                cvar.viewmodel_offset_y:int(l_viewmodel_y_0, true);
                cvar.viewmodel_offset_z:int(l_viewmodel_z_0, true);
                cvar.viewmodel_fov:int(60 + l_viewmodel_fov_0, true);
                return;
            end;
        end;
    end, 
    player_animations = function(_)
        -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref), v0 (ref)
        local l_animations_0 = l_menu_values_0.animations;
        local l_anim_options_0 = l_menu_values_0.anim_options;
        local v165 = entity.get_local_player();
        if not l_animations_0 then
            return;
        elseif not v165 or not v165:is_alive() then
            return;
        else
            local v166 = v165:get_anim_state();
            if v2.utils.search(l_anim_options_0, "static in air") and v1.player.local_state >= 6 then
                v165.m_flPoseParameter[6] = 0.5;
            end;
            if v2.utils.search(l_anim_options_0, "zero pitch on land") and v166.landing and v1.player.local_state < 6 then
                v165.m_flPoseParameter[12] = 0.5;
            end;
            if v2.utils.search(l_anim_options_0, "drag") and v1.player.local_state < 6 then
                v165.m_flPoseParameter[0] = 0;
                v0.ref.misc.leg_movement:set(globals.tickcount % 3 == 0 and "Sliding" or "Walking");
            end;
            if l_menu_values_0.lean_amount > 0 then
                local v167 = v2.utils.get_anim_overlay(v165[0], 12);
                if not v167 then
                    return;
                elseif v1.player.local_state ~= 1 and v1.player.local_state ~= 3 then
                    v167.weight = l_menu_values_0.lean_amount * 0.01;
                end;
            end;
            return;
        end;
    end, 
    call_player_animations = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        local l_animations_1 = v0.elem.player.animations;
        local l_animations_2 = l_menu_values_0.animations;
        l_animations_1:set_callback(misc.call_player_animations);
        events.post_update_clientside_animation(misc.player_animations, l_animations_2);
    end, 
    simulate = function(v170, v171)
        local l_m_fFlags_0 = v171.m_fFlags;
        local l_m_vecVelocity_0 = v171.m_vecVelocity;
        local v174 = bit.band(bit.lshift(1, 0), l_m_fFlags_0) == 1;
        local v175 = utils.net_channel();
        local v176 = v175 and v175.latency[1] or 0;
        local v177 = to_ticks(v176);
        local v178 = v171:simulate_movement();
        v178:think(1 + v177);
        local l_flags_0 = v178.flags;
        if bit.band(bit.lshift(1, 0), l_flags_0) == 1 and not v174 and l_m_vecVelocity_0.z < -500 and not has_crouch then
            has_crouch = true;
            v170.in_duck = true;
        end;
        if v174 then
            has_crouch = false;
        end;
    end, 
    fast_ladder = function(v180, v181)
        -- upvalues: l_menu_values_0 (ref)
        local l_m_MoveType_0 = v181.m_MoveType;
        local v183 = render.camera_angles();
        local l_fast_ladder_0 = l_menu_values_0.fast_ladder;
        local l_ladder_yaw_0 = l_menu_values_0.ladder_yaw;
        if l_m_MoveType_0 ~= 9 or not l_fast_ladder_0 then
            return;
        else
            if v180.forwardmove == 0 and l_ladder_yaw_0 ~= 0 then
                v180.view_angles.x = 89;
                v180.view_angles.y = v180.view_angles.y + l_ladder_yaw_0;
                local v186 = math.abs(l_ladder_yaw_0);
                if v186 > 0 and v186 < 180 and v180.sidemove ~= 0 then
                    v180.view_angles.y = v180.view_angles.y - l_ladder_yaw_0;
                elseif v186 == 180 then
                    v180.in_moveleft = v180.sidemove > 0;
                    v180.in_moveright = v180.sidemove < 0;
                end;
            elseif v180.forwardmove > 0 and v183.x < 45 then
                v180.view_angles.x = 89;
                v180.in_moveright = true;
                v180.in_moveleft = false;
                v180.in_forward = false;
                v180.in_back = true;
                if v180.sidemove == 0 then
                    v180.view_angles.y = v180.view_angles.y + 90;
                elseif v180.sidemove < 0 then
                    v180.view_angles.y = v180.view_angles.y + 150;
                else
                    v180.view_angles.y = v180.view_angles.y + 30;
                end;
            elseif v180.forwardmove < 0 then
                v180.view_angles.x = 89;
                v180.in_moveleft = true;
                v180.in_moveright = false;
                v180.in_forward = true;
                v180.in_back = false;
                if v180.sidemove == 0 then
                    v180.view_angles.y = v180.view_angles.y + 90;
                elseif v180.sidemove > 0 then
                    v180.view_angles.y = v180.view_angles.y + 150;
                else
                    v180.view_angles.y = v180.view_angles.y + 30;
                end;
            end;
            return;
        end;
    end, 
    modify_fakeduck_speed = function(v187, v188)
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        if not v0.ref.misc.fake_duck:get() or not l_menu_values_0.unlock_speed then
            return;
        else
            local v189 = vector(v187.forwardmove, v187.sidemove);
            local v190 = v188.m_vecVelocity:length2d();
            v189:normalize();
            if v190 >= 10 then
                v187.forwardmove = v189.x * 125;
                v187.sidemove = v189.y * 125;
            end;
            return;
        end;
    end, 
    modify_freezetime_eyeview = function(v191)
        -- upvalues: v1 (ref)
        local v192 = entity.get_local_player();
        if not v192 or not v192:is_alive() then
            return;
        elseif not v1.player.freeze_duck then
            return;
        else
            local v193 = v192:get_origin();
            v191.camera.z = v193.z + 64;
            return;
        end;
    end, 
    call_freezetime_eyeview = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        local l_freezetime_fd_0 = v0.elem.player.freezetime_fd;
        local l_freezetime_fd_1 = l_menu_values_0.freezetime_fd;
        l_freezetime_fd_0:set_callback(misc.call_player_animations);
        events.override_view(misc.modify_freezetime_eyeview, l_freezetime_fd_1);
    end, 
    modify_freeztime_duck = function(v196, v197)
        -- upvalues: v0 (ref), v1 (ref), l_menu_values_0 (ref)
        local v198 = v0.ref.misc.fake_duck:get();
        local v199 = entity.get_game_rules();
        v1.player.freeze_duck = false;
        v0.ref.rage.double_tap:override();
        v0.ref.rage.hide_shots:override();
        rage.exploit:allow_charge(true);
        if not v199 then
            return;
        elseif not v199.m_bFreezePeriod then
            return;
        elseif not v198 or not l_menu_values_0.freezetime_fd then
            return;
        else
            v196.send_packet = false;
            rage.exploit:allow_charge(false);
            v0.ref.rage.double_tap:override(false);
            v0.ref.rage.hide_shots:override(false);
            local _ = v197.m_flDuckAmount;
            local _ = v196.choked_commands;
            local l_choked_commands_1 = v196.choked_commands;
            local v203 = 16 / 2;
            v1.player.freeze_duck = true;
            if v203 <= l_choked_commands_1 then
                v196.in_duck = true;
            end;
            return;
        end;
    end, 
    modify_tuff_eyeview = function(v204)
        -- upvalues: v1 (ref)
        local v205 = entity.get_local_player();
        if not v205 or not v205:is_alive() then
            return;
        else
            local v206 = v205:get_origin();
            if not v1.player.fake_tuff then
                return;
            elseif not common.is_in_thirdperson() then
                return;
            else
                v204.camera.z = v206.z + 64;
                return;
            end;
        end;
    end, 
    call_fake_tuff_eyeview = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref)
        local l_fake_tuff_0 = v0.elem.player.fake_tuff;
        local l_fake_tuff_1 = l_menu_values_0.fake_tuff;
        l_fake_tuff_0:set_callback(misc.call_fake_tuff_eyeview);
        events.override_view(misc.modify_tuff_eyeview, l_fake_tuff_1);
    end, 
    fake_tuff = function(v209, v210)
        -- upvalues: v0 (ref), v1 (ref), l_menu_values_0 (ref)
        local l_fake_duck_0 = v0.ref.misc.fake_duck;
        local v212 = v210:get_player_weapon();
        v1.player.fake_tuff = false;
        if not v212 then
            l_fake_duck_0:override();
            return;
        else
            local v213 = v212:get_weapon_info();
            if not v213 then
                l_fake_duck_0:override();
                return;
            elseif v213.cycle_time < 1 or not l_fake_duck_0:get() or not l_menu_values_0.fake_tuff then
                l_fake_duck_0:override();
                return;
            else
                v1.player.fake_tuff = true;
                local _ = v210.m_flNextAttack;
                local l_m_flNextPrimaryAttack_0 = v212.m_flNextPrimaryAttack;
                local _ = v210.m_flDuckAmount;
                v209.in_duck = true;
                l_fake_duck_0:override(globals.curtime >= l_m_flNextPrimaryAttack_0);
                return;
            end;
        end;
    end, 
    binding = function()
        -- upvalues: v0 (ref), l_menu_values_0 (ref), v2 (ref), v1 (ref), v5 (ref), v6 (ref)
        v0.elem.builders.team_export:set_callback(function()
            -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref), v0 (ref)
            local l_team_slider_0 = l_menu_values_0.team_slider;
            local l_current_state_0 = l_menu_values_0.current_state;
            local _, v220 = v2.utils.search(v1.player.extra_state_names, l_current_state_0);
            local v221 = l_team_slider_0 == 1 and 2 or 1;
            for v222, v223 in pairs(v0.elem.builders.panel[v220][l_team_slider_0]) do
                v0.elem.builders.panel[v220][v221][v222]:set(v223:get());
            end;
            print_raw(string.format("\a%sacatel\aDEFAULT \194\183 synced %s's %s anti-aim to %s's %s antiaim", v1.cheat.accent_color, v1.player.team_state[l_team_slider_0], l_current_state_0, v1.player.team_state[v221], l_current_state_0));
        end);
        v0.elem.builders.state_export:set_callback(function()
            -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref), v0 (ref)
            local l_state_to_export_0 = l_menu_values_0.state_to_export;
            local l_current_state_1 = l_menu_values_0.current_state;
            local l_team_slider_1 = l_menu_values_0.team_slider;
            local _, v228 = v2.utils.search(v1.player.extra_state_names, l_current_state_1);
            local _, v230 = v2.utils.search(v1.player.extra_state_names, l_state_to_export_0);
            if v228 == v230 then
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 context state can't not be the same as the current", v1.cheat.accent_color, l_current_state_1));
                return;
            else
                for v231, v232 in pairs(v0.elem.builders.panel[v228][l_team_slider_1]) do
                    v0.elem.builders.panel[v230][l_team_slider_1][v231]:set(v232:get());
                end;
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 synced %s anti-aim to %s antiaim", v1.cheat.accent_color, l_current_state_1, l_state_to_export_0));
                return;
            end;
        end);
        generate_config = function()
            -- upvalues: v0 (ref), v5 (ref)
            local v233 = {};
            for v234, v235 in pairs(v0.elem) do
                if type(v235) ~= "function" and v234 ~= "home" then
                    v233[v234] = v233[v234] or {};
                    for v236, v237 in pairs(v235) do
                        if type(v237) == "function" or not (type(v237) ~= "table") or type(v237) == "userdata" and (not (v237:type() ~= "label") or not (v237:type() ~= "button") or not (v237:type() ~= "textbox") or v237:type() == "hotkey") then
                            if type(v237) == "table" then
                                v233[v234][v236] = v233[v234][v236] or {};
                                for v238, v239 in pairs(v237) do
                                    local v240 = math.max(0, v238 - 1);
                                    v233[v234][v236][v240] = v233[v234][v236][v240] or {};
                                    for v241, v242 in pairs(v239) do
                                        v233[v234][v236][v240][v241] = v233[v234][v236][v240][v241] or {};
                                        for v243, v244 in pairs(v242) do
                                            v233[v234][v236][v240][v241][v243] = v244:get();
                                        end;
                                    end;
                                end;
                            end;
                        else
                            v233[v234][v236] = v237:type() == "color_picker" and {
                                v237:get():unpack()
                            } or v237:get();
                        end;
                    end;
                end;
            end;
            local v245 = json.stringify(v233);
            return (v5.base64.encode(v245));
        end;
        load_config = function(v246)
            -- upvalues: v5 (ref), v0 (ref)
            local l_status_0, l_result_0 = pcall(function()
                -- upvalues: v5 (ref), v246 (ref), v0 (ref)
                local v247 = v5.base64.decode(v246);
                local v248 = json.parse(v247);
                for v249, v250 in pairs(v248) do
                    for v251, v252 in pairs(v250) do
                        if type(v252) == "table" and type(v0.elem[v249][v251]) ~= "userdata" then
                            for v253, v254 in pairs(v252) do
                                for v255, v256 in pairs(v254) do
                                    for v257, v258 in pairs(v256) do
                                        local v259 = v0.elem[v249][v251][v253][v255][v257];
                                        if v259 then
                                            v259:set(v259:type() == "color_picker" and color(unpack(v258)) or v258);
                                        end;
                                    end;
                                end;
                            end;
                        else
                            local v260 = v0.elem[v249][v251];
                            if v260 and v260:type() ~= "hotkey" then
                                v260:set(v260:type() == "color_picker" and color(unpack(v252)) or v252);
                            end;
                        end;
                    end;
                end;
            end);
            return l_status_0, l_result_0;
        end;
        v0.elem.home.config:set_callback(function()
            -- upvalues: v0 (ref)
            local l_config_0 = v0.elem.home.config;
            v0.elem.home.config_name:set(l_config_0:list()[l_config_0:get()] or "");
        end);
        v0.elem.home.save:set_callback(function()
            -- upvalues: v0 (ref), v1 (ref), v2 (ref), v6 (ref)
            local v264 = generate_config();
            local l_config_1 = v0.elem.home.config;
            local v266 = v0.elem.home.config_name:get();
            if v266 == "" then
                return;
            elseif v266 == "main" then
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 cannot override main config", v1.cheat.highlight));
                return;
            else
                if not v2.utils.search(v1.cheat.config, v266) then
                    table.insert(v1.cheat.config, v266);
                end;
                v1.cheat.config_value[v266] = v264;
                l_config_1:update(v1.cheat.config);
                v6.configs = v1.cheat.config;
                v6.configs_values = v1.cheat.config_value;
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 saved %s config", v1.cheat.accent_color, v266));
                db.acatel = v6;
                return;
            end;
        end);
        v0.elem.home.load:set_callback(function()
            -- upvalues: v0 (ref), v1 (ref)
            local v267 = v0.elem.home.config_name:get();
            local v268 = v1.cheat.config_value[v267];
            if v267 == "" then
                return;
            else
                local v269, _ = load_config(v268);
                if v269 then
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 loaded %s config", v1.cheat.accent_color, v267));
                else
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 %s config can't be loaded", v1.cheat.highlight, v267));
                end;
                return;
            end;
        end);
        v0.elem.home.delete:set_callback(function()
            -- upvalues: v0 (ref), v1 (ref), v2 (ref), v6 (ref)
            local _ = generate_config();
            local l_config_2 = v0.elem.home.config;
            local v273 = v0.elem.home.config_name:get();
            if v273 == "main" then
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 cannot delete main config", v1.cheat.highlight));
                return;
            else
                local v274, v275 = v2.utils.search(v1.cheat.config, v273);
                if v274 then
                    table.remove(v1.cheat.config, v275);
                    v1.cheat.config_value[v273] = nil;
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 deleted %s config", v1.cheat.accent_color, v273));
                else
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 %s config doesn't exist", v1.cheat.highlight, v273));
                end;
                l_config_2:update(v1.cheat.config);
                local v276 = l_config_2:list();
                v0.elem.home.config_name:set(v276[math.max(1, l_config_2:get() - 1)]);
                v6.configs = v1.cheat.config;
                v6.configs_values = v1.cheat.config_value;
                db.acatel = v6;
                return;
            end;
        end);
        v0.elem.home.import:set_callback(function()
            -- upvalues: v5 (ref), v1 (ref)
            local v277 = v5.clipboard.get();
            if not v277 or v277 == "" then
                return;
            else
                local v278 = v277:gsub("%s+", "");
                if load_config(v278) then
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 imported config", v1.cheat.accent_color));
                else
                    print_raw(string.format("\a%sacatel\aDEFAULT \194\183 can't import config", v1.cheat.highlight));
                end;
                return;
            end;
        end);
        v0.elem.home.export:set_callback(function()
            -- upvalues: v5 (ref), v1 (ref)
            local v279 = generate_config();
            if not v279 or v279 == "" then
                return;
            else
                v5.clipboard.set(v279);
                print_raw(string.format("\a%sacatel\aDEFAULT \194\183 exported config", v1.cheat.accent_color));
                return;
            end;
        end);
        v0.elem.home.reset:set_callback(function()
            -- upvalues: v0 (ref), v1 (ref)
            for v280, v281 in pairs(v0.elem) do
                if type(v281) ~= "function" and v280 ~= "home" then
                    for _, v283 in pairs(v281) do
                        if type(v283) == "function" or not (type(v283) ~= "table") or type(v283) == "userdata" and (not (v283:type() ~= "label") or not (v283:type() ~= "button") or v283:type() == "textbox") then
                            if type(v283) == "table" then
                                for _, v285 in pairs(v283) do
                                    for _, v287 in pairs(v285) do
                                        for _, v289 in pairs(v287) do
                                            v289:reset();
                                        end;
                                    end;
                                end;
                            end;
                        else
                            v283:reset();
                        end;
                    end;
                end;
            end;
            print_raw(string.format("\a%sacatel\aDEFAULT \194\183 config has been reset", v1.cheat.accent_color));
        end);
    end, 
    drop_nades = function(v290, v291)
        -- upvalues: l_menu_values_0 (ref), v1 (ref), v0 (ref), v2 (ref)
        if not l_menu_values_0.dropping then
            v1.grenade.old_state = false;
            v1.grenade.all_nades = {};
            return;
        else
            v0.ref.anti_aim.enabled:override();
            local _ = v291:get_player_weapon();
            local _ = v291:get_player_weapon(true);
            local _ = l_menu_values_0.list_nades;
            local _ = {};
            local v296 = utils.net_channel();
            local v297 = (v296 and v296.latency[1] or 0) + 0.05;
            local v298 = v0.elem.misc.drop_nades:get();
            if v1.grenade.old_state ~= v298 then
                v1.grenade.old_state = v298;
                if v298 and not v1.grenade.is_active then
                    local v299 = v291:get_player_weapon(true);
                    v1.grenade.all_nades = {};
                    for _, v301 in pairs(v299) do
                        local v302 = v301:get_weapon_info();
                        if v302 then
                            local v303 = v1.grenades_mismatch[v302.console_name];
                            if v303 and v2.utils.search(l_menu_values_0.list_nades, v303) then
                                table.insert(v1.grenade.all_nades, v301);
                            end;
                        end;
                    end;
                    v1.grenade.is_active = #v1.grenade.all_nades > 0;
                end;
            end;
            if v1.grenade.is_active then
                v0.ref.anti_aim.enabled:override(false);
                v290.send_packet = true;
                v290.no_choke = true;
            end;
            if not v1.grenade.is_active or v1.grenade.is_dropping then
                return;
            else
                v1.grenade.is_dropping = true;
                for v304, v305 in ipairs(v1.grenade.all_nades) do
                    local v306 = v305:get_weapon_info();
                    do
                        local l_v304_0 = v304;
                        do
                            local l_v306_0 = v306;
                            if l_v306_0 then
                                utils.execute_after(v297 * l_v304_0, function()
                                    -- upvalues: l_v306_0 (ref), l_v304_0 (ref), v1 (ref)
                                    utils.console_exec(string.format("use %s; drop", l_v306_0.console_name));
                                    if l_v304_0 == #v1.grenade.all_nades then
                                        utils.execute_after(0.1, function()
                                            -- upvalues: v1 (ref)
                                            v1.grenade.is_active = false;
                                            v1.grenade.is_dropping = false;
                                            v1.grenade.all_nades = {};
                                        end);
                                    end;
                                end);
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
    end, 
    auto_hs = function(_, _)
        -- upvalues: v1 (ref), v0 (ref), l_menu_values_0 (ref), v2 (ref)
        local l_local_state_0 = v1.player.local_state;
        local v312 = v1.player.local_state_names[l_local_state_0];
        v0.ref.rage.double_tap:override();
        v0.ref.rage.hide_shots:override();
        if not l_menu_values_0.hideshots then
            return;
        else
            local v313, _ = v2.utils.search(l_menu_values_0.hideshots_state, v312);
            if v313 then
                v0.ref.rage.double_tap:override(false);
                v0.ref.rage.hide_shots:override(true);
            end;
            return;
        end;
    end, 
    init = function()
        misc.setup_aspect_ratio();
        misc.update_ping_spike();
        misc.update_world_tone();
        misc.call_local_transparency();
        misc.call_viewmodel();
        misc.call_client_name();
        misc.call_player_animations();
        misc.call_freezetime_eyeview();
        misc.call_fake_tuff_eyeview();
        misc.modify_freezetime_eyeview();
        misc.binding();
    end
};
draw = {
    manual_arrows = function(v315)
        -- upvalues: l_menu_values_0 (ref), v1 (ref)
        local l_manual_0 = l_menu_values_0.manual;
        if simulate_me then
            render.circle(simulate_me.origin:to_screen(), color(255, 255, 255, 255), 10, 0, 1);
        end;
        if not l_manual_0 then
            return;
        else
            local _ = l_menu_values_0.arrow_style;
            local l_arrow_size_0 = l_menu_values_0.arrow_size;
            local l_arrow_pos_0 = l_menu_values_0.arrow_pos;
            local l_get_offset_0 = v1.player.get_offset;
            local v321 = math.max(-1, math.min(1, l_get_offset_0));
            local v322 = {
                vector(v315.x + (math.abs(l_get_offset_0) == 90 and l_arrow_pos_0 * v321 or 0), v315.y + (math.abs(l_get_offset_0) == 90 and 0 or math.abs(l_get_offset_0) == 180 and -l_arrow_pos_0 - l_arrow_size_0 or l_menu_values_0.manual_bind == "Backward" and l_arrow_pos_0 + l_arrow_size_0 or 0)), 
                vector(v315.x + (math.abs(l_get_offset_0) == 90 and (l_arrow_pos_0 - 1.6 * l_arrow_size_0) * v321 - (v321 ~= 1 and v321 or 0) or l_arrow_size_0), v315.y + (math.abs(l_get_offset_0) == 90 and l_arrow_size_0 or l_get_offset_0 == 180 and -l_arrow_pos_0 + l_arrow_size_0 or l_menu_values_0.manual_bind == "Backward" and l_arrow_pos_0 - l_arrow_size_0 or 0)), 
                vector(v315.x + (math.abs(l_get_offset_0) == 90 and (l_arrow_pos_0 - 1.6 * l_arrow_size_0) * v321 - (v321 ~= 1 and v321 or 0) or -l_arrow_size_0), v315.y + (math.abs(l_get_offset_0) == 90 and -l_arrow_size_0 or l_get_offset_0 == 180 and -l_arrow_pos_0 + l_arrow_size_0 or l_menu_values_0.manual_bind == "Backward" and l_arrow_pos_0 - l_arrow_size_0 or 0))
            };
            local v323 = v1.anti_aim.manual_arrows[l_menu_values_0.manual_bind];
            if l_menu_values_0.manual_bind ~= "Disabled" then
                if l_menu_values_0.arrow_style == "re-sizable" then
                    render.poly(color(255, 255, 255, 255), v322[1], v322[2], v322[3]);
                else
                    render.text(v1.cheat.fonts.arrow, v315 + v323[2], color(255, 255, 255, 255), "c", v323[1]);
                end;
            end;
            return;
        end;
    end, 
    scope = function(v324, v325, v326)
        -- upvalues: l_menu_values_0 (ref), v0 (ref), v1 (ref), v5 (ref)
        local l_scope_0 = l_menu_values_0.scope;
        local l_scope_overlay_0 = v0.ref.visuals.scope_overlay;
        if not l_scope_0 or not v326 then
            v1.cheat.scope_alpha = 0;
            if l_scope_overlay_0:get_override() then
                l_scope_overlay_0:override();
            end;
            return;
        else
            if not l_scope_overlay_0:get_override() then
                l_scope_overlay_0:override("Remove All");
            end;
            local v329 = v326:is_alive() and v326:get_player_weapon() or nil;
            if not v329 or not v329.m_zoomLevel then
                local _ = nil;
            end;
            local v331 = v326:is_alive() and v326.m_bIsScoped;
            local v332 = v326:is_alive() and v326.m_bResumeZoom;
            local v333 = l_menu_values_0.scope_line_gap > l_menu_values_0.scope_line_length;
            local l_scope_line_color_0 = l_menu_values_0.scope_line_color;
            local v335 = v333 and l_menu_values_0.scope_line_length or l_menu_values_0.scope_line_gap * v325.y / 1080;
            local v336 = v333 and l_menu_values_0.scope_line_gap or l_menu_values_0.scope_line_length * v325.y / 1080;
            local l_scope_line_speed_0 = l_menu_values_0.scope_line_speed;
            local _ = l_menu_values_0.scope_line_rotation;
            local v339 = globals.frametime * l_scope_line_speed_0;
            local v340 = v326:is_alive() and v329 and v331 and not v332;
            local v341 = v5.easing.linear(v1.cheat.scope_alpha, 0, 1, 1);
            v1.cheat.scope_alpha = math.max(0, math.min(1, v1.cheat.scope_alpha + v339 * (v340 and 1 or -1)));
            local v342 = {
                [1] = {
                    vector(v324.x - v335, v324.y), 
                    vector(v324.x - v335 - v336, v324.y + 1)
                }, 
                [2] = {
                    vector(v324.x + v336 + v335 + 1, v324.y), 
                    vector(v324.x + v335 + 1, v324.y + 1)
                }, 
                [3] = {
                    vector(v324.x, v324.y - v335), 
                    vector(v324.x + 1, v324.y - v335 - v336)
                }, 
                [4] = {
                    vector(v324.x, v324.y + v335 + 1), 
                    vector(v324.x + 1, v324.y + v335 + v336 + 1)
                }
            };
            render.gradient(v342[1][1], v342[1][2], color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), 0);
            render.gradient(v342[2][1], v342[2][2], color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), 0);
            render.gradient(v342[3][1], v342[3][2], color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), 0);
            render.gradient(v342[4][1], v342[4][2], color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and 0 or v341 * l_scope_line_color_0.a), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), color(l_scope_line_color_0.r, l_scope_line_color_0.g, l_scope_line_color_0.b, v333 and v341 * l_scope_line_color_0.a or 0), 0);
            return;
        end;
    end, 
    watermark = function(_, v344)
        -- upvalues: l_menu_values_0 (ref), v1 (ref), v2 (ref), v6 (ref)
        if l_menu_values_0.indicators then
            return;
        else
            local l_watermark_color_0 = l_menu_values_0.watermark_color;
            local v346 = ui.get_mouse_position();
            local v347 = vector(10, 5);
            local v348 = utils.net_channel();
            local v349 = v348 and math.floor(math.min(1000, v348.latency[1] * 1000) + 0.5) or 0;
            local v350 = l_watermark_color_0:clone();
            v350.a = 255;
            local v351 = string.format("ACATEL [ \a%s%s\a%s ]\t|\t%s\t|\t%dMS", v350:to_hex(), string.upper(v1.cheat.build), "FFFFFFFF", string.upper(v1.cheat.user), v349);
            local v352 = render.measure_text(2, nil, v351);
            local _ = vector(v352.x * 2, v352.y);
            local v354 = v352.x + v347.x;
            local v355 = v352.y + v347.y;
            local v356 = v2.utils.is_hovering(v1.cheat.watermark_pos, v1.cheat.watermark_pos + vector(v354, v355));
            local v357 = color(v356 and 200 or 0, v356 and 200 or 0, v356 and 200 or 0, v356 and 100 or 50);
            if v356 and common.is_button_down(1) then
                v1.cheat.drag = true;
            elseif not common.is_button_down(1) then
                v1.cheat.drag = false;
            end;
            if v1.cheat.drag then
                local v358 = v346 - v1.cheat.watermark_offset;
                local v359 = math.min(v344.x - v354 - v347.x, math.max(0, v358.x));
                v358.y = math.min(v344.y - v355 - 1, math.max(0, v358.y));
                v358.x = v359;
                v1.cheat.watermark_pos = v358;
            else
                v1.cheat.watermark_offset = v346 - v1.cheat.watermark_pos;
            end;
            local l_watermark_pos_0 = v1.cheat.watermark_pos;
            local l_watermark_pos_1 = v1.cheat.watermark_pos;
            local v362 = math.min(v344.x - v354 - v347.x, math.max(0, v1.cheat.watermark_pos.x));
            l_watermark_pos_1.y = math.min(v344.y - v355 - 1, math.max(0, v1.cheat.watermark_pos.y));
            l_watermark_pos_0.x = v362;
            render.gradient(v1.cheat.watermark_pos, v1.cheat.watermark_pos + vector(v354 / 2, v355), color(v357.r, v357.g, v357.b, 0), color(v357.r, v357.g, v357.b, v357.a), color(v357.r, v357.g, v357.b, 0), color(v357.r, v357.g, v357.b, v357.a));
            render.gradient(v1.cheat.watermark_pos + vector(v354 + v347.x, v355), v1.cheat.watermark_pos + vector(v354 / 2, 0), color(v357.r, v357.g, v357.b, 0), color(v357.r, v357.g, v357.b, v357.a), color(v357.r, v357.g, v357.b, 0), color(v357.r, v357.g, v357.b, v357.a));
            l_watermark_pos_0 = l_watermark_color_0:clone();
            l_watermark_pos_0.a = 0;
            render.gradient(v1.cheat.watermark_pos + vector(0, v355), v1.cheat.watermark_pos + vector(v354 / 2, v355 + 1), l_watermark_pos_0, l_watermark_color_0, l_watermark_pos_0, l_watermark_color_0);
            render.gradient(v1.cheat.watermark_pos + vector(v354 + v347.x, v355 + 1), v1.cheat.watermark_pos + vector(v354 / 2, v355), l_watermark_pos_0, l_watermark_color_0, l_watermark_pos_0, l_watermark_color_0);
            render.text(2, v1.cheat.watermark_pos + vector(v347.x, v347.y) + vector(v352.x / 2, v352.y / 2 - 3), color(255, 255, 255, 255), "c", v351);
            v6.position = v1.cheat.watermark_pos;
            return;
        end;
    end, 
    log = function(v363, _)
        -- upvalues: l_menu_values_0 (ref), v1 (ref)
        local v365 = globals.frametime * 12;
        local v366 = 12;
        local v367 = 0;
        local v368 = v363:clone();
        v368.y = v368.y + l_menu_values_0.logs_start;
        if not l_menu_values_0.logs then
            return;
        else
            for v369 = #v1.cheat.log, 1, -1 do
                local v370 = v1.cheat.log[v369];
                local l_context_0 = v370.context;
                local v372 = v370.time - globals.curtime;
                v370.anim = v370.anim == nil and 0 or math.max(0, math.min(1, v370.anim + v365));
                local v373 = math.max(0, math.min(1, v370.anim * v370.alpha));
                v367 = v367 + v373;
                if #v1.cheat.log > 7 and v369 == 1 then
                    v370.time = globals.curtime;
                end;
                local v374 = v366 * v367;
                do
                    local l_v370_0, l_l_context_0_0 = v370, l_context_0;
                    local v378 = (function()
                        -- upvalues: l_v370_0 (ref), v1 (ref), l_l_context_0_0 (ref)
                        local v377 = "";
                        if l_v370_0.type == "hit" then
                            v377 = string.format("Hit \a%s%s\aDEFAULT's %s [\a%s%d\aDEFAULT dmg]", l_v370_0.color:to_hex(), l_v370_0.name, v1.cheat.hitgroup_names[l_l_context_0_0.hitgroup], l_v370_0.color:to_hex(), l_l_context_0_0.damage);
                        elseif l_v370_0.type == "miss" then
                            v377 = string.format("Missed \a%s%s\aDEFAULT's %s [\a%s%s\aDEFAULT]", l_v370_0.color:to_hex(), l_v370_0.name, v1.cheat.hitgroup_names[l_l_context_0_0.wanted_hitgroup], l_v370_0.color:to_hex(), l_l_context_0_0.state);
                        else
                            v377 = string.format("%s \a%s%s\aDEFAULT [\a%s%s\aDEFAULT dmg]", v1.cheat.item_names[l_l_context_0_0.weapon], l_v370_0.color:to_hex(), l_v370_0.name, l_v370_0.color:to_hex(), l_v370_0.damage);
                        end;
                        return v377;
                    end)();
                    local v379 = l_v370_0.color:clone();
                    v379.a = math.min(l_v370_0.alpha * 255, v379.a);
                    if l_menu_values_0.logs_small then
                        v378 = string.gsub(v378, "%s+", "  ");
                    end;
                    render.text(l_menu_values_0.logs_small and 2 or 1, v368 + vector(0, v374), color(255, 255, 255, v379.a), "c", l_menu_values_0.logs_small and string.upper(v378) or v378);
                    if v372 <= 0 then
                        l_v370_0.alpha = l_v370_0.alpha - v365;
                        if v373 <= 0 then
                            table.remove(v1.cheat.log, v369);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end, 
    trashtalk = function()
        -- upvalues: l_menu_values_0 (ref), v1 (ref), v2 (ref)
        local l_trashtalk_0 = l_menu_values_0.trashtalk;
        local l_trashtalk_options_0 = l_menu_values_0.trashtalk_options;
        local _ = l_menu_values_0.trashtalk_delay;
        local _ = l_menu_values_0.trashtalk_level;
        if not l_trashtalk_0 then
            v1.cheat.reply_list = {};
            return;
        else
            local l_reply_list_0 = v1.cheat.reply_list;
            for v385, v386 in ipairs(l_reply_list_0) do
                if v386.time - globals.curtime <= 0 then
                    if v2.utils.search(l_trashtalk_options_0, "xyren") and not v386.has_extended then
                        v386.time = globals.curtime + 10;
                        v386.has_extended = true;
                        local v387 = v1.cheat.fuel[utils.random_int(1, #v1.cheat.fuel)];
                        utils.console_exec(string.format("say %s", v387));
                    end;
                    if v386.has_extended then
                        table.remove(v1.cheat.reply_list, v385);
                    end;
                end;
            end;
            return;
        end;
    end, 
    indicator = function(v388, _, v390)
        -- upvalues: l_menu_values_0 (ref), v1 (ref), v2 (ref), v0 (ref)
        if not l_menu_values_0.indicators then
            return;
        else
            local l_list_0 = v1.indicator.list;
            local v392 = rage.exploit:get();
            local v393 = globals.frametime * 12;
            local l_m_flDuckAmount_2 = v390.m_flDuckAmount;
            local l_m_flVelocityModifier_0 = v390.m_flVelocityModifier;
            local l_indicator_start_0 = l_menu_values_0.indicator_start;
            local v397 = 10 + l_menu_values_0.indicator_gap;
            local v398 = l_menu_values_0.indicator_center and "c" or nil;
            v388.y = v388.y + l_indicator_start_0;
            local v399 = rage.antiaim:get_rotation();
            local v400 = rage.antiaim:get_rotation(true);
            local v401 = math.normalize_yaw(v400 - v399);
            local v402 = math.sin(math.abs(-math.pi + globals.curtime * 5 % (math.pi * 2)));
            if l_m_flVelocityModifier_0 ~= 1 and v2.utils.search(l_menu_values_0.indicator_responsive, "vel. modifier") then
                v1.indicator.responsive = 1;
            end;
            if v1.indicator.responsive > 0 then
                v1.indicator.responsive = math.max(0, v1.indicator.responsive - globals.frametime * 2);
            end;
            if v1.dodge.active and v2.utils.search(l_menu_values_0.indicator_responsive, "dodge") and (l_m_flVelocityModifier_0 == 1 or not v2.utils.search(l_menu_values_0.indicator_responsive, "vel. modifier")) then
                v1.indicator.responsive = v402;
            end;
            local v403 = color(255, 255, 255, 200):lerp(color(255, 255, 255, 100), v1.indicator.responsive);
            local v404 = string.format("ACATEL \a%s%s\aDEFAULT", v403:to_hex(), string.upper(v1.cheat.build));
            render.text(2, v388, v403, v398, v404);
            v388.y = v388.y + v397;
            local v405 = math.min(60, math.max(-60, math.abs(v401)));
            local v406 = string.format("%.f%%", v405);
            local v407 = string.format("M:%s", string.sub(string.upper(l_menu_values_0.manual_bind), 1, 1));
            local _ = v405 / 60;
            render.text(2, v388, color(255, 255, 255, 100), v398, l_menu_values_0.manual_bind == "Disabled" and v406 or v407);
            v388.y = v388.y + v397;
            local v409 = v388:clone();
            local v410 = 0;
            local v411 = "";
            if l_menu_values_0.indicator_invert then
                v409.y = v409.y + v1.indicator.inline_anim * v397;
            end;
            force_bind = function(v412, v413, v414)
                if v412:get_override() == v413 or not v414 and v412:get() == v413 then
                    return true;
                else
                    return false;
                end;
            end;
            for _, v416 in ipairs(l_list_0) do
                if not v416.anim then
                    v416.anim = 0;
                end;
                local l_name_0 = v416.name;
                v416.draw_inline = #l_menu_values_0.indicator_inline > 1 and v2.utils.search(l_menu_values_0.indicator_inline, l_name_0);
                v416.draw_inactive = v2.utils.search(l_menu_values_0.indicator_base, l_name_0);
                local v418 = v416.color:clone();
                local _ = v416.alpha;
                local v420 = vector(v409.x, v409.y + v410 * v397);
                local l_draw_inline_0 = v416.draw_inline;
                local l_draw_inactive_0 = v416.draw_inactive;
                local l_menu_bound_0 = v416.menu_bound;
                local v424 = l_menu_bound_0 and l_menu_bound_0:get();
                if not v424 then
                    local v425 = ui.get_binds();
                    for _, v427 in ipairs(v425) do
                        local l_name_1 = v427.name;
                        if l_name_1 == "Min. Damage" and l_name_0 == v1.indicator.list_names[7] then
                            v424 = true;
                            l_name_0 = string.format("DMG  [%d]", v427.value);
                        elseif l_name_1 == "Hit Chance" and l_name_0 == v1.indicator.list_names[8] then
                            v424 = true;
                            l_name_0 = string.format("HC  [%d]", v427.value);
                        end;
                    end;
                end;
                if l_name_0 == v1.indicator.list_names[1] then
                    v418 = color(255, 65, 65, 200):lerp(color(255, 255, 255, 200), v392);
                elseif l_name_0 == v1.indicator.list_names[3] then
                    v418 = color(255, 255, 255, 200):lerp(color(255, 255, 255, 75), l_m_flDuckAmount_2);
                elseif l_name_0 == v1.indicator.list_names[4] then
                    v424 = force_bind(v0.ref.rage.body_aim, "Force");
                elseif l_name_0 == v1.indicator.list_names[5] then
                    v424 = force_bind(v0.ref.rage.safe_point, "Force");
                elseif l_name_0 == v1.indicator.list_names[6] then
                    v424 = force_bind(v0.ref.anti_aim.freestanding, true);
                elseif l_name_0 == v1.indicator.list_names[7] then
                    v424 = force_bind(v0.ref.rage.dmg, true, true);
                elseif l_name_0 == v1.indicator.list_names[8] then
                    v424 = force_bind(v0.ref.rage.hc, true, true);
                end;
                if not v424 then
                    v418 = color(255, 255, 255, 100);
                end;
                v416.anim = math.max(0, math.min(1, v416.anim + (not (not (not not l_draw_inactive_0 or v424) or l_draw_inline_0) and v393 or -v393)));
                if not l_draw_inline_0 then
                    v418.a = v418.a * v416.anim;
                end;
                if not l_draw_inline_0 and (l_draw_inactive_0 or v424) then
                    render.text(2, v420, v418, v398, l_name_0);
                elseif l_draw_inline_0 and (l_draw_inactive_0 or v424) then
                    v411 = v411 .. string.format("\a%s%s", v418.to_hex(v418), l_name_0) .. "  ";
                end;
                v410 = v410 + v416.anim;
            end;
            local v429 = vector(v388.x, v388.y + (l_menu_values_0.indicator_invert and 0 or v1.indicator.inline_anim * v410 * v397));
            v1.indicator.inline_active = v411.len(v411) > 0;
            v1.indicator.inline_anim = math.max(0, math.min(1, v1.indicator.inline_anim + (v1.indicator.inline_active and v393 or -v393)));
            if v1.indicator.inline_active then
                render.text(2, v429, color(255, 255, 255, v1.indicator.inline_anim * 255), v398, v411);
            end;
            return;
        end;
    end, 
    hitmarker = function(v430, _, _)
        -- upvalues: l_menu_values_0 (ref), v1 (ref)
        if not l_menu_values_0.hitmarker then
            if #v1.hitmarker.queue > 0 then
                v1.hitmarker.queue = {};
            end;
            v1.hitmarker.screen_queue = {};
            return;
        else
            local l_hitmarker_gap_0 = l_menu_values_0.hitmarker_gap;
            local v434 = l_menu_values_0.hitmarker_gap + l_menu_values_0.hitmarker_length;
            v1.hitmarker.position = {
                top_left = {
                    vector(-v434, -v434), 
                    vector(-l_hitmarker_gap_0, -l_hitmarker_gap_0)
                }, 
                top_right = {
                    vector(v434, -v434), 
                    vector(l_hitmarker_gap_0, -l_hitmarker_gap_0)
                }, 
                bottom_left = {
                    vector(-v434, v434), 
                    vector(-l_hitmarker_gap_0, l_hitmarker_gap_0)
                }, 
                bottom_right = {
                    vector(v434, v434), 
                    vector(l_hitmarker_gap_0, l_hitmarker_gap_0)
                }
            };
            local l_position_0 = v1.hitmarker.position;
            local v436 = globals.frametime * 255;
            for v437 = #v1.hitmarker.queue, 1, -1 do
                local v438 = v1.hitmarker.queue[v437];
                local l_color_0 = v438.color;
                local l_time_0 = v438.time;
                local l_position_1 = v438.position;
                local v442 = l_position_1:to_screen();
                if l_time_0 - globals.curtime <= 0 or not l_position_1 or not v442 then
                    v438.color.a = math.max(0, v438.color.a - v436);
                    if v438.color.a == 0 then
                        table.remove(v1.hitmarker.queue, v437);
                    end;
                end;
                render.line(v442 + l_position_0.top_left[1], v442 + l_position_0.top_left[2], l_color_0);
                render.line(v442 + l_position_0.top_right[1], v442 + l_position_0.top_right[2], l_color_0);
                render.line(v442 + l_position_0.bottom_left[1], v442 + l_position_0.bottom_left[2], l_color_0);
                render.line(v442 + l_position_0.bottom_right[1], v442 + l_position_0.bottom_right[2], l_color_0);
            end;
            local l_screen_queue_0 = v1.hitmarker.screen_queue;
            if l_screen_queue_0.color then
                local v444 = l_screen_queue_0.time - globals.curtime;
                render.line(v430 + l_position_0.top_left[1], v430 + l_position_0.top_left[2], l_screen_queue_0.color);
                render.line(v430 + l_position_0.top_right[1], v430 + l_position_0.top_right[2], l_screen_queue_0.color);
                render.line(v430 + l_position_0.bottom_left[1], v430 + l_position_0.bottom_left[2], l_screen_queue_0.color);
                render.line(v430 + l_position_0.bottom_right[1], v430 + l_position_0.bottom_right[2], l_screen_queue_0.color);
                if v444 <= 0 then
                    l_screen_queue_0.color.a = math.max(0, l_screen_queue_0.color.a - v436);
                    if l_screen_queue_0.color.a == 0 then
                        l_screen_queue_0.color = nil;
                        l_screen_queue_0.time = nil;
                    end;
                end;
            end;
            return;
        end;
    end, 
    caller = function(v445, v446, v447)
        draw.scope(v446, v445, v447);
        draw.log(v446, v445);
        draw.trashtalk();
        draw.watermark(v446, v445);
        draw.hitmarker(v446, v445, v447);
        if not v447 or not v447:is_alive() then
            return;
        else
            draw.manual_arrows(v446, v445);
            draw.indicator(v446, v445, v447);
            return;
        end;
    end
};
v1.inactive_features = {
    [1] = v0.elem.modifiers.defensive, 
    [2] = v0.elem.modifiers.defensive_antiaim
};
main = {
    state = function(v448, v449)
        -- upvalues: v0 (ref), v1 (ref)
        if not v449 then
            return;
        else
            local v450 = v449:get_anim_state();
            if not v450 then
                return;
            else
                local v451 = math.floor(v450.velocity_length_xy + 0.5);
                local v452 = v448.in_duck or v0.ref.misc.fake_duck:get();
                local v453 = not v450.on_ground or v448.in_jump;
                local v454 = v0.ref.misc.slow_walk:get();
                if v453 then
                    v1.player.local_state = not v452 and 6 or 7;
                elseif v451 > 2 then
                    local l_player_0 = v1.player;
                    local v456;
                    if not v452 and not v454 then
                        v456 = 2;
                    else
                        v456 = not v452 and v454 and 5 or 4;
                    end;
                    l_player_0.local_state = v456;
                else
                    v1.player.local_state = not v452 and 1 or 3;
                end;
                return;
            end;
        end;
    end, 
    get_distance_2d = function(v457, v458)
        if not v457 or not v458 then
            return;
        else
            return (v457:get_origin():dist2d((v458:get_origin())));
        end;
    end, 
    legit_aa = function(v459, v460)
        -- upvalues: v1 (ref)
        if not v460 then
            return;
        else
            v1.player.in_use = false;
            local v461 = {
                weapon = false, 
                hostage = false, 
                door = false, 
                c4 = false
            };
            local v462 = v460:get_eye_position();
            local l_m_iTeamNum_0 = v460.m_iTeamNum;
            local v464 = v462 + vector():angles(v459.view_angles) * 100;
            local _ = entity.get_entities("CPlantedC4", true, function(v465)
                -- upvalues: v460 (ref), l_m_iTeamNum_0 (ref), v461 (ref)
                if not v465 then
                    return;
                else
                    if main.get_distance_2d(v465, v460) <= 60 and l_m_iTeamNum_0 == 3 then
                        v461.c4 = true;
                    end;
                    return;
                end;
            end);
            local _ = utils.trace_line(v462, v464, function(v467, _)
                -- upvalues: v461 (ref), v1 (ref), v460 (ref), l_m_iTeamNum_0 (ref)
                if not v467 then
                    return;
                elseif v467:get_classname() == "CCSPlayer" then
                    return false;
                else
                    if v467:get_classname() == "CPropDoorRotating" then
                        v461.door = not v1.player.has_triggered_trace;
                    else
                        if v467:is_weapon() then
                            v461.weapon = not v1.player.has_triggered_trace;
                        end;
                        if v467:get_classname() == "CHostage" and main.get_distance_2d(v467, v460) <= 60 and l_m_iTeamNum_0 == 3 then
                            v461.hostage = true;
                        end;
                    end;
                    return;
                end;
            end, nil, 2);
            local l_in_use_0 = v459.in_use;
            if l_in_use_0 and not v461.hostage and not v461.c4 and not v461.door and not v461.weapon then
                v1.player.has_triggered_trace = true;
                v459.in_use = false;
                v1.player.in_use = true;
            elseif not l_in_use_0 then
                v1.player.has_triggered_trace = false;
            end;
            return;
        end;
    end, 
    dodge = function(v471, _, _, v474)
        -- upvalues: v1 (ref), v2 (ref), l_menu_values_0 (ref)
        local l_last_0 = v1.dodge.last;
        local l_target_0 = l_last_0.target;
        if not l_target_0 then
            return;
        else
            local v477 = v2.utils.search(v471.body_yaw_options, "dodge");
            local v478 = v471.dodge_strength or 70;
            local v479 = v471.dodge_threshold or 4.5;
            if not v477 then
                if v1.dodge.last.threat then
                    v1.dodge.last = {};
                end;
                return;
            else
                if globals.tickcount == l_last_0.tickcount and l_last_0.local_position then
                    local v480 = l_last_0.local_position:closest_ray_point(l_last_0.position, l_last_0.target_position):dist(l_last_0.local_position);
                    local v481 = (l_last_0.position - l_last_0.target_position):normalized();
                    local v482 = (l_last_0.local_position - l_last_0.target_position):normalized();
                    local v483 = math.deg(math.acos(v481:dot(v482)));
                    if v480 <= 50 and v483 < v479 then
                        v1.dodge.active = true;
                    end;
                end;
                if v474 ~= l_target_0 and v1.dodge.last_switched then
                    if globals.curtime > v1.dodge.last_switched or not l_target_0:is_alive() then
                        v1.dodge.active = false;
                    end;
                else
                    v1.dodge.last_switched = globals.curtime + 2;
                end;
                if v1.dodge.active and l_menu_values_0.manual_bind == "Disabled" then
                    local l_offset_0 = v471.offset;
                    local v485 = 30 * (v478 * 0.01);
                    local v486 = utils.random_int(math.abs(l_offset_0) + v485, math.abs(l_offset_0)) * (l_offset_0 < 0 and -1 or 1);
                    v471.left_limit = 34;
                    v471.right_limit = 34;
                    v471.offset = v486;
                end;
                return;
            end;
        end;
    end, 
    exploits = function(_, v488, v489)
        -- upvalues: v0 (ref), v1 (ref)
        if not v488 then
            return;
        else
            local v490 = v0.ref.rage.double_tap:get();
            local v491 = v0.ref.rage.hide_shots:get();
            v1.exploits.is_active = v490 or v491;
            v1.exploits.is_defensive = v489.command.no_entry.x ~= 0 and v489.command.no_entry.y ~= 0;
            return;
        end;
    end, 
    config = function(v492, v493)
        -- upvalues: v1 (ref), l_menu_values_0 (ref), v2 (ref)
        if not v493 then
            return;
        else
            local v494 = entity.get_game_rules();
            if not v494 then
                return;
            else
                local v495 = entity.get_threat();
                local v496 = v493:get_player_weapon();
                local _ = v494.m_bWarmupPeriod;
                local l_local_state_1 = v1.player.local_state;
                local _ = v1.player.local_state_names[l_local_state_1];
                local v500 = l_menu_values_0.team_switch and math.max(1, math.min(2, v493.m_iTeamNum - 1)) or 1;
                local v501 = l_menu_values_0.mode == 1;
                v1.anti_aim.presets.defensive = {
                    [1] = {
                        pitch = {
                            "custom", 
                            utils.random_int(-45, 45)
                        }, 
                        yaw = {
                            [1] = "custom", 
                            [2] = ({
                                [1] = -120, 
                                [2] = 0, 
                                [3] = 120
                            })[utils.random_int(1, 3)]
                        }
                    }, 
                    [2] = {
                        pitch = {
                            "custom", 
                            utils.random_int(-89, 89)
                        }, 
                        yaw = {
                            "custom", 
                            utils.random_int(110, 145)
                        }
                    }, 
                    [3] = {
                        pitch = {
                            [1] = "custom", 
                            [2] = -48
                        }, 
                        yaw = {
                            "custom", 
                            utils.random_int(-115, 115)
                        }
                    }, 
                    [4] = {
                        pitch = {
                            [1] = "up", 
                            [2] = 0
                        }, 
                        yaw = {
                            "custom", 
                            utils.random_int(-145, -130)
                        }
                    }, 
                    [5] = {
                        pitch = {
                            [1] = "custom", 
                            [2] = -35
                        }, 
                        yaw = {
                            "custom", 
                            utils.random_int(-115, 145)
                        }
                    }, 
                    [6] = {
                        pitch = {
                            "custom", 
                            utils.random_int(-45, 45)
                        }, 
                        yaw = {
                            "custom", 
                            utils.random_int(-100, 70)
                        }
                    }, 
                    [7] = {
                        pitch = {
                            [1] = "custom", 
                            [2] = -45
                        }, 
                        yaw = {
                            [1] = "custom", 
                            [2] = -122
                        }
                    }
                };
                if record then
                    main.exploits(v492, v493, record);
                end;
                v1.anti_aim.anti_aim_array = v501 and v1.anti_aim.presets.default[l_local_state_1][v500] or l_menu_values_0.panel[v1.player.local_state][v500];
                local l_state_enabled_0 = v1.anti_aim.anti_aim_array.state_enabled;
                if not v501 and not l_state_enabled_0 then
                    v1.anti_aim.anti_aim_array = l_menu_values_0.panel[0][v500];
                end;
                local v503 = {};
                for v504, v505 in pairs(v1.anti_aim.anti_aim_array) do
                    if type(v505) == "table" then
                        v503[v504] = {};
                        for v506, v507 in pairs(v505) do
                            v503[v504][v506] = v507;
                        end;
                    else
                        v503[v504] = v505;
                    end;
                end;
                v1.anti_aim.defensive_array = v501 and v1.anti_aim.presets.defensive[l_local_state_1] or {
                    pitch = {
                        [1] = v503.defensive_pitch, 
                        [2] = v503.defensive_pitch_slider
                    }, 
                    yaw = {
                        [1] = v503.defensive_yaw, 
                        [2] = -v503.defensive_yaw_slider
                    }
                };
                v503.safety = false;
                if v501 and l_menu_values_0.defensive_antiaim and v2.utils.search(l_menu_values_0.defensive_aa_options, v1.player.local_state_names[v1.player.local_state]) then
                    v503.hidden = true;
                end;
                if not v503.body_yaw then
                    v503.body_yaw_options = {};
                end;
                v503.offset = v1.player.invert_yaw;
                if v2.utils.search(v503.body_yaw_options, "jitter") and v503.body_yaw then
                    local v508, v509 = v2.utils.search(v503.body_yaw_options, "jitter");
                    if v508 then
                        table.remove(v503.body_yaw_options, v509);
                    end;
                    local v510 = (v503.yaw_delay_master and math.max(1, v503.yaw_delay == 101 and utils.random_int(1, 3) or v503.yaw_delay * 0.14) or 1) + (v503.yaw_delay_master and (v1.player.invert and (v503.yaw_delay_r == 15 and utils.random_int(1, 3) or v503.yaw_delay_r) or v503.yaw_delay_l == 15 and utils.random_int(1, 3) or v503.yaw_delay_l) or 0);
                    if v492.command_number > v1.player.delay then
                        v1.player.invert = not v1.player.invert;
                        v1.player.delay = v492.command_number + v510;
                    end;
                    v503.inverter = v1.player.invert;
                    v1.player.invert_yaw = v503.inverter and v503.offset_l or v503.offset_r;
                else
                    v1.player.invert_yaw = v503.inverter and v503.offset_l or v503.offset_r;
                end;
                local v511 = nil;
                if l_menu_values_0.safe_head then
                    local v512 = nil;
                    local v513 = nil;
                    local v514 = nil;
                    if v495 then
                        local v515 = v495:get_origin();
                        v514 = v493:get_origin().z - v515.z >= l_menu_values_0.height_threshold and v2.utils.search(l_menu_values_0.safe_head_states, "height");
                    end;
                    if v496 then
                        local v516 = v496:get_classname();
                        v512 = v516 == "CKnife" and v1.player.local_state == 7 and v2.utils.search(l_menu_values_0.safe_head_states, "air safety knife");
                        v513 = v516 == "CWeaponTaser" and v1.player.local_state == 7 and v2.utils.search(l_menu_values_0.safe_head_states, "air safety taser");
                    end;
                    local v517;
                    if not v512 then
                        if not v513 then
                            v517 = v514;
                        else
                            v517 = v513;
                        end;
                    else
                        v517 = v512;
                    end;
                    v503.safety = v517;
                end;
                v503.backstab = l_menu_values_0.anti_backstab;
                main.dodge(v503, v492, v493, v495);
                binds.handler(v503, v493);
                main.defensive(v492, v493, v495, v503, v501);
                if v503.safety then
                    v503.pitch = "down";
                    v503.yaw = "backward";
                    if l_menu_values_0.manual_bind ~= "Disabled" or v511 then
                        v503.hidden = false;
                    end;
                    if l_menu_values_0.manual_bind == "Disabled" then
                        v503.offset = 10;
                        v503.body_yaw = false;
                    end;
                    v503.body_yaw_options = {};
                    v503.inverter = false;
                    v503.jitter = "disabled";
                end;
                if v1.player.in_use then
                    v503.pitch = "disabled";
                    v503.base = "local view";
                    v503.yaw = "disabled";
                    v503.jitter = "disabled";
                    v503.inverter = true;
                    v503.hidden = false;
                    v503.body_yaw_options = {};
                    v503.body_yaw_freestanding = "peek real";
                    v503.freestanding = false;
                end;
                v2.utils.set_antiaim(v503);
                return;
            end;
        end;
    end, 
    defensive = function(_, v519, v520, v521, v522)
        -- upvalues: v1 (ref), l_menu_values_0 (ref), v2 (ref), v0 (ref)
        local l_defensive_array_0 = v1.anti_aim.defensive_array;
        local v524 = false;
        local v525 = v522 and l_menu_values_0.defensive or v521.defensive;
        local v526 = v522 and l_menu_values_0.defensive_antiaim or v521.defensive_aa;
        local v527 = v522 and l_menu_values_0.defensive_state or v521.defensive;
        local v528 = v522 and l_menu_values_0.defensive_aa_options or v521.defensive_conds;
        local v529 = v519:get_hitbox_position(0);
        local v530 = v519:simulate_movement(v529);
        v530:think(14);
        local v531 = -1;
        local v532 = -1;
        if not v522 then
            v521.hidden = v526 and not v2.utils.search(v528, "visible only");
        end;
        if v520 then
            v532 = utils.trace_bullet(v520, v520:get_eye_position(), v529);
            if v532 > 0 and v526 and v2.utils.search(v528, "visible only") then
                v524 = true;
                v521.hidden = true;
            elseif v532 <= 0 and v526 and v2.utils.search(v528, "visible only") then
                v521.hidden = false;
            end;
            if v530 then
                v531 = utils.trace_bullet(v520, v520:get_eye_position(), v530.origin);
            end;
        elseif v526 and v2.utils.search(v528, "visible only") then
            v521.hidden = false;
        end;
        local v533 = v1.player.local_state_names[v1.player.local_state];
        local v534 = (v525 and (not (type(v527) == "table") or v2.utils.search(v527, v533)) or v524) and "Always on" or nil;
        v0.ref.rage.double_tap_mode:override(v534);
        if (not v522 or v1.player.local_state == 2) and v526 and v532 == 0 and v531 >= 10 and v2.utils.search(v528, "pre-flick") then
            v521.body_yaw_freestanding = "peek real";
            v521.hidden = true;
            l_defensive_array_0.pitch[1] = "zero";
            l_defensive_array_0.yaw[1] = "custom";
            l_defensive_array_0.yaw[2] = rage.antiaim:inverter() and 120 or -120;
        end;
        if l_defensive_array_0 and v521.hidden then
            if l_defensive_array_0.pitch[1] ~= "inherited" then
                rage.antiaim:override_hidden_pitch(v1.anti_aim.pitch_values[l_defensive_array_0.pitch[1]] or l_defensive_array_0.pitch[2]);
            end;
            if l_defensive_array_0.yaw[1] ~= "inherited" then
                rage.antiaim:override_hidden_yaw_offset(l_defensive_array_0.yaw[2] == 181 and utils.random_int(-145, 145) or l_defensive_array_0.yaw[2]);
            end;
        end;
    end, 
    block_mouse = function(v535)
        -- upvalues: v1 (ref)
        if v1.cheat.drag then
            v535.in_attack = false;
            v535.in_attack2 = false;
        end;
    end, 
    caller = function(v536, v537)
        main.config(v536, v537);
        main.state(v536, v537);
        main.legit_aa(v536, v537);
        main.block_mouse(v536, v537);
        misc.simulate(v536, v537);
        misc.fast_ladder(v536, v537);
        misc.modify_freeztime_duck(v536, v537);
        misc.fake_tuff(v536, v537);
        misc.drop_nades(v536, v537);
        misc.auto_hs(v536, v537);
    end
};
run = {
    caller = function(v538, v539)
        misc.modify_fakeduck_speed(v538, v539);
    end
};
binds = {
    handler = function(v540, v541)
        -- upvalues: v1 (ref), l_menu_values_0 (ref), v2 (ref)
        if not v541 then
            return;
        else
            local l_local_state_2 = v1.player.local_state;
            local v543 = v1.player.local_state_names[l_local_state_2];
            local v544 = false;
            v1.player.get_offset = 0;
            if l_menu_values_0.manual_yaw and l_menu_values_0.manual_bind ~= "Disabled" then
                v1.player.get_offset = v1.anti_aim.manual_array[l_menu_values_0.manual_bind];
                if l_menu_values_0.fs_prioritize then
                    v544 = true;
                end;
                if v2.utils.search(l_menu_values_0.manual_triggers, "use local view") then
                    v540.base = "local view";
                end;
                if v2.utils.search(l_menu_values_0.manual_triggers, "force safety") then
                    v540.safety = true;
                end;
                v540.offset = v1.player.get_offset;
            end;
            v540.freestanding = not v2.utils.search(l_menu_values_0.fs_disablers, v543) and l_menu_values_0.freestanding and l_menu_values_0.fs_bind and not v544;
            local v545 = rage.antiaim:get_target(true);
            if l_menu_values_0.fs_safety and v545 and v540.freestanding and not v1.player.in_use then
                v540.safety = true;
            end;
            return;
        end;
    end
};
debug = {
    send_vars_globals = function()

    end
};
v3.createmove = function(v546)
    if not globals.is_in_game then
        return;
    else
        local v547 = entity.get_local_player();
        if not v547 then
            return;
        else
            main.caller(v546, v547);
            return;
        end;
    end;
end;
v3.createmove_run = function(v548)
    if not globals.is_in_game then
        return;
    else
        local v549 = entity.get_local_player();
        if not v549 then
            return;
        else
            run.caller(v548, v549);
            return;
        end;
    end;
end;
v3.render = function()
    if not globals.is_in_game then
        return;
    else
        local v550 = render.screen_size();
        if not v550 then
            return;
        else
            local v551 = entity.get_local_player();
            local v552 = v550 / 2;
            draw.caller(v550, v552, v551);
            return;
        end;
    end;
end;
v3.shutdown = function()
    -- upvalues: v6 (ref), v1 (ref)
    v6.position = {
        v1.cheat.watermark_pos:unpack()
    };
    db.acatel = v6;
end;
v3.aim_ack = function(v553)
    -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref)
    local v554 = entity.get_local_player();
    if not l_menu_values_0.logs then
        return;
    else
        local l_logs_draw_0 = l_menu_values_0.logs_draw;
        local l_logs_console_0 = l_menu_values_0.logs_console;
        local l_logs_corner_0 = l_menu_values_0.logs_corner;
        local l_m_iHealth_0 = v553.target.m_iHealth;
        if v2.utils.search(l_logs_draw_0, "hit") and not v553.state or v2.utils.search(l_logs_draw_0, "miss") and v553.state then
            table.insert(v1.cheat.log, {
                fade = 1, 
                alpha = 1, 
                name = v553.target:get_name(), 
                type = v553.state and "miss" or "hit", 
                context = v553, 
                time = globals.curtime + 5, 
                color = v553.state and l_menu_values_0.logs_miss or l_m_iHealth_0 == 0 and l_menu_values_0.logs_lethal or l_menu_values_0.logs_hit
            });
        end;
        if v2.utils.search(l_logs_console_0, "hit") and not v553.state or v2.utils.search(l_logs_console_0, "miss") and v553.state then
            local l_state_0 = v553.state;
            local v560 = v1.cheat.hitgroup_names[v553.wanted_hitgroup];
            local v561 = v1.cheat.hitgroup_names[v553.hitgroup];
            local v562 = string.format("Missed \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT due to \a%s%s\aDEFAULT", l_menu_values_0.logs_miss:to_hex(), v553.target:get_name(), l_menu_values_0.logs_miss:to_hex(), v560, l_menu_values_0.logs_miss:to_hex(), l_state_0);
            local v563 = not l_state_0 and string.format("Hit \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT for \a%s%d\aDEFAULT damage (%d health remaining)", l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v553.target:get_name(), l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v561, l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v553.damage, l_m_iHealth_0) or v562;
            do
                local l_v560_0 = v560;
                local v566 = string.format("(history(\206\148): %d, mismatch: %s, aimpunch: %d, hc: %d%%)", (function()
                    -- upvalues: v553 (ref), l_v560_0 (ref), v554 (ref)
                    local v565 = "";
                    if v553.wanted_hitgroup ~= v553.hitgroup then
                        v565 = v565 .. string.format("hitgroup(%s)", l_v560_0);
                    end;
                    if v553.wanted_damage ~= v553.damage then
                        v565 = v565 .. (v565 ~= "" and " " or "") .. string.format("damage(%s)", v553.wanted_damage);
                    end;
                    if v565 == "" then
                        v565 = "none";
                    end;
                    return v553.backtrack or 0, v565, v554.m_flVelocityModifier == 1 and 0 or 1, v553.hitchance or 0;
                end)());
                local _ = v553.wanted_hitgroup ~= v553.hitgroup;
                string.format("");
                v563 = string.format("%s %s", v563, v566);
                local v568 = not l_state_0 and string.format("Hit \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT for \a%s%d\aDEFAULT damage (%d health remaining)", l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v553.target:get_name(), l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v561, l_m_iHealth_0 > 0 and l_menu_values_0.logs_hit:to_hex() or l_menu_values_0.logs_lethal:to_hex(), v553.damage, l_m_iHealth_0) or string.format("Missed \a%s%s\aDEFAULT in the \a%s%s\aDEFAULT due to \a%s%s\aDEFAULT", l_menu_values_0.logs_miss:to_hex(), v553.target:get_name(), l_menu_values_0.logs_miss:to_hex(), l_v560_0, l_menu_values_0.logs_miss:to_hex(), l_state_0);
                print_raw(v563);
                if l_logs_corner_0 then
                    print_dev(v568);
                end;
            end;
        end;
        return;
    end;
end;
v3.player_hurt = function(v569)
    -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref)
    local v570 = entity.get_local_player();
    local v571 = entity.get(v569.attacker, true);
    local v572 = entity.get(v569.userid, true);
    local l_logs_draw_1 = l_menu_values_0.logs_draw;
    local l_logs_console_1 = l_menu_values_0.logs_console;
    local l_logs_corner_1 = l_menu_values_0.logs_corner;
    if not v571 or v571 ~= v570 or not v572 then
        return;
    else
        if v2.utils.search(l_menu_values_0.indicator_responsive, "damage") then
            v1.indicator.responsive = 1;
        end;
        if l_menu_values_0.hitmarker then
            local v576 = v569.hitgroup == 1;
            local v577 = v569.health == 0;
            local v578 = globals.curtime + 0.1;
            local v579 = v577 and l_menu_values_0.hitmarker_lethal_color or not (not v576 or v577) and l_menu_values_0.hitmarker_headshot_color or l_menu_values_0.hitmarker_default_color;
            local v580 = v572:get_hitbox_position(v569.hitgroup);
            if globals.tickcount == v1.hitmarker.last.tickcount and v2.utils.search(l_menu_values_0.hitmarker_toggle, "world") then
                table.insert(v1.hitmarker.queue, {
                    current = 1, 
                    color = v2.utils.search(l_menu_values_0.hitmarker_apply_color, "world") and v579:clone() or l_menu_values_0.hitmarker_default_color:clone(), 
                    time = v578, 
                    position = v580
                });
            end;
            if v2.utils.search(l_menu_values_0.hitmarker_toggle, "screen") then
                v1.hitmarker.screen_queue = {
                    time = v578, 
                    color = v2.utils.search(l_menu_values_0.hitmarker_apply_color, "screen") and v579:clone() or l_menu_values_0.hitmarker_default_color:clone()
                };
            end;
        end;
        if not l_menu_values_0.logs then
            return;
        else
            if (v1.cheat.hitgroup_names[v569.hitgroup] or "?") == "generic" and v1.cheat.item_names[v569.weapon] ~= nil then
                local v581 = v572:get_name();
                if v569.weapon == "knife" and v2.utils.search(l_logs_console_1, "knifed") or v569.weapon ~= "knife" and v2.utils.search(l_logs_console_1, "grenade dmg") then
                    local v582 = string.format("%s \a%s%s\aDEFAULT for \a%s%d\aDEFAULT damage (%i health remaining)", v1.cheat.item_names[v569.weapon], l_menu_values_0.logs_nade:to_hex(), v581, l_menu_values_0.logs_nade:to_hex(), v569.dmg_health, v569.health);
                    print_raw(v582);
                    if l_logs_corner_1 then
                        print_dev(v582);
                    end;
                end;
                if v569.weapon == "knife" and v2.utils.search(l_logs_draw_1, "knifed") or v569.weapon ~= "knife" and v2.utils.search(l_logs_draw_1, "grenade dmg") then
                    table.insert(v1.cheat.log, {
                        type = "other", 
                        fade = 1, 
                        alpha = 1, 
                        damage = v569.dmg_health, 
                        name = v581, 
                        context = v569, 
                        time = globals.curtime + 3, 
                        color = v569.health == 0 and l_menu_values_0.logs_lethal or l_menu_values_0.logs_nade
                    });
                end;
            end;
            return;
        end;
    end;
end;
v3.bullet_impact = function(v583)
    -- upvalues: v1 (ref)
    local v584 = entity.get_local_player();
    if not v584 or not v584:is_alive() then
        return;
    else
        local l_hitmarker_0 = v1.hitmarker;
        local l_dodge_0 = v1.dodge;
        local v587 = vector(v583.x, v583.y, v583.z);
        l_hitmarker_0.last.tickcount = globals.tickcount;
        l_hitmarker_0.last.position = v587;
        if l_dodge_0.last.tickcount == globals.tickcount then
            l_dodge_0.last.position = v587;
            l_dodge_0.last.target_position = l_dodge_0.last.target:get_hitbox_position(0);
            l_dodge_0.last.local_position = v584:get_hitbox_position(0);
        end;
        return;
    end;
end;
v3.weapon_fire = function(v588)
    -- upvalues: v1 (ref)
    local v589 = entity.get_local_player();
    if not v589 or not v589:is_alive() then
        return;
    else
        local v590 = entity.get(v588.userid, true);
        if v590 == v589 then
            return;
        else
            local v591 = entity.get_threat();
            if v591 ~= v590 then
                return;
            else
                local l_dodge_1 = v1.dodge;
                l_dodge_1.last.tickcount = globals.tickcount;
                l_dodge_1.last.target = v591;
                return;
            end;
        end;
    end;
end;
v3.player_death = function(v593)
    -- upvalues: l_menu_values_0 (ref), v2 (ref), v1 (ref)
    local v594 = entity.get_local_player();
    local l_trashtalk_1 = l_menu_values_0.trashtalk;
    local v596 = entity.get(v593.userid, true);
    if entity.get(v593.attacker, true) ~= v594 or v596 == v594 or not l_trashtalk_1 then
        return;
    else
        local l_trashtalk_options_1 = l_menu_values_0.trashtalk_options;
        local l_trashtalk_level_1 = l_menu_values_0.trashtalk_level;
        local v599 = v2.utils.search(l_trashtalk_options_1, "add delay") and (l_menu_values_0.trashtalk_delay == 1 and utils.random_int(1, 3) or l_menu_values_0.trashtalk_delay) or 1;
        local l_weapon_0 = v593.weapon;
        local v601 = v1.cheat.death_tbl[l_weapon_0] or v1.cheat.death_tbl[l_trashtalk_level_1];
        local v602 = v601[utils.random_int(1, #v601)];
        utils.execute_after(v599, function()
            -- upvalues: v602 (ref), v1 (ref), v596 (ref)
            local v603 = string.format("say %s", v602);
            utils.console_exec(v603);
            table.insert(v1.cheat.reply_list, {
                target = v596, 
                time = globals.curtime + 15
            });
        end);
        return;
    end;
end;
v3.player_say = function(v604)
    -- upvalues: l_menu_values_0 (ref), v1 (ref), v2 (ref)
    local l_trashtalk_2 = l_menu_values_0.trashtalk;
    local l_trashtalk_options_2 = l_menu_values_0.trashtalk_options;
    local v607 = entity.get(v604.userid, true);
    local _ = v604.text;
    for _, v610 in ipairs(v1.cheat.reply_list) do
        if v610.target == v607 then
            v1.cheat.replies_i = v1.cheat.replies_i >= #v1.cheat.replies and 1 or v1.cheat.replies_i + 1;
            local v611 = v1.cheat.replies[v1.cheat.replies_i];
            local v612 = utils.random_int(2, 3);
            local v613 = string.format("say %s", v611);
            do
                local l_v613_0 = v613;
                if l_trashtalk_2 and v2.utils.search(l_trashtalk_options_2, "reply") then
                    v610.time = globals.curtime + 10;
                    v610.has_extended = false;
                    utils.execute_after(v612, function()
                        -- upvalues: l_v613_0 (ref)
                        utils.console_exec(l_v613_0);
                    end);
                end;
            end;
        end;
    end;
end;
v3.level_init = function(_)
    -- upvalues: v1 (ref)
    v1.player.delay = 0;
    v1.cheat.replies_i = 1;
    v1.cheat.reply_list = {};
    v1.cheat.log = {};
    v1.hitmarker = {
        queue = {}, 
        last = {}, 
        screen_queue = {}
    };
    v1.dodge = {
        active = false, 
        queue = {}, 
        last = {}
    };
    misc.update_world_tone();
    misc.call_viewmodel();
    misc.call_client_name();
end;
v3.player_spawn = function(v616)
    -- upvalues: v1 (ref)
    local v617 = entity.get_local_player();
    local v618 = entity.get(v616.userid, true);
    if not v618 or v617 ~= v618 then
        return;
    else
        v1.player.delay = 0;
        v1.dodge = {
            active = false, 
            queue = {}, 
            last = {}
        };
        misc.call_viewmodel();
        return;
    end;
end;
v3.init = function()
    -- upvalues: v3 (ref)
    events.createmove:set(v3.createmove);
    events.createmove_run:set(v3.createmove_run);
    events.render:set(v3.render);
    events.aim_ack:set(v3.aim_ack);
    events.player_hurt:set(v3.player_hurt);
    events.bullet_impact:set(v3.bullet_impact);
    events.weapon_fire:set(v3.weapon_fire);
    events.player_death:set(v3.player_death);
    events.player_say:set(v3.player_say);
    events.shutdown:set(v3.shutdown);
    events.level_init:set(v3.level_init);
    events.player_spawn:set(v3.player_spawn);
end;
v2.handle = function()
    -- upvalues: l_menu_values_0 (ref), v0 (ref), v1 (ref), v2 (ref)
    local l_mode_0 = l_menu_values_0.mode;
    local l_team_switch_0 = l_menu_values_0.team_switch;
    local v621 = l_team_switch_0 and l_menu_values_0.team_slider or 1;
    local l_current_state_2 = l_menu_values_0.current_state;
    for v623, v624 in pairs(v0.elem.builders.panel) do
        for v625, v626 in pairs(v624) do
            local v627 = v1.player.extra_state_names[v623];
            local v628 = v621 == v625 and v627 == l_current_state_2;
            for v629, v630 in pairs(v626) do
                local v631 = v624[v625];
                v2.utils.bind(v630, v2.handle);
                local v632 = (not (v629 == "defensive_pitch_slider") or v631.defensive_pitch:get() == "custom") and (not (v629 == "defensive_yaw_slider") or v631.defensive_yaw:get() == "static") and (v629 ~= "dodge_strength" and not (v629 == "dodge_threshold") or v631.body_yaw_options:get("dodge"));
                local v633 = l_mode_0 == 1;
                if v627 == "fallback" and v629 == "state_enabled" then
                    v633 = true;
                end;
                v630:visibility(v628 and v632);
                v630:disabled(v633);
            end;
        end;
    end;
    for _, v635 in ipairs(v1.inactive_features) do
        v635:disabled(l_mode_0 == 2);
    end;
    v0.elem.draw.watermark:disabled(l_menu_values_0.indicators);
    v0.elem.builders.team_export:visibility(l_mode_0 == 2 and l_team_switch_0);
    v0.elem.builders.state_to_export:visibility(l_mode_0 == 2);
    v0.elem.builders.state_export:visibility(l_mode_0 == 2);
    misc.update_aspect_ratio();
end;
v3.init();
v2.init();
misc.init();