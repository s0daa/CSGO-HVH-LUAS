local phrases = {
	kill = ' ENEMY ELIMINATED',		
	kill_plural = ' ENEMIES ELIMINATED',
	kill_zk = 'ENEMY ANNIHILATED',			
};

local kill_phrases = {
	'DOUBLE KILL',
	'MULTI KILL',
	'ULTRA KILL',
	'MONSTER KILL',
	'KILLING SPREE',
	'RAMPAGE',
	'DOMINATING',
	'UNSTOPPABLE',
	'GODLIKE',
	'COMBO WHORE'
};

local zk_phrases = {
	'Owned! ',
	'Outplayed by a true pro! ',
	'Outsmarted! ',
	'Sick move, dude! ',
	'Wonder if he will rq... ',
};

local nade_phrases = {
	he = {
		'BOOM! ',
		'Are you a basketball player? ',
		'No need for a weapon, huh? '
	},
	molly = {
		'Look at his ashes! ',
		'Reminds me of auschwitz...? ',
		'One fried retard and a cola, please! '
	}
};
local data = {
	game = {
		kills = 0,
	},
	round = {
		kills = 0,
	},
	anim = {
		prefix = '',
		counter = 0,
		counter_update = 0,
		should_announce = false,
		is_zk = false,
		global_alpha = 1,
		desc_alpha = 1,
		keys = {
			fade_in = 0,
			fade_in_stop = 0,
			fade_out = 0,
			fade_out_stop = 0,
			stop = 0,
		},
	},
	const = {
		fade_in_dur = 0.1,
		fade_out_dur = 0.5,
		fade_hold = 2,
		counter_dur = 0.025,
	},
};

local animation_fonts = {
	{ font = render.create_font('verdana', 92,500, e_font_flags.DROPSHADOW), color = { color_t(255,255,255, 255), color_t(255,255,255, 255) } },
	{ font = render.create_font('verdana', 84,500, e_font_flags.DROPSHADOW), color = { color_t(201,222,255, 255), color_t(255,186,171, 255) } },
	{ font = render.create_font('verdana', 72,500, e_font_flags.DROPSHADOW), color = { color_t(168,202,255, 255), color_t(255,128,135, 255) } },
	{ font = render.create_font('verdana', 64,500, e_font_flags.DROPSHADOW), color = { color_t(135,182,255, 255), color_t(255,94,103, 255) } },
	{ font = render.create_font('verdana', 52,500, e_font_flags.DROPSHADOW), color = { color_t(66, 135, 245, 255), color_t(255,66,76, 255) } },
};

local bold_font = render.create_font('verdanab', 24, e_font_flags.DROPSHADOW);
local norm_font = render.create_font('verdana', 16, e_font_flags.DROPSHADOW);

