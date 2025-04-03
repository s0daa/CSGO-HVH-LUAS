local aa_title = "Fukushima - aa"
local rage_title = "Fukushima - rage"
local visual_title = "Fukushima - visuals"
local changelog_title = "Fukushima - updates"

local menu_ref = {

    features = menu.add_selection("main", "features", {rage_title, aa_title, visual_title, changelog_title}),
    indicators = menu.add_selection("main", "features", {"none", "Fukushima"}),

    -- masters
    aa_master = menu.add_checkbox("antiaim", "master switch"),
    rage_master = menu.add_checkbox("rage", "master switch"),
    visual_master = menu.add_checkbox("visuals", "master switch"),
    antiaim_method_condition = menu.add_selection("antiaim", "type", {"static", "conditional", "presets"}),
    antiaim_conditions = menu.add_selection("antiaim", "type", {"stand", "run", "slowwalk", "air (not working rn)"}),


    -- changelogs
    text1 = menu.add_text("updates", "- Changelog 0.1 -"),
    text2 = menu.add_text("updates", " > User interface changes"),
    text3 = menu.add_text("updates", " > Force safe MM angles/exploits (still banable)"),
    text4 = menu.add_text("updates", " > Fakelag is limited in MM, beaware max ticks = 6!"),
    text5 = menu.add_text("updates", " > Finally released AA-Builder!"),
    textfinal = menu.add_text("updates", " > Suggestions are welcome on my discord!"),


    -- fakelag
    fakelag = menu.add_checkbox("fakelag", "enable fakelag"),
    fakelag_options = menu.add_selection("fakelag", "fakelag options", {"dynamic", "adaptive", "static"}),
    fakelag_static = menu.add_slider("fakelag", "(static) fakelag", 1, 14),
    fakelag_adaptive_1 = menu.add_slider("fakelag", "(adapative fakelag (1)) fakelag", 1, 14),
    fakelag_adaptive_2 = menu.add_slider("fakelag", "(adapative fakelag (2)) fakelag", 1, 14),
    fakelag_mm_protection = menu.add_checkbox("fakelag", "enable mm-protection"),
    fakelag_text = menu.add_text("fakelag", "mm-protection limits your mm fakelag (removes rubberbanding, unsafe, etc)"),
    fakelag_text2 = menu.add_text("fakelag", "enable on valve servers ^"),












    -- Antiaim builder
    -- static
    static_pitch = menu.add_selection("(static) builder", "pitch", {"none", "down", "up"}),
    static_yawbase = menu.add_selection("(static) builder", "yaw base", {"none", "viewangle", "at target"}),
    static_yawadd = menu.add_slider("(static) builder", "yaw add", -180, 180),
    static_desync_side = menu.add_selection("(static) builder", "desync side", {"none", "left", "right"}),
    static_desynclength = menu.add_slider("(static) builder", "desync max length", 0, 100),




    -- conditional
    stand_pitch = menu.add_selection("(conditional) builder", "(S) pitch", {"none", "down", "up"}),
    stand_yawbase = menu.add_selection("(conditional) builder", "(S) yaw base", {"none", "viewangle", "at target"}), --"none", "viewangle", "at target"
    stand_yawadd_conditions = menu.add_selection("(conditional) builder", "(S) type", {"jitter yaw", "normal yaw"}),


    -- yaw's for jitter
    stand_yawadd_normal = menu.add_slider("(conditional) builder", "(S) yaw add", -180, 180),
    -- else
    stand_yawadd_jitter_1 = menu.add_slider("(conditional) builder", "(S) yaw add jitter (1)", -180, 180),
    stand_yawadd_jitter_2 = menu.add_slider("(conditional) builder", "(S) yaw add jitter (2)", -180, 180),

    -- desync
    stand_desync_side = menu.add_selection("(conditional) builder", "(S) desync side", {"none", "left", "right"}),
    stand_desync_conditions = menu.add_selection("(conditional) builder", "(S) desync side", {"normal desync", "jitter desync"}),
    stand_jitter_desync_right_1 = menu.add_slider("(conditional) builder", "(S) jitter desync (1) right", 0, 100),
    stand_jitter_desync_left_1 = menu.add_slider("(conditional) builder", "(S) jitter desync (1) left", 0, 100),
    stand_jitter_desync_right_2 = menu.add_slider("(conditional) builder", "(S) jitter desync (2) right", 0, 100),
    stand_jitter_desync_left_2 = menu.add_slider("(conditional) builder", "(S) jitter desync (2) left", 0, 100),
    stand_normal_desync_left_1 = menu.add_slider("(conditional) builder", "(S) normal desync (left)", 0, 100),
    stand_normal_desync_right_1 = menu.add_slider("(conditional) builder", "(S) normal desync (right)", 0, 100),
    stand_jitter_options = menu.add_selection("(conditional) builder", "(S) jitter type", {"none", "static"}),
    stand_jitter_value = menu.add_slider("(conditional) builder", "(S) jitter add", -180, 180),

    --run
    run_pitch = menu.add_selection("(conditional) builder", "(R) pitch", {"none", "down", "up"}),
    run_yawbase = menu.add_selection("(conditional) builder", "(R) yaw base", {"none", "viewangle", "at target"}), --"none", "viewangle", "at target"
    run_yawadd_conditions = menu.add_selection("(conditional) builder", "(R) type", {"jitter yaw", "normal yaw"}),


    -- yaw's for jitter
    run_yawadd_normal = menu.add_slider("(conditional) builder", "(R) yaw add", -180, 180),
    -- else
    run_yawadd_jitter_1 = menu.add_slider("(conditional) builder", "(R) yaw add jitter (1)", -180, 180),
    run_yawadd_jitter_2 = menu.add_slider("(conditional) builder", "(R) yaw add jitter (2)", -180, 180),

    -- desync
    run_desync_side = menu.add_selection("(conditional) builder", "(R) desync side", {"none", "left", "right"}),
    run_desync_conditions = menu.add_selection("(conditional) builder", "(R) desync side", {"normal desync", "jitter desync"}),
    run_jitter_desync_right_1 = menu.add_slider("(conditional) builder", "(R) jitter desync (1) right", 0, 100),
    run_jitter_desync_left_1 = menu.add_slider("(conditional) builder", "(R) jitter desync (1) left", 0, 100),
    run_jitter_desync_right_2 = menu.add_slider("(conditional) builder", "(R) jitter desync (2) right", 0, 100),
    run_jitter_desync_left_2 = menu.add_slider("(conditional) builder", "(R) jitter desync (2) left", 0, 100),
    run_normal_desync_left_1 = menu.add_slider("(conditional) builder", "(R) normal desync (left)", 0, 100),
    run_normal_desync_right_1 = menu.add_slider("(conditional) builder", "(R) normal desync (right)", 0, 100),
    run_jitter_options = menu.add_selection("(conditional) builder", "(R) jitter type", {"none", "static"}),
    run_jitter_value = menu.add_slider("(conditional) builder", "(R) jitter add", -180, 180),

    -- slowwalk
    slowwalk_pitch = menu.add_selection("(conditional) builder", "(SL) pitch", {"none", "down", "up"}),
    slowwalk_yawbase = menu.add_selection("(conditional) builder", "(SL) yaw base", {"none", "viewangle", "at target"}), --"none", "viewangle", "at target"
    slowwalk_yawadd_conditions = menu.add_selection("(conditional) builder", "(SL) type", {"jitter yaw", "normal yaw"}),


    -- yaw's for jitter
    slowwalk_yawadd_normal = menu.add_slider("(conditional) builder", "(SL) yaw add", -180, 180),
    -- else
    slowwalk_yawadd_jitter_1 = menu.add_slider("(conditional) builder", "(SL) yaw add jitter (1)", -180, 180),
    slowwalk_yawadd_jitter_2 = menu.add_slider("(conditional) builder", "(SL) yaw add jitter (2)", -180, 180),

    -- desync
    slowwalk_desync_side = menu.add_selection("(conditional) builder", "(SL) desync side", {"none", "left", "right"}),
    slowwalk_desync_conditions = menu.add_selection("(conditional) builder", "(SL) desync side", {"normal desync", "jitter desync"}),
    slowwalk_jitter_desync_right_1 = menu.add_slider("(conditional) builder", "(SL) jitter desync (1) right", 0, 100),
    slowwalk_jitter_desync_left_1 = menu.add_slider("(conditional) builder", "(SL) jitter desync (1) left", 0, 100),
    slowwalk_jitter_desync_right_2 = menu.add_slider("(conditional) builder", "(SL) jitter desync (2) right", 0, 100),
    slowwalk_jitter_desync_left_2 = menu.add_slider("(conditional) builder", "(SL) jitter desync (2) left", 0, 100),
    slowwalk_normal_desync_left_1 = menu.add_slider("(conditional) builder", "(SL) normal desync (left)", 0, 100),
    slowwalk_normal_desync_right_1 = menu.add_slider("(conditional) builder", "(SL) normal desync (right)", 0, 100),
    slowwalk_jitter_options = menu.add_selection("(conditional) builder", "(SL) jitter type", {"none", "static"}),
    slowwalk_jitter_value = menu.add_slider("(conditional) builder", "(SL) jitter add", -180, 180),

    -- air
    air_pitch = menu.add_selection("(conditional) builder", "(AIR) pitch", {"none", "down", "up"}),
    air_yawbase = menu.add_selection("(conditional) builder", "(AIR) yaw base", {"none", "viewangle", "at target"}), --"none", "viewangle", "at target"
    air_yawadd_conditions = menu.add_selection("(conditional) builder", "(AIR) type", {"jitter yaw", "normal yaw"}),


    -- yaw's for jitter
    air_yawadd_normal = menu.add_slider("(conditional) builder", "(AIR) yaw add", -180, 180),
    -- else
    air_yawadd_jitter_1 = menu.add_slider("(conditional) builder", "(AIR) yaw add jitter (1)", -180, 180),
    air_yawadd_jitter_2 = menu.add_slider("(conditional) builder", "(AIR) yaw add jitter (2)", -180, 180),

    -- desync
    air_desync_side = menu.add_selection("(conditional) builder", "(AIR) desync side", {"none", "left", "right"}),
    air_desync_conditions = menu.add_selection("(conditional) builder", "(AIR) desync side", {"normal desync", "jitter desync"}),
    air_jitter_desync_right_1 = menu.add_slider("(conditional) builder", "(AIR) jitter desync (1) right", 0, 100),
    air_jitter_desync_left_1 = menu.add_slider("(conditional) builder", "(AIR) jitter desync (1) left", 0, 100),
    air_jitter_desync_right_2 = menu.add_slider("(conditional) builder", "(AIR) jitter desync (2) right", 0, 100),
    air_jitter_desync_left_2 = menu.add_slider("(conditional) builder", "(AIR) jitter desync (2) left", 0, 100),
    air_normal_desync_left_1 = menu.add_slider("(conditional) builder", "(AIR) normal desync (left)", 0, 100),
    air_normal_desync_right_1 = menu.add_slider("(conditional) builder", "(AIR) normal desync (right)", 0, 100),
    air_jitter_options = menu.add_selection("(conditional) builder", "(AIR) jitter type", {"none", "static"}),
    air_jitter_value = menu.add_slider("(conditional) builder", "(AIR) jitter add", -180, 180),

}

