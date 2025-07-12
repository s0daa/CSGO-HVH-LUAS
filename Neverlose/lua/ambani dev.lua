local l_clipboard_0 = require("neverlose/clipboard");
local l_pui_0 = require("neverlose/pui");
local _ = require("neverlose/b_renderer");
local l_smoothy_0 = require("neverlose/smoothy");
local l_base64_0 = require("neverlose/base64");
local _ = require("ffi");
local l_lambotruck_0 = require("neverlose/lambotruck");
local v7 = "{\"ct\":{\"duck\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":15.0,\"faszsag_fakelimit_r\":16.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-35.0,\"faszsag_yawvalue_2\":36.0,\"faszsagfakeyaw\":20.0,\"faszsagfakeyaw_r\":15.0,\"fluctuate\":true,\"fluctuate_value\":2.0,\"fluctuatefakelag\":false,\"hold_delay\":15.0,\"hold_time\":3.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-22.0,\"yaw_add_r\":30.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":19.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"duck jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-24.0,\"faszsag_yawvalue_2\":46.0,\"faszsagfakeyaw\":9.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":1.0,\"fluctuatefakelag\":false,\"hold_delay\":11.0,\"hold_time\":2.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":9.0,\"tickspeed2\":11.0,\"yaw_add\":-17.0,\"yaw_add_r\":33.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":10.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"duck move\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":17.0,\"faszsag_fakelimit_r\":15.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-33.0,\"faszsag_yawvalue_2\":39.0,\"faszsagfakeyaw\":9.0,\"faszsagfakeyaw_r\":5.0,\"fluctuate\":true,\"fluctuate_value\":1.0,\"fluctuatefakelag\":false,\"hold_delay\":6.0,\"hold_time\":2.0,\"interaction_type\":\"Net_update\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-16.0,\"yaw_add_r\":31.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":13.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"global\":{\"body_yaw\":\"off\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"fakelimit\":32.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"local view\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":57.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":12.0,\"faszsag_fakelimit_r\":23.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-24.0,\"faszsag_yawvalue_2\":24.0,\"faszsagfakeyaw\":13.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":3.0,\"fluctuatefakelag\":false,\"hold_delay\":9.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":1.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-17.0,\"yaw_add_r\":22.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"random\",\"yaw_jitter_add\":15.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":11.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":4.0,\"fluctuatefakelag\":false,\"hold_delay\":6.0,\"hold_time\":1.0,\"interaction_type\":\"Net_update\",\"options\":[\"safe head\",\"~\"],\"randomize_delays\":true,\"switch_delay\":2.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-31.0,\"yaw_add_r\":34.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":16.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"slow walk\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":32.0,\"faszsag\":true,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":10.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-44.0,\"faszsag_yawvalue_2\":51.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"safe head (hg)\",\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":12.0,\"tickspeed2\":14.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-47.0,\"faszsag_yawvalue_2\":56.0,\"faszsagfakeyaw\":7.0,\"faszsagfakeyaw_r\":5.0,\"fluctuate\":true,\"fluctuate_value\":2.0,\"fluctuatefakelag\":false,\"hold_delay\":7.0,\"hold_time\":3.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-25.0,\"yaw_add_r\":34.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":17.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true}},\"t\":{\"duck\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":56.0,\"faszsag_fakelimit_r\":54.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-30.0,\"faszsag_yawvalue_2\":55.0,\"faszsagfakeyaw\":4.0,\"faszsagfakeyaw_r\":10.0,\"fluctuate\":true,\"fluctuate_value\":5.0,\"fluctuatefakelag\":false,\"hold_delay\":11.0,\"hold_time\":2.0,\"interaction_type\":\"Net_update\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":9.0,\"tickspeed2\":12.0,\"yaw_add\":-24.0,\"yaw_add_r\":30.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":11.0,\"yawspeed\":8.0,\"yawspeed2\":9.0,\"yawspeed_randomization\":true},\"duck jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"freestanding\",\"choke1\":2.0,\"choke2\":22.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":58.0,\"faszsag_fakelimit_r\":58.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":10.0,\"faszsag_spinspeed\":3.0,\"faszsag_yaw\":\"sway\",\"faszsag_yawvalue_1\":-62.0,\"faszsag_yawvalue_2\":30.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":8.0,\"fluctuate\":true,\"fluctuate_value\":-1.0,\"fluctuatefakelag\":false,\"hold_delay\":4.0,\"hold_time\":4.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":2.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-17.0,\"yaw_add_r\":38.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":11.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"duck move\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":59.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-36.0,\"faszsag_yawvalue_2\":55.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":7.0,\"fluctuate\":true,\"fluctuate_value\":2.0,\"fluctuatefakelag\":false,\"hold_delay\":7.0,\"hold_time\":1.0,\"interaction_type\":\"Net_update\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":14.0,\"tickspeed2\":14.0,\"yaw_add\":-19.0,\"yaw_add_r\":34.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":14.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"global\":{\"body_yaw\":\"off\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"fakelimit\":32.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"local view\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":17.0,\"faszsagfakeyaw_r\":12.0,\"fluctuate\":true,\"fluctuate_value\":3.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":3.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":0.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"freestanding\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":56.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":4.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-30.0,\"faszsag_yawvalue_2\":40.0,\"faszsagfakeyaw\":8.0,\"faszsagfakeyaw_r\":16.0,\"fluctuate\":true,\"fluctuate_value\":4.0,\"fluctuatefakelag\":false,\"hold_delay\":6.0,\"hold_time\":3.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":14.0,\"tickspeed2\":15.0,\"yaw_add\":-28.0,\"yaw_add_r\":27.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":19.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"slow walk\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":32.0,\"faszsag\":true,\"faszsag_antibrute\":false,\"faszsag_defensive\":true,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":58.0,\"faszsag_fakelimit_r\":58.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":4.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-40.0,\"faszsag_yawvalue_2\":51.0,\"faszsagfakeyaw\":14.0,\"faszsagfakeyaw_r\":4.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":true,\"hold_delay\":0.0,\"hold_time\":0.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head (hg)\",\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":11.0,\"tickspeed2\":14.0,\"yaw_add\":-50.0,\"yaw_add_r\":50.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":10.0,\"faszsag_fakelimit_r\":8.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-46.0,\"faszsag_yawvalue_2\":40.0,\"faszsagfakeyaw\":8.0,\"faszsagfakeyaw_r\":15.0,\"fluctuate\":true,\"fluctuate_value\":5.0,\"fluctuatefakelag\":false,\"hold_delay\":7.0,\"hold_time\":3.0,\"interaction_type\":\"Createmove\",\"options\":[\"safe head\",\"force defensive\",\"safe head (hg)\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":6.0,\"tickspeed2\":7.0,\"yaw_add\":-31.0,\"yaw_add_r\":29.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"sanya\",\"yaw_jitter_add\":17.0,\"yawspeed\":8.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true}}}";
local v8 = "{\"ct\":{\"duck\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":56.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":15.0,\"faszsag_fakelimit_r\":16.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-35.0,\"faszsag_yawvalue_2\":36.0,\"faszsagfakeyaw\":20.0,\"faszsagfakeyaw_r\":15.0,\"fluctuate\":true,\"fluctuate_value\":8.0,\"fluctuatefakelag\":true,\"hold_delay\":17.0,\"hold_time\":1.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-26.0,\"yaw_add_r\":24.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":19.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"duck jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":59.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-24.0,\"faszsag_yawvalue_2\":46.0,\"faszsagfakeyaw\":9.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":2.0,\"fluctuatefakelag\":false,\"hold_delay\":3.0,\"hold_time\":4.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":1.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-17.0,\"yaw_add_r\":37.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":8.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"duck move\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":37.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":17.0,\"faszsag_fakelimit_r\":15.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-33.0,\"faszsag_yawvalue_2\":39.0,\"faszsagfakeyaw\":9.0,\"faszsagfakeyaw_r\":5.0,\"fluctuate\":true,\"fluctuate_value\":6.0,\"fluctuatefakelag\":false,\"hold_delay\":8.0,\"hold_time\":1.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-22.0,\"yaw_add_r\":23.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":13.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"global\":{\"body_yaw\":\"off\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"fakelimit\":32.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"local view\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":57.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":12.0,\"faszsag_fakelimit_r\":23.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-24.0,\"faszsag_yawvalue_2\":24.0,\"faszsagfakeyaw\":13.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":3.0,\"fluctuatefakelag\":false,\"hold_delay\":9.0,\"hold_time\":0.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":1.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-17.0,\"yaw_add_r\":22.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"random\",\"yaw_jitter_add\":15.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":48.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":11.0,\"faszsagfakeyaw_r\":6.0,\"fluctuate\":true,\"fluctuate_value\":8.0,\"fluctuatefakelag\":false,\"hold_delay\":6.0,\"hold_time\":2.0,\"options\":[\"safe head\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-31.0,\"yaw_add_r\":22.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":8.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"slow walk\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":32.0,\"faszsag\":true,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":43.0,\"faszsag_fakelimit_r\":44.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-35.0,\"faszsag_yawvalue_2\":46.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":12.0,\"tickspeed2\":14.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":58.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-53.0,\"faszsag_yawvalue_2\":54.0,\"faszsagfakeyaw\":7.0,\"faszsagfakeyaw_r\":5.0,\"fluctuate\":true,\"fluctuate_value\":3.0,\"fluctuatefakelag\":false,\"hold_delay\":7.0,\"hold_time\":2.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-27.0,\"yaw_add_r\":25.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":17.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true}},\"t\":{\"duck\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":56.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-56.0,\"faszsag_yawvalue_2\":51.0,\"faszsagfakeyaw\":7.0,\"faszsagfakeyaw_r\":11.0,\"fluctuate\":true,\"fluctuate_value\":8.0,\"fluctuatefakelag\":true,\"hold_delay\":17.0,\"hold_time\":1.0,\"options\":[\"safe head\",\"force lag\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":-29.0,\"yaw_add_r\":24.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":19.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"duck jump\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"freestanding\",\"choke1\":15.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":58.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":58.0,\"faszsag_fakelimit_r\":58.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":10.0,\"faszsag_spinspeed\":3.0,\"faszsag_yaw\":\"sway\",\"faszsag_yawvalue_1\":-62.0,\"faszsag_yawvalue_2\":30.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":8.0,\"fluctuate\":true,\"fluctuate_value\":4.0,\"fluctuatefakelag\":false,\"hold_delay\":8.0,\"hold_time\":1.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":3.0,\"tickbase\":1.0,\"tickspeed\":11.0,\"tickspeed2\":13.0,\"yaw_add\":-23.0,\"yaw_add_r\":42.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":16.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"duck move\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":37.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"sway\",\"faszsag_yawvalue_1\":-57.0,\"faszsag_yawvalue_2\":56.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":7.0,\"fluctuate\":true,\"fluctuate_value\":7.0,\"fluctuatefakelag\":false,\"hold_delay\":11.0,\"hold_time\":2.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":5.0,\"tickbase\":1.0,\"tickspeed\":14.0,\"tickspeed2\":14.0,\"yaw_add\":-29.0,\"yaw_add_r\":34.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":12.0,\"yawspeed\":7.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true},\"global\":{\"body_yaw\":\"off\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"fakelimit\":32.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"local view\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"yawspeed_randomization\":false},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":17.0,\"faszsagfakeyaw_r\":12.0,\"fluctuate\":true,\"fluctuate_value\":3.0,\"fluctuatefakelag\":false,\"hold_delay\":8.0,\"hold_time\":0.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":13.0,\"tickspeed2\":14.0,\"yaw_add\":3.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":0.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"freestanding\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":50.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":true,\"faszsag_speed\":4.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-30.0,\"faszsag_yawvalue_2\":40.0,\"faszsagfakeyaw\":8.0,\"faszsagfakeyaw_r\":16.0,\"fluctuate\":true,\"fluctuate_value\":8.0,\"fluctuatefakelag\":false,\"hold_delay\":17.0,\"hold_time\":2.0,\"options\":[\"safe head\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":14.0,\"tickspeed2\":15.0,\"yaw_add\":-33.0,\"yaw_add_r\":21.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":24.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"slow walk\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":32.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":true,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":58.0,\"faszsag_fakelimit_r\":58.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":10.0,\"faszsag_spinspeed\":4.0,\"faszsag_yaw\":\"sway\",\"faszsag_yawvalue_1\":-70.0,\"faszsag_yawvalue_2\":51.0,\"faszsagfakeyaw\":14.0,\"faszsagfakeyaw_r\":4.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":true,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickbase\":1.0,\"tickspeed\":11.0,\"tickspeed2\":14.0,\"yaw_add\":-50.0,\"yaw_add_r\":50.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0,\"yawspeed\":7.0,\"yawspeed2\":7.0,\"yawspeed_randomization\":true},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"choke1\":5.0,\"choke2\":15.0,\"enable\":true,\"fakelimit\":59.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":10.0,\"faszsag_fakelimit_r\":8.0,\"faszsag_pitch\":\"fake down\",\"faszsag_randomize_fakelimit\":false,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":2.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-46.0,\"faszsag_yawvalue_2\":40.0,\"faszsagfakeyaw\":8.0,\"faszsagfakeyaw_r\":15.0,\"fluctuate\":true,\"fluctuate_value\":4.0,\"fluctuatefakelag\":false,\"hold_delay\":7.0,\"hold_time\":1.0,\"options\":[\"safe head\",\"force defensive\",\"warmup AA\",\"~\"],\"randomize_delays\":true,\"switch_delay\":4.0,\"tickbase\":1.0,\"tickspeed\":6.0,\"tickspeed2\":7.0,\"yaw_add\":-31.0,\"yaw_add_r\":26.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"offset\",\"yaw_jitter_add\":17.0,\"yawspeed\":8.0,\"yawspeed2\":8.0,\"yawspeed_randomization\":true}}}";
local v9 = "{\"ct\":{\"duck\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":true,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-22.0,\"faszsag_yawvalue_2\":44.0,\"faszsagfakeyaw\":60.0,\"faszsagfakeyaw_r\":60.0,\"yawspeed\":10.0,\"yawspeed2\":9.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-10.0,\"yaw_add_r\":12.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":48.0},\"duck jump\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":23.0,\"faszsag_fakelimit_r\":30.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":true,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-8.0,\"faszsag_yawvalue_2\":7.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":13.0,\"yawspeed\":7.0,\"yawspeed2\":6.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":8.0,\"tickspeed2\":10.0,\"yaw_add\":20.0,\"yaw_add_r\":-20.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":5.0},\"duck move\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"fake up\",\"yawspeed_randomization\":true,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"sway\",\"faszsag_yawvalue_1\":99.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":48.0,\"faszsagfakeyaw_r\":48.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-30.0,\"yaw_add_r\":33.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":0.0},\"global\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":60.0,\"faszsagfakeyaw_r\":60.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":8.0,\"yaw_add_r\":-8.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":true,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":17.0,\"faszsagfakeyaw_r\":12.0,\"yawspeed\":9.0,\"yawspeed2\":8.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-27.0,\"yaw_add_r\":42.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake up\",\"yawspeed_randomization\":true,\"faszsag_speed\":4.0,\"faszsag_spinspeed\":3.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-110.0,\"faszsag_yawvalue_2\":110.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":11.0,\"yawspeed\":9.0,\"yawspeed2\":8.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-25.0,\"yaw_add_r\":42.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"slow walk\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":4.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-10.0,\"faszsag_yawvalue_2\":13.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":true,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":39.0,\"faszsagfakeyaw_r\":39.0,\"yawspeed\":7.0,\"yawspeed2\":6.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":5.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-33.0,\"yaw_add_r\":41.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0}},\"t\":{\"duck\":{\"body_yaw\":\"tick\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":true,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-19.0,\"faszsag_yawvalue_2\":35.0,\"faszsagfakeyaw\":54.0,\"faszsagfakeyaw_r\":54.0,\"yawspeed\":7.0,\"yawspeed2\":6.0,\"fluctuate\":true,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":6.0,\"tickspeed2\":5.0,\"yaw_add\":-22.0,\"yaw_add_r\":22.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":34.0},\"duck jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":59.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":true,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":26.0,\"faszsag_fakelimit_r\":26.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":true,\"faszsag_speed\":6.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-14.0,\"faszsag_yawvalue_2\":15.0,\"faszsagfakeyaw\":12.0,\"faszsagfakeyaw_r\":11.0,\"yawspeed\":6.0,\"yawspeed2\":7.0,\"fluctuate\":true,\"fluctuate_value\":0.0,\"fluctuatefakelag\":true,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-19.0,\"yaw_add_r\":49.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":0.0},\"duck move\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":true,\"faszsag_speed\":5.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-31.0,\"faszsag_yawvalue_2\":33.0,\"faszsagfakeyaw\":60.0,\"faszsagfakeyaw_r\":60.0,\"yawspeed\":7.0,\"yawspeed2\":6.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-30.0,\"yaw_add_r\":33.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"global\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":false,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":60.0,\"faszsagfakeyaw_r\":60.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":8.0,\"yaw_add_r\":-8.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"torpedo\",\"yaw_jitter_add\":0.0},\"jump\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":true,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":17.0,\"faszsagfakeyaw_r\":12.0,\"yawspeed\":9.0,\"yawspeed2\":8.0,\"fluctuate\":true,\"fluctuate_value\":1.0,\"fluctuatefakelag\":true,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-27.0,\"yaw_add_r\":42.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"run\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":true,\"faszsag_fakelimit_l\":59.0,\"faszsag_fakelimit_r\":59.0,\"faszsag_pitch\":\"fake up\",\"yawspeed_randomization\":true,\"faszsag_speed\":4.0,\"faszsag_spinspeed\":3.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-110.0,\"faszsag_yawvalue_2\":110.0,\"faszsagfakeyaw\":10.0,\"faszsagfakeyaw_r\":11.0,\"yawspeed\":9.0,\"yawspeed2\":8.0,\"fluctuate\":true,\"fluctuate_value\":-8.0,\"fluctuatefakelag\":true,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":8.0,\"tickspeed2\":6.0,\"yaw_add\":-25.0,\"yaw_add_r\":42.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"center\",\"yaw_jitter_add\":0.0},\"slow walk\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":false,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":60.0,\"faszsag_fakelimit_r\":60.0,\"faszsag_pitch\":\"fake down\",\"yawspeed_randomization\":false,\"faszsag_speed\":7.0,\"faszsag_spinspeed\":4.0,\"faszsag_yaw\":\"jitter\",\"faszsag_yawvalue_1\":-10.0,\"faszsag_yawvalue_2\":13.0,\"faszsagfakeyaw\":0.0,\"faszsagfakeyaw_r\":0.0,\"yawspeed\":2.0,\"yawspeed2\":2.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":0.0,\"hold_time\":0.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":0.0,\"yaw_add_r\":0.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0},\"stand\":{\"body_yaw\":\"jitter\",\"body_yaw_side\":\"left\",\"enable\":true,\"fakelimit\":60.0,\"faszsag\":false,\"faszsag_antibrute\":true,\"faszsag_defensive\":false,\"faszsag_dis\":false,\"faszsag_fakelimit_l\":0.0,\"faszsag_fakelimit_r\":0.0,\"faszsag_pitch\":\"disabled\",\"yawspeed_randomization\":true,\"faszsag_speed\":2.0,\"faszsag_spinspeed\":1.0,\"faszsag_yaw\":\"static\",\"faszsag_yawvalue_1\":0.0,\"faszsag_yawvalue_2\":0.0,\"faszsagfakeyaw\":39.0,\"faszsagfakeyaw_r\":39.0,\"yawspeed\":7.0,\"yawspeed2\":6.0,\"fluctuate\":false,\"fluctuate_value\":0.0,\"fluctuatefakelag\":false,\"hold_delay\":5.0,\"hold_time\":2.0,\"options\":[\"~\"],\"randomize_delays\":false,\"switch_delay\":0.0,\"tickspeed\":2.0,\"tickspeed2\":2.0,\"yaw_add\":-33.0,\"yaw_add_r\":41.0,\"yaw_base\":\"at targets\",\"yaw_jitter\":\"off\",\"yaw_jitter_add\":0.0}}}";
utility_lerp = function(v10, v11, v12)
    return v10 + (v11 - v10) * v12;
