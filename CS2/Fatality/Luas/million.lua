-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

M = {
    main = {
        groupa = gui.ctx:find("lua>elements a"),
        groupb = gui.ctx:find("lua>elements b")
    },
    tracked_enemies = {},

    screen = {game.engine:get_screen_size()},
    elements_pos = {},
    dragging = {},
    drag_offset = {},
    initial_positions = {},

    _group_reset_this_frame = {
        groupa = false,
        groupb = false
    },
    _last_refresh_time = 0,
    _refresh_cooldown = 0.1,

    temp = {},

    startup_anim = {
        active = true,
        start_time = 0,
        first_frame = true,
        script_started = true,
        letters_million = {"M", "I", "L", "L", "I", "O", "N", "W", "A", "R", "E"},
        letters_premium = {"R", "E", "W", "O", "R", "K", ".", "v", "2"}
    },

    colors = {
        transblack = draw.color(0, 0, 0, 50),
        black = draw.color(0, 0, 0, 100),
        white = draw.color(255, 255, 255),
        gray_line = draw.color(100, 100, 100, 150),
        single_line_color = draw.color(100, 100, 100, 150),
        green = draw.color(0, 255, 0, 255),
        red = draw.color(255, 0, 0, 255)

    },
    KNIFE_RANGE = 80,
    ZEUS_RANGE = 140,

    watermark_custom_text = "millionware",
    apex_watermark_text = "millionware",
    game_text = "game",
    sense_text = "sense",

    bottom_watermark = {
        spacing = 8,
        y_offset = 40,
        bracket_padding = 5
    },

    KEYS = {
        A = 0x41,
        W = 0x57,
        S = 0x53,
        D = 0x44,
        C = 0x11,
        J = 0x20
    },

    indicators = {
        crosshair = {
            last_pos = nil,
            movement_alpha = 255,
            current_text = "- Standing -",
            stable_alpha = 0,
            stable_fade_dir = 1,
            custom_million_text = "million",
            custom_stable_text = "stable",
            wave_position = 0,
            wave_speed = 80,
            glitch_last_update = 0,
            glitch_chars = {},
            glitch_active = false,
            typewriter_start = 0,
            typewriter_phase = "typing",  
            typewriter_pos = 0

        }
    },
    dmg = {
        impacts = {},          
        hitmarkers = {},       
        damage_numbers = {},   
        hitmarker_thickness = 2,  
        hitmarker_length = 10,    
        hitmarker_spacing = 5,    

        heart_hitmarkers = {},  
        HEART_SIZE = 16,        
        HEART_LIFETIME = 4.0,   
        HEART_FADE_TIME = 1.0,  
    },
    hitlogs = {

        nvidia = {
            nvidia_slide_duration = 0.3,
            nvidia_display_duration = 3.0,
            nvidia_fade_duration = 0.5,
            nvidia_max_width = 300,
            nvidia_height = 25 
        }

    },
    nvidia_hitlogs = {},
    nvidia_last_hit = {
    damage = 0,
    hitbox = 0,
    time = 0
    },
    lastHitTime = 0, 
    comprehensive_gs_hitlogs = {},
    gs_hitlogs = {},
    hitlogs_last = {
        damage = 0,
        hitbox = 0,
        time = 0
    },
    last_killsay_time = 0,
    last_deathsay_time = 0,
    killsay_cooldown = 2.0,  
    deathsay_cooldown = 2.0,

    hurtlogs = {},
    hurtlogs_last = {
        damage = 0,
        hitbox = 0,
     time = 0
    },

    HITBOX_NAMES = {
        [1] = "head", [2] = "chest", [3] = "stomach", 
        [4] = "left arm", [5] = "right arm", 
        [6] = "left leg", [7] = "right leg"
    },

    scale_x = nil,
    scale_y = nil,

    current_x_offset = 0,

    game_stats = {
        shots_fired = 0,
        distance_traveled = 0,
        nades_used = 0,
        molotovs_used = 0,
        smokes_used = 0,
        kills = 0,
        deaths = 0,
        ns_kills = 0,
        headshots = 0,
        kill_streaks = {},
        last_position = nil,
        round_number = 0
    },

    UTILITY_WEAPONS = {
        [weapon_id.taser] = true,     
        [weapon_id.hegrenade] = true, 
        [weapon_id.flashbang] = true, 
        [weapon_id.smokegrenade] = true, 
        [weapon_id.molotov] = true,   
        [weapon_id.incgrenade] = true, 
        [weapon_id.decoy] = true,     
        [weapon_id.c4] = true,        
        [weapon_id.knife] = true,     
        [weapon_id.knife_t] = true,   

        [weapon_id.knife_bayonet] = true,
        [weapon_id.knife_css] = true,
        [weapon_id.knife_flip] = true,
        [weapon_id.knife_gut] = true,
        [weapon_id.knife_karambit] = true,
        [weapon_id.knife_m9bayonet] = true,
        [weapon_id.knife_tactical] = true,
        [weapon_id.knife_falchion] = true,
        [weapon_id.knife_survival_bowie] = true,
        [weapon_id.knife_butterfly] = true,
        [weapon_id.knife_push] = true,
        [weapon_id.knife_cord] = true,
        [weapon_id.knife_canis] = true,
        [weapon_id.knife_ursus] = true,
        [weapon_id.knife_gypsy_jackknife] = true,
        [weapon_id.knife_outdoor] = true,
        [weapon_id.knife_stiletto] = true,
        [weapon_id.knife_widowmaker] = true,
        [weapon_id.knife_skeleton] = true
    },
    WEAPON_TO_PATH = {

        [weapon_id.deagle] = "rage>weapon>Desert Eagle>weapon>mindamage",
        [weapon_id.elite] = "rage>weapon>Dual Berettas>weapon>mindamage",
        [weapon_id.fiveseven] = "rage>weapon>Five-SeveN>weapon>mindamage",
        [weapon_id.glock] = "rage>weapon>Glock-18>weapon>mindamage",
        [weapon_id.ak47] = "rage>weapon>AK-47>weapon>mindamage",
        [weapon_id.aug] = "rage>weapon>AUG>weapon>mindamage",
        [weapon_id.awp] = "rage>weapon>AWP>weapon>mindamage",
        [weapon_id.famas] = "rage>weapon>FAMAS>weapon>mindamage",
        [weapon_id.g3sg1] = "rage>weapon>G3SG1>weapon>mindamage",
        [weapon_id.galilar] = "rage>weapon>Galil AR>weapon>mindamage",
        [weapon_id.m249] = "rage>weapon>M249>weapon>mindamage",
        [weapon_id.m4a1] = "rage>weapon>M4A4>weapon>mindamage",
        [weapon_id.mac10] = "rage>weapon>MAC-10>weapon>mindamage",
        [weapon_id.p90] = "rage>weapon>P90>weapon>mindamage",
        [weapon_id.mp5sd] = "rage>weapon>MP5-SD>weapon>mindamage",
        [weapon_id.ump45] = "rage>weapon>UMP-45>weapon>mindamage",
        [weapon_id.xm1014] = "rage>weapon>XM1014>weapon>mindamage",
        [weapon_id.bizon] = "rage>weapon>PP Bizon>weapon>mindamage",
        [weapon_id.mag7] = "rage>weapon>MAG-7>weapon>mindamage",
        [weapon_id.negev] = "rage>weapon>Negev>weapon>mindamage",
        [weapon_id.sawedoff] = "rage>weapon>Sawed Off>weapon>mindamage",
        [weapon_id.tec9] = "rage>weapon>Tec-9>weapon>mindamage",
        [weapon_id.hkp2000] = "rage>weapon>P2000>weapon>mindamage",
        [weapon_id.mp7] = "rage>weapon>MP7>weapon>mindamage",
        [weapon_id.mp9] = "rage>weapon>MP9>weapon>mindamage",
        [weapon_id.nova] = "rage>weapon>Nova>weapon>mindamage",
        [weapon_id.p250] = "rage>weapon>P250>weapon>mindamage",
        [weapon_id.scar20] = "rage>weapon>SCAR-20>weapon>mindamage",
        [weapon_id.sg556] = "rage>weapon>SG 553>weapon>mindamage",
        [weapon_id.ssg08] = "rage>weapon>SSG-08>weapon>mindamage",
        [weapon_id.m4a1_silencer] = "rage>weapon>M4A1-S>weapon>mindamage",
        [weapon_id.usp_silencer] = "rage>weapon>USP-S>weapon>mindamage",
        [weapon_id.cz75a] = "rage>weapon>CZ-75 Auto>weapon>mindamage",
        [weapon_id.revolver] = "rage>weapon>R8 Revolver>weapon>mindamage",

        GROUPS = {
            PISTOLS = {
                path = "rage>weapon>Pistols>weapon>mindamage",
                weapons = {
                    [weapon_id.glock] = true,
                    [weapon_id.p250] = true,
                    [weapon_id.fiveseven] = true,
                    [weapon_id.tec9] = true,
                    [weapon_id.hkp2000] = true,
                    [weapon_id.usp_silencer] = true,
                    [weapon_id.cz75a] = true
                }
            },
            HEAVY_PISTOLS = {
                path = "rage>weapon>Heavy Pistols>weapon>mindamage",
                weapons = {
                    [weapon_id.deagle] = true,
                    [weapon_id.revolver] = true
                }
            },
            SMGS = {
                path = "rage>weapon>SMGs>weapon>mindamage",
                weapons = {
                    [weapon_id.mac10] = true,
                    [weapon_id.mp7] = true,
                    [weapon_id.mp9] = true,
                    [weapon_id.mp5sd] = true,
                    [weapon_id.ump45] = true,
                    [weapon_id.p90] = true,
                    [weapon_id.bizon] = true
                }
            },
            RIFLES = {
                path = "rage>weapon>Rifles>weapon>mindamage",
                weapons = {
                    [weapon_id.ak47] = true,
                    [weapon_id.m4a1] = true,
                    [weapon_id.m4a1_silencer] = true,
                    [weapon_id.famas] = true,
                    [weapon_id.galilar] = true,
                    [weapon_id.aug] = true,
                    [weapon_id.sg556] = true
                }
            },
            HEAVY = {
                path = "rage>weapon>Heavy>weapon>mindamage",
                weapons = {
                    [weapon_id.nova] = true,
                    [weapon_id.xm1014] = true,
                    [weapon_id.sawedoff] = true,
                    [weapon_id.mag7] = true,
                    [weapon_id.m249] = true,
                    [weapon_id.negev] = true
                }
            },
            AUTO_SNIPERS = {
                path = "rage>weapon>Auto Snipers>weapon>mindamage",
                weapons = {
                    [weapon_id.g3sg1] = true,
                    [weapon_id.scar20] = true
                }
            },
            BOLT_SNIPERS = {
                path = "rage>weapon>Bolt Snipers>weapon>mindamage",
                weapons = {
                    [weapon_id.awp] = true,
                    [weapon_id.ssg08] = true
                }
            }
        },

        GENERAL = "rage>weapon>general>weapon>mindamage"
    },
    movement = {

        config = {
            kamidere = {
                line_width = 30,
                line_height = 3,
                line_spacing = 8,
                extra_spacing = 25,
                fade_time = 0.5,
            },
            clarity = {
                line_width = 15,
                line_height = 2,
                line_spacing = 5,
            },
            graph = {
                width = 400,
                height = 150,
            },
            rendering = {
                max_velocity_points = 600,
                max_velocity = 600,
                velocity_climb_rate = 1,
                velocity_fall_rate = 3,
                velocity_sample_rate = 0.001,
                velocity = {
                    padding = 2
                }
            }
        },

        kamidere_active = draw.color(255, 255, 255),
        kamidere_inactive = draw.color(100, 100, 100),
        kamidere_line_inactive = draw.color(50, 50, 50),
        clarity_active = draw.color(255, 255, 255),
        clarity_line_inactive = draw.color(100, 100, 100),

        kamidere_fade_states = {
            W = {active = false, time = 0, y_offset = 0},
            A = {active = false, time = 0, y_offset = 0},
            S = {active = false, time = 0, y_offset = 0},
            D = {active = false, time = 0, y_offset = 0},
            J = {active = false, time = 0, y_offset = 0},
            C = {active = false, time = 0, y_offset = 0}
        },

        velocity = {
            last_pos = nil,
            was_jumping = false,
            takeoff_velocity = 0,
            landing_time = 0,
            should_show_takeoff = false,
            display_duration = 0.5,

            graph = {
                MAX_POINTS = 200,
                MAX_VELOCITY = 400,
                PADDING = 2,
                CLIMB_RATE = 1,
                FALL_RATE = 3,
                SAMPLE_RATE = 0.001,
                velocity_points = {},
                last_pos = nil,
                last_sample_time = 0,
                last_graph_state = false,
                current_smoothed_velocity = 0,
                raw_velocities = {} 
            },

            graphv2 = {
                MAX_POINTS = 600,
                MAX_VELOCITY = 600,
                PADDING = 2,
                CLIMB_RATE = 1,
                FALL_RATE = 3,
                SAMPLE_RATE = 0.001,
                velocity_points = {},
                last_pos = nil,
                last_sample_time = 0,
                last_graph_state = false,
                current_smoothed_velocity = 0,
                raw_velocities = {}
            },

            velocity_bar = {
                velocity_bar_last_pos = nil,
                velocity_bar_curr_velocity = 0
            }
        },
        anti_aim = {

            enable = false,
            desync_type = 1, 
            invert_key = 0x51, 
            invert_state = false,
            manual_left_key = 0x5A, 
            manual_right_key = 0x43, 
            manual_back_key = 0x58, 
            manual_direction = 0, 

            yaw_add = 0,       
            jitter_range = 35, 
            desync_amount = 58, 

            standing = {
                override = false,
                yaw_add = 0,
                jitter_range = 35,
                desync_amount = 58
            },

            moving = {
                override = false,
                yaw_add = 0,
                jitter_range = 35,
                desync_amount = 58
            },

            air = {
                override = false,
                yaw_add = 0,
                jitter_range = 35,
                desync_amount = 58
            },

            slowwalk = {
                override = false,
                yaw_add = 0,
                jitter_range = 35,
                desync_amount = 58
            },

            fake_lag = {
                enable = false,
                amount = 14, 
                random = false,
                fluctuate = false,
                fluctuate_range = {min = 2, max = 14}
            },

            anti_resolver = {
                enable = false,
                trigger_on_hit = true,
                trigger_on_shot = false,
                reset_time = 5.0, 
                last_change_time = 0
            },

            lby_breaker = {
                enable = false,
                delta = 120, 
                speed = 0.35 
            },

            last_update_time = 0,
            current_tick = 0,
            last_choke = 0,
            last_shot_time = 0,
            is_breaking_lby = false,
            last_lby_update = 0,
            hit_triggers = 0,
            last_phase = 0,
            spin_progress = 0,

            presets = {
                ["Default"] = {
                    desync_type = 1,
                    yaw_add = 0,
                    jitter_range = 35,
                    desync_amount = 58
                },
                ["Wide Jitter"] = {
                    desync_type = 2,
                    yaw_add = 0,
                    jitter_range = 120,
                    desync_amount = 58
                },
                ["Slow Spin"] = {
                    desync_type = 3,
                    yaw_add = 0,
                    jitter_range = 0,
                    desync_amount = 58,
                    spin_speed = 10
                },
                ["Randomized"] = {
                    desync_type = 4,
                    yaw_add = 0,
                    jitter_range = 90,
                    desync_amount = 58
                }
            },
            current_preset = "Default",

            debug = {
                real_angle = 0,
                fake_angle = 0,
                desync_delta = 0,
                condition = "standing",
                shots_missed = 0
            }
        },

        keys = {
            kz = {
                last_pos = nil,
                was_jumping = false,
                takeoff_velocity = 0,
                landing_time = 0,
                should_show_takeoff = false,
                display_duration = 0.5,
            },
        },

        trail_positions = {},
        trail_colors = {}
    },
    context_states = {},
    round_stats = {
        config = {
            fade_in_time = 0.3,
            display_time = 5.0,
            fade_out_time = 0.5,
            width = 300,
            height = 200,
            corner_radius = 6,
            line_height = 24,
            padding = 10,
            glow_size = 8
        },

        visuals = {
            opacity = 0,
            state = "hidden",  
            display_start_time = 0,
            show_until_time = 0
        },

        current_round = {
            damage_dealt = 0,
            damage_taken = 0,
            hits_dealt = 0,
            hits_taken = 0,
            headshots_dealt = 0,
            enemies_killed = 0,
            enemies_hurt = {},  
            damage_sources = {}  
        }
    },
    anti_afk = {
        direction = 1,
        last_change = 0,
        change_interval = 0.5,  
        movement_amount = 0.02, 
        current_movement = {forward = 0, side = 0},
        initialized = false
    },
    disconnect_on_end = {
        waiting_for_disconnect = false,
        disconnect_delay = 3.0  
    },
    auto_rs = {
        last_check_time = 0,
        has_sent_reset = false,     
        trigger_threshold = 3,      
        debug_mode = false          
    },
    kill_effects = {

        kill_count = 0,             
        kill_streak = 0,            
        last_kill_time = 0,         
        multi_kill_count = 0,       
        multi_kill_timer = 3.0,     
        track_id = -1,              

        flying_texts = {},

        config = {
            text_duration = 2.0,       
            speed_min = 80,            
            speed_max = 120,           
            size_min = 0.8,            
            size_max = 1.4,            
            color = draw.color(255, 255, 255, 255),  
            headshot_color = draw.color(255, 0, 0, 255),  
            multikill_color = draw.color(255, 165, 0, 255), 
            streak_color = draw.color(0, 255, 255, 255),   

            variations = {             
                "ELIMINATED!",
                "DELETED!",
                "WASTED!",
                "DESTROYED!",
                "TERMINATED!",
                "GOT 'EM!",
                "CRUSHED!",
                "FINISHED!",
            },
            headshot_variations = {    
                "BOOM! HEADSHOT!",
                "HEADSHOT!",
                "CLEAN SHOT!",
                "RIGHT BETWEEN THE EYES!",
                "BULLSEYE!",
                "CRITICAL HIT!"
            },
            multikill_texts = {        
                [2] = "DOUBLE KILL!",
                [3] = "TRIPLE KILL!",
                [4] = "QUADRA KILL!",
                [5] = "PENTA KILL!",
                [6] = "MEGA KILL!",
                [10] = "GODLIKE!",
            },
            killstreak_prefix = "KILLSTREAK: ", 
            streak_thresholds = {3, 5, 10, 15, 20, 25}, 

            hit_messages = {                
                "HIT!",
                "TAGGED!",
                "DINKED!",
                "CLIPPED!",
                "DAMAGED!",
                "PINGED!",
                "TAGGED!",
                "CONNECTED!"
            },
            hit_headshot_messages = {       
                "DINK!",
                "HEADSHOT!",
                "PINGED HEAD!",
                "HEAD HIT!",
                "CRACKED!",
                "BONK!",
                "TAGGED HEAD!"
            },
            knife_kill_messages = {         
                "SHANKED!",
                "STABBED!",
                "SLICED!",
                "BUTCHERED!",
                "CARVED UP!",
                "COLD STEEL!",
                "CUT DOWN!",
                "GUTTED!"
            },
            zeus_kill_messages = {          
                "ELECTRIFIED!",
                "SHOCKED!",
                "ZAPPED!",
                "THUNDERSTRUCK!",
                "LIGHTNING STRIKE!",
                "ELECTROCUTED!",
                "VOLTS OF PAIN!",
                "POWER SURGE!"
            },
            grenade_kill_messages = {         
                "FRAGGED!",
                "BOOM!",
                "KABOOM!",
                "BLASTED!",
                "EXPLODED!",
                "BLOWN UP!",
                "SHRAPNEL!",
                "GRENADED!"
            },
            molotov_kill_messages = {         
                "ROASTED!",
                "BURNED!",
                "TOASTED!",
                "INCINERATED!",
                "FRIED!",
                "SCORCHED!",
                "FLAME-BROILED!",
                "CREMATED!"
            },
            jumpshot_kill_messages = {        
                "AIR SHOT!",
                "MID-AIR!",
                "ACROBATIC!",
                "GRAVITY DEFYING!",
                "AERIAL ATTACK!",
                "JUMP SHOT!",
                "FLYING KILL!",
                "HANG TIME!"
            },
            grenade_color = draw.color(255, 100, 0, 255),   
            molotov_color = draw.color(255, 50, 0, 255),    
            jumpshot_color = draw.color(100, 200, 255, 255), 

            hit_color = draw.color(200, 200, 255, 255),         
            hit_headshot_color = draw.color(255, 150, 0, 255),  
            hit_text_duration = 1.0,        
            hit_size_factor = 0.8,          
        }
    },
    flying_hitlogs = {

        texts = {},

        config = {
            text_duration = 5.0,       
            speed_min = 40,            
            speed_max = 70,            
            size_min = 0.8,            
            size_max = 1.2,            
            normal_color = draw.color(255, 255, 255, 255),  
            headshot_color = draw.color(255, 150, 0, 255),  
            hit_min_damage = 1,        
            name_color = draw.color(100, 200, 255, 255),    
            damage_color = draw.color(255, 100, 100, 255),  
            health_low_color = draw.color(255, 50, 50, 255), 
            health_high_color = draw.color(50, 255, 50, 255), 

            chars_per_second = 20,     
            backspace_per_second = 35, 
            delay_before_backspace = 1.0, 
            cursor_blink_rate = 0.5,   
        }
    }

}

local base_width, base_height = 2560, 1440
M.scale_x = M.screen[1] / base_width
M.scale_y = M.screen[2] / base_height

M.elements_pos.watermark = {x = M.screen[1] - 250, y = 20}
M.elements_pos.gs_watermark = {x = M.screen[1] - 250, y = 15}
M.elements_pos.apex_watermark = {x = M.screen[1] - 250, y = 15}
M.elements_pos.legit_indicators = {x = 1270 * M.scale_x, y = 1175 * M.scale_y}
M.elements_pos.comprehensive_gs_logs = {x = M.screen[1] / 2 - 300, y = M.screen[2] - 200}
M.elements_pos.kamidere_keys = {x = (M.screen[1] - ((M.movement.config.kamidere.line_width * 6) + (M.movement.config.kamidere.line_spacing * 4) + M.movement.config.kamidere.extra_spacing)) / 2, y = M.screen[2] - 150}
M.elements_pos.clarity_keys = {x = (M.screen[1] / 2) - 25, y = 200}
M.elements_pos.kz_keys = {x = M.screen[1] / 2 - 200, y = M.screen[2] / 2 + 200}
M.elements_pos.velocity_graph = {x = (M.screen[1] / 2) - (M.movement.config.graph.width / 2), y = M.screen[2] - 450}
M.elements_pos.velocity_graphv2 = {x = (M.screen[1] / 2) - (M.movement.config.graph.width / 2), y = M.screen[2] - 450}
M.elements_pos.velocity_indicator = {x = M.screen[1] / 2, y = M.screen[2] - 290}
M.elements_pos.velocity_bar = {x = M.screen[1] / 2 - 100, y = M.screen[2] - 200}
M.elements_pos.keybinds = {x = 45, y = 835}
M.elements_pos.enemy_list = {x = 260, y = 403}
M.elements_pos.game_stats = {x = 20, y = 400}
M.elements_pos.rainbow_line = {x = 0, y = 0}
M.elements_pos.active_streaks = {x = 20, y = 725}
M.elements_pos.round_stats = {x = M.screen[1] / 2 - 150, y = M.screen[2] / 2 - 100}

M.dragging.watermark = false
M.dragging.gs_watermark = false
M.dragging.apex_watermark = false
M.dragging.legit_indicators = false
M.dragging.comprehensive_gs_logs = false
M.dragging.kamidere_keys = false
M.dragging.clarity_keys = false
M.dragging.kz_keys = false
M.dragging.velocity_graph = false
M.dragging.velocity_graphv2 = false
M.dragging.velocity_indicator = false
M.dragging.velocity_bar = false
M.dragging.keybinds = false
M.dragging.enemy_list = false
M.dragging.game_stats = false
M.dragging.active_streaks = false
M.dragging.round_stats = false

M.drag_offset.watermark = {x = 0, y = 0}
M.drag_offset.gs_watermark = {x = 0, y = 0}
M.drag_offset.apex_watermark = {x = 0, y = 0}
M.drag_offset.legit_indicators = {x = 0, y = 0}
M.drag_offset.comprehensive_gs_logs = {x = 0, y = 0}
M.drag_offset.kamidere_keys = {x = 0, y = 0}
M.drag_offset.clarity_keys = {x = 0, y = 0}
M.drag_offset.kz_keys = {x = 0, y = 0}
M.drag_offset.velocity_graph = {x = 0, y = 0}
M.drag_offset.velocity_graphv2 = {x = 0, y = 0}
M.drag_offset.velocity_indicator = {x = 0, y = 0}
M.drag_offset.velocity_bar = {x = 0, y = 0}
M.drag_offset.keybinds = {x = 0, y = 0}
M.drag_offset.enemy_list = {x = 0, y = 0}
M.drag_offset.game_stats = {x = 0, y = 0}
M.drag_offset.game_stats = {x = 0, y = 0}
M.drag_offset.active_streaks = {x = 0, y = 0}
M.drag_offset.round_stats = {x = 0, y = 0}

M.initial_positions = {
    millionware = true,
    gamesense = true,
    apex = true
}
M.main.groupa = gui.ctx:find("lua>elements a")
M.main.groupb = gui.ctx:find("lua>elements b")

function smart_reset(group, force)
    local current_time = game.global_vars.real_time

    if force or not M._group_reset_this_frame[group] then
        if current_time - M._last_refresh_time >= M._refresh_cooldown or force then
            if group == "groupa" and M.main.groupa then
                M.main.groupa:reset()
                M._group_reset_this_frame.groupa = true
            elseif group == "groupb" and M.main.groupb then
                M.main.groupb:reset()
                M._group_reset_this_frame.groupb = true
            end
            M._last_refresh_time = current_time
        end
    end
end
function conditional_reset(group)
    if not M._group_reset_this_frame[group] then
        if group == "groupa" and M.main.groupa then
            M.main.groupa:reset()
            M._group_reset_this_frame.groupa = true
        elseif group == "groupb" and M.main.groupb then
            M.main.groupb:reset()
            M._group_reset_this_frame.groupb = true
        end
    end
end

function safe_add_control(group, control, label)
    local wrapped_control = gui.make_control(label, control)
    group:add(wrapped_control)
    group:reset()

    print(string.format("Added control to %s:", 
        (group == M.main.groupa and "Group A" or "Group B")))
    print("  Label: " .. tostring(label))
    print("  Control Type: " .. tostring(control.type))
end

local title_label = gui.label(gui.control_id("title_label"), "                      Million.lua - Premium", draw.color(255, 255, 255, 255), true)
M.main.groupa:add(title_label)
smart_reset("groupa")

M.accent_picker = gui.color_picker(gui.control_id("accent_color"))
M.accent_picker:get_value():set(draw.color(0, 209, 255, 255))
M.main.groupa:add(gui.make_control("Lua Accent Color", M.accent_picker))
smart_reset("groupa")

M.watermarks_combo = gui.combo_box(gui.control_id("watermarks"))
M.watermarks_combo.allow_multiple = true

local watermark_options = {
    {"Millionware", 1},
    {"Gamesense", 2},
    {"Bottom Watermark", 4},
}