menu_ref.text1:set_visible(false)
menu_ref.text2:set_visible(false)
menu_ref.text3:set_visible(false)
menu_ref.text4:set_visible(false)
menu_ref.text5:set_visible(false)
menu_ref.antiaim_conditions:set_visible(false)
menu_ref.textfinal:set_visible(false)
menu_ref.aa_master:set_visible(false)
menu_ref.rage_master:set_visible(false)
menu_ref.visual_master:set_visible(false)
menu_ref.antiaim_method_condition:set_visible(false)
menu_ref.static_pitch:set_visible(false)
menu_ref.static_yawbase:set_visible(false)
menu_ref.static_desync_side:set_visible(false)
menu_ref.static_desynclength:set_visible(false)
menu_ref.static_yawadd:set_visible(false)
menu_ref.stand_pitch:set_visible(false)
menu_ref.stand_yawbase:set_visible(false)
menu_ref.stand_yawadd_conditions:set_visible(false)
menu_ref.stand_yawadd_jitter_1:set_visible(false)
menu_ref.stand_yawadd_jitter_2:set_visible(false)
menu_ref.stand_yawadd_normal:set_visible(false)
menu_ref.stand_desync_side:set_visible(false)
menu_ref.stand_jitter_desync_left_1:set_visible(false)
menu_ref.stand_jitter_desync_right_1:set_visible(false)
menu_ref.stand_jitter_desync_left_2:set_visible(false)
menu_ref.stand_jitter_desync_right_2:set_visible(false)
menu_ref.stand_desync_conditions:set_visible(false)
menu_ref.stand_normal_desync_left_1:set_visible(false)
menu_ref.stand_normal_desync_right_1:set_visible(false)
menu_ref.stand_jitter_options:set_visible(false)
menu_ref.stand_jitter_value:set_visible(false)
menu_ref.fakelag_adaptive_1:set_visible(false)
menu_ref.fakelag_adaptive_2:set_visible(false)
menu_ref.fakelag_options:set_visible(false)
menu_ref.fakelag:set_visible(false)
menu_ref.fakelag_mm_protection:set_visible(false)
menu_ref.fakelag_text:set_visible(false)
menu_ref.fakelag_text2:set_visible(false)
menu_ref.run_pitch:set_visible(false)
menu_ref.run_yawbase:set_visible(false)
menu_ref.run_yawadd_conditions:set_visible(false)
menu_ref.run_yawadd_jitter_1:set_visible(false)
menu_ref.run_yawadd_jitter_2:set_visible(false)
menu_ref.run_yawadd_normal:set_visible(false)
menu_ref.run_desync_side:set_visible(false)
menu_ref.run_jitter_desync_left_1:set_visible(false)
menu_ref.run_jitter_desync_right_1:set_visible(false)
menu_ref.run_jitter_desync_left_2:set_visible(false)
menu_ref.run_jitter_desync_right_2:set_visible(false)
menu_ref.run_desync_conditions:set_visible(false)
menu_ref.run_normal_desync_left_1:set_visible(false)
menu_ref.run_normal_desync_right_1:set_visible(false)
menu_ref.run_jitter_options:set_visible(false)
menu_ref.run_jitter_value:set_visible(false)
menu_ref.slowwalk_pitch:set_visible(false)
menu_ref.slowwalk_yawbase:set_visible(false)
menu_ref.slowwalk_yawadd_conditions:set_visible(false)
menu_ref.slowwalk_yawadd_jitter_1:set_visible(false)
menu_ref.slowwalk_yawadd_jitter_2:set_visible(false)
menu_ref.slowwalk_yawadd_normal:set_visible(false)
menu_ref.slowwalk_desync_side:set_visible(false)
menu_ref.slowwalk_jitter_desync_left_1:set_visible(false)
menu_ref.slowwalk_jitter_desync_right_1:set_visible(false)
menu_ref.slowwalk_jitter_desync_left_2:set_visible(false)
menu_ref.slowwalk_jitter_desync_right_2:set_visible(false)
menu_ref.slowwalk_desync_conditions:set_visible(false)
menu_ref.slowwalk_normal_desync_left_1:set_visible(false)
menu_ref.slowwalk_normal_desync_right_1:set_visible(false)
menu_ref.slowwalk_jitter_options:set_visible(false)
menu_ref.slowwalk_jitter_value:set_visible(false)
menu_ref.air_pitch:set_visible(false)
menu_ref.air_yawbase:set_visible(false)
menu_ref.air_yawadd_conditions:set_visible(false)
menu_ref.air_yawadd_jitter_1:set_visible(false)
menu_ref.air_yawadd_jitter_2:set_visible(false)
menu_ref.air_yawadd_normal:set_visible(false)
menu_ref.air_desync_side:set_visible(false)
menu_ref.air_jitter_desync_left_1:set_visible(false)
menu_ref.air_jitter_desync_right_1:set_visible(false)
menu_ref.air_jitter_desync_left_2:set_visible(false)
menu_ref.air_jitter_desync_right_2:set_visible(false)
menu_ref.air_desync_conditions:set_visible(false)
menu_ref.air_normal_desync_left_1:set_visible(false)
menu_ref.air_normal_desync_right_1:set_visible(false)
menu_ref.air_jitter_options:set_visible(false)
menu_ref.air_jitter_value:set_visible(false)
menu_ref.indicators:set_visible(false)





