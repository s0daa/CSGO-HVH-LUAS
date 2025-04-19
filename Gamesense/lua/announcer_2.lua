local phrases = {
	kill = ' ENEMY DESTROYED',				-- normal kills
	kill_plural = ' ENEMIES ELIMINATED',
	kill_zk = 'ENEMY EMBARRESED',			-- zeus/knife kills
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
	'GET EM HOES! ',
	'Wonder if he will rq... ',
};

local hs_phrases = {
	'Fatality resovler |--|>  ',
	'Ez for Fatality.win! ',
	'He is ded ',
	'1. ',
	'DING! '
};

local nade_phrases = {
	he = {
		'Bruh. ',
		'BOOM! ',
		'Are you a basketball player? ',
		'Kobe! '
	},
	molly = {
		'Look at his ashes! ',
		'Reminds me of auschwitz...? ',
		'One fried nonamer and a cola, please! '
	}
};

local data = {
	game = {
		kills = 0,
	},
	round = {
		kills = 0,
	},
	persistent = {
		xp = 0,
		next_xp = 750,
		level = 1
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
	{ font = render.create_font('verdana.ttf', 92, render.font_flag_shadow), color = { render.color('#ffffff'), render.color('#ffffff') } },
	{ font = render.create_font('verdana.ttf', 84, render.font_flag_shadow), color = { render.color('#c9deff'), render.color('#ffa6ab') } },
	{ font = render.create_font('verdana.ttf', 72, render.font_flag_shadow), color = { render.color('#a8caff'), render.color('#ff8087') } },
	{ font = render.create_font('verdana.ttf', 64, render.font_flag_shadow), color = { render.color('#87b6ff'), render.color('#ff5e67') } },
	{ font = render.create_font('verdana.ttf', 52, render.font_flag_shadow), color = { render.color('#4287f5'), render.color('#ff424c') } },
};

local bold_font = render.create_font('verdanab.ttf', 24, render.font_flag_shadow);
local norm_font = render.create_font('verdana.ttf', 16, render.font_flag_shadow);

local zk_items = {
	'taser', 'knife', 'bayonet'
};

local function start_animation(is_zk, nade, hs, fire)
	is_zk = is_zk or false
	data.anim.counter = 0;
	data.anim.should_announce = true;
	data.anim.is_zk = is_zk;
	
	local prefix = '';
	if is_zk then
		prefix = zk_phrases[utils.random_int(1, #zk_phrases)];
	elseif hs then
		prefix = hs_phrases[utils.random_int(1, #hs_phrases)];
	elseif nade then
		prefix = nade_phrases.he[utils.random_int(1, #nade_phrases.he)];
	elseif fire then
		prefix = nade_phrases.molly[utils.random_int(1, #nade_phrases.molly)];
	end
	
	data.anim.prefix = prefix;
	
	local realtime = global_vars.realtime;
	data.anim.keys.fade_in = realtime + data.const.counter_dur * (#animation_fonts + 1);
	data.anim.keys.fade_in_stop = data.anim.keys.fade_in + data.const.fade_in_dur;
	data.anim.keys.fade_out = data.anim.keys.fade_in_stop + data.const.fade_hold;
	data.anim.keys.fade_out_stop = data.anim.keys.fade_out + data.const.fade_out_dur;
	data.anim.keys.stop = data.anim.keys.fade_out_stop;
	
	data.anim.global_alpha = 1;
	data.anim.desc_alpha = 0;
	data.anim.counter_update = realtime;
end

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

function on_player_death(ev)
	local lp = engine.get_local_player();
	local attacker = engine.get_player_for_user_id(ev:get_int('attacker'));
	local userid = engine.get_player_for_user_id(ev:get_int('userid'));
	local headshot = ev:get_bool('headshot');
	local weapon = ev:get_string('weapon');
	
	if attacker == lp and userid ~= lp then
		data.game.kills = data.game.kills + 1;
		data.round.kills = data.round.kills + 1;
		
		local zk = false;
		local nade = false;
		local hs = headshot;
		local fire =false;
		
		for i, v in ipairs(zk_items) do
			if string.find(weapon, v) then zk = true end;
		end
		
		if weapon == 'hegrenade' then nade = true end;
		if weapon == 'inferno' then fire = true end;
		
		start_animation(zk, nade, hs, fire);
	end	
end

function on_round_start()
	data.round.kills = 0;
end

function on_level_init()
	data.round.kills = 0;
	data.game.kills = 0;
end

function on_paint()
	if data.anim.should_announce then
		local sx, sy = render.get_screen_size();
		sy = sy - 140;
	
		local realtime = global_vars.realtime;
		if data.anim.keys.stop <= realtime then
			data.anim.should_announce = false;
			return;
		end
		
		if data.anim.counter < #animation_fonts - 1 then
			if realtime - data.anim.counter_update >= data.const.counter_dur then
				data.anim.counter_update = realtime;
				data.anim.counter = data.anim.counter + 1;
			end
		end
		
		if realtime >= data.anim.keys.fade_out and realtime <= data.anim.keys.fade_out_stop then
			data.anim.global_alpha = lerp(0, 1, (data.anim.keys.fade_out_stop - realtime) / (data.anim.keys.fade_out_stop - data.anim.keys.fade_out));
			data.anim.desc_alpha = data.anim.global_alpha;
		end
		
		if realtime >= data.anim.keys.fade_in and realtime <= data.anim.keys.fade_in_stop then
			data.anim.desc_alpha = lerp(0, 1, ((data.anim.keys.fade_in_stop - data.anim.keys.fade_in) - (data.anim.keys.fade_in_stop - realtime)) / (data.anim.keys.fade_in_stop - data.anim.keys.fade_in));
		end
		
		data.anim.desc_alpha = clamp(data.anim.desc_alpha, 1, 0);
		data.anim.global_alpha = clamp(data.anim.global_alpha, 1, 0);
		
		local col_idx = data.anim.is_zk and 2 or 1;
		
		local fnt = animation_fonts[data.anim.counter + 1];
		fnt.color[col_idx].a = data.anim.global_alpha * 255;
		
		local text = tostring(data.round.kills) .. (is_plural(data.round.kills) and phrases.kill_plural or phrases.kill);
		text = data.anim.is_zk and phrases.kill_zk or text;
		
		render.text(fnt.font, sx * 0.5, sy * 0.5, text, fnt.color[col_idx], 1, 1);

		local col = render.color(255, 255, 255, data.anim.desc_alpha * 255);
		
		local off = 0;
		if data.round.kills > 1 then
			render.text(bold_font, sx * 0.5, sy * 0.5 + 46, kill_phrases[clamp(data.round.kills - 1, #kill_phrases, 1)], col, 1, 1);
			off = off + 24;
		end
		
		render.text(norm_font, sx * 0.5, sy * 0.5 + off + 46, data.anim.prefix .. 'You have done ' .. tostring(data.game.kills) .. ' kills in this game so far', col, 1, 1);
	end
end