end;
local function _(v13, v14)
    local v15 = 10 ^ (v14 or 0);
    return math.floor(v13 * v15 + 0.5) / v15;
end;
local v17 = {};
local v18 = false;
local v19 = math.pi * 2;
local v20 = v19 / 8;
local _ = "\a" .. ui.get_style().Button:to_hex();
ambani_insert_log = function(v22, v23)
    -- upvalues: v17 (ref)
    table.insert(v17, {
        w = 0, 
        circle = 0, 
        height = 0, 
        width = 0, 
        color2 = 0, 
        color = 0, 
        str_a = 0, 
        anim_mod = 0, 
        text = v22, 
        time = v23 or 5, 
        anim_time = globals.curtime
    });
end;
split = function(v24, v25)
    if v25 == nil then
        v25 = "%s";
    end;
    local v26 = {};
    for v27 in string.gmatch(v24, "([^" .. v25 .. "]+)") do
        table.insert(v26, v27);
    end;
    return v26;
end;
rgba_to_hex = function(v28, v29, v30, v31)
    return string.format("%02x%02x%02x%02x", v28, v29, v30, v31);
end;
color_text = function(v32, v33, v34, v35, v36)
    local v37 = "\a" .. color(v33, v34, v35, v36):to_hex();
    local v38 = "\a" .. color(255, 255, 255, v36):to_hex();
    local v39 = "";
    for v40, v41 in ipairs(split(v32, "$")) do
        v39 = v39 .. (v40 % 2 == (v32:sub(1, 1) == "$" and 0 or 1) and v38 or v37) .. v41;
    end;
    return v39;
end;
local function v49(v42, v43, v44)
    local v45 = v42 - v43;
    local v46 = v44 - v43;
    local v47 = #v46;
    v46.x = v46.x / v47;
    v46.y = v46.y / v47;
    v46.z = v46.z / v47;
    local v48 = v46.x * v45.x + v46.y * v45.y + v46.z * v45.z;
    if v48 < 0 then
        return v43;
    elseif v47 < v48 then
        return v44;
    else
        return vector(v43.x + v46.x * v48, v43.y + v46.y * v48, v43.z + v46.z * v48);
    end;
end;
local v50 = 0;
local v51 = 0;
local function v55(v52, v53, v54)
    -- upvalues: v51 (ref), v49 (ref), v50 (ref)
    v51 = v49(v52, v53, v54):dist(v52);
    if v51 > 55 then
        return;
    else
        v50 = globals.tickcount;
        return;
    end;
end;
local v56 = {
    ab = {
        hurt = false, 
        jitteramount = 0, 
        jitter = 0, 
        bruted_last_time = 0, 
        stage = {}, 
        should_swap = {}, 
        time = {}, 
        misses = {}, 
        jitteralgo = {}
    }
};
local v57 = render.load_font("museo500", 18, "ad");
local v58 = render.load_font("museo500", 14, "ad");
render_custom_square = function(v59, v60, v61, v62)
    -- upvalues: v57 (ref)
    local v63 = v59.x / v59.x + 10;
    local v64 = v59.y / 2 + v62 * 35;
    local v65 = render.measure_text(v57, "c", v61);
    local v66 = v65.x + 10;
    local v67 = v65.y + 10;
    local v68 = vector(v63, v64);
    local v69 = vector(v63 + v66, v64 * 1.01);
    local v70 = vector(v63 + v66 * 0.9, v64);
    local v71 = vector(v63, v64 + v67);
    local v72 = vector(v63 + v66, v64 + v67);
    local _ = vector(v63 + v66 * 0.6, v64);
    render.gradient(v68, v72, color(0, 0, 0, 0), color(0, 0, 0, 0), v60, v60);
    render.line(v68, v70, v60);
    render.line(v72, v69, v60);
    render.line(v69, v70, v60);
    render.line(v72, v71, v60);
    render.line(v71, v68, v60);
    local v74 = v63 + 6 + v65.x;
    local v75 = v64 + (v67 - v65.y) / 1.9;
    render.text(v57, vector(v74, v75), color(255, 255, 255, 155), "r", v61);
end;
draw_styled_rect = function(v76, v77, v78, _, _, _, _)
    render.rect(vector(v76 - 3, v77 - 5), vector(v78 + 3, v77 + 23), color(30, 30, 30, 255), 5, true);
    render.rect(vector(v76 - 2, v77 - 4), vector(v78 + 2, v77 + 22), color(10, 10, 10, 255), 5, true);
    render.rect(vector(v76 - 1, v77 - 3), vector(v78 + 1, v77 + 21), color(30, 30, 30, 255), 5, true);
    render.rect(vector(v76 - 1, v77 - 3), vector(v78 + 1, v77 + 4), color(129, 119, 181, 255), 5, true);
    render.rect(vector(v76, v77 - 2), vector(v78, v77 + 20), color(15, 15, 15, 255), 5, true);
end;
local function v106()
    -- upvalues: v17 (ref)
    local l_curtime_0 = globals.curtime;
    local v84 = 1.5 * globals.frametime;
    local v85 = 8;
    local v86 = render.screen_size();
    local v87 = 255;
    local v88 = 255;
    local v89 = 255;
    local v90 = 255;
    local _ = 255;
    local _ = 255;
    local _ = 255;
    local v94 = 255;
    for v95, v96 in ipairs(v17) do
        v96.time = v96.time - globals.frametime;
        if v95 > 8 then
            table.remove(v17, 1);
        end;
        if v96.time <= 0 then
            table.remove(v17, v95);
        end;
        local _ = (v96.anim_time - l_curtime_0) * -0.7;
        local v98 = color_text(v96.text, 150, 150, 255, 255 * v96.color2);
        local v99 = render.measure_text(1, "[Ambani] ", "cb", v98) - 123;
        local v100 = vector(v86.x / 2);
        local v101 = vector(v86.y / 2 + 192);
        local _ = 18;
        local v103 = v99.x + 5;
        if v96.time > 5 then
            v96.color = utility_lerp(v96.color, v90, 2 * globals.frametime);
            v96.color2 = utility_lerp(v96.color2, v94, v84);
            v96.width = utility_lerp(v96.width, 163, v84);
            v96.anim_mod = utility_lerp(v96.anim_mod, v96.time, v84);
            v96.circle = utility_lerp(v96.circle, 0.64, v84);
            v96.str_a = v96.str_a + v84 * 2;
            if v96.str_a > 0.99 then
                v96.start = 1;
            end;
            v96.height = utility_lerp(v96.height, 200, 1 * globals.frametime);
            v96.w = utility_lerp(v96.w, v99.x + 8, v96.anim_mod);
        end;
        if v96.time < 0.4 then
            v96.color = utility_lerp(v96.color, -v90, 1 * globals.frametime);
            v96.color2 = utility_lerp(v96.color2, -v94, 1 * globals.frametime);
            v96.anim_mod = utility_lerp(v96.anim_mod, -v96.time - 5, v84);
            v96.width = utility_lerp(v96.width, -163, v84);
            v96.height = utility_lerp(v96.height, -100, v84);
            v96.circle = utility_lerp(v96.circle, -0.64, v84);
            v96.str_a = v96.str_a - (v96.w < 20 and v84 * 3 or v84);
            if v96.str_a < 0.01 then
                v96.str_a = 0;
            end;
            local v104 = v96.anim_mod * -1 + 1;
            v96.w = utility_lerp(v96.w, 5, v104);
        end;
        if v96.time > 4 and v96.anim_mod <= 0 then
            table.remove(v17, v95);
        end;
        local v105 = "[Ambani] ";
        v85 = v85 + 35 + v96.anim_mod;
        v100 = v100 - v103 / 2;
        v101 = v101 / 10 * 13.4 - v85;
        draw_styled_rect(v100.x - 52, v101.y + v86.y - v96.height - 11, v100.x + v99.x + 61, v101.y + v86.y - v96.height + 8, v96.color, color(150, 150, 255, v96.color - 70), color(30, 30, 30, v96.color - 50));
        render.text(1, vector(v100.x - 48 + v99.x - v99.x + render.measure_text(1, v105, nil).x, v101.y + v86.y - v96.height - 8), color(v87, v88, v89, v96.color), nil, v98);
    end;