local finds = {

    pitch = menu.find("antiaim", "main", "angles", "pitch"),
    yawbase = menu.find("antiaim", "main", "angles", "yaw base"),
    yawadd = menu.find("antiaim", "main", "angles", "yaw add"),
    jittermode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitteradd = menu.find("antiaim", "main", "angles", "jitter add"),
    desync_side = menu.find("antiaim", "main", "desync", "side"),
    left_amount = menu.find("antiaim", "main", "desync", "left amount"),
    right_amount = menu.find("antiaim", "main", "desync", "right amount"),
    fakelag_amount = menu.find("antiaim", "main", "fakelag", "amount"),
}


local function handle_menu(watermark_text)

    if (menu_ref.features:get() == 4) then
        menu_ref.text1:set_visible(true)
        menu_ref.text2:set_visible(true)
        menu_ref.text3:set_visible(true)
        menu_ref.text4:set_visible(true)
        menu_ref.text5:set_visible(true)
        menu_ref.textfinal:set_visible(true)
    else
        menu_ref.text1:set_visible(false)
        menu_ref.text2:set_visible(false)
        menu_ref.text3:set_visible(false)
        menu_ref.text4:set_visible(false)
        menu_ref.text5:set_visible(false)
        menu_ref.textfinal:set_visible(false)
    end

    if (menu_ref.features:get() == 2) then
        menu_ref.aa_master:set_visible(true)
    else
        menu_ref.aa_master:set_visible(false)
    end



    if (menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.features:get() == 2) then
        menu_ref.antiaim_method_condition:set_visible(true)
        menu_ref.fakelag:set_visible(true)
    else
        menu_ref.antiaim_method_condition:set_visible(false)
        menu_ref.fakelag:set_visible(false)
    end

    if (menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.features:get() == 2 and menu_ref.fakelag:get() == true) then
        menu_ref.fakelag_options:set_visible(true)
        menu_ref.fakelag_mm_protection:set_visible(true)
        menu_ref.fakelag_text:set_visible(true)
        menu_ref.fakelag_text2:set_visible(true)
    else
        menu_ref.fakelag_options:set_visible(false)
        menu_ref.fakelag_mm_protection:set_visible(false)
        menu_ref.fakelag_text:set_visible(false)
        menu_ref.fakelag_text2:set_visible(false)
    end

    if (menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.features:get() == 2 and menu_ref.fakelag_options:get() == 3) then
        menu_ref.fakelag_static:set_visible(true)
    else
        menu_ref.fakelag_static:set_visible(false)
    end

    if (menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.features:get() == 2 and menu_ref.fakelag_options:get() == 2) then
        menu_ref.fakelag_adaptive_1:set_visible(true)
        menu_ref.fakelag_adaptive_2:set_visible(true)
    else
        menu_ref.fakelag_adaptive_1:set_visible(false)
        menu_ref.fakelag_adaptive_2:set_visible(false)
    end

    if (menu_ref.features:get() == 3 ) then
        menu_ref.visual_master:set_visible(true)
    else
        menu_ref.visual_master:set_visible(false)
    end

    if (menu_ref.features:get() == 3 and menu_ref.visual_master:get() == true) then
        menu_ref.indicators:set_visible(true)
    else
        menu_ref.indicators:set_visible(false)
    end

    





    -- aa

    if (menu_ref.antiaim_method_condition:get() == 1 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true) then
        menu_ref.static_pitch:set_visible(true)
        menu_ref.static_yawbase:set_visible(true)
        menu_ref.static_desync_side:set_visible(true)
        menu_ref.static_desynclength:set_visible(true)
        menu_ref.static_yawadd:set_visible(true)
    else
        menu_ref.static_pitch:set_visible(false)
        menu_ref.static_yawbase:set_visible(false)
        menu_ref.static_desync_side:set_visible(false)
        menu_ref.static_desynclength:set_visible(false)
        menu_ref.static_yawadd:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true) then
        menu_ref.antiaim_conditions:set_visible(true)
    else
        menu_ref.antiaim_conditions:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1) then
        menu_ref.stand_pitch:set_visible(true)
        menu_ref.stand_yawbase:set_visible(true)
        menu_ref.stand_yawadd_conditions:set_visible(true)
        menu_ref.stand_desync_side:set_visible(true)
        menu_ref.stand_desync_conditions:set_visible(true)
        menu_ref.stand_jitter_options:set_visible(true)
    else
        menu_ref.stand_pitch:set_visible(false)
        menu_ref.stand_yawbase:set_visible(false)
        menu_ref.stand_yawadd_conditions:set_visible(false)
        menu_ref.stand_desync_conditions:set_visible(false)
        menu_ref.stand_desync_side:set_visible(false)
        menu_ref.stand_jitter_options:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1 and menu_ref.stand_yawadd_conditions:get() == 2) then
        menu_ref.stand_yawadd_normal:set_visible(true)
    else
        menu_ref.stand_yawadd_normal:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1 and menu_ref.stand_yawadd_conditions:get() == 1) then
        menu_ref.stand_yawadd_jitter_1:set_visible(true)
        menu_ref.stand_yawadd_jitter_2:set_visible(true)
    else
        menu_ref.stand_yawadd_jitter_1:set_visible(false)
        menu_ref.stand_yawadd_jitter_2:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1 and menu_ref.stand_desync_conditions:get() == 2) then
        menu_ref.stand_jitter_desync_left_1:set_visible(true)
        menu_ref.stand_jitter_desync_right_1:set_visible(true)
        menu_ref.stand_jitter_desync_left_2:set_visible(true)
        menu_ref.stand_jitter_desync_right_2:set_visible(true)
    else
        menu_ref.stand_jitter_desync_left_1:set_visible(false)
        menu_ref.stand_jitter_desync_right_1:set_visible(false)
        menu_ref.stand_jitter_desync_left_2:set_visible(false)
        menu_ref.stand_jitter_desync_right_2:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1 and menu_ref.stand_desync_conditions:get() == 1) then
        menu_ref.stand_normal_desync_left_1:set_visible(true)
        menu_ref.stand_normal_desync_right_1:set_visible(true)
    else
        menu_ref.stand_normal_desync_left_1:set_visible(false)
        menu_ref.stand_normal_desync_right_1:set_visible(false)
    end

    if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 1 and menu_ref.stand_jitter_options:get() == 2) then
        menu_ref.stand_jitter_value:set_visible(true)
    else
        menu_ref.stand_jitter_value:set_visible(false)
    end


    -- running

    

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true) then
    menu_ref.antiaim_conditions:set_visible(true)
