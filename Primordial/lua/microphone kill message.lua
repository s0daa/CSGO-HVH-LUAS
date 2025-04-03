local vars = {
	menu = {
		enable = menu.add_checkbox('killsays', 'enable', false),
		second = menu.add_slider('killsays', 'seconds', 0, 5, 1),
		tenths = menu.add_slider('killsays', 'tenths', 0, 10, 1),
	},
    is_playing = false
}

local toggle_mic = function(on)
	vars.is_playing = on;
	cvars.voice_loopback:set_int(on and 1 or 0);
	cvars.voice_inputfromfile:set_int(on and 1 or 0);
	engine.execute_cmd((on and '+' or '-') .. 'voicerecord');
end

local on_event = function(event)
	local victim, attacker = event.userid, event.attacker
	if not victim or not attacker then
		return
	end

	local victim, attacker, local_player = entity_list.get_player_from_userid(victim), entity_list.get_player_from_userid(attacker), entity_list.get_local_player()
	if not victim or not attacker or not local_player then
		return
	end

	if attacker == local_player and victim ~= local_player then
		if not vars.is_playing and vars.menu.enable:get() then
			client.delay_call(function()
				toggle_mic(false);
			end, vars.menu.second:get() + (vars.menu.tenths:get() / 10));
			toggle_mic(true);
		end
	end
end

local on_shutdown = function(event)
	toggle_mic(false);
end

callbacks.add(e_callbacks.EVENT, on_event, 'player_death')
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)