for _, option in ipairs(watermark_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.watermarks_combo:add(option_sel)
end

M.main.groupa:add(gui.make_control("Watermarks", M.watermarks_combo))
smart_reset("groupa")

M.indicators_combo = gui.combo_box(gui.control_id("indicators"))
M.indicators_combo.allow_multiple = true

local indicators_options = {
    {"Legit", 1},
    {"Crosshair", 2}
}

for _, option in ipairs(indicators_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.indicators_combo:add(option_sel)
end

M.main.groupa:add(gui.make_control("Indicators", M.indicators_combo))
smart_reset("groupa")

M.hitlogs_display_combo = gui.combo_box(gui.control_id("hitlogs_display"))
M.hitlogs_display_combo.allow_multiple = true

local hitlogs_display_controls = {
    {"Normal", 1},
    {"Gamesense", 2},
    {"Notifications", 4},
    {"NVIDIA", 8},
    {"Advanced GS", 16},
    {"Create Dummy Hitlog", 32},
    {"Console Logs", 64},
    {"Flying", 128}

}

for _, option in ipairs(hitlogs_display_controls) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_display_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.hitlogs_display_combo:add(option_sel)
end    

local hitlogs_display_wrapper = gui.make_control("Hitlogs", M.hitlogs_display_combo)
M.main.groupa:add(hitlogs_display_wrapper)
M.hitlogs_display_wrapper = hitlogs_display_wrapper 
smart_reset("groupa")

M.damage_effects_combo = gui.combo_box(gui.control_id("damage_effects"))
M.damage_effects_combo.allow_multiple = true

local damage_effects_controls = {
    {"Damage Numbers", 1},
    {"Hitmarkers", 2},
    {"Custom Hitmarkers", 4},
    {"Killsay", 8},
    {"Deathsay", 16},
    {"Kill Effects", 32}, 

}

for _, option in ipairs(damage_effects_controls) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_effects_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.damage_effects_combo:add(option_sel)
end    

local damage_effects_wrapper = gui.make_control("Damage Related", M.damage_effects_combo)
M.main.groupa:add(damage_effects_wrapper)
M.damage_effects_wrapper = damage_effects_wrapper 
smart_reset("groupa")

M.movement_combo = gui.combo_box(gui.control_id("movement_features"))
M.movement_combo.allow_multiple = true

local movement_options = {
    {"Kamidere Keys", 1},
    {"Clarity Keys", 2},
    {"KZ Keys", 4},
    {"Velocity Graph", 8},
    {"Velocity Graph v2", 16},
    {"Velocity Indicator", 32},
    {"Velocity Bar", 64},
    {"Trails", 128}
}

for _, option in ipairs(movement_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.movement_combo:add(option_sel)
end

M.main.groupa:add(gui.make_control("Movement", M.movement_combo))
smart_reset("groupa")

M.other_visuals_combo = gui.combo_box(gui.control_id("other_visuals"))
M.other_visuals_combo.allow_multiple = true

local other_visuals_options = {
    {"Keybinds", 1},
    {"Enemy List", 2},
    {"Rainbow Line", 4},
    {"Game Stats", 8},
    {"Active Streaks", 16},
    {"Round Stats", 32},
    {"Knife Range Visualizer", 64},
    {"Zeus Range Visualizer", 128}
}

for _, option in ipairs(other_visuals_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_visual_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.other_visuals_combo:add(option_sel)
end

M.main.groupa:add(gui.make_control("Other Visuals", M.other_visuals_combo))
smart_reset("groupa")

M.game_related_combo = gui.combo_box(gui.control_id("game_related"))
M.game_related_combo.allow_multiple = true

local game_related_options = {
    {"Anti Afk", 1},
    {"Disconnect on Game End", 2},
    {"Auto RS", 4}
}

for _, option in ipairs(game_related_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_game_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.game_related_combo:add(option_sel)
end

local game_related_wrapper = gui.make_control("Game Related", M.game_related_combo)
M.main.groupa:add(game_related_wrapper)
M.game_related_wrapper = game_related_wrapper 
smart_reset("groupa")

M.watermark_elements_combo = gui.combo_box(gui.control_id("watermark_elements"))
M.watermark_elements_combo.allow_multiple = true

local watermark_element_options = {
    {"Username", 1},
    {"FPS", 2},
    {"Ping", 4},
    {"Server Type", 8},
    {"Server IP", 16},
    {"Map", 32},
    {"Time", 64},
    {"Tick", 128},
    {"Players", 256}
}

for _, option in ipairs(watermark_element_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.watermark_elements_combo:add(option_sel)
end

local watermark_elements_wrapper = gui.make_control("Watermark Elements", M.watermark_elements_combo)
M.main.groupb:add(watermark_elements_wrapper)
M.watermark_elements_wrapper = watermark_elements_wrapper 
smart_reset("groupb")

M.watermark_text_input = gui.text_input(gui.control_id("watermark_custom_text"))
M.watermark_text_input.placeholder = "custom watermark text"
M.watermark_text_input:set_value(M.watermark_custom_text) 

M.watermark_text_wrapper = gui.make_control("Millionware Txt", M.watermark_text_input)
M.main.groupb:add(M.watermark_text_wrapper)
smart_reset("groupb")

function M.update_watermark_text()
    M.watermark_custom_text = M.watermark_text_input.value
end

events.present_queue:add(M.update_watermark_text)

M.gamesense_text_input = gui.text_input(gui.control_id("gamesense_custom_text"))
M.gamesense_text_input.placeholder = "Enter GameSense text..."
M.gamesense_text_input:set_value(M.game_text) 

M.sense_text_input = gui.text_input(gui.control_id("gamesense_sense_text"))
M.sense_text_input.placeholder = "Enter sense text..."
M.sense_text_input:set_value(M.sense_text) 

M.gamesense_text_wrapper = gui.make_control("GS Game Txt", M.gamesense_text_input)
M.main.groupb:add(M.gamesense_text_wrapper)
smart_reset("groupb")

M.sense_text_wrapper = gui.make_control("GS Sense Txt", M.sense_text_input)
M.main.groupb:add(M.sense_text_wrapper)
smart_reset("groupb")

function M.update_gamesense_text()
    M.game_text = M.gamesense_text_input.value
    M.sense_text = M.sense_text_input.value
end

events.present_queue:add(M.update_gamesense_text)

M.legit_indicator_controls_combo = gui.combo_box(gui.control_id("legit_indicator_controls"))
M.legit_indicator_controls_combo.allow_multiple = true

local legit_indicator_options = {
    {"Jump Bug", 1},
    {"Edge Jump", 2},
    {"Trigger", 4}
}

for _, option in ipairs(legit_indicator_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.legit_indicator_controls_combo:add(option_sel)
end

local legit_elements_wrapper = gui.make_control("Legit Indicators", M.legit_indicator_controls_combo)
M.main.groupb:add(legit_elements_wrapper)
M.legit_elements_wrapper = legit_elements_wrapper 
smart_reset("groupb")

M.crosshair_indicator_controls_combo = gui.combo_box(gui.control_id("crosshair_indicator_controls"))
M.crosshair_indicator_controls_combo.allow_multiple = true

local crosshair_indicator_options = {
    {"MinDamage", 1},
    {"Hitchance", 2},
    {"Pointscale", 4},
    {"Delay Shot", 8},
    {"Baim", 16},
    {"Force Shot", 32},
    {"Force Head", 64},
    {"No Spread", 128},
    {"Hide Shots", 256},
    {"Double Tap", 512}
}

for _, option in ipairs(crosshair_indicator_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_list_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.crosshair_indicator_controls_combo:add(option_sel)
end

local crosshair_elements_wrapper = gui.make_control("Crosshair Indicators", M.crosshair_indicator_controls_combo)
M.main.groupb:add(crosshair_elements_wrapper)
M.crosshair_elements_wrapper = crosshair_elements_wrapper 
smart_reset("groupb")
M.main.groupb:reset()

M.keybinds_list_combo = gui.combo_box(gui.control_id("keybinds_list"))
M.keybinds_list_combo.allow_multiple = true

local keybind_options = {
    {"Delay Shot", 1},
    {"Baim", 2},
    {"Force Shot", 4},
    {"Force Head", 8},
    {"No Spread", 16},
    {"Legit Aimbot", 32},
    {"Legit Silent Aim", 64},
    {"Recoil Control", 128},
    {"Triggerbot", 256},
    {"BunnyHop", 512},
    {"JumpBug", 1024},
    {"Edgejump", 2048},
    {"Hide Shots", 4096},
    {"Double Tap", 8192}
}

for _, option in ipairs(keybind_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_keybind_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.keybinds_list_combo:add(option_sel)
end

M.keybinds_list_wrapper = gui.make_control("Keybinds", M.keybinds_list_combo)
M.main.groupb:add(M.keybinds_list_wrapper)
smart_reset("groupb")

M.anti_afk_direction_speed = gui.slider(gui.control_id("anti_afk_direction_speed"), 0.01, 5.0, {"%.2f sec"}, 0.5)
M.anti_afk_distance = gui.slider(gui.control_id("anti_afk_distance"), 0.01, 1.0, {"%.2f"}, 0.02)
M.anti_afk_random = gui.checkbox(gui.control_id("anti_afk_random"))

local direction_speed_wrapper = gui.make_control("AFK Direction Speed", M.anti_afk_direction_speed)
local distance_wrapper = gui.make_control("AFK Movement Dist", M.anti_afk_distance)
local random_wrapper = gui.make_control("Randomize Movement", M.anti_afk_random)

M.main.groupb:add(direction_speed_wrapper)
M.main.groupb:add(distance_wrapper)
M.main.groupb:add(random_wrapper)

M.direction_speed_wrapper = direction_speed_wrapper
M.distance_wrapper = distance_wrapper
M.random_wrapper = random_wrapper

M.direction_speed_wrapper:set_visible(false)
M.distance_wrapper:set_visible(false)
M.random_wrapper:set_visible(false)

M.remove_status_checkbox = gui.checkbox(gui.control_id("remove_status"))
M.remove_status_checkbox:set_value(false)
local remove_status_wrapper = gui.make_control("Remove Status Indicator", M.remove_status_checkbox)
M.main.groupb:add(remove_status_wrapper)
M.remove_status_wrapper = remove_status_wrapper 

M.remove_dormant_checkbox = gui.checkbox(gui.control_id("remove_dormant"))
M.remove_dormant_checkbox:set_value(false)
local remove_dormant_wrapper = gui.make_control("Remove Million Stable", M.remove_dormant_checkbox)
M.main.groupb:add(remove_dormant_wrapper)
M.remove_dormant_wrapper = remove_dormant_wrapper 

M.million_text_input = gui.text_input(gui.control_id("million_text"))
M.million_text_input.placeholder = "Enter million text..."
M.million_text_input:set_value(M.indicators.crosshair.custom_million_text) 

M.million_text_wrapper = gui.make_control("Million Text", M.million_text_input)
M.main.groupb:add(M.million_text_wrapper)
smart_reset("groupb")

M.stable_text_input = gui.text_input(gui.control_id("stable_text"))
M.stable_text_input.placeholder = "Enter stable text..."
M.stable_text_input:set_value(M.indicators.crosshair.custom_stable_text) 

M.stable_text_wrapper = gui.make_control("Stable Text", M.stable_text_input)
M.main.groupb:add(M.stable_text_wrapper)

smart_reset("groupb")
M.main.groupb:reset()

M.indicator_style_combo = gui.combo_box(gui.control_id("indicator_style_combo"))
M.indicator_style_combo.allow_multiple = false  

local style_options = {
    {"Pulse", 1},
    {"Wave", 2},
    {"Rainbow Wave", 4},
    {"Bounce", 8},
    {"Glitch", 16},
    {"Typewriter", 32}
}

for _, option in ipairs(style_options) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_style_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.indicator_style_combo:add(option_sel)
end

M.indicator_style_wrapper = gui.make_control("Indicator Style", M.indicator_style_combo)
M.main.groupb:add(M.indicator_style_wrapper)
smart_reset("groupb")

function M.update_million_stable_text()
    if M.million_text_input.value ~= "" then
        M.indicators.crosshair.custom_million_text = M.million_text_input.value
    end

    if M.stable_text_input.value ~= "" then
        M.indicators.crosshair.custom_stable_text = M.stable_text_input.value
    end
end

events.present_queue:add(M.update_million_stable_text)

M.damage_numbers_color = gui.color_picker(gui.control_id("Damage Numbers Color"))
M.damage_numbers_color:get_value():set(draw.color(255, 255, 255, 255))
local damage_numbers_color_wrapper = gui.make_control("Damage Numbers Color", M.damage_numbers_color)
M.main.groupb:add(damage_numbers_color_wrapper)
M.damage_numbers_color_wrapper = damage_numbers_color_wrapper
smart_reset("groupb")

M.hitmarkers_color = gui.color_picker(gui.control_id("Hitmarkers Color"))
M.hitmarkers_color:get_value():set(draw.color(255, 255, 255, 255))
local hitmarkers_color_wrapper = gui.make_control("Hitmarkers Color", M.hitmarkers_color)
M.main.groupb:add(hitmarkers_color_wrapper)
M.hitmarkers_color_wrapper = hitmarkers_color_wrapper
smart_reset("groupb")

M.heart_hitmarker_color = gui.color_picker(gui.control_id("Heart Hitmarker Color"))
M.heart_hitmarker_color:get_value():set(draw.color(255, 0, 50, 255))
local heart_color_wrapper = gui.make_control("Heart Hitmarker Color", M.heart_hitmarker_color)
M.main.groupb:add(heart_color_wrapper)
M.heart_color_wrapper = heart_color_wrapper
smart_reset("groupb")

M.hitmarker_shape_combo = gui.combo_box(gui.control_id("hitmarker_shape"))

local hitmarker_shapes = {
    {"Heart", 1},
    {"Diamond", 2},        
    {"Ruby", 4},
    {"Star", 8},
    {"Cross", 16},
    {"Skull", 32},         
    {"Arrow", 64},        
    {"Classic X", 128},    
    {"Lightning", 256},   
    {"Smiley", 512},      
    {"Question", 1024},   
    {"Dollar", 2048},   
}

for _, option in ipairs(hitmarker_shapes) do
    local option_name = option[1]
    local option_id = gui.control_id(option_name .. "_shape_select")
    local option_sel = gui.selectable(option_id, option_name)
    M.hitmarker_shape_combo:add(option_sel)
end

M.hitmarker_shape_wrapper = gui.make_control("Hitmarker Shape", M.hitmarker_shape_combo)

M.main.groupb:add(M.hitmarker_shape_wrapper)
smart_reset("groupb")

M.hitmarker_shape_wrapper:set_visible(false)

M.killsay_input = gui.text_input(gui.control_id("killsay_text"))
M.killsay_input.placeholder = "Enter killsay message... ({player} = victim name)"
M.killsay_input:set_value("You pay? @{player}")

M.deathsay_input = gui.text_input(gui.control_id("deathsay_text"))
M.deathsay_input.placeholder = "Enter deathsay message... ({player} = killer name)"
M.deathsay_input:set_value("):")

local killsay_wrapper = gui.make_control("Killsay Message", M.killsay_input)
local deathsay_wrapper = gui.make_control("Deathsay Message", M.deathsay_input)

M.killsay_wrapper = killsay_wrapper
M.deathsay_wrapper = deathsay_wrapper

M.main.groupb:add(M.killsay_wrapper)
smart_reset("groupb")
M.main.groupb:add(M.deathsay_wrapper)
smart_reset("groupb")

M.killsay_wrapper:set_visible(false)
M.deathsay_wrapper:set_visible(false)

M.trail_color = gui.color_picker(gui.control_id("Trail Color"))
M.trail_color:get_value():set(draw.color(0, 209, 255, 255))
M.trail_color_wrapper = gui.make_control("Trail Color", M.trail_color)

M.rainbow_trail = gui.checkbox(gui.control_id("Rainbow Trail"))
M.rainbow_trail_wrapper = gui.make_control("Rainbow Trail", M.rainbow_trail)

M.trail_thickness = gui.slider(gui.control_id("Trail Thickness"), 1, 10, 2)
M.trail_thickness_wrapper = gui.make_control("Trail Thickness", M.trail_thickness)

M.trail_length = gui.slider(gui.control_id("Trail Length"), 50, 500, 150)
M.trail_length_wrapper = gui.make_control("Trail Length", M.trail_length)

M.trail_glow_size = gui.slider(gui.control_id("Trail Glow Size"), 1, 50, 10)
M.trail_glow_size_wrapper = gui.make_control("Trail Glow Size", M.trail_glow_size)

M.trail_glow_intensity = gui.slider(gui.control_id("Trail Glow Intensity"), 1, 100, 50)
M.trail_glow_intensity_wrapper = gui.make_control("Trail Glow Intensity", M.trail_glow_intensity)

M.velocity_line_color = gui.color_picker(gui.control_id("Velocity Line Color"))
M.velocity_line_color:get_value():set(draw.color(255, 255, 255, 255))
M.velocity_line_color_wrapper = gui.make_control("Velocity Line Color", M.velocity_line_color)

M.main.groupb:add(M.rainbow_trail_wrapper)
M.main.groupb:add(M.trail_color_wrapper)
M.main.groupb:add(M.trail_thickness_wrapper)
M.main.groupb:add(M.trail_length_wrapper)
M.main.groupb:add(M.trail_glow_size_wrapper)
M.main.groupb:add(M.trail_glow_intensity_wrapper)
M.main.groupb:add(M.velocity_line_color_wrapper)
smart_reset("groupb")

M.knife_rainbow = gui.checkbox(gui.control_id('knife_rainbow_mode'))
M.knife_rainbow:set_value(false)
M.knife_rainbow_wrapper = gui.make_control('Rainbow Mode', M.knife_rainbow)

M.knife_color = gui.color_picker(gui.control_id('knife_ring_color'))
M.knife_color:get_value():set(draw.color(255, 0, 0, 180))  
M.knife_color_wrapper = gui.make_control('Ring Color', M.knife_color)

M.knife_thickness = gui.slider(gui.control_id('knife_line_thickness'), 1, 5, {'%.1f'}, 1.5)
M.knife_thickness_wrapper = gui.make_control('Line Thickness', M.knife_thickness)

M.main.groupb:add(M.knife_rainbow_wrapper)
M.main.groupb:add(M.knife_color_wrapper)
M.main.groupb:add(M.knife_thickness_wrapper)

M.knife_rainbow_wrapper:set_visible(false)
M.knife_color_wrapper:set_visible(false)
M.knife_thickness_wrapper:set_visible(false)
smart_reset("groupb")

M.zeus_rainbow = gui.checkbox(gui.control_id('zeus_rainbow_mode'))
M.zeus_rainbow:set_value(false)
M.zeus_rainbow_wrapper = gui.make_control('Rainbow Mode', M.zeus_rainbow)

M.zeus_color = gui.color_picker(gui.control_id('zeus_ring_color'))
M.zeus_color:get_value():set(draw.color(255, 255, 0, 180))  
M.zeus_color_wrapper = gui.make_control('Ring Color', M.zeus_color)

M.zeus_thickness = gui.slider(gui.control_id('zeus_line_thickness'), 1, 5, {'%.1f'}, 1.5)
M.zeus_thickness_wrapper = gui.make_control('Line Thickness', M.zeus_thickness)

M.main.groupb:add(M.zeus_rainbow_wrapper)
M.main.groupb:add(M.zeus_color_wrapper)
M.main.groupb:add(M.zeus_thickness_wrapper)

M.zeus_rainbow_wrapper:set_visible(false)
M.zeus_color_wrapper:set_visible(false)
M.zeus_thickness_wrapper:set_visible(false)
smart_reset("groupb")

function M.comprehensive_update()

    local watermark_value = M.watermarks_combo:get_value():get():get_raw()
    local indicators_value = M.indicators_combo:get_value():get():get_raw()
    local hitlogs_value = M.hitlogs_display_combo:get_value():get():get_raw()
    local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
    local movement_value = M.movement_combo:get_value():get():get_raw()
    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    local game_related_value = M.game_related_combo:get_value():get():get_raw()
    local keybinds_value = M.keybinds_list_combo:get_value():get():get_raw()

    local mill_watermark_visible = type(watermark_value) == "number" and bit.band(watermark_value, 1) ~= 0
    local gs_watermark_visible = type(watermark_value) == "number" and bit.band(watermark_value, 2) ~= 0

    if M.watermark_elements_wrapper then
        local mill_watermark_visible = type(watermark_value) == "number" and bit.band(watermark_value, 1) ~= 0
        local gs_watermark_visible = type(watermark_value) == "number" and bit.band(watermark_value, 2) ~= 0

        M.watermark_elements_wrapper:set_visible(mill_watermark_visible or gs_watermark_visible)
    end

    if M.watermark_text_wrapper then
        M.watermark_text_wrapper:set_visible(mill_watermark_visible)
    end

    if M.gamesense_text_wrapper then
        M.gamesense_text_wrapper:set_visible(gs_watermark_visible)
    end

    if M.sense_text_wrapper then
        M.sense_text_wrapper:set_visible(gs_watermark_visible)
    end

    if M.hitmarker_shape_wrapper then
        local heart_hitmarkers_enabled = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 4) ~= 0
        M.hitmarker_shape_wrapper:set_visible(heart_hitmarkers_enabled)
    end

    if M.zeus_rainbow_wrapper then
        local zeus_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 128) ~= 0
        M.zeus_rainbow_wrapper:set_visible(zeus_range_enabled)
    end

    if M.zeus_color_wrapper then
        local zeus_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 128) ~= 0
        M.zeus_color_wrapper:set_visible(zeus_range_enabled)
    end

    if M.zeus_thickness_wrapper then
        local zeus_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 128) ~= 0
        M.zeus_thickness_wrapper:set_visible(zeus_range_enabled)
    end

    if M.direction_speed_wrapper then
        local anti_afk_enabled = type(game_related_value) == "number" and bit.band(game_related_value, 1) ~= 0
        M.direction_speed_wrapper:set_visible(anti_afk_enabled)
    end

    if M.distance_wrapper then
        local anti_afk_enabled = type(game_related_value) == "number" and bit.band(game_related_value, 1) ~= 0
        M.distance_wrapper:set_visible(anti_afk_enabled)
    end

    if M.random_wrapper then
        local anti_afk_enabled = type(game_related_value) == "number" and bit.band(game_related_value, 1) ~= 0
        M.random_wrapper:set_visible(anti_afk_enabled)
    end

    if M.legit_elements_wrapper then
        local legit_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 1) ~= 0
        M.legit_elements_wrapper:set_visible(legit_indicators_visible)
    end

    if M.crosshair_elements_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.crosshair_elements_wrapper:set_visible(crosshair_indicators_visible)
    end

    if M.remove_status_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.remove_status_wrapper:set_visible(crosshair_indicators_visible)
    end

    if M.remove_dormant_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.remove_dormant_wrapper:set_visible(crosshair_indicators_visible)
    end

    if M.million_text_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.million_text_wrapper:set_visible(crosshair_indicators_visible)
    end

    if M.stable_text_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.stable_text_wrapper:set_visible(crosshair_indicators_visible)

    end
    if M.indicator_style_wrapper then
        local crosshair_indicators_visible = type(indicators_value) == "number" and bit.band(indicators_value, 2) ~= 0
        M.indicator_style_wrapper:set_visible(crosshair_indicators_visible)
    end

    if M.damage_numbers_color_wrapper then
        local damage_numbers_visible = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 1) ~= 0
        M.damage_numbers_color_wrapper:set_visible(damage_numbers_visible)
    end

    if M.hitmarkers_color_wrapper then
        local hitmarkers_visible = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 2) ~= 0
        M.hitmarkers_color_wrapper:set_visible(hitmarkers_visible)
    end

    if M.heart_color_wrapper then
        local heart_hitmarkers_visible = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 4) ~= 0
        M.heart_color_wrapper:set_visible(heart_hitmarkers_visible)
    end

    if M.killsay_wrapper then
        local killsay_visible = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 8) ~= 0
        M.killsay_wrapper:set_visible(killsay_visible)
    end

    if M.deathsay_wrapper then
        local deathsay_visible = type(damage_effects_value) == "number" and bit.band(damage_effects_value, 16) ~= 0
        M.deathsay_wrapper:set_visible(deathsay_visible)
    end

    if M.rainbow_trail_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.rainbow_trail_wrapper:set_visible(trails_enabled)
    end

    if M.trail_color_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.trail_color_wrapper:set_visible(trails_enabled and not M.rainbow_trail:get_value():get())
    end

    if M.trail_thickness_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.trail_thickness_wrapper:set_visible(trails_enabled)
    end

    if M.trail_length_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.trail_length_wrapper:set_visible(trails_enabled)
    end

    if M.trail_glow_size_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.trail_glow_size_wrapper:set_visible(trails_enabled)
    end

    if M.trail_glow_intensity_wrapper then
        local trails_enabled = type(movement_value) == "number" and bit.band(movement_value, 128) ~= 0
        M.trail_glow_intensity_wrapper:set_visible(trails_enabled)
    end

    if M.velocity_line_color_wrapper then
        local velocity_graphv2_enabled = type(movement_value) == "number" and bit.band(movement_value, 16) ~= 0
        M.velocity_line_color_wrapper:set_visible(velocity_graphv2_enabled)
    end

    if M.keybinds_list_wrapper then
        local keybinds_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 1) ~= 0
        M.keybinds_list_wrapper:set_visible(keybinds_enabled)
    end

    if M.knife_rainbow_wrapper then
        local knife_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 64) ~= 0
        M.knife_rainbow_wrapper:set_visible(knife_range_enabled)
    end

    if M.knife_color_wrapper then
        local knife_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 64) ~= 0
        M.knife_color_wrapper:set_visible(knife_range_enabled)
    end

    if M.knife_thickness_wrapper then
        local knife_range_enabled = type(other_visuals_value) == "number" and bit.band(other_visuals_value, 64) ~= 0
        M.knife_thickness_wrapper:set_visible(knife_range_enabled)
    end

    conditional_reset("groupa")
    conditional_reset("groupb")
end

events.present_queue:add(M.comprehensive_update)

function M.get_username()
    return gui.ctx.user and gui.ctx.user.username or "Unknown"
end

M.frame_time_samples = {}
M.MAX_SAMPLES = 64

function M.calculate_fps()
    local current_frame_time = game.global_vars.frame_time

    table.insert(M.frame_time_samples, current_frame_time)

    if #M.frame_time_samples > M.MAX_SAMPLES then
        table.remove(M.frame_time_samples, 1)
    end

    local total_time = 0
    for _, time in ipairs(M.frame_time_samples) do
        total_time = total_time + time
    end
    local avg_frame_time = total_time / #M.frame_time_samples

    return math.floor(1.0 / avg_frame_time + 0.5)
end

function M.get_map_name()
    if game.engine:in_game() then
        return game.global_vars.map_name or "unknown"
    end
    return "unknown"
end

function M.get_player_count()
    local count = 0
    local counted_players = {}

    entities.controllers:for_each(function(entry)
        local controller = entry.entity
        if controller then
            local team = controller.m_iTeamNum and controller.m_iTeamNum:get()
            local name = controller:get_name()

            if team and (team == 2 or team == 3) and name and not counted_players[name] then
                counted_players[name] = true
                count = count + 1
            end
        end
    end)

    return count
end

M.startup_time = game.global_vars.real_time
function M.get_elapsed_time()
    local elapsed = game.global_vars.real_time - M.startup_time
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)

    if hours > 0 then
        return string.format("%dh %02dm", hours, minutes)
    else
        return string.format("%02d:%02d", minutes, seconds)
    end
end

function M.get_server_tickrate()
    if game.engine:is_connected() then
        local netchan = game.engine:get_netchan()
        if netchan and not netchan:is_null() then
            return 64  
        end
    end
    return 0
end

function M.get_server_type()
    if not game.engine:is_connected() then return "Local" end

    local netchan = game.engine:get_netchan()
    if not netchan or netchan:is_null() then return "Local" end

    local address = netchan:get_address()
    if not address then return "Local" end

    if string.find(address, "valve") then
        return "Valve"
    end

    return "Community"
end

function M.draw_accent_line(x1, y1, x2, thickness)
    draw.surface:add_rect_filled(
        draw.rect(x1, y1, x2, y1 + thickness),
        M.accent_picker:get_value():get()
    )
end

function M.draw_outlined_text(d, x, y, text, color, alpha)
    for ox = -1, 1 do
        for oy = -1, 1 do
            if ox ~= 0 or oy ~= 0 then
                d:add_text(draw.vec2(x + ox, y + oy), text, draw.color(0, 0, 0, alpha))
            end
        end
    end
    d:add_text(draw.vec2(x, y), text, color)
end

function M.get_watermark_elements()
    local elements_value = M.watermark_elements_combo:get_value():get():get_raw()
    if type(elements_value) ~= "number" then return {} end

    local elements = {}

    if bit.band(elements_value, 1) ~= 0 then
        table.insert(elements, M.get_username())
    end

    if bit.band(elements_value, 2) ~= 0 then
        table.insert(elements, M.calculate_fps() .. " fps")
    end

    if bit.band(elements_value, 4) ~= 0 then
        local netchan = game.engine:get_netchan()
        if netchan and not netchan:is_null() then
            local ping = math.floor(netchan:get_latency() * 1000)
            table.insert(elements, ping > 0 and ping .. " ms" or "idle")
        else
            table.insert(elements, "idle")
        end
    end

    if bit.band(elements_value, 8) ~= 0 then
        table.insert(elements, M.get_server_type())
    end

    if bit.band(elements_value, 16) ~= 0 then
        if game.engine:is_connected() then
            local netchan = game.engine:get_netchan()
            if netchan and not netchan:is_null() then
                table.insert(elements, netchan:get_address() or "local")
            else
                table.insert(elements, "local")
            end
        else
            table.insert(elements, "local")
        end
    end

    if bit.band(elements_value, 32) ~= 0 then
        table.insert(elements, M.get_map_name())
    end

    if bit.band(elements_value, 64) ~= 0 then
        table.insert(elements, M.get_elapsed_time())
    end

    if bit.band(elements_value, 128) ~= 0 then
        table.insert(elements, string.format("%d tick", M.get_server_tickrate()))
    end

    if bit.band(elements_value, 256) ~= 0 then
        table.insert(elements, M.get_player_count() .. " players")
    end

    return elements
end

function M.render_gamesense_watermark()
    local combo_value = M.watermarks_combo:get_value():get():get_raw()

    if type(combo_value) ~= "number" or bit.band(combo_value, 2) == 0 then 
        return 
    end

    local accent_color = M.accent_picker:get_value():get()

    local elements = {}

    table.insert(elements, {name = M.game_text, color = M.colors.white})
    table.insert(elements, {name = M.sense_text, color = accent_color})

    local watermark_elements = M.get_watermark_elements()
    if #watermark_elements > 0 then
        for i, element in ipairs(watermark_elements) do
            if i == 1 then
                table.insert(elements, {name = "    " .. element, color = M.colors.white})
            else

                local parts = {}
                for part in element:gmatch("[^%s]+") do
                    table.insert(parts, part)
                end

                if #parts == 2 then
                    table.insert(elements, {name = "    " .. parts[1], color = accent_color})
                    table.insert(elements, {name = " " .. parts[2], color = M.colors.white})
                else
                    table.insert(elements, {name = "    " .. element, color = M.colors.white})
                end
            end
        end
    end

    if M.dragging.gs_watermark then
        local mouse = gui.input:cursor()
        M.elements_pos.gs_watermark.x = mouse.x - M.drag_offset.gs_watermark.x
        M.elements_pos.gs_watermark.y = mouse.y - M.drag_offset.gs_watermark.y
        M.initial_positions.gamesense = false
    end

    local total_width = 0
    for _, element in ipairs(elements) do
        draw.surface.font = draw.fonts["gui_debug"]
        total_width = total_width + draw.surface.font:get_text_size(element.name).x
    end
    total_width = total_width + 24  

    if M.initial_positions.gamesense then
        M.elements_pos.gs_watermark.x = M.screen[1] - total_width - 15
        M.elements_pos.gs_watermark.y = 15
    end

    M.elements_pos.gs_watermark.x = math.max(0, math.min(M.elements_pos.gs_watermark.x, M.screen[1] - total_width - 15))
    M.elements_pos.gs_watermark.y = math.max(0, math.min(M.elements_pos.gs_watermark.y, M.screen[2] - 20))

    local height = 20
    local pos_x = M.elements_pos.gs_watermark.x
    local pos_y = M.elements_pos.gs_watermark.y

    for i = 0, height do
        local alpha = 0
        if i < height * 0.2 or i > height * 0.8 then
            alpha = 40
        else
            local progress = (i - height * 0.2) / (height * 0.6)
            alpha = 40 * (1 - math.sin(progress * math.pi))
        end
        draw.surface:add_rect_filled(
            draw.rect(pos_x, pos_y + i, pos_x + total_width, pos_y + i + 1),
            draw.color(0, 0, 0, alpha)
        )
    end

    draw.surface:add_rect_filled(
        draw.rect(pos_x, pos_y, pos_x + total_width, pos_y + 1),
        draw.color(0, 0, 0, 100)
    )
    draw.surface:add_rect_filled(
        draw.rect(pos_x, pos_y + height - 1, pos_x + total_width, pos_y + height),
        draw.color(0, 0, 0, 100)
    )

    local x_offset = pos_x + 12
    for _, element in ipairs(elements) do
        draw.surface:add_text(draw.vec2(x_offset, pos_y + 4), element.name, element.color)
        x_offset = x_offset + draw.surface.font:get_text_size(element.name).x
    end
end

function M.render_apex_watermark()
    local combo_value = M.watermarks_combo:get_value():get():get_raw()

    if type(combo_value) ~= "number" or bit.band(combo_value, 1) == 0 then 
        return 
    end

    local accent_color = M.accent_picker:get_value():get()

    local show_icons = false

    if M.dragging.apex_watermark then
        local mouse = gui.input:cursor()
        M.elements_pos.apex_watermark.x = mouse.x - M.drag_offset.apex_watermark.x
        M.elements_pos.apex_watermark.y = mouse.y - M.drag_offset.apex_watermark.y
        M.initial_positions.apex = false
    end

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local padding_x = 8
    local padding_y = 6
    local element_spacing = 10
    local corner_radius = 6
    local box_height = 24

    local elements = {}

    table.insert(elements, {
        text = M.watermark_custom_text, 
        has_value = false
    })

    local watermark_elements = M.get_watermark_elements()
    for _, element_value in ipairs(watermark_elements) do

        if element_value == M.get_username() then

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        elseif element_value:find("fps") then

            local fps = element_value:match("(%d+)%s+fps")
            if fps then
                table.insert(elements, {
                    text = element_value,
                    value = fps,
                    label = " fps",
                    has_value = true
                })
            else
                table.insert(elements, {
                    text = element_value,
                    has_value = false
                })
            end
        elseif element_value:find("ms") then

            local ping = element_value:match("(%d+)%s+ms")
            if ping then
                table.insert(elements, {
                    text = element_value,
                    value = ping,
                    label = " ms",
                    has_value = true
                })
            elseif element_value == "idle" then
                table.insert(elements, {
                    text = element_value,
                    has_value = false
                })
            end
        elseif element_value == "Valve" or element_value == "Community" or element_value == "Local" then

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        elseif element_value:find("%.") or element_value == "local" then

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        elseif element_value == M.get_map_name() then

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        elseif element_value:find("[0-9]+:[0-9]+") or element_value:find("[0-9]+h") then

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        elseif element_value:find("tick") then

            local tick = element_value:match("(%d+)%s+tick")
            if tick then
                table.insert(elements, {
                    text = element_value,
                    value = tick,
                    label = " tick",
                    has_value = true
                })
            else
                table.insert(elements, {
                    text = element_value,
                    has_value = false
                })
            end
        elseif element_value:find("players") then

            local players = element_value:match("(%d+)%s+players")
            if players then
                table.insert(elements, {
                    text = element_value,
                    value = players,
                    label = " players",
                    has_value = true
                })
            else
                table.insert(elements, {
                    text = element_value,
                    has_value = false
                })
            end
        else

            table.insert(elements, {
                text = element_value,
                has_value = false
            })
        end
    end

    local total_width = 0
    local element_positions = {}

    for i, element in ipairs(elements) do
        element_positions[i] = {x = total_width}

        if i > 1 then
            total_width = total_width + element_spacing
        end

        if element.has_value then
            total_width = total_width + d.font:get_text_size(element.value).x
            total_width = total_width + d.font:get_text_size(element.label).x
        else
            total_width = total_width + d.font:get_text_size(element.text).x
        end
    end

    total_width = total_width + (padding_x * 2)

    if M.initial_positions.apex then
        M.elements_pos.apex_watermark.x = M.screen[1] - total_width - 15
        M.elements_pos.apex_watermark.y = 15
    end

    M.elements_pos.apex_watermark.x = math.max(0, math.min(M.elements_pos.apex_watermark.x, M.screen[1] - total_width))
    M.elements_pos.apex_watermark.y = math.max(0, math.min(M.elements_pos.apex_watermark.y, M.screen[2] - box_height))

    local pos = M.elements_pos.apex_watermark

    local glow_size = 6
    for i = glow_size, 1, -1 do
        local alpha = 10 * (1 - (i / glow_size))
        d:add_rect_filled_rounded(
            draw.rect(
                pos.x - i, 
                pos.y - i, 
                pos.x + total_width + i, 
                pos.y + box_height + i
            ),
            draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                math.floor(alpha)
            ),
            corner_radius + i,
            draw.rounding.all
        )
    end

    d:add_rect_filled_rounded(
        draw.rect(
            pos.x, 
            pos.y, 
            pos.x + total_width, 
            pos.y + box_height
        ),
        draw.color(0, 0, 0, 175),
        corner_radius,
        draw.rounding.all
    )

    local center_y = pos.y + (box_height / 2)

    for i, element in ipairs(elements) do
        local current_x = pos.x + padding_x + element_positions[i].x

        if i > 1 then
            current_x = current_x + element_spacing
        end

        local text_height = d.font:get_text_size("A").y

        if element.has_value then

            d:add_text(
                draw.vec2(current_x, center_y - (text_height/2)),
                element.value,
                accent_color
            )

            local value_width = d.font:get_text_size(element.value).x
            current_x = current_x + value_width

            d:add_text(
                draw.vec2(current_x, center_y - (text_height/2)),
                element.label,
                M.colors.white
            )
         else 

            d:add_text(
                draw.vec2(current_x, center_y - (text_height/2)),
                element.text,
                M.colors.white
            )
        end
    end
end