else
    menu_ref.antiaim_conditions:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2) then
    menu_ref.run_pitch:set_visible(true)
    menu_ref.run_yawbase:set_visible(true)
    menu_ref.run_yawadd_conditions:set_visible(true)
    menu_ref.run_desync_side:set_visible(true)
    menu_ref.run_desync_conditions:set_visible(true)
    menu_ref.run_jitter_options:set_visible(true)
else
    menu_ref.run_pitch:set_visible(false)
    menu_ref.run_yawbase:set_visible(false)
    menu_ref.run_yawadd_conditions:set_visible(false)
    menu_ref.run_desync_conditions:set_visible(false)
    menu_ref.run_desync_side:set_visible(false)
    menu_ref.run_jitter_options:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2 and menu_ref.run_yawadd_conditions:get() == 2) then
    menu_ref.run_yawadd_normal:set_visible(true)
else
    menu_ref.run_yawadd_normal:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2 and menu_ref.run_yawadd_conditions:get() == 1) then
    menu_ref.run_yawadd_jitter_1:set_visible(true)
    menu_ref.run_yawadd_jitter_2:set_visible(true)
else
    menu_ref.run_yawadd_jitter_1:set_visible(false)
    menu_ref.run_yawadd_jitter_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2 and menu_ref.run_desync_conditions:get() == 2) then
    menu_ref.run_jitter_desync_left_1:set_visible(true)
    menu_ref.run_jitter_desync_right_1:set_visible(true)
    menu_ref.run_jitter_desync_left_2:set_visible(true)
    menu_ref.run_jitter_desync_right_2:set_visible(true)
