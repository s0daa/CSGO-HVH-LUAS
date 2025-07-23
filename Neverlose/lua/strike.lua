-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local ffi = require 'ffi'

local pui = require 'neverlose/pui'

local base64 = require 'neverlose/base64'
local clipboard = require 'neverlose/clipboard'

local smoothy = require 'neverlose/smoothy'
local lambotruck = require 'neverlose/lambotruck'

local inspect = require 'neverlose/inspect'

local lagrecord do
	lagrecord = require 'neverlose/lagrecord'
	lagrecord = lagrecord ^ lagrecord.SIGNED

	lagrecord.set_update_callback(function(player)
		if player == entity.get_local_player() then
			return true
		end
	end)
end

local zane_settings = [[{"ct":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["Height Advantage","~"],"modifier_random":0.0,"options":["Hide Head","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":6.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":35.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":30.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":16.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":4.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-16.0,"yaw_add2":0.0,"yaw_add_l_random":2.0,"yaw_add_r":43.0,"yaw_add_r_random":2.0,"yaw_base":2.0,"yaw_jitter":4.0,"yaw_jitter_add":12.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":13.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":3.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":40.0,"yaw_add_r_random":5.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":19.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":-3.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":12.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"static","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":8.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":4.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":8.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":39.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":55.0,"fakelimit_options":"L&R","fakelimit_r":59.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":40.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":13.0,"yaw_mode":2.0,"yaw_sliders":1.0}},"t":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["Height Advantage","~"],"modifier_random":0.0,"options":["Hide Head","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":6.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":35.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":30.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":16.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":4.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-16.0,"yaw_add2":0.0,"yaw_add_l_random":2.0,"yaw_add_r":43.0,"yaw_add_r_random":2.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":12.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":13.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":2.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":40.0,"yaw_add_r_random":5.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":8.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":-3.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":12.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"static","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":8.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":4.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":8.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":39.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":55.0,"fakelimit_options":"L&R","fakelimit_r":59.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":40.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":13.0,"yaw_mode":2.0,"yaw_sliders":1.0}}}]]
-- local pirex_settings = [[{"ct":{"duck":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":4.0,"slider_values2":4.0,"slider_values3":4.0,"slider_values4":4.0,"slider_values5":4.0,"slider_values6":8.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-33.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":32.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":9.0,"yaw_mode":2.0,"yaw_sliders":6.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Hittable","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"180","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":58.0,"fakelimit_options":"L&R","fakelimit_r":58.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":2.0,"slider_values2":2.0,"slider_values3":2.0,"slider_values4":5.0,"slider_values5":7.0,"slider_values6":8.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":8.0,"yaw_add":-23.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":42.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-5.0,"yaw_mode":2.0,"yaw_sliders":6.0},"duck move":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-16.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":29.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":15.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":34.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-10.0,"yaw_mode":2.0,"yaw_sliders":1.0},"slow walk":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-27.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":2.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":16.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":58.0,"fakelimit_options":"L&R","fakelimit_r":58.0,"hidehead_options":["~"],"modifier_random":5.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":4.0,"slider_values2":5.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":41.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-4.0,"yaw_mode":2.0,"yaw_sliders":6.0}},"t":{"duck":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":4.0,"slider_values2":4.0,"slider_values3":4.0,"slider_values4":4.0,"slider_values5":4.0,"slider_values6":8.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-33.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":32.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":9.0,"yaw_mode":2.0,"yaw_sliders":6.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Hittable","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"180","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":58.0,"fakelimit_options":"L&R","fakelimit_r":58.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":2.0,"slider_values2":2.0,"slider_values3":2.0,"slider_values4":5.0,"slider_values5":7.0,"slider_values6":8.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":8.0,"yaw_add":-23.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":42.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-5.0,"yaw_mode":2.0,"yaw_sliders":6.0},"duck move":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-14.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":18.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":58.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-38.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":40.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-10.0,"yaw_mode":2.0,"yaw_sliders":1.0},"slow walk":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-27.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":2.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":16.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":58.0,"fakelimit_options":"L&R","fakelimit_r":58.0,"hidehead_options":["~"],"modifier_random":5.0,"options":["~"],"random_delay_value_1":0.0,"random_delay_value_2":0.0,"slider_values1":4.0,"slider_values2":5.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":41.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-4.0,"yaw_mode":2.0,"yaw_sliders":6.0}}}]]
-- local meta_settings = [[{"ct":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-35.0,"yaw_add2":0.0,"yaw_add_l_random":13.0,"yaw_add_r":24.0,"yaw_add_r_random":21.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":40.0,"yaw_mode":2.0,"yaw_sliders":1.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":5.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":8.0,"yaw_add_r":29.0,"yaw_add_r_random":9.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":33.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"global":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":2.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":24.0,"yaw_add_r_random":11.0,"yaw_base":1.0,"yaw_jitter":6.0,"yaw_jitter_add":35.0,"yaw_mode":2.0,"yaw_sliders":3.0},"jump":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":12.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":2.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":8.0,"yaw_add_r":19.0,"yaw_add_r_random":16.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":35.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0}},"t":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-35.0,"yaw_add2":0.0,"yaw_add_l_random":13.0,"yaw_add_r":24.0,"yaw_add_r_random":21.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":40.0,"yaw_mode":2.0,"yaw_sliders":1.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":5.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":8.0,"yaw_add_r":29.0,"yaw_add_r_random":9.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":33.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"global":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":2.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":24.0,"yaw_add_r_random":11.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":35.0,"yaw_mode":2.0,"yaw_sliders":3.0},"jump":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"run":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":12.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":2.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":8.0,"yaw_add_r":19.0,"yaw_add_r_random":16.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":35.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":12.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":2.0,"slider_values2":3.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":8.0,"yaw_add_r":19.0,"yaw_add_r_random":3.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":30.0,"yaw_mode":2.0,"yaw_sliders":3.0}}}]]
local pirex_settings = [[{"ct":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["Height Advantage","~"],"modifier_random":0.0,"options":["Hide Head","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":6.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":35.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":19.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":3.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-18.0,"yaw_add2":0.0,"yaw_add_l_random":10.0,"yaw_add_r":29.0,"yaw_add_r_random":10.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":31.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":13.0,"defensive_activation":"Always","defensive_activation_options":["Always","~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":3.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":40.0,"yaw_add_r_random":5.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":8.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-3.0,"yaw_mode":2.0,"yaw_sliders":1.0},"run":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"static","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":4.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-22.0,"yaw_add2":0.0,"yaw_add_l_random":16.0,"yaw_add_r":28.0,"yaw_add_r_random":16.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":36.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":55.0,"fakelimit_options":"L&R","fakelimit_r":59.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":40.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":13.0,"yaw_mode":2.0,"yaw_sliders":1.0}},"t":{"duck":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["Height Advantage","~"],"modifier_random":0.0,"options":["Hide Head","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":3.0,"slider_values2":6.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":35.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":19.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":10.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":3.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":3.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-21.0,"yaw_add2":0.0,"yaw_add_l_random":9.0,"yaw_add_r":32.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":31.0,"yaw_mode":2.0,"yaw_sliders":3.0},"duck move":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":13.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":2.0,"delay_method":2.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Avoid Backstab","Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":2.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":5.0,"yaw_add_r":40.0,"yaw_add_r_random":5.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":8.0,"yaw_mode":2.0,"yaw_sliders":1.0},"global":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"jump":{"body_yaw":3.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":11.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-30.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":30.0,"yaw_add_r_random":0.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":-3.0,"yaw_mode":2.0,"yaw_sliders":1.0},"run":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":9.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":60.0,"fakelimit_l":32.0,"fakelimit_options":"static","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":15.0,"options":["Avoid Backstab","~"],"random_delay_value_1":1.0,"random_delay_value_2":4.0,"slider_values1":2.0,"slider_values2":1.0,"slider_values3":3.0,"slider_values4":2.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":2.0,"yaw_add":-15.0,"yaw_add2":0.0,"yaw_add_l_random":6.0,"yaw_add_r":22.0,"yaw_add_r_random":11.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":39.0,"yaw_mode":2.0,"yaw_sliders":3.0},"slow walk":{"body_yaw":1.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":false,"fakelimit":32.0,"fakelimit_l":32.0,"fakelimit_options":"jitter","fakelimit_r":32.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":0.0,"yaw_add2":0.0,"yaw_add_l_random":0.0,"yaw_add_r":0.0,"yaw_add_r_random":0.0,"yaw_base":1.0,"yaw_jitter":1.0,"yaw_jitter_add":0.0,"yaw_mode":1.0,"yaw_sliders":1.0},"stand":{"body_yaw":2.0,"body_yaw_slider_values1":1.0,"body_yaw_slider_values2":1.0,"body_yaw_slider_values3":1.0,"body_yaw_slider_values4":1.0,"body_yaw_slider_values5":1.0,"body_yaw_slider_values6":1.0,"body_yaw_sliders":1.0,"body_yaw_switch_delay":1.0,"body_yaw_ticks":1.0,"defensive_activation":"Always","defensive_activation_options":["~"],"defensive_pitch":"Down","defensive_pitch_value":0.0,"defensive_yaw":"Spin","defensivebuilder_enable":1.0,"delay":1.0,"delay_method":1.0,"enable":true,"fakelimit":32.0,"fakelimit_l":55.0,"fakelimit_options":"L&R","fakelimit_r":59.0,"hidehead_options":["~"],"modifier_random":0.0,"options":["Fluctuate Fakelag","~"],"random_delay_value_1":1.0,"random_delay_value_2":1.0,"slider_values1":1.0,"slider_values2":1.0,"slider_values3":1.0,"slider_values4":1.0,"slider_values5":1.0,"slider_values6":1.0,"slider_values7":1.0,"slider_values8":1.0,"switch_delay":1.0,"yaw_add":-24.0,"yaw_add2":0.0,"yaw_add_l_random":3.0,"yaw_add_r":40.0,"yaw_add_r_random":8.0,"yaw_base":2.0,"yaw_jitter":6.0,"yaw_jitter_add":13.0,"yaw_mode":2.0,"yaw_sliders":1.0}}}]]

local vec_closest_point_on_ray = function(target, ray_start, ray_end)
    local to = target - ray_start
    local direction = ray_end - ray_start
    local ray_length = #direction
    direction.x = direction.x / ray_length
    direction.y = direction.y / ray_length
    direction.z = direction.z / ray_length
    local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
    if direction_along < 0 then return ray_start end
    if direction_along > ray_length then return ray_end end
    return vector(ray_start.x + direction.x * direction_along, ray_start.y + direction.y * direction_along, ray_start.z + direction.z * direction_along)
end

local distance = 0
local bullet_impact = function(eye_pos, eyepos, impact)
    distance = vec_closest_point_on_ray(eye_pos, eyepos, impact):dist(eye_pos)
    if distance > 55 then return end
    tick_work = globals.tickcount
end

local ctx = new_class()

    :struct 'globals' {
        states = {'stand', 'slow walk', 'run', 'duck', 'jump', 'duck jump', 'duck move'},
        extended_states = {'global', 'stand', 'slow walk', 'run', 'duck', 'jump', 'duck jump', 'duck move'},
        teams = {'t', 'ct'},
		strike_cache = {
			ab = {
				bruted_last_time = 0,
				stage = {},
				should_swap = {},
				time = {},
				misses = {},
				jitter = 0,
				jitteramount = 0,
				hurt = false,
				jitteralgo = {}
			},
		}
    }
    :struct 'ref' {
        antiaim = {
			enable = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Enabled'),
            pitch = ui.find('Aimbot', 'Anti aim', 'Angles', 'Pitch'),
            yaw = ui.find('Aimbot', 'Anti aim', 'Angles', 'Yaw'),
            hidden = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Hidden'),
            yawoffset = ui.find('Aimbot', 'Anti aim', 'Angles', 'Yaw', 'Offset'),
            yawmodifier = ui.find('Aimbot', 'Anti aim', 'Angles', 'Yaw Modifier'),
            yawmodifieramount = ui.find('Aimbot', 'Anti aim', 'Angles', 'Yaw Modifier', 'Offset'),
            bodyyawopt = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Options'),
            leftfake = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Left Limit'),
            rightfake = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Right Limit'),
            slowwalk = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Slow Walk'),
            bodyyaw = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw'),
            legmovement = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement'),
            freestanding = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding'),
			freestanding_static = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Freestanding', 'Disable Yaw Modifiers'),
            yawtarget = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base'),
            inverter = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Inverter'),
            fbyaw = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Freestanding'),
			legs = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement'),
            antibackstab = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Avoid Backstab')
        },
        rage = {
            dt = ui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap'),
            hs = ui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots'),
            hs2 = ui.find('Aimbot', 'Ragebot', 'Main', 'Hide Shots', 'Options'),
            fb = ui.find('Aimbot', 'Ragebot', 'Safety', 'Body Aim'),
            dmg = ui.find('Aimbot', 'Ragebot', 'Selection', 'Min. Damage'),
            fakelag = ui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Limit'),
            fakelag_enabled = ui.find('Aimbot', 'Anti Aim', 'Fake Lag', 'Enabled'),
            dtlag = ui.find('Aimbot', 'Ragebot', 'Main', 'Double Tap', 'Lag Options'),
            fd = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'),
			ping = ui.find('Miscellaneous', 'Main', 'Other', 'Fake Latency')
        },
		visuals = {
			scope_overlay = ui.find('Visuals', 'World', 'Main', 'Override Zoom', 'Scope Overlay'),
			force_thirdperson = ui.find('Visuals', 'World', 'Main', 'Force Thirdperson')
		}
	}

    :struct 'ui' {
		menu = {
			global = {},
			aa = {},
			vis = {},
			misc = {},
			cfg = {},
			debug = {}
		},

		add_space = function(self, text, count)
			local HSP = '\u{200A}'

			local space = string.rep(HSP, count)
			local result = space .. text .. space

			return result
		end,
		render = function(self)
			local time = globals.realtime

			local style = ui.get_style()

			local color_a = style['Link Active']
			local color_b = color(80, 80, 80, 255)

			local text = self.decors:gradient(
				'strike dev', time, color_a, color_b
			)

			local icon = self.decors:gradient(
				ui.get_icon('signature-lock'),
				time, color_a, color_b
			)

			pui.sidebar(text, icon)
		end,
        execute = function(self)
			local function lock_unselection(ref, default_value, callback)
				local prev_value = ref:get()

				if next(prev_value) == nil then
					if default_value == nil then
						default_value = ref:list()
					end

					prev_value = default_value
					ref:set(default_value)
				end

				local function on_item(item)
					local value = item:get()

					if next(value) == nil then
						ref:set(prev_value)
					else
						prev_value = value
					end

					if callback ~= nil then
						callback(item)
					end
				end

				ref:set_callback(on_item, true)
			end

			local group = pui.create('strike',{
				{'select', 'SELECTION'},
				{'main', 'MAIN', 2},
				{'other', 'MODE', 1},
        		{'addon', 'EXTRA', 1},
        		{'movement', 'MOVEMENT', 2},
				{'builder', 'BUILDER', 2},
				{'configs', 'CONFIGS'},
				{'info', 'info'},
			})

			self.menu.global.select = group.select:list('', {

				' \v\f<house>\r  Home',
				' \v\f<user-shield>\r  Anti-Aim',
				' \v\f<circle-half-stroke>\r  Visuals',
				' \v\f<sliders>\r  Misc',
			})


			self.menu.cfg.hawiz = group.info:button('\v\f<youtube>\r  Hawiz', function ()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@hawiz1220")
            end, true)

			self.menu.cfg.pirex = group.info:button('\v\f<youtube>\r  Pirex', function ()
                panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@pirexq")
            end, true)


			self.menu.aa.mode = group.main:combo('\v\f<user-gear>\r  Anti-aim mode', {'Strike', 'Builder'})
			self.menu.aa.preset_list = group.main:list('\v\f<user-plus>\r  Presets', {
				'\v\f Beach Bunny @Zane',
				'\v\f Burger @Pirex'
			}):depend({self.menu.aa.mode, 'Strike'})

			self.menu.aa.state = group.main:combo('\v\f<person>\r  State', self.globals.extended_states):depend({self.menu.aa.mode, 'Builder'})
			self.menu.aa.team = group.main:combo('\v\f<people-group>\r  Team', self.globals.teams):depend({self.menu.aa.mode, 'Builder'})

            self.menu.aa.states = {}

			for _, team in ipairs(self.globals.teams) do
				self.menu.aa.states[team] = {}
				for _, state in ipairs(self.globals.extended_states) do
					self.menu.aa.states[team][state] = {}
					local menu = self.menu.aa.states[team][state]

					if state ~= 'global' then
						menu.enable = group.builder:switch('Activate ' .. state .. '\n' .. team)
					end

					--menu.options = group.builder:selectable('\v\f<gears>\r  Additions' .. '\n' .. state .. team, 'Warmup AA', 'Hide Head', 'Avoid Backstab', 'Fluctuate Fakelag')
					--local gear = menu.options:create()
                    --menu.hidehead_options = gear:selectable('Hide head options' .. '\n' .. state .. team, 'Standing', 'Crouch', 'Air Crouch Knife', 'Distance', 'Height Advantage', 'Taser In Air'):depend({menu.options, 'Hide Head'})
					--menu.yaw_base = group.builder:combo('Yaw Base' .. '\n' .. state .. team, {'local view', 'at targets'})

					menu.yaw_base = group.builder:slider('\v\f<arrows-turn-to-dots>\r  Yaw Base\n' .. state .. team, 1, 2, 0, 1, function(val)
						if val == 1 then
							return 'Local View'
						elseif val == 2 then
							return 'At Targets'
						end
					end)

					local gear = menu.yaw_base:create()

					menu.yaw_mode = group.builder:slider('\v\f<layer-group>\r  Mode\n' .. state .. team, 1, 2, 0, 1, function(val)


						if val == 1 then
							return '1-Way'
						elseif val == 2 then
							return '2-Way'
						end

					end)

                    local gear = menu.yaw_mode:create()
                    menu.yaw_add2 = gear:slider('\v\f<hyphen>\r  Yaw' .. '\nvalue' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_mode, 1, false})
					menu.yaw_add = gear:slider('\v\f<arrow-left>\r  Yaw Left' .. '\n' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_mode, 2, false})
					menu.yaw_add_l_random = gear:slider('\v\f<shuffle>\r  Random Left' .. '\n left' .. state .. team, 0, 180, 0, 1):depend({menu.yaw_mode, 2, false})
					menu.yaw_add_r = gear:slider('\v\f<arrow-right>\r  Yaw Right' .. '\n' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_mode, 2, false})
					menu.yaw_add_r_random = gear:slider('\v\f<shuffle>\r  Random Right' .. '\n right' .. state .. team, 0, 180, 0, 1):depend({menu.yaw_mode, 2, false})

					menu.delay = gear:slider('\v\f<timeline>\r  Delay\n' .. state .. team, 1, 2, 0, 1, function(val)
						if val == 1 then
							return 'Off'
						elseif val == 2 then
							return 'On'
						end
					end)

					menu.delay_method = gear:slider('\v\f<rotate-right>\r  Method\n' .. state .. team, 1, 3, 0, 1, function(val)
						if val == 1 then
							return 'Default'
						elseif val == 2 then
							return 'Random'
						elseif val == 3 then
							return 'Custom'
						end
					end):depend({menu.delay, 2})

					menu.switch_delay = gear:slider('\v\f<timer>\r  Timing\n' .. state .. team, 1, 17, 0, 1, function(val)
						return val .. 't'
					end):depend({menu.delay_method, 1}):depend({menu.delay, 2})

					menu.random_delay_value_1 = gear:slider('\v\f<timer>\r  Min. Timing\n' .. state .. team, 1, 17, 0, 1, function(val)
						return val .. 't'
					end):depend({menu.delay_method, 2}):depend({menu.delay, 2})

					menu.random_delay_value_2 = gear:slider('\v\f<timer>\r  Max. Timing\n' .. state .. team, 1, 17, 0, 1, function(val)
						return val .. 't'
					end):depend({menu.delay_method, 2}):depend({menu.delay, 2})


					menu.yaw_sliders = gear:slider('\v\f<list-timeline>\r  Sliders\n as' .. state .. team, 1, 8, 0, 1):depend({menu.delay_method, 3}):depend({menu.delay, 2})

					for i = 1, 8 do
						menu["slider_values" .. i] = gear:slider('\v\f<hyphen>\r  [' .. i .. ']\n' .. state .. "\n" .. team, 1, 8, 0, 1):depend({menu.delay_method, 3}):depend({menu.yaw_sliders, i, 10}):depend({menu.delay, 2})
					end

					menu.yaw_jitter = group.builder:slider('\v\f<gitter>\r  Jitter\n' .. state .. team, 1, 6, 0, 1, function(val)
						if val == 1 then
							return 'Off'
						elseif val == 2 then
							return 'Offset'
						elseif val == 3 then
							return 'Center'
						elseif val == 4 then
							return 'Random'
						elseif val == 5 then
							return 'Spin'
						elseif val == 6 then
							return 'Rapid'
						end
					end)

					--menu.yaw_jitter = group.builder:combo('Yaw Jitter\n' .. state .. team, {'off', 'offset', 'center', 'random', 'rapid'})
					local gear = menu.yaw_jitter:create()
					menu.yaw_jitter_add = gear:slider('\v\f<gitter>\r  Jitter\n' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_jitter, 2, 6})

					menu.modifier_random_enable = gear:switch("Randomization")

					menu.modifier_random_method = gear:slider('\v\f<rotate-right>\r  Method\n' .. state .. team, 1, 2, 0, 1, function(val)
						if val == 1 then
							return 'Default'
						elseif val == 2 then
							return 'Custom'
						end
					end):depend({menu.yaw_jitter, 2, 6}):depend({menu.modifier_random_enable, true})

                    menu.modifier_random = gear:slider('\v-\r  Minimum\n' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_jitter, 2, 6}):depend({menu.modifier_random_enable, true}):depend({menu.modifier_random_method, 1})
					menu.modifier_random2 = gear:slider('\v-\r  Maximum\n' .. state .. team, -180, 180, 0, 1):depend({menu.yaw_jitter, 2, 6}):depend({menu.modifier_random_enable, true}):depend({menu.modifier_random_method, 1})

					menu.modifier_random_sliders = gear:slider('\v\f<list-timeline>\r  Sliders\n as' .. state .. team, 1, 8, 0, 1):depend({menu.yaw_jitter, 2, 6}):depend({menu.modifier_random_enable, true}):depend({menu.modifier_random_method, 2})

					for i = 1, 8 do
						menu["modifier_random_slider_values" .. i] = gear:slider('\v\f<hyphen>\r  [' .. i .. ']\n' .. state .. "\n" .. team, -180, 180, 0, 1):depend({menu.yaw_jitter, 2, 6}):depend({menu.modifier_random_enable, true}):depend({menu.modifier_random_sliders, i, 10}):depend({menu.modifier_random_method, 2})
					end


					menu.body_yaw = group.builder:slider('\v\f<child>\r  Body\n' .. state .. team, 1, 3, 0, 1, function(val)
						if val == 1 then
							return 'Off'
						elseif val == 2 then
							return 'Jitter'
						elseif val == 3 then
							return 'Tick'
						end
					end)

					--menu.body_yaw = group.builder:combo('Body Yaw\n' .. '\n' .. state .. team, {'off', 'jitter', 'tick'})

					local gear = menu.body_yaw:create()

					menu.body_yaw_ticks = gear:slider('\v\f<timeline>\r  Ticks\n' .. state .. team, 1, 18, 0, 1, function(val)
						return val .. 't'
					end):depend({menu.body_yaw, 3})

					menu.body_yaw_switch_delay = gear:slider('\v\f<timeline>\r  Delay\n2' .. state .. team, 1, 17, 0, 1, function(val)
						if val == 1 then
							return 'Off'
						elseif val == 16 then
							return 'Random'
						elseif val == 17 then
							return 'Custom'
						else
							return val .. 't'
						end
					end):depend({menu.body_yaw, 2})

					menu.body_yaw_sliders = gear:slider('\v\f<list-timeline>\r  Sliders\n' .. state .. team, 1, 6, 0, 1):depend({menu.body_yaw_switch_delay, 17})

					for i = 1, 6 do
						menu["body_yaw_slider_values" .. i] = gear:slider('\v\f<hyphen>\r  [' .. i .. ']\n' .. state .. "\n" .. team, 1, 8, 0, 1)
							:depend({menu.body_yaw_switch_delay, 17}):depend({menu.body_yaw_sliders, i, 10})
					end

                    menu.fakelimit_options = gear:combo('\v\f<gears>\r  Fake options\n' .. state .. team, {'jitter', 'static', 'L&R'}):depend({menu.body_yaw, 2})

                    menu.fakelimit = gear:slider('\v\f<hyphen>\r  Fake limit' .. '\n' .. state .. team, 0, 60, 32, 1):depend({menu.fakelimit_options, 'L&R', true}):depend({menu.body_yaw, 2})
                    menu.fakelimit_l = gear:slider('\v\f<hyphen>\r  Fake limit L' .. '\n' .. state .. team, 0, 60, 32, 1):depend({menu.body_yaw, 2}):depend({menu.fakelimit_options, 'L&R', false})
                    menu.fakelimit_r = gear:slider('\v\f<hyphen>\r  Fake limit R' .. '\n' .. state .. team, 0, 60, 32, 1):depend({menu.body_yaw, 2}):depend({menu.fakelimit_options, 'L&R', false})

					menu.defensivebuilder_enable = group.builder:slider('\v\f<shield>\r  Defensive\n2' .. state .. team, 1, 2, 0, 1, function(val)
						if val == 1 then
							return 'Off'
						elseif val == 2 then
							return 'On'
						end
					end)

                    local gear = menu.defensivebuilder_enable:create()
                    menu.defensive_pitch = gear:combo('Pitch' .. '\n' .. state .. team, {'Down', 'Up', 'Custom'}):depend({menu.defensivebuilder_enable, 2})
                    menu.defensive_pitch_value = gear:slider('Pitch\n value' .. state .. team, -89, 89, 0, 1):depend({menu.defensive_pitch, 'Custom'})
                    menu.defensive_yaw = gear:combo('Yaw' .. '\n' .. state .. team, {'Spin', 'Static', 'Left/Right'}):depend({menu.defensivebuilder_enable, 2})
					menu.defensive_yaw_value = gear:slider('Offset\n value' .. state .. team, -180, 180, 0, 1):depend({menu.defensive_yaw, 'Static'})
					menu.defensive_yaw_left_value = gear:slider('Left Offset\n left value' .. state .. team, -180, 180, 0, 1):depend({menu.defensive_yaw, 'Left/Right'})
					menu.defensive_yaw_right_value = gear:slider('Right Offset\n right value' .. state .. team, -180, 180, 0, 1):depend({menu.defensive_yaw, 'Left/Right'})

                    menu.defensive_activation = gear:combo('Activation' .. '\n' .. state .. team, {'Always', 'Hittable'}):depend({menu.defensivebuilder_enable, 2})

                    menu.defensive_options = group.builder:label('\v\f<gears>\r  Force Break LC')
                    local gear = menu.defensive_options:create()
                    menu.defensive_activation_options = gear:selectable('Activators' .. '\n' .. state .. team, 'Weapon switch', 'Weapon reload', 'Always')

					menu.defensive_tickbase = gear:switch('Tickbase' .. '\n' .. state .. team)
					menu.defensive_choke_from = gear:slider('Choke From' .. '\n' .. state .. team, 2, 22, 15, nil, 't')
					menu.defensive_choke_to = gear:slider('Choke To' .. '\n' .. state .. team, 2, 22, 15, nil, 't')

                    for _, v in pairs(menu) do
						local arr =  { {self.menu.aa.state, state}, {self.menu.aa.team, team}, {self.menu.aa.mode, 'Builder'} }
						if _ ~= 'enable' and state ~= 'global' then
							arr =  { {self.menu.aa.state, state}, {self.menu.aa.team, team}, {self.menu.aa.mode, 'Builder'}, {menu.enable, true} }
						end

						v:depend(table.unpack(arr))
					end

					menu.defensive_choke_from:depend({menu.defensive_tickbase, true})
					menu.defensive_choke_to:depend({menu.defensive_tickbase, true})
				end
			end

			self.menu.aa.send_to_another_team = group.other:button('                \v\f<arrows-turn-to-dots>\r  Send to another team                ', function()
				local export_type = 'state'

				local team = self.menu.aa.team:get()
				local state = self.menu.aa.state:get()

				local data = self.config:export(export_type, team, state)
				local other_team = team == 'ct' and 't' or 'ct'

				self.config:import(data, export_type, other_team, state)
			end, true)

            -- self.menu.aa.export_from = group.other:combo('\v\f<file-export>\r  Export', {'selected state', 'selected team'}):depend({self.menu.aa.mode, 'Builder'})
            -- self.menu.aa.export_to = group.other:combo('\v\f<file-import>\r   Import', {'opposite team', 'clipboard'}):depend({self.menu.aa.mode, 'Builder'})
            -- self.menu.aa.export = group.other:button('Export', function ()
			--     local type = 'team'
			--     local team = self.menu.aa.team:get() == 'ct' and 't' or 'ct'

			-- 	if self.menu.aa.export_from:get() == 'selected state' then
			--     	type = 'state'
			--     end

			--     data = self.config:export(type, self.menu.aa.team:get(), self.menu.aa.state:get())

			--     if self.menu.aa.export_to:get() == 'clipboard' then
			--     	clipboard.set(data)
			--     else
			--     	self.config:import(data, type, team, self.menu.aa.state:get())
			--     end
			-- end, true):depend({self.menu.aa.mode, 'Builder'})

            -- self.menu.aa.import = group.other:button('Import', function ()
            --     local data = clipboard.get()
            --     local type = data:match('{strike:(.+)}')
            --             self.config:import(data, type, self.menu.aa.team:get(), self.menu.aa.state:get())
            -- end, true):depend({self.menu.aa.mode, 'Builder'})
            --misc
            -- button(build.basic.page, {}, false)

			self.menu.aa.options = group.addon:selectable('\v\f<gears>\r  Additions' .. '\n', 'Warmup AA', 'Hide Head', 'Avoid Backstab', 'Fluctuate Fakelag')

			local gear = self.menu.aa.options:create()
			self.menu.aa.hidehead_options = gear:selectable('Hide head options' .. '\n', 'Standing', 'Crouch', 'Air Crouch Knife', 'Distance', 'Height Advantage', 'Taser In Air'):depend({self.menu.aa.options, 'Hide Head'})
			self.menu.aa.freestanding = group.addon:switch('\v\f<arrows-turn-to-dots>\r  Freestanding')

			local freestand_gear = self.menu.aa.freestanding:create()
    		self.menu.aa.freestanding_disablers = freestand_gear:selectable('Disablers', self.globals.states):depend({self.menu.aa.freestanding, true})
			self.menu.aa.manual_aa = group.addon:combo('\v\f<arrows-spin>\r  Manual anti-aim', {'Off', 'Left', 'Right', 'Forward'})
			self.menu.aa.animations = group.addon:selectable('\v\f<person-skating>\r  Animations', {"Static legs", "Leg fucker", "Body lean"}, "Body lean - Performs a lean animation in every state. ")

			local animations_gear = self.menu.aa.animations:create()
			self.menu.aa.animations_lean_amount = animations_gear:slider('\v\f<list-timeline>\r  Leaning\n', 1, 100, 0, 1):depend({self.menu.aa.animations, "Body lean"})
			self.menu.aa.yawmodifier = freestand_gear:selectable('Type', {'Force static'}):depend({self.menu.aa.freestanding, true})

			self.menu.vis.watermark = group.main:label('\v\f<audio-description>\r Watermark', function(gear)
				local list = { }

				list.col = gear:color_picker('Color', {
					['Accent'] = { color(250, 137, 250, 255) },
					['Secondary'] = { color(255, 255, 255, 255) }
				})

				list.style = gear:combo('Style', { 'Simple', 'Strike' })
				list.position = gear:combo('Position', { 'Bottom', 'Left', 'Right' })

                list.build_col = gear:color_picker(
                    'Build Color', color(250, 137, 250, 255)
                )

                local callbacks do
                    local function on_style(item)
                        local value = item:get()

                        list.build_col:visibility(
                            value == 'Simple'
                        )
                    end

                    list.style:set_callback(
                        on_style, true
                    )
                end

				return list
			end)

			self.menu.vis.hitlogs = group.main:switch("\v\f<bullseye>\r  Log Events", false, function(gear)
				local items = { }

				items.col = gear:color_picker('Color', color(161, 135, 153))

				items.output = gear:selectable('Output', 'Console', 'Events')
				items.events = gear:selectable('Events', 'Aimbot', 'Purchases')

				lock_unselection(items.output)
				lock_unselection(items.events)

				return items
			end)

			self.menu.vis.hit_marker = group.addon:switch('\v\f<bullseye-arrow>\r  Hit Marker', false, function(gear)
				return {
					col = gear:color_picker('Color', color(255, 255, 255, 255))
				}
			end)

			self.menu.vis.kibit_marker = group.addon:switch('\v\f<plus>\r  Kibit Marker', false, function(gear)
				return {
					col = gear:color_picker('Color', {
                        ['Vertical'] = { color(0, 255, 0, 255) },
						['Horizontal'] = { color(0, 255, 255, 255) }
					}),

					size = gear:slider('Size', 2, 5, 4, nil, 'px'),
					thickness = gear:slider('Thickness', 1, 5, 2, nil, 'px')
				}
			end)

			self.menu.vis.scope_overlay = group.addon:switch('\v\f<eye>\r  Scope Overlay', false, function(gear)
				return {
					col = gear:color_picker('Color'),

					position = gear:slider('Position', 0, 500, 105),
					offset = gear:slider('Offset', 0, 500, 10),
					rotate = gear:switch('Rotate')
				}
			end)

			self.menu.vis.grenade_radius = group.addon:switch('\v\f<circle-xmark>\r  Grenade Radius', false, function(gear)
				local items = { }

				items.smoke = gear:switch('Smoke', false, { color(130, 130, 255) })
				items.molotov = gear:switch('Molotov', false, { color(245, 90, 90) })

				local callbacks do
					local function on_smoke(item)
						local value = item:get()

                        if not value and not items.molotov:get() then
                            items.molotov:set(true)
                        end
					end

					local function on_molotov(item)
						local value = item:get()

                        if not value and not items.smoke:get() then
                            items.smoke:set(true)
                        end
					end

					items.smoke:set_callback(on_smoke)
					items.molotov:set_callback(on_molotov)
				end

				return items
			end)

			self.menu.vis.aspect_ratio = group.main:switch('\v\f<display-code>\r  Aspect Ratio', false, function(gear)
				local items = { }

				local ratios = {
					'5:4',
					'4:3',
					'16:9',
					'16:10',
				}

				local values = {
					['5:4'] = 125,
					['4:3'] = 133,
					['16:9'] = 177,
					['16:10'] = 160
				}

				local keys = { } do
					for i = 1, #ratios do
						local ratio = ratios[i]
						local value = values[ratio]

						keys[value] = ratio
					end
				end

				items.ratio = gear:slider(
                    '##VALUE', 1, 200, 177, 0.01, function(val)
                        return keys[val] or nil
                    end
                )

				for i = 1, #ratios do
                    local ratio = ratios[i]
                    local value = values[ratio]

                    local function callback()
                        items.ratio:set(value)
                    end

                    local space = math.ceil(#ratio * 1.34)
                    local text = self:add_space(ratio, space)

                    gear:button(text, callback, true)
                end

				return items
			end)

			self.menu.vis.viewmodel = group.main:switch('\v\f<line-height>\r  Viewmodel', false, function(gear)
				return {
					fov = gear:slider('Fov', 0, 1000, 680, 0.1),

					offset_x = gear:slider('X', -100, 100, 25, 0.1),
					offset_y = gear:slider('Y', -100, 100, 25, 0.1),
					offset_z = gear:slider('Z', -100, 100, 25, 0.1),

					opposite_knife_hand = gear:switch('Opposite knife hand')
				}
			end)

			self.menu.vis.damage_indicator = group.addon:switch('\v\f<exclamation>\r  Damage Indicator', false, function(gear)
				return {
					col = gear:color_picker('Color', color(255, 255, 255, 255)),

					font = gear:combo('Font', { 'Default', 'Pixel' }),
					offset = gear:slider('Offset', 1, 12, 8, 1, 'px'),

					if_active = gear:switch('If active')
				}
			end)

			self.menu.vis.console_color = group.addon:switch('\v\f<terminal>\r  Console Color', false, color(150, 150, 150, 255))

			self.menu.vis.lc_indicator = group.main:switch('\v\f<ban-bug>\r  LC Indicator', false, function(gear)
				return {
					font = gear:combo('Font', { 'Default', 'Pixel', 'Bold' }),
					offset = gear:slider('Offset', 0, 100, 34, nil, '%'),
					background = gear:switch('Background'),
				}
			end)

			self.menu.vis.skeet_indicators = group.main:switch('\v\f<money-bill>\r  500$ Indicators', false, function(gear)
				return {
					feature_list = gear:listable(
						'##LIST', {
							'Hit/Miss',
							'Dormant Aimbot',
							'Damage Override',
							'Hitchance Override',
							'Fake Latency',
							'Fake Duck',
							'Body Aim',
							'Safe Points',
							'Freestanding',
							'Hide Shots',
							'Double Tap',
							'Bomb Info'
						}
					)
				}
			end)

			self.menu.vis.skeet_grenade = group.main:switch('\v\f<bomb>\r  Grenade Visuals', false, function(gear)
				local items = { }

				items.warning = gear:switch('Warning')
				items.trajectory = gear:switch('Trajectory')

				return items
			end)

			self.menu.vis.damage_helper = group.main:switch('\v\f<circle-exclamation>\r  Damage Helper', false, "Displays the amount of damage the equiped weapon can deal.", function(gear)
				local items = { }

				items.font = gear:combo('Font', { 'Default', 'Bold' })

				return items
			end)

			self.menu.vis.revolver_helper = group.main:switch('\v\f<circle-exclamation>\r  Revolver Helper', false, "Shows DMG/DMG+ when a enemy is killable in 1 bullet from a revolver.")

			self.menu.vis.lagcomp_debug = group.main:switch('\v\f<ban-bug>\r  LC Debug Box', false, "Displays a box that will show where the enemy will teleport.", function(gear)
				local items = { }

				items.box_color = gear:color_picker('Box Color', color(47, 117, 221, 255))
				items.text_color = gear:color_picker('Text Color', color(255, 45, 45, 255))

				return items
			end)

			self.menu.misc.drop_nades = group.main:switch('\v\f<bomb>\r  Drop Nades', false, "Drop grenades when you press the drop key.", function(gear)
				local items = { }

				items.hotkey = gear:hotkey('Activation key', 0x0)
				items.selection = gear:selectable('Selection', { 'HE', 'Smoke', 'Molotov' })

				return items
			end)

			self.menu.misc.super_toss = group.main:switch('\v\f<bomb>\r  Super Toss', false, "Straightens the trajectory when throwing utility.")

			self.menu.misc.grenade_release = group.main:switch('\v\f<bomb>\r Grenade Release', false, function(gear)
				local items = { }

				items.damage = gear:slider('Damage', 1, 50, 50, nil, 'hp')

				return items
			end)

			self.menu.misc.fast_ladder = group.addon:switch('\v\f<water-ladder>\r  Fast Ladder', false, "Increases movement speed when attached to a ladder.")

			self.menu.misc.freezetime_fakeduck = group.addon:switch('\v\f<face-icicles>\r  Freezetime Fakeduck', false, "Allows you to Fakeduck in freezetime")
			self.menu.misc.unlock_fakeduck_speed = group.addon:switch('\v\f<rabbit-running>\r  Override Fakeduck Speed', false, "Increases speed while moving in Fakeduck.")

			self.menu.misc.no_fall_damage = group.addon:switch('\v\f<person-falling>\r  No Fall Damage')

			self.menu.misc.keep_model_tranparency = group.addon:switch('\v\f<person-falling>\r  Keep Model Transparency', false, "Keep model transparency when shooting with bolt-action sniper.")

			self.menu.misc.dormant_aimbot = group.main:switch('\v\f<block-brick>\r  Dormant Aimbot', false, "Aimbot which shoots dormant players.", function(gear)
				local items = { }

				items.hitboxes = gear:selectable('Hitboxes', { 'Head', 'Chest', 'Stomach', 'Legs' })
				items.hitchance = gear:slider('Hitchance', 0, 100, 70)
				items.alpha_modifier = gear:slider('Accuracy', 50, 85, 78, nil, "%")
				items.minimum_damage = gear:slider('Minimum Damage', 0, 120, 10)

				lock_unselection(items.hitboxes)

				return items
			end)

			self.menu.misc.teammate_aimbot = group.main:switch('\v\f<heart-crack>\r  Teammate Aimbot', false, "mp_my_teammates_are_opps 1")

			self.menu.misc.edge_quick_stop = group.movement:switch('\v\f<person-walking-with-cane>\r  Edge Quick Stop', false, "Stops you on the edge, works only with Peek Assist.")

			self.menu.misc.air_duck_collision = group.movement:switch('\v\f<person-walking-dashed-line-arrow-right>\r  Air Duck Collision', false, "Avoids possible collision when air-ducking.")

			self.menu.aa.auto_teleport = group.addon:switch('\v\f<arrows-turn-to-dots>\r  Auto Teleport', false, "Automatically uncharges exploit, when defensive is gone.", function(gear)
				local items = { }

				items.teleport_delay = gear:slider('Teleport Delay', 0, 500, 0, nil, 'ms')

				return items
			end)

			self.menu.aa.auto_hide_shots = group.addon:switch('\v\f<water-ladder>\r  Auto Hide Shots', false, "Disables Doubletap & enables Hide Shots in selected state & weapons.", function(gear)
				local items = { }

				items.states = gear:selectable(
					'State', {
						'stand',
						'duck',
						'duck move',
					}
				)

				items.weapons = gear:selectable(
					'Weapons', {
						'SMG',
						'Rifles',
						'Pistols',
						'SSG-08',
						'AWP',
						'Auto Snipers',
						'Desert Eagle'
					}
				)

				return items
			end)

			self.menu.misc.clientside_nickname = group.main:switch('\v\f<input-text>\r  Clientside Nickname', false, function(gear)
				local items = { }

				items.nickname = gear:input('Nickname', 'strike')

				return items
			end)



			self.menu.misc.unlock_fake_ping = group.main:switch('\v\f<network-wired>\r  Unlock Fake Ping', false,"Unlocks the default Neverlose Fake Ping limit.", function(gear)
				local items = { }

				items.latency = gear:slider('Latency', 0, 200, 0, 'ms')

				return items
			end)

        	--configurations
      		self.menu.cfg.list = group.main:list('configs', {})
			self.menu.cfg.list:set_callback(function() self.config:update_name() end)
			self.menu.cfg.name = group.main:input(' \v\f<file>\r   Config name')
			self.menu.cfg.save = group.main:button('\v\f<floppy-disk>\r  Save', function() self.config:save() end, true)
			self.menu.cfg.load = group.main:button('\v\f<spinner>\r  Load', function() self.config:load() end, true)
			self.menu.cfg.delete = group.main:button('\v\f<trash-can>\r  Delete', function() self.config:delete() end, true)
			self.menu.cfg.export = group.main:button('\v\f<file-export>\r  Export', function() clipboard.set(self.config:export('config')) end, true)
			self.menu.cfg.import = group.main:button('\v\f<file-import>\r  Import', function() self.config:import(clipboard.get(), 'config') end, true)

			self.menu.cfg.export_preset = group.main:button('\v\f<triangle-exclamation>\r  [preset export]', function ()
				local config = pui.setup(self.menu.aa.states, true)
				local data = config:save()

				local serialized = json.stringify(data)

				clipboard.set(serialized)
			end, true, '\aFF0000FFCAUTION! \rThis is developer export, does not work for sharing settings')

			local tab_to_name = {
				['cfg'] = 1,
				['aa'] = 2,
				['vis'] = 3,
				['misc'] = 4
			}

            for tab, arr in pairs(self.menu) do
                if type(arr) == 'table' and tab ~= 'global' then
                    Loop = function (arr, tab)
                        for _, v in pairs(arr) do
                            if type(v) == 'table' then
                                if v.__type == 'pui::element' then
                                    v:depend({self.menu.global.select, tab_to_name[tab]})
                                else
                                    Loop(v, tab)
                                end
                            end
                        end
                    end

                    Loop(arr, tab)
                end
            end
        end

    }

	:struct 'binds' {
		lookup = { },

		update = function(self)
			local binds = ui.get_binds()

			for k in pairs(self.lookup) do
				self.lookup[k] = nil
			end

			for i = 1, #binds do
				local bind = binds[i]

				local reference = bind.reference
				local reference_id = reference:id()

				self.lookup[reference_id] = bind
			end
		end,

		get = function(self, reference)
			if reference == nil then
				return nil
			end

			return self.lookup[
				reference:id()
			]
		end
	}

    :struct 'config' {
		configs = {},
		write_file = function (self, path, data)
			if not data or type(path) ~= 'string' then
				return
			end
			return files.write(path, json.stringify(data))
		end,
		update_name = function (self)
			local index = self.ui.menu.cfg.list()
			local i = 1
			for k, v in pairs(self.configs) do
				if index == i or index == 0 then
					return self.ui.menu.cfg.name(k)
				end
				i = i + 1
			end
		end,
		update_configs = function (self)
			local names = {}
			for k, v in pairs(self.configs) do
				table.insert(names, k)
			end


			self.ui.menu.cfg.list:update(names)

			self:write_file('strike.txt', self.configs)
			self:update_name()
		end,
		setup = function (self)
			local data = files.read('strike.txt')
			if data == nil then
				self.configs = {}
				return
			end
			self.configs = json.parse(data)
			self:update_configs()
			self:update_name()
		end,
		export_config = function(self, ...)
			local config = pui.setup({self.ui.menu.global, self.ui.menu.aa, self.ui.menu.misc, self.ui.menu.vis}, true)
			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )
			return encrypted
		end,
		export_state = function (self, team, state)
			local config = pui.setup({self.ui.menu.aa.states[team][state]}, true)
			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )
			return encrypted
		end,
		export_team = function (self, team)
			local config = pui.setup({self.ui.menu.aa.states[team]}, true)
			local data = config:save()
			local encrypted = base64.encode( json.stringify(data) )
			return encrypted
		end,
		export = function (self, type, ...)
			local success, result = pcall(self['export_' .. type], self, ...)
			if not success then
				print(result)
				return
			end
			return '{strike:' .. type .. '}:' .. result
		end,
		import_config = function (self, encrypted)
			local data = json.parse(base64.decode(encrypted))
			local config = pui.setup({self.ui.menu.global, self.ui.menu.aa, self.ui.menu.misc, self.ui.menu.vis}, true)
			config:load(data)
		end,
		import_state = function (self, encrypted, team, state)
			local data = json.parse(base64.decode(encrypted))
			local config = pui.setup({self.ui.menu.aa.states[team][state]}, true)
			config:load(data)
		end,
		import_team = function (self, encrypted, team)
			local data = json.parse(base64.decode(encrypted))
			local config = pui.setup({self.ui.menu.aa.states[team]}, true)
			config:load(data)
		end,
		import = function (self, data, type, ...)
			local name = data:match('{strike:(.+)}')
			if not name or name ~= type then
				return error('This is not valid strike data. 1')
			end
			local success, err = pcall(self['import_'..name], self, data:gsub('{strike:' .. name .. '}:', ''), ...)
			if not success then
				print(err)
				return error('This is not valid strike data. 2')
			end
		end,
		save = function (self)
			local name = self.ui.menu.cfg.name()
			if name:match('%w') == nil then
				return print('Invalid config name')
			end
			local data = self:export('config')
			self.configs[name] = data
			self:update_configs()
		end,
		load = function (self)
			local name = self.ui.menu.cfg.name()
			local data = self.configs[name]
			if not data then
				return print('Invalid config name')
			end
			self:import(data, 'config')
		end,
		delete = function(self)
			local name = self.ui.menu.cfg.name()
			local data = self.configs[name]
			if not data then
				return print('Invalid config name')
			end
			self.configs[name] = nil
			self:update_configs()
		end
	}

	:struct 'helpers' {
        contains = function(self, tbl, val)
			for k, v in pairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end,

		easeInOut = function(self, t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,

		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, 'not very useful error message here')
			if lower > upper then lower, upper = upper, lower end
			return math.max(lower, math.min(upper, val))
		end,

		in_air = function(self, ent)
			local flags = ent.m_fFlags
			return bit.band(flags, 1) == 0
		end,

		in_duck = function(self, ent)
			local flags = ent.m_fFlags
			return bit.band(flags, 4) == 4
		end,

        get_state = function(self)
			local me = entity.get_local_player()
			local velocity = me.m_vecVelocity:length2d()

			if self:in_air(me) or self.antiaim.air then
				return self:in_duck(me) and 'duck jump' or 'jump'
			else
				if velocity > 3 and (self:in_duck(me) or self.ref.rage.fd:get()) then
					return 'duck move'
				elseif self.ref.antiaim.slowwalk:get() then
					return 'slow walk'
				elseif self:in_duck(me) or self.ref.rage.fd:get() then
					return 'duck'
				else
					return velocity > 1.5 and 'run' or 'stand'
				end
			end
		end,

		get_team = function(self)
			local me = entity.get_local_player()
			local index = me.m_iTeamNum

			return index == 2 and 't' or 'ct'
		end,

        get_charge = function()
			local me = entity.get_local_player()
			local simulation_time = entity.get_local_player().m_flSimulationTime
			return (globals.tickcount - simulation_time / globals.tickinterval)
		end,

        normalize = function(self, angle)
	    	angle =  angle % 360
	    	angle = (angle + 360) % 360
	    	if (angle > 180)  then
	    		angle = angle - 360
	    	end
	    	return angle
	    end,
    }

    :struct 'antiaim' {
		hold_time = 0,
		hold_delay = 0,
		switch_delay = 0,
		modifier_switch_delay = 0,
        body_yaw_switch_delay = 0,
        side = 0,
        body_yaw_side = 0,
		body_yaw_switch = false,
        defensive_switch = false,
		body_yaw_false_ticks = 0,
		inverter_override_ticks = 0,
		last_rand = 0,
		counter = 0,
        run = function (self, cmd)
            local mode = self.ui.menu.aa.mode:get()
            local data
            if mode ~= 'Builder' then
                if self.ui.menu.aa.preset_list:get() == 1 then
                    data = self:setup_data(zane_settings)
				elseif self.ui.menu.aa.preset_list:get() == 2 then
					data = self:setup_data(pirex_settings)

				end

            else
                data = self:setup_data(self.ui.menu.aa.states)
                self.ref.rage.dtlag:override(nil)
            end

            self:set(cmd, data)
        end,

        setup_data = function (self, data)
			local team = self.helpers:get_team()
            local state = self.helpers:get_state()

            if type(data) == 'string' then
                local data = json.parse(data)

				if state ~= 'global' and not data[team][state].enable then
					state = 'global'
				end

				local arr = {}

				for k, v in pairs(data[team][state]) do
					arr[k] = v
				end

				return arr
            else
                if state ~= 'global' and not data[team][state].enable:get() then
                    state = 'global'
                end

                local arr = {}

                for k, v in pairs(data[team][state]) do
                    arr[k] = v:get()
                end

                return arr
            end
        end,

        set = function (self, cmd, data)
            local delay = {1, 2, 4, 12}

            local delayed = true
			local state = self.helpers:get_state()

			local me = entity.get_local_player()
			if me == nil then
				return
			end

			if cmd.choked_commands == 0 and data.delay ~= 1 then
				self.switch_delay = self.switch_delay + 1

				if data.delay_method == 2 then
					if self.switch_delay >= math.random(data.random_delay_value_1, data.random_delay_value_2) then
						self.switch_delay = 0
						self.side = self.side == 1 and 0 or 1
					end
				elseif data.delay_method == 3 then
					if not self.current_slider then
						self.current_slider = 1
					end

					local current_slider_value = tonumber(data["slider_values" .. tostring(self.current_slider)]) or 1

					current_slider_value = math.max(current_slider_value, 1)

					if self.switch_delay >= current_slider_value then
						self.switch_delay = 0
						self.side = self.side == 1 and 0 or 1

						self.current_slider = self.current_slider + 1

						if self.current_slider > data.yaw_sliders then
							self.current_slider = 1
						end
					end
				else
					if self.switch_delay >= data.switch_delay then
						self.switch_delay = 0
						self.side = self.side == 1 and 0 or 1
					end
				end
			elseif cmd.choked_commands == 0 then
				self.side = self.side == 1 and 0 or 1
			end

            if cmd.choked_commands == 0 then
				self.body_yaw_switch_delay = self.body_yaw_switch_delay + 1

				if data.switch_delay == 16 then
					if self.body_yaw_switch_delay >= math.random(1, 8) then
						self.body_yaw_switch_delay = 0

						self.body_yaw_side = self.side == 1 and 0 or 1
					end
				elseif data.body_yaw_switch_delay == 17 then
					if not self.current_slider then
						self.current_slider = 1
					end

					local current_slider_value = tonumber(data["body_yaw_slider_values" .. tostring(self.current_slider)]) or 1

					current_slider_value = math.max(current_slider_value, 1)

					if self.body_yaw_switch_delay >= current_slider_value then
						self.body_yaw_switch_delay = 0
						self.body_yaw_side = self.body_yaw_side == 1 and 0 or 1

						self.current_slider = self.current_slider + 1

						if self.current_slider > data.body_yaw_sliders then
							self.current_slider = 1
						end
					end
				else
					if self.body_yaw_switch_delay >= data.body_yaw_switch_delay then
						self.body_yaw_switch_delay = 0

						self.body_yaw_side = self.body_yaw_side == 1 and 0 or 1
					end
				end
			end

            local yaw_offset = 0
            local fakelimit = 0

			--{'off', 'offset', 'center', 'random', 'rapid'})

            if data.yaw_jitter == 2 then
				self.ref.antiaim.yawmodifier:override('off')
           		self.ref.antiaim.yawmodifieramount:override(0)
                if self.side == 1 then
                    yaw_offset = yaw_offset + data.yaw_jitter_add
                end
            elseif data.yaw_jitter == 3 or data.yaw_jitter == 6 then
				self.ref.antiaim.yawmodifier:override('off')
           		self.ref.antiaim.yawmodifieramount:override(0)
				local value = 0
				if data.modifier_random_enable and data.modifier_random_method == 1 then
					value = utils.random_int(data.modifier_random, data.modifier_random2)
					yaw_offset = yaw_offset + (self.side == 1 and value/2 or -value/2)
				elseif data.modifier_random_enable and data.modifier_random_method == 2 then
					if cmd.choked_commands == 0 then
						self.modifier_switch_delay = self.modifier_switch_delay + 1
					end

					if not self.current_slider then
						self.current_slider = 1
					end

					local current_slider_value = tonumber(data["modifier_random_slider_values" .. tostring(self.current_slider)]) or 1

					current_slider_value = math.max(current_slider_value, 1)

					if self.modifier_switch_delay >= current_slider_value then
						self.current_slider = self.current_slider + 1

						if self.current_slider > data.modifier_random_sliders then
							self.current_slider = 1
						end
					end
					
					if self.current_slider == data.modifier_random_sliders then
						value = math.random(data["modifier_random_slider_values" .. tostring(self.current_slider)], data["modifier_random_slider_values" .. 1])
					else
						value = math.random(data["modifier_random_slider_values" .. tostring(self.current_slider)], data["modifier_random_slider_values" .. tostring(self.current_slider + 1)])
					end

					--value = data["modifier_random_slider_values" .. tostring(self.current_slider)]
					yaw_offset = yaw_offset + (self.side == 1 and value/2 or -value/2)
				else
					yaw_offset = yaw_offset + (self.side == 1 and data.yaw_jitter_add/2 or -data.yaw_jitter_add/2)
				end

				if data.yaw_jitter == 6 then
					for k, v in next, self.ui.globals.strike_cache.ab.should_swap do
						if v and self.ui.globals.strike_cache.ab.time[k] - globals.curtime >= 0 then
							local brute_yaw = self.exploitswitch2 and data.yaw_add_r or data.yaw_add
							yaw_offset = (self.side == 1 and data.yaw_jitter_add/2 or -data.yaw_jitter_add/2) + self.ui.globals.strike_cache.ab.jitteralgo[k]
							break
						end
					end
				end
            elseif data.yaw_jitter == 4 then
				self.ref.antiaim.yawmodifier:override('off')
           		self.ref.antiaim.yawmodifieramount:override(0)
                local rand = (math.random(0, data.yaw_jitter_add) - data.yaw_jitter_add/1.5)
                if not delayed then
                    yaw_offset = yaw_offset + rand

                    self.last_rand = rand
                else
                    yaw_offset = yaw_offset + rand
                end
			elseif data.yaw_jitter == 5 then
				self.ref.antiaim.yawmodifier:override('spin')
				self.ref.antiaim.yawmodifieramount:override(data.yaw_jitter_add)
            else
                self.ref.antiaim.yawmodifier:override('off')
                self.ref.antiaim.yawmodifieramount:override(0)
            end

            if data.yaw_mode == 1 then
				if data.modifier_random_enable and data.modifier_random_method == 1 then
                	yaw_offset = yaw_offset + data.yaw_add2
				else
					yaw_offset = yaw_offset + data.yaw_add2
				end
            else
                yaw_offset = yaw_offset + (self.side == 0 and (data.yaw_add + (utils.random_int(-data.yaw_add_l_random, data.yaw_add_l_random))) or (self.side == 1 and (data.yaw_add_r + (utils.random_int(-data.yaw_add_r_random, data.yaw_add_r_random))) or 0))
			end

			if data.yaw_jitter == 6 then
				if self.counter % math.random(5, 7) == 0 then
					yaw_offset = math.random(-3, 6)
				end
			end

            if data.fakelimit_options == 'jitter' then
                fakelimit = self.side == 0 and data.fakelimit or (data.fakelimit / 2)
            elseif data.fakelimit_options == 'L&R' then
                fakelimit = self.side == 0 and data.fakelimit_l or data.fakelimit_r
            else
                fakelimit = data.fakelimit
            end

			self.ref.antiaim.enable:override(true)
            self.ref.antiaim.pitch:override('down')
			self.ref.antiaim.yawtarget:override(data.yaw_base == 2 and 'At Target' or 'Local view')
			self.ref.antiaim.yaw:override('Backward')
			self.ref.antiaim.yawoffset:override(yaw_offset)

            if data.body_yaw == 1 or data.body_yaw_switch_delay == 1 then
				self.ref.antiaim.inverter:override(self.side == 0)
            else
				self.ref.antiaim.inverter:override(self.body_yaw_side == 0)
            end

			if data.body_yaw == 3 then
				local trigger = math.random(3, 6)

				if globals.tickcount % data.body_yaw_ticks == 0 then
					self.body_yaw_switch = not self.body_yaw_switch
					self.body_yaw_false_ticks = 0
				end

				if not self.body_yaw_switch then
					self.body_yaw_false_ticks = self.body_yaw_false_ticks + 1

				end

				if self.body_yaw_switch then
					self.inverter_override_ticks = self.inverter_override_ticks + 1
				end

				if self.body_yaw_false_ticks >= math.random(2, 6) then
					self.body_yaw_switch = true
					self.body_yaw_false_ticks = 0
				end

				if trigger == 1 or trigger == 1 + 1 then
					trigger = 9
				else
					trigger = trigger + 1
				end

				if self.body_yaw_switch and (self.inverter_override_ticks < math.random(6, 9) and self.inverter_override_ticks > 4) then
					self.ref.antiaim.inverter:override(cmd.command_number % trigger == 0)
					self.inverter_override_ticks = 0
				end

				fakelimit = 60
				self.ref.antiaim.bodyyaw:override(self.body_yaw_switch)
			else
				self.ref.antiaim.bodyyaw:override(nil)
			end

            self.ref.antiaim.leftfake:override(fakelimit)
			self.ref.antiaim.rightfake:override(fakelimit)
            self.ref.antiaim.antibackstab:override(self.helpers:contains(self.ui.menu.aa.options:get(), 'Avoid Backstab'))

            if (self.helpers:contains(self.ui.menu.aa.options:get(), 'Warmup AA')) then
				--print(1)
                local game_rules = entity.get_game_rules()

                if game_rules == nil then
                    return
                end

                if game_rules.m_bWarmupPeriod then
                    self.ref.antiaim.pitch:override('Disabled')
                    self.ref.antiaim.yawoffset:override((globals.tickcount * (4^4)) % 360)
                    self.ref.antiaim.leftfake:override(0)
                    self.ref.antiaim.rightfake:override(0)
                end
            end

			local weapon = entity.get_local_player():get_player_weapon()
			local class = ''

			if weapon ~= nil then
				class = weapon:get_classname()
			end

			local threat = entity.get_threat()
			local pos = entity.get_local_player():get_origin() or {}
			local hg = false
            local dist = false
			if threat ~= nil then
				local epos = threat:get_origin()
				if epos.z - pos.z < -60 then
					hg = true
				end
                if epos.x - pos.x < - 1500 then
                    dist = true
                end
			end

			if globals.choked_commands == 0 then
				self.counter = self.counter + 1
				self.defensive_switch = not self.defensive_switch
			end

            if (self.helpers:contains(self.ui.menu.aa.options:get(), 'Hide Head')) then
                if (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Standing') and string.find(state, 'stand'))
                or (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Crouch') and state == 'duck')
                or (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Air Crouch Knife') and state == 'duck jump' and class == 'CKnife')
                or (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Taser In Air') and string.find(state, 'jump') and class == 'CWeaponTaser')
                or (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Height Advantage') and hg)
                or (self.helpers:contains(self.ui.menu.aa.hidehead_options:get(), 'Distance') and dist)
                then
                    self.ref.antiaim.yawoffset:override(5)
                    self.ref.antiaim.yawmodifier:override('Offset')
                    self.ref.antiaim.yawmodifieramount:override(0)
                    self.ref.antiaim.leftfake:override(0)
                    self.ref.antiaim.rightfake:override(0)
                    self.ref.antiaim.inverter:override(false)
                    self.ref.antiaim.hidden:override(false)
                end
			end

            --defensive aa
            if data.defensivebuilder_enable == 2 then
                if data.defensive_pitch == 'Up' then
                    rage.antiaim:override_hidden_pitch(-89)
                elseif data.defensive_pitch == 'Down' then
                    rage.antiaim:override_hidden_pitch(89)
                elseif data.defensive_pitch == 'Custom' then
                    rage.antiaim:override_hidden_pitch(data.defensive_pitch_value)
                end

                if data.defensive_yaw == 'Spin' then
                    rage.antiaim:override_hidden_yaw_offset((globals.tickcount * (2^4)) % 360)
                elseif data.defensive_yaw == 'Static' then
                    rage.antiaim:override_hidden_yaw_offset(-data.defensive_yaw_value)
				elseif data.defensive_yaw == 'Left/Right' then
					rage.antiaim:override_hidden_yaw_offset(-1 * (
						self.side == 1
						and data.defensive_yaw_left_value
						or data.defensive_yaw_right_value
					))
				end
            end

            if data.defensive_activation == 'Hittable' and data.defensivebuilder_enable == 2 then
                local threat = entity.get_threat()
                if entity.get_threat(true) ~= nil then
                    self.ref.antiaim.hidden:override(true)
                else
                    self.ref.antiaim.hidden:override(false)
                end
            elseif data.defensive_activation == 'Always' and data.defensivebuilder_enable == 2 then
                self.ref.antiaim.hidden:override(true)
            else
                self.ref.antiaim.hidden:override(false)
            end

            if self.helpers:contains(data.defensive_activation_options, 'Weapon switch') then
                if me.m_flNextAttack > globals.curtime then
                    self.ref.rage.dtlag:override('always on')
                end
            end

            if self.helpers:contains(data.defensive_activation_options, 'Weapon reload') then
                if weapon:get_weapon_reload() ~= -1 then
                    self.ref.rage.dtlag:override('always on')
                end
            end

            if self.helpers:contains(data.defensive_activation_options, 'Always') then
                self.ref.rage.dtlag:override('always on')
            end

			local dt_lag_value = self.ref.rage.dtlag:get_override()

			if dt_lag_value == nil then
				dt_lag_value = self.ref.rage.dtlag:get()
			end

			if dt_lag_value == 'Always On' and data.defensive_tickbase then
				rage.exploit:allow_defensive(globals.tickcount % math.random(data.defensive_choke_from, data.defensive_choke_to) == 0)
			end

			if self.ui.menu.aa.manual_aa:get() == 'Left' then
				self.ref.antiaim.yawoffset:override(-90)
				self.ref.antiaim.freestanding:override(false)
				self.ref.antiaim.yawtarget:override('Local view')
			elseif self.ui.menu.aa.manual_aa:get() == 'Right' then
				self.ref.antiaim.yawoffset:override(90)
				self.ref.antiaim.freestanding:override(false)
				self.ref.antiaim.yawtarget:override('Local view')
			elseif self.ui.menu.aa.manual_aa:get() == 'Forward' then
				self.ref.antiaim.yawoffset:override(180)
				self.ref.antiaim.freestanding:override(false)
				self.ref.antiaim.yawtarget:override('Local view')
			elseif self.ui.menu.aa.freestanding:get() and not self.helpers:contains(self.ui.menu.aa.freestanding_disablers:get(), state) then
				self.ref.antiaim.freestanding:override(true)
                if self.helpers:contains(self.ui.menu.aa.yawmodifier:get(), 'Force static') then
                    self.ref.antiaim.yawoffset:override(5)
                    self.ref.antiaim.yawmodifier:override('Offset')
                    self.ref.antiaim.yawmodifieramount:override(0)
                    self.ref.antiaim.leftfake:override(0)
                    self.ref.antiaim.rightfake:override(0)
                    self.ref.antiaim.inverter:override(false)
                    self.ref.antiaim.hidden:override(false)
                end
			else
				self.ref.antiaim.freestanding:override(false)
			end

			if self.helpers:contains(self.ui.menu.aa.options:get(), 'Fluctuate Fakelag') and not self.ref.rage.fd:get() then

				self.ref.rage.fakelag:override((globals.tickcount % 5 == 0) and 1 or 14)
			else
				self.ref.rage.fakelag:override(14)
			end

			self.ref.antiaim.bodyyawopt:override({})
        end
    }

    :struct 'defensive' {
		cmd = 0,
		check = 0,
		defensive = 0,
		player_data = {},

		predict = function(self)
			local tickbase = entity.get_local_player().m_nTickBase
			self.defensive = math.abs(tickbase - self.check)
			self.check = math.max(tickbase, self.check or 0)
			self.cmd = 0
		end,

		reset = function(self)
			self.check, self.defensive = 0, 0
		end,
    }

	:struct 'decors' {
		u8 = function(self, str)
			local chars = { }
			local count = 0

			for c in string.gmatch(str, '.[\128-\191]*') do
				count = count + 1
				chars[count] = c
			end

			return chars, count
		end,

		gradient = function(self, str, time, color_a, color_b)
			local list = { }

			local strbuf, strlen = self:u8(str)
			local div = 1 / (strlen - 1)

			local delta_r = color_b.r - color_a.r
			local delta_g = color_b.g - color_a.g
			local delta_b = color_b.b - color_a.b
			local delta_a = color_b.a - color_a.a

			for i = 1, strlen do
				local char = strbuf[i]

				local t = time do
					t = t % 2

					if t > 1 then
						t = 2 - t
					end
				end

				local r = color_a.r + t * delta_r
				local g = color_a.g + t * delta_g
				local b = color_a.b + t * delta_b
				local a = color_a.a + t * delta_a

				local hex = string.format(
					'%02x%02x%02x%02x',
					r, g, b, a
				)

				table.insert(list, '\a')
				table.insert(list, hex)
				table.insert(list, char)

				time = time + div
			end

			return table.concat(list)
		end
	}

	:struct 'scan' {
		get_hitbox_damage_mult = function(self, hitgroup)
			local HITGROUP_GENERIC  = 0
			local HITGROUP_HEAD     = 1
			local HITGROUP_CHEST    = 2
			local HITGROUP_STOMACH  = 3
			local HITGROUP_LEFTARM  = 4
			local HITGROUP_RIGHTARM	= 5
			local HITGROUP_LEFTLEG  = 6
			local HITGROUP_RIGHTLEG	= 7
			local HITGROUP_GEAR     = 10

			if hitgroup == HITGROUP_HEAD then
				return 4.0
			end

			if hitgroup == HITGROUP_STOMACH then
				return 1.25
			end

			if hitgroup == HITGROUP_LEFTLEG then
				return 0.75
			end

			if hitgroup == HITGROUP_RIGHTLEG then
				return 0.75
			end

			return 1.0
		end,

		scale_damage = function(self, enemy, damage, hitgroup, weapon_armor_ratio)
			damage = damage * self:get_hitbox_damage_mult(hitgroup)

			if enemy.m_ArmorValue > 0 then
				if hitgroup == HITGROUP_HEAD then
					if enemy.m_bHasHelmet then
						damage = damage * (weapon_armor_ratio * 0.5)
					end
				else
					damage = damage * (weapon_armor_ratio * 0.5)
				end
			end

			return damage
		end,

		simulate_damage = function(self, start_pos, end_pos, enemy, hitgroup, data)
			local delta = end_pos - start_pos

			local damage = data.damage
			local armor_ratio = data.armor_ratio

			local range = data.range
			local range_modifier = data.range_modifier

			local length = math.min(range, delta:length())

			damage = damage * math.pow(range_modifier, length * 0.002)
			damage = self:scale_damage(enemy, damage, hitgroup, armor_ratio)

			return damage
		end
	}

	:struct 'watermark' {
		names_for_strike = {
			['boy'] = 'gabriel.ghion',
			['nogo'] = 'junie.sync',
			['vowlhvh'] = 'peteyhook',
			['patrickbad'] = 'gonghook.bird',
			['skeetjepasteachcinl'] = 'burgersense.dev',
		},

		get_simple_text = function(self)
			return 'S T R I K E', '[DEV]'
		end,

		get_strike_text = function(self)
			local text = self.names_for_strike[
				common.get_username()
			]

			if text == nil then
				text = 'strike dev'
			end

			return text
		end,

        render_simple = function (self)
            local ref = self.ui.menu.vis.watermark

            local gap_between = 5
			local font, flags = 1, ''

			local color_a = ref.col:get('Accent')[1]
			local color_b = ref.col:get('Secondary')[1]

            local color_build = ref.build_col:get()

			local pos_variant = ref.position:get()
			local screen_size = render.screen_size()

            local text_1, text_2 = self:get_simple_text()

            local text_size_1 = render.measure_text(font, flags, text_1)
            local text_size_2 = render.measure_text(font, flags, text_2)

            local max_width = text_size_1.x + gap_between + text_size_2.x
            local max_height = math.max(text_size_1.y, text_size_2.y)

			text_1 = self.decors:gradient(
				text_1, -globals.realtime,
				color_a, color_b
			)

			local position = vector(
				20, screen_size.y * 0.5
			)

			if pos_variant == 'Bottom' then
				position.x = (screen_size.x - max_width) * 0.5
				position.y = screen_size.y - 14
			end

			if pos_variant == 'Right' then
				position.x = screen_size.x - position.x
				position.x = position.x - max_width + 1
			end

			position.y = position.y - max_height * 0.5

			local draw_shadow do
				local shadow_pos = vector(position.x, position.y + text_size_1.y / 2)
				render.shadow(shadow_pos, shadow_pos + vector(text_size_1.x, 0), color_a)
			end

            render.text(font, position, color_a, flags, text_1)

            if text_2 ~= nil then
                position.x = position.x + text_size_1.x + gap_between

				local draw_shadow do
					local shadow_pos = vector(position.x, position.y + text_size_2.y / 2)
					render.shadow(shadow_pos, shadow_pos + vector(text_size_2.x, 0), color_build)
				end

                render.text(font, position, color_build, flags, text_2)
            end
        end,

		render_strike = function(self)
			local ref = self.ui.menu.vis.watermark

			local color_a = ref.col:get('Accent')[1]
			local color_b = ref.col:get('Secondary')[1]

			local pos_variant = ref.position:get()
			local screen_size = render.screen_size()

			local font, flags, text = 1, '', self:get_strike_text()
			local text_size = render.measure_text(font, flags, text)

			text = self.decors:gradient(
				text, -globals.realtime,
				color_a, color_b
			)

			local position = vector(
				20, screen_size.y * 0.5
			)

			if pos_variant == 'Bottom' then
				position.x = (screen_size.x - text_size.x) * 0.5
				position.y = screen_size.y - text_size.y - 3
			end

			if pos_variant == 'Right' then
				position.x = screen_size.x - position.x
				position.x = position.x - text_size.x + 1

				position.y = position.y - text_size.y * 0.5
			end

			local draw_shadow do
				local shadow_pos = vector(position.x, position.y + text_size.y / 2)
				render.shadow(shadow_pos, shadow_pos + vector(text_size.x, 0), color_a)
			end

			render.text(font, position, color_a, flags, text)
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.watermark

			local function on_render_simple()
				self:render_simple()
			end

			local function on_render_strike()
				self:render_strike()
			end

			local callbacks do
                local function on_style(item)
                    local value = item:get()

					events.render(on_render_simple, value == 'Simple')
					events.render(on_render_strike, value == 'Strike')
                end

				local function on_enabled(item)
                    local value = item:get()

                    if not value then
                        events.render(on_render_simple, false)
                        events.render(on_render_strike, false)
                    end

                    if value then
                        ref.style:set_callback(on_style, true)
                    else
                        ref.style:unset_callback(on_style)
                    end
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}


	:struct 'hit_marker' {
		hurt_time = 0,

		render = function(self)
			if not globals.is_in_game or self.hurt_time <= 0 then
                return
            end

            local alpha = 1.0

            if self.hurt_time < 0.25 then
                alpha = self.hurt_time / 0.25
            end

            local col = self.ui.menu.vis.hit_marker.col:get()
            local center = render.screen_size() * 0.5

            col.a = col.a * alpha

            render.line(vector(center.x - 10, center.y - 10), vector(center.x - 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y - 10), vector(center.x + 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y + 10), vector(center.x + 5, center.y + 5), col)
            render.line(vector(center.x - 10, center.y + 10), vector(center.x - 5, center.y + 5), col)

            self.hurt_time = math.max(self.hurt_time - globals.frametime, 0.0)
		end,

		player_hurt = function(self, e)
            local me = entity.get_local_player()

            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            if userid == me or attacker ~= me then
                return
            end

            self.hurt_time = 0.5
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.hit_marker

			local function on_render()
				self:render()
			end

			local function on_player_hurt(e)
				self:player_hurt(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					if not value then
						self.hurt_time = 0.0
					end

					events.render(on_render, value)
					events.player_hurt(on_player_hurt, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'kibit_marker' {
		list = { },

		render = function(self)
			if not globals.is_in_game then
                return
            end

            local dt = globals.frametime
            local time = globals.realtime

			local size = self.ui.menu.vis.kibit_marker.size:get()
			local thickness = self.ui.menu.vis.kibit_marker.thickness:get()

			local colors = {
				['Vertical'] = self.ui.menu.vis.kibit_marker.col:get('Vertical')[1],
				['Horizontal'] = self.ui.menu.vis.kibit_marker.col:get('Horizontal')[1]
			}

            for i = #self.list, 1, -1 do
                local data = self.list[i]

                if time > data.time then
                    table.remove(self.list, i)
                end
            end

			for i = 1, #self.list do
                local data = self.list[i]

                local alpha = 1.0

                local liferemaining = data.time - time

                if liferemaining < 0.7 then
                    alpha = liferemaining / 0.7
                end

                local screen = render.world_to_screen(data.point)

                if screen == nil then
                    goto continue
                end

                local thickness = thickness * 0.5
                local size = size + thickness

                local color_h = colors['Horizontal']:clone()
                local color_v = colors['Vertical']:clone()

                local vert_0 = vector(screen.x - thickness, screen.y - size)
                local vert_1 = vector(screen.x + thickness, screen.y + size)

                local hori_0 = vector(screen.x - size, screen.y - thickness)
                local hori_1 = vector(screen.x + size, screen.y + thickness)

                color_h.a = color_h.a * alpha
                color_v.a = color_v.a * alpha

                render.rect(hori_0, hori_1, color_h)
                render.rect(vert_0, vert_1, color_v)

                ::continue::
            end
		end,

		aim_ack = function(self, e)
			local time = globals.realtime + 3.0

            table.insert(self.list, {
                time = time,
                point = e.aim
            })
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.kibit_marker

			local function on_render()
				self:render()
			end

			local function on_aim_ack(e)
				self:aim_ack(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					if not value then
						-- erase data list
						for i = 1, #self.list do
							self.list[i] = nil
						end
					end

					events.render(on_render, value)
					events.aim_ack(on_aim_ack, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'scope_overlay' {
		RESOLUTION = 1 / 1080,

		alpha = smoothy.new(0.0),

		render = function(self)
			local me = entity.get_local_player()

			if me == nil or not me:is_alive() then
				return
			end

			local is_scoped = me.m_bIsScoped

			local alpha = self.alpha(0.05, is_scoped)

			if alpha == 0.0 then
				return
			end

			local screen = render.screen_size()
			local center = screen * 0.5

			local col = self.ui.menu.vis.scope_overlay.col:get()

			local offset = self.ui.menu.vis.scope_overlay.offset:get() * screen.y * self.RESOLUTION
			local position = self.ui.menu.vis.scope_overlay.position:get() * screen.y * self.RESOLUTION

			offset = math.floor(offset)
			position = math.floor(position)

			local delta = position - offset

			local color_a = col:clone()
			local color_b = col:clone()

			color_a.a = color_a.a * alpha
			color_b.a = 0
			if self.ui.menu.vis.scope_overlay.rotate:get() then
				render.push_rotation(45)
			end
			local top_line do
				local pos_a = vector(center.x, center.y - offset + 1)
				local pos_b = vector(pos_a.x + 1, center.y - position)

				render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
			end

			local bottom_line do
				local pos_a = vector(center.x, center.y + offset)
				local pos_b = vector(pos_a.x + 1, center.y + position)

				render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
			end

			local left_line do
				local pos_a = vector(center.x - offset + 1, center.y)
				local pos_b = vector(pos_a.x - delta, center.y + 1)

				render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
			end

			local right_line do
				local pos_a = vector(center.x + offset, center.y)
				local pos_b = vector(pos_a.x + delta, center.y + 1)

				render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
			end
			if self.ui.menu.vis.scope_overlay.rotate:get() then
				render.pop_rotation()
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.scope_overlay

			local function on_render()
				self:render()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					self.ref.visuals.scope_overlay:override(
						value and 'Remove All' or nil
					)

					events.render(on_render, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'grenade_radius' {
		mp_friendlyfire = cvar.mp_friendlyfire,

		smoke_data = { },
		molotov_data = { },

		erase_data = function(self, data)
            for k in pairs(data) do
                data[k] = nil
            end
        end,

		is_molotov_friendly = function(self, ent)
            if self.mp_friendlyfire:int() == 1 then
                return false
            end

            local me = entity.get_local_player()
            local owner = ent.m_hOwnerEntity

            if owner == nil or not owner:is_player() then
                return false
            end

            if me == owner or owner:is_enemy() then
                return false
            end

            return true
        end,

		update_smoke_data = function(self)
            local entities = entity.get_entities(
                'CSmokeGrenadeProjectile'
            )

            local index_map = { }

            for i = 1, #entities do
                local ent = entities[i]

                if not ent.m_bDidSmokeEffect then
                    goto continue
                end

                local index = ent:get_index()

                if self.smoke_data[index] == nil then
                    local origin = ent:get_origin()

                    self.smoke_data[index] = {
                        index = index,
                        origin = origin,

                        alpha = 0.0,
                        radius = 125
                    }
                end

                index_map[index] = true

                ::continue::
            end

            for index in pairs(self.smoke_data) do
                if index_map[index] == nil then
                    self.smoke_data[index] = nil
                end
            end
        end,

		update_molotov_data = function(self)
            local entities = entity.get_entities 'CInferno'

            local index_map = { }

            for i = 1, #entities do
                local ent = entities[i]

                local fire_count = ent.m_fireCount

                if fire_count == 0 then
                    goto continue
                end

                local index = ent:get_index()

                if self.molotov_data[index] == nil then
                    local origin = ent:get_origin()

                    self.molotov_data[index] = {
                        index = index,
                        origin = origin,

                        alpha = 0.0,
                        radius = 0,

                        fire_count = 0,

						friendly = self:is_molotov_friendly(ent)
                    }
                end

                local data = self.molotov_data[index]

                if data.fire_count < fire_count then
                    data.fire_count = fire_count

                    local max_distance_sqr = 0

                    local edge_a = nil
                    local edge_b = nil

                    local cells = { }
                    local cells_count = 0

                    local origin = ent:get_origin()

                    for j = 0, fire_count - 1 do
                        if ent.m_bFireIsBurning[j] then
                            local fire_pos = vector(
                                ent.m_fireXDelta[j],
                                ent.m_fireYDelta[j],
                                ent.m_fireZDelta[j]
                            )

                            cells_count = cells_count + 1
                            cells[cells_count] = fire_pos
                        end
                    end

                    for j = 1, cells_count do
                        for k = 1, cells_count do
                            local pos_a = cells[j]
                            local pos_b = cells[k]

                            local delta = pos_b - pos_a
                            local distsqr = delta:lengthsqr()

                            if max_distance_sqr < distsqr then
                                max_distance_sqr = distsqr

                                edge_a = pos_a
                                edge_b = pos_b
                            end
                        end
                    end

                    if edge_a ~= nil and edge_b ~= nil then
						local origin = ent:get_origin()

						data.origin = origin + (edge_a + edge_b) / 2
						data.radius = math.sqrt(max_distance_sqr) / 2 + 40
                    end
                end

                index_map[index] = true
                ::continue::
            end

            for index in pairs(self.molotov_data) do
                if index_map[index] == nil then
                    self.molotov_data[index] = nil
                end
            end
        end,

		render = function(self)
			local dt = globals.frametime

            local smoke_color = self.ui.menu.vis.grenade_radius.smoke.color:get()
            local molotov_color = self.ui.menu.vis.grenade_radius.molotov.color:get()

            for _, v in pairs(self.smoke_data) do
                v.alpha = math.min(v.alpha + dt * 4.0, 1.0)

                local radius = v.radius * v.alpha

                render.circle_3d_outline(
                    v.origin, smoke_color,
                    radius, 0.0, 1.0, 1
                )
            end

            for _, v in pairs(self.molotov_data) do
                v.alpha = math.min(v.alpha + dt * 4.0, 1.0)

                local radius = v.radius * v.alpha

                render.circle_3d_outline(
                    v.origin, molotov_color,
                    radius, 0.0, 1.0, 1
                )

                local screen_pos = render.world_to_screen(v.origin)

                if screen_pos ~= nil then
                    if v.teammate then
                        render.text(1, screen_pos, color(149, 184, 6, 255), 'c', '✔')
                    else
                        render.text(1, screen_pos, color(230, 21, 21, 255), 'c', '❌')
                    end
                end
            end
		end,

		net_update_end = function(self)
			self:update_smoke_data()
			self:update_molotov_data()
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.grenade_radius

			local function on_update_smoke_data()
				self:update_smoke_data()
			end

			local function on_update_molotov_data()
				self:update_molotov_data()
			end

			local function on_render()
				self:render()
			end

			local callbacks do
				local function on_smoke(item)
					local value = item:get()

					if not value then
						self:erase_data(self.smoke_data)
					end

					events.net_update_start(
						on_update_smoke_data, value
					)
				end

				local function on_molotov(item)
					local value = item:get()

					if not value then
						print(self)

						self:erase_data(self.molotov_data)
					end

					events.net_update_start(
						on_update_molotov_data, value
					)
				end

				local function on_enabled(item)
					local value = item:get()

					if not value then
						self:erase_data(self.smoke_data)
						self:erase_data(self.molotov_data)

						events.net_update_start(on_update_smoke_data, false)
						events.net_update_start(on_update_molotov_data, false)
					end

					if value then
						ref.smoke:set_callback(on_smoke, true)
						ref.molotov:set_callback(on_molotov, true)
					else
						ref.smoke:unset_callback(on_smoke)
						ref.molotov:unset_callback(on_molotov)
					end

					events.render(on_render, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'viewmodel' {
		setup = function(self)
			local ref = self.ui.menu.vis.viewmodel

			local WEAPONTYPE_KNIFE = 0

			-- cache convars to no invoke
			-- hashmap find function
			local cl_righthand = cvar.cl_righthand
			local viewmodel_fov = cvar.viewmodel_fov

			local viewmodel_offset_x = cvar.viewmodel_offset_x
			local viewmodel_offset_y = cvar.viewmodel_offset_y
			local viewmodel_offset_z = cvar.viewmodel_offset_z

			local old_weaponindex = nil

			local function get_original(convar)
				return tonumber(convar:string())
			end

			local function update_knife_hand(is_knife)
				local is_right = cl_righthand:string() == '1'

				if is_right then
					cl_righthand:int(is_knife and 0 or 1, true)
				else
					cl_righthand:int(is_knife and 1 or 0, true)
				end
			end

			local function shutdown_viewmodel()
				viewmodel_fov:float(get_original(viewmodel_fov), false)

				viewmodel_offset_x:float(get_original(viewmodel_offset_x), false)
				viewmodel_offset_y:float(get_original(viewmodel_offset_y), false)
				viewmodel_offset_z:float(get_original(viewmodel_offset_z), false)

				cl_righthand:int(cl_righthand:string() == '1' and 1 or 0, false)
			end

			local function on_shutdown()
				shutdown_viewmodel()
			end

			local function on_pre_render()
				local me = entity.get_local_player()

				if me == nil then
					return
				end

				local weapon = me:get_player_weapon()

				if weapon == nil then
					return
				end

				local weapon_index = weapon:get_weapon_index()

				if old_weaponindex ~= weapon_index then
					old_weaponindex = weapon_index

					local weapon_info = weapon:get_weapon_info()

					if weapon_info == nil then
						return
					end

					local weapon_type = weapon_info.weapon_type
					local is_knife = weapon_type == WEAPONTYPE_KNIFE

					update_knife_hand(is_knife)
				end
			end

			local function update_event_callbacks(value)
				if not value then
					shutdown_viewmodel()
				end

				if not value then
					events.pre_render(on_pre_render, false)
				end

				events.shutdown(on_shutdown, value)
			end

			local callbacks do
				local function on_fov(item)
					viewmodel_fov:float(item:get() * 0.1, true)
				end

				local function on_offset_x(item)
					viewmodel_offset_x:float(item:get() * 0.1, true)
				end

				local function on_offset_y(item)
					viewmodel_offset_y:float(item:get() * 0.1, true)
				end

				local function on_offset_z(item)
					viewmodel_offset_z:float(item:get() * 0.1, true)
				end

				local function on_opposite_knife_hand(item)
					local value = item:get()

					if not value then
						cl_righthand:int(cl_righthand:string() == '1' and 1 or 0, false)
					else
						old_weaponindex = nil
					end

					events.pre_render(on_pre_render, value)
				end

				local function on_enabled(item)
					local value = item:get()

					if value then
						ref.fov:set_callback(on_fov, true)

						ref.offset_x:set_callback(on_offset_x, true)
						ref.offset_y:set_callback(on_offset_y, true)
						ref.offset_z:set_callback(on_offset_z, true)

						ref.opposite_knife_hand:set_callback(on_opposite_knife_hand, true)
					else
						ref.fov:unset_callback(on_fov)

						ref.offset_x:unset_callback(on_offset_x)
						ref.offset_y:unset_callback(on_offset_y)
						ref.offset_z:unset_callback(on_offset_z)

						ref.opposite_knife_hand:unset_callback(on_opposite_knife_hand)
					end

					update_event_callbacks(value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'aspect_ratio' {
		setup = function(self)
			local ref = self.ui.menu.vis.aspect_ratio

			local r_aspectratio = cvar.r_aspectratio

			local function restore_value()
				r_aspectratio:float(tonumber(r_aspectratio:string()), true)
			end

			local function update_value(value)
				r_aspectratio:float(value, true)
			end

			local function on_shutdown()
				restore_value()
			end

			local callbacks do
				local function on_ratio(item)
					update_value(item:get() * 0.01)
				end

				local function on_enabled(item)
					local value = item:get()

					if not value then
						restore_value()
					end

					if value then
						ref.ratio:set_callback(on_ratio, true)
					else
						ref.ratio:unset_callback(on_ratio)
					end

					events.shutdown(on_shutdown, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'damage_indicator' {
		setup = function(self)
			local ref = self.ui.menu.vis.damage_indicator

			local fontmap = {
				['Default'] = 1,
				['Pixel'] = 2
			}

			local function get_damage_text()
				local value = self.ref.rage.dmg:get()

				if value == 0 then
					return 'A'
				end

				if value > 100 then
					return string.format(
						'+%d', value - 100
					)
				end

				return value
			end

			local function on_render()
				local me = entity.get_local_player()

				if me == nil or not me:is_alive() then
					return
				end

				local bind_min_damage = self.binds:get(self.ref.rage.dmg)

				if bind_min_damage == nil or not bind_min_damage.active then
					if ref.if_active:get() then
						return
					end
				end

				local text_color = ref.col:get()

				local screen_size = render.screen_size()

				local center = screen_size / 2
				local position = center:clone()

				local font = fontmap[
					ref.font:get()
				]

				if font == nil then
					return
				end

				local offset = ref.offset:get()

				local flags, text = '', get_damage_text()

				local text_size = render.measure_text(
					font, flags, text
				)

				position.x = position.x + offset + 2
				position.y = position.y - offset

				position.y = position.y - text_size.y

				render.text(font, position, text_color, flags, text)
			end

			local function update_event_callbacks(value)
				events.render(on_render, value)
			end

			local callbacks do
				local function on_enabled(item)
					update_event_callbacks(item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'console_color' {
		ConsoleIsVisible = utils.get_vfunc(
			'engine.dll', 'VEngineClient014', 11, 'bool(__thiscall*)(void*)'
		),

		material_list = {
			materials.get_materials 'vgui_white' [1],
			materials.get 'vgui/hud/800corner1',
			materials.get 'vgui/hud/800corner2',
			materials.get 'vgui/hud/800corner3',
			materials.get 'vgui/hud/800corner4'
		},

		update_color = function(self, col)
			local alpha = col.a / 255

			for i = 1, #self.material_list do
				local material = self.material_list[i]

				material:alpha_modulate(alpha)
				material:color_modulate(col)
			end
		end,

		shutdown = function(self)
			self:update_color(color(255, 255, 255, 255))
		end,

		pre_render = function(self)
			local ref = self.ui.menu.vis.console_color

			if not self.ConsoleIsVisible() then
				self:update_color(color(255, 255, 255, 255))
			else
				self:update_color(ref:get_color())
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.console_color

			local function on_shutdown()
				self:shutdown()
			end

			local function on_pre_render()
				self:pre_render()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					if not value then
						self:update_color(color(255, 255, 255, 255))
					end

					events.shutdown(on_shutdown, value)
					events.pre_render(on_pre_render, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'lc_indicator' {
		fonts = {
			['Default'] = 1,
			['Pixel'] = 2,
			['Bold'] = 4
		},

		status = {
			success = false,
			duration = 0.0,
			distance = nil
		},

		was_charging = true,

		prev_exploit = 0,
		teleport_value = 0,

		lerp = function(self, a, b, t)
			return a + t * (b - a)
		end,

		render = function(self)
			local ref = self.ui.menu.vis.lc_indicator

			local font = self.fonts[
				ref.font:get()
			]

			if font == nil then
				return
			end

			local dt = globals.frametime

			if self.status.duration > 0.0 then
				self.status.duration = self.status.duration - dt
			end

			if self.status.duration <= 0.0 then
				self.status.success = nil
				self.status.duration = 0.0
				self.status.distance = nil
			end

			local screen_size = render.screen_size()
			local position = vector(screen_size.x * 0.5, 0.0)

			local buffer = { } do
				local teleport = self.teleport_value

				if self.status.distance ~= nil then
					teleport = self.status.distance
				end

				table.insert(buffer, string.format(
					'[%s] ', math.floor(teleport)
				))

				table.insert(buffer, 'BREAK LC')

				if self.status.success == true then
					table.insert(buffer, ': SUCCESS')
				end

				if self.status.success == false then
					table.insert(buffer, ': FAILED')
				end
			end

			local text = table.concat(buffer, '')
			local text_size = render.measure_text(font, nil, text)

			local text_color = color(255, 255, 255, 255)

			local rect_pos = position:clone()
			local rect_size = text_size + 8

			rect_pos.x = rect_pos.x - rect_size.x * 0.5
			rect_pos.y = self:lerp(0, screen_size.y - rect_size.y, ref.offset:get() * 0.01)

			local text_pos = rect_pos + (rect_size - text_size) * 0.5

			if self.status.success == true then
				text_color = color(0, 255, 0, 255)
			end

			if self.status.success == false then
				text_color = color(255, 0, 0, 255)
			end

			if ref.background:get() then
				render.rect(rect_pos, rect_pos + rect_size, color(0, 0, 0, 100))
			end

			render.text(font, text_pos + vector(0, -1), text_color, nil, text)
		end,

		entity_update = function(self, c)
			if c.entity ~= entity.get_local_player() then
				return
			end

			local snapshot = lagrecord.get_snapshot(c.entity)

			if snapshot == nil then
				return
			end

			local exploit = rage.exploit:get()

			local prev_teleport = self.teleport_value
			local teleport = snapshot.origin.change

			local charge_delta = exploit - self.prev_exploit
			local max_teleport = math.max(teleport, prev_teleport)

			if charge_delta > 0.0 then
				self.was_charging = true
			end

			if self.was_charging and charge_delta < 0.0 then
				local success = max_teleport > 4096

				if success then
					cvar.play:call('common\\wpn_select.wav')
				end

				self.status.success = success
				self.status.duration = 1.0
				self.status.distance = max_teleport

				self.was_charging = false
			end

			self.prev_exploit = exploit
			self.teleport_value = teleport
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.lc_indicator

			local function on_render()
				self:render()
			end

			local function on_entity_update(c)
				self:entity_update(c)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.render(on_render, value)
					events.entity_update(on_entity_update, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'skeet_indicators' {
		setup = function(self)
			local ref = self.ui.menu.vis.skeet_indicators

			local ZONE = 380
			local SPACING = 8

			local TEXT_OFFSET = 24

			local VERTICAL_PADDING = 4
			local HORIZONTAL_OFFSET = 3

			local FONT = render.load_font(
				'C:\\Windows\\Fonts\\calibrib.ttf',
				vector(25, 23.5, 0), 'a'
			)

			local DrawCmd = { } do
				DrawCmd.__index = DrawCmd

				function DrawCmd:new(id, size)
					return setmetatable({
						id = id,
						size = size
					}, self)
				end

				function DrawCmd:draw(pos, col, ...)
					render.texture(self.id, pos, self.size, col, ...)
				end
			end

			local textures = { } do
				textures.bomb_c4 = render.load_image_from_file(
					'materials\\panorama\\images\\icons\\ui\\bomb_c4.svg', vector(32, 32)
				)
			end

			local draw_commands = { } do
				draw_commands.bomb_c4 = DrawCmd:new(
					textures.bomb_c4, vector(32, 29)
				)
			end

			local draw_queue = { }

			local hit_ratio = 100
			local hit, shots = 0, 0

			-- cache reference variables
			local ref_dormant_aimbot = ui.find(
				'Aimbot', 'Ragebot', 'Main', 'Enabled', 'Dormant Aimbot'
			)

			local ref_double_tap = ui.find(
				'Aimbot', 'Ragebot', 'Main', 'Double Tap'
			)

			local ref_hide_shots = ui.find(
				'Aimbot', 'Ragebot', 'Main', 'Hide Shots'
			)

			local ref_body_aim = ui.find(
				'Aimbot', 'Ragebot', 'Safety', 'Body Aim'
			)

			local ref_safe_points = ui.find(
				'Aimbot', 'Ragebot', 'Safety', 'Safe Points'
			)

			local ref_hit_chance = ui.find(
				'Aimbot', 'Ragebot', 'Selection', 'Hit Chance'
			)

			local ref_hitboxes = ui.find(
				'Aimbot', 'Ragebot', 'Selection', 'Hitboxes'
			)

			local ref_fake_duck = ui.find(
				'Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'
			)

			local ref_freestanding = ui.find(
				'Aimbot', 'Anti Aim', 'Angles', 'Freestanding'
			)

			local ref_fake_latancy = ui.find(
				'Miscellaneous', 'Main', 'Other', 'Fake Latency'
			)

			local ref_feature_list = ref.feature_list

			local function get_value(item)
				local override = item:get_override()

				if override ~= nil then
					return override
				end

				return item:get()
			end

			local function is_bind_active(reference)
				local bind = self.binds:get(reference)

				return bind ~= nil
					and bind.active
			end

			local function clear_draw_queue()
				for i = 1, #draw_queue do
					draw_queue[i] = nil
				end
			end

			local function add_indicator_ex(data)
				local text_size = render.measure_text(FONT, nil, data.text)
				local screen_size = render.screen_size()

				text_size.y = text_size.y + VERTICAL_PADDING * 2

				local offset = next(draw_queue) == nil
					and screen_size.y - (screen_size.y - ZONE) / 2
					or draw_queue[#draw_queue].offset - SPACING - text_size.y

				data.offset = offset
				data.text_size = text_size

				table.insert(draw_queue, data)
				return offset
			end

			local function add_indicator(col, text, ...)
				text = table.concat { text, ... }

				return add_indicator_ex {
					text = text,
					color = col
				}
			end

			local function get_csgo_damage(damage, armor_value)
				local armor_ratio = 0.5
				local armor_bonus = 0.5

				if armor_value > 0 then
					local new = damage * armor_ratio
					local armor = (damage - new) * armor_bonus

					if armor > armor_value then
						armor = armor_value * (1.0 / armor_bonus)
						new = damage - armor
					end

					damage = new
				end

				return damage
			end

			local function get_bomb_damage(player, c4)
				local damage_percentage = 1.0

				local damage = 500
				local bomb_radius = damage * 3.5
				local distance_to_me = (c4:get_origin() - player:get_eye_position()):length()
				local sigma = bomb_radius / 3.0
				local gaussian_fallof = math.exp(-distance_to_me * distance_to_me / (2.0 * sigma * sigma))
				local adjusted_damage = damage * gaussian_fallof * damage_percentage

				return get_csgo_damage(adjusted_damage, player.m_ArmorValue)
			end

			local function update_local_indicators(player)
				-- for some reason thru ui.find
				-- is not worked for zane
				local is_min_damage = is_bind_active(self.ref.rage.dmg)
				local is_hit_chance = is_bind_active(ref_hit_chance)

				local is_fake_latency = ref_fake_latancy:get() > 0

				local is_fake_duck = get_value(ref_fake_duck)
				local is_freestanding = get_value(ref_freestanding)

				local is_body_aim = get_value(ref_body_aim) == 'Force'
				local is_safe_points = get_value(ref_safe_points) == 'Force'

				local is_double_tap = get_value(ref_double_tap) and not is_fake_duck
				local is_hide_shots = get_value(ref_hide_shots) and not is_fake_duck and not is_double_tap

				local is_dormant_aimbot = get_value(ref_dormant_aimbot)

				if is_fake_latency and ref_feature_list:get 'Fake Latency' then
					local netchannel = utils.net_channel()

					if netchannel ~= nil then
						local col = nil

						local wish_latency = get_value(ref_fake_latancy)

						local latency = math.clamp(netchannel.latency[0] + netchannel.latency[1], 0.001, 0.2)
						local avg_latency = math.clamp((wish_latency * 0.001) + netchannel.avg_latency[1], 0.001, 0.2)

						local pct = math.clamp(latency / avg_latency, 0.0, 1.0)

						if pct < 0.5 then
							col = color(250, 234, 232, 255)
								:lerp(color(213, 197, 84, 255), pct * 2)
						else
							col = color(213, 197, 84, 255)
								:lerp(color(143, 194, 21, 255), (pct - 0.5) * 2)
						end

						add_indicator(col, 'PING')
					end
				end

				if is_hide_shots and ref_feature_list:get 'Hide Shots' then
					add_indicator(color(255, 255, 255, 200), 'OSAA')
				end

				if is_double_tap and ref_feature_list:get 'Double Tap' then
					local text_color = color(255, 0, 50, 255)

					if rage.exploit:get() == 1 then
						text_color = color(255, 255, 255, 200)
					end

					add_indicator(text_color, 'DT')
				end

				if is_dormant_aimbot and ref_feature_list:get 'Dormant Aimbot' then
					add_indicator(color(255, 255, 255, 200), 'DA')
				end

				if is_fake_duck and ref_feature_list:get 'Fake Duck' then
					add_indicator(color(255, 255, 255, 200), 'DUCK')
				end

				if is_safe_points and ref_feature_list:get 'Safe Points' then
					add_indicator(color(255, 255, 255, 200), 'SAFE')
				end

				if is_body_aim and ref_feature_list:get 'Body Aim' then
					add_indicator(color(255, 255, 255, 200), 'BODY')
				end

				if is_min_damage and ref_feature_list:get 'Damage Override' then
					add_indicator(color(255, 255, 255, 200), 'MD')
				end

				if is_hit_chance and ref_feature_list:get 'Hitchance Override' then
					add_indicator(color(255, 255, 255, 200), 'H1TCHANCE')
				end

				if is_freestanding and ref_feature_list:get 'Freestanding' then
					add_indicator(color(255, 255, 255, 200), 'FS')
				end

				if ref_feature_list:get 'Hit/Miss' then
					add_indicator(color(255, 255, 255, 200), hit_ratio .. '%')
				end
			end

			local function update_player_bomb(player_resource, player)
				local weapon = player:get_player_weapon()

				if weapon == nil then
					return
				end

				local is_started_arming = weapon.m_bStartedArming

				if not is_started_arming then
					return
				end

				local armed_time = weapon.m_fArmedTime

				if armed_time == nil then
					return
				end

				local origin = player:get_origin()

				local bombsite_a = player_resource.m_bombsiteCenterA
				local bombsite_b = player_resource.m_bombsiteCenterB

				local distancesqr_a = origin:distsqr(bombsite_a)
				local distancesqr_b = origin:distsqr(bombsite_b)

				local bombsite = distancesqr_a < distancesqr_b and 'A' or 'B'

				local planting_time = armed_time - globals.curtime
				local progress_percent = planting_time / 3.0

				add_indicator_ex {
					text = bombsite,
					color = color(252, 243, 105, 255),

					progress = 1 - progress_percent,
					draw_cmd = draw_commands.bomb_c4
				}
			end

			local function update_planted_bomb(me, c4)
				local is_defused = c4.m_bBombDefused
				local is_bomb_ticking = c4.m_bBombTicking

				if not is_bomb_ticking or is_defused then
					return
				end

				local curtime = globals.curtime

				local blow_time = c4.m_flC4Blow
				local remaining_time = blow_time - curtime

				if remaining_time > 0 then
					local defuser = c4.m_hBombDefuser

					if defuser ~= nil then
						local screen_size = render.screen_size()

						local count_down = c4.m_flDefuseCountDown
						local defuse_time = count_down - curtime

						local progress_percent = defuse_time / 10

						local col = blow_time < count_down
							and color(235, 50, 75, 125)
							or color(50, 235, 75, 125)

						local height = (screen_size.y - 2) * (1 - progress_percent)

						render.rect(vector(0, 0), vector(20, screen_size.y), color(0, 0, 0, 115))
						render.rect(vector(1, 1 + height), vector(19, screen_size.y - 1), col)
					end

					local text = string.format(
						'%s - %.1fs', c4.m_nBombSite == 1 and 'B' or 'A', remaining_time
					)

					add_indicator_ex {
						text = text,
						color = color(255, 255, 255, 200 ),

						draw_cmd = draw_commands.bomb_c4
					}
				end

				local health = me.m_iHealth
				local damage = get_bomb_damage(me, c4)

				damage = math.floor(damage)

				if health <= damage then
					add_indicator(color(255, 0, 50, 255), 'FATAL')
				elseif damage > 0 then
					add_indicator(color(252, 243, 105, 255), string.format('-%d HP', damage))
				end
			end

			local function update_bomb_indicators(me)
				local game_rules = entity.get_game_rules()

				if game_rules == nil then
					return
				end

				local player_resource = entity.get_player_resource()

				if player_resource == nil then
					return
				end

				local is_planted = game_rules.m_bBombPlanted
				local player_c4 = player_resource.m_iPlayerC4

				if player_c4 ~= nil and player_c4 ~= 0 then
					local player = entity.get(player_c4)

					if player ~= nil then
						update_player_bomb(player_resource, player)
					end
				end

				if is_planted then
					local planted_c4 = entity.get_entities 'CPlantedC4' [1]

					if planted_c4 ~= nil then
						update_planted_bomb(me, planted_c4)
					end
				end
			end

			local function update_indicators()
				local me = entity.get_local_player()

				if me == nil then
					return
				end

				if me:is_alive() then
					update_local_indicators(me)
				end

				if ref_feature_list:get 'Bomb Info' then
					update_bomb_indicators(me)
				end
			end

			local function draw_shadow(pos_a, pos_b)
				local center = (pos_a + pos_b) / 2

				local col_begin = color(0, 0, 0, 0)
				local col_finish = color(0, 0, 0, 50)

				render.gradient(pos_a, vector(center.x, pos_b.y), col_begin, col_finish, col_begin, col_finish)
				render.gradient(pos_b, vector(center.x, pos_a.y), col_begin, col_finish, col_begin, col_finish)
			end

			local function draw_progress_circle(pos, col, radius, start_degrees, percentage, thickness)
				render.circle_outline(pos, color(0, 0, 0, 255), radius, start_degrees, 1.0, thickness)
				render.circle_outline(pos, col, radius - 1, start_degrees, percentage, thickness - 2)
			end

			local function draw_indicators()
				for i = 1, #draw_queue do
					local data = draw_queue[i]

					if data.color == nil then
						goto continue
					end

					local position = vector(HORIZONTAL_OFFSET, data.offset)

					local text_pos = position + vector(TEXT_OFFSET, VERTICAL_PADDING)
					local text_size = data.text_size + vector(50)

					local col = data.color

					local draw_cmd = data.draw_cmd
					local progress = data.progress

					text_pos.y = text_pos.y + 2

					if draw_cmd ~= nil then
						text_size.x = text_size.x + draw_cmd.size.x + 5
					end

					if progress ~= nil then
						text_size.x = text_size.x + 30
					end

					draw_shadow(position, position + text_size)

					if draw_cmd ~= nil then
						local texture_pos = position:clone()

						texture_pos.x = texture_pos.x + TEXT_OFFSET
						texture_pos.y = texture_pos.y + (text_size.y - draw_cmd.size.y) / 2

						draw_cmd:draw(texture_pos, col, 'f')

						text_pos.x = text_pos.x + draw_cmd.size.x + 5
					end

					render.text(FONT, text_pos + 1, color(0, 0, 0, 128), '', data.text)
					render.text(FONT, text_pos, col, '', data.text)

					text_pos.x = text_pos.x + data.text_size.x

					if progress ~= nil then
						local radius = 10

						local circle_x = text_pos.x + (radius / 2) + 12
						local circle_y = position.y + text_size.y / 2

						local circle_pos = vector(circle_x, circle_y)
						local circle_col = color(255, 255, 255, 200)

						draw_progress_circle(circle_pos, circle_col, 10, 0, progress, 5)
					end

					::continue::
				end
			end

			local function on_render()
				if globals.is_in_game then
					update_indicators()
					draw_indicators()
				end

				clear_draw_queue()
			end

			local function on_aim_ack(e)
				local is_invalid_shot = (
					e.state == 'death' or
					e.state == 'player death' or
					e.state == 'unregistered shot'
				)

				if is_invalid_shot then
					return
				end

				shots = shots + 1

				if e.state == nil then
					hit = hit + 1
				end

				hit_ratio = math.floor(hit / math.max(1, shots) * 100)
			end

			local function update_event_callbacks(value)
				events.render(on_render, value)
				events.aim_ack(on_aim_ack, value)
			end

			local callbacks do
				local function on_enabled(item)
					update_event_callbacks(item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'skeet_grenade' {
		setup = function(self)
			local ref = self.ui.menu.vis.skeet_grenade

			local UNITS_TO_FOOT = 0.0254 * 3.28084

			local warning = { } do
				local GetCreationTime = utils.get_netvar_offset('DT_BaseCSGrenadeProjectile', 'm_nExplodeEffectTickBegin') + 0x10

				local DEFAULT_WARNING_RADIUS = 30

				local MIN_UPSCALE_DISTANCE = 48
				local MAX_UPSCALE_DISTANCE = 204

				local DELTA_UPSCALE_DISTANCE = MAX_UPSCALE_DISTANCE - MIN_UPSCALE_DISTANCE

				local function get_creation_time(entity)
					return ffi.cast('float*', ffi.cast('unsigned long', entity[0]) + GetCreationTime)[0]
				end

				local function get_radius_upscale(distance)
					local clamped = math.clamp(distance, MIN_UPSCALE_DISTANCE, MAX_UPSCALE_DISTANCE)
					local upscale = 1.0 - (clamped - MIN_UPSCALE_DISTANCE) / DELTA_UPSCALE_DISTANCE

					return upscale * upscale
				end

				local function get_warning_radius(distance)
					local upscale = get_radius_upscale(distance) * 20

					return DEFAULT_WARNING_RADIUS + upscale
				end

				local function get_warning_percent(e)
					local is_projectile = e.entity['m_nExplodeEffectTickBegin'] ~= nil

					local remaining_time = e.expire_time - globals.curtime

					local expire_time = not is_projectile and 7.0
						or e.expire_time - get_creation_time(e.entity)

					return remaining_time / expire_time
				end

				local function get_warning_text(e, distance)
					if e.type == 'Molly' then
						return math.ceil(distance * 0.0798)
					end

					return e.damage
				end

				local function get_screen_position(e, radius)
					local pos = render.get_offscreen(e.origin, 0.9, true)
					local screen_size = render.screen_size()

					pos.x = math.clamp(pos.x, radius, screen_size.x - radius)
					pos.y = math.clamp(pos.y, radius, screen_size.y - radius)

					return pos
				end

				local function is_beign_drawn(e, me)
					local position = me:get_origin()

					local threshold = e.type == 'Frag'
						and 350 or 408

					local distance = position:distsqr(e.origin)

					return distance <= threshold * threshold
				end

				local function render_warning_gradient(e, pos, radius, distance)
					if e.type == 'Frag' then
						if e.damage == 0 then
							return nil
						end

						local damage = math.clamp(e.damage, 0, 55)
						local weight = damage / 55

						weight = math.sqrt(weight)

						local inner = color():as_hsl(
							0, 1.0, 0.5 * weight, 0.685
						)

						outer = inner:clone()
						outer.a = 0

						render.circle_gradient(pos, outer, inner, radius, 0, 1.0)

						return nil
					end

					if e.type == 'Molly' then
						if distance > 155 then
							return nil
						end

						local inner = color(255, 0, 0, 175)

						outer = inner:clone()
						outer.a = 0

						render.circle_gradient(pos, outer, inner, radius, 0, 1.0)

						return nil
					end
				end

				local function draw_grenade_warning(e, origin)
					local distance = origin:dist(e.closest_point)

					local radius = get_warning_radius(distance)
					local pos = get_screen_position(e, radius)

					if pos == nil then
						return false
					end

					if e.type ~= 'Molly' and e.damage == 0 then
						return
					end

					local percent = get_warning_percent(e)

					render.circle(pos, color(0, 0, 0, 200), radius, 0, 1.0)
					render_warning_gradient(e, pos, radius, distance)

					render.circle_outline(pos, color(255, 255, 255, 200), radius - 1, 0, percent, 2)

					local texture = e.icon do
						local icon_color = color(255, 255, 255, 230)

						local icon_size = vector(texture.width, texture.height) * 1.0
						local icon_pos = pos - icon_size / 2 - vector(0, 10)

						render.texture(texture, icon_pos, icon_size, icon_color)
					end

					local text = get_warning_text(e, distance) do
						local text_pos = pos + vector(0, 12)
						local text_color = color(255, 255, 255, 230)

						render.text(4, text_pos, text_color, 'c', text)
					end
				end

				function warning.on_grenade_warning(e)
					local me = entity.get_local_player()

					if me == nil then
						return false
					end

					if not is_beign_drawn(e, me) then
						return false
					end

					local origin = me:get_origin()

					if origin == nil then
						return false
					end

					draw_grenade_warning(e, origin)
					return false
				end
			end

			local trajectory = { } do
				local last_event = nil

				local ref_path_color = ui.find(
					'Visuals', 'World', 'Other', 'Grenade Prediction', 'Color'
				)

				local ref_color_hit = {
					ui.find('Visuals', 'World', 'Other', 'Grenade Prediction', 'Color Hit')
				}

				local function render_point(position, col)
					render.circle(position, col, 2.4, 0, 1.0)
					render.circle_outline(position, color(0, 0, 0, 128), 3.5, 0, 1.0, 1)
				end

				local function draw_prediction(e)
					local paths = #e.path
					local collisions = #e.collisions

					if paths == 1 then
						return
					end

					local damage = e.damage
					local is_hit = damage > 0

					local prev_position = nil

					local line_color = is_hit and ref_color_hit[1]:get()
						and ref_color_hit[2]:get() or ref_path_color:get()

					for i = 1, paths do
						local position = render.world_to_screen(e.path[i])

						if prev_position ~= nil and position ~= nil then
							render.poly_line(line_color, position + 1, prev_position + 1)
						end

						prev_position = position
					end

					for i = 1, collisions - 1 do
						local position = render.world_to_screen(e.collisions[i])

						if position == nil then
							goto continue
						end

						render_point(position, color(255, 255, 255, 200))

						::continue::
					end

					local point = e.path[paths] do
						local position = render.world_to_screen(point)

						if position == nil then
							goto continue
						end

						local target = e.target

						local point_color = is_hit
							and color(0, 255, 40, 255)
							or color(255, 0, 40, 255)

						render_point(position, point_color)

						if target ~= nil then
							local origin = target:get_origin()
							local distance = origin:dist(point)

							local feets = distance * UNITS_TO_FOOT
							local health = target.m_iHealth

							local text_pos = vector(position.x, position.y - 10)

							if e.type == 'Molly' and feets <= 14.5 then
								local text_color = feets < 12.5
									and color(129, 171, 52, 255)
									or color(255, 255, 255, 200)

								render.text(1, text_pos, text_color, 'c', string.format('%.1f ft', feets))
							end

							if e.type == 'Frag' and is_hit then
								local is_critical = damage > 50
									or damage >= health

								local text_color = is_critical
									and color(129, 171, 52, 255)
									or color(255, 255, 255, 200)

								render.text(1, text_pos, text_color, 'c', string.format('%d dmg', damage))
							end
						end

						::continue::
					end
				end

				function trajectory.render()
					if last_event ~= nil then
						draw_prediction(last_event)
					end

					last_event = nil
				end

				function trajectory.grenade_prediction(e)
					last_event = e
					return false
				end
			end

			local callbacks do
				local function on_warning(item)
					events.grenade_warning(warning.on_grenade_warning, item:get())
				end

				local function on_trajectory(item)
					local value = item:get()

					events.render(trajectory.render, value)
					events.grenade_prediction(trajectory.grenade_prediction, value)
				end

				local function on_enabled(item)
					local value = item:get()

					if not value then
						events.render(trajectory.render, false)
						events.grenade_warning(warning.on_grenade_warning, false)
						events.grenade_prediction(trajectory.grenade_prediction, false)
					end

					if value then
						ref.warning:set_callback(on_warning, true)
						ref.trajectory:set_callback(on_trajectory, true)
					else
						ref.warning:unset_callback(on_warning)
						ref.trajectory:unset_callback(on_trajectory)
					end
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'damage_helper' {
		info = nil,

		fontmap = {
			['Default'] = 1,
			['Bold'] = 4
		},

		is_weapon_gun = function(self, weapon_info)
			return weapon_info.max_clip1 > 0
		end,

		get_damage_info = function(self)
			local me = entity.get_local_player()

			if me == nil then
				return nil
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return nil
			end

			local weapon_info = weapon:get_weapon_info()

			if weapon_info == nil then
				return nil
			end

			if not self:is_weapon_gun(weapon_info) then
				return nil
			end

			local info = { }

			local eye_pos = me:get_eye_position()
			local enemies = entity.get_players(true)

			for i = 1, #enemies do
				local enemy = enemies[i]

				if not enemy:is_alive() then
					goto continue
				end

				local stomach = enemy:get_hitbox_position(3)

				local damage = self.scan:simulate_damage(
					eye_pos, stomach, enemy, 3, weapon_info
				)

				info[enemy:get_index()] = damage

				::continue::
			end

			return info
		end,

		get_player_damage = function(self, player)
			local info = self.info

			if info == nil then
				return nil
			end

			local damage = info[player]

			if damage == nil then
				return nil
			end

			return damage
		end,

		render = function(self)
			local info = self.info

			if info == nil then
				return
			end

			local flags, font = '', self.fontmap[
				self.ui.menu.vis.damage_helper.font:get()
			]

			if font == nil then
				return
			end

			local enemies = entity.get_players(true)

			for i = 1, #enemies do
				local enemy = enemies[i]

				local damage = self:get_player_damage(
					enemy:get_index()
				)

				if damage == nil then
					goto continue
				end

				local bbox = enemy:get_bbox()

				local is_bbox_valid = (
					bbox ~= nil
					and bbox.pos1 ~= nil
					and bbox.pos2 ~= nil
					and bbox.alpha ~= nil
				)

				if not is_bbox_valid then
					return false
				end

				local pos1 = bbox.pos1
				local pos2 = bbox.pos2

				local width = pos2.x - pos1.x

				local position = vector(
					pos1.x + width / 2,
					pos1.y - 12
				)

				local text = string.format(
					'- \aFF6464FF%d\aDEFAULT -', damage
				)

				local text_size = render.measure_text(font, flags, text)

				position.x = position.x - text_size.x / 2
				position.y = position.y - text_size.y

				render.text(font, position, color(), flags, text)

			    ::continue::
			end
		end,

		createmove = function(self)
			self.info = self:get_damage_info()
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.damage_helper

			local function on_render()
				self:render()
			end

			local function on_createmove()
				self:createmove()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.render(on_render, value)
					events.createmove(on_createmove, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'revolver_helper' {
		info = nil,

		get_info = function(self)
			return self.info
		end,

		get_damage_info = function(self)
			local me = entity.get_local_player()

			if me == nil then
				return nil
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return nil
			end

			local weapon_info = weapon:get_weapon_info()

			if weapon_info == nil then
				return nil
			end

			if not weapon_info.is_revolver then
				return nil
			end

			local threat = entity.get_threat()

			if threat == nil then
				return nil
			end

			local health = threat.m_iHealth

			local eye_pos = me:get_eye_position()
			local stomach = threat:get_hitbox_position(3)

			local damage = self.scan:simulate_damage(
				eye_pos, stomach, threat, 3, weapon_info
			)

			local info = { }

			info.target = threat
			info.damage = damage
			info.health = health

			return info
		end,

		get_line_render_pos = function(self, player)
			if self.ref.visuals.force_thirdperson:get() then
				return render.world_to_screen(
					player:get_hitbox_position(3)
				)
			end

			local screen = render.screen_size()
			return vector(screen.x / 2, screen.y)
		end,

		render = function(self)
			local me = entity.get_local_player()

			if me == nil then
				return nil
			end

			local threat = entity.get_threat()

			if threat == nil then
				return nil
			end

			local info = self.info

			if info == nil then
				return
			end

			if info.damage < info.health then
				return
			end

			local text = 'DMG'
			local text_col = color(255, 0, 0, 255)

			if info.damage > info.health + 1 then
				text = text .. '+'
				text_col = color(50, 205, 50, 255)
			end

			local line_render do
				local stomach = threat:get_hitbox_position(3)

				local screen_a = self:get_line_render_pos(me)
				local screen_b = render.world_to_screen(stomach)

				if screen_a ~= nil and screen_b ~= nil then
					render.line(screen_a, screen_b, color(255, 0, 0, 255))
				end
			end

			local idx = threat:get_index()
			local bbox = threat:get_bbox()

			local is_bbox_valid = (
				bbox ~= nil
				and bbox.pos1 ~= nil
				and bbox.pos2 ~= nil
				and bbox.alpha ~= nil
			)

			if is_bbox_valid then
				local font, flags = 4, ''

				local pos1 = bbox.pos1
				local pos2 = bbox.pos2

				local width = pos2.x - pos1.x

				local position = vector(
					pos1.x + width / 2,
					pos1.y - 12
				)

				if self.ui.menu.vis.damage_helper:get() then
					local damage = self.damage_helper:get_player_damage(idx)

					if damage ~= nil then
						position.y = position.y - 12
					end
				end

				local text_size = render.measure_text(font, flags, text)

				position.x = position.x - text_size.x / 2
				position.y = position.y - text_size.y

				render.text(font, position, text_col, flags, text)
			end
		end,

		createmove = function(self)
			self.info = self:get_damage_info()
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.revolver_helper

			local function on_render()
				self:render()
			end

			local function on_createmove()
				self:createmove()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.render(on_render, value)
					events.createmove(on_createmove, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'lagcomp_debug' {
		sv_gravity = cvar.sv_gravity,
		sv_jump_impulse = cvar.sv_jump_impulse,

		sim_ticks = { },
		net_data = { },
		esp_data = { },

		extrapolate = function(self, ent, origin, ticks)
			local tickinterval = globals.tickinterval

			local sv_gravity = self.sv_gravity:float() * tickinterval
			local sv_jump_impulse = self.sv_jump_impulse:float() * tickinterval

			local p_origin, prev_origin = origin, origin

			local velocity = ent.m_vecVelocity

			local gravity = velocity.z > 0
				and -sv_gravity or sv_jump_impulse

			for _ = 1, ticks do
				prev_origin = p_origin

				p_origin = vector(
					p_origin.x + (velocity.x * tickinterval),
					p_origin.y + (velocity.y * tickinterval),
					p_origin.z + (velocity.z + gravity) * tickinterval
				)

				local tr = utils.trace_line(
					prev_origin, p_origin
				)

				if tr.fraction <= 0.99 then
					return prev_origin
				end
			end

			return p_origin
		end,

		get_active_players = function(self, me)
			local observer_mode = me.m_iObserverMode

			if observer_mode == 0 or observer_mode == 1 or observer_mode == 2 or observer_mode == 6 then
				return entity.get_players(true, true)
			end

			local active_players = { }

			if observer_mode == 4 or observer_mode == 5 then
				local players = entity.get_player(false, true)

				local observer_target = me.m_hObserverTarget
				local observer_target_team = observer_target.m_iTeamNum

				for i = 1, #players do
					local player = players[i]

					if player == me or player.m_iTeamNum == observer_target_team then
						goto continue
					end

					table.insert(active_players, player)

				    ::continue::
				end
			end

			return active_players
		end,

		render = function(self)
			local ref = self.ui.menu.vis.lagcomp_debug

			local me = entity.get_local_player()

			if me == nil or not me:is_alive() then
				return
			end

			local box_color = ref.box_color:get()
			local text_color = ref.text_color:get()

			local active_players = self:get_active_players(me)

			if #active_players == 0 then
				return
			end

			for idx, net_data in pairs(self.net_data) do
				local player = entity.get(idx)

				local is_valid_player = (
					player ~= nil
					and player:is_alive()
					and player:is_enemy()
				)

				if not is_valid_player then
					goto continue
				end

				if net_data.lagcomp then
					local predicted_pos = net_data.predicted_origin

					local min = predicted_pos + player.m_vecMins
					local max = predicted_pos + player.m_vecMaxs

					local points = {
						vector(min.x, min.y, min.z), vector(min.x, max.y, min.z),
						vector(max.x, max.y, min.z), vector(max.x, min.y, min.z),
						vector(min.x, min.y, max.z), vector(min.x, max.y, max.z),
						vector(max.x, max.y, max.z), vector(max.x, min.y, max.z)
					}

					local edges = {
						{0, 1},
						{1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8},
						{0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}
					}

					for i = 1, #edges do
						if i == 1 then
							local origin = player:get_origin()

							local min_w2s = render.world_to_screen(min)
							local origin_w2s = render.world_to_screen(origin)

							if min_w2s ~= nil and origin_w2s ~= nil then
								render.line(min_w2s, origin_w2s, box_color)
							end
						end

						local point_a = points[edges[i][1]]
						local point_b = points[edges[i][2]]

						if point_a ~= nil and point_b ~= nil then
							local p1 = render.world_to_screen(point_a)
							local p2 = render.world_to_screen(point_b)

							if p1 ~= nil and p2 ~= nil then
								render.line(p1, p2, box_color)
							end
						end
					end
				end

				local bbox = player:get_bbox()

				local is_bbox_valid = (
					bbox ~= nil
					and bbox.pos1 ~= nil
					and bbox.pos2 ~= nil
					and bbox.alpha ~= nil
				)

				if not is_bbox_valid then
					goto continue
				end

				local palpha = 0

				if self.esp_data[idx] > 0 then
					self.esp_data[idx] = self.esp_data[idx] - globals.frametime * 2
					self.esp_data[idx] = self.esp_data[idx] < 0 and 0 or self.esp_data[idx]

					palpha = self.esp_data[idx]
				end

				local tb = net_data.tickbase or self.esp_data[idx] > 0
				local lc = net_data.lagcomp

				if not tb or net_data.lagcomp then
					palpha = bbox.alpha
				end

				local text_map = {
					[0] = '',
					[1] = 'LAG COMP BREAKER',
					[2] = 'SHIFTING TICKBASE'
				}

				if bbox.alpha > 0 then
					local name = player:get_name()
					local y_add = name == '' and -8 or 0

					local width = bbox.pos2.x - bbox.pos1.x

					local text_pos = vector(
						bbox.pos1.x + width / 2,
						bbox.pos1.y - 18 + y_add
					)

					local text_color = text_color:clone()
					text_color.a = text_color.a * palpha

					local text = text_map[
						tb and 2 or (lc and 1 or 0)
					]

					if self.ui.menu.vis.damage_helper:get() then
						local damage = self.damage_helper:get_player_damage(idx)

						if damage ~= nil then
							text_pos.y = text_pos.y - 12
						end
					end

					if self.ui.menu.vis.revolver_helper:get() then
						local info = self.revolver_helper:get_info()

						if info ~= nil and info.damage >= info.health then
							text_pos.y = text_pos.y - 12
						end
					end

					render.text(1, text_pos, text_color, 'c', text)
				end

				::continue::
			end
		end,

		net_update_end = function(self)
			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local enemies = entity.get_players(true, true)

			for i = 1, #enemies do
				local enemy = enemies[i]

				local idx = enemy:get_index()
				local prev_tick = self.sim_ticks[idx]

				if enemy:is_dormant() or not enemy:is_alive() then
					self.sim_ticks[idx] = nil
					self.net_data[idx] = nil
					self.esp_data[idx] = nil

					goto continue
				end

				local player_origin = enemy.m_vecOrigin
				local simulation_time = to_ticks(enemy.m_flSimulationTime)

				if prev_tick ~= nil then
					local delta = simulation_time - prev_tick.tick

					if delta < 0 or delta > 0 and delta <= 64 then
						local m_fFlags = enemy.m_fFlags

						local diff_origin = player_origin - prev_tick.origin
						local teleport_distance = diff_origin:length2dsqr()

						--print(teleport_distance)

						local extrapolated = self:extrapolate(
							enemy, player_origin, delta - 1
						)

						if delta < 0 then
							self.esp_data[idx] = 1
						end

						self.net_data[idx] = {
							tick = delta - 1,

							origin = player_origin,
							predicted_origin = extrapolated,

							tickbase = delta < 0,
							lagcomp = teleport_distance > 4096
						}
					end
				end

				if self.esp_data[idx] == nil then
					self.esp_data[idx] = 0
				end

				self.sim_ticks[idx] = {
					tick = simulation_time,
					origin = player_origin
				}

				::continue::
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.lagcomp_debug

			local function on_render()
				self:render()
			end

			local function on_net_update_end()
				self:net_update_end()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.render(on_render, value)
					events.net_update_end(on_net_update_end, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'drop_nades' {
		ref_antiaim_enabled = ui.find(
			'Aimbot', 'Anti Aim', 'Angles', 'Enabled'
		),

		queue = { },

		throwing = false,
		old_state = nil,

		is_allowed_class = function(self, console_name)
			local ref = self.ui.menu.misc.drop_nades

			if console_name == 'weapon_hegrenade' then
				return ref.selection:get 'HE'
			end

			if console_name == 'weapon_smokegrenade' then
				return ref.selection:get 'Smoke'
			end

			if console_name == 'weapon_incgrenade' or console_name == 'weapon_molotov' then
				return ref.selection:get 'Molotov'
			end

			return false
		end,

		is_weapon_allowed = function(self, weapon)
			local info = weapon:get_weapon_info()

			if info.weapon_type ~= 9 then
				return false
			end

			if not self:is_allowed_class(info.console_name) then
				return false
			end

			return true
		end,

		clear_queue = function(self)
			for i = 1, #self.queue do
				self.queue[i] = nil
			end
		end,

		update_queue = function(self, ent)
			local weapons = ent:get_player_weapon(true)

			for i = 1, #weapons do
				local weapon = weapons[i]

				if not self:is_weapon_allowed(weapon) then
					goto continue
				end

				table.insert(self.queue, weapon)

				::continue::
			end
		end,

		createmove = function(self, cmd)
			local ref = self.ui.menu.misc.drop_nades

			if ref == nil then
				return
			end

			self.ref_antiaim_enabled:override()

			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return
			end

			local nci = utils.net_channel()

			if nci == nil then
				return
			end

			local state = ref.hotkey:get()

			if self.old_state ~= state then
				self.old_state = state

				if state and not self.throwing then
					self:clear_queue()
					self:update_queue(me)

					self.throwing = next(self.queue) ~= nil
				end
			end

			local latency = nci.latency[1] + to_time(4)

			for i = 1, #self.queue do
				local grenade = self.queue[i]

				if grenade == nil then
					goto continue
				end

				local weapon_info = grenade:get_weapon_info()

				if weapon_info == nil then
					goto continue
				end

				local last = i == #self.queue

				utils.execute_after(latency * i, function()
					utils.console_exec(string.format(
						'use %s; drop', weapon_info.console_name
					))

					if last then
						utils.execute_after(0.1, function()
							self.throwing = false
						end)
					end
				end)

				::continue::
			end

			self:clear_queue()

			if self.throwing then
				cmd.no_choke = true
				cmd.send_packet = true

				self.ref_antiaim_enabled:override(false)
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.drop_nades

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.createmove(on_createmove, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'super_toss' {
		GRENADE_SECONDARY_DAMPENING = 0.3,

		lerp = function(self, a, b, t)
			return a + t * (b - a)
		end,

		ray_circle_intersection = function(self, ray, center, r)
			if math.abs(ray.x) > math.abs(ray.y) then
				local k = ray.y / ray.x

				local a = 1 + k * k
				local b = -2 * center.x - 2 * k * center.y
				local c = center:length2dsqr() - r * r

				local d = b * b - 4 * a * c

				if d < 0 then
					local nearest_on_ray = ray * center:dot(ray)
					local diff = (nearest_on_ray - center):normalized()

					return center + diff * r
				elseif d < 0.001 then
					local x = -b / (2 * a);
					local y = k * x;
					return vector(x, y)
				end

				local d_sqrt = math.sqrt(d)

				local x = (-b + d_sqrt) / (2 * a)
				local y = k * x

				local dir1 = vector(x, y)

				x = (-b - d_sqrt) / (2 * a)
				y = k * x

				local dir2 = vector(x, y)

				if ray:dot(dir1) > ray:dot(dir2) then
					return dir1
				end

				return dir2
			else
				local k = ray.x / ray.y

				local a = 1 + k * k
				local b = -2 * center.y - 2 * k * center.x
				local c = center:length2dsqr() - r * r

				local d = b * b - 4 * a * c;

				if d < 0 then
					local nearest_on_ray = ray * center:dot(ray)
					local diff = (nearest_on_ray - center):normalized()

					return center + diff * r
				elseif d < 0.001 then
					local y = -b / (2 * a)
					local x = k * y
					return vector(x, y)
				end

				local d_sqrt = math.sqrt(d)

				local y = (-b + d_sqrt) / (2 * a)
				local x = k * y

				local dir1 = vector(x, y)

				y = (-b - d_sqrt) / (2 * a)
				x = k * y

				local dir2 = vector(x, y)

				if ray:dot(dir1) > ray:dot(dir2) then
					return dir1
				end

				return dir2
			end
		end,

		correct_angle = function(self, ang, velocity, throw_velocity, throw_strength)
            local wish_dir = vector():angles(ang)
			local dir_normalized = vector():angles(ang.x - (90 - math.abs(ang.x)) * 10 / 90, ang.y)

			local cos_pitch = dir_normalized:dot(wish_dir) / wish_dir:length()

            local vel = math.clamp(throw_velocity * 0.9, 15, 750)
            local clamped_throw_strength = math.clamp(throw_strength, 0, 1)

            vel = vel * self:lerp(self.GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

			local real_dir = self:ray_circle_intersection(
                dir_normalized,
                velocity * 1.25,
                vel * cos_pitch
            ) - velocity * 1.25

            ang.y = real_dir:angles().y
			ang.x = math.clamp(ang.x + math.clamp(velocity.z * 0.1, -20, 20), -89, 89)
        end,

		rotate_movement = function(self, cmd, ang)
            local rad = math.rad(ang)

            local cos = math.cos(rad)
			local sin = math.sin(rad)

			local new_forwardmove = (cos * cmd.forwardmove) + (sin * cmd.sidemove)
			local new_sidemove = (sin * cmd.forwardmove) + (cos * cmd.sidemove)

			cmd.forwardmove = new_forwardmove
			cmd.sidemove = new_sidemove
        end,

		createmove = function(self, cmd)
			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return
			end

			local weapon_info = weapon:get_weapon_info()

			if weapon_info == nil or weapon_info.weapon_type ~= 9 then
				return
			end

			if weapon.m_fThrowTime == 0 then
				return
			end

			local timebase = me.m_nTickBase * globals.tickinterval

			if timebase < weapon.m_fThrowTime and rage.exploit:get() ~= 1.0 then
				return
			end

			local view_angles = cmd.view_angles
			local yaw_old = view_angles.y

			local camera_angles = render.camera_angles()

			local is_modified_angle = (
				camera_angles.x ~= view_angles.x
				or camera_angles.y ~= view_angles.y
			)

			if is_modified_angle then
				return
			end

			self:correct_angle(
                view_angles,
                me.m_vecVelocity,
                weapon_info.throw_velocity,
                weapon.m_flThrowStrength
            )

			self:rotate_movement(cmd, math.normalize_yaw(yaw_old - view_angles.y))
		end,

		grenade_override_view = function(self, e)
            local me = entity.get_local_player()

            if me == nil then
                return
            end

            local weapon = me:get_player_weapon()

			if weapon == nil then
				return
			end

			local weapon_info = weapon:get_weapon_info()

			if weapon_info ~= nil and weapon_info.weapon_type == 9 then
				self:correct_angle(
                    e.angles,
                    e.velocity,
                    weapon_info.throw_velocity,
                    weapon.m_flThrowStrength
                )
			end
        end,

		setup = function(self)
			local ref = self.ui.menu.misc.super_toss

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local function on_grenade_override_view(e)
				self:grenade_override_view(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.createmove(on_createmove, value)
					events.grenade_override_view(on_grenade_override_view, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'grenade_release' {
		damage = nil,

		should_throw = function(self, weapon, damage)
			local ref = self.ui.menu.misc.grenade_release

			if weapon == nil or damage == nil then
				return false
			end

			local weapon_index = weapon:get_weapon_index()

			if weapon_index == 45 then
				return damage > 0
			end

			return damage >= ref.damage:get()
		end,

		createmove = function(self, cmd)
			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return
			end

			if not weapon.m_bPinPulled then
				return
			end

			if weapon.m_flThrowStrength <= 0 then
				return
			end

			if self:should_throw(weapon, self.damage) then
				cmd.in_attack = false
				cmd.in_attack2 = false
			end

			self.damage = nil
		end,

		grenade_prediction = function(self, e)
			self.damage = e.damage
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.grenade_release

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local function on_grenade_prediction(e)
				self:grenade_prediction(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.createmove(on_createmove, value)
					events.grenade_prediction(on_grenade_prediction, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}


	:struct 'animations' {
		staticlegs = function(self)
			local me = entity.get_local_player()
			if me == nil then
				return
			end

			if self.helpers:contains(self.ui.menu.aa.animations:get(), "Static legs") then
				me.m_flPoseParameter[6] = 1
			end

			if self.helpers:contains(self.ui.menu.aa.animations:get(), "Leg fucker") then
                me.m_flPoseParameter[0] = globals.tickcount % 4 >= 2 and 86 or 50 * 1.0 / (globals.tickcount % 8 >= 4 and 200 or 400)
                self.ref.antiaim.legs:override("sliding")
            else
                self.ref.antiaim.legs:override(nil)
            end

			if self.helpers:contains(self.ui.menu.aa.animations:get(), "Body lean") then
				lambotruck.animation.overlay(me[0], 12).m_flWeight = self.ui.menu.aa.animations_lean_amount:get() / 100
			end

		end,
	}

	:struct 'fast_ladder' {
		createmove = function(self, cmd)
			local me = entity.get_local_player()

            if me == nil then
                return
            end

            local movetype = me.m_MoveType

			-- MOVETYPE_LADDER
            if movetype ~= 9 then
                return
            end

            local angle = render.camera_angles()

            cmd.view_angles.y = math.floor(
                0.5 + cmd.view_angles.y
            )

            cmd.view_angles.z = 0

            if cmd.forwardmove > 0 and angle.y < 45 then
                cmd.view_angles.x = 89

                cmd.in_moveright = 1
                cmd.in_moveleft = 0
                cmd.in_forward = 0
                cmd.in_back = 1

                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                end

                if cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                end

                if cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
            elseif cmd.forwardmove < 0 and angle.y < 45 then
                cmd.view_angles.x = 89

                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0

                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                end

                if cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                end

                if cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
            end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.fast_ladder

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.createmove(on_createmove, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'unlock_fake_ping' {
		setup = function(self)
			local ref = self.ui.menu.misc.unlock_fake_ping

			local ref_fake_latancy = ui.find(
				'Miscellaneous', 'Main', 'Other', 'Fake Latency'
			)

			local sv_maxunlag = cvar.sv_maxunlag

			local function restore_value()
				ref_fake_latancy:override()
				ref_fake_latancy:disabled(false)
			end

			local function update_value(value)
				ref_fake_latancy:override(value)
				ref_fake_latancy:disabled(true)
			end

			local function on_shutdown()
				restore_value()
			end

			local callbacks do
				local function on_latency(item)
					update_value(item:get())
				end

				local function on_enabled(item)
					local value = item:get()

					if not value then
						restore_value()
					end

					if value then
						ref.latency:set_callback(on_latency, true)
					else
						ref.latency:unset_callback(on_latency)
					end

					events.shutdown(on_shutdown, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}


	:struct 'hitlogs' {
		action_str = {
			['knife'] = 'Knifed',
			['inferno'] = 'Burned',
			['hegrenade'] = 'Naded'
		},

		hitgroup_str = {
			[0] = 'generic',
			'head', 'chest', 'stomach',
			'left arm', 'right arm',
			'left leg', 'right leg',
			'neck', 'generic', 'gear'
		},

		wrap_color = function(self, text, hex)
			return string.format(
				'\a%s%s\aDEFAULT',
				hex, text
			)
		end,

		get_hitgroup = function(self, hitgroup)
			return self.hitgroup_str[hitgroup] or '?'
		end,

		get_prefix = function(self)
			local ref = self.ui.menu.vis.hitlogs

			local col = ref.col:get()
			local hex = col:to_hex()

			return self:wrap_color(
				'Strike', hex
			)
		end,

		print_events = function(self, text)
			local ref = self.ui.menu.vis.hitlogs

			if not ref.output:get 'Events' then
				return
			end

			print_dev(string.format(
				'[%s] %s', self:get_prefix(), text
			))
		end,

		print_console = function(self, text)
			local ref = self.ui.menu.vis.hitlogs

			if not ref.output:get 'Console' then
				return
			end

			print_raw(string.format(
				'[%s] %s', self:get_prefix(), text
			))
		end,

		aim_hit = function(self, e)
			local ref = self.ui.menu.vis.hitlogs

			if ref == nil then
				return
			end

			local target = e.target

			if target == nil then
				return
			end

			local target_name = target:get_name()
			local target_health = target.m_iHealth

			local damage = e.damage
			local wanted_damage = e.wanted_damage

			local hitgroup = self:get_hitgroup(e.hitgroup)
			local wanted_hitgroup = self:get_hitgroup(e.wanted_hitgroup)

			local backtrack = e.backtrack

			local col = ref.col:get()
			local hex = col:to_hex()

			local text = '' do
                local name_text = self:wrap_color(target_name, hex)

				local damage_text = self:wrap_color(damage, hex)
                local hitgroup_text = self:wrap_color(hitgroup, hex)

				local health_text = self:wrap_color(target_health, hex)
				local backtrack_text = self:wrap_color(backtrack, hex)

                if damage ~= wanted_damage then
                    damage_text = damage_text .. string.format(
						'(%s)', self:wrap_color(wanted_damage, hex)
					)
                end

                if hitgroup ~= wanted_hitgroup then
                    hitgroup_text = hitgroup_text .. string.format(
						'(%s)', self:wrap_color(wanted_hitgroup, hex)
					)
                end

				text = string.format(
					'Registered shot at %s\'s %s for %s damage (hp: %s) (bt: %s)',
					name_text, hitgroup_text, damage_text, health_text, backtrack_text
				)
			end

			self:print_events(text)
			self:print_console(text)
		end,

		aim_miss = function(self, e)
			local ref = self.ui.menu.vis.hitlogs

			if ref == nil then
				return
			end

			local target = e.target

			if target == nil then
				return
			end

			local target_name = target:get_name()

			local wanted_damage = e.wanted_damage
			local wanted_hitgroup = self:get_hitgroup(e.wanted_hitgroup)

			local hitchance = e.hitchance
			local backtrack = e.backtrack

			local state = e.state

			local col = ref.col:get()
			local hex = col:to_hex()

			local text = '' do
                local name_text = self:wrap_color(target_name, hex)
				local state_text = self:wrap_color(state, hex)

				local damage_text = self:wrap_color(wanted_damage, hex)
                local hitgroup_text = self:wrap_color(wanted_hitgroup, hex)

				local hitchance_text = self:wrap_color(hitchance, hex)
				local backtrack_text = self:wrap_color(backtrack, hex)

				text = string.format(
					'Missed shot in %s in the %s due to %s (hc: %s) (damage: %s) (bt: %s)',
					name_text, hitgroup_text, state_text, hitchance_text, damage_text, backtrack_text
				)
			end

			self:print_events(text)
			self:print_console(text)
		end,

		aim_ack = function(self, e)
			local ref = self.ui.menu.vis.hitlogs

			if not ref.events:get 'Aimbot' then
				return
			end

			if e.state == nil then
				self:aim_hit(e)
			else
				self:aim_miss(e)
			end
		end,

		player_hurt = function(self, e)
			local ref = self.ui.menu.vis.hitlogs

			if not ref.events:get 'Aimbot' then
				return
			end

			local me = entity.get_local_player()

			local userid = entity.get(e.userid, true)
			local attacker = entity.get(e.attacker, true)

			if me == userid or me ~= attacker then
				return
			end

			local action = self.action_str[e.weapon]

			if action == nil then
				return
			end

			local name = userid:get_name()

			local health = e.health
			local damage = e.dmg_health

			local col = ref.col:get()
			local hex = col:to_hex()

			local text = '' do
                local name_text = self:wrap_color(name, hex)

				local damage_text = self:wrap_color(damage, hex)
                local health_text = self:wrap_color(health, hex)

				text = string.format(
					'%s %s for %s damage (hp: %s)',
					action, name_text, damage_text, health_text
				)
			end

			self:print_events(text)
			self:print_console(text)
		end,

		item_purchase = function(self, e)
			local ref = self.ui.menu.vis.hitlogs

			if not ref.events:get 'Purchases' then
				return
			end

			local userid = entity.get(e.userid, true)

			if not userid:is_enemy() then
				return
			end

			local name = userid:get_name()
			local weapon = e.weapon

			local col = ref.col:get()
			local hex = col:to_hex()

			local text = '' do
                local name_text = self:wrap_color(name, hex)
                local weapon_text = self:wrap_color(weapon, hex)

				text = string.format(
					'%s bought %s',
					name_text, weapon_text
				)
			end

			self:print_events(text)
			self:print_console(text)
		end,

		setup = function(self)
			local ref = self.ui.menu.vis.hitlogs

			local function on_aim_ack(e)
				self:aim_ack(e)
			end

			local function on_player_hurt(e)
				self:player_hurt(e)
			end

			local function on_item_purchase(e)
				self:item_purchase(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.aim_ack(on_aim_ack, value)
					events.player_hurt(on_player_hurt, value)
					events.item_purchase(on_item_purchase, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'freezetime_fakeduck' {
		current_tick = 0,

		ref_hide_shots = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Hide Shots'
		),

		ref_double_tap = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Double Tap'
		),

		ref_fake_duck = ui.find(
			'Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'
		),

		update_current_tick = function(self)
			if self.current_tick >= 14 then
				self.current_tick = 0
			end

			self.current_tick = self.current_tick + 1
		end,

		shutdown = function(self)
            self.ref_hide_shots:override()
            self.ref_double_tap:override()
		end,

		createmove = function(self, cmd)
            if not self.ref_fake_duck:get() then
                return
            end

            local game_rules = entity.get_game_rules()

            if game_rules == nil then
                return
            end

            if not game_rules.m_bFreezePeriod then
                return
            end

            self:update_current_tick()

            local should_duck = self.current_tick > 7 do
                cmd.in_duck = should_duck
                cmd.send_packet = self.current_tick == 14
            end

            self.ref_hide_shots:override(false)
            self.ref_double_tap:override(false)
        end,

		override_view = function(self, e)
			local ref = self.ui.menu.misc.freezetime_fakeduck

            if not ref:get() or not self.ref_fake_duck:get() then
                return
            end

            local game_rules = entity.get_game_rules()

            if game_rules == nil then
                return
            end

            if not game_rules.m_bFreezePeriod then
                return
            end

            local me = entity.get_local_player()

            if me == nil then
                return
            end

            local origin = me:get_origin()
            e.camera.z = origin.z + 64
        end,

		setup = function(self)
			local ref = self.ui.menu.misc.freezetime_fakeduck

			local function on_shutdown()
				self:shutdown()
			end

			local function on_override_view(e)
				self:override_view(e)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.shutdown(on_shutdown, value)
					events.override_view(on_override_view, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'unlock_fakeduck_speed' {
		ref_fake_duck = ui.find(
			'Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'
		),

		createmove_run = function(self, cmd)
			if not self.ref_fake_duck:get() then
				return
			end

			local impulse = vector(
				cmd.forwardmove,
				cmd.sidemove
			)

			impulse:normalize()

			local me = entity.get_local_player()

            if me == nil then
                return
            end
			
			if math.abs(me.m_vecVelocity.y) > 10 then
				cmd.forwardmove = impulse.x * 150
				cmd.sidemove = impulse.y * 150
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.unlock_fakeduck_speed

			local function on_createmove_run(cmd)
				self:createmove_run(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.createmove_run(on_createmove_run, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'no_fall_damage' {
        triggered = false,

		trace = function(self, player, length)
			local origin = player:get_origin()

			for rad = 0, math.pi * 2, math.pi * 2 / 8 do
				local sin = math.sin(rad)
				local cos = math.cos(rad)

				local point_a = origin + vector(
					10 * cos, 10 * sin, 0
				)

				local point_b = point_a - vector(0, 0, length)

				local tr = utils.trace_line(
					point_a, point_b, player
				)

				if tr.fraction ~= 1 then
					return true
				end
			end

			return false
		end,

		on_createmove = function(self, cmd)
            local me = entity.get_local_player()

            if me == nil then
                return
            end

            if me.m_vecVelocity.z >= -500 then
				self.triggered = false
			else
				if self:trace(me, 15) then
					self.triggered = false
				elseif self:trace(me, 75) then
					self.triggered = true
				end
			end

			if me.m_vecVelocity.z < -500 then
                cmd.in_duck = self.triggered
			end
        end,

		setup = function(self)
			local ref = self.ui.menu.misc.no_fall_damage

			local function on_createmove(cmd)
				self:on_createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.createmove(on_createmove, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'keep_model_tranparency' {
		localplayer_transparency = function(self, alpha)
			local player = entity.get_local_player()

			if player == nil then
				return
			end

			if player.m_bIsScoped or player.m_bResumeZoom then
				return 59
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.keep_model_tranparency

			local function on_localplayer_transparency(alpha)
				return self:localplayer_transparency(alpha)
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					events.localplayer_transparency(on_localplayer_transparency, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'dormant_aimbot' {
		WEAPONTYPE_SNIPER_RIFLE = 5,

		ref_minimum_damage = ui.find(
			'Aimbot', 'Ragebot', 'Selection', 'Min. Damage'
		),

		target_index = 1,
		spread_patterns = { },

		hitbox_points = {
			{ scale = 5, hitbox = 'Stomach', vec = vector(0, 0, 40) },
			{ scale = 6, hitbox = 'Chest', vec = vector(0, 0, 50) },
			{ scale = 3, hitbox = 'Head', vec = vector(0, 0, 58) },
			{ scale = 4, hitbox = 'Legs', vec = vector(0, 0, 20) }
		},

		is_weapon_gun = function(self, type)
			return type >= 1 and type <= 6
		end,

		get_aimbot_targets = function(self)
			local list = { }

			local player_resource = entity.get_player_resource()

			for i = 1, globals.max_players do
				local player = entity.get(i)

				if player == nil then
					goto continue
				end

				local is_connected = player_resource.m_bConnected[i]

				if not is_connected then
					goto continue
				end

				local is_enemy = player:is_enemy()
				local is_dormant = player:is_dormant()

				if not is_enemy or not is_dormant then
					goto continue
				end

				table.insert(list, player)

				::continue::
			end

			return list
		end,

		compute_spread = function(self)
			for i = 1, 64 do
				utils.random_seed(i)

				local temp1 = utils.random_float(0, 1)
				local temp2 = utils.random_float(0, math.pi * 2)

				local a, b, c, d = temp1, temp2, temp1, temp2

				self.spread_patterns[i] = {
					a = a, c = c,

					bcos = math.cos(b),
					bsin = math.sin(b),

					dcos = math.cos(d),
					dsin = math.sin(d)
				}
			end
		end,

		calculate_hitchance = function(self, cmd, position)
			local me = entity.get_local_player()

			if me == nil then
				return 0
			end

			local wpn = me:get_player_weapon()

			if wpn == nil then
				return 0
			end

			local eye = me.m_vecOrigin + me.m_vecViewOffset
			local angle = eye:to(position):angles()

			local forward = vector( math.cos(math.rad(angle.x)) * math.cos(math.rad(angle.y)), math.cos(math.rad(angle.x)) * math.sin(math.rad(angle.y)), -math.sin(math.rad(angle.x)) )
			local right, up = forward:vectors()

			local hits = 0

			for i = 1, 64 do
				local temp = self.spread_patterns[i]

				local a, c = temp.a, temp.c
				local inaccuracy = a * wpn:get_inaccuracy()
				local spread = c * wpn:get_spread()

				local is_revolver = (
					wpn:get_weapon_index() == 64
				)

				if is_revolver and cmd.in_attack2 == true then
					a = 1 - a * a
					a = 1 - c * c
				end

				local direction = (forward + (right * (temp.bcos * inaccuracy + temp.dcos * spread)) + (up * (temp.bsin * inaccuracy + temp.dsin * spread))):normalized()

				if position:dist_to_ray(eye, direction) < 20 then
					hits = hits + 1
				end
			end

			return hits / 64
		end,

		create_multipoints = function(self, from, to, radius)
			local angles = from:to(to):angles()
			local radian = math.rad(angles.y + 90)

			local forward = vector(math.cos(radian), math.sin(radian), 0)
			local direction = forward * radius

			return {
				{
					text = 'Middle',
					vec = to
				},

				{
					text = 'Left',
					vec = to + direction
				},

				{
					text = 'Right',
					vec = to - direction
				}
			}
		end,

		trace_bullet = function(self, player, start_pos, end_pos, skip)
			local damage, trace = utils.trace_bullet(
				player, start_pos, end_pos, skip
			)

			if trace ~= nil then
				local ent = trace.entity

				if ent == nil then
					return 0, trace
				end

				if ent:is_player() and not ent:is_enemy() then
					return 0, trace
				end

				if trace:is_visible() then
					return 0, trace
				end
			end

			return damage, trace
		end,

		createmove = function(self, cmd)
			local ref = self.ui.menu.misc.dormant_aimbot

			local targets = self:get_aimbot_targets()
			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return
			end

			local weapon_info = weapon:get_weapon_info()

			if weapon_info == nil then
				return
			end

			local inaccuracy = weapon:get_inaccuracy()

			if inaccuracy == nil then
				return
			end

			local eye_pos = me:get_eye_position()
			local simtime = me:get_simulation_time().current
			local onground = bit.band(me.m_fFlags, bit.lshift(1, 0)) ~= 0

			if cmd.in_jump and not onground then
				return
			end

			local weapon_type = weapon_info.weapon_type

			if not self:is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
				return false
			end

			if globals.tickcount % #targets ~= 0 then
				self.target_index = self.target_index + 1
			else
				self.target_index = 1
			end

			local target = targets[self.target_index]

			if target == nil then
				return
			end

			local bbox = target:get_bbox()
			local origin = target:get_origin()

			local duck_amount = target.m_flDuckAmount

			local alpha_limit = ref.alpha_modifier:get()
			local desired_damage = ref.minimum_damage:get()

			local hc = ref.hitchance:get()

			if desired_damage == 0 then
				desired_damage = self.ref_minimum_damage:get()
			end

			if desired_damage >= 100 then
				desired_damage = desired_damage - 100 + target.m_iHealth
			end

			local points = { }

			for i = 1, #self.hitbox_points do
				local data = self.hitbox_points[i]

				local vec = data.vec
				local scale = data.scale
				local hitbox = data.hitbox

				if hitbox == 'Head' then
					vec = vec - vector(0, 0, 10 * duck_amount)
				end

				if hitbox == 'Chest' then
					vec = vec - vector(0, 0, 4 * duck_amount)
				end

				local hitboxes = ref.hitboxes

				if #hitboxes:get() ~= 0 then
					if hitboxes:get(hitbox) then
						table.insert(points, {
							vec = vec,
							scale = scale,
							hitbox = hitbox
						})
					end
				else
					table.insert(points, 1, {
						vec = vec,
						scale = scale,
						hitbox = hitbox
					})
				end
			end

			local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
				or math.max(me.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime

			if not is_available_to_shoot then
				return
			end

			local found_pos
			local found_damage

			if alpha_limit > math.floor(bbox.alpha * 100) + 5 then
				return
			end

			for j = 1, #points do
				local point = points[j]

				local multipoints = self:create_multipoints(
					eye_pos, origin + point.vec, point.scale
				)

				for k = 1, #multipoints do
					local multipoint = multipoints[k]
					local aimpoint = multipoint.vec

					local damage, tr = self:trace_bullet(
						me, eye_pos, aimpoint
					)

					if point.hitbox == 'Head' then
						damage = damage * 4
					end

					if tr ~= nil and tr:is_visible() or target:is_visible() then
						goto continue
					end

					if damage ~= 0 and desired_damage < damage then
						found_pos = aimpoint
						found_damage = damage

						break
					end

					::continue::
				end

				if found_pos and found_damage then
					break
				end
			end

			if not found_pos or not found_damage then
				return
			end

			if hc > self:calculate_hitchance(cmd, found_pos) * 100 then
				return
			end

			local angles = eye_pos:to(found_pos):angles()

			local is_onground = not cmd.in_jump and onground

			local is_scoped = me.m_bIsScoped or me.m_bResumeZoom
			local is_sniper = weapon_info.weapon_type == self.WEAPONTYPE_SNIPER_RIFLE

			cmd.block_movement = 1

			if not is_scoped and is_sniper and is_onground then
				cmd.in_attack2 = true
			end

			if inaccuracy < 0.01 then
				cmd.in_attack = true
				cmd.view_angles = angles

				is_shot = true
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.dormant_aimbot

			self:compute_spread()

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.createmove(on_createmove, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'edge_quick_stop' {
		ref_peek_assist = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Peek Assist'
		),

		createmove = function(self, cmd)
			if not self.ref_peek_assist:get() then
				return
			end

			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local simulation_ctx = me:simulate_movement() do
				simulation_ctx:think(5)
			end

			if simulation_ctx.velocity.z < 0 then
				cmd.block_movement = 2
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.edge_quick_stop

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.createmove(on_createmove, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'air_duck_collision' {
		createmove = function(self, cmd)
			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local flags = me.m_fFlags

			if bit.band(flags, 1) ~= 0 then
				return
			end

			if cmd.in_duck then
				return
			end

			local is_hit_wall_with_duck = false do
				local sim_ctx = me:simulate_movement()

				cmd.in_duck = true
				sim_ctx:think(1)

				is_hit_wall_with_duck = (
					bit.band(sim_ctx.flags, 1) == 0
					and sim_ctx.did_hit_collision
				)
			end

			local is_hit_wall_without_duck = false do
				local sim_ctx = me:simulate_movement()

				cmd.in_duck = false
				sim_ctx:think(1)

				is_hit_wall_without_duck = (
					bit.band(sim_ctx.flags, 1) == 0
					and sim_ctx.did_hit_collision
				)
			end

			local should_duck = (
				not is_hit_wall_with_duck
				and is_hit_wall_without_duck
			)

			if should_duck then
				cmd.in_duck = true
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.air_duck_collision

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.createmove(on_createmove, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'auto_teleport' {
		ref_lag_options = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Double Tap', 'Lag Options'
		),

		ref_fake_duck = ui.find(
			'Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'
		),

		teleport_time = nil,
		was_teleported = false,

		prev_no_entry = vector(),

		set_teleport_time = function(self)
			local ref = self.ui.menu.aa.auto_teleport
			local delay = ref.teleport_delay:get() / 1000

			self.teleport_time = globals.curtime + delay
		end,

		createmove = function(self, cmd)
			local ref = self.ui.menu.aa.auto_teleport

			if not ref:get() then
				return
			end

			local me = entity.get_local_player()

			if me == nil then
				return
			end

			local flags = me.m_fFlags

			if bit.band(flags, 1) ~= 0 then
				return
			end

			local snapshot = lagrecord.get_snapshot(me)

			if snapshot == nil then
				return
			end

			local no_entry = snapshot.command.no_entry

			local is_triggered = false do
				local hittable = entity.get_threat(true)

				if hittable ~= nil then
					is_triggered = true
				end
			end

			self.ref_fake_duck:override()

			if is_triggered then
				if self.teleport_time == nil then
					self.ref_lag_options:override 'Always on'

					if self.prev_no_entry.x ~= 0 and no_entry.x == 0 then
						self:set_teleport_time()
					end
				end
			else
				self.teleport_time = nil
			end

			if self.teleport_time ~= nil then
				if globals.curtime >= self.teleport_time then
					self.ref_fake_duck:override(true)
					self.teleport_time = nil
				end
			end

			self.prev_no_entry = no_entry:clone()
		end
	}

	:struct 'auto_hide_shots' {
		WEAPONTYPE_PISTOL        = 1,
		WEAPONTYPE_SUBMACHINEGUN = 2,
		WEAPONTYPE_RIFLE         = 3,
		WEAPONTYPE_SNIPER_RIFLE  = 5,

		ref_hide_shots = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Hide Shots'
		),

		ref_double_tap = ui.find(
			'Aimbot', 'Ragebot', 'Main', 'Double Tap'
		),

		ref_fake_duck = ui.find(
			'Aimbot', 'Anti Aim', 'Misc', 'Fake Duck'
		),

		get_weapon_type = function(self, weapon)
			local weapon_info = weapon:get_weapon_info()

			if weapon_info == nil then
				return nil
			end

			local weapon_type = weapon_info.weapon_type
			local weapon_index = weapon:get_weapon_index()

			if weapon_type == self.WEAPONTYPE_SUBMACHINEGUN then
				return 'SMG'
			end

			if weapon_type == self.WEAPONTYPE_RIFLE then
				return 'Rifles'
			end

			if weapon_type == self.WEAPONTYPE_PISTOL then
				if weapon_index == 1 then
					return 'Desert Eagle'
				end

				return 'Pistols'
			end

			if weapon_type == self.WEAPONTYPE_SNIPER_RIFLE then
				if weapon_index == 40 then
					return 'SSG-08'
				end

				if weapon_index == 9 then
					return 'AWP'
				end

				return 'Auto Snipers'
			end

			return nil
		end,

		should_update = function(self)
			local ref = self.ui.menu.aa.auto_hide_shots

			if not ref:get() then
				return false
			end

			if self.ref_fake_duck:get() then
				return false
			end

			if not self.ref_double_tap:get() then
				return false
			end

			local me = entity.get_local_player()

			if me == nil then
				return false
			end

			local weapon = me:get_player_weapon()

			if weapon == nil then
				return false
			end

			local weapon_type = self:get_weapon_type(weapon)

			if weapon_type == nil then
				return false
			end

			if not ref.weapons:get(weapon_type) then
				return false
			end

			local state = self.helpers:get_state()

			if not ref.states:get(state) then
				return false
			end

			return true
		end,

		shutdown = function(self)
			self.ref_hide_shots:override()
			self.ref_double_tap:override()
		end,

		createmove = function(self, cmd)
			if self:should_update() then
				self.ref_hide_shots:override(true)
				self.ref_double_tap:override(false)
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.aa.auto_hide_shots

			local function on_shutdown()
				self:shutdown()
			end

			local function on_createmove(cmd)
				self:createmove(cmd)
			end

			local callbacks do
				local function on_enabled(item)
					events.shutdown(on_shutdown, item:get())
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}



	:struct 'teammate_aimbot' {
		mp_teammates_are_enemies = cvar.mp_teammates_are_enemies,

		shutdown = function(self)
			self.mp_teammates_are_enemies:int(0)
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.teammate_aimbot

			local function on_shutdown()
				self:shutdown()
			end

			local callbacks do
				local function on_enabled(item)
					local value = item:get()

					self.mp_teammates_are_enemies:int(
						value and 1 or 0
					)

					events.shutdown(on_shutdown, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}




	:struct 'clientside_nickname' {
		player_info_t = ffi.typeof [[
			struct {
				int64_t         unknown;
				int64_t         steamID64;
				char            szName[128];
				int             userId;
				char            szSteamID[20];
				char            pad_0x00A8[0x10];
				unsigned long   iSteamID;
				char            szFriendsName[128];
				bool            fakeplayer;
				bool            ishltv;
				unsigned int    customfiles[4];
				unsigned char   filesdownloaded;
			} *
		]],

		BaseLocalClient = ffi.cast(
			'uintptr_t**', utils.opcode_scan(
				'engine.dll',
				'A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6',
				1
			)
		),

		GetStringUserData = utils.get_vfunc(
			11, 'void*(__thiscall*)(void*, int, int*)'
		),

		restore_nickname = function(self)
			if self.previous_name == nil then
				return
			end

			self:apply_nickname(self.previous_name)
			self.previous_name = nil
		end,

		apply_nickname = function(self, name)
			local me = entity.get_local_player()

			if me == nil then
				return false
			end

			local BaseLocalClient = self.BaseLocalClient[0][0]

			if BaseLocalClient == nil then
				return false
			end

			local UserInfoTable = ffi.cast('void***', BaseLocalClient + 0x52C0)[0]

			if UserInfoTable == nil then
				return false
			end

			local data = self.GetStringUserData(
				UserInfoTable, me:get_index() - 1, nil
			)

			if data == nil then
				return false
			end

			local player_info = ffi.cast(
				self.player_info_t, data
			)

			if player_info == nil then
				return false
			end

			local current_name = ffi.string(
				player_info[0].szName
			)

			if current_name ~= name and self.previous_name == nil then
				self.previous_name = current_name
			end

			ffi.copy(player_info[0].szName, name, #name + 1)
		end,

		shutdown = function(self)
			self:restore_nickname()
		end,

		level_init = function(self)
			local ref = self.ui.menu.misc.clientside_nickname
			local nickname = ref.nickname:get()

			self:restore_nickname()

			if nickname ~= '' then
				self:apply_nickname(nickname)
			end
		end,

		setup = function(self)
			local ref = self.ui.menu.misc.clientside_nickname

			local function on_shutdown()
				self:shutdown()
			end

			local function on_level_init()
				self:level_init()
			end

			local callbacks do
				local function on_nickname(item)
					local value = item:get()

					if value == '' then
						self:restore_nickname()
					else
						self:apply_nickname(value)
					end
				end

				local function on_enabled(item)
					local value = item:get()

					if not value then
						self:restore_nickname()
					end

					if value then
						ref.nickname:set_callback(on_nickname, true)
					else
						ref.nickname:unset_callback(on_nickname)
					end

					events.shutdown(on_shutdown, value)
					events.level_init(on_level_init, value)
				end

				ref:set_callback(on_enabled, true)
			end
		end
	}

	:struct 'scoreboard_website' {
		setup = function(self)
			local website_button = panorama.loadstring([[
				var original_button = null;
				var website_button = null;

				var _Replace = function() {
					let scoreboard = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard");
					if (!scoreboard) return;

					let footer_button = scoreboard.FindChildTraverse("id-sb-footer-server-website");
					if (!footer_button) return;

					original_button = footer_button;
					original_button.style.visibility = "collapse";

					let parent = original_button.GetParent();
					website_button = $.CreatePanel("Button", parent, "custom-website-text");

					let layout = `
					<root>
						<styles>
							<include src="file://{resources}/styles/scoreboard.css" />
						</styles>

						<Panel class="CustomWebsiteText">
							<CSGOGameTimeLabel id="id-gametime__time" text="strike dev" />

							<Script>
								var texts = [
									's/',
									'st/',
									'str/',
									'stri/',
									'strik/',
									'strike/',
									'trik/',
									'rike/',
									'ike/',
									'ke/',
									'e/',
									'str/',
									'tri/',
									'rik/',
									'strik/',
									'str/i/',
									'stri/k/',
									'strik/e/',
									'st/ri/e/',
									's/t/r/i/k/e/',
									'strike!'
								];

								var currentIndex = 0;
								var label = $.GetContextPanel().GetParent().FindChildTraverse('id-gametime__time');

								function updateText() {
									$('#id-gametime__time').text = texts[currentIndex];
									currentIndex = (currentIndex + 1) % texts.length;
									$.Schedule(0.2, updateText);
								}

								updateText();
							</Script>
						</Panel>
					</root>
					`;

					website_button.BLoadLayoutFromString(layout, false, false);
				};

				var _Restore = function() {
					if (original_button && original_button.IsValid()) {
						original_button.style.visibility = "visible";
					}

					if (website_button && website_button.IsValid()) {
						website_button.DeleteAsync(0.0);
					}

					original_button = null;
					website_button = null;
				};

				return {
					replace: _Replace,
					restore: _Restore
				};
			]], 'CSGOHud')()

			local function on_shutdown()
				website_button.restore()
			end

			local function on_level_init()
				website_button.restore()
				website_button.replace()
			end

			events.shutdown(on_shutdown)
			events.level_init(on_level_init)

			website_button.replace()
		end
	}


for _, eid in ipairs({
	{
		'load', function()
			ctx.ui:execute()
			ctx.config:setup()

			ctx.watermark:setup()

			ctx.viewmodel:setup()
			ctx.aspect_ratio:setup()

			ctx.hit_marker:setup()
			ctx.kibit_marker:setup()

			ctx.damage_indicator:setup()
			ctx.console_color:setup()

			ctx.scope_overlay:setup()
			ctx.grenade_radius:setup()

			ctx.skeet_grenade:setup()

			ctx.lc_indicator:setup()
			ctx.skeet_indicators:setup()

			ctx.damage_helper:setup()
			ctx.revolver_helper:setup()

			ctx.lagcomp_debug:setup()

			ctx.drop_nades:setup()
			ctx.super_toss:setup()
			ctx.unlock_fakeduck_speed:setup()

			ctx.no_fall_damage:setup()
			ctx.keep_model_tranparency:setup()

			ctx.edge_quick_stop:setup()
			ctx.air_duck_collision:setup()

			ctx.grenade_release:setup()
			ctx.freezetime_fakeduck:setup()

			ctx.fast_ladder:setup()
			ctx.auto_hide_shots:setup()

			ctx.clientside_nickname:setup()

			ctx.dormant_aimbot:setup()
			ctx.teammate_aimbot:setup()

			ctx.unlock_fake_ping:setup()
			ctx.scoreboard_website:setup()

			ctx.hitlogs:setup()
		end
	},
	{
		"post_update_clientside_animation", function()
			ctx.animations:staticlegs()
		end
	},
	{
		'post_update_clientside_animation', function()

		end
	},
	{
		'aim_ack', function(e)
		end
	},
    {
        'level_init', function()
            ctx.defensive:reset()
        end
    },
    {
        'render', function()
			ctx.binds:update()
			ctx.ui:render()
		end
    },
	{
		"bullet_impact", function(e)
			if tick_work == globals.tickcount then return end
			if not globals.is_connected then return end
			if not entity.get_local_player():is_alive() then return end
			if not entity.get(e.userid, true) then return end
			if not e.userid then return end
			if entity.get(e.userid, true):is_alive() == false then return end
			if entity.get(e.userid, true):is_dormant() then return end
			if not entity.get(e.userid, true):is_enemy() then return end
			if math.abs(ctx.ui.globals.strike_cache.ab.bruted_last_time - globals.curtime) > 0.250 then
				local impact = vector(e.x, e.y, e.z)
				local eyepos = entity.get(e.userid, true):get_eye_position()
				local eye_pos = entity.get_local_player():get_eye_position()
				local head_vec = bullet_impact(eye_pos, eyepos, impact)
				local ent = entity.get(e.userid, true)
				if distance < 70 then
					ctx.ui.globals.strike_cache.ab.bruted_last_time = globals.curtime
					ctx.ui.globals.strike_cache.ab.time[ent] = globals.curtime + 5
					ctx.ui.globals.strike_cache.ab.jitteralgo[ent] = math.random(-5, 8)
					ctx.ui.globals.strike_cache.ab.should_swap[ent] = true
				end
			end
		end
	},
    {
        'createmove', function(cmd)
			ctx.ref.rage.dt:override()
			ctx.ref.rage.hs:override()

			ctx.ref.rage.dtlag:override()

            ctx.defensive:predict()
            ctx.antiaim:run(cmd)

			ctx.auto_teleport:createmove(cmd)

			ctx.freezetime_fakeduck:createmove(cmd)
			ctx.auto_hide_shots:createmove(cmd)
        end
    }
}) do
    if eid[1] == 'load' then
        eid[2]()
    else
        events[eid[1]]:set(eid[2])
    end
end