function M.render_bottom_watermark()
    local combo_value = M.watermarks_combo:get_value():get():get_raw()

    if type(combo_value) ~= "number" or bit.band(combo_value, 4) == 0 then 
        return 
    end

    local accent_color = M.accent_picker:get_value():get()
    local white_color = M.colors.white

    draw.surface.font = draw.fonts["gui_main"]

    local letters = {"M", "I", "L", "L", "I", "O", "N", "W", "A", "R", "E"}

    local total_width = 0
    for _, letter in ipairs(letters) do
        total_width = total_width + draw.surface.font:get_text_size(letter).x
    end
    total_width = total_width + (M.bottom_watermark.spacing * (#letters - 1))

    local bracket_left_width = draw.surface.font:get_text_size("[").x
    local bracket_right_width = draw.surface.font:get_text_size("]").x
    local full_width = total_width + bracket_left_width + bracket_right_width + (M.bottom_watermark.bracket_padding * 2)

    local start_x = (M.screen[1] - full_width) / 2
    local y_pos = M.screen[2] - M.bottom_watermark.y_offset

    draw.surface:add_text(
        draw.vec2(start_x, y_pos),
        "[",
        white_color
    )

    local current_x = start_x + bracket_left_width + M.bottom_watermark.bracket_padding
    for _, letter in ipairs(letters) do

        for ox = -1, 1 do
            for oy = -1, 1 do
                if ox ~= 0 or oy ~= 0 then
                    draw.surface:add_text(
                        draw.vec2(current_x + ox, y_pos + oy),
                        letter,
                        draw.color(0, 0, 0, 150)
                    )
                end
            end
        end

        draw.surface:add_text(
            draw.vec2(current_x, y_pos),
            letter,
            accent_color
        )

        current_x = current_x + draw.surface.font:get_text_size(letter).x + M.bottom_watermark.spacing
    end

    draw.surface:add_text(
        draw.vec2(current_x, y_pos),
        "]",
        white_color
    )

    local status_letters = {"R", "E", "W", "O", "R", "K"}

    local status_width = 0
    for _, letter in ipairs(status_letters) do
        status_width = status_width + draw.surface.font:get_text_size(letter).x
    end
    status_width = status_width + (M.bottom_watermark.spacing * (#status_letters - 1))

    local status_start_x = (M.screen[1] - status_width) / 2
    local status_y_pos = y_pos + 20

    local current_status_x = status_start_x
    for _, letter in ipairs(status_letters) do

        for ox = -1, 1 do
            for oy = -1, 1 do
                if ox ~= 0 or oy ~= 0 then
                    draw.surface:add_text(
                        draw.vec2(current_status_x + ox, status_y_pos + oy),
                        letter,
                        draw.color(0, 0, 0, 150)
                    )
                end
            end
        end

        draw.surface:add_text(
            draw.vec2(current_status_x, status_y_pos),
            letter,
            white_color
        )

        current_status_x = current_status_x + draw.surface.font:get_text_size(letter).x + M.bottom_watermark.spacing
    end
end

function M.render_legit_indicators()
    local combo_value = M.indicators_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 1) == 0 then
        return
    end

    local selected_features = M.legit_indicator_controls_combo:get_value():get():get_raw()
    if type(selected_features) ~= "number" then return end

    if M.dragging.legit_indicators then
        local mouse = gui.input:cursor()
        M.elements_pos.legit_indicators.x = mouse.x - M.drag_offset.legit_indicators.x
        M.elements_pos.legit_indicators.y = mouse.y - M.drag_offset.legit_indicators.y
    end

    local adjusted_x = M.elements_pos.legit_indicators.x
    local adjusted_y = M.elements_pos.legit_indicators.y

    local d = draw.surface
    d.font = draw.fonts["gui_bold"]

    local millionware_controls = {
        {name = "jb", display = "JB", context = "misc>movement>jumpbug", bit = 1},
        {name = "ej", display = "EJ", context = "misc>movement>edge jump", bit = 2},
        {name = "tb", display = "TB", context = "legit>weapon>general>trigger>triggerbot", bit = 4}
    }

    local padding_x = 8
    local padding_y = 6
    local item_height = 22
    local item_spacing = 8
    local corner_radius = 6
    local accent_color = M.accent_picker:get_value():get()

    local active_indicators = {}
    for _, control in ipairs(millionware_controls) do

        if bit.band(selected_features, control.bit) ~= 0 then
            local context = gui.ctx:find(control.context)
            if context and context:get_value():get() then
                table.insert(active_indicators, control)
            end
        end
    end

    if #active_indicators == 0 then return end

    local total_height = (#active_indicators * (item_height + item_spacing)) - item_spacing
    local drag_box_width = 60

    d:add_rect_filled(
        draw.rect(
            adjusted_x, 
            adjusted_y, 
            adjusted_x + drag_box_width, 
            adjusted_y + total_height
        ),
        draw.color(0, 0, 0, 0)  
    )

    local current_y = adjusted_y
    for _, indicator in ipairs(active_indicators) do

        local text_width = d.font:get_text_size(indicator.display).x
        local box_width = text_width + (padding_x * 2)

        local glow_size = 6
        for i = glow_size, 1, -1 do
            local alpha = 10 * (1 - (i / glow_size))
            d:add_rect_filled_rounded(
                draw.rect(
                    adjusted_x - i, 
                    current_y - i, 
                    adjusted_x + box_width + i, 
                    current_y + item_height + i
                ),
                draw.color(
                    accent_color:get_r(),
                    accent_color:get_g(),
                    accent_color:get_b(),
                    math.floor(alpha)
                ),
                corner_radius + i,
                draw.rounding.all
            )
        end

        d:add_rect_filled_rounded(
            draw.rect(
                adjusted_x, 
                current_y, 
                adjusted_x + box_width, 
                current_y + item_height
            ),
            draw.color(0, 0, 0, 175),
            corner_radius,
            draw.rounding.all
        )

        d:add_text(
            draw.vec2(adjusted_x + padding_x, current_y + padding_y),
            indicator.display,
            draw.color(255, 255, 255, 255)
        )

        current_y = current_y + item_height + item_spacing
    end
end

function M.is_utility_weapon(weapon_id)
    return M.UTILITY_WEAPONS[weapon_id] or false
end

function M.get_mindamage_path(weapon_id)
    if not weapon_id then return M.WEAPON_TO_PATH.GENERAL end

    local specific_path = M.WEAPON_TO_PATH[weapon_id]
    if specific_path then

        local context = gui.ctx:find(specific_path)
        if context then
            return specific_path
        end
    end

    for _, group in pairs(M.WEAPON_TO_PATH.GROUPS) do
        if group.weapons[weapon_id] then
            local context = gui.ctx:find(group.path)
            if context then
                return group.path
            end
        end
    end

    local general_context = gui.ctx:find(M.WEAPON_TO_PATH.GENERAL)
    if general_context then
        return M.WEAPON_TO_PATH.GENERAL
    end

    return nil
end

function M.get_hitchance_path(path)
    return path:gsub("mindamage", "hitchance")
end

function M.get_pointscale_path(path)
    return path:gsub("mindamage", "pointscale")
end

M.fade_states = {}
for _, data in ipairs({
    {name = "MinDamage", context = ""},
    {name = "Hitchance", context = ""},
    {name = "Pointscale", context = ""},
    {name = "Delay Shot", context = "rage>aimbot>general>delay shot"},
    {name = "Baim", context = "rage>aimbot>general>force bodyaim"},
    {name = "Force Shot", context = "rage>aimbot>general>force shoot"},
    {name = "Force Head", context = "rage>aimbot>general>headshot only"},
    {name = "No Spread", context = "rage>aimbot>general>nospread"},
    {name = "Hide Shots", context = "rage>anti-aim>angles>hide shot"},
    {name = "Double Tap", context = "rage>aimbot>general>doubletap"}
}) do
    M.fade_states[data.name] = {active = false, time = 0, y_offset = 20, alpha = 0}
end

function M.render_crosshair_indicators()
    local combo_value = M.indicators_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 2) == 0 then
        return
    end

    local selected_features = M.crosshair_indicator_controls_combo:get_value():get():get_raw()
    if type(selected_features) ~= "number" then return end

    local sw, sh = M.screen[1], M.screen[2]
    local pos_x, pos_y = sw / 2, sh / 2
    local d = draw.surface
    d.font = draw.fonts["gui_debug"]

    local local_pawn = entities.get_local_pawn()
    if not local_pawn then return end

    local is_scoped = local_pawn.m_bIsScoped and local_pawn.m_bIsScoped:get()
    local active_weapon = local_pawn:get_active_weapon()
    local is_sniper = active_weapon and (
        active_weapon:get_id() == weapon_id.awp or 
        active_weapon:get_id() == weapon_id.ssg08 or 
        active_weapon:get_id() == weapon_id.scar20 or 
        active_weapon:get_id() == weapon_id.g3sg1
    )

    local target_x_offset = (is_scoped and is_sniper) and 75 or 0
    local frame_time = game.global_vars.frame_time
    M.current_x_offset = M.current_x_offset or 0
    M.current_x_offset = M.current_x_offset + ((target_x_offset - M.current_x_offset) * frame_time * 8)

    local accent_color = M.accent_picker:get_value():get()

    local y_pos = pos_y + 25

    if not M.remove_dormant_checkbox:get_value():get() then
        local million_text = M.indicators.crosshair.custom_million_text
        local stable_text = M.indicators.crosshair.custom_stable_text

        local million_width = d.font:get_text_size(million_text).x
        local stable_width = d.font:get_text_size(stable_text).x
        local space_width = d.font:get_text_size(" ").x
        local total_width = million_width + space_width + stable_width
        local start_x = pos_x - (total_width / 2) + M.current_x_offset

        local style_value = M.indicator_style_combo:get_value():get():get_raw()
        if type(style_value) ~= "number" then style_value = 1 end

        if bit.band(style_value, 1) ~= 0 then

            M.draw_outlined_text(d, start_x, y_pos, million_text, draw.color(255, 255, 255, 255), 255)

            M.indicators.crosshair.stable_alpha = M.indicators.crosshair.stable_alpha + (frame_time * 255 * 1.5 * M.indicators.crosshair.stable_fade_dir)
            M.indicators.crosshair.stable_alpha = math.max(100, math.min(255, M.indicators.crosshair.stable_alpha))
            if M.indicators.crosshair.stable_alpha == 255 or M.indicators.crosshair.stable_alpha == 100 then
                M.indicators.crosshair.stable_fade_dir = -M.indicators.crosshair.stable_fade_dir
            end

            local stable_x = start_x + million_width + space_width

            for i = 3, 1, -1 do
                local glow_alpha = (15 - (i * 3)) * (M.indicators.crosshair.stable_alpha / 255)
                for x = -i, i do
                    for y = -i, i do
                        d:add_text(draw.vec2(stable_x + x, y_pos + y), stable_text, draw.color(
                            accent_color:get_r(),
                            accent_color:get_g(),
                            accent_color:get_b(),
                            glow_alpha
                        ))
                    end
                end
            end

            d:add_text(
                draw.vec2(stable_x, y_pos),
                stable_text,
                draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), M.indicators.crosshair.stable_alpha)
            )
        elseif bit.band(style_value, 2) ~= 0 then

            M.indicators.crosshair.wave_position = (M.indicators.crosshair.wave_position + frame_time * M.indicators.crosshair.wave_speed) % (total_width * 1.5)

            local cursor_x = start_x
            local combined_text = million_text .. " " .. stable_text
            local wave_width = 45

            for i = 1, combined_text:len() do
                local char = combined_text:sub(i, i)
                local char_width = d.font:get_text_size(char).x

                local wave_center = start_x + M.indicators.crosshair.wave_position - (total_width * 0.25)
                local dist_from_wave = math.abs(cursor_x - wave_center)

                local char_color
                if dist_from_wave < wave_width then
                    local factor = 1 - (dist_from_wave / wave_width)
                    factor = factor * factor

                    char_color = draw.color(
                        math.floor(255 * (1 - factor) + accent_color:get_r() * factor),
                        math.floor(255 * (1 - factor) + accent_color:get_g() * factor),
                        math.floor(255 * (1 - factor) + accent_color:get_b() * factor),
                        255
                    )
                else
                    char_color = draw.color(255, 255, 255, 255)
                end

                for ox = -1, 1 do
                    for oy = -1, 1 do
                        if ox ~= 0 or oy ~= 0 then
                            d:add_text(draw.vec2(cursor_x + ox, y_pos + oy), char, draw.color(0, 0, 0, 255))
                        end
                    end
                end

                d:add_text(draw.vec2(cursor_x, y_pos), char, char_color)
                cursor_x = cursor_x + char_width
            end
        elseif bit.band(style_value, 4) ~= 0 then

            M.indicators.crosshair.wave_position = (M.indicators.crosshair.wave_position + frame_time * M.indicators.crosshair.wave_speed) % (total_width * 1.5)

            local cursor_x = start_x
            local combined_text = million_text .. " " .. stable_text
            local wave_width = 45
            local time = game.global_vars.real_time * 0.5

            for i = 1, combined_text:len() do
                local char = combined_text:sub(i, i)
                local char_width = d.font:get_text_size(char).x

                local wave_center = start_x + M.indicators.crosshair.wave_position - (total_width * 0.25)
                local dist_from_wave = math.abs(cursor_x - wave_center)

                local char_color
                if dist_from_wave < wave_width then
                    local factor = 1 - (dist_from_wave / wave_width)
                    factor = factor * factor

                    local hue = (((cursor_x / 100) + time) % 1.0)
                    local r, g, b

                    local h = hue * 6
                    local i = math.floor(h)
                    local f = h - i
                    local p = 0
                    local q = 1 - f
                    local t = f

                    if i == 0 then r, g, b = 1, t, 0
                    elseif i == 1 then r, g, b = q, 1, 0
                    elseif i == 2 then r, g, b = 0, 1, t
                    elseif i == 3 then r, g, b = 0, q, 1
                    elseif i == 4 then r, g, b = t, 0, 1
                    else r, g, b = 1, 0, q end

                    char_color = draw.color(
                        math.floor(255 * (1 - factor) + r * 255 * factor),
                        math.floor(255 * (1 - factor) + g * 255 * factor),
                        math.floor(255 * (1 - factor) + b * 255 * factor),
                        255
                    )
                else
                    char_color = draw.color(255, 255, 255, 255)
                end

                for ox = -1, 1 do
                    for oy = -1, 1 do
                        if ox ~= 0 or oy ~= 0 then
                            d:add_text(draw.vec2(cursor_x + ox, y_pos + oy), char, draw.color(0, 0, 0, 255))
                        end
                    end
                end

                d:add_text(draw.vec2(cursor_x, y_pos), char, char_color)
                cursor_x = cursor_x + char_width
            end
        elseif bit.band(style_value, 8) ~= 0 then

            local time = game.global_vars.real_time * 4
            local cursor_x = start_x
            local combined_text = million_text .. " " .. stable_text

            for i = 1, combined_text:len() do
                local char = combined_text:sub(i, i)
                local char_width = d.font:get_text_size(char).x

                local bounce_phase = ((cursor_x / 15) + time) % (2 * math.pi)
                local bounce_offset = math.sin(bounce_phase) * 3

                local color_phase = ((cursor_x / 25) + time) % (2 * math.pi)
                local color_factor = (math.sin(color_phase) + 1) / 2

                local char_color = draw.color(
                    math.floor(255 * (1 - color_factor) + accent_color:get_r() * color_factor),
                    math.floor(255 * (1 - color_factor) + accent_color:get_g() * color_factor),
                    math.floor(255 * (1 - color_factor) + accent_color:get_b() * color_factor),
                    255
                )

                for ox = -1, 1 do
                    for oy = -1, 1 do
                        if ox ~= 0 or oy ~= 0 then
                            d:add_text(draw.vec2(cursor_x + ox, y_pos + bounce_offset + oy), char, draw.color(0, 0, 0, 255))
                        end
                    end
                end

                d:add_text(draw.vec2(cursor_x, y_pos + bounce_offset), char, char_color)
                cursor_x = cursor_x + char_width
            end
        elseif bit.band(style_value, 16) ~= 0 then

            if not M.indicators.crosshair.glitch_last_update then
                M.indicators.crosshair.glitch_last_update = game.global_vars.real_time
                M.indicators.crosshair.glitch_chars = {}
                M.indicators.crosshair.glitch_active = false
            end

            local time = game.global_vars.real_time
            local cursor_x = start_x
            local combined_text = million_text .. " " .. stable_text

            if time - M.indicators.crosshair.glitch_last_update > (M.indicators.crosshair.glitch_active and 0.1 or 0.3) then
                M.indicators.crosshair.glitch_last_update = time
                M.indicators.crosshair.glitch_active = not M.indicators.crosshair.glitch_active

                M.indicators.crosshair.glitch_chars = {}
                for i = 1, combined_text:len() do
                    M.indicators.crosshair.glitch_chars[i] = {
                        x_offset = (math.random() * 8 - 4),
                        y_offset = (math.random() * 6 - 3),
                        use_accent = math.random() < 0.5,
                        hide = math.random() < 0.15, 
                        delay = math.random() * 0.05 
                    }
                end
            end

            for i = 1, combined_text:len() do
                local char = combined_text:sub(i, i)
                local char_width = d.font:get_text_size(char).x

                local glitch_data = M.indicators.crosshair.glitch_chars[i] or {
                    x_offset = 0, 
                    y_offset = 0, 
                    use_accent = false,
                    hide = false,
                    delay = 0
                }

                local x_offset = M.indicators.crosshair.glitch_active and glitch_data.x_offset or 0
                local y_offset = M.indicators.crosshair.glitch_active and glitch_data.y_offset or 0

                if not (M.indicators.crosshair.glitch_active and glitch_data.hide) then

                    local char_color
                    if M.indicators.crosshair.glitch_active and glitch_data.use_accent then
                        char_color = accent_color
                    else
                        char_color = draw.color(255, 255, 255, 255)
                    end

                    for ox = -1, 1 do
                        for oy = -1, 1 do
                            if ox ~= 0 or oy ~= 0 then
                                d:add_text(draw.vec2(cursor_x + x_offset + ox, y_pos + y_offset + oy), char, draw.color(0, 0, 0, 255))
                            end
                        end
                    end

                    d:add_text(draw.vec2(cursor_x + x_offset, y_pos + y_offset), char, char_color)
                end

                cursor_x = cursor_x + char_width
            end
        elseif bit.band(style_value, 32) ~= 0 then

            if not M.indicators.crosshair.typewriter_start then
                M.indicators.crosshair.typewriter_start = game.global_vars.real_time
                M.indicators.crosshair.typewriter_pos = 0
                M.indicators.crosshair.typewriter_phase = "typing"
            end

            local time = game.global_vars.real_time
            local cursor_x = start_x
            local combined_text = million_text .. " " .. stable_text
            local text_length = combined_text:len()

            local chars_per_second = 15
            local pause_duration = 1.5  
            local elapsed = time - M.indicators.crosshair.typewriter_start

            if M.indicators.crosshair.typewriter_phase == "typing" then

                M.indicators.crosshair.typewriter_pos = math.floor(elapsed * chars_per_second)

                if M.indicators.crosshair.typewriter_pos >= text_length then
                    M.indicators.crosshair.typewriter_pos = text_length
                    M.indicators.crosshair.typewriter_phase = "pause"
                    M.indicators.crosshair.typewriter_start = time
                end
            elseif M.indicators.crosshair.typewriter_phase == "pause" then

                if elapsed >= pause_duration then
                    M.indicators.crosshair.typewriter_phase = "deleting"
                    M.indicators.crosshair.typewriter_start = time
                end
            elseif M.indicators.crosshair.typewriter_phase == "deleting" then

                M.indicators.crosshair.typewriter_pos = text_length - math.floor(elapsed * chars_per_second)

                if M.indicators.crosshair.typewriter_pos <= 0 then
                    M.indicators.crosshair.typewriter_pos = 0
                    M.indicators.crosshair.typewriter_phase = "typing"
                    M.indicators.crosshair.typewriter_start = time
                end
            end

            M.indicators.crosshair.typewriter_pos = math.max(0, math.min(text_length, M.indicators.crosshair.typewriter_pos))

            for i = 1, combined_text:len() do
                local char = combined_text:sub(i, i)
                local char_width = d.font:get_text_size(char).x

                if i <= M.indicators.crosshair.typewriter_pos then

                    local char_color
                    if i <= million_text:len() then

                        char_color = draw.color(255, 255, 255, 255)
                    else

                        char_color = accent_color
                    end

                    for ox = -1, 1 do
                        for oy = -1, 1 do
                            if ox ~= 0 or oy ~= 0 then
                                d:add_text(draw.vec2(cursor_x + ox, y_pos + oy), char, draw.color(0, 0, 0, 255))
                            end
                        end
                    end

                    d:add_text(draw.vec2(cursor_x, y_pos), char, char_color)
                end

                cursor_x = cursor_x + char_width
            end

            local cursor_display_x = start_x

            for i = 1, M.indicators.crosshair.typewriter_pos do
                if i <= combined_text:len() then
                    local char = combined_text:sub(i, i)
                    cursor_display_x = cursor_display_x + d.font:get_text_size(char).x
                end
            end

            if M.indicators.crosshair.typewriter_phase ~= "pause" and (math.floor(time * 2) % 2 == 0) then
                d:add_rect_filled(
                    draw.rect(cursor_display_x + 1, y_pos, cursor_display_x + 3, y_pos + d.font:get_text_size("A").y),
                    accent_color
                )
            end
        end
    end

    local current_pos = local_pawn:get_abs_origin()
    local velocity = 0
    if M.indicators.crosshair.last_pos and current_pos then
        local dx, dy = current_pos.x - M.indicators.crosshair.last_pos.x, current_pos.y - M.indicators.crosshair.last_pos.y
        velocity = math.sqrt(dx * dx + dy * dy) / frame_time
    end
    M.indicators.crosshair.last_pos = current_pos

    if not M.remove_status_checkbox:get_value():get() then
        local state_text = ""
        if not game.engine:in_game() then
            state_text = "« Idle »"
        elseif local_pawn then
            if not local_pawn:is_alive() then
                state_text = "« Dead »"
            else
                local anti_aim_context = gui.ctx:find("rage>anti-aim>angles>anti-aim")
                local slowwalk_context = gui.ctx:find("misc>movement>slowwalk")
                local fakeduck_context = gui.ctx:find("misc>aimbot>general>duck peek assist")
                local slowwalk_speed_context = gui.ctx:find("misc>movement>slowwalk speed")
                local peekassist_context = gui.ctx:find("misc>movement>peek assist")
                local peekassistretreat_context = gui.ctx:find("misc>movement>retreat on release")
                local is_e_pressed = gui.input:is_key_down(0x45)
                local gamerelated_context = M.game_related_combo:get_value():get():get_raw() 

                if slowwalk_context and slowwalk_context:get_value():get() then
                    local slowwalk_speed = slowwalk_speed_context and slowwalk_speed_context:get_value():get() or 0
                    state_text = string.format("« Slow Walk(%d) »", math.floor(slowwalk_speed))
                elseif anti_aim_context and anti_aim_context:get_value():get() and is_e_pressed then
                    state_text = "« Legit AA »"
                elseif fakeduck_context and fakeduck_context:get_value():get() then
                    state_text = "« Fake Ducking »"
                elseif peekassist_context and peekassist_context:get_value():get() and not peekassistretreat_context:get_value():get() then
                    state_text = "« Peek Assist »"
                elseif peekassist_context and peekassist_context:get_value():get() and peekassistretreat_context:get_value():get() then
                    state_text = "« Peek Assist(retreat) »"
                elseif type(gamerelated_context) == "number" and bit.band(gamerelated_context, 1) ~= 0 then
                    state_text = "« Anti-Afk »"

                else
                    local is_crouching = gui.input:is_key_down(0x11)
                    local is_shift_walking = gui.input:is_key_down(0x10)
                    local flags = local_pawn.m_fFlags and local_pawn.m_fFlags:get() or 0
                    local is_in_air = bit.band(flags, 1) == 0

                    if is_in_air then
                        state_text = is_crouching and "« Air+Crouching »" or "« In Air »"
                    else
                        if is_shift_walking then
                            state_text = "« Sneaking »"
                        elseif is_crouching then
                            state_text = "« Crouching »"
                        elseif velocity > 5 then
                            state_text = "« Moving »"
                        else
                            state_text = "« Standing »"
                        end
                    end
                end
            end
        end

        local new_text = state_text
        M.indicators.crosshair.movement_alpha = new_text ~= M.indicators.crosshair.current_text and 
            math.max(0, M.indicators.crosshair.movement_alpha - (frame_time * 255 * 255)) or 
            math.min(255, M.indicators.crosshair.movement_alpha + (frame_time * 255 * 255))

        if M.indicators.crosshair.movement_alpha == 0 then 
            M.indicators.crosshair.current_text = new_text 
        end

        local text_width = d.font:get_text_size(M.indicators.crosshair.current_text).x
        M.draw_outlined_text(
            d, 
            pos_x - (text_width / 2) + M.current_x_offset,
            y_pos + 15,
            M.indicators.crosshair.current_text,
            draw.color(255, 255, 255, M.indicators.crosshair.movement_alpha),
            M.indicators.crosshair.movement_alpha
        )
    end

    local active_features = {}
    local animation_speed = 0.2

    local list_y = y_pos + 15  

    if not M.remove_dormant_checkbox:get_value():get() then
        list_y = list_y + 0  
    end

    if not M.remove_status_checkbox:get_value():get() then
        list_y = list_y + 15  
    end

    if bit.band(selected_features, 1) ~= 0 and active_weapon then
        local weapon_id = active_weapon:get_id()

        if not M.is_utility_weapon(weapon_id) then
            local damage_path = M.get_mindamage_path(weapon_id)

            if damage_path then
                local damage_context = gui.ctx:find(damage_path)
                local override_context = gui.ctx:find("rage>aimbot>general>min damage>override")
                local override_value_context = gui.ctx:find("rage>aimbot>general>min damage>override value")

                if damage_context then
                    local damage_value = damage_context:get_value():get()
                    local is_override = override_context and override_context:get_value():get()
                    local override_value = override_value_context and override_value_context:get_value():get()

                    local function format_damage(value)
                        if value == 0 then
                            return "Lethal"
                        elseif value > 100 and value <= 125 then
                            return string.format("HP+%d", value - 100)
                        else
                            return tostring(value)
                        end
                    end                

                    local damage_text = format_damage(damage_value)

                    if is_override and override_value_context then
                        damage_text = format_damage(override_value)
                    end

                    local text = string.format("MD %s%s",
                        damage_text,
                        is_override and " (override)" or ""
                    )

                    table.insert(active_features, {
                        name = text,
                        alpha = 1,
                        y_offset = 0
                    })
                end
            end
        end
    end

    if bit.band(selected_features, 2) ~= 0 and active_weapon then
        local weapon_id = active_weapon:get_id()

        if not M.is_utility_weapon(weapon_id) then
            local base_path = M.get_mindamage_path(weapon_id)
            if base_path then
                local hitchance_path = M.get_hitchance_path(base_path)
                local hitchance_context = gui.ctx:find(hitchance_path)

                if hitchance_context then
                    local hitchance_value = hitchance_context:get_value():get()

                    local hitchance_text
                    if hitchance_value == -1 then
                        hitchance_text = "HC Auto"
                    else
                        hitchance_text = string.format("HC %d%%", hitchance_value)
                    end

                    table.insert(active_features, {
                        name = hitchance_text,
                        alpha = 1,
                        y_offset = 0
                    })
                end
            end
        end
    end

    if bit.band(selected_features, 4) ~= 0 and active_weapon then
        local weapon_id = active_weapon:get_id()

        if not M.is_utility_weapon(weapon_id) then
            local base_path = M.get_mindamage_path(weapon_id)
            if base_path then
                local pointscale_path = M.get_pointscale_path(base_path)
                local pointscale_context = gui.ctx:find(pointscale_path)

                if pointscale_context then
                    local pointscale_value = pointscale_context:get_value():get()
                    local pointscale_text = string.format("PS %d%%", pointscale_value)

                    table.insert(active_features, {
                        name = pointscale_text,
                        alpha = 1,
                        y_offset = 0
                    })
                end
            end
        end
    end

    local feature_paths = {
        [8] = {name = "Delay Shot", context = "rage>aimbot>general>delay shot"},
        [16] = {name = "Baim", context = "rage>aimbot>general>force bodyaim"},
        [32] = {name = "Force Shot", context = "rage>aimbot>general>force shoot"},
        [64] = {name = "Force Head", context = "rage>aimbot>general>headshot only"},
        [128] = {name = "No Spread", context = "rage>aimbot>general>nospread"},
        [256] = {name = "Hide Shots", context = "rage>anti-aim>angles>hide shot"},
        [512] = {name = "Double Tap", context = "rage>aimbot>general>doubletap"}
    }

    for bit_value, feature_info in pairs(feature_paths) do
        if bit.band(selected_features, bit_value) ~= 0 then
            local context = gui.ctx:find(feature_info.context)
            local fade_state = M.fade_states[feature_info.name] or 
                {active = false, time = 0, y_offset = 20, alpha = 0}

            M.fade_states[feature_info.name] = fade_state

            if context and context:get_value():get() then
                if not fade_state.active then
                    fade_state.active = true
                    fade_state.time = game.global_vars.real_time
                    fade_state.y_offset = 20
                end

                fade_state.alpha = math.min(1, fade_state.alpha + frame_time / animation_speed)
                fade_state.y_offset = math.max(0, fade_state.y_offset - (frame_time * 200))

                if fade_state.alpha > 0 then
                    table.insert(active_features, {
                        name = feature_info.name,
                        alpha = fade_state.alpha,
                        y_offset = fade_state.y_offset
                    })
                end
            else
                if fade_state.active then
                    fade_state.active = false
                    fade_state.time = game.global_vars.real_time
                end

                fade_state.alpha = math.max(0, fade_state.alpha - frame_time / animation_speed)
                fade_state.y_offset = math.min(20, fade_state.y_offset + (frame_time * 200))

                if fade_state.alpha > 0 then
                    table.insert(active_features, {
                        name = feature_info.name,
                        alpha = fade_state.alpha,
                        y_offset = fade_state.y_offset
                    })
                end
            end
        end
    end

    table.sort(active_features, function(a, b)
        return a.y_offset < b.y_offset
    end)

    local spacing = 15
    for i, feature in ipairs(active_features) do
        local width = d.font:get_text_size(feature.name).x
        local feature_y = list_y + (i-1) * spacing + feature.y_offset
        local alpha = math.floor(feature.alpha * 255)

        for ox = -1, 1 do
            for oy = -1, 1 do
                if ox ~= 0 or oy ~= 0 then
                    d:add_text(
                        draw.vec2(pos_x - (width / 2) + M.current_x_offset + ox, feature_y + oy),
                        feature.name,
                        draw.color(0, 0, 0, alpha)
                    )
                end
            end
        end

        d:add_text(
            draw.vec2(pos_x - (width / 2) + M.current_x_offset, feature_y),
            feature.name,
            draw.color(255, 255, 255, alpha)
        )
    end
end

function M.handle_input(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local combo_value = M.watermarks_combo:get_value():get():get_raw()

        if type(combo_value) == "number" and bit.band(combo_value, 1) ~= 0 then
            local apex_box = {
                x = M.elements_pos.apex_watermark.x - 15,
                y = M.elements_pos.apex_watermark.y - 7,
                width = 250,
                height = 27
            }

            if mouse.x >= apex_box.x and 
               mouse.x <= apex_box.x + apex_box.width and
               mouse.y >= apex_box.y and 
               mouse.y <= apex_box.y + apex_box.height then
                M.dragging.apex_watermark = true
                M.drag_offset.apex_watermark.x = mouse.x - M.elements_pos.apex_watermark.x
                M.drag_offset.apex_watermark.y = mouse.y - M.elements_pos.apex_watermark.y
                M.initial_positions.apex = false
            end
        end

        if type(combo_value) == "number" and bit.band(combo_value, 2) ~= 0 then
            local gs_box = {
                x = M.elements_pos.gs_watermark.x,
                y = M.elements_pos.gs_watermark.y,
                width = 400,
                height = 20
            }

            if mouse.x >= gs_box.x and 
               mouse.x <= gs_box.x + gs_box.width and
               mouse.y >= gs_box.y and 
               mouse.y <= gs_box.y + gs_box.height then
                M.dragging.gs_watermark = true
                M.drag_offset.gs_watermark.x = mouse.x - M.elements_pos.gs_watermark.x
                M.drag_offset.gs_watermark.y = mouse.y - M.elements_pos.gs_watermark.y
                M.initial_positions.gamesense = false
            end
        end

        if type(combo_value) == "number" and bit.band(combo_value, 8) ~= 0 then
            local apex_box = {
                x = M.elements_pos.apex_watermark.x - 15,
                y = M.elements_pos.apex_watermark.y - 7,
                width = 250,
                height = 27
            }

            if mouse.x >= apex_box.x and 
               mouse.x <= apex_box.x + apex_box.width and
               mouse.y >= apex_box.y and 
               mouse.y <= apex_box.y + apex_box.height then
                M.dragging.apex_watermark = true
                M.drag_offset.apex_watermark.x = mouse.x - M.elements_pos.apex_watermark.x
                M.drag_offset.apex_watermark.y = mouse.y - M.elements_pos.apex_watermark.y
                M.initial_positions.apex = false
            end
        end

        local indicators_combo_value = M.indicators_combo:get_value():get():get_raw()
        if type(indicators_combo_value) == "number" and bit.band(indicators_combo_value, 1) ~= 0 then
            local legit_indicators_box = {
                x = M.elements_pos.legit_indicators.x - 10,
                y = M.elements_pos.legit_indicators.y - 10,
                width = 35,
                height = 50
            }

            if mouse.x >= legit_indicators_box.x and 
               mouse.x <= legit_indicators_box.x + legit_indicators_box.width and
               mouse.y >= legit_indicators_box.y and 
               mouse.y <= legit_indicators_box.y + legit_indicators_box.height then
                M.dragging.legit_indicators = true
                M.drag_offset.legit_indicators.x = mouse.x - M.elements_pos.legit_indicators.x
                M.drag_offset.legit_indicators.y = mouse.y - M.elements_pos.legit_indicators.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.watermark = false
        M.dragging.gs_watermark = false
        M.dragging.apex_watermark = false
        M.dragging.legit_indicators = false
    end
end

function M.render_startup_animation()
    if not M.startup_anim.script_started then return end

    if M.startup_anim.first_frame then
        M.startup_anim.start_time = game.global_vars.real_time
        M.startup_anim.first_frame = false
    end

    local current_time = game.global_vars.real_time
    local elapsed = current_time - M.startup_anim.start_time

    if elapsed > 3.0 then 
        M.startup_anim.active = false
        M.startup_anim.script_started = false  
        return 
    end

    local center_x = M.screen[1] / 2
    local center_y = (M.screen[2] / 2) - 15

    local alpha = 255
    if elapsed < 0.5 then 
        alpha = math.floor((elapsed / 0.5) * 255)
    elseif elapsed > 2.5 then 
        alpha = math.floor(((3.0 - elapsed) / 0.5) * 255)
    end

    draw.surface:add_rect_filled(
        draw.rect(0, 0, M.screen[1], M.screen[2]),
        draw.color(0, 0, 0, math.floor(alpha * 0.5))
    )

    draw.surface.font = draw.fonts["gui_title"]

    local letter_spacing = 5

    local total_width = 0
    for _, letter in ipairs(M.startup_anim.letters_million) do
        total_width = total_width + draw.surface.font:get_text_size(letter).x + letter_spacing
    end

    local current_x = center_x - (total_width / 2)
    local letter_delay = 0.1 
    local slide_duration = 0.3 

    for i, letter in ipairs(M.startup_anim.letters_million) do
        local letter_start_time = 0.2 + (i-1) * letter_delay
        local letter_progress = math.max(0, math.min(1, (elapsed - letter_start_time) / slide_duration))

        letter_progress = 1 - (1 - letter_progress) * (1 - letter_progress)

        local letter_width = draw.surface.font:get_text_size(letter).x
        local target_x = current_x
        local start_x = target_x + 100 

        local x = start_x + (target_x - start_x) * letter_progress

        if elapsed > letter_start_time then

            for ox = -1, 1 do
                for oy = -1, 1 do
                    if ox ~= 0 or oy ~= 0 then
                        draw.surface:add_text(
                            draw.vec2(x + ox, center_y - 20 + oy),
                            letter,
                            draw.color(0, 0, 0, alpha)
                        )
                    end
                end
            end

            draw.surface:add_text(
                draw.vec2(x, center_y - 20),
                letter,
                draw.color(255, 255, 255, alpha)
            )
        end

        current_x = current_x + letter_width + letter_spacing
    end

    local total_text_width = 0
    for _, letter in ipairs(M.startup_anim.letters_premium) do
        total_text_width = total_text_width + draw.surface.font:get_text_size(letter).x + letter_spacing
    end

    local text_x = center_x - (total_text_width / 2)

    local current_text_x = text_x
    for i, letter in ipairs(M.startup_anim.letters_premium) do
        local letter_start_time = 0.8 + (i-1) * letter_delay 
        local letter_progress = math.max(0, math.min(1, (elapsed - letter_start_time) / slide_duration))

        letter_progress = 1 - (1 - letter_progress) * (1 - letter_progress)

        local letter_width = draw.surface.font:get_text_size(letter).x
        local target_x = current_text_x
        local start_x = target_x + 100

        local x = start_x + (target_x - start_x) * letter_progress

        if elapsed > letter_start_time then

            for ox = -1, 1 do
                for oy = -1, 1 do
                    if ox ~= 0 or oy ~= 0 then
                        draw.surface:add_text(
                            draw.vec2(x + ox, center_y + 10 + oy),
                            letter,
                            draw.color(0, 0, 0, alpha)
                        )
                    end
                end
            end

            draw.surface:add_text(
                draw.vec2(x, center_y + 10),
                letter,
                draw.color(196, 30, 58, alpha)
            )
        end

        current_text_x = current_text_x + letter_width + letter_spacing
    end

    draw.surface.font = draw.fonts["gui_debug"]
    local credit_text = "by mlasno23/Doodlebot"
    local credit_size = draw.surface.font:get_text_size(credit_text)

    local credit_y = center_y + 45
    local credit_x = center_x - (credit_size.x / 2)

    local credit_start_time = 1.2  
    local credit_progress = math.max(0, math.min(1, (elapsed - credit_start_time) / slide_duration))

    credit_progress = 1 - (1 - credit_progress) * (1 - credit_progress)

    local credit_target_x = credit_x
    local credit_start_x = credit_target_x + 100
    local final_x = credit_start_x + (credit_target_x - credit_start_x) * credit_progress

    if elapsed > credit_start_time then

        for ox = -1, 1 do
            for oy = -1, 1 do
                if ox ~= 0 or oy ~= 0 then
                    draw.surface:add_text(
                        draw.vec2(final_x + ox, credit_y + oy),
                        credit_text,
                        draw.color(0, 0, 0, alpha)
                    )
                end
            end
        end

        draw.surface:add_text(
            draw.vec2(final_x, credit_y),
            credit_text,
            draw.color(255, 255, 255, alpha)
        )
    end
end

function M.on_hit(event)
    if event:get_name() ~= "player_hurt" then return end

    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 1) == 0 then
        return 
    end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if attacker and local_player and attacker == local_player then
        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local current_time = game.global_vars.cur_time
        local victim_name = victim and victim:get_name() or "unknown"

        if damage == M.hitlogs_last.damage and 
           hitbox == M.hitlogs_last.hitbox and 
           (current_time - M.hitlogs_last.time) < 0.01 then
            return
        end

        M.hitlogs_last.damage = damage
        M.hitlogs_last.hitbox = hitbox
        M.hitlogs_last.time = current_time

        local hit_location = M.HITBOX_NAMES[hitbox] or "body"

        local log_text = health <= 0 and
            string.format("Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage (\x01died\x02)",
                victim_name, hit_location, damage) or
            string.format("Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage (\x01%d\x02 hp remaining)", 
                victim_name, hit_location, damage, health)

        table.insert(M.hitlogs, {
            text = log_text,
            time = current_time,
            alpha = 0, 
            y_offset = -20, 
            x_offset = -300, 
            state = "fade_in", 
            segments = {}  
        })

        if #M.hitlogs > 8 then
            table.remove(M.hitlogs, 1)
        end
    end
end

function M.on_hurt(event)
    if event:get_name() ~= "player_hurt" then return end

    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 1) == 0 then
        return 
    end

    local victim = event:get_pawn_from_id("userid")
    local attacker = event:get_pawn_from_id("attacker")
    local local_player = entities.get_local_pawn()

    if victim and local_player and victim == local_player and attacker and attacker:is_enemy() then
        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local current_time = game.global_vars.cur_time
        local attacker_name = attacker:get_name() or "unknown"

        if damage == M.hurtlogs_last.damage and 
           hitbox == M.hurtlogs_last.hitbox and 
           (current_time - M.hurtlogs_last.time) < 0.01 then
            return
        end

        M.hurtlogs_last.damage = damage
        M.hurtlogs_last.hitbox = hitbox
        M.hurtlogs_last.time = current_time

        local hit_location = M.HITBOX_NAMES[hitbox] or "body"

        local log_text = string.format("Hurt by \x01%s\x02 in \x01%s\x02 for \x01%d\x02 damage (\x01%d\x02 hp remaining)",
            attacker_name, hit_location, damage, health)

        table.insert(M.hitlogs, {
            text = log_text,
            time = current_time,
            alpha = 0,
            y_offset = -20,
            x_offset = -300, 
            state = "fade_in",
            segments = {}
        })

        if #M.hitlogs > 8 then
            table.remove(M.hitlogs, 1)
        end
    end
end

function M.parse_text_segments(text, accent_color)
    local segments = {}
    local current_pos = 1
    local in_colored = false

    for j = 1, #text do
        local char = text:sub(j, j)
        if char == '\x01' then
            if current_pos < j then
                table.insert(segments, {
                    text = text:sub(current_pos, j - 1),
                    color = in_colored and accent_color or M.colors.white
                })
            end
            current_pos = j + 1
            in_colored = true
        elseif char == '\x02' then
            if current_pos < j then
                table.insert(segments, {
                    text = text:sub(current_pos, j - 1),
                    color = in_colored and accent_color or M.colors.white
                })
            end
            current_pos = j + 1
            in_colored = false
        end
    end

    if current_pos <= #text then
        table.insert(segments, {
            text = text:sub(current_pos),
            color = in_colored and accent_color or M.colors.white
        })
    end

    return segments
end
function M.render_gamesense_hitlog()
    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 2) == 0 then 
        return 
    end

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local current_time = game.global_vars.cur_time
    local accent_color = M.accent_picker:get_value():get()
    local frame_time = game.global_vars.frame_time

    local base_x = M.elements_pos.hitlogs and M.elements_pos.hitlogs.x or (M.screen[1] / 2 - 150)
    local base_y = M.elements_pos.hitlogs and M.elements_pos.hitlogs.y or (M.screen[2] - 200)

    if bit.band(combo_value, 32) ~= 0 then
        local dummy_elements = {
            {name = "hit", color = draw.color(255, 255, 255)},
            {name = " Azul", color = accent_color},
            {name = " in", color = draw.color(255, 255, 255)},
            {name = " head", color = accent_color},
            {name = " for", color = draw.color(255, 255, 255)},
            {name = " 95", color = accent_color},
            {name = " hp", color = draw.color(255, 255, 255)},
            {name = " (", color = draw.color(255, 255, 255)},
            {name = "5", color = accent_color},
            {name = " hp remaining)", color = draw.color(255, 255, 255)},
        }

        local total_width = 0
        for _, element in ipairs(dummy_elements) do
            total_width = total_width + d.font:get_text_size(element.name).x
        end
        total_width = total_width + 24

        local height = 20
        local pos_x = base_x
        local pos_y = base_y

        for i = 0, height do
            local alpha = 0
            if i < height * 0.2 or i > height * 0.8 then
                alpha = 40
            else
                local progress = (i - height * 0.2) / (height * 0.6)
                alpha = 40 * (1 - math.sin(progress * math.pi))
            end
            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y + i, pos_x + total_width, pos_y + i + 1),
                draw.color(0, 0, 0, alpha)
            )
        end

        draw.surface:add_rect_filled(
            draw.rect(pos_x, pos_y, pos_x + total_width, pos_y + 1),
            draw.color(0, 0, 0, 100)
        )
        draw.surface:add_rect_filled(
            draw.rect(pos_x, pos_y + height - 1, pos_x + total_width, pos_y + height),
            draw.color(0, 0, 0, 100)
        )

        local x_offset = pos_x + 12 
        for _, element in ipairs(dummy_elements) do
            draw.surface:add_text(draw.vec2(x_offset, pos_y + 4), element.name, element.color)
            x_offset = x_offset + d.font:get_text_size(element.name).x
        end
    end

    local log_spacing = 10
    for i = #M.hitlogs, 1, -1 do
        local log = M.hitlogs[i]
        local age = current_time - log.time

        if log.state == "fade_in" then
            log.alpha = math.min(255, log.alpha + (frame_time * 1275))
            log.y_offset = log.y_offset + (frame_time * 100)
            if log.alpha >= 255 then
                log.state = "visible"
                log.alpha = 255
                log.y_offset = 0
            end
        elseif age > 2 then
            log.state = "fade_out"
            log.alpha = math.max(0, 255 * (1 - (age - 2)))
            log.y_offset = log.y_offset - (frame_time * 50)
        end

        if age >= 3 then
            table.remove(M.hitlogs, i)
        else
            local y_pos = base_y + ((i - 1) * (15 + log_spacing)) + log.y_offset

            if not log.parsed_elements then
                log.parsed_elements = {}
                local current_pos = 1
                local in_colored = false

                for j = 1, #log.text do
                    local char = log.text:sub(j, j)
                    if char == '\x01' then
                        if current_pos < j then
                            table.insert(log.parsed_elements, {
                                name = log.text:sub(current_pos, j - 1),
                                color = in_colored and accent_color or draw.color(255, 255, 255)
                            })
                        end
                        current_pos = j + 1
                        in_colored = true
                    elseif char == '\x02' then
                        if current_pos < j then
                            table.insert(log.parsed_elements, {
                                name = log.text:sub(current_pos, j - 1),
                                color = in_colored and accent_color or draw.color(255, 255, 255)
                            })
                        end
                        current_pos = j + 1
                        in_colored = false
                    end
                end

                if current_pos <= #log.text then
                    table.insert(log.parsed_elements, {
                        name = log.text:sub(current_pos),
                        color = in_colored and accent_color or draw.color(255, 255, 255)
                    })
                end
            end

            local total_width = 0
            for _, element in ipairs(log.parsed_elements) do
                total_width = total_width + d.font:get_text_size(element.name).x
            end
            total_width = total_width + 24

            local height = 20
            local pos_x = base_x
            local pos_y = y_pos

            for i = 0, height do
                local alpha = 0
                if i < height * 0.2 or i > height * 0.8 then
                    alpha = 40
                else
                    local progress = (i - height * 0.2) / (height * 0.6)
                    alpha = 40 * (1 - math.sin(progress * math.pi))
                end
                draw.surface:add_rect_filled(
                    draw.rect(pos_x, pos_y + i, pos_x + total_width, pos_y + i + 1),
                    draw.color(0, 0, 0, math.floor(alpha * log.alpha / 255))
                )
            end

            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y, pos_x + total_width, pos_y + 1),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )
            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y + height - 1, pos_x + total_width, pos_y + height),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )

            local x_offset = pos_x + 12 
            for _, element in ipairs(log.parsed_elements) do
                local text_color = draw.color(
                    element.color:get_r(), 
                    element.color:get_g(), 
                    element.color:get_b(), 
                    math.floor(log.alpha)
                )
                draw.surface:add_text(draw.vec2(x_offset, pos_y + 4), element.name, text_color)
                x_offset = x_offset + d.font:get_text_size(element.name).x
            end
        end
    end