else
    menu_ref.run_jitter_desync_left_1:set_visible(false)
    menu_ref.run_jitter_desync_right_1:set_visible(false)
    menu_ref.run_jitter_desync_left_2:set_visible(false)
    menu_ref.run_jitter_desync_right_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2 and menu_ref.run_desync_conditions:get() == 1) then
    menu_ref.run_normal_desync_left_1:set_visible(true)
    menu_ref.run_normal_desync_right_1:set_visible(true)
else
    menu_ref.run_normal_desync_left_1:set_visible(false)
    menu_ref.run_normal_desync_right_1:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 2 and menu_ref.run_jitter_options:get() == 2) then
    menu_ref.run_jitter_value:set_visible(true)
else
    menu_ref.run_jitter_value:set_visible(false)
end

-- slowwalk
if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true) then
    menu_ref.antiaim_conditions:set_visible(true)
else
    menu_ref.antiaim_conditions:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3) then
    menu_ref.slowwalk_pitch:set_visible(true)
    menu_ref.slowwalk_yawbase:set_visible(true)
    menu_ref.slowwalk_yawadd_conditions:set_visible(true)
    menu_ref.slowwalk_desync_side:set_visible(true)
    menu_ref.slowwalk_desync_conditions:set_visible(true)
    menu_ref.slowwalk_jitter_options:set_visible(true)
else
    menu_ref.slowwalk_pitch:set_visible(false)
    menu_ref.slowwalk_yawbase:set_visible(false)
    menu_ref.slowwalk_yawadd_conditions:set_visible(false)
    menu_ref.slowwalk_desync_conditions:set_visible(false)
    menu_ref.slowwalk_desync_side:set_visible(false)
    menu_ref.slowwalk_jitter_options:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3 and menu_ref.slowwalk_yawadd_conditions:get() == 2) then
    menu_ref.slowwalk_yawadd_normal:set_visible(true)