end;
events.render:set(v106);
ambani_insert_log("$Ambani$ Welcome [$'" .. common.get_username() .. "'$] build $reborn$", 6);
local v572 = new_class():struct("globals")({
    nade = 0, 
    in_ladder = 0, 
    states = {
        [1] = "stand", 
        [2] = "slow walk", 
        [3] = "run", 
        [4] = "duck", 
        [5] = "jump", 
        [6] = "duck jump", 
        [7] = "duck move"
    }, 
    extended_states = {
        [1] = "global", 
        [2] = "stand", 
        [3] = "slow walk", 
        [4] = "run", 
        [5] = "duck", 
        [6] = "jump", 
        [7] = "duck jump", 
        [8] = "duck move"
    }, 
    extended_states2 = {
        [1] = "duck", 
        [2] = "duck move", 
        [3] = "stand", 
        [4] = "slow walk"
    }, 
    teams = {
        [1] = "t", 
        [2] = "ct"
    }, 
    resolver_data = {}
}):struct("ref")({
    antiaim = {
        enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti aim", "Angles", "Pitch"), 
        yaw = ui.find("Aimbot", "Anti aim", "Angles", "Yaw"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        yawoffset = ui.find("Aimbot", "Anti aim", "Angles", "Yaw", "Offset"), 
        yawmodifier = ui.find("Aimbot", "Anti aim", "Angles", "Yaw Modifier"), 
        yawmodifieramount = ui.find("Aimbot", "Anti aim", "Angles", "Yaw Modifier", "Offset"), 
        bodyyawopt = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        leftfake = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        rightfake = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
        bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
        freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        freestanding_static = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        yawtarget = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        fbyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
    }, 
    rage = {
        dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        hs2 = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
        fb = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
        dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
        fakelag_enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
        dtlag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
        fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson")
    }
}):struct("ui")({
    menu = {
        global = {}, 
        aa = {}, 
        vis = {}, 
        misc = {}, 
        cfg = {}, 
        debug = {}
    }, 
    execute = function(v107)
        -- upvalues: l_pui_0 (ref), l_clipboard_0 (ref)
        l_pui_0.sidebar("\vambani\r reborn", "react");
        local v108 = l_pui_0.create("bambani", {
            [1] = {
                [1] = "select", 
                [2] = "SELECTION", 
                [3] = 1
            }, 
            [2] = {
                [1] = "main", 
                [2] = "MAIN", 
                [3] = 2
            }, 
            [3] = {
                [1] = "other", 
                [2] = "MODE", 
                [3] = 1
            }, 
            [4] = {
                [1] = "addon", 
                [2] = "EXTRA", 
                [3] = 1
            }, 
            [5] = {
                [1] = "builder", 
                [2] = "BUILDER", 
                [3] = 2
            }, 
            [6] = {
                [1] = "configs", 
                [2] = "CONFIGS"
            }, 
            [7] = {
                [1] = "info", 
                [2] = "info"
            }
        });
        v107.menu.global.select = v108.select:list("", {
            [1] = "\v                    \f<file-import>  Home & Config", 
            [2] = "\v                           \f<user-alien>  Anti-aim", 
            [3] = "\v                           \f<paint-roller>  Visuals", 
            [4] = "\v                      \f<cubes>  Miscellaneous"
        });
        v107.menu.cfg.label = v108.info:label("\rWelcome to the \v[dev]\r version of \vambani");
        v107.menu.cfg.yt = v108.info:button("\v\f<youtube>\r  Cola", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@kingcola1337");
        end, true);
        v107.menu.cfg.yt2 = v108.info:button("\v\f<youtube>\r  Hawiz", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@hawiz1220");
        end, true);
        v107.menu.cfg.dc = v108.info:button("\v\f<discord>\r  Discord", function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/c77g9BnV2k");
        end, true);
        v107.menu.aa.mode = v108.main:combo("\v\f<folder-closed>\r   Anti-aim modes", {
            [1] = "Ambani", 
            [2] = "Builder"
        });
        v107.menu.aa.preset_list = v108.main:list("\v\f<user-plus>\r  Built-in mode", {
            [1] = "\r sanya test preset   -   \v\f<at>Cola", 
            [2] = "\r torpedo preset  -   \v\f<at>Hawiz", 
            [3] = "\r current meta preset  -   \v\f<at>Kassu"
        }):depend({
            [1] = nil, 
            [2] = "Ambani", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.state = v108.main:combo("\v\f<users-between-lines>\r  State", v107.globals.extended_states):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.team = v108.main:combo("\v\f<people-arrows>\r   Team", v107.globals.teams):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.states = {};
        for _, v110 in ipairs(v107.globals.teams) do
            v107.menu.aa.states[v110] = {};
            for _, v112 in ipairs(v107.globals.extended_states) do
                v107.menu.aa.states[v110][v112] = {};
                local v113 = v107.menu.aa.states[v110][v112];
                if v112 ~= "global" then
                    v113.enable = v108.builder:switch("\v\f<play-pause>\r   Activate \aFF2000FF" .. v112 .. "\n" .. v110);
                end;
                v113.options = v108.builder:selectable("\v\f<gear>\r   Options" .. "\n" .. v112 .. v110, "defensive yaw", "safe head", "e spam", "e spam (safe)", "force defensive", "safe head (hg)");
                v113.interaction_type = v108.builder:combo("\v-\r   Interaction type" .. "\n" .. v112 .. v110, {
                    [1] = "Createmove", 
                    [2] = "Net_update"
                });
                v113.yaw_base = v108.builder:combo("\v\f<sitemap>\r   Yaw Base" .. "\n" .. v112 .. v110, {
                    [1] = "local view", 
                    [2] = "at targets"
                });
                local v114 = v113.yaw_base:create();
                v113.yaw_add = v108.builder:slider("             \v\f\r   Yaw Left" .. "\n" .. v112 .. v110, -180, 180, 0, 1);
                v113.yaw_add_r = v108.builder:slider("             \v\f\r   Yaw Right" .. "\n" .. v112 .. v110, -180, 180, 0, 1);
                v113.fluctuate = v114:switch("\v\f<angle>\r    Fluctuate Yaw\n" .. v112 .. "\n" .. v110);
                v113.fluctuate_value = v114:slider("             \v\f\r   Yaw" .. "\n" .. v112 .. v110, -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v113.fluctuate
                });
                v113.kikapcs = v114:switch("\v\f<rotate-right>\r    FL Off\n" .. v112 .. "\n" .. v110);
                v113.fluctuatefakelag = v114:switch("\v\f<rotate-right>\r    Fluctuate Fakelag\n" .. v112 .. "\n" .. v110);
                v113.yaw_jitter = v108.builder:combo("\v\f<gitter>\r   Yaw Jitter\n" .. v112 .. v110, {
                    [1] = "off", 
                    [2] = "offset", 
                    [3] = "center", 
                    [4] = "random", 
                    [5] = "3-way", 
                    [6] = "5-way", 
                    [7] = "torpedo", 
                    [8] = "sanya"
                });
                local v115 = v113.yaw_jitter:create();
                v113.yaw_jitter_add = v115:slider("\v\f<angle>\r   Jitter amount\n" .. v112 .. v110, -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.hold_time = v115:slider("\v\f<timer>\r   Hold ticks\n" .. v112 .. v110, 0, 5, 0, 1):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.hold_delay = v115:slider("\v\f<timer>\r   Hold cycles\n" .. v112 .. v110, 0, 32, 0, 1):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.switch_delay = v115:slider("\v\f<timer>\r   Switch delay\n" .. v112 .. v110, 0, 5, 0, 1):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.randomize_delays = v115:switch(" \v\f<question>\r   Random delays\n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsagfakeyaw = v115:slider("\v\f<angle>\r   Fake Limit Left   \n" .. v112 .. v110, 0, 60, 0, 1):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsagfakeyaw_r = v115:slider("\v\f<angle>\r   Fake Limit Right\n" .. v112 .. v110, 0, 60, 0, 1):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsag_randomize_fakelimit = v115:switch("\v\f<angle>\r   Randomize Fake Limit\n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.yawspeed_randomization = v115:switch("\v\f<shuffle>\r   Yaw speed randomization \n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.yawspeed = v115:slider("\v\f<loader>\r    1st Yaw speed \n" .. v112 .. v110, 2, 10, 0, 1):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.yawspeed2 = v115:slider("\v\f<loader>\r   2nd Yaw speed \n" .. v112 .. v110, 2, 10, 0, 1):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                }):depend({
                    [1] = nil, 
                    [2] = true, 
                    [1] = v113.yawspeed_randomization
                });
                v113.faszsag_antibrute = v115:switch("\v\f<shield-slash>\r   Antibrute \n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsag_dis = v115:switch(" \v\f<user-minus>\r   Disable on lagcomp\n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsag_defensive = v115:switch(" \v\f<shield-xmark>\r    Use Defensive\n" .. v112 .. "\n" .. v110):depend({
                    [1] = nil, 
                    [2] = "torpedo", 
                    [1] = v113.yaw_jitter
                });
                v113.faszsag = v108.builder:switch(" \v\f<lightbulb>\r   Flick Exploit\n" .. v112 .. "\n" .. v110);
                local v116 = v113.faszsag:create();
                v113.faszsag_speed = v116:slider("\v\f<sliders>\r   Speed\n" .. v112 .. "\n" .. v110, 2, 10, 0, 1);
                v113.faszsag_pitch = v116:combo("\v\f<person>\r    Pitch\n" .. v112 .. v110, {
                    [1] = "disabled", 
                    [2] = "fake up", 
                    [3] = "fake down"
                });
                v113.faszsag_yaw = v116:combo("\v\f<lightbulb>\r   Yaw Mode\n" .. v112 .. v110, {
                    [1] = "static", 
                    [2] = "jitter", 
                    [3] = "spin", 
                    [4] = "sway"
                });
                v113.faszsag_yawvalue_1 = v116:slider("\v\f<angle-90>\r   1st Yaw\n" .. v112 .. v110, -180, 180, 0, 1);
                v113.faszsag_yawvalue_2 = v116:slider("\v\f<angle-90>\r   2nd Yaw\n" .. v112 .. v110, -180, 180, 0, 1):depend({
                    [1] = nil, 
                    [2] = "jitter", 
                    [1] = v113.faszsag_yaw
                });
                v113.faszsag_spinspeed = v116:slider("\v\f<loader>\r   Spin Speed\n" .. v112 .. v110, 1, 5, 0, 1):depend({
                    [1] = nil, 
                    [2] = "spin", 
                    [1] = v113.faszsag_yaw
                });
                v113.faszsag_fakelimit_l = v116:slider("\v\f<angle>\r  Fake Limit Left\n" .. v112 .. v110, 0, 60, 0, 1);
                v113.faszsag_fakelimit_r = v116:slider("\v\f<angle>\r  Fake Limit Right\n" .. v112 .. v110, 0, 60, 0, 1);
                v113.body_yaw = v108.builder:combo(" \v\f<child>\r    Body Yaw\n" .. "\n" .. v112 .. v110, {
                    [1] = "off", 
                    [2] = "static", 
                    [3] = "jitter", 
                    [4] = "random", 
                    [5] = "tick"
                });
                v113.tickspeed = v108.builder:slider("\v\f<angle>\r  Tick speed 1\n" .. v112 .. v110, 2, 16, 0, 1):depend({
                    [1] = nil, 
                    [2] = "tick", 
                    [1] = v113.body_yaw
                });
                v113.tickspeed2 = v108.builder:slider("\v\f<angle>\r  Tick speed 2\n" .. v112 .. v110, 2, 16, 0, 1):depend({
                    [1] = nil, 
                    [2] = "tick", 
                    [1] = v113.body_yaw
                });
                local _ = v113.body_yaw:create();
                v113.body_yaw_side = v108.builder:combo("\v\f<angle>\r    body yaw side" .. "\n" .. v112 .. v110, {
                    [1] = "left", 
                    [2] = "right", 
                    [3] = "freestanding"
                }):depend({
                    [1] = nil, 
                    [2] = "static", 
                    [3] = false, 
                    [1] = v113.body_yaw
                });
                v113.fakelimit = v108.builder:slider("             \v\f\r   Fake limit" .. "\n" .. v112 .. v110, 0, 60, 32, 1):depend({
                    [1] = nil, 
                    [2] = "static", 
                    [3] = "jitter", 
                    [4] = "random", 
                    [5] = "tick", 
                    [1] = v113.body_yaw
                }):depend({
                    [1] = nil, 
                    [2] = "off", 
                    [3] = "offset", 
                    [4] = "center", 
                    [5] = "random", 
                    [6] = "3-way", 
                    [7] = "5-way", 
                    [8] = "sanya", 
                    [1] = v113.yaw_jitter
                });
                v113.tickbase = v108.builder:slider("\vTickbase\n", 1, 2, 0, 1, function(v118)
                    if v118 == 1 then
                        return "Default";
                    else
                        return "Ambani";
                    end;
                end);
                local v119 = v113.tickbase:create();
                v113.choke1 = v119:slider("Choke from\n", 1, 22, 5, 1, function(v120)
                    return v120 .. "t";
                end):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v113.tickbase
                });
                v113.choke2 = v119:slider("Choke to\n", 1, 22, 15, 1, function(v121)
                    return v121 .. "t";
                end):depend({
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v113.tickbase
                });
                for v122, v123 in pairs(v113) do
                    local v124 = {
                        [1] = {
                            [1] = v107.menu.aa.state, 
                            [2] = v112
                        }, 
                        [2] = {
                            [1] = v107.menu.aa.team, 
                            [2] = v110
                        }, 
                        [3] = {
                            [1] = nil, 
                            [2] = "Builder", 
                            [1] = v107.menu.aa.mode
                        }
                    };
                    if v122 ~= "enable" and v112 ~= "global" then
                        v124 = {
                            [1] = {
                                [1] = v107.menu.aa.state, 
                                [2] = v112
                            }, 
                            [2] = {
                                [1] = v107.menu.aa.team, 
                                [2] = v110
                            }, 
                            [3] = {
                                [1] = nil, 
                                [2] = "Builder", 
                                [1] = v107.menu.aa.mode
                            }, 
                            [4] = {
                                [1] = nil, 
                                [2] = true, 
                                [1] = v113.enable
                            }
                        };
                    end;
                    v123:depend(table.unpack(v124));
                end;
            end;
        end;
        v107.menu.aa.export_from = v108.other:combo("\v\f<share>\r  Export", {
            [1] = "selected state", 
            [2] = "selected team"
        }):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.export_to = v108.other:combo("\v\f<terminal>\r  To", {
            [1] = "opposite team", 
            [2] = "clipboard"
        }):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.export = v108.other:button("\v\f<file-export>\r  Export", function()
            -- upvalues: v107 (ref), l_clipboard_0 (ref)
            local v125 = "team";
            local v126 = v107.menu.aa.team:get() == "ct" and "t" or "ct";
            if v107.menu.aa.export_from:get() == "selected state" then
                v125 = "state";
            end;
            data = v107.config:export(v125, v107.menu.aa.team:get(), v107.menu.aa.state:get());
            if v107.menu.aa.export_to:get() == "clipboard" then
                l_clipboard_0.set(data);
            else
                v107.config:import(data, v125, v126, v107.menu.aa.state:get());
            end;
        end, true):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.import = v108.other:button("\v\f<file-import>\r  Import", function()
            -- upvalues: l_clipboard_0 (ref), v107 (ref)
            local v127 = l_clipboard_0.get();
            local v128 = v127:match("{ambani:(.+)}");
            v107.config:import(v127, v128, v107.menu.aa.team:get(), v107.menu.aa.state:get());
        end, true):depend({
            [1] = nil, 
            [2] = "Builder", 
            [1] = v107.menu.aa.mode
        });
        v107.menu.aa.freestanding = v108.addon:switch("\v\f<users-line>\r    Freestanding");
        local v129 = v107.menu.aa.freestanding:create();
        v107.menu.aa.freestanding_disablers = v129:selectable("\v\f<user-slash>\r  Disablers", v107.globals.states):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v107.menu.aa.freestanding
        });
        v107.menu.misc.fastladder = v108.other:switch("\v\f<water-ladder>\r    Fast Ladder");
        v107.menu.aa.manual_aa = v108.addon:combo("\v\f<arrows-up-down-left-right>\r     Manual antiaim", {
            [1] = "Off", 
            [2] = "Left", 
            [3] = "Right", 
            [4] = "Forward"
        });
        v107.menu.aa.yawmodifier = v129:selectable(" \v\f<arrows-up-down-left-right>\r  Type", {
            [1] = "Force static"
        }):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v107.menu.aa.freestanding
        });
        v107.menu.misc.animations = v108.main:label("\v\f<gif>\r    Animations");
        v107.menu.aa.autoos = v108.addon:switch("\v\f<head-side-cough-slash>\r    Auto hideshots", false, "\aFF0000FFCAUTION! \rThis disables doubletap and enables hideshots with pistol and on [X] state");
        v107.menu.aa.troll_aa = v108.addon:selectable("\v\f<users-line>\r    Troll AA", {
            [1] = "Warmup", 
            [2] = "Round end"
        });
        local v130 = v107.menu.aa.autoos:create();
        v107.menu.aa.autoos_states = v130:selectable("\v\f<users-between-lines>\r    States", v107.globals.extended_states2):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v107.menu.aa.autoos
        });
        local v131 = v107.menu.misc.animations:create();
        v107.menu.misc.animations_selector = v131:selectable("\v\f<users-between-lines>\r    Type", "Static legs", "Moon walk", "Leg fucker", "Body lean", "Earthquake", "Goblin in air", "0 Pitch on land");
        v107.menu.misc.hitlogs_label = v108.main:label("\v\f<text-height>\r    Hitlogs");
        local v132 = v107.menu.misc.hitlogs_label:create();
        v107.menu.misc.hitlogs = v132:selectable("\v\f<users-between-lines>\r    Appereance", "On screen", "Console", "Notifications");
        v107.menu.misc.hitlog_color = v132:label("\a877f99ff\f<palette>\r", color(161, 135, 153)):depend({
            [1] = nil, 
            [2] = "On screen", 
            [1] = v107.menu.misc.hitlogs
        }):depend({
            [1] = nil, 
            [2] = "On screen", 
            [1] = v107.menu.misc.hitlogs
        });
        v107.menu.vis.indicators = v108.main:switch("\v\f<users-between-lines>\r    Crosshair Indicators");
        v107.menu.vis.indicatorfont = v108.addon:combo("\v\f<font-case>\r    Crosshair Font", {
            [1] = "small", 
            [2] = "normal", 
            [3] = "bold"
        });
        v107.menu.vis.side_indicators = v108.main:switch("\v\f<sidebar>\r    Side Indicators");
        v107.menu.vis.side_indicators_color = v108.addon:label("\v\f<sidebar>\r    Side Indicators Color", color(255, 255, 255, 255));
        v107.menu.vis.dmgindicator = v108.main:switch("\v\f<users-between-lines>\r    Minimum damage indicator");
        v107.menu.vis.missnotification = v108.main:switch("\v\f<sidebar>\r    Display misses on screen");
        v107.menu.vis.windows = v108.main:switch("\v\f<keyboard>\r    Hotkey");
        v107.menu.vis.scope_overlay = v108.main:switch("\v\f<microscope>\r    Custom scope overlay");
        v107.menu.vis.revolver_helper = v108.main:switch("\v\f<circle-exclamation>\r    Revolver Helper", false);
        v107.menu.vis.hotkey_options = v108.addon:label("\v\f<keyboard>\r    Hotkey options");
        local v133 = v107.menu.vis.hotkey_options:create();
        v107.menu.vis.hotkey_text_color = v133:label("\a877f99ff\f<palette>\r Text color", false, color(200, 200, 200));
        v107.menu.vis.hotkey_background_color = v133:label("\a877f99ff\f<palette>\r Background color", false, color(15, 15, 15));
        v107.menu.vis.hotkey_edge_color = v133:label("\a877f99ff\f<palette>\r Edge color", false, color(161, 135, 153));
        v107.menu.vis.scope_overlay_options = v108.addon:label("\v\f<microscope>\r    Scope overlay options");
        local v134 = v107.menu.vis.scope_overlay_options:create();
        v107.menu.vis.scope_overlay_color = v134:label("\v\f<palette>\r  Color", color(255, 255, 255, 255));
        v107.menu.vis.scope_overlay_line = v134:slider("\v\f<angle>\r  Line", 0, 100, 50, 1);
        v107.menu.vis.scope_overlay_gap = v134:slider("\v\f<angle>\r  Gap", 0, 100, 10, 1);
        v107.menu.vis.scope_overlay_rotate = v134:switch("\v\f<angle>\r  Rotate", false);
        v107.menu.misc.extravisual = v108.main:label("\v\f<users-between-lines>\r    Viewmodel");
        local v135 = v107.menu.misc.extravisual:create();
        v107.menu.misc.viewmodel_fov = v135:slider("\v\f<binoculars>\r    FOV", 0, 1000, 690, 0.1);
        v107.menu.misc.viewmodel_x = v135:slider("\v\f<x>\r    X", -150, 150, 25, 0.1);
        v107.menu.misc.viewmodel_y = v135:slider("\v\f<y>\r    Y", -150, 150, 25, 0.1);
        v107.menu.misc.viewmodel_z = v135:slider("\v\f<z>\r    Z", -150, 150, 25, 0.1);
        v107.menu.misc.extended_ping = v108.main:label("\v\f<wind>\r    Extended pingspike");
        local v136 = v107.menu.misc.extended_ping:create();
        v107.menu.misc.extended_ping_amount = v136:slider("\v\f\r    Pingspike", 0, 200, 0, nil);
        v107.menu.misc.aspectratio = v108.main:slider("\v\f<tv>\r    Aspect Ratio", 0, 200, 0, 0.01);
        v107.menu.misc.no_fall_damage = v108.other:switch("\v\f<person-falling-burst>\r    No Fall Damage");
        v107.menu.misc.nadefix = v108.other:switch("\v\f<hammer>\r   Grenade Fix");
        v107.menu.misc.freezetime_fd = v108.other:switch("\v\f<duck>\r   Freezetime fake duck");
        v107.menu.misc.unlock_fakeduck_speed = v108.other:switch("\v\f<duck>\r   Unlock fake duck speed");
        v107.menu.misc.disable_cvars = v108.other:switch("\v\f<hammer>\r   Disable useless cvars");
        v107.menu.cfg.list = v108.main:list("configs", {});
        v107.menu.cfg.list:set_callback(function()
            -- upvalues: v107 (ref)
            v107.config:update_name();
        end);
        v107.menu.cfg.name = v108.main:input(" \v\f<file>\r   Config name");
        v107.menu.cfg.save = v108.main:button("\v\f<floppy-disk>\r  Save", function()
            -- upvalues: v107 (ref)
            v107.config:save();
        end, true);
        v107.menu.cfg.load = v108.main:button("\v\f<spinner>\r  Load", function()
            -- upvalues: v107 (ref)
            v107.config:load();
        end, true);
        v107.menu.cfg.delete = v108.main:button("\v\f<trash-can>\r  Delete", function()
            -- upvalues: v107 (ref)
            v107.config:delete();
        end, true);
        v107.menu.cfg.export = v108.main:button("\v\f<file-export>\r  Export", function()
            -- upvalues: l_clipboard_0 (ref), v107 (ref)
            l_clipboard_0.set(v107.config:export("config"));
        end, true);
        v107.menu.cfg.import = v108.main:button("\v\f<file-import>\r  Import", function()
            -- upvalues: v107 (ref), l_clipboard_0 (ref)
            v107.config:import(l_clipboard_0.get(), "config");
        end, true);
        v107.menu.cfg.export_preset = v108.main:button("\v\f<triangle-exclamation>\r  [developer export]", function()
            -- upvalues: l_pui_0 (ref), v107 (ref), l_clipboard_0 (ref)
            local v137 = l_pui_0.setup(v107.menu.aa.states, true):save();
            local v138 = json.stringify(v137);
            l_clipboard_0.set(v138);
        end, true, "\aFF0000FFCAUTION! \rThis is developer export, does not work for sharing settings");
        local v139 = {
            misc = 4, 
            vis = 3, 
            aa = 2, 
            cfg = 1
        };
        for v140, v141 in pairs(v107.menu) do
            if type(v141) == "table" and v140 ~= "global" then
                Loop = function(v142, v143)
                    -- upvalues: v107 (ref), v139 (ref)
                    for _, v145 in pairs(v142) do
                        if type(v145) == "table" then
                            if v145.__type == "pui::element" then
                                v145:depend({
                                    [1] = v107.menu.global.select, 
                                    [2] = v139[v143]
                                });
                            else
                                Loop(v145, v143);
                            end;
                        end;
                    end;
                end;
                Loop(v141, v140);
            end;
        end;
    end
}):struct("config")({
    configs = {}, 
    write_file = function(_, v147, v148)
        if not v148 or type(v147) ~= "string" then
            return;
        else
            return files.write(v147, json.stringify(v148));
        end;
    end, 
    update_name = function(v149)
        local v150 = v149.ui.menu.cfg.list();
        local v151 = 1;
        for v152, _ in pairs(v149.configs) do
            if v150 == v151 or v150 == 0 then
                return v149.ui.menu.cfg.name(v152);
            else
                v151 = v151 + 1;
            end;
        end;
    end, 
    update_configs = function(v154)
        local v155 = {};
        for v156, _ in pairs(v154.configs) do
            table.insert(v155, v156);
        end;
        v154.ui.menu.cfg.list:update(v155);
        v154:write_file("ambani_configs.txt", v154.configs);
        v154:update_name();
    end, 
    setup = function(v158)
        local v159 = files.read("ambani_configs.txt");
        if v159 == nil then
            v158.configs = {};
            return;
        else
            v158.configs = json.parse(v159);
            v158:update_configs();
            v158:update_name();
            return;
        end;
    end, 
    export_config = function(v160, ...)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v161 = l_pui_0.setup({
            [1] = v160.ui.menu.global, 
            [2] = v160.ui.menu.aa, 
            [3] = v160.ui.menu.misc, 
            [4] = v160.ui.menu.vis
        }, true):save();
        return (l_base64_0.encode(json.stringify(v161)));
    end, 
    export_state = function(v162, v163, v164)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v165 = l_pui_0.setup({
            [1] = v162.ui.menu.aa.states[v163][v164]
        }, true):save();
        return (l_base64_0.encode(json.stringify(v165)));
    end, 
    export_team = function(v166, v167)
        -- upvalues: l_pui_0 (ref), l_base64_0 (ref)
        local v168 = l_pui_0.setup({
            [1] = v166.ui.menu.aa.states[v167]
        }, true):save();
        return (l_base64_0.encode(json.stringify(v168)));
    end, 
    export = function(v169, v170, ...)
        local l_status_0, l_result_0 = pcall(v169["export_" .. v170], v169, ...);
        if not l_status_0 then
            print(l_result_0);
            return;
        else
            return "{ambani:" .. v170 .. "}:" .. l_result_0;
        end;
    end, 
    import_config = function(v173, v174)
        -- upvalues: l_base64_0 (ref), l_pui_0 (ref)
        local v175 = json.parse(l_base64_0.decode(v174));
        l_pui_0.setup({
            [1] = v173.ui.menu.global, 
            [2] = v173.ui.menu.aa, 
            [3] = v173.ui.menu.misc, 
            [4] = v173.ui.menu.vis
        }, true):load(v175);
    end, 
    import_state = function(v176, v177, v178, v179)
        -- upvalues: l_base64_0 (ref), l_pui_0 (ref)
        local v180 = json.parse(l_base64_0.decode(v177));
        l_pui_0.setup({
            [1] = v176.ui.menu.aa.states[v178][v179]
        }, true):load(v180);
    end, 
    import_team = function(v181, v182, v183)
        -- upvalues: l_base64_0 (ref), l_pui_0 (ref)
        local v184 = json.parse(l_base64_0.decode(v182));
        l_pui_0.setup({
            [1] = v181.ui.menu.aa.states[v183]
        }, true):load(v184);
    end, 
    import = function(v185, v186, v187, ...)
        local v188 = v186:match("{ambani:(.+)}");
        if not v188 or v188 ~= v187 then
            return error("This is not valid ambani data. 1");
        else
            local l_status_1, l_result_1 = pcall(v185["import_" .. v188], v185, v186:gsub("{ambani:" .. v188 .. "}:", ""), ...);
            if not l_status_1 then
                print(l_result_1);
                return error("This is not valid ambani data. 2");
            else
                return;
            end;
        end;
    end, 
    save = function(v191)
        local v192 = v191.ui.menu.cfg.name();
        if v192:match("%w") == nil then
            return print("Invalid config name");
        else
            local v193 = v191:export("config");
            v191.configs[v192] = v193;
            v191:update_configs();
            return;
        end;
    end, 
    load = function(v194)
        local v195 = v194.ui.menu.cfg.name();
        local v196 = v194.configs[v195];
        if not v196 then
            return print("Invalid config name");
        else
            v194:import(v196, "config");
            return;
        end;
    end, 
    delete = function(v197)
        local v198 = v197.ui.menu.cfg.name();
        if not v197.configs[v198] then
            return print("Invalid config name");
        else
            v197.configs[v198] = nil;
            v197:update_configs();
            return;
        end;
    end
}):struct("helpers")({
    contains = function(_, v200, v201)
        for _, v203 in pairs(v200) do
            if v203 == v201 then
                return true;
            end;
        end;
        return false;
    end, 
    easeInOut = function(_, v205)
        return v205 > 0.5 and 4 * (v205 - 1) ^ 3 + 1 or 4 * v205 ^ 3;
    end, 
    clamp = function(_, v207, v208, v209)
        assert(v207 and v208 and v209, "not very useful error message here");
        if v209 < v208 then
            local l_v209_0 = v209;
            v209 = v208;
            v208 = l_v209_0;
        end;
        return math.max(v208, math.min(v209, v207));
    end, 
    in_air = function(_, v212)
        local l_m_fFlags_0 = v212.m_fFlags;
        return bit.band(l_m_fFlags_0, 1) == 0;
    end, 
    in_duck = function(_, v215)
        local l_m_fFlags_1 = v215.m_fFlags;
        return bit.band(l_m_fFlags_1, 4) == 4;
    end, 
    gradienttext = function(_, _, v219, v220, v221, v222, v223)
        local v224 = "";
        local v225 = globals.realtime / 2 % 1.2 * 2 - 1.2;
        for v226 = 0, #v219 do
            local v227 = v219:sub(v226, v226);
            local v228 = v226 / #v219;
            local v229 = 255;
            local v230 = 255;
            local v231 = 255;
            local v232 = 155;
            local l_v220_0 = v220;
            local l_v221_0 = v221;
            local l_v222_0 = v222;
            local l_v223_0 = v223;
            local v237 = v228 - v225;
            if v237 >= 0 and v237 <= 1.4 then
                if v237 > 0.7 then
                    v237 = 1.4 - v237;
                end;
                local v238 = v229 - l_v220_0;
                local v239 = v230 - l_v221_0;
                local v240 = v231 - l_v222_0;
                local v241 = v232 - l_v223_0;
                l_v220_0 = l_v220_0 + v238 * v237 / 0.8;
                l_v221_0 = l_v221_0 + v239 * v237 / 0.8;
                l_v222_0 = l_v222_0 + v240 * v237 / 0.8;
                l_v223_0 = l_v223_0 + v241 * v237 / 0.8;
            end;
            v224 = v224 .. "\a" .. color(l_v220_0, l_v221_0, l_v222_0, l_v223_0):to_hex() .. v227;
        end;
        return v224;
    end, 
    animate_text = function(_, v243, v244, v245, v246, v247, v248)
        local v249 = {};
        local v250 = 1;
        local _ = v244:len() - 1;
        local v252 = 255 - v245;
        local v253 = 255 - v246;
        local v254 = 255 - v247;
        local v255 = 155 - v248;
        for v256 = 1, #v244 do
            local v257 = (v256 - 1) / (#v244 - 1) + v243;
            v249[v250] = "\a" .. color(v245 + v252 * math.abs(math.cos(v257)), v246 + v253 * math.abs(math.cos(v257)), v247 + v254 * math.abs(math.cos(v257)), v248 + v255 * math.abs(math.cos(v257))):to_hex();
            v249[v250 + 1] = v244:sub(v256, v256);
            v250 = v250 + 2;
        end;
        return v249;
    end, 
    get_state = function(v258)
        local v259 = entity.get_local_player();
        local v260 = v259.m_vecVelocity:length2d();
        if v258:in_air(v259) or v258.antiaim.air then
            return v258:in_duck(v259) and "duck jump" or "jump";
        elseif v260 > 3 and (v258:in_duck(v259) or v258.ref.rage.fd:get()) then
            return "duck move";
        elseif v258.ref.antiaim.slowwalk:get() then
            return "slow walk";
        elseif v258:in_duck(v259) or v258.ref.rage.fd:get() then
            return "duck";
        else
            return v260 > 1.5 and "run" or "stand";
        end;
    end, 
    get_team = function(_)
        return entity.get_local_player().m_iTeamNum == 2 and "t" or "ct";
    end, 
    get_charge = function()
        local _ = entity.get_local_player();
        local l_m_flSimulationTime_0 = entity.get_local_player().m_flSimulationTime;
        return globals.tickcount - l_m_flSimulationTime_0 / globals.tickinterval;
    end, 
    normalize = function(_, v265)
        v265 = (v265 % 360 + 360) % 360;
        if v265 > 180 then
            v265 = v265 - 360;
        end;
        return v265;
    end
}):struct("antiaim")({
    exploitswitch2 = false, 
    body_yaw_switch = false, 
    round_ended = false, 
    inverter_override_ticks = 0, 
    body_yaw_false_ticks = 0, 
    skitter_switch_delay = 0, 
    skitter_side = 0, 
    notifyenable = false, 
    jitter = 0, 
    cache = 0, 
    safe = false, 
    last_skitter = 0, 
    last_rand = 0, 
    cycle = 0, 
    hold_delay = 0, 
    last_angle = 0, 
    hold_time = 0, 
    side = 1, 
    has_updated = true, 
    moving_backward = false, 
    moving_forward = false, 
    moving_right = false, 
    moving_left = false, 
    counter4 = 0, 
    counter3 = 0, 
    counter2 = 0, 
    counter = 0, 
    old_yaw = 0, 
    exploitswitch3 = false, 
    switch_delay = 0, 
    exploitswitch = false, 
    reset = 0, 
    random_fluctuation = 0, 
    peeked2 = 0, 
    peeked = 0, 
    last_press = 0, 
    manual_angle = 0, 
    switch2 = true, 
    skitter_counter = 1, 
    air = false, 
    switch = true, 
    spin = -175, 
    last_count = globals.tickcount, 
    pistol = {
        [1] = 1, 
        [2] = 2, 
        [3] = 3, 
        [4] = 4, 
        [5] = 32, 
        [6] = 36, 
        [7] = 63, 
        [8] = 30, 
        [9] = 61
    }, 
    run = function(v266, v267)
        -- upvalues: v7 (ref), v8 (ref), v9 (ref)
        local v268 = v266.ui.menu.aa.mode:get();
        local v269 = nil;
        if v268 ~= "Builder" then
            if v266.ui.menu.aa.preset_list:get() == 1 then
                v269 = v266:setup_data(v7);
            elseif v266.ui.menu.aa.preset_list:get() == 2 then
                v269 = v266:setup_data(v8);
            elseif v266.ui.menu.aa.preset_list:get() == 3 then
                v269 = v266:setup_data(v9);
                v266.ref.rage.dtlag:override("always on");
            end;
        else
            v269 = v266:setup_data(v266.ui.menu.aa.states);
            v266.ref.rage.dtlag:override(nil);
        end;
        v266:set(v267, v269);
    end, 
    get_best_side = function(_, v271)
        local v272 = entity.get_local_player();
        local v273 = v272:get_eye_position();
        local v274 = entity.get_threat();
        local v275 = render.camera_angles();
        local v276 = nil;
        if v274 then
            v276 = v274:get_origin() + vector(0, 0, 64);
            v275 = (v276 - v273):angles();
        end;
        local v277 = {
            [1] = 60, 
            [2] = 45, 
            [3] = 30, 
            [4] = -30, 
            [5] = -45, 
            [6] = -60
        };
        local v278 = {
            right = 0, 
            left = 0
        };
        for _, v280 in ipairs(v277) do
            local v281 = vector():angles(0, v275.y + 180 + v280, 0);
            if v274 then
                local v282 = v273 + v281:scaled(128);
                local v283 = utils.trace_bullet(v274, v276, v282, v272);
                v278[v280 < 0 and "left" or "right"] = v278[v280 < 0 and "left" or "right"] + v283;
            else
                return 1;
            end;
        end;
        if v278.left == v278.right then
            return 1;
        elseif v278.left > v278.right then
            return v271 and 1 or 0;
        else
            return v271 and 0 or 1;
        end;
    end, 
    setup_data = function(v284, v285)
        local v286 = v284.helpers:get_team();
        local v287 = v284.helpers:get_state();
        if type(v285) == "string" then
            local v288 = json.parse(v285);
            if v287 ~= "global" and not v288[v286][v287].enable then
                v287 = "global";
            end;
            local v289 = {};
            for v290, v291 in pairs(v288[v286][v287]) do
                v289[v290] = v291;
            end;
            return v289;
        else
            if v287 ~= "global" and not v285[v286][v287].enable:get() then
                v287 = "global";
            end;
            local v292 = {};
            for v293, v294 in pairs(v285[v286][v287]) do
                v292[v293] = v294:get();
            end;
            return v292;
        end;
    end, 
    set = function(v295, v296, v297)
        -- upvalues: v56 (ref)
        local _ = {
            [1] = 1, 
            [2] = 2, 
            [3] = 4, 
            [4] = 12
        };
        local v299 = true;
        local v300 = v295.helpers:get_state();
        if globals.choked_commands == 0 and not v297.randomize_delays and (v297.interaction_type ~= "Net_update" or globals.choked_commands == math.random(0, 1)) then
            if v295.hold_delay + 1 >= v297.hold_delay then
                if v295.hold_time >= v297.hold_time then
                    if v295.switch_delay >= v297.switch_delay then
                        v295.side = v295.side == 1 and 0 or 1;
                        v295.skitter_counter = v295.skitter_counter + 1;
                        v295.hold_delay = 0;
                        v295.hold_time = 0;
                        v295.switch_delay = 0;
                    else
                        v295.switch_delay = v295.switch_delay + 1;
                    end;
                else
                    v295.hold_time = v295.hold_time + 1;
                end;
            else
                if v295.switch_delay >= v297.switch_delay then
                    v295.side = v295.side == 1 and 0 or 1;
                    v295.skitter_counter = v295.skitter_counter + 1;
                    v295.switch_delay = 0;
                else
                    v295.switch_delay = v295.switch_delay + 1;
                end;
                v295.hold_delay = v295.hold_delay + 1;
            end;
        end;
        if globals.choked_commands == 0 and v297.randomize_delays and (v297.interaction_type ~= "Net_update" or globals.choked_commands == math.random(0, 1)) then
            if v295.hold_delay + 1 >= math.random(0, v297.hold_delay) then
                if v295.hold_time >= math.random(0, v297.hold_time) then
                    if v295.switch_delay >= math.random(0, v297.switch_delay) then
                        v295.side = v295.side == 1 and 0 or 1;
                        v295.skitter_counter = v295.skitter_counter + 1;
                        v295.hold_delay = 0;
                        v295.hold_time = 0;
                        v295.switch_delay = 0;
                    else
                        v295.switch_delay = v295.switch_delay + 1;
                    end;
                else
                    v295.hold_time = v295.hold_time + 1;
                end;
            else
                if v295.switch_delay >= math.random(0, v297.switch_delay) then
                    v295.side = v295.side == 1 and 0 or 1;
                    v295.skitter_counter = v295.skitter_counter + 1;
                    v295.switch_delay = 0;
                else
                    v295.switch_delay = v295.switch_delay + 1;
                end;
                v295.hold_delay = v295.hold_delay + 1;
            end;
        end;
        local l_side_0 = v295.side;
        if v297.jitter_random then
            l_side_0 = math.random(0, 1);
        end;
        local l_body_yaw_0 = v297.body_yaw;
        local v303 = math.random(1, 4);
        if l_body_yaw_0 == "jitter" then
            l_body_yaw_0 = "static";
        elseif l_body_yaw_0 == "random" then
            if v303 == 1 then
                l_side_0 = 1;
            elseif v303 == 2 then
                l_side_0 = 0;
            end;
        elseif l_body_yaw_0 == "tick" then
            l_body_yaw_0 = "static";
        else
            l_side_0 = v297.body_yaw_side == "left" and 1 or v297.body_yaw_side == "right" and 0 or v295:get_best_side();
        end;
        local v304 = 0;
        local v305 = entity.get_local_player():get_player_weapon();
        local v306 = "";
        if v305 ~= nil then
            v306 = v305:get_classname();
        end;
        if v297.yaw_jitter == "offset" then
            v295.ref.antiaim.yawmodifier:override("off");
            v295.ref.antiaim.yawmodifieramount:override(0);
            if v295.side == 1 then
                v304 = v304 + v297.yaw_jitter_add;
            end;
        elseif v297.yaw_jitter == "center" then
            v295.ref.antiaim.yawmodifier:override("off");
            v295.ref.antiaim.yawmodifieramount:override(0);
            v304 = v304 + (v295.side == 1 and v297.yaw_jitter_add / 2 or -v297.yaw_jitter_add / 2);
        elseif v297.yaw_jitter == "random" then
            v295.ref.antiaim.yawmodifier:override("off");
            v295.ref.antiaim.yawmodifieramount:override(0);
            local v307 = math.random(0, v297.yaw_jitter_add) - v297.yaw_jitter_add / 1.5;
            if not v299 then
                v304 = v304 + v307;
                v295.last_rand = v307;
            else
                v304 = v304 + v295.last_rand;
            end;
        elseif v297.yaw_jitter == "sanya" then
            v295.ref.antiaim.yawmodifier:override(v295.counter2 % 10 == 0 and "Random" or "3-way");
            v295.ref.antiaim.yawmodifieramount:override(v297.yaw_jitter_add / 2);
            v304 = v304 + (v295.side == 1 and v297.yaw_jitter_add / 2 or -v297.yaw_jitter_add / 2);
            v295.ref.antiaim.yawmodifier:visibility(false);
        elseif v297.yaw_jitter == "3-way" then
            v295.ref.antiaim.yawmodifier:override("3-way");
            v295.ref.antiaim.yawmodifieramount:override(v297.yaw_jitter_add);
        elseif v297.yaw_jitter == "5-way" then
            v295.ref.antiaim.yawmodifier:override("5-way");
            v295.ref.antiaim.yawmodifieramount:override(v297.yaw_jitter_add);
        else
            v295.ref.antiaim.yawmodifier:visibility(true);
            v295.ref.antiaim.yawmodifier:override("off");
            v295.ref.antiaim.yawmodifieramount:override(0);
        end;
        local _ = v297.yaw_add - 5;
        local _ = v297.yaw_add + 5;
        local _ = v297.yaw_add_r - 5;
        local _ = v297.yaw_add_r + 5;
        if v297.kikapcs and v295.ref.rage.dt:get() and not v295.ref.rage.fd:get() then
            if globals.choked_commands == 0 then
                v295.ref.rage.fakelag_enabled:override(false);
            end;
        else
            v295.ref.rage.fakelag_enabled:override(true);
        end;
        if v297.fluctuatefakelag and not v295.ref.rage.fd:get() then
            if globals.choked_commands == 0 then
                v295.counter3 = v295.counter3 + 1;
                v295.ref.rage.fakelag:set(v295.counter3 % 5 == 0 and 1 or 14);
            end;
        else
            v295.ref.rage.fakelag:set(14);
        end;
        if v297.fluctuate and globals.choked_commands == 0 then
            v295.counter = (v295.counter or 0) + 1;
            v295.random_fluctuation = math.random(0, v297.fluctuate_value);
            if v295.counter % 4 == 0 then
                v295.random_fluctuation = v295.random_fluctuation * -1;
            end;
        end;
        if globals.choked_commands == 0 then
            v295.counter2 = v295.counter2 + 1;
        end;
        v304 = v304 + (l_side_0 == 0 and v297.yaw_add or l_side_0 == 1 and v297.yaw_add_r or 0) + v295.random_fluctuation;
        local v312 = entity.get_threat();
        if entity.get_threat(true) ~= nil then
            v295.peeked = globals.tickcount + 20;
            v295.peeked2 = globals.tickcount + 5;
        end;
        local _ = 0;
        local _ = 0;
        local _ = 0;
        if v295.spin <= 170 then
            v295.spin = v295.spin + math.random(20, 94);
        else
            v295.spin = -175;
        end;
        if v312 ~= nil then
            local v316 = entity.get_local_player():get_origin();
            local v317 = v312:get_origin();
            if math.abs(v317.x - v316.x) > 350 then
                v295.safe = true;
            else
                v295.safe = false;
            end;
        end;
        v295.ref.antiaim.enable:override(true);
        v295.ref.antiaim.pitch:override("down");
        v295.ref.antiaim.yawtarget:override(v297.yaw_base and "At Target" or "Local view");
        v295.ref.antiaim.yaw:override("Backward");
        v295.ref.antiaim.yawoffset:override(v295.helpers:normalize(v304));
        v295.ref.antiaim.inverter:override(l_side_0 == 0);
        local l_fakelimit_0 = v297.fakelimit;
        if v297.body_yaw == "tick" then
            local v319 = math.random(1, 8);
            if globals.tickcount % v297.tickspeed == 0 then
                v295.body_yaw_switch = not v295.body_yaw_switch;
                v295.body_yaw_false_ticks = 0;
            end;
            if not v295.body_yaw_switch then
                v295.body_yaw_false_ticks = v295.body_yaw_false_ticks + 1;
            end;
            if v295.body_yaw_switch then
                v295.inverter_override_ticks = v295.inverter_override_ticks + 1;
            end;
            if v295.body_yaw_false_ticks >= math.random(2, 5) then
                v295.body_yaw_switch = true;
                v295.body_yaw_false_ticks = 0;
            end;
            v319 = (not (v319 ~= 1) or v319 == 2) and 9 or v319 + 1;
            if v295.body_yaw_switch and v295.inverter_override_ticks < math.random(5, 9) and v295.inverter_override_ticks > 4 then
                v295.ref.antiaim.inverter:override(v296.command_number % v319 == 0);
                v295.inverter_override_ticks = 0;
            end;
            l_fakelimit_0 = math.random(47, 60);
            v295.ref.antiaim.bodyyaw:override(v295.body_yaw_switch);
        else
            v295.ref.antiaim.bodyyaw:override(true);
        end;
        v295.ref.antiaim.bodyyawopt:override({});
        v295.ref.antiaim.leftfake:override(l_fakelimit_0);
        v295.ref.antiaim.rightfake:override(l_fakelimit_0);
        if v295.helpers:contains(v297.options, "defensive yaw") and (not v295.helpers:contains(v297.options, "e spam (safe)") or not v295.safe) then
            rage.antiaim:override_hidden_pitch(math.random(0, 1) == 1 and -89 or -10);
        end;
        if v295.helpers:contains(v297.options, "defensive yaw") or v295.helpers:contains(v297.options, "e spam") and v295.peeked > globals.tickcount or v295.helpers:contains(v297.options, "e spam (safe)") and defensive and v295.safe then
            v295.ref.antiaim.hidden:override(true);
        else
            v295.ref.antiaim.hidden:override(false);
        end;
        if v295.helpers:contains(v297.options, "e spam") and v295.peeked > globals.tickcount or v295.helpers:contains(v297.options, "e spam (safe)") and v295.defensive.defensive > 8 and v295.safe then
            rage.antiaim:override_hidden_pitch(0);
            local l_antiaim_0 = rage.antiaim;
            local l_l_antiaim_0_0 = l_antiaim_0;
            l_antiaim_0 = l_antiaim_0.override_hidden_yaw_offset;
            local v322;
            if math.random(0, 2) == 1 then
                v322 = math.random(0, 1) == 1 and -165 or -179;
            else
                v322 = math.random(0, 1) == 1 and 165 or 179;
            end;
            l_antiaim_0(l_l_antiaim_0_0, v322);
        end;
        if globals.choked_commands == 0 and v295.counter2 % 2 == 0 then
            v295.exploitswitch = not v295.exploitswitch;
        end;
        if entity.get_game_rules().m_bFreezePeriod and v295.ref.rage.fd:get() and v295.ui.menu.misc.freezetime_fd:get() then
            if v295.ref.rage.dt:get() then
                v295.ref.rage.dt:override(false);
            else
                v295.ref.rage.dt:override();
            end;
            if v295.ref.rage.hs:get() then
                v295.ref.rage.hs:override(false);
            else
                v295.ref.rage.hs:override();
            end;
            if globals.choked_commands >= 7 then
                v296.send_packet = false;
                v296.in_duck = true;
            else
                v296.send_packet = false;
                v296.in_duck = false;
            end;
        else
            v295.ref.rage.hs:override();
            v295.ref.rage.dt:override();
        end;
        if v295.counter4 % 2 == 0 then
            v295.exploitswitch3 = not v295.exploitswitch3;
        end;
        local l_m_flNextAttack_0 = entity.get_local_player().m_flNextAttack;
        local v324 = entity.get_local_player():get_player_weapon();
        local v325 = entity.get_threat();
        local v326 = entity.get_local_player():get_origin() or {};
        local v327 = false;
        if v325 ~= nil and v325:get_origin().z - v326.z < -60 then
            v327 = true;
        end;
        local l_m_flNextPrimaryAttack_0 = v324.m_flNextPrimaryAttack;
        if v296.choked_commands == 0 then
            v295.defensive_switch = not v295.defensive_switch;
            v295.skitter_switch_delay = v295.skitter_switch_delay + 1;
            if v295.skitter_switch_delay >= math.random(1, 8) then
                v295.skitter_switch_delay = 0;
                v295.skitter_side = v295.skitter_side == 1 and 0 or 1;
            end;
        end;
        if v297.yaw_jitter == "torpedo" and v324:get_name() ~= "R8 Revolver" and (not v295.helpers:contains(v297.options, "safe head (hg)") or not v327) then
            local l_yawspeed_0 = v297.yawspeed;
            local v330 = math.random(-4, 3);
            if v297.yawspeed_randomization then
                l_yawspeed_0 = math.random(v297.yawspeed, v297.yawspeed2);
            end;
            local v331 = v295.ref.rage.dt:get() and math.max(l_m_flNextPrimaryAttack_0, l_m_flNextAttack_0) <= globals.curtime or v295.ref.rage.hs:get();
            if v295.counter4 % l_yawspeed_0 == 0 or v297.faszsag_dis and not v331 then
                if v297.faszsag_defensive then
                    if v297.tickbase == 2 and v295.ref.rage.dt:get() then
                        v295.ref.rage.dtlag:override("always on");
                        rage.exploit:allow_defensive(globals.tickcount % math.random(v297.choke1, v297.choke2) == 0);
                    else
                        v295.ref.rage.dtlag:override("on peek");
                    end;
                end;
                rage.exploit:allow_defensive(true);
                v295.ref.antiaim.hidden:override(false);
                v295.ref.antiaim.yawoffset:override(v330);
                v295.ref.antiaim.yawmodifier:override("disabled");
                v295.ref.antiaim.yawmodifieramount:override(0);
                v295.ref.antiaim.leftfake:override(v297.faszsagfakeyaw);
                v295.ref.antiaim.rightfake:override(v297.faszsagfakeyaw_r);
                v295.ref.antiaim.inverter:override(false);
            else
                if v295.counter4 % (v297.yawspeed - math.random(-1, 1)) == 0 then
                    v295.exploitswitch2 = not v295.exploitswitch2;
                end;
                local v332 = v295.exploitswitch2 and v297.yaw_add_r or v297.yaw_add;
                local v333 = v295.skitter_side and v332 - v330 or v332;
                local v334 = nil;
                local v335 = nil;
                if v297.faszsag_randomize_fakelimit then
                    v334 = math.random(3, v297.faszsagfakeyaw);
                    v335 = math.random(3, v297.faszsagfakeyaw_r);
                else
                    v334 = v297.faszsagfakeyaw;
                    v335 = v297.faszsagfakeyaw_r;
                end;
                if v297.faszsag_antibrute then
                    v295.notifyenable = true;
                    for v336, v337 in next, v56.ab.should_swap do
                        if v337 and v56.ab.time[v336] - globals.curtime >= 0 then
                            local v338 = v295.exploitswitch2 and v297.yaw_add_r or v297.yaw_add;
                            v333 = (v295.exploitswitch3 and v338 - v330 or v338) + v56.ab.jitteralgo[v336];
                            v334 = v297.faszsagfakeyaw + v56.ab.jitteralgo[v336];
                            v335 = v297.faszsagfakeyaw - v56.ab.jitteralgo[v336];
                            break;
                        end;
                    end;
                else
                    v295.notifyenable = false;
                end;
                rage.exploit:allow_defensive(false);
                v295.ref.antiaim.hidden:override(false);
                v295.ref.antiaim.yawoffset:override(v333);
                v295.ref.antiaim.yawmodifier:override("disabled");
                v295.ref.antiaim.yawmodifieramount:override(0);
                v295.ref.antiaim.leftfake:override(math.abs(v334));
                v295.ref.antiaim.rightfake:override(math.abs(v335));
                v295.ref.antiaim.inverter:override(v295.exploitswitch2);
                if v295.ref.rage.fd:get() then
                    rage.exploit:allow_defensive(false);
                    v295.ref.antiaim.hidden:override(false);
                    v295.ref.antiaim.yawoffset:override(0);
                    v295.ref.antiaim.yawmodifier:override("disabled");
                    v295.ref.antiaim.yawmodifieramount:override(0);
                    v295.ref.antiaim.leftfake:override(v297.faszsagfakeyaw);
                    v295.ref.antiaim.rightfake:override(v297.faszsagfakeyaw_r);
                    v295.ref.antiaim.inverter:override(v295.exploitswitch2);
                end;
            end;
        end;
        if v297.faszsag and v324:get_name() ~= "R8 Revolver" and not v295.ref.rage.fd:get() and v295.ui.menu.aa.manual_aa:get() == "Off" and (v295.ref.rage.dt:get() and math.max(l_m_flNextPrimaryAttack_0, l_m_flNextAttack_0) <= globals.curtime or v295.ref.rage.hs:get() and (not v295.helpers:contains(v297.options, "safe head (hg)") or not v327)) then
            if v295.counter2 % v297.faszsag_speed == 0 then
                v295.ref.rage.dtlag:override("always on");
                rage.exploit:allow_defensive(true);
                v295.ref.antiaim.hidden:override(false);
                v295.ref.antiaim.yawoffset:override(0);
                v295.ref.antiaim.yawmodifier:override("disabled");
                v295.ref.antiaim.yawmodifieramount:override(0);
                v295.ref.antiaim.leftfake:override(59);
                v295.ref.antiaim.rightfake:override(59);
                v295.ref.antiaim.inverter:override(false);
                v295.ref.antiaim.pitch:override("down");
            else
                v295.ref.rage.dtlag:override(nil);
                rage.exploit:allow_defensive(false);
                v295.ref.antiaim.hidden:override(false);
                if v297.faszsag_yaw == "jitter" then
                    v295.ref.antiaim.yawoffset:override(v295.exploitswitch and v297.faszsag_yawvalue_1 or v297.faszsag_yawvalue_2);
                    v295.ref.antiaim.inverter:override(v295.exploitswitch);
                elseif v297.faszsag_yaw == "spin" then
                    local v339 = globals.tickcount * 2 ^ v297.faszsag_spinspeed % 360;
                    if v339 > 170 and v339 < 190 then
                        v339 = 200;
                    end;
                    v295.ref.antiaim.yawoffset:override(v339);
                    v295.ref.antiaim.inverter:override(false);
                elseif v297.faszsag_yaw == "sway" then
                    v295.ref.antiaim.yawoffset:override(30 + globals.tickcount * 4 % v297.faszsag_yawvalue_1);
                else
                    v295.ref.antiaim.yawoffset:override(v297.faszsag_yawvalue_1);
                    v295.ref.antiaim.inverter:override(false);
                end;
                v295.ref.antiaim.pitch:override(v297.faszsag_pitch);
                v295.ref.antiaim.yawmodifier:override("disabled");
                v295.ref.antiaim.yawmodifieramount:override(0);
                v295.ref.antiaim.leftfake:override(v297.faszsag_fakelimit_l);
                v295.ref.antiaim.rightfake:override(v297.faszsag_fakelimit_r);
            end;
        end;
        if globals.choked_commands == 0 then
            v295.counter4 = v295.counter4 + 1;
            v295.exploitswitch2 = not v295.exploitswitch2;
        end;
        if v295.helpers:contains(v297.options, "safe head") and (v306 == "CKnife" or v306 == "CWeaponTaser") then
            v295.ref.antiaim.yawoffset:override(5);
            v295.ref.antiaim.yawmodifier:override("Offset");
            v295.ref.antiaim.yawmodifieramount:override(0);
            v295.ref.antiaim.leftfake:override(0);
            v295.ref.antiaim.rightfake:override(0);
            v295.ref.antiaim.inverter:override(false);
            v295.ref.antiaim.hidden:override(false);
        end;
        if v297.yaw_jitter == "torpedo" and v324:get_name() == "R8 Revolver" then
            v295.ref.antiaim.yawoffset:override(5);
            v295.ref.antiaim.yawmodifier:override("Offset");
            v295.ref.antiaim.yawmodifieramount:override(35);
            v295.ref.antiaim.leftfake:override(30);
            v295.ref.antiaim.rightfake:override(30);
            v295.ref.antiaim.inverter:override(false);
            v295.ref.antiaim.hidden:override(false);
        end;
        if v295.ui.menu.aa.manual_aa:get() == "Left" then
            v295.ref.antiaim.yawoffset:override(-90);
            v295.ref.antiaim.freestanding:override(false);
            v295.ref.antiaim.yawtarget:override("Local view");
        elseif v295.ui.menu.aa.manual_aa:get() == "Right" then
            v295.ref.antiaim.yawoffset:override(90);
            v295.ref.antiaim.freestanding:override(false);
            v295.ref.antiaim.yawtarget:override("Local view");
        elseif v295.ui.menu.aa.manual_aa:get() == "Forward" then
            v295.ref.antiaim.yawoffset:override(180);
            v295.ref.antiaim.freestanding:override(false);
            v295.ref.antiaim.yawtarget:override("Local view");
        elseif v295.ui.menu.aa.freestanding:get() and not v295.helpers:contains(v295.ui.menu.aa.freestanding_disablers:get(), v300) then
            v295.ref.antiaim.freestanding:override(true);
        else
            v295.ref.antiaim.freestanding:override(false);
        end;
        local v340 = entity.get_local_player():get_player_weapon():get_weapon_index();
        if v295.ui.menu.aa.autoos:get() and v295.helpers:contains(v295.ui.menu.aa.autoos_states:get(), v300) and not v295.ref.rage.fd:get() then
            local v341 = false;
            for _, v343 in next, v295.pistol do
                if v340 == v343 then
                    v295.ref.rage.hs:override(true);
                    v295.ref.rage.hs2:override("Favor fire rate");
                    v341 = true;
                    break;
                end;
            end;
            if not v341 then
                v295.ref.rage.hs:override();
                v295.ref.rage.hs2:override();
            end;
        else
            v295.ref.rage.hs:override();
            v295.ref.rage.hs2:override();
        end;
        if v295.helpers:contains(v295.ui.menu.aa.troll_aa:get(), "Warmup") then
            local v344 = entity.get_game_rules();
            if v344 == nil then
                return;
            elseif v344.m_bWarmupPeriod then
                v295.ref.antiaim.pitch:override("Disabled");
                v295.ref.antiaim.yawoffset:override(globals.tickcount * 16 % 360);
                v295.ref.antiaim.leftfake:override(0);
                v295.ref.antiaim.rightfake:override(0);
            end;
        end;
        if v295.helpers:contains(v295.ui.menu.aa.troll_aa:get(), "Round end") and v295.round_ended and not entity.get_threat(true) then
            v295.ref.antiaim.pitch:override("Disabled");
            v295.ref.antiaim.yawoffset:override(globals.tickcount * 16 % 360);
            v295.ref.antiaim.leftfake:override(0);
            v295.ref.antiaim.rightfake:override(0);
        end;
        if v297.tickbase == 2 and v295.helpers:contains(v297.options, "force defensive") and v295.ref.rage.dt:get() then
            v295.ref.rage.dtlag:override("on peek");
            rage.exploit:allow_defensive(globals.tickcount % math.random(v297.choke1, v297.choke2) == 0);
        elseif v295.helpers:contains(v297.options, "force defensive") and v297.tickbase == 1 then
            v295.ref.rage.dtlag:override("always on");
        end;
        if v295.ui.menu.misc.nadefix:get() and v306.find(v306, "Grenade") then
            v295.ref.rage.dtlag:override(nil);
        end;
        v295.air = v296.in_jump;
        v295.last_count = globals.tickcount;
        v295.last_angle = v295.ref.antiaim.yawoffset:get();
    end
}):struct("uselessshit")({
    GRENADE_SECONDARY_DAMPENING = 0.3, 
    lerp = function(v345, v346, v347)
        return v345 + v347 * (v346 - v345);
    end, 
    aspectratioviewmodel = function(v348)
        cvar.sv_competitive_minspec:int(0);
        cvar.viewmodel_fov:float(v348.ui.menu.misc.viewmodel_fov:get() * 0.1);
        cvar.viewmodel_offset_x:float(v348.ui.menu.misc.viewmodel_x:get() * 0.1);
        cvar.viewmodel_offset_y:float(v348.ui.menu.misc.viewmodel_y:get() * 0.1);
        cvar.viewmodel_offset_z:float(v348.ui.menu.misc.viewmodel_z:get() * 0.1);
        cvar.r_aspectratio:float(v348.ui.menu.misc.aspectratio:get() * 0.01);
    end, 
    fastladder = function(v349, v350)
        if entity.get_local_player().m_MoveType == 9 and common.is_button_down(87) and v349.ui.menu.misc.fastladder:get() then
            v350.view_angles.y = math.floor(v350.view_angles.y + 0.5);
            v350.roll = 0;
            if v350.view_angles.x < 45 then
                v350.view_angles.x = 89;
                v350.in_moveright = 1;
                v350.in_moveleft = 0;
                v350.in_forward = 0;
                v350.in_back = 1;
                if v350.sidemove == 0 then
                    v350.view_angles.y = v350.view_angles.y + 90;
                elseif v350.sidemove < 0 then
                    v350.view_angles.y = v350.view_angles.y + 150;
                elseif v350.sidemove > 0 then
                    v350.view_angles.y = v350.view_angles.y + 30;
                end;
            end;
        end;
    end, 
    trace_fall = function(_, v352, v353)
        -- upvalues: v19 (ref), v20 (ref)
        if entity.get_local_player() ~= nil then
            local v354 = entity.get_local_player():get_origin();
            for v355 = 0, v19, v20 do
                local v356 = math.sin(v355);
                local v357 = math.cos(v355);
                local v358 = v354.x + v357 * 10;
                local v359 = v354.y + v356 * 10;
                local v360 = vector(v358, v359, v354.z);
                local v361 = v360:clone();
                v361.z = v361.z - v353;
                if utils.trace_line(v360, v361, v352).fraction ~= 1 then
                    return true;
                end;
            end;
        end;
        return false;
    end, 
    no_fall_damage = function(v362, v363)
        -- upvalues: v18 (ref)
        local v364 = entity.get_local_player();
        if v362.ui.menu.misc.no_fall_damage:get() then
            if v364 == nil then
                return;
            elseif v364.m_vecVelocity.z >= -500 then
                v18 = false;
                return;
            else
                if v362:trace_fall(v364, 15) then
                    v18 = false;
                elseif v362:trace_fall(v364, 75) then
                    v18 = true;
                end;
                v363.in_duck = v18;
            end;
        end;
    end, 
    fake_latency = function(v365, _)
        local v367 = entity.get_local_player();
        local l_sv_maxunlag_0 = cvar.sv_maxunlag;
        local l_ping_0 = v365.ref.rage.ping;
        if v365.ui.menu.misc.extended_ping:get() then
            if v367 == nil then
                return;
            else
                l_ping_0:override((v365.ui.menu.misc.extended_ping_amount:get()));
                l_sv_maxunlag_0:float(0.4, true);
            end;
        else
            l_ping_0:override(nil);
            l_sv_maxunlag_0:float(tonumber(l_sv_maxunlag_0:string()), true);
        end;
    end
}):struct("defensive")({
    max_tickbase = 0, 
    cmd = 0, 
    defensive = 0, 
    on_createmove = function(v370, _)
        local l_m_nTickBase_0 = entity.get_local_player().m_nTickBase;
        if math.abs(l_m_nTickBase_0 - v370.max_tickbase) > 64 then
            v370.max_tickbase = 0;
        end;
        local v373 = 0;
        if v370.max_tickbase < l_m_nTickBase_0 then
            v370.max_tickbase = l_m_nTickBase_0;
        elseif l_m_nTickBase_0 < v370.max_tickbase then
            v373 = math.min(14, math.max(0, v370.max_tickbase - l_m_nTickBase_0 - 1));
        end;
        v370.defensive = v373;
    end
}):struct("hotkeys")({
    animation_speed = 0.1, 
    target_width = 0, 
    width = 0, 
    bind_states = {}, 
    window = {
        dragging = false, 
        pos = vector(render.screen_size().x / 1.5, render.screen_size().y / 1.5), 
        size = vector(100, 22)
    }, 
    mouse = {
        down = false, 
        down_duration = 0, 
        clicked = false, 
        pos = vector(), 
        pos_prev = vector(), 
        delta = vector(), 
        clicked_pos = vector()
    }, 
    save_position = function(v374)
        local v375 = {
            x = v374.window.pos.x, 
            y = v374.window.pos.y
        };
        files.write("keybinds_pos.txt", json.stringify(v375));
    end, 
    load_position = function(v376)
        local v377 = files.read("keybinds_pos.txt");
        if v377 then
            local v378 = json.parse(v377);
            if v378 and v378.x and v378.y then
                v376.window.pos = vector(v378.x, v378.y);
            end;
        end;
    end, 
    animate_bind = function(v379, v380, v381)
        v379.bind_states[v380] = v379.bind_states[v380] or {
            height = 0, 
            alpha = 0
        };
        local v382 = v379.bind_states[v380];
        if v381 then
            v382.height = v382.height + v379.animation_speed * (15 - v382.height);
            v382.alpha = v382.alpha + v379.animation_speed * (255 - v382.alpha);
        else
            v382.height = v382.height - v379.animation_speed * v382.height;
            v382.alpha = v382.alpha - v379.animation_speed * v382.alpha;
            if v382.height < 0.1 and v382.alpha < 0.1 then
                v379.bind_states[v380] = nil;
                return nil;
            end;
        end;
        return v382;
    end, 
    animate_width = function(v383)
        if v383.target_width > v383.width then
            v383.width = v383.width + v383.animation_speed * (v383.target_width - v383.width);
        else
            v383.width = v383.width - v383.animation_speed * (v383.width - v383.target_width);
        end;
        return v383.width;
    end, 
    update_mouse = function(v384)
        local l_frametime_0 = globals.frametime;
        local v386 = ui.get_mouse_position();
        local v387 = common.is_button_down(1);
        v384.mouse.pos_prev = v384.mouse.pos;
        v384.mouse.pos = v386;
        v384.mouse.delta = v384.mouse.pos - v384.mouse.pos_prev;
        v384.mouse.down = v387;
        v384.mouse.clicked = v387 and v384.mouse.down_duration < 0;
        local l_mouse_0 = v384.mouse;
        local v389;
        if v387 then
            if v384.mouse.down_duration < 0 then
                v389 = 0;
                goto label0 --[[  true, true  ]];
            else
                v389 = v384.mouse.down_duration + l_frametime_0;
                if v389 then
                    goto label0;
                end;
            end;
        end;
        v389 = -1;
        ::label0::;
        l_mouse_0.down_duration = v389;
        if v384.mouse.clicked then
            v384.mouse.clicked_pos = v384.mouse.pos;
        end;
    end, 
    update_dragging = function(v390)
        local v391 = v390.mouse.pos.x >= v390.window.pos.x and v390.mouse.pos.x <= v390.window.pos.x + v390.window.size.x and v390.mouse.pos.y >= v390.window.pos.y and v390.mouse.pos.y <= v390.window.pos.y + v390.window.size.y;
        if v390.mouse.clicked and v391 then
            v390.window.dragging = true;
            v390.window.drag_offset = v390.mouse.pos - v390.window.pos;
        end;
        if v390.mouse.down and v390.window.dragging then
            v390.window.pos = v390.mouse.pos - v390.window.drag_offset;
            local v392 = render.screen_size();
            v390.window.pos.x = math.clamp(v390.window.pos.x, 0, v392.x - v390.window.size.x);
            v390.window.pos.y = math.clamp(v390.window.pos.y, 0, v392.y - v390.window.size.y);
        end;
        if not v390.mouse.down and v390.window.dragging then
            v390.window.dragging = false;
            v390:save_position();
        end;
    end, 
    render_hotkeys = function(v393)
        -- upvalues: v58 (ref)
        if v393.ui.menu.vis.windows:get() then
            local v394 = entity.get_local_player();
            if not v394 or not v394:is_alive() then
                return;
            else
                local v395 = ui.get_binds();
                local v396 = ui.get_alpha() > 0;
                v393.target_width = (not not v396 or #v395 > 0) and 100 or 0;
                local v397 = v393:animate_width();
                if v397 < 0.1 and not v396 then
                    return;
                else
                    if ui.get_alpha() > 0 then
                        v393:update_mouse();
                        v393:update_dragging();
                    end;
                    local v398 = v393.window.dragging and 1 or 1;
                    local v399 = 255 * (v397 / 100) * v398;
                    render.rect(vector(v393.window.pos.x - 3, v393.window.pos.y - 5), vector(v393.window.pos.x + v397 + 3, v393.window.pos.y + 23), color(30, 30, 30, v399), 5, true);
                    render.rect(vector(v393.window.pos.x - 2, v393.window.pos.y - 4), vector(v393.window.pos.x + v397 + 2, v393.window.pos.y + 22), color(10, 10, 10, v399), 5, true);
                    render.rect(vector(v393.window.pos.x - 1, v393.window.pos.y - 3), vector(v393.window.pos.x + v397 + 1, v393.window.pos.y + 21), color(30, 30, 30, v399), 5, true);
                    render.rect(vector(v393.window.pos.x - 1, v393.window.pos.y - 3), vector(v393.window.pos.x + v397 + 1, v393.window.pos.y + 4), color(v393.ui.menu.vis.hotkey_edge_color:get_color().r, v393.ui.menu.vis.hotkey_edge_color:get_color().g, v393.ui.menu.vis.hotkey_edge_color:get_color().b, v393.ui.menu.vis.hotkey_edge_color:get_color().a * (v397 / 100) * v398), 5, true);
                    render.rect(vector(v393.window.pos.x, v393.window.pos.y - 2), vector(v393.window.pos.x + v397, v393.window.pos.y + 20), color(v393.ui.menu.vis.hotkey_background_color:get_color().r, v393.ui.menu.vis.hotkey_background_color:get_color().g, v393.ui.menu.vis.hotkey_background_color:get_color().b, v399), 5, true);
                    render.text(v58, vector(v393.window.pos.x + v397 / 2, v393.window.pos.y + 10), color(255, 255, 255, v399), "c", "\a" .. v393.ui.menu.vis.hotkey_edge_color:get_color():to_hex() .. ui.get_icon("keyboard") .. "\a0a0aaff | \acfcfcfffHotkeys");
                    local v400 = {};
                    for _, v402 in ipairs(v395) do
                        v400[tostring(v402)] = true;
                    end;
                    local v403 = v393.window.pos.y + 27;
                    local v404 = 0;
                    for v405, _ in pairs(v393.bind_states) do
                        local v407 = v393:animate_bind(v405, v400[v405]);
                        if v407 then
                            local v408 = v403 + v404;
                            local v409 = string.match(v405, "bind%((.-)%)") or v405;
                            local v410 = render.measure_text(v58, "l", v409);
                            local v411 = render.measure_text(v58, "r", ui.get_icon("toggle-on"));
                            local v412 = math.min(v407.alpha, v399);
                            render.rect(vector(v393.window.pos.x, v408), vector(v393.window.pos.x + v410.x + 10, v408 + v407.height), color(5, 5, 5, 105 * (v412 / 255)), 5, true);
                            render.text(v58, vector(v393.window.pos.x + 5, v408), color(v393.ui.menu.vis.hotkey_text_color:get_color().r, v393.ui.menu.vis.hotkey_text_color:get_color().g, v393.ui.menu.vis.hotkey_text_color:get_color().b, v412), "l", v409);
                            render.rect(vector(v393.window.pos.x + v397 - 19, v408 - 1), vector(v393.window.pos.x + v397 - 19 + v411.x + 5, v408 + v407.height), color(5, 5, 5, 105 * (v412 / 255)), 5, true);
                            render.text(v58, vector(v393.window.pos.x + v397 - 2, v408), color(v393.ui.menu.vis.hotkey_text_color:get_color().r, v393.ui.menu.vis.hotkey_text_color:get_color().g, v393.ui.menu.vis.hotkey_text_color:get_color().b, v412), "r", ui.get_icon("toggle-on"));
                            v404 = v404 + v407.height + 5;
                        end;
                    end;
                    for _, v414 in ipairs(v395) do
                        local v415 = tostring(v414);
                        if not v393.bind_states[v415] then
                            v393.bind_states[v415] = {
                                height = 0, 
                                alpha = 0
                            };
                        end;
                    end;
                end;
            end;
        end;
    end
}):struct("visuals")({
    scoped = 0, 
    delta = 0, 
    max_delta = 0, 
    fraction = 0, 
    weapon_fraction = 0, 
    ap_fraction = 0, 
    scoped_fraction = 0, 
    hide_fraction = 0, 
    inactive_fraction = 0, 
    active_fraction = 0, 
    alpha_smoother = l_smoothy_0.new(0), 
    windows = {
        mouse = {
            down = false, 
            down_duration = 0, 
            clicked = false, 
            pos = vector(), 
            pos_prev = vector(), 
            delta = vector(), 
            clicked_pos = vector()
        }, 
        damage_window = {
            alpha = 0, 
            dragging = false, 
            pos = vector(render.screen_size().x / 2 + 30, render.screen_size().y / 2 - 40), 
            size = vector(), 
            padding = vector(4, 4)
        }
    }, 
    update_mouse = function(v416)
        local l_frametime_1 = globals.frametime;
        local v418 = ui.get_mouse_position();
        local v419 = common.is_button_down(1);
        local l_mouse_1 = v416.windows.mouse;
        l_mouse_1.pos_prev = l_mouse_1.pos;
        l_mouse_1.pos = v418;
        l_mouse_1.delta = l_mouse_1.pos - l_mouse_1.pos_prev;
        l_mouse_1.down = v419;
        l_mouse_1.clicked = v419 and l_mouse_1.down_duration < 0;
        local v421;
        if v419 then
            if l_mouse_1.down_duration < 0 then
                v421 = 0;
                goto label1 --[[  true, true  ]];
            else
                v421 = l_mouse_1.down_duration + l_frametime_1;
                if v421 then
                    goto label1;
                end;
            end;
        end;
        v421 = -1;
        ::label1::;
        l_mouse_1.down_duration = v421;
        if l_mouse_1.clicked then
            l_mouse_1.clicked_pos = l_mouse_1.pos;
        end;
    end, 
    update_dragging = function(v422)
        local l_damage_window_0 = v422.windows.damage_window;
        local l_mouse_2 = v422.windows.mouse;
        v422:update_mouse();
        if ui.get_alpha() > 0 then
            local v425 = l_mouse_2.pos.x >= l_damage_window_0.pos.x and l_mouse_2.pos.x <= l_damage_window_0.pos.x + l_damage_window_0.size.x and l_mouse_2.pos.y >= l_damage_window_0.pos.y and l_mouse_2.pos.y <= l_damage_window_0.pos.y + l_damage_window_0.size.y;
            if l_mouse_2.clicked and v425 then
                l_damage_window_0.dragging = true;
                v422.drag_offset = l_mouse_2.pos - l_damage_window_0.pos;
            end;
            if l_mouse_2.down and l_damage_window_0.dragging then
                l_damage_window_0.pos = l_mouse_2.pos - v422.drag_offset;
                local v426 = render.screen_size();
                l_damage_window_0.pos.x = math.clamp(l_damage_window_0.pos.x, 0, v426.x - l_damage_window_0.size.x);
                l_damage_window_0.pos.y = math.clamp(l_damage_window_0.pos.y, 0, v426.y - l_damage_window_0.size.y);
            end;
            if not l_mouse_2.down then
                l_damage_window_0.dragging = false;
            end;
        end;
        if not l_damage_window_0.dragging then
            v422:save_damage_window_position();
        end;
    end, 
    render_damage_indicator = function(v427)
        -- upvalues: v57 (ref)
        local v428 = entity.get_local_player();
        if not v428 or not v428:is_alive() then
            return;
        elseif not v427.ui.menu.vis.dmgindicator:get() then
            return;
        else
            local l_v57_0 = v57;
            local v430 = l_v57_0 == "Small" and 2 or l_v57_0 == "Bold" and 4 or 1;
            local v431 = tostring(v427.ref.rage.dmg:get());
            local v432 = render.measure_text(v430, "s", v431) + v427.windows.damage_window.padding * 2 + vector(1, 0);
            v427.windows.damage_window.size = v432;
            v427:update_dragging();
            local v433;
            if ui.get_alpha() > 0 then
                v433 = v427.windows.damage_window.dragging and 0.5 or 1;
            else
                v433 = 0;
            end;
            v427.windows.damage_window.alpha = utility_lerp(v427.windows.damage_window.alpha, v433, 0.05);
            local l_pos_0 = v427.windows.damage_window.pos;
            local v435 = l_pos_0 + v432 * 0.5 + vector(1, 0);
            local v436 = color(200, 200, 200, 228 * v427.windows.damage_window.alpha);
            render.rect_outline(l_pos_0, l_pos_0 + v432, v436, 1, 4);
            local v437 = color(200, 200, 200, 228);
            render.text(v430, v435, v437, "cs", v431);
            return;
        end;
    end, 
    save_damage_window_position = function(v438)
        local l_damage_window_1 = v438.windows.damage_window;
        local v440 = {
            x = l_damage_window_1.pos.x, 
            y = l_damage_window_1.pos.y
        };
        local v441 = json.stringify(v440);
        files.write("ambani_pos.txt", v441);
    end, 
    load_damage_window_position = function(v442)
        local v443 = files.read("ambani_pos.txt");
        if v443 then
            local v444 = json.parse(v443);
            if v444 and v444.x and v444.y then
                v442.windows.damage_window.pos = vector(v444.x, v444.y);
            end;
        end;
    end, 
    setup = function(v445)
        v445:load_damage_window_position();
        local v446 = files.read("ambani_pos.txt");
        if v446 == nil then
            v445.configs = {};
            return;
        else
            v445.configs = json.parse(v446);
            v445:save_damage_window_position();
            return;
        end;
    end, 
    render = function(v447)
        local v448 = entity.get_local_player();
        if not v448 or not v448:is_alive() then
            return;
        else
            local v449 = render.screen_size();
            local l_m_flNextAttack_1 = v448.m_flNextAttack;
            local l_m_flNextPrimaryAttack_1 = v448:get_player_weapon().m_flNextPrimaryAttack;
            local v452 = v447.ref.rage.dt:get();
            local v453 = math.max(l_m_flNextPrimaryAttack_1, l_m_flNextAttack_1) <= globals.curtime;
            if v447.ui.menu.vis.side_indicators:get() then
                local v454 = v447.ui.menu.vis.side_indicators_color:get_color();
                for v455, v456 in next, ui.get_binds() do
                    local v457 = string.match(tostring(v456), "bind%((.-)%)") or v456;
                    if v457:upper() == "DOUBLE TAP" then
                        if v453 then
                            render_custom_square(v449, v454, "DT", v455);
                        else
                            render_custom_square(v449, color(140, 31, 31, 255), "DT", v455);
                        end;
                    elseif v457:upper() == "HIDE SHOTS" then
                        render_custom_square(v449, v454, "OS", v455);
                    elseif v457:upper() == "MIN. DAMAGE" then
                        render_custom_square(v449, v454, "DMG", v455);
                    elseif string.find(v457:upper(), "DORMANT AIMBOT") then
                        render_custom_square(v449, v454, "DA", v455);
                    elseif v457:upper() == "BODY AIM" then
                        render_custom_square(v449, v454, "BODY", v455);
                    elseif v457:upper() == "HIT CHANCE" then
                        render_custom_square(v449, v454, "HC", v455);
                    elseif string.find(v457:upper(), "FAKE LATENCY") or string.find(v457:upper(), "PING SPIKE") then
                        render_custom_square(v449, v454, "XT", v455);
                    elseif string.find(v457:upper(), "FREESTAND") then
                        render_custom_square(v449, v454, "FS", v455);
                    elseif v457:upper() ~= "SLOW WALK" then
                        render_custom_square(v449, v454, v457:upper(), v455);
                    end;
                end;
            end;
            local v458 = v447.helpers:get_state();
            local v459 = v447.ui.menu.vis.indicatorfont:get();
            local v460 = "";
            if v459 == "small" then
                v460 = 2;
            elseif v459 == "bold" then
                v460 = 4;
            elseif v459 == "normal" then
                v460 = 1;
            end;
            render.text(2, vector(v449.x / 2, v449.y / 2 * 1.99), ui.get_style().Button, "c", "\vAMBANI \aFFFFFFFFREBORN");
            local v461 = nil;
            if not v447.ui.menu.vis.indicators:get() then
                return;
            else
                if v448.m_bIsScoped then
                    v447.scoped = v447.helpers:clamp(v447.scoped + globals.frametime / 0.2, 0, 1);
                    v461 = v447.scoped ^ 0.5;
                else
                    v447.scoped = v447.helpers:clamp(v447.scoped - globals.frametime / 0.2, 0, 1);
                    v461 = v447.scoped ^ 2;
                end;
                local v462 = string[v460 == 2 and "upper" or "lower"];
                local l_x_0 = render.measure_text(v460, "c", v462("ambani REBORN")).x;
                render.text(v460, vector(v449.x / 2 + 2 + l_x_0 / 2 * v461, v449.y / 2 + 20), color(255, 255, 255, 255), "c", v462("ambani "), v462("\a" .. color(155, 155, 255):to_hex(), 255 * math.abs(math.cos(globals.curtime * 2))) .. v462("REBORN"));
                if v452 and v453 then
                    v447.active_fraction = v447.helpers:clamp(v447.active_fraction + globals.frametime / 0.15, 0, 1);
                else
                    v447.active_fraction = v447.helpers:clamp(v447.active_fraction - globals.frametime / 0.15, 0, 1);
                end;
                if v452 and not v453 then
                    v447.inactive_fraction = v447.helpers:clamp(v447.inactive_fraction + globals.frametime / 0.15, 0, 1);
                else
                    v447.inactive_fraction = v447.helpers:clamp(v447.inactive_fraction - globals.frametime / 0.15, 0, 1);
                end;
                if v447.ref.rage.hs:get() and not v452 then
                    v447.hide_fraction = v447.helpers:clamp(v447.hide_fraction + globals.frametime / 0.15, 0, 1);
                else
                    v447.hide_fraction = v447.helpers:clamp(v447.hide_fraction - globals.frametime / 0.15, 0, 1);
                end;
                if math.max(v447.hide_fraction, v447.inactive_fraction, v447.active_fraction) > 0 then
                    v447.fraction = v447.helpers:clamp(v447.fraction + globals.frametime / 0.2, 0, 1);
                else
                    v447.fraction = v447.helpers:clamp(v447.fraction - globals.frametime / 0.2, 0, 1);
                end;
                local l_y_0 = render.measure_text(v460, "c", v462("ambani revive")).y;
                local l_x_1 = render.measure_text(v460, "c", v462("DT ")).x;
                local l_y_1 = render.measure_text(v460, "c", v462("DT ")).y;
                local l_x_2 = render.measure_text(v460, "c", v462("READY")).x;
                local l_x_3 = render.measure_text(v460, "c", v462("DT "), v462("\a" .. color(155, 255, 155, 255 * v447.active_fraction):to_hex() .. "READY")).x;
                local v469 = vector(v449.x / 2 + (l_x_1 + l_x_2 + 2) / 2 * v461, v449.y / 2 + 14 + l_y_0);
                render.push_clip_rect(v469 - vector(l_x_3 / 2 * v447.active_fraction), v469 + vector(l_x_3 / 2 * v447.active_fraction, l_y_1));
                render.text(v460, vector(v449.x / 2 + (l_x_3 + 2) / 2 * v461, v449.y / 2 + 18 + l_y_0), color(255, 255, 255, v447.active_fraction * 255), "c", v462("DT "), v462("\a" .. color(155, 255, 155, 255 * v447.active_fraction):to_hex() .. "READY"));
                render.pop_clip_rect();
                local l_x_4 = render.measure_text(v460, "c", v462("CHARGING")).x;
                local v471 = v447.helpers:gradienttext(globals.curtime, v462("CHARGING"), 255, 100, 100, 155);
                local l_x_5 = render.measure_text(v460, "c", v462("DT "), v471).x;
                local v473 = vector(v449.x / 2 + (l_x_1 + l_x_2 + 2) / 2 * v461, v449.y / 2 + 14 + l_y_0);
                render.push_clip_rect(v473 - vector(l_x_5 / 2 * v447.inactive_fraction), v473 + vector(l_x_5 / 2 * v447.inactive_fraction, l_y_1));
                render.text(v460, vector(v449.x / 2 + (l_x_1 + l_x_4 + 2) / 2 * v461, v449.y / 2 + 18 + l_y_0), color(255, 255, 255, v447.inactive_fraction * 255), "c", v462("DT "), v471);
                render.pop_clip_rect();
                local l_x_6 = render.measure_text(v460, "c", v462("HIDE ")).x;
                local l_x_7 = render.measure_text(v460, "c", v462("ACTIVE")).x;
                local v476 = render.measure_text(v460, "c", v462("HIDE "), v462("\a" .. color(155, 155, 200, 255 * v447.hide_fraction):to_hex() .. "ACTIVE")).x + 4;
                local v477 = vector(v449.x / 2 + (l_x_1 + l_x_2 + 2) / 2 * v461, v449.y / 2 + 14 + l_y_0);
                render.push_clip_rect(v477 - vector(v476 / 2 * v447.hide_fraction), v477 + vector(v476 / 2 * v447.hide_fraction, l_y_1));
                render.text(v460, vector(v449.x / 2 + (l_x_6 + l_x_7 + 2) / 2 * v461, v449.y / 2 + 18 + l_y_0), color(255, 255, 255, v447.hide_fraction * 255), "c", v462("HIDE "), v462("\a" .. color(155, 155, 200, 255 * v447.hide_fraction):to_hex() .. "ACTIVE"));
                render.pop_clip_rect();
                local l_x_8 = render.measure_text(v460, "c", "- " .. v462(v458) .. " -").x;
                render.text(v460, vector(v449.x / 2 + (l_x_8 + 2) / 2 * v461, v449.y / 2 + 18 + (l_y_0 + (l_y_1 - 2) * v447.helpers:easeInOut(v447.fraction))), color(255, 255, 255, 255), "c", v462("- " .. v458 .. " -"));
                return;
            end;
        end;
    end, 
    scope_overlay = function(v479)
        if v479.ui.menu.vis.scope_overlay:get() then
            local v480 = v479.ui.menu.vis.scope_overlay_color:get_color();
            local v481 = entity.get_local_player();
            if not v481 or not v481:is_alive() then
                return;
            else
                local v482 = v479.alpha_smoother(0.05, v481.m_bIsScoped);
                if v482 == 0 then
                    return;
                else
                    local v483 = v479.ui.menu.vis.scope_overlay_line:get() * 5;
                    local v484 = v479.ui.menu.vis.scope_overlay_gap:get();
                    local v485 = render.screen_size();
                    local v486 = v485 * 0.5;
                    local v487 = math.floor(v483 * v485.y / 1080);
                    local v488 = math.floor(v484 * v485.y / 1080);
                    local v489 = v480:clone();
                    local v490 = v480:clone();
                    v489.a = v489.a * v482;
                    v490.a = 0;
                    if v479.ui.menu.vis.scope_overlay_rotate:get() then
                        render.push_rotation(45);
                    end;
                    render.gradient(vector(v486.x, v486.y - v488 + 1), vector(v486.x + 1, v486.y - (v487 - v488)), v489, v489, v490, v490);
                    render.gradient(vector(v486.x, v486.y + v488), vector(v486.x + 1, v486.y + (v487 - v488)), v489, v489, v490, v490);
                    render.gradient(vector(v486.x - v488 + 1, v486.y), vector(v486.x - (v487 - v488), v486.y + 1), v489, v490, v489, v490);
                    render.gradient(vector(v486.x + v488, v486.y), vector(v486.x + (v487 - v488), v486.y + 1), v489, v490, v489, v490);
                    if v479.ui.menu.vis.scope_overlay_rotate:get() then
                        render.pop_rotation();
                    end;
                end;
            end;
        end;
    end
}):struct("hitlogs")({
    hitgroup_str = {
        [0] = "generic", 
        [1] = "head", 
        [2] = "chest", 
        [3] = "stomach", 
        [4] = "left arm", 
        [5] = "right arm", 
        [6] = "left leg", 
        [7] = "right leg", 
        [8] = "neck", 
        [9] = "generic", 
        [10] = "gear"
    }, 
    main = function(v491, v492)
        local _ = entity.get_local_player();
        local v494 = entity.get(v492.target);
        local l_damage_0 = v492.damage;
        local l_wanted_damage_0 = v492.wanted_damage;
        local v497 = v491.hitgroup_str[v492.wanted_hitgroup];
        local l_hitchance_0 = v492.hitchance;
        local l_state_0 = v492.state;
        local l_backtrack_0 = v492.backtrack;
        if not v494 then
            return;
        elseif v494 == nil then
            return;
        else
            local l_m_iHealth_0 = v494.m_iHealth;
            local v502 = v491.hitgroup_str[v492.hitgroup];
            local v503 = v491.ui.menu.misc.hitlog_color:get_color():to_hex();
            if l_state_0 == nil then
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "On screen") then
                    print_dev(("\affffffff[\a" .. v503 .. "Ambani\affffffff] Registered shot at \a" .. v503 .. "%s\affffffff's \a" .. v503 .. "%s\affffffff for \a" .. v503 .. "%d\affffffff(" .. string.format("%.f", l_wanted_damage_0) .. ") damage (hp: " .. l_m_iHealth_0 .. ") (bt: \a" .. v503 .. "%s\affffffff)"):format(v494:get_name(), v502, l_damage_0, l_backtrack_0));
                end;
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "Console") then
                    print_raw(("\affffffff[\a" .. v503 .. "Ambani\affffffff] Registered shot at \a" .. v503 .. "%s\affffffff's \a" .. v503 .. "%s\affffffff for \a" .. v503 .. "%d\affffffff(" .. string.format("%.f", l_wanted_damage_0) .. ") damage (hp: " .. l_m_iHealth_0 .. ") (bt: \a" .. v503 .. "%s\affffffff)"):format(v494:get_name(), v502, l_damage_0, l_backtrack_0));
                end;
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "Notifications") then
                    ambani_insert_log(("$Ambani$ Fired shot at $%s$'s $%s$ for $%d(" .. string.format("%.f", l_wanted_damage_0) .. ")$ damage (hp: $" .. l_m_iHealth_0 .. "$) (bt: $%s$)"):format(v494:get_name(), v502, l_damage_0, l_backtrack_0), 6);
                end;
            else
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "On screen") then
                    print_dev(("\affffffff[\a" .. v503 .. "Ambani\affffffff] Missed shot in \a" .. v503 .. "%s\affffffff in the \a" .. v503 .. "%s\affffffff due to \a" .. v503 .. "%s\affffffff (hc: \a" .. v503 .. "%.f\affffffff) (damage: \a" .. v503 .. "%.f\affffffff) (bt: \a" .. v503 .. "%.f\affffffff)"):format(v494:get_name(), v497, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0));
                end;
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "Console") then
                    print_raw(("\affffffff[\a" .. v503 .. "Ambani\affffffff] Missed shot in \a" .. v503 .. "%s\affffffff in the \a" .. v503 .. "%s\affffffff due to \a" .. v503 .. "%s\affffffff (hc: \a" .. v503 .. "%.f\affffffff) (damage: \a" .. v503 .. "%.f\affffffff) (bt: \a" .. v503 .. "%.f\affffffff)"):format(v494:get_name(), v497, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0));
                end;
                if v491.helpers:contains(v491.ui.menu.misc.hitlogs:get(), "Notifications") then
                    ambani_insert_log(("$Ambani$ Missed shot in $%s$ in the $%s$ due to $%s$ (hc: $%.f$) (damage: $%.f$) (bt: $%.f$)"):format(v494:get_name(), v497, l_state_0, l_hitchance_0, l_wanted_damage_0, l_backtrack_0), 6);
                end;
            end;
            return;
        end;
    end
}):struct("animations")({
    ping_check = 0, 
    last_tickcount = globals.tickcount, 
    staticlegs = function(v504)
        -- upvalues: l_lambotruck_0 (ref)
        local v505 = entity.get_local_player();
        if v505 == nil then
            return;
        else
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Static legs") then
                v505.m_flPoseParameter[6] = 1;
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Leg fucker") then
                v505.m_flPoseParameter[0] = globals.tickcount % 4 >= 2 and 70 or 87 / (globals.tickcount % 8 >= 4 and 200 or 400);
                v504.ref.antiaim.legs:override(math.random(0, 1) == 0 and "sliding" or "default");
            else
                v504.ref.antiaim.legs:override(nil);
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Moon walk") then
                v505.m_flPoseParameter[7] = -1;
                v504.ref.antiaim.legs:override("walking");
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Body lean") then
                l_lambotruck_0.animation.overlay(v505[0], 12).m_flWeight = 1;
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Earthquake") then
                v505.m_flPoseParameter[6] = math.random(0, 10) / 10;
                v505.m_flPoseParameter[10] = math.random(0, 10) / 10;
                v505.m_flPoseParameter[9] = math.random(0, 10) / 10;
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "Goblin in air") and v504.antiaim.air then
                v505.m_flPoseParameter[16] = 100;
                v505.m_flPoseParameter[17] = 100;
            end;
            if v504.helpers:contains(v504.ui.menu.misc.animations_selector:get(), "0 Pitch on land") and v505:get_anim_state().landing then
                v505.m_flPoseParameter[12] = 0.5;
            end;
            return;
        end;
    end
}):struct("revolver_helper")({
    get_info = function(v506)
        return v506.info;
    end, 
    get_damage_info = function(v507)
        local v508 = entity.get_local_player();
        if v508 == nil then
            return nil;
        else
            local v509 = v508:get_player_weapon();
            if v509 == nil then
                return nil;
            else
                local v510 = v509:get_weapon_info();
                if v510 == nil then
                    return nil;
                elseif not v510.is_revolver then
                    return nil;
                else
                    local v511 = entity.get_threat();
                    if v511 == nil then
                        return nil;
                    else
                        local l_m_iHealth_1 = v511.m_iHealth;
                        local v513 = v508:get_eye_position();
                        local v514 = v511:get_hitbox_position(3);
                        local v515 = v507.scan:simulate_damage(v513, v514, v511, 3, v510);
                        return {
                            target = v511, 
                            damage = v515, 
                            health = l_m_iHealth_1
                        };
                    end;
                end;
            end;
        end;
    end, 
    get_line_render_pos = function(v516, v517)
        if v516.ref.rage.thirdperson:get() then
            return render.world_to_screen(v517:get_hitbox_position(3));
        else
            local v518 = render.screen_size();
            return vector(v518.x / 2, v518.y);
        end;
    end, 
    render = function(v519)
        local v520 = entity.get_local_player();
        if v520 == nil then
            return nil;
        else
            local v521 = entity.get_threat();
            if v521 == nil then
                return nil;
            else
                local l_info_0 = v519.info;
                if l_info_0 == nil then
                    return;
                elseif l_info_0.damage < l_info_0.health then
                    return;
                else
                    local v523 = "DMG";
                    local v524 = color(255, 0, 0, 255);
                    if l_info_0.damage > l_info_0.health + 1 then
                        v523 = v523 .. "+";
                        v524 = color(50, 205, 50, 255);
                    end;
                    local _ = nil;
                    local v526 = v521:get_hitbox_position(3);
                    local v527 = v519:get_line_render_pos(v520);
                    local v528 = render.world_to_screen(v526);
                    if v527 ~= nil and v528 ~= nil then
                        render.line(v527, v528, color(255, 0, 0, 255));
                    end;
                    v526 = v521:get_index();
                    v527 = v521:get_bbox();
                    if v527 ~= nil and v527.pos1 ~= nil and v527.pos2 ~= nil and v527.alpha ~= nil then
                        local v529 = 4;
                        local v530 = "";
                        local l_pos1_0 = v527.pos1;
                        local v532 = v527.pos2.x - l_pos1_0.x;
                        local v533 = vector(l_pos1_0.x + v532 / 2, l_pos1_0.y - 12);
                        if v519.ui.menu.vis.damage_helper:get() and v519.damage_helper:get_player_damage(v526) ~= nil then
                            v533.y = v533.y - 12;
                        end;
                        local v534 = render.measure_text(v529, v530, v523);
                        v533.x = v533.x - v534.x / 2;
                        v533.y = v533.y - v534.y;
                        render.text(v529, v533, v524, v530, v523);
                    end;
                    return;
                end;
            end;
        end;
    end, 
    createmove = function(v535)
        v535.info = v535:get_damage_info();
    end, 
    setup = function(v536)
        local l_revolver_helper_0 = v536.ui.menu.vis.revolver_helper;
        local function v538()
            -- upvalues: v536 (ref)
            v536:render();
        end;
        local function v539()
            -- upvalues: v536 (ref)
            v536:createmove();
        end;
        local _ = nil;
        l_revolver_helper_0:set_callback(function(v541)
            -- upvalues: v538 (ref), v539 (ref)
            local v542 = v541:get();
            events.render(v538, v542);
            events.createmove(v539, v542);
        end, true);
    end
}):struct("scan")({
    get_hitbox_damage_mult = function(_, v544)
        local _ = 0;
        local v546 = 1;
        local _ = 2;
        local v548 = 3;
        local _ = 4;
        local _ = 5;
        local v551 = 6;
        local v552 = 7;
        local _ = 10;
        if v544 == v546 then
            return 4;
        elseif v544 == v548 then
            return 1.25;
        elseif v544 == v551 then
            return 0.75;
        elseif v544 == v552 then
            return 0.75;
        else
            return 1;
        end;
    end, 
    scale_damage = function(v554, v555, v556, v557, v558)
        v556 = v556 * v554:get_hitbox_damage_mult(v557);
        if v555.m_ArmorValue > 0 then
            if v557 == HITGROUP_HEAD then
                if v555.m_bHasHelmet then
                    v556 = v556 * (v558 * 0.5);
                end;
            else
                v556 = v556 * (v558 * 0.5);
            end;
        end;
        return v556;
    end, 
    simulate_damage = function(v559, v560, v561, v562, v563, v564)
        local v565 = v561 - v560;
        local l_damage_1 = v564.damage;
        local l_armor_ratio_0 = v564.armor_ratio;
        local l_range_0 = v564.range;
        local l_range_modifier_0 = v564.range_modifier;
        local v570 = math.min(l_range_0, v565:length());
        return (v559:scale_damage(v562, l_damage_1 * math.pow(l_range_modifier_0, v570 * 0.002), v563, l_armor_ratio_0));
    end
}):struct("disable_cvars")({
    perfomance_boost = function(v571)
        if v571.ui.menu.misc.disable_cvars:get() then
            cvar.cl_disable_ragdolls:int(1, true);
            cvar.dsp_slow_cpu:int(1, true);
            cvar.mat_disable_bloom:int(1, true);
            cvar.r_drawparticles:int(1, true);
            cvar.func_break_max_pieces:int(0, true);
            cvar.mat_queue_mode:int(2, true);
            cvar.muzzleflash_light:int(0, true);
            cvar.mat_hdr_enabled:int(0, true);
            cvar.r_eyemove:int(0, true);
            cvar.r_eyegloss:int(0, true);
            cvar.fps_max:int(0, true);
        end;
    end
});
for _, v585 in ipairs({
    [1] = {
        [1] = "load", 
        [2] = function()
            -- upvalues: v572 (ref)
            v572.hotkeys:load_position();
            v572.ui:execute();
            v572.config:setup();
            v572.visuals:setup();
            v572.revolver_helper:setup();
        end
    }, 
    [2] = {
        [1] = "post_update_clientside_animation", 
        [2] = function()
            -- upvalues: v572 (ref)
            v572.animations:staticlegs();
        end
    }, 
    [3] = {
        [1] = "aim_ack", 
        [2] = function(v573)
            -- upvalues: v572 (ref)
            v572.hitlogs:main(v573);
        end
    }, 
    [4] = {
        [1] = "net_update_end", 
        [2] = function()

        end
    }, 
    [5] = {
        [1] = "round_end", 
        [2] = function()
            -- upvalues: v572 (ref)
            v572.antiaim.round_ended = true;
        end
    }, 
    [6] = {
        [1] = "round_start", 
        [2] = function()
            -- upvalues: v572 (ref)
            v572.antiaim.round_ended = false;
        end
    }, 
    [7] = {
        [1] = "level_init", 
        [2] = function()

        end
    }, 
    [8] = {
        [1] = "bullet_impact", 
        [2] = function(v574)
            -- upvalues: v50 (ref), v56 (ref), v55 (ref), v51 (ref), v572 (ref)
            if v50 == globals.tickcount then
                return;
            elseif not globals.is_connected then
                return;
            elseif not entity.get_local_player():is_alive() then
                return;
            elseif not entity.get(v574.userid, true) then
                return;
            elseif not v574.userid then
                return;
            elseif entity.get(v574.userid, true):is_alive() == false then
                return;
            elseif entity.get(v574.userid, true):is_dormant() then
                return;
            elseif not entity.get(v574.userid, true):is_enemy() then
                return;
            else
                if math.abs(v56.ab.bruted_last_time - globals.curtime) > 0.25 then
                    local v575 = vector(v574.x, v574.y, v574.z);
                    local v576 = entity.get(v574.userid, true):get_eye_position();
                    local v577 = entity.get_local_player():get_eye_position();
                    local _ = v55(v577, v576, v575);
                    local v579 = entity.get(v574.userid, true);
                    if v51 < 70 then
                        v56.ab.bruted_last_time = globals.curtime;
                        v56.ab.time[v579] = globals.curtime + 5;
                        v56.ab.jitteralgo[v579] = math.random(-6, -4);
                        v56.ab.should_swap[v579] = true;
                        if v572.ui.menu.vis.missnotification:get() then
                            ambani_insert_log("$Ambani$ User [$'" .. v579:get_name() .. "'$] shot at you", 6);
                        end;
                    end;
                end;
                return;
            end;
        end
    }, 
    [9] = {
        [1] = "render", 
        [2] = function()
            -- upvalues: v572 (ref)
            v572.visuals:render();
            v572.hotkeys:render_hotkeys();
            v572.visuals:render_damage_indicator();
            v572.visuals:scope_overlay();
            v572.uselessshit:aspectratioviewmodel();
            v572.disable_cvars:perfomance_boost();
        end
    }, 
    [10] = {
        [1] = "createmove", 
        [2] = function(v580)
            -- upvalues: v572 (ref)
            v572.defensive:on_createmove(v580);
            v572.antiaim:run(v580);
            v572.uselessshit:no_fall_damage(v580);
            v572.uselessshit:fastladder(v580);
            v572.uselessshit:fake_latency(v580);
        end
    }, 
    [11] = {
        [1] = "createmove_run", 
        [2] = function(v581)
            -- upvalues: v572 (ref)
            if v572.ui.menu.misc.unlock_fakeduck_speed:get() then
                if not v572.ref.rage.fd:get() then
                    return;
                else
                    local v582 = vector(v581.forwardmove, v581.sidemove);
                    v582:normalize();
                    local v583 = entity.get_local_player();
                    if v583 == nil then
                        return;
                    elseif math.abs(v583.m_vecVelocity.y) > 10 then
                        v581.forwardmove = v582.x * 150;
                        v581.sidemove = v582.y * 150;
                    end;
                end;
            end;
        end
    }
}) do
    if v585[1] == "load" then
        v585[2]();
    else
        events[v585[1]]:set(v585[2]);
    end;
end;