end

    function M.render_apex_style_hitlogs()
        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
        if type(combo_value) ~= "number" or bit.band(combo_value, 1) == 0 then
            return 
        end

        local d = draw.surface
        d.font = draw.fonts["gui_debug"]
        local current_time = game.global_vars.cur_time
        local accent_color = M.accent_picker:get_value():get()
        local frame_time = game.global_vars.frame_time

        local base_x = M.elements_pos.hitlogs and M.elements_pos.hitlogs.x or (M.screen[1] / 2 - 150)
        local base_y = M.elements_pos.hitlogs and M.elements_pos.hitlogs.y or (M.screen[2] - 200)

        if M.dragging.hitlogs then
            local mouse = gui.input:cursor()
            base_x = mouse.x - M.drag_offset.hitlogs.x
            base_y = mouse.y - M.drag_offset.hitlogs.y
            M.elements_pos.hitlogs.x = base_x
            M.elements_pos.hitlogs.y = base_y
        end

        local corner_radius = 6
        local padding_x = 8
        local padding_y = 6
        local box_height = 24
        local log_spacing = 5
        local glow_size = 6

        local current_texture = d.g.texture
        local current_tex_sz = d.tex_sz
        d.g.texture = nil
        d.tex_sz = nil

        if bit.band(combo_value, 32) ~= 0 then
            local dummy_text = "Hit Example Player in the head for 100 damage (died)"

            local segments = M.parse_text_segments(dummy_text, accent_color)

            local total_text_width = 0
            for _, segment in ipairs(segments) do
                total_text_width = total_text_width + d.font:get_text_size(segment.text).x
            end

            local box_width = total_text_width + (padding_x * 2)

            for i = glow_size, 1, -1 do
                local alpha = 10 * (1 - (i / glow_size))
                d:add_rect_filled_rounded(
                    draw.rect(
                        base_x - i, 
                        base_y - i, 
                        base_x + box_width + i, 
                        base_y + box_height + i
                    ),
                    draw.color(
                        accent_color:get_r(),
                        accent_color:get_g(),
                        accent_color:get_b(),
                        math.floor(alpha)
                    ),
                    corner_radius + i,
                    draw.rounding.all
                )
            end

            d:add_rect_filled_rounded(
                draw.rect(
                    base_x, 
                    base_y, 
                    base_x + box_width, 
                    base_y + box_height
                ),
                draw.color(0, 0, 0, 175),
                corner_radius,
                draw.rounding.all
            )

            local current_x = base_x + padding_x
            local text_height = d.font:get_text_size("A").y
            local text_y = base_y + ((box_height - text_height) / 2)

            for _, segment in ipairs(segments) do

                local displayColor
                if segment.text:find("Example Player") or 
                   segment.text:find("head") or 
                   segment.text:find("100") or 
                   segment.text:find("died") then
                    displayColor = accent_color
                else
                    displayColor = M.colors.white
                end

                d:add_text(
                    draw.vec2(current_x, text_y),
                    segment.text,
                    displayColor
                )
                current_x = current_x + d.font:get_text_size(segment.text).x
            end
        end

        for i = #M.hitlogs, 1, -1 do
            local log = M.hitlogs[i]
            local age = current_time - log.time

            local slide_duration = 0.5
            local display_duration = 2.5
            local fade_duration = 0.5

            if age < slide_duration then

                log.x_offset = -300 * (1 - (age / slide_duration))
                log.alpha = math.min(255, 255 * (age / slide_duration))
            elseif age < (slide_duration + display_duration) then

                log.x_offset = 0
                log.alpha = 255
            else

                local fade_progress = (age - (slide_duration + display_duration)) / fade_duration
                log.x_offset = 300 * fade_progress
                log.alpha = math.max(0, 255 * (1 - fade_progress))
            end

            if age >= (slide_duration + display_duration + fade_duration) then
                table.remove(M.hitlogs, i)
            else
                local y_pos = base_y + ((i - 1) * (box_height + log_spacing))

                if #log.segments == 0 then
                    log.segments = M.parse_text_segments(log.text, accent_color)
                end

                local total_width = 0
                for _, segment in ipairs(log.segments) do
                    total_width = total_width + d.font:get_text_size(segment.text).x
                end

                local box_width = total_width + (padding_x * 2)

                for j = glow_size, 1, -1 do
                    local glow_alpha = 10 * (1 - (j / glow_size)) * (log.alpha / 255)
                    d:add_rect_filled_rounded(
                        draw.rect(
                            base_x + log.x_offset - j, 
                            y_pos - j, 
                            base_x + box_width + log.x_offset + j, 
                            y_pos + box_height + j
                        ),
                        draw.color(
                            accent_color:get_r(),
                            accent_color:get_g(),
                            accent_color:get_b(),
                            math.floor(glow_alpha)
                        ),
                        corner_radius + j,
                        draw.rounding.all
                    )
                end

                d:add_rect_filled_rounded(
                    draw.rect(
                        base_x + log.x_offset, 
                        y_pos, 
                        base_x + box_width + log.x_offset, 
                        y_pos + box_height
                    ),
                    draw.color(0, 0, 0, math.floor(log.alpha * 0.7)),
                    corner_radius,
                    draw.rounding.all
                )

                local current_x = base_x + padding_x + log.x_offset
                local text_height = d.font:get_text_size("A").y
                local text_y = y_pos + ((box_height - text_height) / 2)

                for _, segment in ipairs(log.segments) do
                    local in_colored = segment.color:get_r() == accent_color:get_r() and
                                      segment.color:get_g() == accent_color:get_g() and
                                      segment.color:get_b() == accent_color:get_b()

                    local color
                    if in_colored then
                        color = draw.color(
                            accent_color:get_r(),
                            accent_color:get_g(),
                            accent_color:get_b(),
                            log.alpha
                        )
                    else
                        color = draw.color(255, 255, 255, log.alpha)
                    end

                    d:add_text(
                        draw.vec2(current_x, text_y),
                        segment.text,
                        color
                    )
                    current_x = current_x + d.font:get_text_size(segment.text).x
                end
            end
        end

        d.g.texture = current_texture
        d.tex_sz = current_tex_sz
    end

    function M.fix_hitlog_segments()
        local accent_color = M.accent_picker:get_value():get()

        for i, log in ipairs(M.hitlogs) do
            if log and log.text and (#log.segments == 0 or log.segments == nil) then
                log.segments = M.parse_text_segments(log.text, accent_color) or {}
            end
        end

        return true  
    end

    events.present_queue:add(M.fix_hitlog_segments)

if not M.elements_pos.hitlogs then
    M.elements_pos.hitlogs = {x = M.screen[1] / 2 - 150, y = M.screen[2] - 200}
end

if not M.dragging.hitlogs then
    M.dragging.hitlogs = false
end

if not M.drag_offset.hitlogs then
    M.drag_offset.hitlogs = {x = 0, y = 0}
end

function M.on_comprehensive_gamesense_hit(event)
    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 16) == 0 then return end
    local accent_color = M.accent_picker:get_value():get()

    if event:get_name() ~= "player_hurt" then return end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if not attacker or not victim or attacker ~= local_player then return end

    local damage = event:get_int("dmg_health")
    local hitbox = event:get_int("hitgroup")
    local health = event:get_int("health")
    local victim_name = victim:get_name() or "unknown"
    local current_time = game.global_vars.cur_time

    if damage == M.hitlogs_last.damage and 
       hitbox == M.hitlogs_last.hitbox and 
       (current_time - M.hitlogs_last.time) < 0.01 then
        return
    end

    M.hitlogs_last.damage = damage
    M.hitlogs_last.hitbox = hitbox
    M.hitlogs_last.time = current_time

    local hit_location = M.HITBOX_NAMES[hitbox] or "body"

    local active_weapon = attacker:get_active_weapon()
    local attacker_pos = attacker:get_abs_origin()
    local victim_pos = victim:get_abs_origin()

    local distance = 0
    if attacker_pos and victim_pos then
        local dx = attacker_pos.x - victim_pos.x
        local dy = attacker_pos.y - victim_pos.y
        local dz = attacker_pos.z - victim_pos.z
        distance = math.sqrt(dx*dx + dy*dy + dz*dz)
    end

    local function calculate_damage_falloff(initial_damage, distance, weapon_range, range_modifier)
        if not weapon_range or not range_modifier then 
            return initial_damage 
        end

        local falloff_factor = math.max(0, 1 - (distance / weapon_range))
        return initial_damage * (1 - (1 - range_modifier) * (1 - falloff_factor))
    end

    local weapon_data = active_weapon and active_weapon:get_data()
    local falloff_damage = weapon_data and calculate_damage_falloff(
        damage, 
        distance, 
        weapon_data.range or 8192,  
        weapon_data.range_modifier or 0.98
    ) or damage

    local log_text
    if health <= 0 then
        log_text = string.format(
            "Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage at \x01%.1f\x02 units, (\x01died\x02) Damage Falloff: \x01%.1f\x02%%, Penetration Power: \x01%.2f\x02", 
            victim_name, 
            hit_location, 
            damage, 
            distance,
            weapon_data and ((damage - falloff_damage) / damage * 100) or 0,
            weapon_data and (weapon_data.penetration or 0) or 0
        )
    else
        log_text = string.format(
            "Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage at \x01%.1f\x02 units, (\x01%d\x02 Remaining) Damage Falloff: \x01%.1f\x02%%, Penetration Power: \x01%.2f\x02", 
            victim_name, 
            hit_location, 
            damage, 
            distance,
            health,
            weapon_data and ((damage - falloff_damage) / damage * 100) or 0,
            weapon_data and (weapon_data.penetration or 0) or 0
        )
    end

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local elements = {}
    local current_pos = 1
    local in_colored = false
    local total_width = 0

    for j = 1, #log_text do
        local char = log_text:sub(j, j)
        if char == '\x01' then
            if current_pos < j then
                local segment = log_text:sub(current_pos, j - 1)
                total_width = total_width + d.font:get_text_size(segment).x
                table.insert(elements, {
                    name = segment,
                    color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
                })
            end
            current_pos = j + 1
            in_colored = true
        elseif char == '\x02' then
            if current_pos < j then
                local segment = log_text:sub(current_pos, j - 1)
                total_width = total_width + d.font:get_text_size(segment).x
                table.insert(elements, {
                    name = segment,
                    color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
                })
            end
            current_pos = j + 1
            in_colored = false
        end
    end

    if current_pos <= #log_text then
        local segment = log_text:sub(current_pos)
        total_width = total_width + d.font:get_text_size(segment).x
        table.insert(elements, {
            name = segment,
            color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
        })
    end

    total_width = total_width + 24  

    local log_entry = {
        text = log_text,
        time = current_time,
        alpha = 0, 
        y_offset = -50,
        x_offset = -total_width,  
        state = "fade_in",
        elements = elements,
        total_width = total_width
    }

    table.insert(M.comprehensive_gs_hitlogs, log_entry)

    if #M.comprehensive_gs_hitlogs > 8 then
        table.remove(M.comprehensive_gs_hitlogs, 1)
    end
end

function M.render_comprehensive_gamesense_logs()
    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) ~= "number" or bit.band(combo_value, 16) == 0 then return end

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local current_time = game.global_vars.cur_time
    local frame_time = game.global_vars.frame_time
    local accent_color = M.accent_picker:get_value():get()

    local base_x = M.elements_pos.comprehensive_gs_logs.x
    local base_y = M.elements_pos.comprehensive_gs_logs.y
    local height = 20

    if M.dragging.comprehensive_gs_logs then
        local mouse = gui.input:cursor()
        M.elements_pos.comprehensive_gs_logs.x = mouse.x - M.drag_offset.comprehensive_gs_logs.x
        M.elements_pos.comprehensive_gs_logs.y = mouse.y - M.drag_offset.comprehensive_gs_logs.y
        base_x = M.elements_pos.comprehensive_gs_logs.x
        base_y = M.elements_pos.comprehensive_gs_logs.y
    end

    if type(combo_value) == "number" and bit.band(combo_value, 32) ~= 0 then

        local dummy_log_text = "Hit \x01Dummy Player\x02 in the \x01head\x02 for \x01100\x02 damage at \x01500.0\x02 units, (\x01died\x02) Damage Falloff: \x01 5.2\x02%, Penetration Power: \x01 2.50\x02"

        local elements = {}
        local current_pos = 1
        local in_colored = false
        local total_width = 0

        for j = 1, #dummy_log_text do
            local char = dummy_log_text:sub(j, j)
            if char == '\x01' then
                if current_pos < j then
                    local segment = dummy_log_text:sub(current_pos, j - 1)
                    total_width = total_width + d.font:get_text_size(segment).x
                    table.insert(elements, {
                        name = segment,
                        color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
                    })
                end
                current_pos = j + 1
                in_colored = true
            elseif char == '\x02' then
                if current_pos < j then
                    local segment = dummy_log_text:sub(current_pos, j - 1)
                    total_width = total_width + d.font:get_text_size(segment).x
                    table.insert(elements, {
                        name = segment,
                        color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
                    })
                end
                current_pos = j + 1
                in_colored = false
            end
        end

        if current_pos <= #dummy_log_text then
            local segment = dummy_log_text:sub(current_pos)
            total_width = total_width + d.font:get_text_size(segment).x
            table.insert(elements, {
                name = segment,
                color = in_colored and draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), 255) or draw.color(255, 255, 255)
            })
        end

        total_width = total_width + 24  

        for i = 0, height do
            local alpha = 0
            if i < height * 0.2 or i > height * 0.8 then
                alpha = 40
            else
                local progress = (i - height * 0.2) / (height * 0.6)
                alpha = 40 * (1 - math.sin(progress * math.pi))
            end
            draw.surface:add_rect_filled(
                draw.rect(base_x, base_y + i, base_x + total_width, base_y + i + 1),
                draw.color(0, 0, 0, alpha)
            )
        end

        draw.surface:add_rect_filled(
            draw.rect(base_x, base_y, base_x + total_width, base_y + 1),
            draw.color(0, 0, 0, 100)
        )
        draw.surface:add_rect_filled(
            draw.rect(base_x, base_y + height - 1, base_x + total_width, base_y + height),
            draw.color(0, 0, 0, 100)
        )

        local x_offset = base_x + 12 
        for _, element in ipairs(elements) do
            draw.surface:add_text(
                draw.vec2(x_offset, base_y + 4), 
                element.name, 
                element.color
            )
            x_offset = x_offset + d.font:get_text_size(element.name).x
        end
    end

    for i = #M.comprehensive_gs_hitlogs, 1, -1 do
        local log = M.comprehensive_gs_hitlogs[i]
        local age = current_time - log.time

        local slide_duration = 0.7  
        local display_duration = 4.0  

        if log.state == "fade_in" then

            local progress = math.min(1, (current_time - log.time) / slide_duration)
            log.x_offset = -log.total_width * (1 - progress)
            log.alpha = math.min(255, progress * 1275)

            if progress >= 1 then
                log.state = "visible"
                log.x_offset = 0
                log.alpha = 255
            end
        elseif age > (display_duration + slide_duration) then

            local fade_progress = math.min(1, (age - (display_duration + slide_duration)) / slide_duration)
            log.x_offset = log.total_width * fade_progress
            log.alpha = math.max(0, 255 * (1 - fade_progress))
        elseif age > display_duration then

            log.x_offset = 0
            log.alpha = 255
        end

        if age >= (display_duration + 2 * slide_duration) then
            table.remove(M.comprehensive_gs_hitlogs, i)
        else
            local y_pos = base_y + ((#M.comprehensive_gs_hitlogs - i) * (height + 4))

            local pos_x = base_x + log.x_offset
            local pos_y = y_pos

            for i = 0, height do
                local alpha = 0
                if i < height * 0.2 or i > height * 0.8 then
                    alpha = 40
                else
                    local progress = (i - height * 0.2) / (height * 0.6)
                    alpha = 40 * (1 - math.sin(progress * math.pi))
                end
                draw.surface:add_rect_filled(
                    draw.rect(pos_x, pos_y + i, pos_x + log.total_width, pos_y + i + 1),
                    draw.color(0, 0, 0, math.floor(alpha * log.alpha / 255))
                )
            end

            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y, pos_x + log.total_width, pos_y + 1),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )
            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y + height - 1, pos_x + log.total_width, pos_y + height),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )

            local x_offset = pos_x + 12 
            for _, element in ipairs(log.elements) do
                local text_color = draw.color(
                    element.color:get_r(), 
                    element.color:get_g(), 
                    element.color:get_b(), 
                    math.floor(log.alpha)
                )
                draw.surface:add_text(
                    draw.vec2(x_offset, pos_y + 4), 
                    element.name, 
                    text_color
                )
                x_offset = x_offset + d.font:get_text_size(element.name).x
            end
        end
    end
end
function M.gs_on_hit(event)
    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) == "number" then
        if bit.band(combo_value, 2) == 0 then return end
    end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if attacker and local_player and attacker == local_player then
        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local current_time = game.global_vars.cur_time
        local victim_name = victim and victim:get_name() or "unknown"

        if damage == M.hitlogs_last.damage and 
           hitbox == M.hitlogs_last.hitbox and 
           (current_time - M.hitlogs_last.time) < 0.01 then
            return
        end

        M.hitlogs_last.damage = damage
        M.hitlogs_last.hitbox = hitbox
        M.hitlogs_last.time = current_time

        local hit_location = M.HITBOX_NAMES[hitbox] or "body"

        local log_text = health <= 0 and
            string.format("Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage (\x01died\x02)", 
                victim_name, hit_location, damage) or
            string.format("Hit \x01%s\x02 in the \x01%s\x02 for \x01%d\x02 damage (\x01%d\x02 hp remaining)", 
                victim_name, hit_location, damage, health)

        table.insert(M.gs_hitlogs, {
            text = log_text,
            time = current_time,
            alpha = 0,
            y_offset = -20,
            state = "fade_in"
        })

        if #M.gs_hitlogs > 8 then
            table.remove(M.gs_hitlogs, 1)
        end
    end
end

function M.gs_on_hurt(event)
    if event:get_name() ~= "player_hurt" then return end

    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) == "number" then
        if bit.band(combo_value, 2) == 0 then return end
    end

    local victim = event:get_pawn_from_id("userid")
    local attacker = event:get_pawn_from_id("attacker")
    local local_player = entities.get_local_pawn()

    if victim and local_player and victim == local_player and attacker and attacker:is_enemy() then
        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local current_time = game.global_vars.cur_time
        local attacker_name = attacker:get_name() or "unknown"

        if damage == M.hitlogs_last.damage and 
           hitbox == M.hitlogs_last.hitbox and 
           (current_time - M.hitlogs_last.time) < 0.01 then
            return
        end

        M.hitlogs_last.damage = damage
        M.hitlogs_last.hitbox = hitbox
        M.hitlogs_last.time = current_time

        local hit_location = M.HITBOX_NAMES[hitbox] or "body"

        local log_text = string.format("Hurt by \x01%s\x02 in \x01%s\x02 for \x01%d\x02 damage (\x01%d\x02 hp remaining)",
            attacker_name, hit_location, damage, health)

        table.insert(M.gs_hitlogs, {
            text = log_text,
            time = current_time,
            alpha = 0,
            y_offset = -20,
            state = "fade_in"
        })

        if #M.gs_hitlogs > 8 then
            table.remove(M.gs_hitlogs, 1)
        end
    end
end

function M.render_gamesense_hitlog()
    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) == "number" then
        if bit.band(combo_value, 2) == 0 then return end
    end

    if M.dragging and M.dragging.hitlogs then
        local mouse = gui.input:cursor()
        M.elements_pos.hitlogs.x = mouse.x - M.drag_offset.hitlogs.x
        M.elements_pos.hitlogs.y = mouse.y - M.drag_offset.hitlogs.y
    end

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local current_time = game.global_vars.cur_time
    local accent_color = M.accent_picker:get_value():get()
    local frame_time = game.global_vars.frame_time

    local base_x = M.elements_pos.hitlogs.x or (M.screen[1] / 2 - 150)
    local base_y = M.elements_pos.hitlogs.y or (M.screen[2] - 200)

    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) == "number" then
        if bit.band(combo_value, 32) ~= 0 then
            local dummy_elements = {
                {name = "hit", color = draw.color(255, 255, 255)},
                {name = " Example Player", color = accent_color},
                {name = " in", color = draw.color(255, 255, 255)},
                {name = " head", color = accent_color},
                {name = " for", color = draw.color(255, 255, 255)},
                {name = " 95", color = accent_color},
                {name = " damage", color = draw.color(255, 255, 255)},
                {name = " (", color = draw.color(255, 255, 255)},
                {name = "5", color = accent_color},
                {name = " hp remaining)", color = draw.color(255, 255, 255)}
            }

            local total_width = 0
            for _, element in ipairs(dummy_elements) do
                total_width = total_width + d.font:get_text_size(element.name).x
            end
            total_width = total_width + 24

            local height = 20
            local pos_x = base_x
            local pos_y = base_y

            for i = 0, height do
                local alpha = 0
                if i < height * 0.2 or i > height * 0.8 then
                    alpha = 40
                else
                    local progress = (i - height * 0.2) / (height * 0.6)
                    alpha = 40 * (1 - math.sin(progress * math.pi))
                end
                draw.surface:add_rect_filled(
                    draw.rect(pos_x, pos_y + i, pos_x + total_width, pos_y + i + 1),
                    draw.color(0, 0, 0, alpha)
                )
            end

            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y, pos_x + total_width, pos_y + 1),
                draw.color(0, 0, 0, 100)
            )
            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y + height - 1, pos_x + total_width, pos_y + height),
                draw.color(0, 0, 0, 100)
            )

            local x_offset = pos_x + 12 
            for _, element in ipairs(dummy_elements) do
                draw.surface:add_text(draw.vec2(x_offset, pos_y + 4), element.name, element.color)
                x_offset = x_offset + d.font:get_text_size(element.name).x
            end
        end
    end

    local log_spacing = 10
    for i = #M.gs_hitlogs, 1, -1 do
        local log = M.gs_hitlogs[i]
        local age = current_time - log.time

        if log.state == "fade_in" then
            log.alpha = math.min(255, log.alpha + (frame_time * 1275))
            log.y_offset = log.y_offset + (frame_time * 100)
            if log.alpha >= 255 then
                log.state = "visible"
                log.alpha = 255
                log.y_offset = 0
            end
        elseif age > 2 then
            log.state = "fade_out"
            log.alpha = math.max(0, 255 * (1 - (age - 2)))
            log.y_offset = log.y_offset - (frame_time * 50)
        end

        if age >= 3 then
            table.remove(M.gs_hitlogs, i)
        else
            local y_pos = base_y + ((i - 1) * (15 + log_spacing)) + log.y_offset

            local elements = {}
            local current_pos = 1
            local in_colored = false
            for j = 1, #log.text do
                local char = log.text:sub(j, j)
                if char == '\x01' then
                    if current_pos < j then
                        table.insert(elements, {
                            name = log.text:sub(current_pos, j - 1),
                            color = in_colored and accent_color or draw.color(255, 255, 255)
                        })
                    end
                    current_pos = j + 1
                    in_colored = true
                elseif char == '\x02' then
                    if current_pos < j then
                        table.insert(elements, {
                            name = log.text:sub(current_pos, j - 1),
                            color = in_colored and accent_color or draw.color(255, 255, 255)
                        })
                    end
                    current_pos = j + 1
                    in_colored = false
                end
            end
            if current_pos <= #log.text then
                table.insert(elements, {
                    name = log.text:sub(current_pos),
                    color = in_colored and accent_color or draw.color(255, 255, 255)
                })
            end

            local total_width = 0
            for _, element in ipairs(elements) do
                total_width = total_width + d.font:get_text_size(element.name).x
            end
            total_width = total_width + 24

            local height = 20
            local pos_x = base_x
            local pos_y = y_pos

            for i = 0, height do
                local alpha = 0
                if i < height * 0.2 or i > height * 0.8 then
                    alpha = 40
                else
                    local progress = (i - height * 0.2) / (height * 0.6)
                    alpha = 40 * (1 - math.sin(progress * math.pi))
                end
                draw.surface:add_rect_filled(
                    draw.rect(pos_x, pos_y + i, pos_x + total_width, pos_y + i + 1),
                    draw.color(0, 0, 0, math.floor(alpha * log.alpha / 255))
                )
            end

            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y, pos_x + total_width, pos_y + 1),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )
            draw.surface:add_rect_filled(
                draw.rect(pos_x, pos_y + height - 1, pos_x + total_width, pos_y + height),
                draw.color(0, 0, 0, math.floor(100 * log.alpha / 255))
            )

            local x_offset = pos_x + 12 
            for _, element in ipairs(elements) do
                local text_color = draw.color(
                    element.color:get_r(), 
                    element.color:get_g(), 
                    element.color:get_b(), 
                    math.floor(log.alpha)
                )
                draw.surface:add_text(draw.vec2(x_offset, pos_y + 4), element.name, text_color)
                x_offset = x_offset + d.font:get_text_size(element.name).x
            end
        end
    end
end

function M.show_notification(title, message)
    local notif = gui.notification("Million.lua", message)
    gui.notify:add(notif)
 end
 function M.on_nvidia_hurt(event)
    if event:get_name() ~= "player_hurt" then return end

    local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(combo_value) == "number" then
        if bit.band(combo_value, 8) == 0 then return end
    end

    local victim = event:get_pawn_from_id("userid")
    local attacker = event:get_pawn_from_id("attacker")
    local local_player = entities.get_local_pawn()

    if victim and local_player and victim == local_player and attacker and attacker:is_enemy() then
        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local current_time = game.global_vars.cur_time
        local attacker_name = attacker:get_name() or "unknown"

        if damage == M.nvidia_last_hit.damage and 
           hitbox == M.nvidia_last_hit.hitbox and 
           (current_time - M.nvidia_last_hit.time) < 0.01 then
            return
        end

        M.nvidia_last_hit.damage = damage
        M.nvidia_last_hit.hitbox = hitbox
        M.nvidia_last_hit.time = current_time

        local hit_location = ""
        if hitbox == 1 then hit_location = "head"
        elseif hitbox == 2 then hit_location = "chest"
        elseif hitbox == 3 then hit_location = "stomach"
        elseif hitbox == 4 then hit_location = "left arm"
        elseif hitbox == 5 then hit_location = "right arm"
        elseif hitbox == 6 then hit_location = "left leg"
        elseif hitbox == 7 then hit_location = "right leg"
        else hit_location = "body"
        end

        table.insert(M.nvidia_hitlogs, {
            name = attacker_name,
            location = hit_location,
            damage = damage,
            health = health,
            time = current_time,
            progress = 0,
            alpha = 255,
            width = 0,
            is_hurt_log = true  
        })

        if #M.nvidia_hitlogs > 5 then
            table.remove(M.nvidia_hitlogs, 1)
        end
    end
end

 function M.on_nvidia_hit(event)
     if event:get_name() ~= "player_hurt" then return end

     local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
     if type(combo_value) == "number" then
         if bit.band(combo_value, 8) == 0 then return end
     end

     local current_time = game.global_vars.cur_time
     if current_time - M.nvidia_last_hit.time < 0.01 then return end

     local attacker = event:get_pawn_from_id("attacker")
     local victim = event:get_pawn_from_id("userid")
     local local_player = entities.get_local_pawn()

     if attacker and local_player and attacker == local_player then
         local damage = event:get_int("dmg_health")
         local hitbox = event:get_int("hitgroup")
         local health = event:get_int("health")
         local victim_name = victim and victim:get_name() or "unknown"

         M.nvidia_last_hit.damage = damage
         M.nvidia_last_hit.hitbox = hitbox
         M.nvidia_last_hit.time = current_time

         local hit_location = ""
         if hitbox == 1 then hit_location = "head"
         elseif hitbox == 2 then hit_location = "chest"
         elseif hitbox == 3 then hit_location = "stomach"
         elseif hitbox == 4 then hit_location = "left arm"
         elseif hitbox == 5 then hit_location = "right arm"
         elseif hitbox == 6 then hit_location = "left leg"
         elseif hitbox == 7 then hit_location = "right leg"
         else hit_location = "body"
         end

         table.insert(M.nvidia_hitlogs, {
             name = victim_name,
             location = hit_location,
             damage = damage,
             health = health,
             time = current_time,
             progress = 0,
             alpha = 255,
             width = 0
         })

         if #M.nvidia_hitlogs > 5 then
             table.remove(M.nvidia_hitlogs, 1)
         end
     end
 end

 function M.handle_hit_notification(event)
     if event:get_name() ~= "player_hurt" then return end

     local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
     if type(combo_value) == "number" then
         if bit.band(combo_value, 4) == 0 then return end
     end

     local currentTime = game.global_vars.real_time
     if currentTime - M.lastHitTime < 0.1 then return end
     M.lastHitTime = currentTime

     local attacker = event:get_pawn_from_id("attacker")
     local victim = event:get_pawn_from_id("userid")
     local local_player = entities.get_local_pawn()

     if attacker and local_player and attacker == local_player then
         local damage = event:get_int("dmg_health")
         local hitbox = event:get_int("hitgroup")
         local health = event:get_int("health")
         local victim_name = victim and victim:get_name() or "unknown"

         local hit_location = ""
         if hitbox == 1 then hit_location = "head"
         elseif hitbox == 2 then hit_location = "chest"
         elseif hitbox == 3 then hit_location = "stomach"
         elseif hitbox == 4 then hit_location = "left arm"
         elseif hitbox == 5 then hit_location = "right arm"
         elseif hitbox == 6 then hit_location = "left leg"
         elseif hitbox == 7 then hit_location = "right leg"
         else hit_location = "body"
         end

         local message = string.format("Hit %s in the %s for %d damage (%d hp remaining)", 
             victim_name, hit_location, damage, health)

         M.show_notification("Million.lua", message)
     end
 end

 function M.handle_hurt_notification(event)
     if event:get_name() ~= "player_hurt" then return end

     local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
     if type(combo_value) == "number" then
         if bit.band(combo_value, 4) == 0 then return end
     end

     local victim = event:get_pawn_from_id("userid")
     local attacker = event:get_pawn_from_id("attacker")
     local local_player = entities.get_local_pawn()

     if victim and local_player and victim == local_player and attacker and attacker:is_enemy() then
         local damage = event:get_int("dmg_health")
         local hitbox = event:get_int("hitgroup")
         local health = event:get_int("health")
         local attacker_name = attacker:get_name() or "unknown"

         local hit_location = ""
         if hitbox == 1 then hit_location = "head"
         elseif hitbox == 2 then hit_location = "chest"
         elseif hitbox == 3 then hit_location = "stomach"
         elseif hitbox == 4 then hit_location = "left arm"
         elseif hitbox == 5 then hit_location = "right arm"
         elseif hitbox == 6 then hit_location = "left leg"
         elseif hitbox == 7 then hit_location = "right leg"
         else hit_location = "body"
         end

         local message = string.format("Hurt by %s in %s for %d damage (%d hp remaining)", 
             attacker_name, hit_location, damage, health)

         M.show_notification("Million.lua", message)
     end
 end

    function M.render_nvidia_hitlog()
        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
        if type(combo_value) ~= "number" or bit.band(combo_value, 8) == 0 then return end

        local d = draw.surface
        d.font = draw.fonts["gui_title"]  
        local current_time = game.global_vars.cur_time
        local accent_color = M.accent_picker:get_value():get()
        local frame_time = game.global_vars.frame_time

        local saved_command = {}
        saved_command.texture = d.g.texture
        saved_command.frag_shader = d.g.frag_shader
        saved_command.tex_sz = d.tex_sz
        saved_command.mode = d.g.mode
        saved_command.is_tile = d.g.is_tile
        saved_command.uv_rect = d.g.uv_rect
        saved_command.alpha = d.g.alpha
        saved_command.rotation = d.g.rotation
        saved_command.anti_alias = d.g.anti_alias
        saved_command.ignore_scaling = d.g.ignore_scaling

        d.g.texture = nil
        d.g.frag_shader = nil
        d.tex_sz = nil
        d.g.mode = nil
        d.g.is_tile = false
        d.g.uv_rect = nil
        d.g.alpha = 1.0
        d.g.rotation = 0
        d.g.anti_alias = true
        d.g.ignore_scaling = true

        local base_x = 0  
        local base_y = 50
        local nvidia_height = 40
        local text_padding = 20
        local bar_width = 10

        for i = #M.nvidia_hitlogs, 1, -1 do
            local log = M.nvidia_hitlogs[i]
            local age = current_time - log.time

            local segments
            if log.is_hurt_log then
                segments = {
                    {text = "Hurt by ", color = M.colors.white},
                    {text = log.name, color = accent_color},
                    {text = " in ", color = M.colors.white},
                    {text = log.location, color = accent_color},
                    {text = " for ", color = M.colors.white},
                    {text = tostring(log.damage), color = accent_color},
                    {text = " damage (", color = M.colors.white},
                    {text = tostring(log.health), color = accent_color},
                    {text = " hp remaining)", color = M.colors.white}
                }
            else
                segments = {
                    {text = "Hit ", color = M.colors.white},
                    {text = log.name, color = accent_color},
                    {text = " in the ", color = M.colors.white},
                    {text = log.location, color = accent_color},
                    {text = " for ", color = M.colors.white},
                    {text = tostring(log.damage), color = accent_color},
                    {text = " damage (", color = M.colors.white},
                    {text = tostring(log.health), color = accent_color},
                    {text = " hp remaining)", color = M.colors.white}
                }
            end

            local total_width = 0
            for _, segment in ipairs(segments) do
                total_width = total_width + d.font:get_text_size(segment.text).x
            end
            local required_width = total_width + (text_padding * 3) + bar_width

            local x_offset = 0
            local hitlogs_nvidia = {
                nvidia_slide_duration = 0.3,
                nvidia_display_duration = 3.0,
                nvidia_fade_duration = 0.5,
                nvidia_max_width = 300,
                nvidia_height = 25 
            }

            if age < hitlogs_nvidia.nvidia_slide_duration then

                log.width = math.min(required_width, (age / hitlogs_nvidia.nvidia_slide_duration) * required_width)
            elseif age > hitlogs_nvidia.nvidia_display_duration then

                local fade_progress = (age - hitlogs_nvidia.nvidia_display_duration) / hitlogs_nvidia.nvidia_fade_duration
                log.width = required_width
                x_offset = -(fade_progress * required_width)
                log.alpha = math.max(0, 255 * (1 - fade_progress))
            else
                log.width = required_width
            end

            if age >= (hitlogs_nvidia.nvidia_display_duration + hitlogs_nvidia.nvidia_fade_duration) then
                table.remove(M.nvidia_hitlogs, i)
            else
                local y_pos = base_y + ((i-1) * (nvidia_height + 8))

                d:add_rect_filled(
                    draw.rect(base_x + x_offset, y_pos, base_x + x_offset + log.width, y_pos + nvidia_height),
                    draw.color(0, 0, 0, math.floor(log.alpha * 0.75))
                )

                if log.width > bar_width then
                    d:add_rect_filled(
                        draw.rect(base_x + x_offset + log.width - bar_width, y_pos, base_x + x_offset + log.width, y_pos + nvidia_height),
                        draw.color(accent_color:get_r(), accent_color:get_g(), accent_color:get_b(), log.alpha)
                    )
                end

                if log.width > text_padding * 2 then
                    local current_x = base_x + x_offset + text_padding
                    local text_height = d.font:get_text_size(segments[1].text).y
                    local text_y = y_pos + ((nvidia_height - text_height) / 2) - 2

                    for _, segment in ipairs(segments) do
                        local color = draw.color(
                            segment.color:get_r(),
                            segment.color:get_g(),
                            segment.color:get_b(),
                            log.alpha
                        )

                        d:add_text(
                            draw.vec2(current_x, text_y),
                            segment.text,
                            color
                        )
                        current_x = current_x + d.font:get_text_size(segment.text).x
                    end
                end
            end
        end

        d.g.texture = saved_command.texture
        d.g.frag_shader = saved_command.frag_shader
        d.tex_sz = saved_command.tex_sz
        d.g.mode = saved_command.mode
        d.g.is_tile = saved_command.is_tile
        d.g.uv_rect = saved_command.uv_rect
        d.g.alpha = saved_command.alpha
        d.g.rotation = saved_command.rotation
        d.g.anti_alias = saved_command.anti_alias
        d.g.ignore_scaling = saved_command.ignore_scaling
    end

    function M.calculate_damage_falloff(initial_damage, distance, weapon_range, range_modifier)
        if not weapon_range or not range_modifier then 
            return initial_damage 
        end

        local falloff_factor = math.max(0, 1 - (distance / weapon_range))
        return initial_damage * (1 - (1 - range_modifier) * (1 - falloff_factor))
    end

    function M.on_console_hit_log(event)
        if event:get_name() ~= "player_hurt" then return end

        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
        if type(combo_value) == "number" then
            if bit.band(combo_value, 64) == 0 then return end  
        end

        local attacker = event:get_pawn_from_id("attacker")
        local victim = event:get_pawn_from_id("userid")
        local local_player = entities.get_local_pawn()

        if attacker and local_player and attacker == local_player and victim then
            local damage = event:get_int("dmg_health")
            local hitbox = event:get_int("hitgroup")
            local health = event:get_int("health")
            local current_time = game.global_vars.cur_time
            local victim_name = victim:get_name() or "unknown"

            if damage == M.hitlogs_last.damage and 
               hitbox == M.hitlogs_last.hitbox and 
               (current_time - M.hitlogs_last.time) < 0.01 then
                return
            end

            M.hitlogs_last.damage = damage
            M.hitlogs_last.hitbox = hitbox
            M.hitlogs_last.time = current_time

            local hit_location = ""
            if hitbox == 1 then hit_location = "head"
            elseif hitbox == 2 then hit_location = "chest"
            elseif hitbox == 3 then hit_location = "stomach"
            elseif hitbox == 4 then hit_location = "left arm"
            elseif hitbox == 5 then hit_location = "right arm"
            elseif hitbox == 6 then hit_location = "left leg"
            elseif hitbox == 7 then hit_location = "right leg"
            else hit_location = "body"
            end

            local attacker_pos = attacker:get_abs_origin()
            local victim_pos = victim:get_abs_origin()
            local distance = 0

            if attacker_pos and victim_pos then
                local dx = attacker_pos.x - victim_pos.x
                local dy = attacker_pos.y - victim_pos.y
                local dz = attacker_pos.z - victim_pos.z
                distance = math.sqrt(dx*dx + dy*dy + dz*dz)
            end

            local active_weapon = attacker:get_active_weapon()
            local weapon_data = active_weapon and active_weapon:get_data()

            local falloff_damage = weapon_data and M.calculate_damage_falloff(
                damage, 
                distance, 
                weapon_data.range or 8192,
                weapon_data.range_modifier or 0.98
            ) or damage

            local log_text = string.format(
                "[Million.lua] Hit %s in %s for %d damage at %.1f units, (%d Remaining) Damage Falloff: %.1f%%, Penetration Power: %.2f",
                victim_name,
                hit_location,
                damage,
                distance,
                health,
                weapon_data and ((damage - falloff_damage) / damage * 100) or 0,
                weapon_data and (weapon_data.penetration or 0) or 0
            )

            print(log_text)
        end
    end

    function M.on_console_hurt_log(event)
        if event:get_name() ~= "player_hurt" then return end

        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()
        if type(combo_value) == "number" then
            if bit.band(combo_value, 64) == 0 then return end  
        end

        local victim = event:get_pawn_from_id("userid")
        local attacker = event:get_pawn_from_id("attacker")
        local local_player = entities.get_local_pawn()

        if victim and local_player and victim == local_player and attacker and attacker:is_enemy() then
            local damage = event:get_int("dmg_health")
            local hitbox = event:get_int("hitgroup")
            local health = event:get_int("health")
            local current_time = game.global_vars.cur_time
            local attacker_name = attacker:get_name() or "unknown"

            if damage == M.hitlogs_last.damage and 
               hitbox == M.hitlogs_last.hitbox and 
               (current_time - M.hitlogs_last.time) < 0.01 then
                return
            end

            M.hitlogs_last.damage = damage
            M.hitlogs_last.hitbox = hitbox
            M.hitlogs_last.time = current_time

            local hit_location = ""
            if hitbox == 1 then hit_location = "head"
            elseif hitbox == 2 then hit_location = "chest"
            elseif hitbox == 3 then hit_location = "stomach"
            elseif hitbox == 4 then hit_location = "left arm"
            elseif hitbox == 5 then hit_location = "right arm"
            elseif hitbox == 6 then hit_location = "left leg"
            elseif hitbox == 7 then hit_location = "right leg"
            else hit_location = "body"
            end

            local attacker_pos = attacker:get_abs_origin()
            local victim_pos = victim:get_abs_origin()
            local distance = 0

            if attacker_pos and victim_pos then
                local dx = attacker_pos.x - victim_pos.x
                local dy = attacker_pos.y - victim_pos.y
                local dz = attacker_pos.z - victim_pos.z
                distance = math.sqrt(dx*dx + dy*dy + dz*dz)
            end

            local log_text = string.format(
                "[Million.lua] Hurt by %s in %s for %d damage at %.1f units, (%d Remaining)",
                attacker_name,
                hit_location,
                damage,
                distance,
                health
            )

            print(log_text)
        end
    end

    function M.on_damage_event(e)
        if not game.engine:in_game() then return end

        local name = e:get_name()

        if name == 'player_hurt' then

            local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
            if type(damage_effects_value) ~= "number" then return end

            local local_pawn = entities.get_local_pawn()
            if not local_pawn then return end

            local user_pawn = e:get_pawn_from_id('userid')
            local attacker_pawn = e:get_pawn_from_id('attacker')

            if not user_pawn or not attacker_pawn then return end
            if not user_pawn:is_enemy() then return end
            if attacker_pawn ~= local_pawn then return end

            local user_pawn_origin = user_pawn:get_abs_origin()
            if not user_pawn_origin then return end

            local best_distance = math.huge
            local best_impact = nil
            local best_impact_idx = -1

            for i = 1, #M.dmg.impacts do
                local impact = M.dmg.impacts[i]
                local distance = impact.position:dist_sqr(user_pawn_origin)
                if distance < best_distance then
                    best_distance = distance
                    best_impact = impact
                    best_impact_idx = i
                end
            end

            if best_impact == nil then return end

            if bit.band(damage_effects_value, 1) ~= 0 then
                local damage = e:get_int('dmg_health')
                local remaining_health = e:get_int('health')

                table.insert(M.dmg.damage_numbers, {
                    opacity = 1.0,           
                    progress = 0.0,          
                    position = best_impact.position,
                    damage = damage,
                    lethal = remaining_health <= 0  
                })
            end

            if bit.band(damage_effects_value, 2) ~= 0 then
                table.insert(M.dmg.hitmarkers, {
                    opacity = 1.0,
                    position = best_impact.position
                })
            end

            if bit.band(damage_effects_value, 4) ~= 0 then

                local initial_velocity = -50  

                table.insert(M.dmg.heart_hitmarkers, {
                    opacity = 1.0,
                    position = best_impact.position,
                    time = game.global_vars.real_time,
                    y_offset = 0,
                    velocity = initial_velocity
                })
            end

            table.remove(M.dmg.impacts, best_impact_idx)
        end

        if name == 'bullet_impact' then
            local local_pawn = entities.get_local_pawn()
            if not local_pawn then return end  

            local user_pawn = e:get_pawn_from_id('userid')
            if not user_pawn then return end   

            if user_pawn ~= local_pawn then return end

            table.insert(M.dmg.impacts, {
                time = 1.0,
                position = vector(
                    e:get_float('x'),
                    e:get_float('y'),
                    e:get_float('z')
                )
            })
        end
    end

  M.last_killsay_time = 0

  M.last_deathsay_time = 0