else
    menu_ref.slowwalk_yawadd_normal:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3 and menu_ref.slowwalk_yawadd_conditions:get() == 1) then
    menu_ref.slowwalk_yawadd_jitter_1:set_visible(true)
    menu_ref.slowwalk_yawadd_jitter_2:set_visible(true)
else
    menu_ref.slowwalk_yawadd_jitter_1:set_visible(false)
    menu_ref.slowwalk_yawadd_jitter_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3 and menu_ref.slowwalk_desync_conditions:get() == 2) then
    menu_ref.slowwalk_jitter_desync_left_1:set_visible(true)
    menu_ref.slowwalk_jitter_desync_right_1:set_visible(true)
    menu_ref.slowwalk_jitter_desync_left_2:set_visible(true)
    menu_ref.slowwalk_jitter_desync_right_2:set_visible(true)
else
    menu_ref.slowwalk_jitter_desync_left_1:set_visible(false)
    menu_ref.slowwalk_jitter_desync_right_1:set_visible(false)
    menu_ref.slowwalk_jitter_desync_left_2:set_visible(false)
    menu_ref.slowwalk_jitter_desync_right_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3 and menu_ref.slowwalk_desync_conditions:get() == 1) then
    menu_ref.slowwalk_normal_desync_left_1:set_visible(true)
    menu_ref.slowwalk_normal_desync_right_1:set_visible(true)
else
    menu_ref.slowwalk_normal_desync_left_1:set_visible(false)
    menu_ref.slowwalk_normal_desync_right_1:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 3 and menu_ref.slowwalk_jitter_options:get() == 2) then
    menu_ref.slowwalk_jitter_value:set_visible(true)
else
    menu_ref.slowwalk_jitter_value:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true) then
    menu_ref.antiaim_conditions:set_visible(true)
else
    menu_ref.antiaim_conditions:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4) then
    menu_ref.air_pitch:set_visible(true)
    menu_ref.air_yawbase:set_visible(true)
    menu_ref.air_yawadd_conditions:set_visible(true)
    menu_ref.air_desync_side:set_visible(true)
    menu_ref.air_desync_conditions:set_visible(true)
    menu_ref.air_jitter_options:set_visible(true)
else
    menu_ref.air_pitch:set_visible(false)
    menu_ref.air_yawbase:set_visible(false)
    menu_ref.air_yawadd_conditions:set_visible(false)
    menu_ref.air_desync_conditions:set_visible(false)
    menu_ref.air_desync_side:set_visible(false)
    menu_ref.air_jitter_options:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4 and menu_ref.air_yawadd_conditions:get() == 2) then
    menu_ref.air_yawadd_normal:set_visible(true)
else
    menu_ref.air_yawadd_normal:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4 and menu_ref.air_yawadd_conditions:get() == 1) then
    menu_ref.air_yawadd_jitter_1:set_visible(true)
    menu_ref.air_yawadd_jitter_2:set_visible(true)
else
    menu_ref.air_yawadd_jitter_1:set_visible(false)
    menu_ref.air_yawadd_jitter_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4 and menu_ref.air_desync_conditions:get() == 2) then
    menu_ref.air_jitter_desync_left_1:set_visible(true)
    menu_ref.air_jitter_desync_right_1:set_visible(true)
    menu_ref.air_jitter_desync_left_2:set_visible(true)
    menu_ref.air_jitter_desync_right_2:set_visible(true)
else
    menu_ref.air_jitter_desync_left_1:set_visible(false)
    menu_ref.air_jitter_desync_right_1:set_visible(false)
    menu_ref.air_jitter_desync_left_2:set_visible(false)
    menu_ref.air_jitter_desync_right_2:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4 and menu_ref.air_desync_conditions:get() == 1) then
    menu_ref.air_normal_desync_left_1:set_visible(true)
    menu_ref.air_normal_desync_right_1:set_visible(true)
else
    menu_ref.air_normal_desync_left_1:set_visible(false)
    menu_ref.air_normal_desync_right_1:set_visible(false)
end

if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.features:get() == 2 and menu_ref.aa_master:get() == true and menu_ref.antiaim_conditions:get() == 4 and menu_ref.air_jitter_options:get() == 2) then
    menu_ref.air_jitter_value:set_visible(true)
else
    menu_ref.air_jitter_value:set_visible(false)
end




end

callbacks.add(e_callbacks.DRAW_WATERMARK, handle_menu)


local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end



