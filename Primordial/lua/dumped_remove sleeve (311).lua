function on_draw_model(ctx)
    if ctx.model_name:find("v_sleeve") == nil then 
       return
    end

    ctx.override_original = true
    
 end
 
 callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)