M.killsay_cooldown = 2.0  
M.deathsay_cooldown = 2.0  

function M.handle_killsay(event)
    if event:get_name() ~= "player_death" then return end

    local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
    if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 8) == 0 then 
        return 
    end

    local attacker = event:get_controller("attacker")
    local victim = event:get_controller("userid")
    local local_controller = entities.get_local_controller()

    if not attacker or not victim or attacker ~= local_controller then
        return
    end

    local current_time = game.global_vars.real_time
    if current_time - M.last_killsay_time < M.killsay_cooldown then
        return
    end

    M.last_killsay_time = current_time

    local victim_name = victim:get_name() or "player"

    local killsay_message = M.killsay_input.value
    if not killsay_message or killsay_message == "" then
        killsay_message = "Get rekt {player}!"
    end

    killsay_message = killsay_message:gsub("{player}", victim_name)

    game.engine:client_cmd('say "' .. killsay_message .. '"')
end

function M.handle_deathsay(event)
    if event:get_name() ~= "player_death" then return end

    local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
    if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 16) == 0 then 
        return 
    end

    local attacker = event:get_controller("attacker")
    local victim = event:get_controller("userid")
    local local_controller = entities.get_local_controller()

    if not attacker or not victim or victim ~= local_controller then
        return
    end

    local current_time = game.global_vars.real_time
    if current_time - M.last_deathsay_time < M.deathsay_cooldown then
        return
    end

    M.last_deathsay_time = current_time

    local killer_name = attacker:get_name() or "player"

    local deathsay_message = M.deathsay_input.value
    if not deathsay_message or deathsay_message == "" then
        deathsay_message = "Nice luck {player}!"
    end

    deathsay_message = deathsay_message:gsub("{player}", killer_name)

    game.engine:client_cmd('say "' .. deathsay_message .. '"')
end

mods.events:add_listener("player_death")

events.event:remove(M.handle_killsay)
events.event:remove(M.handle_deathsay)

events.event:add(M.handle_killsay)
events.event:add(M.handle_deathsay)

    function M.render_damage_numbers()
        local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
        if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 1) == 0 then return end

        local layer = draw.surface
        layer.font = draw.fonts['gui_title']  
        local command = layer.g
        command.anti_alias = true

        for i = #M.dmg.damage_numbers, 1, -1 do
            local number = M.dmg.damage_numbers[i]
            if number ~= nil then

                number.progress = math.clamp(number.progress + game.global_vars.frame_time, 0.0, 1.0)

                if number.progress >= 1.0 then
                    number.opacity = number.opacity - (game.global_vars.frame_time * 2.0)
                    if number.opacity <= 0.0 then
                        table.remove(M.dmg.damage_numbers, i)
                        goto continue
                    end
                end

                local screen = math.world_to_screen(number.position)
                if not screen then goto continue end

                local alignment = draw.text_params.with_vh(draw.text_alignment.center, draw.text_alignment.center)
                local content = string.format('%.0f', number.damage * number.progress)
                local offset = layer.font:get_text_size(content).y * 2.0
                local opacity = math.floor(255 * number.opacity)

                local shadow_color = draw.color(0, 0, 0, opacity)
                layer:add_text(draw.vec2(screen.x + 1, screen.y - offset + 1), content, shadow_color, alignment)

                local chosen_color = M.damage_numbers_color:get_value():get()
                local text_color = draw.color(
                    chosen_color:get_r(),
                    chosen_color:get_g(),
                    chosen_color:get_b(),
                    opacity
                )
                layer:add_text(draw.vec2(screen.x, screen.y - offset), content, text_color, alignment)
            end
            ::continue::
        end
    end

    function M.render_hitmarkers()
        local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
        if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 2) == 0 then return end

        local layer = draw.surface
        local command = layer.g
        command.anti_alias = true

        local hitmarker_lengths = {
            { -M.dmg.hitmarker_length, -M.dmg.hitmarker_length },
            {  M.dmg.hitmarker_length, -M.dmg.hitmarker_length },
            { -M.dmg.hitmarker_length,  M.dmg.hitmarker_length },
            {  M.dmg.hitmarker_length,  M.dmg.hitmarker_length }
        }

        for i = #M.dmg.hitmarkers, 1, -1 do
            local hitmarker = M.dmg.hitmarkers[i]
            if hitmarker ~= nil then

                hitmarker.opacity = hitmarker.opacity - (game.global_vars.frame_time * 3)
                if hitmarker.opacity <= 0.0 then
                    table.remove(M.dmg.hitmarkers, i)
                    goto continue
                end

                local screen = math.world_to_screen(hitmarker.position)
                if not screen then goto continue end

                local opacity = math.floor(255 * hitmarker.opacity)
                local chosen_color = M.hitmarkers_color:get_value():get()
                local color = draw.color(
                    chosen_color:get_r(),
                    chosen_color:get_g(),
                    chosen_color:get_b(),
                    opacity
                )

                for _, length in ipairs(hitmarker_lengths) do
                    local start_pos = draw.vec2(screen.x + length[1], screen.y + length[2])
                    local end_pos = draw.vec2(
                        screen.x + length[1] + (length[1] > 0 and -M.dmg.hitmarker_spacing or M.dmg.hitmarker_spacing),
                        screen.y + length[2] + (length[2] > 0 and -M.dmg.hitmarker_spacing or M.dmg.hitmarker_spacing)
                    )
                    layer:add_line(start_pos, end_pos, color, M.dmg.hitmarker_thickness)
                end
            end
            ::continue::
        end
    end

    function M.draw_heart_hitmarker(center_x, center_y, size, opacity)

        local heart = {
            {0,0,1,1,0,0,1,1,0,0},
            {0,1,1,1,1,1,1,1,1,0},
            {1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1,1},
            {0,1,1,1,1,1,1,1,1,0},
            {0,0,1,1,1,1,1,1,0,0},
            {0,0,0,1,1,1,1,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,0,0,0,0,0,0}
        }

        M.draw_pixel_hitmarker(heart, center_x, center_y, size, opacity)
    end

    function M.draw_ruby_hitmarker(center_x, center_y, size, opacity)
        local ruby = {
            {0,0,0,1,1,1,1,0,0,0},
            {0,0,1,1,1,1,1,1,0,0},
            {0,1,1,1,1,1,1,1,1,0},
            {1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,0,0,1,1,1,1},
            {1,1,1,0,0,0,0,1,1,1},
            {0,1,1,0,0,0,0,1,1,0},
            {0,0,1,1,0,0,1,1,0,0},
            {0,0,0,1,1,1,1,0,0,0},
            {0,0,0,0,1,1,0,0,0,0}
        }

        M.draw_pixel_hitmarker(ruby, center_x, center_y, size, opacity)
    end

    function M.draw_star_hitmarker(center_x, center_y, size, opacity)
        local star = {
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,1,2,2,1,0,0,0},
            {0,0,1,2,2,2,2,1,0,0},
            {0,1,2,2,2,2,2,2,1,0},
            {1,2,2,2,2,2,2,2,2,1},
            {0,1,2,2,0,0,2,2,1,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,1,0,0,0,0,0,0,1,0},
            {1,0,0,0,0,0,0,0,0,1},
            {0,0,0,1,0,0,1,0,0,0}
        }

        M.draw_pixel_hitmarker(star, center_x, center_y, size, opacity)
    end

    function M.draw_cross_hitmarker(center_x, center_y, size, opacity)
        local cross = {
            {1,0,0,0,0,0,0,0,0,1},
            {0,1,0,0,0,0,0,0,1,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,0,0,1,0,0,1,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,1,0,0,1,0,0,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,1,0,0,0,0,0,0,1,0},
            {1,0,0,0,0,0,0,0,0,1}
        }

        M.draw_pixel_hitmarker(cross, center_x, center_y, size, opacity)
    end 

    function M.draw_diamond_hitmarker(center_x, center_y, size, opacity)
        local diamond = {
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,1,2,2,1,0,0,0},
            {0,0,1,2,2,2,2,1,0,0},
            {0,1,2,2,2,2,2,2,1,0},
            {1,2,2,2,2,2,2,2,2,1},
            {1,2,2,2,2,2,2,2,2,1},
            {0,1,2,2,2,2,2,2,1,0},
            {0,0,1,2,2,2,2,1,0,0},
            {0,0,0,1,2,2,1,0,0,0},
            {0,0,0,0,1,1,0,0,0,0}
        }
        M.draw_pixel_hitmarker(diamond, center_x, center_y, size, opacity)
    end

    function M.draw_skull_hitmarker(center_x, center_y, size, opacity)
        local skull = {
            {0,0,1,1,1,1,1,1,0,0},
            {0,1,1,1,1,1,1,1,1,0},
            {1,1,0,1,1,1,1,0,1,1},
            {1,1,1,1,1,1,1,1,1,1},
            {1,1,0,0,1,1,0,0,1,1},
            {0,1,1,1,1,1,1,1,1,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,1,0,1,0,0,1,0,1,0},
            {0,1,0,1,1,1,1,0,1,0},
            {0,0,1,1,1,1,1,1,0,0}
        }

        M.draw_pixel_hitmarker(skull, center_x, center_y, size, opacity)
    end

    function M.draw_arrow_hitmarker(center_x, center_y, size, opacity)
        local arrow = {
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,1,1,1,1,0,0,0},
            {0,0,1,1,1,1,1,1,0,0},
            {0,1,1,1,1,1,1,1,1,0},
            {1,1,1,1,1,1,1,1,1,1},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,0,1,1,0,0,0,0}
        }

        M.draw_pixel_hitmarker(arrow, center_x, center_y, size, opacity)
    end

    function M.draw_classic_hitmarker(center_x, center_y, size, opacity)
        local classic = {
            {1,0,0,0,0,0,0,0,0,1},
            {0,1,0,0,0,0,0,0,1,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,0,0,1,0,0,1,0,0,0},
            {0,0,0,0,0,0,0,0,0,0},
            {0,0,0,0,0,0,0,0,0,0},
            {0,0,0,1,0,0,1,0,0,0},
            {0,0,1,0,0,0,0,1,0,0},
            {0,1,0,0,0,0,0,0,1,0},
            {1,0,0,0,0,0,0,0,0,1}
        }

        M.draw_pixel_hitmarker(classic, center_x, center_y, size, opacity)
    end

    function M.draw_lightning_hitmarker(center_x, center_y, size, opacity)
        local lightning = {
            {0,0,0,0,1,1,0,0,0,0},
            {0,0,0,1,1,0,0,0,0,0},
            {0,0,1,1,0,0,0,0,0,0},
            {0,1,1,1,1,1,1,0,0,0},
            {0,0,0,1,1,0,0,0,0,0},
            {0,0,1,1,0,0,0,0,0,0},
            {0,1,1,0,0,0,0,0,0,0},
            {1,1,0,0,0,0,0,0,0,0},
            {1,0,0,0,0,0,0,0,0,0},
            {0,0,0,0,0,0,0,0,0,0}
        }

        M.draw_pixel_hitmarker(lightning, center_x, center_y, size, opacity)
    end

    function M.draw_smiley_hitmarker(center_x, center_y, size, opacity)
        local smiley = {
            {0,0,1,1,1,1,1,1,0,0},
            {0,1,1,1,1,1,1,1,1,0},
            {1,1,0,0,1,1,0,0,1,1},
            {1,1,0,0,1,1,0,0,1,1},
            {1,1,1,1,1,1,1,1,1,1},
            {1,1,0,0,0,0,0,0,1,1},
            {1,1,0,1,1,1,1,0,1,1},
            {1,1,0,0,1,1,0,0,1,1},
            {0,1,1,0,0,0,0,1,1,0},
            {0,0,1,1,1,1,1,1,0,0}
        }

        M.draw_pixel_hitmarker(smiley, center_x, center_y, size, opacity)
    end

function M.draw_question_hitmarker(center_x, center_y, size, opacity)
    local question = {
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,1,1,1,1,1,1,1,0},
        {1,1,0,0,0,0,0,0,1,1},
        {0,0,0,0,0,0,0,1,1,0},
        {0,0,0,0,1,1,1,1,0,0},
        {0,0,0,1,1,1,0,0,0,0},
        {0,0,0,1,1,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,1,1,1,0,0,0,0},
        {0,0,0,1,1,1,0,0,0,0}
    }

    M.draw_pixel_hitmarker(question, center_x, center_y, size, opacity)
end

function M.draw_dollar_hitmarker(center_x, center_y, size, opacity)
    local dollar = {
        {0,0,0,0,1,1,0,0,0,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,1,0,1,1,0,1,1,0},
        {1,1,0,0,1,1,0,0,0,0},
        {0,1,1,1,1,1,1,0,0,0},
        {0,0,0,1,1,1,1,1,1,0},
        {0,0,0,0,1,1,0,0,1,1},
        {0,1,1,0,1,1,0,1,1,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,0,0,0,1,1,0,0,0,0}
    }

    M.draw_pixel_hitmarker(dollar, center_x, center_y, size, opacity)
end

function M.draw_key_hitmarker(center_x, center_y, size, opacity)
    local key = {
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,0,0,1,0,0,1,0,0},
        {0,0,0,0,1,0,0,1,0,0},
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,1,1,1,1,1,1,1,0},
        {0,0,1,0,0,1,0,0,1,0},
        {0,0,1,0,0,1,0,0,1,0},
        {0,0,1,1,1,1,1,1,1,0},
        {0,0,0,0,0,0,0,0,0,0}
    }

    M.draw_pixel_hitmarker(key, center_x, center_y, size, opacity)
end

function M.draw_eye_hitmarker(center_x, center_y, size, opacity)
    local eye = {
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,1,1,1,1,1,1,1,0},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,0,0,0,0,1,1,1},
        {1,1,0,0,1,1,0,0,1,1},
        {1,1,0,0,1,1,0,0,1,1},
        {1,1,1,0,0,0,0,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {0,1,1,1,1,1,1,1,1,0},
        {0,0,1,1,1,1,1,1,0,0}
    }

    M.draw_pixel_hitmarker(eye, center_x, center_y, size, opacity)
end

function M.draw_fire_hitmarker(center_x, center_y, size, opacity)
    local fire = {
        {0,1,0,0,1,1,0,0,1,0},
        {0,1,0,1,1,1,1,0,1,0},
        {0,1,1,1,1,1,1,1,1,0},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {0,1,1,1,1,1,1,1,1,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,0,0,1,1,1,1,0,0,0},
        {0,0,0,0,1,1,0,0,0,0}
    }

    M.draw_pixel_hitmarker(fire, center_x, center_y, size, opacity)
end

function M.draw_moon_hitmarker(center_x, center_y, size, opacity)
    local moon = {
        {0,0,0,1,1,1,0,0,0,0},
        {0,0,1,1,1,1,0,0,0,0},
        {0,1,1,1,1,0,0,0,0,0},
        {1,1,1,1,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,0,0,0},
        {1,1,1,0,0,0,0,0,0,0},
        {1,1,1,1,0,0,0,0,0,0},
        {0,1,1,1,1,0,0,0,0,0},
        {0,0,1,1,1,1,0,0,0,0},
        {0,0,0,1,1,1,0,0,0,0}
    }

    M.draw_pixel_hitmarker(moon, center_x, center_y, size, opacity)
end

function M.draw_music_hitmarker(center_x, center_y, size, opacity)
    local music = {
        {0,0,0,0,0,1,1,1,1,0},
        {0,0,0,0,0,1,1,1,1,0},
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,0,0,0,1,1,0,0,0},
        {0,0,0,0,0,1,1,0,0,0},
        {1,1,0,0,0,1,1,0,0,0},
        {1,1,1,0,1,1,1,0,0,0},
        {0,1,1,1,1,1,0,0,0,0},
        {0,0,1,1,1,0,0,0,0,0}
    }

    M.draw_pixel_hitmarker(music, center_x, center_y, size, opacity)
end

function M.draw_lock_hitmarker(center_x, center_y, size, opacity)
    local lock = {
        {0,0,0,1,1,1,1,0,0,0},
        {0,0,1,0,0,0,0,1,0,0},
        {0,0,1,0,0,0,0,1,0,0},
        {0,0,1,0,0,0,0,1,0,0},
        {0,1,1,1,1,1,1,1,1,0},
        {1,1,1,1,1,1,1,1,1,1},
        {1,1,1,0,0,0,0,1,1,1},
        {1,1,1,0,0,0,0,1,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {0,1,1,1,1,1,1,1,1,0}
    }

    M.draw_pixel_hitmarker(lock, center_x, center_y, size, opacity)
end

function M.draw_battery_hitmarker(center_x, center_y, size, opacity)
    local battery = {
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,1,1,1,1,1,1,1,0},
        {1,1,0,1,1,1,1,0,1,1},
        {1,1,0,1,1,1,1,0,1,1},
        {1,1,0,1,1,1,1,0,1,1},
        {1,1,0,1,1,1,1,0,1,1},
        {1,1,0,0,0,0,0,0,1,1},
        {1,1,1,1,1,1,1,1,1,1},
        {0,1,1,1,1,1,1,1,1,0},
        {0,0,1,1,1,1,1,1,0,0}
    }

    M.draw_pixel_hitmarker(battery, center_x, center_y, size, opacity)
end

function M.draw_trophy_hitmarker(center_x, center_y, size, opacity)
    local trophy = {
        {0,1,1,1,1,1,1,1,1,0},
        {0,1,0,0,0,0,0,0,1,0},
        {0,1,0,0,0,0,0,0,1,0},
        {0,1,0,0,0,0,0,0,1,0},
        {0,0,1,0,0,0,0,1,0,0},
        {0,0,0,1,1,1,1,0,0,0},
        {0,0,0,0,1,1,0,0,0,0},
        {0,0,0,1,1,1,1,0,0,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,1,1,1,1,1,1,1,0}
    }

    M.draw_pixel_hitmarker(trophy, center_x, center_y, size, opacity)
end

function M.draw_flower_hitmarker(center_x, center_y, size, opacity)
    local flower = {
        {0,0,1,0,0,0,0,1,0,0},
        {0,1,0,1,0,0,1,0,1,0},
        {1,0,0,0,1,1,0,0,0,1},
        {0,1,0,1,1,1,1,0,1,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,0,1,1,1,1,1,1,0,0},
        {0,1,0,1,1,1,1,0,1,0},
        {1,0,0,0,1,1,0,0,0,1},
        {0,1,0,1,0,0,1,0,1,0},
        {0,0,1,0,0,0,0,1,0,0}
    }

    M.draw_pixel_hitmarker(flower, center_x, center_y, size, opacity)