local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait2(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end

local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait3(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end



local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait4(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end

local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait5(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end



local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait6(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end

local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait7(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end



local old_time = global_vars.cur_time()
local should_shift = false
local do_init = false
local function wait8(time, func)

    if not do_init then
        old_time = old_time + time
        do_init = true
    end

    if (should_shift) then
        old_time = global_vars.cur_time() + time
        should_shift = false
    end

    if global_vars.cur_time() > old_time then
        if not func then
            should_shift = true
            return true
        else
            func()
            should_shift = true

        end
    end

    if not func then
        return false
    end
end

local function antiaim_handle(ctx)

    -- setup shit
    local ingame = engine.is_in_game()
    local plr = entity_list.get_local_player()
    if not plr or not plr:is_alive() then
        return
    end

    if not ingame then
        return
    end


    local velocity_array = plr:get_prop("m_vecVelocity")
    local speed = velocity_array.x
    local height = plr:get_prop("m_vecVelocity[2]")
    local duck_amount = plr:get_prop("m_flDuckAmount") -- note goes from 0 - 0-850 or something but just say > 0.5
    local is_slowwalking = menu.find("misc", "main", "movement", "slow walk")
    local in_air = false
    if (height > 10 or height < -10) then in_air = true end


    if (speed > 1 and in_air == false and is_slowwalking[2]:get() == false or speed < -1 and in_air == false and is_slowwalking[2]:get() == false) then
        -- run
        if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true) then
            -- conditional
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true) then
                -- conditional
                finds.yawbase:set(menu_ref.run_yawbase:get())
                finds.pitch:set(menu_ref.run_pitch:get())
                
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.run_yawadd_conditions:get() == 1) then
                    finds.yawadd:set(menu_ref.run_yawadd_jitter_1:get())
                    wait(0.03, function()
                        finds.yawadd:set(menu_ref.run_yawadd_jitter_2:get()) 
                    end)
                end
            
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.run_yawadd_conditions:get() == 2) then
                    finds.yawadd:set(menu_ref.run_yawadd_normal:get())
                end
            
                finds.desync_side:set(menu_ref.run_desync_side:get())
            
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.run_desync_conditions:get() == 1) then
                    finds.left_amount:set(menu_ref.run_normal_desync_left_1:get())
                    finds.right_amount:set(menu_ref.run_normal_desync_right_1:get())
                end
            
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.run_desync_conditions:get() == 2) then
                    finds.left_amount:set(menu_ref.run_jitter_desync_left_1:get())
                    finds.right_amount:set(menu_ref.run_jitter_desync_right_1:get())
                    wait2(0.03, function()
                        finds.left_amount:set(menu_ref.run_jitter_desync_left_2:get())
                        finds.right_amount:set(menu_ref.run_jitter_desync_right_2:get())
                    end)
                end
            end
            
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.run_jitter_options:get() == 1) then
                finds.jitteradd:set(menu_ref.run_jitter_value:get())
            else
                finds.jitteradd:set(0)
            end
        
        end
        
        end
        
    if (is_slowwalking[2]:get() == true) then
        -- slowwalk
        if (menu_ref.antiaim_method_condition:get() == 2 and menu_ref.aa_master:get() == true) then
            -- conditional
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true) then
                -- conditional
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true) then
                    -- conditional
                    finds.yawbase:set(menu_ref.slowwalk_yawbase:get())
                    finds.pitch:set(menu_ref.slowwalk_pitch:get())
                    
                    if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.slowwalk_yawadd_conditions:get() == 1) then
                        finds.yawadd:set(menu_ref.slowwalk_yawadd_jitter_1:get())
                        wait5(0.03, function()
                            finds.yawadd:set(menu_ref.slowwalk_yawadd_jitter_2:get()) 
                        end)
                    end
                
                    if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.slowwalk_yawadd_conditions:get() == 2) then
                        finds.yawadd:set(menu_ref.slowwalk_yawadd_normal:get())
                    end
                
                    finds.desync_side:set(menu_ref.slowwalk_desync_side:get())
                
                    if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.slowwalk_desync_conditions:get() == 1) then
                        finds.left_amount:set(menu_ref.slowwalk_normal_desync_left_1:get())
                        finds.right_amount:set(menu_ref.slowwalk_normal_desync_right_1:get())
                    end
                
                    if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.slowwalk_desync_conditions:get() == 2) then
                        finds.left_amount:set(menu_ref.slowwalk_jitter_desync_left_1:get())
                        finds.right_amount:set(menu_ref.slowwalk_jitter_desync_right_1:get())
                        wait6(0.03, function()
                            finds.left_amount:set(menu_ref.slowwalk_jitter_desync_left_2:get())
                            finds.right_amount:set(menu_ref.slowwalk_jitter_desync_right_2:get())
                        end)
                    end
                end
                
                if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.slowwalk_jitter_options:get() == 1) then
                    finds.jitteradd:set(menu_ref.slowwalk_jitter_value:get())
                else
                    finds.jitteradd:set(0)
                end
            
            end

        end

    end

    if (height > 1 or height < -1) then
        -- air
        

    end

    if (speed < 1 and is_slowwalking[2]:get() == false or speed < -1 and is_slowwalking[2]:get() == false) then
        -- stand
        if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true) then
            -- conditional
            finds.yawbase:set(menu_ref.stand_yawbase:get())
            finds.pitch:set(menu_ref.stand_pitch:get())
            
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.stand_yawadd_conditions:get() == 1) then
                finds.yawadd:set(menu_ref.stand_yawadd_jitter_1:get())
                wait3(0.03, function()
                    finds.yawadd:set(menu_ref.stand_yawadd_jitter_2:get()) 
                end)
            end
        
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.stand_yawadd_conditions:get() == 2) then
                finds.yawadd:set(menu_ref.stand_yawadd_normal:get())
            end
        
            finds.desync_side:set(menu_ref.stand_desync_side:get())
        
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.stand_desync_conditions:get() == 1) then
                finds.left_amount:set(menu_ref.stand_normal_desync_left_1:get())
                finds.right_amount:set(menu_ref.stand_normal_desync_right_1:get())
            end
        
            if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.stand_desync_conditions:get() == 2) then
                finds.left_amount:set(menu_ref.stand_jitter_desync_left_1:get())
                finds.right_amount:set(menu_ref.stand_jitter_desync_right_1:get())
                wait4(0.03, function()
                    finds.left_amount:set(menu_ref.stand_jitter_desync_left_2:get())
                    finds.right_amount:set(menu_ref.stand_jitter_desync_right_2:get())
                end)
            end
        end
        
        if (menu_ref.antiaim_method_condition:get() == 2  and menu_ref.aa_master:get() == true and menu_ref.stand_jitter_options:get() == 1) then
            finds.jitteradd:set(menu_ref.stand_jitter_value:get())
        else
            finds.jitteradd:set(0)
        end
        
        
        end

    --print(is_slowwalking[2]:get())

    if (menu_ref.antiaim_method_condition:get() == 1  and menu_ref.aa_master:get() == true ) then

        finds.yawbase:set(menu_ref.static_yawbase:get())
        finds.yawadd:set(menu_ref.static_yawadd:get())
        finds.pitch:set(menu_ref.static_pitch:get())
        finds.desync_side:set(menu_ref.static_desync_side:get())
        finds.left_amount:set(menu_ref.static_desynclength:get())
        finds.right_amount:set(menu_ref.static_desynclength:get())

    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 2 and not menu_ref.fakelag_mm_protection:get() == true) then
        finds.fakelag_amount:set(menu_ref.fakelag_adaptive_1:get())
        wait7(0.03, function()
            finds.fakelag_amount:set(menu_ref.fakelag_adaptive_2:get())
        end)
    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 3 and not menu_ref.fakelag_mm_protection:get() == true) then
        finds.fakelag_amount:set(menu_ref.fakelag_static:get())
    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 2 and menu_ref.fakelag_mm_protection:get() == true) then
        finds.fakelag_amount:set(menu_ref.fakelag_adaptive_1:get() / 2 - 1)
        wait7(0.03, function()
            finds.fakelag_amount:set(menu_ref.fakelag_adaptive_2:get() / 2 - 1)
        end)
    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 1 and  menu_ref.fakelag_mm_protection:get() == true) then
        finds.fakelag_amount:set(menu_ref.fakelag_static:get() / 2 - 1)
    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 1 and  menu_ref.fakelag_mm_protection:get() == false) then
        finds.fakelag_amount:set(14)
    end

    if (menu_ref.fakelag:get() == true and menu_ref.fakelag_options:get() == 1 and  menu_ref.fakelag_mm_protection:get() == true) then
        finds.fakelag_amount:set(6)
    end







    -- conditions