local function start_animation(is_zk, nade, hs, fire)
	is_zk = is_zk or false
	data.anim.counter = 0;
	data.anim.should_announce = true;
	data.anim.is_zk = is_zk;
	
	local prefix = '';
	if is_zk then
		prefix = zk_phrases[client.random_int(1, #zk_phrases)];
	elseif nade then
		prefix = nade_phrases.he[client.random_int(1, #nade_phrases.he)];
	elseif fire then
		prefix = nade_phrases.molly[client.random_int(1, #nade_phrases.molly)];
	end
	
	data.anim.prefix = prefix;
	
	local realtime = global_vars.real_time();
	data.anim.keys.fade_in = realtime + data.const.counter_dur * (#animation_fonts + 1);
	data.anim.keys.fade_in_stop = data.anim.keys.fade_in + data.const.fade_in_dur;
	data.anim.keys.fade_out = data.anim.keys.fade_in_stop + data.const.fade_hold;
	data.anim.keys.fade_out_stop = data.anim.keys.fade_out + data.const.fade_out_dur;
	data.anim.keys.stop = data.anim.keys.fade_out_stop;
	
	data.anim.global_alpha = 1;
	data.anim.desc_alpha = 0;
	data.anim.counter_update = realtime;
end

local zk_items = {
	'taser', 'knife', 'bayonet'
};

local function lerp(a, b, t)
	return (b - a) * t + a;
end

local function clamp(v, a, b)
	if v > a then return a end
	if v < b then return b end
	return v;
end

local function is_plural(n)
	return n ~= 1;
end

local function on_event(event)
	if event.name == "game_newmap" then 
		data.game.kills = 0;
		data.round.kills = 0;
	end
	
    if event.name == "round_start" then
        data.round.kills = 0;
    end

    if event.name == "player_death" then
        local attacker = entity_list.get_player_from_userid(event.attacker)
        local victim = entity_list.get_player_from_userid(event.userid)
        local lp = entity_list.get_local_player()
        local headshot = event.headshot 
        local weapon = event.weapon

        if attacker ~= lp or victim == lp then 
            return
        end

        data.game.kills = data.game.kills + 1;
		data.round.kills = data.round.kills + 1;

        local zk = false;
		local nade = false;
		local fire = false;

        for i, v in ipairs(zk_items) do
			if string.find(weapon, v) then zk = true end;
		end

        if weapon == 'hegrenade' then nade = true end;
		if weapon == 'inferno' then fire = true end;
		
		start_animation(zk, nade, hs, fire);
    end
end

local function on_paint(text)
    if data.anim.should_announce then
        local scrn_size = render.get_screen_size();
        scrn_size.y = scrn_size.y - 140;

        local realtime = global_vars.real_time();
        if data.anim.keys.stop <= realtime then
            data.anim.should_announce = false;
            return;
        end

        if data.anim.counter < #animation_fonts - 1 then
            if realtime - data.anim.counter_update >= data.const.counter_dur then
                data.anim.counter_update = realtime
                data.anim.counter = data.anim.counter + 1;
            end
        end

        if realtime >= data.anim.keys.fade_out and realtime <= data.anim.keys.fade_out_stop then
            data.anim.global_alpha = lerp(0,1, (data.anim.keys.fade_out_stop - realtime)/ (data.anim.keys.fade_out_stop - data.anim.keys.fade_out));
            data.anim.desc_alpha = data.anim.global_alpha;
        end

        if realtime >= data.anim.keys.fade_in and realtime <= data.anim.keys.fade_in_stop then
			data.anim.desc_alpha = lerp(0, 1, ((data.anim.keys.fade_in_stop - data.anim.keys.fade_in) - (data.anim.keys.fade_in_stop - realtime)) / (data.anim.keys.fade_in_stop - data.anim.keys.fade_in));
		end

        data.anim.desc_alpha = clamp(data.anim.desc_alpha, 1, 0);
        data.anim.global_alpha = clamp(data.anim.global_alpha,1,0);

        local col_idx = data.anim.is_zk and 2 or 1;

        local fnt = animation_fonts[data.anim.counter + 1];
        local alpha = (data.anim.global_alpha * 255);
        local alpha2 = (data.anim.desc_alpha * 255);

        local text = tostring(data.round.kills) .. (is_plural(data.round.kills) and phrases.kill_plural or phrases.kill);
        text = data.anim.is_zk and phrases.kill_zk or text

        render.text(fnt.font, text, vec2_t(scrn_size.x * 0.5, scrn_size.y * 0.4),  color_t(fnt.color[col_idx].r,fnt.color[col_idx].g,fnt.color[col_idx].b, math.floor(alpha+0.5)))

        local off = 0;
        if data.round.kills > 1 then 
            render.text(bold_font, 
            kill_phrases[clamp(data.round.kills - 1, #kill_phrases, 1)], 
            vec2_t(scrn_size.x * 0.5, scrn_size.y * 0.4 + 46), 
            color_t(255,255,255, math.floor(alpha2+0.5))
            )
            off = off + 24;
        end

        render.text(norm_font, data.anim.prefix .. 'You have gotten ' .. tostring(data.game.kills) .. ' kills in this game so far', vec2_t(scrn_size.x * 0.5, scrn_size.y * 0.4 + off + 46), color_t(255,255,255, math.floor(alpha2+0.5)))
    end

	return text;
end


callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.EVENT, on_event)