end

    function M.draw_pixel_hitmarker(pixel_pattern, center_x, center_y, size, opacity)
        local pixel_size = size / 10  
        local start_x = center_x - (size / 2)
        local start_y = center_y - (size / 2)

        for y = 1, #pixel_pattern do
            for x = 1, #pixel_pattern[y] do
                if pixel_pattern[y][x] == 1 then

                    local is_edge = false
                    for ny = y-1, y+1 do
                        for nx = x-1, x+1 do
                            if ny < 1 or ny > #pixel_pattern or 
                               nx < 1 or nx > #pixel_pattern[1] or 
                               pixel_pattern[ny][nx] == 0 then
                                is_edge = true
                                break
                            end
                        end
                        if is_edge then break end
                    end

                    if is_edge then
                        draw.surface:add_rect_filled(
                            draw.rect(
                                start_x + (x-1) * pixel_size - 1,
                                start_y + (y-1) * pixel_size - 1,
                                start_x + x * pixel_size + 1,
                                start_y + y * pixel_size + 1
                            ),
                            draw.color(0, 0, 0, opacity)
                        )
                    end
                end
            end
        end

        local fill_color = M.heart_hitmarker_color:get_value():get()

        for y = 1, #pixel_pattern do
            for x = 1, #pixel_pattern[y] do
                if pixel_pattern[y][x] == 1 then
                    draw.surface:add_rect_filled(
                        draw.rect(
                            start_x + (x-1) * pixel_size,
                            start_y + (y-1) * pixel_size,
                            start_x + x * pixel_size,
                            start_y + y * pixel_size
                        ),
                        draw.color(
                            fill_color:get_r(),
                            fill_color:get_g(),
                            fill_color:get_b(),
                            opacity
                        )
                    )
                end
            end
        end
    end
    function M.draw_pixel_hitmarker(pixel_pattern, center_x, center_y, size, opacity)
        local pixel_size = size / 10  
        local start_x = center_x - (size / 2)
        local start_y = center_y - (size / 2)

        for y = 1, #pixel_pattern do
            for x = 1, #pixel_pattern[y] do
                if pixel_pattern[y][x] == 1 then

                    local is_edge = false
                    for ny = y-1, y+1 do
                        for nx = x-1, x+1 do
                            if ny < 1 or ny > #pixel_pattern or 
                               nx < 1 or nx > #pixel_pattern[1] or 
                               pixel_pattern[ny][nx] == 0 then
                                is_edge = true
                                break
                            end
                        end
                        if is_edge then break end
                    end

                    if is_edge then
                        draw.surface:add_rect_filled(
                            draw.rect(
                                start_x + (x-1) * pixel_size - 1,
                                start_y + (y-1) * pixel_size - 1,
                                start_x + x * pixel_size + 1,
                                start_y + y * pixel_size + 1
                            ),
                            draw.color(0, 0, 0, opacity)
                        )
                    end
                end
            end
        end

        local fill_color = M.heart_hitmarker_color:get_value():get()

        for y = 1, #pixel_pattern do
            for x = 1, #pixel_pattern[y] do
                if pixel_pattern[y][x] == 1 then
                    draw.surface:add_rect_filled(
                        draw.rect(
                            start_x + (x-1) * pixel_size,
                            start_y + (y-1) * pixel_size,
                            start_x + x * pixel_size,
                            start_y + y * pixel_size
                        ),
                        draw.color(
                            fill_color:get_r(),
                            fill_color:get_g(),
                            fill_color:get_b(),
                            opacity
                        )
                    )
                end
            end
        end
    end
    function M.render_custom_hitmarkers()
        local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
        if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 4) == 0 then
            return
        end

        local current_time = game.global_vars.real_time
        local frame_time = game.global_vars.frame_time

        local selected_shape_raw = M.hitmarker_shape_combo:get_value():get():get_raw()
        if type(selected_shape_raw) ~= "number" then selected_shape_raw = 1 end 

        local selected_shape = 1 
        for i, option in ipairs(hitmarker_shapes) do
            if bit.band(selected_shape_raw, option[2]) ~= 0 then
                selected_shape = option[2]
                break 
            end
        end

        local movement_multiplier = -1  

        for i = #M.dmg.heart_hitmarkers, 1, -1 do
            local hitmarker = M.dmg.heart_hitmarkers[i]
            local age = current_time - hitmarker.time

            hitmarker.velocity = hitmarker.velocity + (150 * frame_time * movement_multiplier)
            hitmarker.y_offset = hitmarker.y_offset + (hitmarker.velocity * frame_time)

            local fade_start = M.dmg.HEART_LIFETIME - M.dmg.HEART_FADE_TIME
            hitmarker.opacity = 1.0
            if age > fade_start then
                hitmarker.opacity = math.max(0, 1.0 - ((age - fade_start) / M.dmg.HEART_FADE_TIME))
            end

            if age > M.dmg.HEART_LIFETIME then
                table.remove(M.dmg.heart_hitmarkers, i)
            else
                local screen_pos = math.world_to_screen(hitmarker.position)
                if screen_pos then

                    if selected_shape == 1 then
                        M.draw_heart_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 2 then
                        M.draw_diamond_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 4 then
                        M.draw_ruby_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 8 then
                        M.draw_star_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 16 then
                        M.draw_cross_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )

                    elseif selected_shape == 32 then
                        M.draw_skull_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 64 then
                        M.draw_arrow_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )

                    elseif selected_shape == 128 then
                        M.draw_classic_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 256 then
                        M.draw_lightning_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 512 then
                        M.draw_smiley_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 1024 then
                        M.draw_question_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    elseif selected_shape == 2048 then
                        M.draw_dollar_hitmarker(
                            screen_pos.x,
                            screen_pos.y + hitmarker.y_offset,
                            M.dmg.HEART_SIZE,
                            math.floor(255 * hitmarker.opacity)
                        )
                    end
                end
            end
        end
    end

    events.present_queue:remove(M.render_custom_hitmarkers)
    events.present_queue:add(M.render_custom_hitmarkers)

    function M.should_render_keys()
        if not game.engine:in_game() then return false end
        local local_player = entities.get_local_pawn()
        if not local_player or not local_player:is_alive() then return false end
        return true
    end

    function M.smooth_velocity(velocities, weight)
        if #velocities < 3 then return velocities[#velocities] or 0 end

        local sum = 0
        local total_weight = 0

        for i = math.max(1, #velocities - 3), #velocities do
            local w = weight ^ (#velocities - i)
            sum = sum + velocities[i] * w
            total_weight = total_weight + w
        end

        return sum / total_weight
    end

    function M.get_rainbow_color()
        local time = game.global_vars.real_time * 0.5
        local hue = time % 1

        local h = hue * 6
        local c = 1
        local x = (1 - math.abs(h % 2 - 1))

        local r, g, b = 0, 0, 0
        if h < 1 then
            r, g, b = c, x, 0
        elseif h < 2 then
            r, g, b = x, c, 0
        elseif h < 3 then
            r, g, b = 0, c, x
        elseif h < 4 then
            r, g, b = 0, x, c
        elseif h < 5 then
            r, g, b = x, 0, c
        else
            r, g, b = c, 0, x
        end

        return draw.color(
            math.floor(r * 255),
            math.floor(g * 255),
            math.floor(b * 255),
            255
        )
    end

    function M.draw_glowing_line(start_pos, end_pos, color, thickness, glow_thickness, glow_alpha)

        local glow_color = draw.color(color:get_r(), color:get_g(), color:get_b(), math.floor(glow_alpha))
        draw.surface:add_line(start_pos, end_pos, glow_color, thickness + glow_thickness)

        draw.surface:add_line(start_pos, end_pos, color, thickness)
    end

    function M.get_player_bottom_pos()
        local local_player = entities.get_local_pawn()
        if not local_player then return nil end
        return local_player:get_abs_origin()
    end

    function M.should_render_trail()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 128) == 0 then 
            M.movement.trail_positions = {} 
            M.movement.trail_colors = {}
            return false 
        end

        if not game.engine:in_game() then 
            M.movement.trail_positions = {}
            M.movement.trail_colors = {}
            return false 
        end

        local local_player = entities.get_local_pawn()
        if not local_player then
            M.movement.trail_positions = {}
            M.movement.trail_colors = {}
            return false
        end

        return true
    end

    function M.update_trail_positions()
        if not M.should_render_trail() then
            M.movement.trail_positions = {}
            M.movement.trail_colors = {} 
            return
        end

        local current_pos = M.get_player_bottom_pos()
        if not current_pos then return end

        table.insert(M.movement.trail_positions, current_pos)

        if M.rainbow_trail:get_value():get() then
            table.insert(M.movement.trail_colors, M.get_rainbow_color())
        else
            table.insert(M.movement.trail_colors, M.trail_color:get_value():get())
        end

        local max_length = M.trail_length:get_value():get()
        while #M.movement.trail_positions > max_length do
            table.remove(M.movement.trail_positions, 1)
            table.remove(M.movement.trail_colors, 1)
        end
    end

    function M.render_trail()
        if not M.should_render_trail() or #M.movement.trail_positions < 2 then return end

        local thickness = M.trail_thickness:get_value():get()
        local glow_size = M.trail_glow_size:get_value():get()
        local glow_intensity = M.trail_glow_intensity:get_value():get()

        for i = 1, #M.movement.trail_positions - 1 do
            local start_pos = M.movement.trail_positions[i]
            local end_pos = M.movement.trail_positions[i + 1]

            local start_screen = math.world_to_screen(start_pos)
            local end_screen = math.world_to_screen(end_pos)

            if start_screen and end_screen then
                local fade_start = 0.3
                local alpha_factor = 1.0
                local pos_factor = i / #M.movement.trail_positions

                if pos_factor < fade_start then
                    alpha_factor = pos_factor / fade_start
                end

                local segment_color = M.movement.trail_colors[i]
                local current_color = draw.color(
                    segment_color:get_r(),
                    segment_color:get_g(),
                    segment_color:get_b(),
                    math.floor(segment_color:get_a() * alpha_factor)
                )

                M.draw_glowing_line(
                    draw.vec2(start_screen.x, start_screen.y),
                    draw.vec2(end_screen.x, end_screen.y),
                    current_color,
                    thickness,
                    glow_size,
                    glow_intensity
                )
            end
        end
    end

    function M.render_kamidere_keys()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 1) == 0 then return end
        if not M.should_render_keys() then return end

        if M.dragging.kamidere_keys then
            local mouse = gui.input:cursor()
            M.elements_pos.kamidere_keys.x = mouse.x - M.drag_offset.kamidere_keys.x
            M.elements_pos.kamidere_keys.y = mouse.y - M.drag_offset.kamidere_keys.y
        end

        local base_x = M.elements_pos.kamidere_keys.x
        local base_y = M.elements_pos.kamidere_keys.y
        local current_time = game.global_vars.real_time

        local kamidere_TOTAL_WIDTH = (M.movement.config.kamidere.line_width * 6) + 
                                     (M.movement.config.kamidere.line_spacing * 4) + 
                                     M.movement.config.kamidere.extra_spacing

        draw.surface:add_rect_filled(
            draw.rect(base_x, base_y - 30, base_x + kamidere_TOTAL_WIDTH, base_y + 10),
            draw.color(0, 0, 0, 0)
        )

        local function kamidere_handle_key(key, x_pos, display_text)
            local key_pressed = gui.input:is_key_down(M.KEYS[key])
            local state = M.movement.kamidere_fade_states[key]

            if key_pressed and not state.active then
                state.active = true
                state.time = current_time
                state.y_offset = 0
            elseif not key_pressed and state.active then
                state.active = false
                state.time = current_time
            end

            local alpha = 255
            if not state.active then
                local time_diff = current_time - state.time
                if time_diff < M.movement.config.kamidere.fade_time then
                    alpha = 255 * (1 - (time_diff / M.movement.config.kamidere.fade_time))
                    state.y_offset = -20 * (time_diff / M.movement.config.kamidere.fade_time)
                else
                    alpha = 0
                    state.y_offset = 0
                end
            end

            draw.surface:add_rect_filled(
                draw.rect(x_pos, base_y, x_pos + M.movement.config.kamidere.line_width, base_y + M.movement.config.kamidere.line_height),
                M.movement.kamidere_line_inactive
            )

            if key_pressed then
                draw.surface:add_rect_filled(
                    draw.rect(x_pos, base_y, x_pos + M.movement.config.kamidere.line_width, base_y + M.movement.config.kamidere.line_height),
                    M.movement.kamidere_active
                )
            end

            if alpha > 0 then
                draw.surface.font = draw.fonts["gui_title"]
                local text_color = draw.color(255, 255, 255, alpha)
                local text_x = x_pos + (M.movement.config.kamidere.line_width / 2) - 8
                local text_y = base_y - 25 + state.y_offset
                draw.surface:add_text(
                    draw.vec2(text_x, text_y),
                    display_text or key,
                    text_color
                )
            end
        end

        local x = base_x
        kamidere_handle_key("W", x)
        x = x + M.movement.config.kamidere.line_width + M.movement.config.kamidere.line_spacing
        kamidere_handle_key("A", x)
        x = x + M.movement.config.kamidere.line_width + M.movement.config.kamidere.line_spacing
        kamidere_handle_key("S", x)
        x = x + M.movement.config.kamidere.line_width + M.movement.config.kamidere.line_spacing
        kamidere_handle_key("D", x)
        x = x + M.movement.config.kamidere.line_width + M.movement.config.kamidere.extra_spacing
        kamidere_handle_key("J", x, "J")
        x = x + M.movement.config.kamidere.line_width + M.movement.config.kamidere.line_spacing
        kamidere_handle_key("C", x, "C")
    end

    function M.render_clarity_keys()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 2) == 0 then return end
        if not M.should_render_keys() then return end

        if M.dragging.clarity_keys then
            local mouse = gui.input:cursor()
            M.elements_pos.clarity_keys.x = mouse.x - M.drag_offset.clarity_keys.x
            M.elements_pos.clarity_keys.y = mouse.y - M.drag_offset.clarity_keys.y
        end

        local base_x = M.elements_pos.clarity_keys.x
        local base_y = M.elements_pos.clarity_keys.y

        local panel_width = (M.movement.config.clarity.line_width * 3) + (M.movement.config.clarity.line_spacing * 2) + 20
        local panel_height = 45

        draw.surface:add_rect_filled(
            draw.rect(base_x - 10, base_y - 20, base_x + panel_width, base_y + panel_height),
            draw.color(0, 0, 0, 0)
        )

        local function clarity_handle_key(key, x_pos, y_pos)
            draw.surface:add_rect_filled(
                draw.rect(x_pos, y_pos, x_pos + M.movement.config.clarity.line_width, y_pos + M.movement.config.clarity.line_height),
                M.movement.clarity_line_inactive
            )

            if gui.input:is_key_down(M.KEYS[key]) then
                draw.surface:add_rect_filled(
                    draw.rect(x_pos, y_pos, x_pos + M.movement.config.clarity.line_width, y_pos + M.movement.config.clarity.line_height),
                    M.movement.clarity_active
                )

                draw.surface.font = draw.fonts["gui_main"]
                draw.surface:add_text(
                    draw.vec2(x_pos + (M.movement.config.clarity.line_width / 2) - 4, y_pos - 15),
                    key,
                    M.movement.clarity_active
                )
            end
        end

        local x = base_x
        for _, key in ipairs({"C", "W", "J"}) do
            clarity_handle_key(key, x, base_y)
            x = x + M.movement.config.clarity.line_width + M.movement.config.clarity.line_spacing
        end

        x = base_x
        for _, key in ipairs({"A", "S", "D"}) do
            clarity_handle_key(key, x, base_y + 20)
            x = x + M.movement.config.clarity.line_width + M.movement.config.clarity.line_spacing
        end
    end

    function M.render_kz_keys()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 4) == 0 then return end
        if not M.should_render_keys() then return end

        if M.dragging.kz_keys then
            local mouse = gui.input:cursor()
            M.elements_pos.kz_keys.x = mouse.x - M.drag_offset.kz_keys.x
            M.elements_pos.kz_keys.y = mouse.y - M.drag_offset.kz_keys.y
        end

        local panel_width = 400
        local panel_height = 80
        local panel_x = M.elements_pos.kz_keys.x
        local panel_y = M.elements_pos.kz_keys.y

        local local_player = entities.get_local_pawn()
        if not local_player then return end
        local current_pos = local_player:get_abs_origin()
        local velocity = 0
        local is_jumping = false
        local current_time = game.global_vars.real_time

        if M.movement.keys.kz.last_pos then
            local delta_x = current_pos.x - M.movement.keys.kz.last_pos.x
            local delta_y = current_pos.y - M.movement.keys.kz.last_pos.y
            velocity = math.sqrt(delta_x * delta_x + delta_y * delta_y)
            velocity = velocity / game.global_vars.frame_time
            local flags = local_player.m_fFlags:get()
            is_jumping = bit.band(flags, 1) == 0

            if is_jumping then
                if not M.movement.keys.kz.was_jumping then
                    M.movement.keys.kz.takeoff_velocity = velocity
                    M.movement.keys.kz.should_show_takeoff = true
                end
                M.movement.keys.kz.landing_time = current_time
            elseif M.movement.keys.kz.was_jumping then
                M.movement.keys.kz.landing_time = current_time
            elseif current_time - M.movement.keys.kz.landing_time > M.movement.keys.kz.display_duration then
                M.movement.keys.kz.should_show_takeoff = false
            end
            M.movement.keys.kz.was_jumping = is_jumping
        end
        M.movement.keys.kz.last_pos = current_pos
        velocity = math.floor(velocity + 0.5)
        M.movement.keys.kz.takeoff_velocity = math.floor(M.movement.keys.kz.takeoff_velocity + 0.5)

        draw.surface:add_rect_filled(
            draw.rect(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height),
            draw.color(20, 20, 20, 180)
        )

        local accent_color = M.accent_picker:get_value():get()
        draw.surface:add_rect_filled(
            draw.rect(panel_x - 2, panel_y, panel_x, panel_y + panel_height),
            accent_color
        )
        draw.surface:add_rect_filled(
            draw.rect(panel_x + panel_width, panel_y, panel_x + panel_width + 2, panel_y + panel_height),
            accent_color
        )

        draw.surface.font = draw.fonts["gui_title"]
        local velocity_text = "Speed: " .. tostring(velocity)
        if M.movement.keys.kz.should_show_takeoff then
            velocity_text = velocity_text .. " (" .. tostring(M.movement.keys.kz.takeoff_velocity) .. ")"
        end
        local text_width = draw.surface.font:get_text_size(velocity_text).x
        draw.surface:add_text(
            draw.vec2(panel_x + (panel_width / 2) - (text_width / 2), panel_y + 15),
            velocity_text,
            draw.color(255, 255, 255)
        )

        draw.surface:add_text(
            draw.vec2(panel_x + (panel_width / 2) - 75, panel_y + 45),
            "Keys: ",
            draw.color(255, 255, 255)
        )

        local LINE_WIDTH = 15
        local LINE_HEIGHT = 2
        local LINE_SPACING = 5
        local key_start_x = panel_x + (panel_width / 2) - 15
        local keys_y = panel_y + 45

        local keys = {"A", "W", "S", "D", "C", "J"}
        for i, key in ipairs(keys) do
            local is_pressed = gui.input:is_key_down(M.KEYS[key])
            local x_pos = key_start_x + ((i - 1) * (LINE_WIDTH + LINE_SPACING))

            if not is_pressed then
                draw.surface:add_rect_filled(
                    draw.rect(x_pos, keys_y + 15, x_pos + LINE_WIDTH, keys_y + 15 + LINE_HEIGHT),
                    draw.color(255, 255, 255, 100)
                )
            end

            if is_pressed then
                local letter_width = draw.surface.font:get_text_size(key).x
                draw.surface:add_text(
                    draw.vec2(x_pos + (LINE_WIDTH / 2) - letter_width / 2, keys_y - 2),
                    key,
                    draw.color(255, 255, 255)
                )
            end
        end
    end
    function M.render_velocity_graph()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 8) == 0 then 

            M.movement.velocity.graph.velocity_points = {}
            M.movement.velocity.graph.raw_velocities = {}
            M.movement.velocity.graph.last_pos = nil
            M.movement.velocity.graph.current_smoothed_velocity = 0
            return
        end

        local local_player = entities.get_local_pawn()
        if not local_player then return end

        if M.dragging.velocity_graph then
            local mouse = gui.input:cursor()
            M.elements_pos.velocity_graph.x = mouse.x - M.drag_offset.velocity_graph.x
            M.elements_pos.velocity_graph.y = mouse.y - M.drag_offset.velocity_graph.y
        end

        local GRAPH_X = M.elements_pos.velocity_graph.x
        local GRAPH_Y = M.elements_pos.velocity_graph.y

        draw.surface:add_rect_filled(
            draw.rect(GRAPH_X, GRAPH_Y, GRAPH_X + M.movement.config.graph.width, GRAPH_Y + M.movement.config.graph.height),
            draw.color(0, 0, 0, 0)
        )

        local current_pos = local_player:get_abs_origin()
        if not current_pos then return end

        local current_time = game.global_vars.cur_time
        if current_time - M.movement.velocity.graph.last_sample_time < M.movement.velocity.graph.SAMPLE_RATE then
            return
        end
        M.movement.velocity.graph.last_sample_time = current_time

        local raw_velocity = 0

        if M.movement.velocity.graph.last_pos then
            local delta_x = current_pos.x - M.movement.velocity.graph.last_pos.x
            local delta_y = current_pos.y - M.movement.velocity.graph.last_pos.y
            raw_velocity = math.sqrt(delta_x * delta_x + delta_y * delta_y)
            raw_velocity = raw_velocity / game.global_vars.frame_time

            table.insert(M.movement.velocity.graph.raw_velocities, raw_velocity)
            if #M.movement.velocity.graph.raw_velocities > 5 then
                table.remove(M.movement.velocity.graph.raw_velocities, 1)
            end

            local target_velocity = M.smooth_velocity(M.movement.velocity.graph.raw_velocities, 0.7)

            if target_velocity > M.movement.velocity.graph.current_smoothed_velocity then
                M.movement.velocity.graph.current_smoothed_velocity = M.movement.velocity.graph.current_smoothed_velocity + 
                    (target_velocity - M.movement.velocity.graph.current_smoothed_velocity) * M.movement.config.rendering.velocity_climb_rate
            else
                M.movement.velocity.graph.current_smoothed_velocity = M.movement.velocity.graph.current_smoothed_velocity + 
                    (target_velocity - M.movement.velocity.graph.current_smoothed_velocity) * M.movement.config.rendering.velocity_fall_rate
            end
        end

        M.movement.velocity.graph.last_pos = current_pos

        table.insert(M.movement.velocity.graph.velocity_points, M.movement.velocity.graph.current_smoothed_velocity)
        if #M.movement.velocity.graph.velocity_points > M.movement.config.rendering.max_velocity_points then
            table.remove(M.movement.velocity.graph.velocity_points, 1)
        end

        for i = 2, #M.movement.velocity.graph.velocity_points do
            local x1 = GRAPH_X + M.movement.config.rendering.velocity.padding + 
                ((i-2) * ((M.movement.config.graph.width - M.movement.config.rendering.velocity.padding * 2) / M.movement.config.rendering.max_velocity_points))
            local x2 = GRAPH_X + M.movement.config.rendering.velocity.padding + 
                ((i-1) * ((M.movement.config.graph.width - M.movement.config.rendering.velocity.padding * 2) / M.movement.config.rendering.max_velocity_points))

            local y1 = GRAPH_Y + M.movement.config.graph.height - M.movement.config.rendering.velocity.padding - 
                (math.min(M.movement.velocity.graph.velocity_points[i-1], M.movement.config.rendering.max_velocity_points) / 
                M.movement.config.rendering.max_velocity_points * (M.movement.config.graph.height - M.movement.config.rendering.velocity.padding * 2))
            local y2 = GRAPH_Y + M.movement.config.graph.height - M.movement.config.rendering.velocity.padding - 
                (math.min(M.movement.velocity.graph.velocity_points[i], M.movement.config.rendering.max_velocity_points) / 
                M.movement.config.rendering.max_velocity_points * (M.movement.config.graph.height - M.movement.config.rendering.velocity.padding * 2))

            draw.surface:add_line(
                draw.vec2(x1, y1),
                draw.vec2(x2, y2),
                draw.color(255, 255, 255, 255)
            )
        end
    end

    function M.render_velocity_graphv2()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 16) == 0 then

            M.movement.velocity.graphv2.velocity_points = {}
            M.movement.velocity.graphv2.raw_velocities = {}
            M.movement.velocity.graphv2.last_pos = nil
            M.movement.velocity.graphv2.current_smoothed_velocity = 0
            return
        end

        local local_player = entities.get_local_pawn()
        if not local_player then return end

        if M.dragging.velocity_graphv2 then
            local mouse = gui.input:cursor()
            M.elements_pos.velocity_graphv2.x = mouse.x - M.drag_offset.velocity_graphv2.x
            M.elements_pos.velocity_graphv2.y = mouse.y - M.drag_offset.velocity_graphv2.y
        end

        local GRAPH_X = M.elements_pos.velocity_graphv2.x
        local GRAPH_Y = M.elements_pos.velocity_graphv2.y

        draw.surface:add_rect_filled(
            draw.rect(GRAPH_X, GRAPH_Y, GRAPH_X + M.movement.config.graph.width, GRAPH_Y + M.movement.config.graph.height),
            draw.color(0, 0, 0, 50)  
        )

        draw.surface:add_rect_filled(
            draw.rect(
                GRAPH_X, 
                GRAPH_Y, 
                GRAPH_X + 2, 
                GRAPH_Y + M.movement.config.graph.height
            ),
            draw.color(255, 255, 255, 255)  
        )

        draw.surface:add_rect_filled(
            draw.rect(
                GRAPH_X, 
                GRAPH_Y + M.movement.config.graph.height - 2,
                GRAPH_X + M.movement.config.graph.width,
                GRAPH_Y + M.movement.config.graph.height
            ),
            draw.color(255, 255, 255, 255)  
        )

        local line_interval = 100  
        draw.surface.font = draw.fonts["gui_debug"]

        for i = 0, M.movement.velocity.graphv2.MAX_VELOCITY, line_interval do

            local y = GRAPH_Y + M.movement.config.graph.height - M.movement.config.rendering.velocity.padding - 
                (i / M.movement.velocity.graphv2.MAX_VELOCITY * (M.movement.config.graph.height - M.movement.config.rendering.velocity.padding * 2))

            draw.surface:add_rect_filled(
                draw.rect(
                    GRAPH_X + 2,  
                    y,
                    GRAPH_X + M.movement.config.graph.width,
                    y + 1
                ),
                draw.color(255, 255, 255, 20)  
            )

            local text = tostring(i)
            local text_width = draw.surface.font:get_text_size(text).x
            draw.surface:add_text(
                draw.vec2(GRAPH_X - text_width - 5, y - 6),  
                text,
                draw.color(255, 255, 255, 150)  
            )
        end

        local current_pos = local_player:get_abs_origin()
        if not current_pos then return end

        local current_time = game.global_vars.cur_time
        local should_sample = current_time - M.movement.velocity.graphv2.last_sample_time >= M.movement.velocity.graphv2.SAMPLE_RATE

        if should_sample and M.movement.velocity.graphv2.last_pos then
            local delta_x = current_pos.x - M.movement.velocity.graphv2.last_pos.x
            local delta_y = current_pos.y - M.movement.velocity.graphv2.last_pos.y
            local raw_velocity = math.sqrt(delta_x * delta_x + delta_y * delta_y)
            raw_velocity = raw_velocity / game.global_vars.frame_time

            table.insert(M.movement.velocity.graphv2.raw_velocities, raw_velocity)
            if #M.movement.velocity.graphv2.raw_velocities > 5 then
                table.remove(M.movement.velocity.graphv2.raw_velocities, 1)
            end

            local target_velocity = M.smooth_velocity(M.movement.velocity.graphv2.raw_velocities, 0.7)

            if target_velocity > M.movement.velocity.graphv2.current_smoothed_velocity then
                M.movement.velocity.graphv2.current_smoothed_velocity = M.movement.velocity.graphv2.current_smoothed_velocity + 
                    (target_velocity - M.movement.velocity.graphv2.current_smoothed_velocity) * M.movement.velocity.graphv2.CLIMB_RATE
            else
                M.movement.velocity.graphv2.current_smoothed_velocity = M.movement.velocity.graphv2.current_smoothed_velocity + 
                    (target_velocity - M.movement.velocity.graphv2.current_smoothed_velocity) * M.movement.velocity.graphv2.FALL_RATE
            end

            table.insert(M.movement.velocity.graphv2.velocity_points, M.movement.velocity.graphv2.current_smoothed_velocity)
            if #M.movement.velocity.graphv2.velocity_points > M.movement.velocity.graphv2.MAX_POINTS then
                table.remove(M.movement.velocity.graphv2.velocity_points, 1)
            end

            M.movement.velocity.graphv2.last_sample_time = current_time
        end

        M.movement.velocity.graphv2.last_pos = current_pos

        if #M.movement.velocity.graphv2.velocity_points >= 2 then
            for i = 2, #M.movement.velocity.graphv2.velocity_points do
                local x1 = GRAPH_X + M.movement.config.rendering.velocity.padding + 
                    ((i-2) * ((M.movement.config.graph.width - M.movement.config.rendering.velocity.padding * 2) / M.movement.velocity.graphv2.MAX_POINTS))
                local x2 = GRAPH_X + M.movement.config.rendering.velocity.padding + 
                    ((i-1) * ((M.movement.config.graph.width - M.movement.config.rendering.velocity.padding * 2) / M.movement.velocity.graphv2.MAX_POINTS))

                local y1 = GRAPH_Y + M.movement.config.graph.height - M.movement.config.rendering.velocity.padding - 
                    (math.min(M.movement.velocity.graphv2.velocity_points[i-1], M.movement.velocity.graphv2.MAX_VELOCITY) / 
                    M.movement.velocity.graphv2.MAX_VELOCITY * (M.movement.config.graph.height - M.movement.config.rendering.velocity.padding * 2))
                local y2 = GRAPH_Y + M.movement.config.graph.height - M.movement.config.rendering.velocity.padding - 
                    (math.min(M.movement.velocity.graphv2.velocity_points[i], M.movement.velocity.graphv2.MAX_VELOCITY) / 
                    M.movement.velocity.graphv2.MAX_VELOCITY * (M.movement.config.graph.height - M.movement.config.rendering.velocity.padding * 2))

                local line_color = M.velocity_line_color:get_value():get()

                draw.surface:add_line(
                    draw.vec2(x1, y1),
                    draw.vec2(x2, y2),
                    line_color
                )
            end
        end
    end

    function M.render_velocity_indicator()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        if type(movement_value) ~= "number" or bit.band(movement_value, 32) == 0 then return end

        if M.dragging.velocity_indicator then
            local mouse = gui.input:cursor()
            M.elements_pos.velocity_indicator.x = mouse.x - M.drag_offset.velocity_indicator.x
            M.elements_pos.velocity_indicator.y = mouse.y - M.drag_offset.velocity_indicator.y
        end

        local local_player = entities.get_local_pawn()
        if not local_player then return end

        local current_pos = local_player:get_abs_origin()
        if not current_pos then return end

        local velocity = 0
        local is_jumping = false
        local current_time = game.global_vars.real_time

        if M.movement.velocity.last_pos then

            local delta_x = current_pos.x - M.movement.velocity.last_pos.x
            local delta_y = current_pos.y - M.movement.velocity.last_pos.y
            velocity = math.sqrt(delta_x * delta_x + delta_y * delta_y)
            velocity = velocity / game.global_vars.frame_time

            local flags = local_player.m_fFlags:get()
            is_jumping = bit.band(flags, 1) == 0

            if is_jumping then
                if not M.movement.velocity.was_jumping then 
                    M.movement.velocity.takeoff_velocity = velocity
                    M.movement.velocity.should_show_takeoff = true
                end
                M.movement.velocity.landing_time = current_time 
            elseif M.movement.velocity.was_jumping then 
                M.movement.velocity.landing_time = current_time
            elseif current_time - M.movement.velocity.landing_time > M.movement.velocity.display_duration then
                M.movement.velocity.should_show_takeoff = false 
            end

            M.movement.velocity.was_jumping = is_jumping
        end

        M.movement.velocity.last_pos = current_pos

        velocity = math.floor(velocity + 0.5)
        M.movement.velocity.takeoff_velocity = math.floor(M.movement.velocity.takeoff_velocity + 0.5)

        local x = M.elements_pos.velocity_indicator.x
        local y = M.elements_pos.velocity_indicator.y

        local text
        if velocity < 1 then
            text = "0"
        elseif (is_jumping or M.movement.velocity.should_show_takeoff) and M.movement.velocity.takeoff_velocity > 0 then

            text = string.format("%d (%d)", velocity, M.movement.velocity.takeoff_velocity)
        else
            text = tostring(velocity)
        end

        draw.surface.font = draw.fonts["gui_title"]
        local text_size = draw.surface.font:get_text_size(text)
        draw.surface:add_text(
            draw.vec2(x - text_size.x / 2, y), 
            text, 
            draw.color(255, 255, 255, 255)
        )
    end

function M.render_velocity_bar()
    local movement_value = M.movement_combo:get_value():get():get_raw()
    if type(movement_value) ~= "number" or bit.band(movement_value, 64) == 0 then return end

    if M.dragging.velocity_bar then
        local mouse = gui.input:cursor()
        M.elements_pos.velocity_bar.x = mouse.x - M.drag_offset.velocity_bar.x
        M.elements_pos.velocity_bar.y = mouse.y - M.drag_offset.velocity_bar.y
    end

    local local_player = entities.get_local_pawn()
    if not local_player then 
        M.movement.velocity.velocity_bar.velocity_bar_last_pos = nil
        return 
    end

    local current_pos = local_player:get_abs_origin()
    if not current_pos then 
        M.movement.velocity.velocity_bar.velocity_bar_last_pos = nil
        return 
    end

    if M.movement.velocity.velocity_bar.velocity_bar_last_pos then
        local delta_x = current_pos.x - M.movement.velocity.velocity_bar.velocity_bar_last_pos.x
        local delta_y = current_pos.y - M.movement.velocity.velocity_bar.velocity_bar_last_pos.y
        local raw_velocity = math.sqrt(delta_x * delta_x + delta_y * delta_y)
        M.movement.velocity.velocity_bar.velocity_bar_curr_velocity = raw_velocity / game.global_vars.frame_time
    end
    M.movement.velocity.velocity_bar.velocity_bar_last_pos = current_pos

    local velocity = math.floor(M.movement.velocity.velocity_bar.velocity_bar_curr_velocity + 0.5)

    local bar_width = 200
    local bar_height = 25

    local x = M.elements_pos.velocity_bar.x
    local y = M.elements_pos.velocity_bar.y

    draw.surface:add_rect_filled(
        draw.rect(x, y, x + bar_width, y + bar_height),
        draw.color(0, 0, 0, 150)
    )

    local fill_width = math.min(velocity / 250 * bar_width, bar_width)

    local accent_color = M.accent_picker:get_value():get()
    draw.surface:add_rect_filled(
        draw.rect(x, y, x + fill_width, y + bar_height),
        accent_color
    )

    draw.surface.font = draw.fonts["gui_title"]
    local text = tostring(velocity) .. " u/s"
    local text_size = draw.surface.font:get_text_size(text)
    draw.surface:add_text(
        draw.vec2(x + (bar_width / 2) - (text_size.x / 2), y + (bar_height / 2) - (text_size.y / 2)),
        text,
        draw.color(255, 255, 255)
    )
end

local original_handle_input = M.handle_input
M.handle_input = function(msg, wparam, lparam)

    original_handle_input(msg, wparam, lparam)

    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local movement_value = M.movement_combo:get_value():get():get_raw()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 2) ~= 0 then

            local enemies_count = 0
            for _, _ in pairs(M.tracked_enemies or {}) do
                enemies_count = enemies_count + 1
            end

            local total_width = 220
            local title_height = 30
            local padding_y = 8
            local item_height = 28
            local item_spacing = 4
            local box_height = title_height + (enemies_count * (item_height + item_spacing)) + padding_y * 2

            if box_height < 60 then box_height = 60 end

            local enemy_list_box = {
                x = M.elements_pos.enemy_list.x,
                y = M.elements_pos.enemy_list.y,
                width = total_width,
                height = box_height
            }

            if mouse.x >= enemy_list_box.x and mouse.x <= enemy_list_box.x + enemy_list_box.width and
               mouse.y >= enemy_list_box.y and mouse.y <= enemy_list_box.y + enemy_list_box.height then
                M.dragging.enemy_list = true
                M.drag_offset.enemy_list.x = mouse.x - M.elements_pos.enemy_list.x
                M.drag_offset.enemy_list.y = mouse.y - M.elements_pos.enemy_list.y
            end

    elseif msg == 0x0202 then 
        M.dragging.enemy_list = false
    end

        if type(movement_value) == "number" and bit.band(movement_value, 1) ~= 0 then
            local kamidere_TOTAL_WIDTH = (M.movement.config.kamidere.line_width * 6) + 
                                        (M.movement.config.kamidere.line_spacing * 4) + 
                                        M.movement.config.kamidere.extra_spacing
            local kamidere_box = {
                x = M.elements_pos.kamidere_keys.x,
                y = M.elements_pos.kamidere_keys.y - 30,
                width = kamidere_TOTAL_WIDTH,
                height = 40
            }

            if mouse.x >= kamidere_box.x and mouse.x <= kamidere_box.x + kamidere_box.width and
               mouse.y >= kamidere_box.y and mouse.y <= kamidere_box.y + kamidere_box.height then
                M.dragging.kamidere_keys = true
                M.drag_offset.kamidere_keys.x = mouse.x - M.elements_pos.kamidere_keys.x
                M.drag_offset.kamidere_keys.y = mouse.y - M.elements_pos.kamidere_keys.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 2) ~= 0 then
            local panel_width = (M.movement.config.clarity.line_width * 3) + (M.movement.config.clarity.line_spacing * 2) + 20
            local clarity_box = {
                x = M.elements_pos.clarity_keys.x - 10,
                y = M.elements_pos.clarity_keys.y - 20,
                width = panel_width,
                height = 45
            }

            if mouse.x >= clarity_box.x and mouse.x <= clarity_box.x + clarity_box.width and
               mouse.y >= clarity_box.y and mouse.y <= clarity_box.y + clarity_box.height then
                M.dragging.clarity_keys = true
                M.drag_offset.clarity_keys.x = mouse.x - M.elements_pos.clarity_keys.x
                M.drag_offset.clarity_keys.y = mouse.y - M.elements_pos.clarity_keys.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 4) ~= 0 then
            local kz_box = {
                x = M.elements_pos.kz_keys.x,
                y = M.elements_pos.kz_keys.y,
                width = 400,
                height = 80
            }

            if mouse.x >= kz_box.x and mouse.x <= kz_box.x + kz_box.width and
               mouse.y >= kz_box.y and mouse.y <= kz_box.y + kz_box.height then
                M.dragging.kz_keys = true
                M.drag_offset.kz_keys.x = mouse.x - M.elements_pos.kz_keys.x
                M.drag_offset.kz_keys.y = mouse.y - M.elements_pos.kz_keys.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 8) ~= 0 then
            local velocity_graph_box = {
                x = M.elements_pos.velocity_graph.x,
                y = M.elements_pos.velocity_graph.y,
                width = M.movement.config.graph.width,
                height = M.movement.config.graph.height
            }

            if mouse.x >= velocity_graph_box.x and mouse.x <= velocity_graph_box.x + velocity_graph_box.width and
               mouse.y >= velocity_graph_box.y and mouse.y <= velocity_graph_box.y + velocity_graph_box.height then
                M.dragging.velocity_graph = true
                M.drag_offset.velocity_graph.x = mouse.x - M.elements_pos.velocity_graph.x
                M.drag_offset.velocity_graph.y = mouse.y - M.elements_pos.velocity_graph.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 16) ~= 0 then
            local velocity_graphv2_box = {
                x = M.elements_pos.velocity_graphv2.x,
                y = M.elements_pos.velocity_graphv2.y,
                width = M.movement.config.graph.width,
                height = M.movement.config.graph.height
            }

            if mouse.x >= velocity_graphv2_box.x and mouse.x <= velocity_graphv2_box.x + velocity_graphv2_box.width and
               mouse.y >= velocity_graphv2_box.y and mouse.y <= velocity_graphv2_box.y + velocity_graphv2_box.height then
                M.dragging.velocity_graphv2 = true
                M.drag_offset.velocity_graphv2.x = mouse.x - M.elements_pos.velocity_graphv2.x
                M.drag_offset.velocity_graphv2.y = mouse.y - M.elements_pos.velocity_graphv2.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 32) ~= 0 then
            local velocity_indicator_box = {
                x = M.elements_pos.velocity_indicator.x - 50,
                y = M.elements_pos.velocity_indicator.y - 10,
                width = 100,
                height = 30
            }

            if mouse.x >= velocity_indicator_box.x and mouse.x <= velocity_indicator_box.x + velocity_indicator_box.width and
               mouse.y >= velocity_indicator_box.y and mouse.y <= velocity_indicator_box.y + velocity_indicator_box.height then
                M.dragging.velocity_indicator = true
                M.drag_offset.velocity_indicator.x = mouse.x - M.elements_pos.velocity_indicator.x
                M.drag_offset.velocity_indicator.y = mouse.y - M.elements_pos.velocity_indicator.y
            end
        end

        if type(movement_value) == "number" and bit.band(movement_value, 64) ~= 0 then
            local velocity_bar_box = {
                x = M.elements_pos.velocity_bar.x,
                y = M.elements_pos.velocity_bar.y,
                width = 200,
                height = 25
            }

            if mouse.x >= velocity_bar_box.x and mouse.x <= velocity_bar_box.x + velocity_bar_box.width and
               mouse.y >= velocity_bar_box.y and mouse.y <= velocity_bar_box.y + velocity_bar_box.height then
                M.dragging.velocity_bar = true
                M.drag_offset.velocity_bar.x = mouse.x - M.elements_pos.velocity_bar.x
                M.drag_offset.velocity_bar.y = mouse.y - M.elements_pos.velocity_bar.y
            end
        end
    elseif msg == 0x0202 then 

        M.dragging.kamidere_keys = false
        M.dragging.clarity_keys = false
        M.dragging.kz_keys = false
        M.dragging.velocity_graph = false
        M.dragging.velocity_graphv2 = false
        M.dragging.velocity_indicator = false
        M.dragging.velocity_bar = false
    end

end
events.input:remove(original_handle_input)
events.input:add(M.handle_input)

    function M.get_feature_state(context)
        if not context then return nil end

        local value = context:get_value()
        if not value then return nil end

        local is_on = value:get()
        if not is_on then

            M.context_states[context.id_string] = nil
            return nil 
        end

        local hotkey_active = value:get_hotkey_state()

        if not hotkey_active then
            return "Active", draw.color(255, 255, 255, 255)
        else

            return "Toggled", M.accent_picker:get_value():get()
        end

    end

function M.render_keybinds_list()
    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 1) == 0 then return end

    if M.dragging.keybinds then
        local mouse = gui.input:cursor()
        M.elements_pos.keybinds.x = mouse.x - M.drag_offset.keybinds.x
        M.elements_pos.keybinds.y = mouse.y - M.drag_offset.keybinds.y
    end

    local adjusted_x = M.elements_pos.keybinds.x
    local adjusted_y = M.elements_pos.keybinds.y

    local selected_keybinds_value = M.keybinds_list_combo:get_value():get():get_raw()
    if type(selected_keybinds_value) ~= "number" or selected_keybinds_value == 0 then
        return 
    end

    local keybind_map = {
        {name = "Delay Shot", context = "rage>aimbot>general>delay shot", bit = 1},
        {name = "Baim", context = "rage>aimbot>general>force bodyaim", bit = 2},
        {name = "Force Shot", context = "rage>aimbot>general>force shoot", bit = 4},
        {name = "Force Head", context = "rage>aimbot>general>headshot only", bit = 8},
        {name = "No Spread", context = "rage>aimbot>general>nospread", bit = 16},
        {name = "Legit Aimbot", context = "legit>weapon>general>aim>aim assist", bit = 32},
        {name = "Legit Silent Aim", context = "legit>weapon>general>aim>silent aim", bit = 64},
        {name = "Recoil Control", context = "legit>weapon>general>rcs>recoil control", bit = 128},
        {name = "Triggerbot", context = "legit>weapon>general>trigger>triggerbot", bit = 256},
        {name = "BunnyHop", context = "misc>movement>bhop", bit = 512},
        {name = "JumpBug", context = "misc>movement>jumpbug", bit = 1024},
        {name = "Edgejump", context = "misc>movement>edge jump", bit = 2048},
        {name = "Hide Shots", context = "rage>anti-aim>angles>hide shot", bit = 4096},
        {name = "Double Tap", context = "rage>aimbot>general>doubletap", bit = 8192}
    }

    local active_features = {}
    for _, keybind in ipairs(keybind_map) do

        if bit.band(selected_keybinds_value, keybind.bit) ~= 0 then
            local context = gui.ctx:find(keybind.context)
            if context then
                local state, color = M.get_feature_state(context)
                if state then
                    table.insert(active_features, {
                        name = keybind.name,
                        state = state,
                        color = color
                    })
                end
            end
        end
    end

    if #active_features == 0 then
        return
    end

    local max_name_width = 0
    for _, feature in ipairs(active_features) do
        draw.surface.font = draw.fonts["gui_main"]
        local name_width = draw.surface.font:get_text_size(feature.name).x
        max_name_width = math.max(max_name_width, name_width)
    end

    local box_width = math.min(200, math.max(160, max_name_width + 70)) 
    local item_spacing = 22 
    local item_height = 16  
    local padding = 10  
    local title_height = 25 
    local corner_radius = 6 

    local box_height = title_height + (#active_features * item_spacing) + padding

    local accent_color = M.accent_picker:get_value():get()

    local glow_size = 6
    for i = glow_size, 1, -1 do
        local alpha = 10 * (1 - (i / glow_size))
        draw.surface:add_rect_filled_rounded(
            draw.rect(
                adjusted_x - i - 10, 
                adjusted_y - i - 8, 
                adjusted_x + box_width + i + 10, 
                adjusted_y + box_height + i + 2 
            ),
            draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                math.floor(alpha)
            ),
            corner_radius + i,
            draw.rounding.all
        )
    end

    draw.surface:add_rect_filled_rounded(
        draw.rect(
            adjusted_x - 10, 
            adjusted_y - 8, 
            adjusted_x + box_width + 10, 
            adjusted_y + box_height + 2 
        ),
        draw.color(0, 0, 0, 175), 
        corner_radius,
        draw.rounding.all
    )

    draw.surface.font = draw.fonts["gui_semi_bold"]
    local title_text = "KEYBINDS"
    local title_width = draw.surface.font:get_text_size(title_text).x
    local title_x = adjusted_x + (box_width / 2) - (title_width / 2)
    local title_y = adjusted_y + 3
    draw.surface:add_text(draw.vec2(title_x, title_y), title_text, M.colors.white)

    local line_width = box_width * 0.6
    local line_x_start = adjusted_x + (box_width - line_width) / 2
    local line_y = title_y + 18

    draw.surface:add_rect_filled_rounded(
        draw.rect(line_x_start, line_y, line_x_start + line_width, line_y + 2),
        accent_color,
        1,
        draw.rounding.all
    )

    local y_position = line_y + 15 

    draw.surface.font = draw.fonts["gui_main"]
    for _, feature in ipairs(active_features) do

        draw.surface:add_text(draw.vec2(adjusted_x + 5, y_position), feature.name, M.colors.white)

        local state_text = feature.state
        local state_text_width = draw.surface.font:get_text_size(state_text).x
        local state_box_width = state_text_width + 10
        local state_box_x = adjusted_x + box_width - state_box_width - 10 
        local state_box_y = y_position
        local state_box_height = 14

        local box_color
        if feature.state == "Active" then
            box_color = draw.color(0, 255, 0, 140) 
        else 
            box_color = draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                140 
            )
        end

        draw.surface:add_rect_filled_rounded(
            draw.rect(
                state_box_x, 
                state_box_y, 
                state_box_x + state_box_width, 
                state_box_y + state_box_height
            ),
            box_color,
            3, 
            draw.rounding.all
        )

        draw.surface.font = draw.fonts["gui_debug"] 
        draw.surface:add_text(
            draw.vec2(
                state_box_x + (state_box_width - draw.surface.font:get_text_size(state_text).x) / 2, 
                state_box_y + 1
            ), 
            state_text, 
            draw.color(192,192,192, 255) 
        )

        draw.surface.font = draw.fonts["gui_main"]

        y_position = y_position + item_spacing
    end
end

function M.handle_keybinds_input(msg, wparam, lparam)

    if M.original_input_handler then
        M.original_input_handler(msg, wparam, lparam)
    end

    if msg == 0x0201 then 
        local mouse = gui.input:cursor()

        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 1) ~= 0 then
            local box_width = 160
            local keybinds_box = {
                x = M.elements_pos.keybinds.x - 10,
                y = M.elements_pos.keybinds.y - 7,
                width = box_width + 20,
                height = 100 
            }

            if mouse.x >= keybinds_box.x and mouse.x <= keybinds_box.x + keybinds_box.width and
               mouse.y >= keybinds_box.y and mouse.y <= keybinds_box.y + keybinds_box.height then
                M.dragging.keybinds = true
                M.drag_offset.keybinds.x = mouse.x - M.elements_pos.keybinds.x
                M.drag_offset.keybinds.y = mouse.y - M.elements_pos.keybinds.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.keybinds = false
    end
end

function M.render_rainbow_line()

    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 4) == 0 then 
        return 
    end

    local screen_w = M.screen[1]
    local line_height = 2  

    local time = game.global_vars.real_time * 0.5

    for x = 0, screen_w, 5 do

        local hue = ((x / screen_w) + time) % 1.0

        local r, g, b
        local h = hue * 6
        local c = 1
        local x_val = (1 - math.abs(h % 2 - 1))

        if h < 1 then
            r, g, b = c, x_val, 0
        elseif h < 2 then
            r, g, b = x_val, c, 0
        elseif h < 3 then
            r, g, b = 0, c, x_val
        elseif h < 4 then
            r, g, b = 0, x_val, c
        elseif h < 5 then
            r, g, b = x_val, 0, c
        else
            r, g, b = c, 0, x_val
        end

        draw.surface:add_rect_filled(
            draw.rect(x, 0, x + 5, line_height),
            draw.color(r * 255, g * 255, b * 255, 255)
        )
    end
end
events.present_queue:add(M.render_rainbow_line)

M.original_input_handler = M.handle_input

events.input:remove(M.handle_input)
events.input:add(M.handle_keybinds_input)

events.present_queue:add(M.render_keybinds_list)