end

callbacks.add(e_callbacks.ANTIAIM, antiaim_handle)


local main_font = render.create_font("Verdana Bold", 12, 600,  e_font_flags.REGULAR, e_font_flags.DROPSHADOW)
local sub_font = render.create_font("Verdana Bold", 10, 600,  e_font_flags.REGULAR, e_font_flags.DROPSHADOW)

local function indicators(watermark_text)
    local ingame = engine.is_in_game()
    local plr = entity_list.get_local_player()
    if not plr or not plr:is_alive() then
        return
    end

    if not ingame then
        return
    end

    local scoped = plr:get_prop("m_bIsScoped")
    local doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
    local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
    local auto_direction = menu.find("antiaim", "main", "auto direction", "enable")
    local size_unscoped = 950
    local size_scoped = 970
    

    if (scoped == 0 and menu_ref.indicators:get() == 2) then
        render.text(main_font, "Fukushima", vec2_t(950, 550), color_t(242, 245, 66, 255))
        if (doubletap[2]:get() == true) then
            render.text(sub_font, "DT", vec2_t(size_unscoped, 560), color_t(255, 255, 255, 255))
            size_unscoped = size_unscoped + 15
        end

        if (hideshots[2]:get() == true and menu_ref.indicators:get() == 2) then
            render.text(sub_font, "HS", vec2_t(size_unscoped, 560), color_t(255, 255, 255, 255))
            size_unscoped = size_unscoped + 15
        end

        if (auto_direction[2]:get() == true and menu_ref.indicators:get() == 2) then
            render.text(sub_font, "FS", vec2_t(size_unscoped, 560), color_t(255, 255, 255, 255))
            size_unscoped = size_unscoped + 15
        end


    end

    if (scoped == 1 and menu_ref.indicators:get() == 2) then
        render.text(main_font, "Fukushima", vec2_t(970, 550), color_t(242, 245, 66, 255))
        if (doubletap[2]:get() == true) then
            render.text(sub_font, "DT", vec2_t(size_scoped, 560), color_t(255, 255, 255, 255))
            size_scoped = size_scoped + 15
        end
        if (hideshots[2]:get() == true and menu_ref.indicators:get() == 2) then
            render.text(sub_font, "HS", vec2_t(size_scoped, 560), color_t(255, 255, 255, 255))
            size_scoped = size_scoped + 15
        end

        if (auto_direction[2]:get() == true and menu_ref.indicators:get() == 2) then
            render.text(sub_font, "FS", vec2_t(size_scoped, 560), color_t(255, 255, 255, 255))
            size_scoped = size_scoped + 15
        end
    else
        -- nothing

    end



    



end

callbacks.add(e_callbacks.DRAW_WATERMARK, indicators)