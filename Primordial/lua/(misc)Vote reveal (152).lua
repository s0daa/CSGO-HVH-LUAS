local chat_lib_name = "chat" --change this if you already have it saved as something else


local status, chat_print = pcall(function () return require(chat_lib_name) end)
local options = menu.add_multi_selection("vote reveal", "log type", {"screen log", "console log", "chat log"})

if not status and string.find(chat_print, "module '" .. chat_lib_name .. "' not found: unknown module, make sure the file is in primordial/scripts/include") then
    local set_clipboard = function (text) ffi.cast("void(__thiscall*)(void*, const char*, int)", memory.get_vfunc(memory.create_interface("vgui2.dll", "VGUI_System010"), 9))(ffi.cast("void*",0), text, #text) end
    menu.add_text("vote reveal", " ")
    menu.add_text("vote reveal", "missing chat printing library (from hause.288)")
    menu.add_text("vote reveal", "download from link below")
    menu.add_text("vote reveal", "place in primordial/scripts/include/chat.lua")

    options:set_items({"screen log", "console log"})

    menu.add_button("vote reveal", "copy link", function ()
        set_clipboard("https://primordial.dev/resources/chat-printing-lib.128/")
        local copied = menu.add_text("vote reveal", "link copied!")
        client.delay_call(function ()
            copied:set_visible(false)
        end, 3)
    end)
end

callbacks.add(e_callbacks.EVENT, function (event)
    if event.name == "vote_cast" then
        local option = { text = "[NO]", color = color_t(255, 0, 0), chat_color = "{red}" }
        local name = entity_list.get_entity(event.entityid):get_name()
        if event.vote_option == 0 then
            option = { text = "[YES]", color = color_t(0, 255, 0), chat_color = "{green}" }
        end
    
        if options:get("screen log") then
            client.log_screen(color_t(0, 161, 255), name, color_t(255, 255, 255), " voted ", option.color, option.text)
        end
        if options:get("console log") then
            client.log(color_t(0, 161, 255), name, color_t(255, 255, 255), " voted ", option.color, option.text)
        end
        if options:get("chat log") then
            chat_print.print("{blue}" .. name .. "{white} voted " .. option.chat_color .. option.text)
        end
    end
end)