function M.render_enemy_list()
    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 2) == 0 then return end

    if not game.engine:in_game() then 
        M.tracked_enemies = {}
        return 
    end

    if not M.tracked_enemies then
        M.tracked_enemies = {}
    end

    if M.dragging.enemy_list then
        local mouse = gui.input:cursor()
        M.elements_pos.enemy_list.x = mouse.x - M.drag_offset.enemy_list.x
        M.elements_pos.enemy_list.y = mouse.y - M.drag_offset.enemy_list.y
    end

    entities.controllers:for_each(function(entry)
        local controller = entry.entity
        if controller and controller:is_enemy() then
            local pawn = controller:get_pawn()
            local name = controller:get_name()
            if name and pawn then
                local health = pawn.m_iHealth and pawn.m_iHealth:get() or 0
                M.tracked_enemies[name] = {
                    name = name,
                    health = health,
                    is_alive = pawn:is_alive(),
                    last_seen = game.global_vars.real_time
                }
            end
        end
    end)

    local to_remove = {}
    local current_time = game.global_vars.real_time
    for name, info in pairs(M.tracked_enemies) do
        if current_time - info.last_seen > 10 then  
            to_remove[name] = true
        end
    end

    for name, _ in pairs(to_remove) do
        M.tracked_enemies[name] = nil
    end

    local enemies = {}
    for _, enemy in pairs(M.tracked_enemies) do
        if enemy.is_alive then
            table.insert(enemies, enemy)
        end
    end

    table.sort(enemies, function(a, b) return a.health < b.health end)

    if #enemies == 0 then return end

    local saved_command = {}
    saved_command.texture = draw.surface.g.texture
    saved_command.frag_shader = draw.surface.g.frag_shader
    saved_command.tex_sz = draw.surface.tex_sz
    saved_command.mode = draw.surface.g.mode
    saved_command.is_tile = draw.surface.g.is_tile
    saved_command.uv_rect = draw.surface.g.uv_rect
    saved_command.alpha = draw.surface.g.alpha
    saved_command.rotation = draw.surface.g.rotation
    saved_command.anti_alias = draw.surface.g.anti_alias
    saved_command.ignore_scaling = draw.surface.g.ignore_scaling

    draw.surface.g.texture = nil
    draw.surface.g.frag_shader = nil
    draw.surface.tex_sz = nil
    draw.surface.g.mode = nil
    draw.surface.g.is_tile = false
    draw.surface.g.uv_rect = nil
    draw.surface.g.alpha = 1.0
    draw.surface.g.rotation = 0
    draw.surface.g.anti_alias = true
    draw.surface.g.ignore_scaling = true

    local d = draw.surface
    d.font = draw.fonts["gui_main"]
    local accent_color = M.accent_picker:get_value():get()
    local padding_x = 10
    local padding_y = 8
    local item_height = 28
    local item_spacing = 4
    local corner_radius = 6
    local max_name_width = 100
    local total_width = 220  

    local title_height = 30
    local box_height = title_height + (#enemies * (item_height + item_spacing)) + padding_y * 2

    local adjusted_x = M.elements_pos.enemy_list.x
    local adjusted_y = M.elements_pos.enemy_list.y

    local glow_size = 6
    for i = glow_size, 1, -1 do
        local alpha = 10 * (1 - (i / glow_size))
        d:add_rect_filled_rounded(
            draw.rect(
                adjusted_x - i, 
                adjusted_y - i, 
                adjusted_x + total_width + i, 
                adjusted_y + box_height + i
            ),
            draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                math.floor(alpha)
            ),
            corner_radius + i,
            draw.rounding.all
        )
    end

    d:add_rect_filled_rounded(
        draw.rect(
            adjusted_x, 
            adjusted_y, 
            adjusted_x + total_width, 
            adjusted_y + box_height
        ),
        draw.color(0, 0, 0, 175),
        corner_radius,
        draw.rounding.all
    )

    d.font = draw.fonts["gui_semi_bold"]
    local title_text = "ENEMY LIST"
    local title_width = d.font:get_text_size(title_text).x
    local title_x = adjusted_x + (total_width / 2) - (title_width / 2)
    local title_y = adjusted_y + 10
    d:add_text(draw.vec2(title_x, title_y), title_text, draw.color(255, 255, 255))

    local line_width = total_width * 0.7
    local line_x_start = adjusted_x + (total_width - line_width) / 2
    local line_y = title_y + 18

    d:add_rect_filled_rounded(
        draw.rect(line_x_start, line_y, line_x_start + line_width, line_y + 2),
        accent_color,
        1,
        draw.rounding.all
    )

    d.font = draw.fonts["gui_main"]
    local y_position = adjusted_y + title_height + padding_y

    for i, enemy in ipairs(enemies) do

        local health_percent = enemy.health / 100

        local health_color
        if health_percent > 0.7 then 
            health_color = draw.color(0, 255, 0, 255)
        elseif health_percent > 0.4 then 
            health_color = draw.color(255, 255, 0, 255)
        elseif health_percent > 0.2 then 
            health_color = draw.color(255, 128, 0, 255)
        else 
            health_color = draw.color(255, 0, 0, 255)
        end

        d:add_rect_filled_rounded(
            draw.rect(
                adjusted_x + padding_x,
                y_position,
                adjusted_x + total_width - padding_x,
                y_position + item_height
            ),
            draw.color(20, 20, 20, 180),
            4,
            draw.rounding.all
        )

        local display_name = enemy.name
        local name_width = d.font:get_text_size(display_name).x
        if name_width > max_name_width then

            display_name = string.sub(display_name, 1, 12) .. "..."
        end

        d:add_text(
            draw.vec2(adjusted_x + padding_x + 6, y_position + 6),
            display_name,
            draw.color(255, 255, 255)
        )

        local bar_width = 80
        local bar_height = 10 
        local bar_x = adjusted_x + total_width - bar_width - padding_x - 6
        local bar_y = y_position + (item_height / 2) - (bar_height / 2)

        d:add_rect_filled_rounded(
            draw.rect(bar_x - 1, bar_y - 1, bar_x + bar_width + 1, bar_y + bar_height + 1),
            draw.color(60, 60, 60, 220),
            3,
            draw.rounding.all
        )

        d:add_rect_filled_rounded(
            draw.rect(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height),
            draw.color(30, 30, 30, 210),
            3,
            draw.rounding.all
        )

        if enemy.health > 0 then
            local health_width = health_percent * bar_width

            for i = 3, 1, -1 do
                local glow_alpha = 50 - (i * 15)
                d:add_rect_filled_rounded(
                    draw.rect(
                        bar_x - i, 
                        bar_y - i, 
                        bar_x + health_width + i, 
                        bar_y + bar_height + i
                    ),
                    draw.color(
                        health_color:get_r(),
                        health_color:get_g(),
                        health_color:get_b(),
                        glow_alpha
                    ),
                    3 + i,
                    draw.rounding.all
                )
            end

            d:add_rect_filled_rounded(
                draw.rect(bar_x, bar_y, bar_x + health_width, bar_y + bar_height),
                health_color,
                3,
                draw.rounding.all
            )
        end

        local health_text = tostring(enemy.health)
        local health_text_width = d.font:get_text_size(health_text).x

        if health_percent > 0.15 then 

            for ox = -1, 1 do
                for oy = -1, 1 do
                    if ox ~= 0 or oy ~= 0 then
                        d:add_text(
                            draw.vec2(bar_x + bar_width / 2 - health_text_width / 2 + ox, bar_y + (bar_height/2) - 5 + oy),
                            health_text,
                            draw.color(0, 0, 0, 180)
                        )
                    end
                end
            end

            d:add_text(
                draw.vec2(bar_x + bar_width / 2 - health_text_width / 2, bar_y + (bar_height/2) - 5),
                health_text,
                draw.color(255, 255, 255, 255)  
            )
        else

            local number_x = math.min(bar_x + bar_width + 5, adjusted_x + total_width - padding_x - health_text_width - 6)

            d:add_text(
                draw.vec2(number_x + 1, bar_y + (bar_height/2) - 5 + 1),
                health_text,
                draw.color(0, 0, 0, 200)
            )

            d:add_text(
                draw.vec2(number_x, bar_y + (bar_height/2) - 5),
                health_text,
                health_color
            )
        end

        y_position = y_position + item_height + item_spacing
    end

    draw.surface.g.texture = saved_command.texture
    draw.surface.g.frag_shader = saved_command.frag_shader
    draw.surface.tex_sz = saved_command.tex_sz
    draw.surface.g.mode = saved_command.mode
    draw.surface.g.is_tile = saved_command.is_tile
    draw.surface.g.uv_rect = saved_command.uv_rect
    draw.surface.g.alpha = saved_command.alpha
    draw.surface.g.rotation = saved_command.rotation
    draw.surface.g.anti_alias = saved_command.anti_alias
    draw.surface.g.ignore_scaling = saved_command.ignore_scaling
end

function M.enemy_list_input_handler(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 2) ~= 0 then

            local enemies_count = 0
            for _, _ in pairs(M.tracked_enemies or {}) do
                enemies_count = enemies_count + 1
            end

            local total_width = 220
            local title_height = 30
            local padding_y = 8
            local item_height = 28
            local item_spacing = 4
            local box_height = title_height + (enemies_count * (item_height + item_spacing)) + padding_y * 2

            if box_height < 60 then box_height = 60 end

            local enemy_list_box = {
                x = M.elements_pos.enemy_list.x,
                y = M.elements_pos.enemy_list.y,
                width = total_width,
                height = box_height
            }

            if mouse.x >= enemy_list_box.x and mouse.x <= enemy_list_box.x + enemy_list_box.width and
               mouse.y >= enemy_list_box.y and mouse.y <= enemy_list_box.y + enemy_list_box.height then
                M.dragging.enemy_list = true
                M.drag_offset.enemy_list.x = mouse.x - M.elements_pos.enemy_list.x
                M.drag_offset.enemy_list.y = mouse.y - M.elements_pos.enemy_list.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.enemy_list = false
    end
end

function M.enemy_list_input_handler(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 2) ~= 0 then

            local enemies_count = 0
            for _, _ in pairs(M.tracked_enemies or {}) do
                enemies_count = enemies_count + 1
            end

            local total_width = 220
            local title_height = 30
            local padding_y = 8
            local item_height = 28
            local item_spacing = 4
            local box_height = title_height + (enemies_count * (item_height + item_spacing)) + padding_y * 2

            if box_height < 60 then box_height = 60 end

            local enemy_list_box = {
                x = M.elements_pos.enemy_list.x,
                y = M.elements_pos.enemy_list.y,
                width = total_width,
                height = box_height
            }

            if mouse.x >= enemy_list_box.x and mouse.x <= enemy_list_box.x + enemy_list_box.width and
               mouse.y >= enemy_list_box.y and mouse.y <= enemy_list_box.y + enemy_list_box.height then
                M.dragging.enemy_list = true
                M.drag_offset.enemy_list.x = mouse.x - M.elements_pos.enemy_list.x
                M.drag_offset.enemy_list.y = mouse.y - M.elements_pos.enemy_list.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.enemy_list = false
    end
end

local original_handle_input = M.handle_input
M.handle_input = function(msg, wparam, lparam)

    if original_handle_input then
        original_handle_input(msg, wparam, lparam)
    end

    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()

        if type(combo_value) == "number" and bit.band(combo_value, 1) ~= 0 then

            local hitlog_box = {
                x = M.elements_pos.hitlogs.x - 10,
                y = M.elements_pos.hitlogs.y - 7,
                width = 320, 
                height = 35  
            }

            if mouse.x >= hitlog_box.x and mouse.x <= hitlog_box.x + hitlog_box.width and
               mouse.y >= hitlog_box.y and mouse.y <= hitlog_box.y + hitlog_box.height then
                M.dragging.hitlogs = true
                M.drag_offset.hitlogs.x = mouse.x - M.elements_pos.hitlogs.x
                M.drag_offset.hitlogs.y = mouse.y - M.elements_pos.hitlogs.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.hitlogs = false
    end
end

function M.extended_handle_input(msg, wparam, lparam)

    M.handle_input(msg, wparam, lparam)

    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local combo_value = M.hitlogs_display_combo:get_value():get():get_raw()

        if type(combo_value) == "number" and bit.band(combo_value, 16) ~= 0 then
            local comprehensive_box = {
                x = M.elements_pos.comprehensive_gs_logs.x - 10,
                y = M.elements_pos.comprehensive_gs_logs.y - 7,
                width = 500, 
                height = 30
            }

            if mouse.x >= comprehensive_box.x and mouse.x <= comprehensive_box.x + comprehensive_box.width and
               mouse.y >= comprehensive_box.y and mouse.y <= comprehensive_box.y + comprehensive_box.height then
                M.dragging.comprehensive_gs_logs = true
                M.drag_offset.comprehensive_gs_logs.x = mouse.x - M.elements_pos.comprehensive_gs_logs.x
                M.drag_offset.comprehensive_gs_logs.y = mouse.y - M.elements_pos.comprehensive_gs_logs.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.comprehensive_gs_logs = false
    end
end

function M.reset_game_stats()
    M.game_stats.shots_fired = 0
    M.game_stats.distance_traveled = 0
    M.game_stats.nades_used = 0
    M.game_stats.molotovs_used = 0
    M.game_stats.smokes_used = 0
    M.game_stats.kills = 0
    M.game_stats.deaths = 0
    M.game_stats.ns_kills = 0
    M.game_stats.headshots = 0
    M.game_stats.kill_streaks = {}  
    M.game_stats.last_position = nil
    M.game_stats.round_number = 0
end

function M.on_grenade_thrown(event)
    if event:get_name() ~= "grenade_thrown" then return end

    local thrower = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()
    if not thrower or thrower ~= local_player then return end

    local weapon = event:get_string("weapon")
    if weapon == "hegrenade" then
        M.game_stats.nades_used = M.game_stats.nades_used + 1
    elseif weapon == "molotov" or weapon == "incgrenade" then
        M.game_stats.molotovs_used = M.game_stats.molotovs_used + 1
    elseif weapon == "smokegrenade" then
        M.game_stats.smokes_used = M.game_stats.smokes_used + 1
    end
end

function M.update_game_stats_distance()
    local local_player = entities.get_local_pawn()
    if not local_player then return end

    local current_pos = local_player:get_abs_origin()
    if not current_pos then return end

    if M.game_stats.last_position then
        local dx = current_pos.x - M.game_stats.last_position.x
        local dy = current_pos.y - M.game_stats.last_position.y

        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < 500 then 
            M.game_stats.distance_traveled = M.game_stats.distance_traveled + distance
        end
    end

    M.game_stats.last_position = current_pos
end

function M.on_game_stats_weapon_fire(event)
    if event:get_name() ~= "weapon_fire" then return end

    local shooter = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()
    if not shooter or shooter ~= local_player then return end

    local weapon = event:get_string("weapon")
    if not weapon then return end

    local active_weapon = shooter:get_active_weapon()
    if active_weapon then
        local weapon_type = active_weapon:get_type()

        if weapon_type == csweapon_type.pistol or
           weapon_type == csweapon_type.submachinegun or
           weapon_type == csweapon_type.rifle or
           weapon_type == csweapon_type.shotgun or
           weapon_type == csweapon_type.sniper_rifle or
           weapon_type == csweapon_type.machinegun then
            M.game_stats.shots_fired = M.game_stats.shots_fired + 1
        end
    end
end

function M.on_game_stats_player_death(event)
    if event:get_name() ~= "player_death" then return end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()
    local headshot = event:get_bool("headshot")

    if attacker then
        local attacker_name = attacker:get_name()
        if attacker_name then
            if not M.game_stats.kill_streaks[attacker_name] then
                M.game_stats.kill_streaks[attacker_name] = 0
            end
            M.game_stats.kill_streaks[attacker_name] = M.game_stats.kill_streaks[attacker_name] + 1
        end

        if attacker == local_player then
            M.game_stats.kills = M.game_stats.kills + 1
            if headshot then
                M.game_stats.headshots = M.game_stats.headshots + 1
            end

            local active_weapon = attacker:get_active_weapon()
            if active_weapon then
                local weapon_id_value = active_weapon:get_id()

                if (weapon_id_value == 9 or  
                    weapon_id_value == 40 or 
                    weapon_id_value == 11 or 
                    weapon_id_value == 38) then 

                    local is_scoped = attacker.m_bIsScoped and attacker.m_bIsScoped:get()
                    if not is_scoped then
                        M.game_stats.ns_kills = M.game_stats.ns_kills + 1
                    end
                end
            end
        end
    end

    if victim then
        local victim_name = victim:get_name()
        if victim_name then

            local streak = M.game_stats.kill_streaks[victim_name] or 0
            if streak >= 5 then
                local attacker_name = attacker and attacker:get_name() or "Someone"
                local message = string.format("%s ended %s's %d killstreak!", attacker_name, victim_name, streak)
                local notif = gui.notification("Million.lua", message)
                gui.notify:add(notif)
            end

            M.game_stats.kill_streaks[victim_name] = 0
        end

        if victim == local_player then
            M.game_stats.deaths = M.game_stats.deaths + 1
        end
    end
end

function M.on_game_stats_round_start(event)
    if event:get_name() ~= "round_start" then return end
    M.game_stats.round_number = M.game_stats.round_number + 1
end

function M.on_game_stats_game_state_change(event)
    local event_name = event:get_name()
    if event_name == "game_newmap" or event_name == "cs_game_disconnected" or event_name == "cs_win_panel_match" then
        M.reset_game_stats()
    end
end

function M.render_game_stats()
    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 8) == 0 then return end

    if M.dragging.game_stats then
        local mouse = gui.input:cursor()
        M.elements_pos.game_stats.x = mouse.x - M.drag_offset.game_stats.x
        M.elements_pos.game_stats.y = mouse.y - M.drag_offset.game_stats.y
    end

    local pos_x = M.elements_pos.game_stats.x
    local pos_y = M.elements_pos.game_stats.y

    local accent_color = M.accent_picker:get_value():get()
    local kd_ratio = M.game_stats.deaths > 0 and M.game_stats.kills / M.game_stats.deaths or M.game_stats.kills

    local d = draw.surface
    d.font = draw.fonts["gui_debug"]
    local padding_x = 15
    local padding_y = 15
    local section_spacing = 15
    local corner_radius = 6
    local item_height = 22
    local panel_width = 220 

    local sections = {
        {
            title = "PERFORMANCE",
            stats = {
                {"Kills", M.game_stats.kills, true},
                {"Deaths", M.game_stats.deaths, true},
                {"K/D", string.format("%.2f", kd_ratio), true},
                {"Headshots", M.game_stats.headshots, true},
                {"No-Scope", M.game_stats.ns_kills, true}
            }
        },
        {
            title = "UTILITY",
            stats = {
                {"Shots", M.game_stats.shots_fired, true},
                {"HE Nades", M.game_stats.nades_used, true}, 
                {"Molotovs", M.game_stats.molotovs_used, true},
                {"Smokes", M.game_stats.smokes_used, true},
                {"Distance", string.format("%.0fm", M.game_stats.distance_traveled / 50), true}
            }
        }
    }

    local panel_height = padding_y

    for i, section in ipairs(sections) do
        d.font = draw.fonts["gui_semi_bold"]
        local title_height = d.font:get_text_size(section.title).y

        panel_height = panel_height + title_height + 12

        panel_height = panel_height + (#section.stats * item_height)

        if i < #sections then
            panel_height = panel_height + section_spacing
        end
    end

    panel_height = panel_height + padding_y

    local glow_size = 6
    for i = glow_size, 1, -1 do
        local alpha = 10 * (1 - (i / glow_size))
        d:add_rect_filled_rounded(
            draw.rect(
                pos_x - i, 
                pos_y - i, 
                pos_x + panel_width + i, 
                pos_y + panel_height + i
            ),
            draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                math.floor(alpha)
            ),
            corner_radius + i,
            draw.rounding.all
        )
    end

    d:add_rect_filled_rounded(
        draw.rect(
            pos_x, 
            pos_y, 
            pos_x + panel_width, 
            pos_y + panel_height
        ),
        draw.color(0, 0, 0, 175),
        corner_radius,
        draw.rounding.all
    )

    local current_y = pos_y + padding_y

    for _, section in ipairs(sections) do

        d.font = draw.fonts["gui_semi_bold"]
        local title_width = d.font:get_text_size(section.title).x
        local title_x = pos_x + (panel_width - title_width) / 2

        d:add_text(
            draw.vec2(title_x, current_y),
            section.title,
            draw.color(255, 255, 255, 255)
        )
        current_y = current_y + d.font:get_text_size(section.title).y + 2

        local line_width = panel_width * 0.8
        local line_x = pos_x + (panel_width - line_width) / 2

        d:add_rect_filled_rounded(
            draw.rect(line_x, current_y, line_x + line_width, current_y + 2),
            accent_color,
            1,
            draw.rounding.all
        )
        current_y = current_y + 10  

        d.font = draw.fonts["gui_debug"]
        for _, stat in ipairs(section.stats) do
            local name = stat[1]
            local value = stat[2]
            local highlight = stat[3]

            d:add_text(
                draw.vec2(pos_x + padding_x, current_y),
                name .. ":",
                draw.color(255, 255, 255, 255)
            )

            local value_width = d.font:get_text_size(tostring(value)).x
            d:add_text(
                draw.vec2(pos_x + panel_width - value_width - padding_x, current_y),
                tostring(value),
                highlight and accent_color or draw.color(255, 255, 255, 255)
            )

            current_y = current_y + item_height
        end

        current_y = current_y + section_spacing  
    end
end

function M.handle_game_stats_input(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 8) ~= 0 then

            local game_stats_box = {
                x = M.elements_pos.game_stats.x - 10,
                y = M.elements_pos.game_stats.y - 10,
                width = 240,
                height = 280
            }

            if mouse.x >= game_stats_box.x and mouse.x <= game_stats_box.x + game_stats_box.width and
               mouse.y >= game_stats_box.y and mouse.y <= game_stats_box.y + game_stats_box.height then
                M.dragging.game_stats = true
                M.drag_offset.game_stats.x = mouse.x - M.elements_pos.game_stats.x
                M.drag_offset.game_stats.y = mouse.y - M.elements_pos.game_stats.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.game_stats = false
    end
end

if not M.drag_offset.game_stats then
    M.drag_offset.game_stats = {x = 0, y = 0}
end

mods.events:add_listener("grenade_thrown")
mods.events:add_listener("weapon_fire")
mods.events:add_listener("player_death")
mods.events:add_listener("round_start")
mods.events:add_listener("game_newmap")
mods.events:add_listener("cs_game_disconnected")
mods.events:add_listener("cs_win_panel_match")

events.event:add(M.on_grenade_thrown)
events.event:add(M.on_game_stats_weapon_fire)
events.event:add(M.on_game_stats_player_death)
events.event:add(M.on_game_stats_round_start)
events.event:add(M.on_game_stats_game_state_change)
events.frame_stage_notify:add(M.update_game_stats_distance)
events.present_queue:add(M.render_game_stats)
events.input:add(M.handle_game_stats_input)

function M.reset_round_data()
    M.round_stats.current_round = {
        damage_dealt = 0,
        damage_taken = 0,
        hits_dealt = 0,
        hits_taken = 0,
        headshots_dealt = 0,
        enemies_killed = 0,
        enemies_hurt = {},
        damage_sources = {}
    }
end

function M.on_round_stats_hit(event)
    if event:get_name() ~= "player_hurt" then return end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if not attacker or not victim or not local_player then return end

    local damage = event:get_int("dmg_health")
    local is_headshot = event:get_bool("headshot")

    if attacker == local_player then
        M.round_stats.current_round.damage_dealt = M.round_stats.current_round.damage_dealt + damage
        M.round_stats.current_round.hits_dealt = M.round_stats.current_round.hits_dealt + 1

        if is_headshot then
            M.round_stats.current_round.headshots_dealt = M.round_stats.current_round.headshots_dealt + 1
        end

        local victim_name = victim:get_name() or "Unknown"
        local found = false

        for i, hurt_entry in ipairs(M.round_stats.current_round.enemies_hurt) do
            if hurt_entry.name == victim_name then
                hurt_entry.dmg = hurt_entry.dmg + damage
                found = true
                break
            end
        end

        if not found then
            table.insert(M.round_stats.current_round.enemies_hurt, {
                name = victim_name,
                dmg = damage
            })
        end
    end

    if victim == local_player then
        M.round_stats.current_round.damage_taken = M.round_stats.current_round.damage_taken + damage
        M.round_stats.current_round.hits_taken = M.round_stats.current_round.hits_taken + 1

        local attacker_name = attacker:get_name() or "Unknown"
        local found = false

        for i, source_entry in ipairs(M.round_stats.current_round.damage_sources) do
            if source_entry.name == attacker_name then
                source_entry.dmg = source_entry.dmg + damage
                found = true
                break
            end
        end

        if not found then
            table.insert(M.round_stats.current_round.damage_sources, {
                name = attacker_name,
                dmg = damage
            })
        end
    end
end

function M.on_round_stats_death(event)
    if event:get_name() ~= "player_death" then return end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if attacker and local_player and attacker == local_player and victim and victim:is_enemy() then
        M.round_stats.current_round.enemies_killed = M.round_stats.current_round.enemies_killed + 1
    end
end

function M.on_round_stats_round_end(event)
    if event:get_name() ~= "round_end" then return end

    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 32) ~= 0 then

        if M.round_stats.current_round.damage_dealt > 0 or M.round_stats.current_round.damage_taken > 0 then
            M.round_stats.visuals.state = "fade_in"
            M.round_stats.visuals.display_start_time = game.global_vars.real_time
            M.round_stats.visuals.show_until_time = game.global_vars.real_time + M.round_stats.config.display_time
        end
    end
end

function M.on_round_stats_round_start(event)
    if event:get_name() ~= "round_start" then return end

    M.reset_round_data()
end

function M.handle_round_stats_input(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 32) ~= 0 then
            if M.round_stats.visuals.state == "hidden" or M.round_stats.visuals.opacity < 0.5 then
                return
            end

            local panel_area = {
                x1 = M.elements_pos.round_stats.x,
                y1 = M.elements_pos.round_stats.y,
                x2 = M.elements_pos.round_stats.x + M.round_stats.config.width,
                y2 = M.elements_pos.round_stats.y + M.round_stats.config.height
            }

            if mouse.x >= panel_area.x1 and mouse.x <= panel_area.x2 and
               mouse.y >= panel_area.y1 and mouse.y <= panel_area.y2 then
                M.dragging.round_stats = true
                M.drag_offset.round_stats.x = mouse.x - M.elements_pos.round_stats.x
                M.drag_offset.round_stats.y = mouse.y - M.elements_pos.round_stats.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.round_stats = false
    end
end

    function M.render_round_stats()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
        if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 32) == 0 then return end

        if M.dragging.round_stats then
            local mouse = gui.input:cursor()
            M.elements_pos.round_stats.x = mouse.x - M.drag_offset.round_stats.x
            M.elements_pos.round_stats.y = mouse.y - M.drag_offset.round_stats.y

            local screen_w, screen_h = game.engine:get_screen_size()
            M.elements_pos.round_stats.x = math.max(0, math.min(screen_w - M.round_stats.config.width, M.elements_pos.round_stats.x))
            M.elements_pos.round_stats.y = math.max(0, math.min(screen_h - M.round_stats.config.height, M.elements_pos.round_stats.y))
        end

        local current_time = game.global_vars.real_time

        if M.round_stats.visuals.state == "fade_in" then
            local progress = (current_time - M.round_stats.visuals.display_start_time) / M.round_stats.config.fade_in_time
            if progress >= 1.0 then
                M.round_stats.visuals.state = "visible"
                M.round_stats.visuals.opacity = 1.0
            else
                M.round_stats.visuals.opacity = progress
            end
        elseif M.round_stats.visuals.state == "visible" then
            if current_time >= M.round_stats.visuals.show_until_time then
                M.round_stats.visuals.state = "fade_out"
                M.round_stats.visuals.display_start_time = current_time
            end
        elseif M.round_stats.visuals.state == "fade_out" then
            local progress = (current_time - M.round_stats.visuals.display_start_time) / M.round_stats.config.fade_out_time
            if progress >= 1.0 then
                M.round_stats.visuals.state = "hidden"
                M.round_stats.visuals.opacity = 0.0
            else
                M.round_stats.visuals.opacity = 1.0 - progress
            end
        end

        if M.round_stats.visuals.state == "hidden" or M.round_stats.visuals.opacity <= 0.01 then
            return
        end

        if M.round_stats.current_round.damage_dealt == 0 and M.round_stats.current_round.damage_taken == 0 then
            return
        end

        local saved_command = {}
        saved_command.texture = draw.surface.g.texture
        saved_command.frag_shader = draw.surface.g.frag_shader
        saved_command.tex_sz = draw.surface.tex_sz
        saved_command.mode = draw.surface.g.mode
        saved_command.is_tile = draw.surface.g.is_tile
        saved_command.uv_rect = draw.surface.g.uv_rect
        saved_command.alpha = draw.surface.g.alpha
        saved_command.rotation = draw.surface.g.rotation
        saved_command.anti_alias = draw.surface.g.anti_alias
        saved_command.ignore_scaling = draw.surface.g.ignore_scaling

        draw.surface.g.texture = nil
        draw.surface.g.frag_shader = nil
        draw.surface.tex_sz = nil
        draw.surface.g.mode = nil
        draw.surface.g.is_tile = false
        draw.surface.g.uv_rect = nil
        draw.surface.g.alpha = 1.0
        draw.surface.g.rotation = 0
        draw.surface.g.anti_alias = true
        draw.surface.g.ignore_scaling = true

        local d = draw.surface
        local config = M.round_stats.config
        local pos = M.elements_pos.round_stats
        local opacity = M.round_stats.visuals.opacity

        local alpha = math.floor(255 * opacity)
        local accent_color = draw.color(
            M.accent_picker:get_value():get():get_r(),
            M.accent_picker:get_value():get():get_g(),
            M.accent_picker:get_value():get():get_b(),
            alpha
        )
        local bg_color = draw.color(20, 20, 20, math.floor(200 * opacity))
        local text_color = draw.color(255, 255, 255, alpha)
        local title_color = accent_color

        for i = config.glow_size, 1, -1 do
            local glow_alpha = math.floor(10 * (1 - (i / config.glow_size)) * opacity)
            d:add_rect_filled_rounded(
                draw.rect(
                    pos.x - i,
                    pos.y - i,
                    pos.x + config.width + i,
                    pos.y + config.height + i
                ),
                draw.color(
                    accent_color:get_r(),
                    accent_color:get_g(),
                    accent_color:get_b(),
                    glow_alpha
                ),
                config.corner_radius + i,
                draw.rounding.all
            )
        end

        d:add_rect_filled_rounded(
            draw.rect(
                pos.x,
                pos.y,
                pos.x + config.width,
                pos.y + config.height
            ),
            bg_color,
            config.corner_radius,
            draw.rounding.all
        )

        d.font = draw.fonts["gui_title"]

        local title = "Round Damage Summary"
        local title_width = d.font:get_text_size(title).x
        d:add_text(
            draw.vec2(pos.x + (config.width - title_width) / 2, pos.y + config.padding),
            title,
            title_color
        )

        local separator_y = pos.y + config.padding + 25
        d:add_rect_filled(
            draw.rect(
                pos.x + config.width * 0.25,
                separator_y,
                pos.x + config.width * 0.75,
                separator_y + 2
            ),
            accent_color
        )

        d.font = draw.fonts["gui_main"]

        local y_offset = separator_y + 15

        local function draw_stat_line(y, label, value, suffix)
            d:add_text(
                draw.vec2(pos.x + config.padding, y),
                label,
                text_color
            )

            local value_text = tostring(value) .. (suffix or "")
            local value_width = d.font:get_text_size(value_text).x

            d:add_text(
                draw.vec2(pos.x + config.width - config.padding - value_width, y),
                value_text,
                accent_color
            )
        end

        draw_stat_line(y_offset, "Damage Dealt:", M.round_stats.current_round.damage_dealt)
        y_offset = y_offset + config.line_height

        draw_stat_line(y_offset, "Damage Taken:", M.round_stats.current_round.damage_taken)
        y_offset = y_offset + config.line_height

        draw_stat_line(y_offset, "Hits Landed:", M.round_stats.current_round.hits_dealt)
        y_offset = y_offset + config.line_height

        draw_stat_line(y_offset, "Headshots:", M.round_stats.current_round.headshots_dealt)
        y_offset = y_offset + config.line_height

        draw_stat_line(y_offset, "Enemies Killed:", M.round_stats.current_round.enemies_killed)
        y_offset = y_offset + config.line_height

        local damage_ratio = 0
        if M.round_stats.current_round.damage_taken > 0 then
            damage_ratio = M.round_stats.current_round.damage_dealt / M.round_stats.current_round.damage_taken
        elseif M.round_stats.current_round.damage_dealt > 0 then
            damage_ratio = 99.9  
        end

        draw_stat_line(y_offset, "Damage Ratio:", string.format("%.1f", damage_ratio), "x")

        draw.surface.g.texture = saved_command.texture
        draw.surface.g.frag_shader = saved_command.frag_shader
        draw.surface.tex_sz = saved_command.tex_sz
        draw.surface.g.mode = saved_command.mode
        draw.surface.g.is_tile = saved_command.is_tile
        draw.surface.g.uv_rect = saved_command.uv_rect
        draw.surface.g.alpha = saved_command.alpha
        draw.surface.g.rotation = saved_command.rotation
        draw.surface.g.anti_alias = saved_command.anti_alias
        draw.surface.g.ignore_scaling = saved_command.ignore_scaling
    end

function M.on_round_stats_game_event(event)
    local event_name = event:get_name()
    if event_name == "cs_game_disconnected" or
       event_name == "game_newmap" or
       event_name == "map_shutdown" then
        M.reset_round_data()
        M.round_stats.visuals.state = "hidden"
        M.round_stats.visuals.opacity = 0
    end
end

function M.handle_active_streaks_input(msg, wparam, lparam)
    if msg == 0x0201 then 
        local mouse = gui.input:cursor()
        local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()

        if type(other_visuals_value) == "number" and bit.band(other_visuals_value, 16) ~= 0 then

            local streaks_box = {
                x = M.elements_pos.active_streaks.x - 20,
                y = M.elements_pos.active_streaks.y - 20,
                width = 270,
                height = 300
            }

            if mouse.x >= streaks_box.x and mouse.x <= streaks_box.x + streaks_box.width and
               mouse.y >= streaks_box.y and mouse.y <= streaks_box.y + streaks_box.height then
                M.dragging.active_streaks = true
                M.drag_offset.active_streaks.x = mouse.x - M.elements_pos.active_streaks.x
                M.drag_offset.active_streaks.y = mouse.y - M.elements_pos.active_streaks.y
            end
        end
    elseif msg == 0x0202 then 
        M.dragging.active_streaks = false
    end
end

function M.render_active_streaks()
    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 16) == 0 then return end

    if M.dragging.active_streaks then
        local mouse = gui.input:cursor()
        M.elements_pos.active_streaks.x = mouse.x - M.drag_offset.active_streaks.x
        M.elements_pos.active_streaks.y = mouse.y - M.drag_offset.active_streaks.y
    end

    local pos_x = M.elements_pos.active_streaks.x
    local pos_y = M.elements_pos.active_streaks.y

    local accent_color = M.accent_picker:get_value():get()

    local d = draw.surface
    local padding_x = 15
    local padding_y = 15
    local corner_radius = 6
    local item_height = 24
    local panel_width = 220

    local active_streaks = {}
    for name, streak in pairs(M.game_stats.kill_streaks) do
        if streak >= 2 then 
            table.insert(active_streaks, {name = name, streak = streak})
        end
    end
    table.sort(active_streaks, function(a, b) return a.streak > b.streak end)

    d.font = draw.fonts["gui_semi_bold"]
    local title_height = d.font:get_text_size("ACTIVE STREAKS").y + 20 

    d.font = draw.fonts["gui_debug"]
    local streaks_height = 0

    if #active_streaks > 0 then
        streaks_height = #active_streaks * item_height
    else
        streaks_height = item_height 
    end

    local panel_height = padding_y * 2 + title_height + streaks_height

    local glow_size = 6
    for i = glow_size, 1, -1 do
        local alpha = 10 * (1 - (i / glow_size))
        d:add_rect_filled_rounded(
            draw.rect(
                pos_x - i, 
                pos_y - i, 
                pos_x + panel_width + i, 
                pos_y + panel_height + i
            ),
            draw.color(
                accent_color:get_r(),
                accent_color:get_g(),
                accent_color:get_b(),
                math.floor(alpha)
            ),
            corner_radius + i,
            draw.rounding.all
        )
    end

    d:add_rect_filled_rounded(
        draw.rect(
            pos_x, 
            pos_y, 
            pos_x + panel_width, 
            pos_y + panel_height
        ),
        draw.color(0, 0, 0, 175),
        corner_radius,
        draw.rounding.all
    )

    d.font = draw.fonts["gui_semi_bold"]
    local title_text = "ACTIVE STREAKS"
    local title_width = d.font:get_text_size(title_text).x
    local title_x = pos_x + (panel_width - title_width) / 2

    d:add_text(
        draw.vec2(title_x, pos_y + padding_y),
        title_text,
        draw.color(255, 255, 255, 255)
    )

    local line_width = panel_width * 0.8
    local line_x = pos_x + (panel_width - line_width) / 2
    local line_y = pos_y + padding_y + d.font:get_text_size(title_text).y + 5

    d:add_rect_filled_rounded(
        draw.rect(line_x, line_y, line_x + line_width, line_y + 2),
        accent_color,
        1,
        draw.rounding.all
    )

    d.font = draw.fonts["gui_debug"]
    local current_y = pos_y + padding_y + title_height

    if #active_streaks > 0 then
        for _, streak in ipairs(active_streaks) do

            d:add_text(
                draw.vec2(pos_x + padding_x, current_y),
                streak.name .. ":",
                draw.color(255, 255, 255, 255)
            )

            local streak_text = streak.streak .. "x"
            local streak_width = d.font:get_text_size(streak_text).x
            d:add_text(
                draw.vec2(pos_x + panel_width - streak_width - padding_x, current_y),
                streak_text,
                accent_color
            )

            current_y = current_y + item_height
        end
    else

        local message = "No active streaks"
        local text_width = d.font:get_text_size(message).x
        local text_x = pos_x + (panel_width - text_width) / 2

        d:add_text(
            draw.vec2(text_x, current_y),
            message,
            draw.color(200, 200, 200, 200)
        )
    end
end

events.input:add(M.handle_active_streaks_input)
events.present_queue:add(M.render_active_streaks)

function M.handle_anti_afk_movement(cmd)
    local game_related_value = M.game_related_combo:get_value():get():get_raw()
    if type(game_related_value) ~= "number" or bit.band(game_related_value, 1) == 0 then
        return
    end

    if not M.anti_afk.initialized then
        M.anti_afk.change_interval = M.anti_afk_direction_speed:get_value():get()
        M.anti_afk.movement_amount = M.anti_afk_distance:get_value():get()
        M.anti_afk.last_change = game.global_vars.cur_time
        M.anti_afk.initialized = true
    end

    local current_time = game.global_vars.cur_time

    M.anti_afk.change_interval = M.anti_afk_direction_speed:get_value():get()
    M.anti_afk.movement_amount = M.anti_afk_distance:get_value():get()

    M.anti_afk.change_interval = math.max(0.01, M.anti_afk.change_interval)
    M.anti_afk.movement_amount = math.max(0.01, M.anti_afk.movement_amount)

    if current_time - M.anti_afk.last_change >= M.anti_afk.change_interval then
        M.anti_afk.direction = -M.anti_afk.direction

        if M.anti_afk_random:get_value():get() then

            M.anti_afk.current_movement = {
                forward = math.random() > 0.5 and M.anti_afk.movement_amount or -M.anti_afk.movement_amount,
                side = math.random() > 0.5 and M.anti_afk.movement_amount or -M.anti_afk.movement_amount
            }
        end

        M.anti_afk.last_change = current_time
    end

    if M.anti_afk_random:get_value():get() then
        cmd:set_forwardmove(M.anti_afk.current_movement.forward)
        cmd:set_leftmove(M.anti_afk.current_movement.side)
    else
        cmd:set_forwardmove(0)
        cmd:set_leftmove(M.anti_afk.direction * M.anti_afk.movement_amount)
    end

    local current_angles = cmd:get_viewangles()
    cmd:set_viewangles(current_angles)
end

events.create_move:add(M.handle_anti_afk_movement)

mods.events:add_listener("cs_win_panel_match")
mods.events:add_listener("round_end")

function M.handle_disconnect_on_end(event)
    local game_related_value = M.game_related_combo:get_value():get():get_raw()
    if type(game_related_value) ~= "number" or bit.band(game_related_value, 2) == 0 then return end

    local event_name = event:get_name()

    if event_name == "cs_win_panel_match" then

        M.disconnect_on_end.waiting_for_disconnect = true

        local notif = gui.notification("Million.lua", string.format("Game ended. Disconnecting in %.1f seconds...", M.disconnect_on_end.disconnect_delay))
        gui.notify:add(notif)

        local disconnect_time = game.global_vars.real_time + M.disconnect_on_end.disconnect_delay

        function M.perform_delayed_disconnect()
            if game.global_vars.real_time >= disconnect_time then
                game.engine:client_cmd("disconnect")
                M.disconnect_on_end.waiting_for_disconnect = false
                return true  
            end
            return false
        end

        events.present_queue:add(M.perform_delayed_disconnect)
    end
end

events.event:add(M.handle_disconnect_on_end)

function M.check_auto_rs()

    local current_time = game.global_vars.real_time

    if current_time - M.auto_rs.last_check_time < 1.0 then
        return
    end
    M.auto_rs.last_check_time = current_time

    local game_related_value = M.game_related_combo:get_value():get():get_raw()

    if type(game_related_value) ~= "number" or bit.band(game_related_value, 4) == 0 then
        return
    end

    if not game.engine:in_game() then

        M.auto_rs.has_sent_reset = false
        return
    end

    local current_kills = M.game_stats.kills
    local current_deaths = M.game_stats.deaths

    if current_kills == 0 and current_deaths == 0 then

        if M.auto_rs.has_sent_reset then
            M.auto_rs.has_sent_reset = false
        end
        return
    end

    if (current_deaths >= current_kills + M.auto_rs.trigger_threshold) and 
       not M.auto_rs.has_sent_reset then

        game.engine:client_cmd("say !rs")

        local reset_message = string.format("Auto RS triggered at %d:%d", current_kills, current_deaths)
        local notif = gui.notification("Million.lua", reset_message)
        gui.notify:add(notif)

        M.auto_rs.has_sent_reset = true
    end
end
function M.reset_auto_rs_state(event)
    local event_name = event:get_name()
    if event_name == "game_newmap" or 
       event_name == "cs_game_disconnected" or
       event_name == "cs_win_panel_match" then
        M.auto_rs.has_sent_reset = false
    end
end

function M.on_round_start_auto_rs(event)
    if event:get_name() ~= "round_start" then return end

    local current_kills = M.game_stats.kills
    local current_deaths = M.game_stats.deaths

    if current_kills == 0 and current_deaths == 0 then
        M.auto_rs.has_sent_reset = false
    end
end
events.event:add(M.reset_auto_rs_state)
events.event:add(M.on_round_start_auto_rs)
events.present_queue:add(function()
    if game.engine:in_game() then
        M.check_auto_rs()
    end
end)

events.event:add(function(event)
    if event:get_name() == "player_death" then
        local victim = event:get_pawn_from_id("userid")
        local local_player = entities.get_local_pawn()

        if victim and local_player and victim == local_player then

            events.present_queue:add(function()
                M.check_auto_rs()
                return true  
            end)
        end
    end
end)

function M.get_knife_rainbow_color(angle, alpha)
    local time = game.global_vars.real_time * 0.3  

    local hue = ((angle / (math.pi * 2)) + time) % 1.0

    local h = hue * 6
    local i = math.floor(h)
    local f = h - i
    local p = 0
    local q = 1 - f
    local t = f

    local r, g, b
    if i == 0 then r, g, b = 1, t, p
    elseif i == 1 then r, g, b = q, 1, p
    elseif i == 2 then r, g, b = p, 1, t
    elseif i == 3 then r, g, b = p, q, 1
    elseif i == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end

    return draw.color(r * 255, g * 255, b * 255, alpha)
end

function M.draw_knife_3d_circle(origin, radius, base_color, segments, thickness, rainbow)
    local d = draw.surface
    segments = segments or 64  

    local points = {}
    local angles = {}
    for i = 0, segments do
        local angle = (i / segments) * math.pi * 2
        angles[i] = angle

        local point = vector(
            origin.x + math.cos(angle) * radius,
            origin.y + math.sin(angle) * radius,
            origin.z
        )

        local screen_point = math.world_to_screen(point)
        if screen_point then
            points[i] = screen_point
        end
    end

    d.g.anti_alias = true

    for i = 0, segments - 1 do
        if points[i] and points[i+1] then
            local color
            if rainbow then

                color = M.get_knife_rainbow_color(angles[i], base_color:get_a())
            else
                color = base_color
            end

            d:add_line(
                draw.vec2(points[i].x, points[i].y),
                draw.vec2(points[i+1].x, points[i+1].y),
                color,
                thickness
            )
        end
    end

    if points[segments] and points[0] then
        local color
        if rainbow then
            color = M.get_knife_rainbow_color(angles[segments], base_color:get_a())
        else
            color = base_color
        end

        d:add_line(
            draw.vec2(points[segments].x, points[segments].y),
            draw.vec2(points[0].x, points[0].y),
            color,
            thickness
        )
    end

    d.g.anti_alias = false
end

function M.render_knife_range()

    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 64) == 0 then
        return
    end

    local local_player = entities.get_local_pawn()
    if not local_player or not local_player:is_alive() then
        return
    end

    local weapon = local_player:get_active_weapon()
    if not weapon or weapon:get_type() ~= csweapon_type.knife then
        return
    end

    local knife_range = M.KNIFE_RANGE  
    local ring_color = M.knife_color:get_value():get()
    local is_rainbow = M.knife_rainbow:get_value():get()
    local thickness = M.knife_thickness:get_value():get()

    local local_pos = local_player:get_abs_origin()
    local player_center = vector(local_pos.x, local_pos.y, local_pos.z + 36)

    local d = draw.surface
    local segments = 64

    local points = {}
    local angles = {}
    for i = 0, segments do
        local angle = (i / segments) * math.pi * 2
        angles[i] = angle

        local point = vector(
            player_center.x + math.cos(angle) * knife_range,
            player_center.y + math.sin(angle) * knife_range,
            player_center.z
        )

        local screen_point = math.world_to_screen(point)
        if screen_point then
            points[i] = screen_point
        end
    end

    d.g.anti_alias = true

    for i = 0, segments - 1 do
        if points[i] and points[i+1] then
            local color
            if is_rainbow then

                local time = game.global_vars.real_time * 0.3
                local hue = ((angles[i] / (math.pi * 2)) + time) % 1.0

                local h = hue * 6
                local c = 1
                local x = (1 - math.abs(h % 2 - 1))

                local r, g, b = 0, 0, 0
                if h < 1 then r, g, b = c, x, 0
                elseif h < 2 then r, g, b = x, c, 0
                elseif h < 3 then r, g, b = 0, c, x
                elseif h < 4 then r, g, b = 0, x, c
                elseif h < 5 then r, g, b = x, 0, c
                else r, g, b = c, 0, x end

                color = draw.color(r * 255, g * 255, b * 255, ring_color:get_a())
            else
                color = ring_color
            end

            d:add_line(
                draw.vec2(points[i].x, points[i].y),
                draw.vec2(points[i+1].x, points[i+1].y),
                color,
                thickness
            )
        end
    end

    if points[segments] and points[0] then
        local color = ring_color
        if is_rainbow then
            local time = game.global_vars.real_time * 0.3
            local hue = ((angles[segments] / (math.pi * 2)) + time) % 1.0

            local h = hue * 6
            local c = 1
            local x = (1 - math.abs(h % 2 - 1))

            local r, g, b = 0, 0, 0
            if h < 1 then r, g, b = c, x, 0
            elseif h < 2 then r, g, b = x, c, 0
            elseif h < 3 then r, g, b = 0, c, x
            elseif h < 4 then r, g, b = 0, x, c
            elseif h < 5 then r, g, b = x, 0, c
            else r, g, b = c, 0, x end

            color = draw.color(r * 255, g * 255, b * 255, ring_color:get_a())
        end

        d:add_line(
            draw.vec2(points[segments].x, points[segments].y),
            draw.vec2(points[0].x, points[0].y),
            color,
            thickness
        )
    end

    d.g.anti_alias = false
end

events.present_queue:add(M.render_knife_range)

function M.render_zeus_range()

    local other_visuals_value = M.other_visuals_combo:get_value():get():get_raw()
    if type(other_visuals_value) ~= "number" or bit.band(other_visuals_value, 128) == 0 then
        return
    end

    local local_player = entities.get_local_pawn()
    if not local_player or not local_player:is_alive() then
        return
    end

    local weapon = local_player:get_active_weapon()
    if not weapon or weapon:get_id() ~= weapon_id.taser then
        return
    end

    local zeus_range = M.ZEUS_RANGE
    local ring_color = M.zeus_color:get_value():get()
    local is_rainbow = M.zeus_rainbow:get_value():get()
    local thickness = M.zeus_thickness:get_value():get()

    local local_pos = local_player:get_abs_origin()
    local player_center = vector(local_pos.x, local_pos.y, local_pos.z + 36)

    local d = draw.surface
    local segments = 64

    local points = {}
    local angles = {}
    for i = 0, segments do
        local angle = (i / segments) * math.pi * 2
        angles[i] = angle

        local point = vector(
            player_center.x + math.cos(angle) * zeus_range,
            player_center.y + math.sin(angle) * zeus_range,
            player_center.z
        )

        local screen_point = math.world_to_screen(point)
        if screen_point then
            points[i] = screen_point
        end
    end

    d.g.anti_alias = true

    for i = 0, segments - 1 do
        if points[i] and points[i+1] then
            local color
            if is_rainbow then

                local time = game.global_vars.real_time * 0.3
                local hue = ((angles[i] / (math.pi * 2)) + time) % 1.0

                local h = hue * 6
                local c = 1
                local x = (1 - math.abs(h % 2 - 1))

                local r, g, b = 0, 0, 0
                if h < 1 then r, g, b = c, x, 0
                elseif h < 2 then r, g, b = x, c, 0
                elseif h < 3 then r, g, b = 0, c, x
                elseif h < 4 then r, g, b = 0, x, c
                elseif h < 5 then r, g, b = x, 0, c
                else r, g, b = c, 0, x end

                color = draw.color(r * 255, g * 255, b * 255, ring_color:get_a())
            else
                color = ring_color
            end

            d:add_line(
                draw.vec2(points[i].x, points[i].y),
                draw.vec2(points[i+1].x, points[i+1].y),
                color,
                thickness
            )
        end
    end

    if points[segments] and points[0] then
        local color = ring_color
        if is_rainbow then
            local time = game.global_vars.real_time * 0.3
            local hue = ((angles[segments] / (math.pi * 2)) + time) % 1.0

            local h = hue * 6
            local c = 1
            local x = (1 - math.abs(h % 2 - 1))

            local r, g, b = 0, 0, 0
            if h < 1 then r, g, b = c, x, 0
            elseif h < 2 then r, g, b = x, c, 0
            elseif h < 3 then r, g, b = 0, c, x
            elseif h < 4 then r, g, b = 0, x, c
            elseif h < 5 then r, g, b = x, 0, c
            else r, g, b = c, 0, x end

            color = draw.color(r * 255, g * 255, b * 255, ring_color:get_a())
        end

        d:add_line(
            draw.vec2(points[segments].x, points[segments].y),
            draw.vec2(points[0].x, points[0].y),
            color,
            thickness
        )
    end

    d.g.anti_alias = false
end
events.present_queue:add(M.render_zeus_range)

function M.kill_effects.get_random_text(is_headshot)
    local variations = is_headshot 
        and M.kill_effects.config.headshot_variations 
        or M.kill_effects.config.variations

    local idx = math.random(1, #variations)
    return variations[idx]
end

function M.kill_effects.create_flying_text(text, position, color, size_mult)

    color = color or M.kill_effects.config.color
    size_mult = size_mult or 1.0

    local screen_w, screen_h = game.engine:get_screen_size()

    local angle = math.random() * math.pi * 0.5 - math.pi * 0.25 
    local speed = math.random(M.kill_effects.config.speed_min, M.kill_effects.config.speed_max)
    local vel_x = math.sin(angle) * speed * 0.5  
    local vel_y = -math.cos(angle) * speed       

    local size = math.random() * (M.kill_effects.config.size_max - M.kill_effects.config.size_min) 
                + M.kill_effects.config.size_min
    size = size * size_mult 

    table.insert(M.kill_effects.flying_texts, {
        text = text,
        pos = position,
        vel = draw.vec2(vel_x, vel_y),
        color = color,
        size = size,
        rotation = math.random(-10, 10), 
        creation_time = game.global_vars.real_time,
        lifetime = M.kill_effects.config.text_duration * (0.8 + math.random() * 0.4) 
    })
end

function M.kill_effects.reset_counters()
    M.kill_effects.kill_streak = 0
    M.kill_effects.multi_kill_count = 0
    M.kill_effects.last_kill_time = 0
    M.kill_effects.flying_texts = {}

    if game.engine:in_game() then
        local screen_w, screen_h = game.engine:get_screen_size()
        local center = draw.vec2(screen_w / 2, screen_h / 3)
        M.kill_effects.create_flying_text("NEW ROUND - STREAK RESET", center, draw.color(0, 255, 255, 255), 1.2)
    end
end
function M.kill_effects.process_kill(is_headshot, victim_pos)
    local current_time = game.global_vars.real_time

    M.kill_effects.kill_count = M.kill_effects.kill_count + 1
    M.kill_effects.kill_streak = M.kill_effects.kill_streak + 1

    if current_time - M.kill_effects.last_kill_time < M.kill_effects.multi_kill_timer then
        M.kill_effects.multi_kill_count = M.kill_effects.multi_kill_count + 1
    else
        M.kill_effects.multi_kill_count = 1
    end

    M.kill_effects.last_kill_time = current_time

    local main_text = ""
    local main_color = M.kill_effects.config.color
    local main_size = 1.0

    if is_headshot then
        main_text = M.kill_effects.get_random_text(true)
        main_color = M.kill_effects.config.headshot_color
        main_size = 1.2  
    else
        main_text = M.kill_effects.get_random_text(false)
    end

    M.kill_effects.create_flying_text(main_text, victim_pos, main_color, main_size)

    if M.kill_effects.multi_kill_count >= 2 and M.kill_effects.config.multikill_texts[M.kill_effects.multi_kill_count] then

        local multi_pos = draw.vec2(victim_pos.x + math.random(-40, 40), victim_pos.y + math.random(-40, 40))
        M.kill_effects.create_flying_text(
            M.kill_effects.config.multikill_texts[M.kill_effects.multi_kill_count], 
            multi_pos, 
            M.kill_effects.config.multikill_color, 
            1.3  
        )
    end

    for _, threshold in ipairs(M.kill_effects.config.streak_thresholds) do
        if M.kill_effects.kill_streak == threshold then

            local streak_pos = draw.vec2(victim_pos.x + math.random(-40, 40), victim_pos.y + math.random(-40, 40))
            M.kill_effects.create_flying_text(
                M.kill_effects.config.killstreak_prefix .. M.kill_effects.kill_streak, 
                streak_pos, 
                M.kill_effects.config.streak_color, 
                1.2  
            )
            break
        end
    end
end

function M.kill_effects.process_hit(is_headshot, victim_pos, damage)

    if damage < 5 then return end

    local hit_text
    local hit_color
    local size_factor = M.kill_effects.config.hit_size_factor

    if is_headshot then
        local idx = math.random(1, #M.kill_effects.config.hit_headshot_messages)
        hit_text = M.kill_effects.config.hit_headshot_messages[idx]
        hit_color = M.kill_effects.config.hit_headshot_color
    else
        local idx = math.random(1, #M.kill_effects.config.hit_messages)
        hit_text = M.kill_effects.config.hit_messages[idx]
        hit_color = M.kill_effects.config.hit_color
    end

    hit_text = hit_text .. " -" .. damage

    local hit_pos = draw.vec2(victim_pos.x + math.random(-20, 20), victim_pos.y + math.random(-10, 10))

    local current_time = game.global_vars.real_time

    local angle = math.random() * math.pi * 0.3 - math.pi * 0.15 
    local speed = math.random(M.kill_effects.config.speed_min * 0.7, M.kill_effects.config.speed_max * 0.7) 
    local vel_x = math.sin(angle) * speed * 0.3  
    local vel_y = -math.cos(angle) * speed       

    local size = math.random() * (M.kill_effects.config.size_max - M.kill_effects.config.size_min) 
                * size_factor + M.kill_effects.config.size_min

    table.insert(M.kill_effects.flying_texts, {
        text = hit_text,
        pos = hit_pos,
        vel = draw.vec2(vel_x, vel_y),
        color = hit_color,
        size = size,
        rotation = math.random(-5, 5), 
        creation_time = current_time,
        lifetime = M.kill_effects.config.hit_text_duration * (0.8 + math.random() * 0.2) 
    })
end

function M.kill_effects.process_special_weapon_kill(kill_type, victim_pos)
    local current_time = game.global_vars.real_time

    M.kill_effects.kill_count = M.kill_effects.kill_count + 1
    M.kill_effects.kill_streak = M.kill_effects.kill_streak + 1

    if current_time - M.kill_effects.last_kill_time < M.kill_effects.multi_kill_timer then
        M.kill_effects.multi_kill_count = M.kill_effects.multi_kill_count + 1
    else
        M.kill_effects.multi_kill_count = 1
    end

    M.kill_effects.last_kill_time = current_time

    local main_text = ""
    local main_color = draw.color(255, 255, 255, 255)  
    local size_multiplier = 1.3  

    if kill_type == "knife" then
        if M.kill_effects.config.knife_kill_messages and #M.kill_effects.config.knife_kill_messages > 0 then
            local idx = math.random(1, #M.kill_effects.config.knife_kill_messages)
            main_text = M.kill_effects.config.knife_kill_messages[idx]
        else
            main_text = "KNIFED!"  
        end
        main_color = draw.color(255, 0, 0, 255)  
        size_multiplier = 1.4  

    elseif kill_type == "zeus" then
        if M.kill_effects.config.zeus_kill_messages and #M.kill_effects.config.zeus_kill_messages > 0 then
            local idx = math.random(1, #M.kill_effects.config.zeus_kill_messages)
            main_text = M.kill_effects.config.zeus_kill_messages[idx]
        else
            main_text = "ZAPPED!"  
        end
        main_color = draw.color(255, 255, 0, 255)  
        size_multiplier = 1.4  

    elseif kill_type == "grenade" then
        if M.kill_effects.config.grenade_kill_messages and #M.kill_effects.config.grenade_kill_messages > 0 then
            local idx = math.random(1, #M.kill_effects.config.grenade_kill_messages)
            main_text = M.kill_effects.config.grenade_kill_messages[idx]
        else
            main_text = "FRAGGED!"  
        end
        main_color = M.kill_effects.config.grenade_color or draw.color(255, 100, 0, 255)  
        size_multiplier = 1.4  

    elseif kill_type == "molotov" then
        if M.kill_effects.config.molotov_kill_messages and #M.kill_effects.config.molotov_kill_messages > 0 then
            local idx = math.random(1, #M.kill_effects.config.molotov_kill_messages)
            main_text = M.kill_effects.config.molotov_kill_messages[idx]
        else
            main_text = "BURNED!"  
        end
        main_color = M.kill_effects.config.molotov_color or draw.color(255, 50, 0, 255)  
        size_multiplier = 1.4  

    elseif kill_type == "jumpshot" then
        if M.kill_effects.config.jumpshot_kill_messages and #M.kill_effects.config.jumpshot_kill_messages > 0 then
            local idx = math.random(1, #M.kill_effects.config.jumpshot_kill_messages)
            main_text = M.kill_effects.config.jumpshot_kill_messages[idx]
        else
            main_text = "AIR SHOT!"  
        end
        main_color = M.kill_effects.config.jumpshot_color or draw.color(100, 200, 255, 255)  
        size_multiplier = 1.3  
    end

    M.kill_effects.create_flying_text(main_text, victim_pos, main_color, size_multiplier)

    if M.kill_effects.multi_kill_count >= 2 and M.kill_effects.config.multikill_texts[M.kill_effects.multi_kill_count] then

        local multi_pos = draw.vec2(victim_pos.x + math.random(-40, 40), victim_pos.y + math.random(-40, 40))
        M.kill_effects.create_flying_text(
            M.kill_effects.config.multikill_texts[M.kill_effects.multi_kill_count], 
            multi_pos, 
            M.kill_effects.config.multikill_color, 
            1.3
        )
    end

    for _, threshold in ipairs(M.kill_effects.config.streak_thresholds) do
        if M.kill_effects.kill_streak == threshold then

            local streak_pos = draw.vec2(victim_pos.x + math.random(-40, 40), victim_pos.y + math.random(-40, 40))
            M.kill_effects.create_flying_text(
                M.kill_effects.config.killstreak_prefix .. M.kill_effects.kill_streak, 
                streak_pos, 
                M.kill_effects.config.streak_color, 
                1.2
            )
            break
        end
    end
end
function M.kill_effects.setup_local_tracking()
    local local_controller = entities.get_local_controller()
    if local_controller then

        local player_idx = local_controller.m_iPlayerIndex and local_controller.m_iPlayerIndex:get() or -1
        M.kill_effects.track_id = player_idx
    end
end
function M.kill_effects.update_flying_texts()
    local current_time = game.global_vars.real_time
    local d = draw.surface
    d.font = draw.fonts['gui_title'] 

    for i = #M.kill_effects.flying_texts, 1, -1 do
        local ft = M.kill_effects.flying_texts[i]
        local elapsed = current_time - ft.creation_time

        if elapsed >= ft.lifetime then
            table.remove(M.kill_effects.flying_texts, i)
        else

            local dt = game.global_vars.frame_time
            ft.pos.x = ft.pos.x + ft.vel.x * dt
            ft.pos.y = ft.pos.y + ft.vel.y * dt

            ft.vel.y = ft.vel.y + 50 * dt  
            ft.vel.x = ft.vel.x * 0.98     

            local progress = elapsed / ft.lifetime
            local fade = 1.0

            if progress < 0.1 then
                fade = progress / 0.1  
            elseif progress > 0.7 then
                fade = 1.0 - ((progress - 0.7) / 0.3)  
            end

            local color = draw.color(
                ft.color:get_r(),
                ft.color:get_g(),
                ft.color:get_b(),
                math.floor(ft.color:get_a() * fade)
            )

            local size_factor = ft.size
            if progress < 0.2 then
                size_factor = ft.size * (0.7 + progress * 1.5)  
            elseif progress > 0.8 then
                size_factor = ft.size * (1.0 - (progress - 0.8) * 0.5)  
            end

            local text_size = d.font:get_text_size(ft.text)

            d.g.rotation = ft.rotation * (1 - progress)  

            d:add_text(
                draw.vec2(ft.pos.x - text_size.x/2, ft.pos.y),
                ft.text,
                color
            )

            d.g.rotation = 0
        end
    end
end

function M.on_kill_effects_event(event)

    local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
    if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 32) == 0 then
        return
    end

    local event_name = event:get_name()

    if event_name == "round_start" or event_name == "game_newmap" or 
       event_name == "map_shutdown" or event_name == "cs_win_panel_match" then
        M.kill_effects.reset_counters()
        return
    end

    if event_name == "player_hurt" then
        local attacker = event:get_pawn_from_id("attacker")
        local victim = event:get_pawn_from_id("userid")
        local local_player = entities.get_local_pawn()

        if attacker and local_player and attacker == local_player and victim and victim:is_enemy() then

            local damage = event:get_int("dmg_health")
            local is_headshot = (event:get_int("hitgroup") == 1) 
            local health = event:get_int("health")

            if health > 0 then

                local victim_pos
                local world_pos = victim:get_abs_origin()
                if world_pos then

                    world_pos.z = world_pos.z + 60

                    local screen_pos = math.world_to_screen(world_pos)
                    if screen_pos then
                        victim_pos = screen_pos
                    end
                end

                if not victim_pos then
                    local screen_w, screen_h = game.engine:get_screen_size()
                    victim_pos = draw.vec2(screen_w / 2, screen_h / 2)
                end

                M.kill_effects.process_hit(is_headshot, victim_pos, damage)
            end
        end
    end

    if event_name == "player_death" then

        M.kill_effects.setup_local_tracking()

        local kill_confirmed = false
        local victim_pos = nil
        local is_headshot = false
        local weapon_used = nil

        local attacker = event:get_pawn_from_id("attacker")
        local victim = event:get_pawn_from_id("userid")
        local local_player = entities.get_local_pawn()

        if attacker and local_player and attacker == local_player then
            kill_confirmed = true

            weapon_used = event:get_string("weapon")

            is_headshot = event:get_bool("headshot")

            if victim then
                local world_pos = victim:get_abs_origin()
                if world_pos then

                    world_pos.z = world_pos.z + 60

                    local screen_pos = math.world_to_screen(world_pos)
                    if screen_pos then
                        victim_pos = screen_pos
                    end
                end
            end

            if not victim_pos then
                local screen_w, screen_h = game.engine:get_screen_size()
                victim_pos = draw.vec2(screen_w / 2, screen_h / 2)
            end

            local is_knife_kill = false
            local is_zeus_kill = false
            local is_grenade_kill = false
            local is_molotov_kill = false
            local is_jumpshot_kill = false

            if local_player.m_fFlags then

                local flags = local_player.m_fFlags:get()
                is_jumpshot_kill = (bit.band(flags, 1) == 0)
            end

            if weapon_used then

                is_knife_kill = (
                    weapon_used == "knife" or
                    weapon_used == "knife_t" or
                    string.find(weapon_used, "knife_") ~= nil
                )

                is_zeus_kill = (weapon_used == "taser")

                is_grenade_kill = (weapon_used == "hegrenade")

                is_molotov_kill = (
                    weapon_used == "molotov" or
                    weapon_used == "incgrenade"
                )
            end

            if is_grenade_kill then
                M.kill_effects.process_special_weapon_kill("grenade", victim_pos)
            elseif is_molotov_kill then
                M.kill_effects.process_special_weapon_kill("molotov", victim_pos)
            elseif is_knife_kill then
                M.kill_effects.process_special_weapon_kill("knife", victim_pos)
            elseif is_zeus_kill then
                M.kill_effects.process_special_weapon_kill("zeus", victim_pos)
            elseif is_jumpshot_kill then
                M.kill_effects.process_special_weapon_kill("jumpshot", victim_pos)
            else

                M.kill_effects.process_kill(is_headshot, victim_pos)
            end
        end
    end
end

function M.render_kill_effects()

    local damage_effects_value = M.damage_effects_combo:get_value():get():get_raw()
    if type(damage_effects_value) ~= "number" or bit.band(damage_effects_value, 32) == 0 then
        return
    end

    M.kill_effects.update_flying_texts()
end

mods.events:add_listener("player_hurt")  
events.event:add(M.on_kill_effects_event)
events.present_queue:add(M.render_kill_effects)

function M.flying_hitlogs.create_flying_text(text, position, color, size_mult)

    color = color or M.flying_hitlogs.config.normal_color
    size_mult = size_mult or 1.0

    local angle = math.random() * math.pi * 0.4 - math.pi * 0.2 
    local speed = math.random(M.flying_hitlogs.config.speed_min, M.flying_hitlogs.config.speed_max)
    local vel_x = math.sin(angle) * speed * 0.3  
    local vel_y = -math.cos(angle) * speed       

    local size = math.random() * (M.flying_hitlogs.config.size_max - M.flying_hitlogs.config.size_min) 
                + M.flying_hitlogs.config.size_min
    size = size * size_mult

    table.insert(M.flying_hitlogs.texts, {
        text = text,
        pos = position,
        vel = draw.vec2(vel_x, vel_y),
        color = color,
        size = size,
        rotation = math.random(-5, 5), 
        creation_time = game.global_vars.real_time,
        lifetime = M.flying_hitlogs.config.text_duration * (0.8 + math.random() * 0.4) 
    })
end

function M.flying_hitlogs.process_hit(attacker_name, victim_name, is_headshot, hitbox, damage, health, victim_pos)

    if damage < M.flying_hitlogs.config.hit_min_damage then return end

    local hit_location = ""
    if hitbox == 1 then hit_location = "head"
    elseif hitbox == 2 then hit_location = "chest"
    elseif hitbox == 3 then hit_location = "stomach"
    elseif hitbox == 4 then hit_location = "left arm"
    elseif hitbox == 5 then hit_location = "right arm"
    elseif hitbox == 6 then hit_location = "left leg"
    elseif hitbox == 7 then hit_location = "right leg"
    else hit_location = "body"
    end

    local text = string.format("hit %s in %s for %d damage - %d hp remaining", 
        victim_name, hit_location, damage, health)

    local segments = {
        {text = "hit ", color = M.flying_hitlogs.config.normal_color},
        {text = victim_name, color = M.flying_hitlogs.config.name_color},
        {text = " in ", color = M.flying_hitlogs.config.normal_color},
        {text = hit_location, color = is_headshot and M.flying_hitlogs.config.headshot_color or M.flying_hitlogs.config.normal_color},
        {text = " for ", color = M.flying_hitlogs.config.normal_color},
        {text = tostring(damage), color = M.flying_hitlogs.config.damage_color},
        {text = " damage - ", color = M.flying_hitlogs.config.normal_color},
        {text = tostring(health), color = (health < 30) and M.flying_hitlogs.config.health_low_color or M.flying_hitlogs.config.health_high_color},
        {text = " hp remaining", color = M.flying_hitlogs.config.normal_color}
    }

    local total_chars = 0
    for _, segment in ipairs(segments) do
        total_chars = total_chars + segment.text:len()
    end

    local hit_pos = draw.vec2(
        victim_pos.x + math.random(-20, 20),
        victim_pos.y + math.random(-10, 10)
    )

    table.insert(M.flying_hitlogs.texts, {
        text = text,
        segments = segments,
        pos = hit_pos,
        vel = draw.vec2(
            math.sin(math.random() * math.pi * 0.4 - math.pi * 0.2) * math.random(60, 90) * 0.3,
            -math.cos(math.random() * math.pi * 0.4 - math.pi * 0.2) * math.random(40, 70)  
        ),
        size = math.random() * 0.4 + 0.8,
        rotation = math.random(-3, 3),  
        creation_time = game.global_vars.real_time,
        lifetime = M.flying_hitlogs.config.text_duration,

        typewriter_state = "typing",  
        typewriter_pos = 0,           
        total_chars = total_chars,    
        segment_offsets = {},         

        cumulative_length = 0
    })

    local entry = M.flying_hitlogs.texts[#M.flying_hitlogs.texts]
    local offset = 0
    for i, segment in ipairs(segments) do
        entry.segment_offsets[i] = offset
        offset = offset + segment.text:len()
    end
end

function M.flying_hitlogs.update_texts()
    local current_time = game.global_vars.real_time
    local d = draw.surface
    d.font = draw.fonts['gui_title'] 

    for i = #M.flying_hitlogs.texts, 1, -1 do
        local ft = M.flying_hitlogs.texts[i]
        local elapsed = current_time - ft.creation_time

        if elapsed >= ft.lifetime then
            table.remove(M.flying_hitlogs.texts, i)
        else

            local dt = game.global_vars.frame_time
            ft.pos.x = ft.pos.x + ft.vel.x * dt
            ft.pos.y = ft.pos.y + ft.vel.y * dt

            ft.vel.y = ft.vel.y + 25 * dt  
            ft.vel.x = ft.vel.x * 0.99     

            local progress = elapsed / ft.lifetime

            if progress < 0.45 then
                ft.typewriter_state = "typing"

                ft.typewriter_pos = math.min(
                    ft.total_chars,
                    math.floor(elapsed * M.flying_hitlogs.config.chars_per_second)
                )

            elseif progress < 0.7 then
                ft.typewriter_state = "pausing"
                ft.typewriter_pos = ft.total_chars

            else
                ft.typewriter_state = "backspacing"
                local backspace_time = elapsed - (ft.lifetime * 0.7)
                ft.typewriter_pos = math.max(
                    0,
                    ft.total_chars - math.floor(backspace_time * M.flying_hitlogs.config.backspace_per_second)
                )
            end

            local fade = 1.0

            local old_rotation = d.g.rotation
            d.g.rotation = ft.rotation * (1 - progress * 0.7)  

            if ft.segments then

                local visible_width = 0
                local cursor_segment = nil
                local cursor_pos_in_segment = 0
                local cursor_x = 0

                local chars_counted = 0
                for seg_idx, segment in ipairs(ft.segments) do
                    local seg_start = ft.segment_offsets[seg_idx]
                    local seg_len = segment.text:len()
                    local visible_chars = 0

                    if ft.typewriter_pos > seg_start then
                        visible_chars = math.min(seg_len, ft.typewriter_pos - seg_start)

                        if visible_chars < seg_len and cursor_segment == nil then
                            cursor_segment = seg_idx
                            cursor_pos_in_segment = visible_chars
                        end
                    end

                    if visible_chars > 0 then
                        local visible_text = segment.text:sub(1, visible_chars)
                        visible_width = visible_width + d.font:get_text_size(visible_text).x
                    end

                    chars_counted = chars_counted + visible_chars

                    if cursor_segment == seg_idx and cursor_x == 0 then
                        local cursor_text = segment.text:sub(1, cursor_pos_in_segment)
                        cursor_x = d.font:get_text_size(cursor_text).x
                    end
                end

                local start_x = ft.pos.x - (visible_width / 2)
                local current_x = start_x

                local chars_drawn = 0
                for seg_idx, segment in ipairs(ft.segments) do
                    local seg_start = ft.segment_offsets[seg_idx]
                    local seg_len = segment.text:len()
                    local visible_chars = 0

                    if ft.typewriter_pos > seg_start then
                        visible_chars = math.min(seg_len, ft.typewriter_pos - seg_start)
                    end

                    if visible_chars > 0 then
                        local visible_text = segment.text:sub(1, visible_chars)
                        local color = draw.color(
                            segment.color:get_r(),
                            segment.color:get_g(),
                            segment.color:get_b(),
                            math.floor(segment.color:get_a() * fade)
                        )

                        d:add_text(draw.vec2(current_x, ft.pos.y), visible_text, color)
                        current_x = current_x + d.font:get_text_size(visible_text).x
                        chars_drawn = chars_drawn + visible_chars

                        if cursor_segment == seg_idx and 
                           (math.floor(current_time / M.flying_hitlogs.config.cursor_blink_rate) % 2 == 0) then

                            d:add_rect_filled(
                                draw.rect(
                                    start_x + visible_width, 
                                    ft.pos.y,
                                    start_x + visible_width + 2,
                                    ft.pos.y + d.font:get_text_size("A").y
                                ),
                                color
                            )
                        end
                    end
                end
            else

                local color = draw.color(
                    ft.color:get_r(),
                    ft.color:get_g(),
                    ft.color:get_b(),
                    math.floor(ft.color:get_a() * fade)
                )

                local text_size = d.font:get_text_size(ft.text)

                d:add_text(draw.vec2(ft.pos.x - text_size.x/2, ft.pos.y), ft.text, color)
            end

            d.g.rotation = old_rotation
        end
    end
end

function M.on_flying_hitlogs_event(event)

    if event:get_name() ~= "player_hurt" then return end

    local hitlogs_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(hitlogs_value) ~= "number" or bit.band(hitlogs_value, 128) == 0 then
        return
    end

    local attacker = event:get_pawn_from_id("attacker")
    local victim = event:get_pawn_from_id("userid")
    local local_player = entities.get_local_pawn()

    if attacker and local_player and attacker == local_player and victim and victim:is_enemy() then

        local damage = event:get_int("dmg_health")
        local hitbox = event:get_int("hitgroup")
        local health = event:get_int("health")
        local is_headshot = (hitbox == 1)  

        local attacker_name = "you"
        if attacker.get_name then
            attacker_name = attacker:get_name() or "you"
        end

        local victim_name = "unknown"
        if victim.get_name then 
            victim_name = victim:get_name() or "unknown"
        end

        local victim_pos
        local world_pos = victim:get_abs_origin()
        if world_pos then

            world_pos.z = world_pos.z + 60

            local screen_pos = math.world_to_screen(world_pos)
            if screen_pos then
                victim_pos = screen_pos
            end
        end

        if not victim_pos then
            local screen_w, screen_h = game.engine:get_screen_size()
            victim_pos = draw.vec2(screen_w / 2, screen_h / 2)
        end

        M.flying_hitlogs.process_hit(attacker_name, victim_name, is_headshot, hitbox, damage, health, victim_pos)
    end
end

function M.render_flying_hitlogs()

    local hitlogs_value = M.hitlogs_display_combo:get_value():get():get_raw()
    if type(hitlogs_value) ~= "number" or bit.band(hitlogs_value, 128) == 0 then
        return
    end

    M.flying_hitlogs.update_texts()
end

mods.events:add_listener("player_hurt")  
events.event:add(M.on_flying_hitlogs_event)
events.present_queue:add(M.render_flying_hitlogs)

function M.show_welcome_notification()
    local username = gui.ctx.user and gui.ctx.user.username or "Unknown"
    local message = string.format("Welcome %s, Your Status is Premium", username)
    local notif = gui.notification("Million.lua", message)
    gui.notify:add(notif)
end

M.show_welcome_notification()

events.present_queue:add(M.render_gamesense_watermark)
events.present_queue:add(M.render_apex_watermark)
events.present_queue:add(M.render_bottom_watermark)
events.present_queue:add(M.render_legit_indicators)
events.present_queue:add(M.render_crosshair_indicators) 
events.present_queue:add(M.render_startup_animation)
events.input:add(M.handle_input)
mods.events:add_listener("player_hurt")
events.event:add(M.on_hit)
events.event:add(M.on_hurt)
events.present_queue:add(M.render_apex_style_hitlogs)
events.event:add(M.on_comprehensive_gamesense_hit)
events.present_queue:add(M.render_comprehensive_gamesense_logs)
events.input:add(M.extended_handle_input)
events.event:add(M.gs_on_hit)
events.event:add(M.gs_on_hurt)
events.present_queue:add(M.render_gamesense_hitlog)
events.event:add(M.on_nvidia_hit)
events.event:add(M.handle_hit_notification)
events.event:add(M.handle_hurt_notification)
events.present_queue:add(M.render_nvidia_hitlog)
events.event:add(M.on_nvidia_hurt)
events.event:add(M.on_console_hit_log)
events.event:add(M.on_console_hurt_log)
mods.events:add_listener("bullet_impact")
mods.events:add_listener("player_hurt")
events.event:add(M.on_damage_event)
events.present_queue:add(M.render_damage_numbers)
events.present_queue:add(M.render_hitmarkers)
mods.events:add_listener("player_death")
events.event:add(M.handle_killsay)
events.event:add(M.handle_deathsay)
events.render_start_pre:add(M.update_trail_positions)
events.present_queue:add(M.render_kamidere_keys)
events.present_queue:add(M.render_clarity_keys)
events.present_queue:add(M.render_kz_keys)
events.present_queue:add(M.render_velocity_graph)
events.present_queue:add(M.render_velocity_graphv2)
events.present_queue:add(M.render_velocity_indicator)
events.present_queue:add(M.render_velocity_bar)
events.present_queue:add(M.render_trail)
events.present_queue:add(M.render_enemy_list)
events.input:remove(M.handle_input) 
events.input:add(M.enemy_list_input_handler)
mods.events:add_listener("round_end")
mods.events:add_listener("round_start")
events.event:add(M.on_round_stats_hit)
events.event:add(M.on_round_stats_death)
events.event:add(M.on_round_stats_round_end)
events.event:add(M.on_round_stats_round_start)
events.event:add(M.on_round_stats_game_event)
events.input:add(M.handle_round_stats_input)
events.present_queue:add(M.render_round_stats)