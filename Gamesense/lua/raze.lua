--@description: просто пиздец какой-то
--@author: а какая разница

local http = require 'gamesense/http'
local base64 = require 'gamesense/base64'

local menu do
    menu = { }

    menu.scoreboard = ui.new_checkbox('MISC', 'Miscellaneous', 'shared icon in scoreboard')
end

local DEBUG_LEVEL = 0

local GITHUB_TOKEN = "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"
local REPO_OWNER = "uwukson4799"
local REPO_NAME = "asterisk"
local FILE_PATH = "players.json"

local news_container = panorama.loadstring([[
    var panel = null;
    var js_news = null;
    var original_transform = null;
    var original_visibility = null;

    var _Create = function() {
        js_news = $.GetContextPanel().FindChildTraverse("JsNewsContainer");
        if (!js_news) {
            return;
        }

        original_transform = js_news.style.transform || 'none';
        original_visibility = js_news.style.visibility || 'visible';

        js_news.style.transform = 'translate3d(-9999px, -9999px, 0)';
        js_news.style.visibility = 'collapse';

        var parent = js_news.GetParent();
        if (!parent) {
            return;
        }
    
        panel = $.CreatePanel("Panel", parent, "news_panel");
        if(!panel) {
            return;
        }

        parent.MoveChildBefore(panel, js_news);
    };

    var _Destroy = function() {
        if (js_news) {
            if (panel) {
                panel.DeleteAsync(0.0);
                panel = null;
            }

            js_news.style.transform = original_transform;
            js_news.style.visibility = original_visibility;
        }
    };

    return {
        create: _Create,
        destroy: _Destroy,
    };

]], "CSGOMainMenu")()

local menu_container = panorama.loadstring([[
    var _change = function() {
        var mainMenuPanel = $.GetContextPanel().FindChildTraverse("MainMenu");
        if (!mainMenuPanel) return;

        var characterPreviewPanel = $.GetContextPanel().FindChildTraverse("JsMainmenu_Vanity");
        if (characterPreviewPanel) {
            characterPreviewPanel.style.backgroundSize = 'contain';
            characterPreviewPanel.style.backgroundPosition = 'center';
            characterPreviewPanel.style.backgroundRepeat = 'no-repeat';

            characterPreviewPanel.SetScene(
                "resource/ui/econ/ItemModelPanelCharWeaponInspect.res",
                "",
                false
            );

            characterPreviewPanel.SetCameraPreset(1, false);
        }
    };

    var _restore = function() {
        var mainMenuPanel = $.GetContextPanel().FindChildTraverse("MainMenu");
        if (mainMenuPanel) {
            var characterPreviewPanel = $.GetContextPanel().FindChildTraverse("JsMainmenu_Vanity");
            if (characterPreviewPanel) {
                characterPreviewPanel.style.backgroundImage = 'none';
                characterPreviewPanel.style.backgroundSize = 'auto';
                characterPreviewPanel.style.backgroundPosition = '0% 0%';
                characterPreviewPanel.style.backgroundRepeat = 'repeat';
                
                characterPreviewPanel.SetScene(
                    "resource/ui/econ/ItemModelPanelCharMainMenu.res",
                    "models/player/custom_player/legacy/ctm_sas.mdl",
                    false
                );

                characterPreviewPanel.SetCameraPreset(1, false);
            }
        }
    };

    var mainMenuRoot = $.GetContextPanel().FindChildTraverse("MainMenu");
    if (mainMenuRoot) {
        $.RegisterEventHandler('PropertyTransitionEnd', mainMenuRoot, function(panelName, propertyName) {
            if (propertyName === 'opacity' || propertyName === 'visibility') {
                _change();
            }
        });
    }

    return {
        change: _change,
        restore: _restore
    };
]], "CSGOMainMenu")()

local background_container = panorama.loadstring([[
    var _ChangeBackground = function(imageUrl) {
        var movieElements = [
            "MainMenuMovie",
            "MainMenuMovieParent",
            "MoviePlayer"
        ];
        
        movieElements.forEach(function(id) {
            var element = $.GetContextPanel().FindChildTraverse(id);
            if (element) {
                element.style.opacity = "0";
                element.style.visibility = "collapse";
            }
        });
        
        var bgElements = [
            "MainMenuBackground",
            "MainMenu",
            "MainMenuContainerPanel"
        ];
        
        bgElements.forEach(function(id) {
            var panel = $.GetContextPanel().FindChildTraverse(id);
            if (panel) {
                panel.style.backgroundImage = 'url("' + imageUrl + '")';
                panel.style.backgroundPosition = 'center';
                panel.style.backgroundSize = 'cover';
                panel.style.backgroundRepeat = 'no-repeat';
                panel.style.opacity = "1";
            }
        });
    };

    var _RestoreDefault = function() {
        var movieElements = [
            "MainMenuMovie",
            "MainMenuMovieParent",
            "MoviePlayer"
        ];
        
        movieElements.forEach(function(id) {
            var element = $.GetContextPanel().FindChildTraverse(id);
            if (element) {
                element.style.opacity = "1";
                element.style.visibility = "visible";
            }
        });
        
        var bgElements = [
            "MainMenuBackground",
            "MainMenu",
            "MainMenuContainerPanel"
        ];
        
        bgElements.forEach(function(id) {
            var panel = $.GetContextPanel().FindChildTraverse(id);
            if (panel) {
                panel.style.backgroundImage = 'none';
            }
        });
    };

    return {
        change: _ChangeBackground,
        restore: _RestoreDefault
    };
]], "CSGOMainMenu")()

local logo_container = panorama.loadstring([[
  var panel = null;
  var cs_logo = null;
  var original_transform = null;
  var original_visibility = null;

  var _Create = function() {
    cs_logo = $.GetContextPanel().FindChildTraverse("MainMenuNavBarHome");
    if (!cs_logo) {
      return;
    }

    original_transform = cs_logo.style.transform || 'none';
    original_visibility = cs_logo.style.visibility || 'visible';

    cs_logo.style.transform = 'translate3d(-9999px, -9999px, 0)';
    cs_logo.style.visibility = 'collapse';

    var parent = cs_logo.GetParent();
    if (!parent) {
      return;
    }

    panel = $.CreatePanel("Panel", parent, "logo_panel");
    if (!panel) {
      return;
    }

    if (!panel.BLoadLayoutFromString(`<root>
  <Panel class="mainmenu-navbar__btn-small mainmenu-navbar__btn-home">
    <RadioButton id="main_menu"
      onactivate="MainMenu.OnHomeButtonPressed(); $.DispatchEvent( 'PlaySoundEffect', 'UIPanorama.mainmenu_press_home', 'MOUSE' ); $.DispatchEvent('PlayMainMenuMusic', true, true); GameInterfaceAPI.SetSettingString('panorama_play_movie_ambient_sound', '1');"
      oncancel="MainMenu.OnEscapeKeyPressed();"
      onmouseover="UiToolkitAPI.ShowTextTooltip( 'main_menu', 'RAZE CLUB');"
      onmouseout="UiToolkitAPI.HideTextTooltip();">
      <Image textureheight="90" texturewidth="-1" src="https://razeclub.ru/styles/razehack/png/logo.png" />
    </RadioButton>
  </Panel>
    </root>`, false, false)) {
      panel.DeleteAsync(0);
      panel = null;
      return;
    }

    parent.MoveChildBefore(panel, parent.GetChild(0));
  };

  var _Destroy = function() {
    if (cs_logo) {
      if (panel) {
        panel.DeleteAsync(0.0);
        panel = null;
      }

      cs_logo.style.transform = original_transform;
      cs_logo.style.visibility = original_visibility;
    }
  };

  return {
    create: _Create,
    destroy: _Destroy,
  };
]], "CSGOMainMenu")()

local alert_color = panorama.loadstring([[
    var _set_style = function() {
        var notifications = [
            "NotificationsContainer",
            "JsGameNotifications",
            "MainMenuNotifications",
            "CSGONotifications",
            "NotificationsPanelContainer"
        ];
        
        notifications.forEach(function(id) {
            var panel = $.GetContextPanel().FindChildTraverse(id);
            if (panel) {
                panel.style.backgroundColor = "rgb(255, 255, 255)";
                panel.style.border = "0px solid rgb(255, 255, 255, 0.0)";
                panel.style.borderRadius = "0px";
                
                var allElements = panel.Children();
                var processElement = function(element) {
                    if (element.style) {
                        element.style.color = "rgb(0, 0, 0)";
                        element.style.fontSize = "19px";
                        element.style.fontWeight = "bold";
                    }
                    
                    var children = element.Children();
                    if (children) {
                        children.forEach(processElement);
                    }
                };
                
                allElements.forEach(processElement);
            }
        });
    };

    var _reset_style = function() {
        var notifications = [
            "NotificationsContainer",
            "JsGameNotifications",
            "MainMenuNotifications",
            "CSGONotifications",
            "NotificationsPanelContainer"
        ];
        
        notifications.forEach(function(id) {
            var panel = $.GetContextPanel().FindChildTraverse(id);
            if (panel) {
                panel.style.backgroundColor = "#E1C111"; // uwukson: shit code but it works
                panel.style.border = "2px solid #E1C111"; // uwukson: shit code but it works
                panel.style.borderRadius = "0px";
                
                var allElements = panel.Children();
                var resetElement = function(element) {
                    if (element.style) {
                        element.style.color = "#000000";
                        element.style.fontSize = "19px";
                        element.style.fontWeight = "normal";
                    }
                    
                    var children = element.Children();
                    if (children) {
                        children.forEach(resetElement);
                    }
                };
                
                allElements.forEach(resetElement);
            }
        });
    };

    return {
        set: _set_style,
        reset: _reset_style
    };
]], "CSGOMainMenu")()

local image_2_nickname = panorama.loadstring([[
    var panel = null;
    var name_panel = null;

    var _Create = function(imageLink) {
        name_panel = $.GetContextPanel().FindChildTraverse("JsPlayerName");
        
        if (!name_panel) {
            return;
        }

        var parent = name_panel.GetParent();
        if (!parent) {
            return;
        }

        parent.style.flowChildren = "right";

        panel = $.CreatePanel("Panel", parent, "custom_image_panel");
        if (!panel) {
            return;
        }

        var layout = `
        <root>
            <Panel style="flow-children: right; margin-right: 5px;">
                <Image textureheight="48" texturewidth="48" src="` + imageLink + `" />
            </Panel>
        </root>
        `;

        if (!panel.BLoadLayoutFromString(layout, false, false)) {
            panel.DeleteAsync(0);
            panel = null;
            return;
        }

        parent.MoveChildBefore(panel, name_panel);
    };

    var _Destroy = function() {
        if (panel) {
            panel.DeleteAsync(0.0);
            panel = null;
        }
    };

    return {
        add: _Create,
        remove: _Destroy
    };
]], "CSGOMainMenu")()

local watch_button = panorama.loadstring([[
    var panel = null;
    var watch_btn = null;
    var original_transform = null;
    var original_visibility = null;

    var _Create = function() {
        watch_btn = $.GetContextPanel().FindChildTraverse("MainMenuNavBarWatch"); // MainMenuNavBarStats
        
        if (!watch_btn) {
            return;
        }

        original_transform = watch_btn.style.transform || 'none';
        original_visibility = watch_btn.style.visibility || 'visible';
        
        watch_btn.style.transform = 'translate3d(-9999px, -9999px, 0)';
        watch_btn.style.visibility = 'collapse';

        var parent = watch_btn.GetParent();
        if (!parent) {
            return;
        }

        panel = $.CreatePanel("RadioButton", parent, "custom_watch_button");
        if (!panel) {
            return;
        }

        parent.MoveChildBefore(panel, watch_btn);
    };

    var _Destroy = function() {
        if (watch_btn) {
            if (panel) {
                panel.DeleteAsync(0.0);
                panel = null;
            }
            watch_btn.style.transform = original_transform;
            watch_btn.style.visibility = original_visibility;
        }
    };

    return {
        hide: _Create,
        show: _Destroy
    };
]], "CSGOMainMenu")()

local stats_button = panorama.loadstring([[
    var panel = null;
    var watch_btn = null;
    var original_transform = null;
    var original_visibility = null;

    var _Create = function() {
        watch_btn = $.GetContextPanel().FindChildTraverse("MainMenuNavBarStats");
        
        if (!watch_btn) {
            return;
        }

        original_transform = watch_btn.style.transform || 'none';
        original_visibility = watch_btn.style.visibility || 'visible';
        
        watch_btn.style.transform = 'translate3d(-9999px, -9999px, 0)';
        watch_btn.style.visibility = 'collapse';

        var parent = watch_btn.GetParent();
        if (!parent) {
            return;
        }

        panel = $.CreatePanel("RadioButton", parent, "custom_stats_button");
        if (!panel) {
            return;
        }

        parent.MoveChildBefore(panel, watch_btn);
    };

    var _Destroy = function() {
        if (watch_btn) {
            if (panel) {
                panel.DeleteAsync(0.0);
                panel = null;
            }
            watch_btn.style.transform = original_transform;
            watch_btn.style.visibility = original_visibility;
        }
    };

    return {
        hide: _Create,
        show: _Destroy
    };
]], "CSGOMainMenu")()

local hvh_button = panorama.loadstring([[
    var panel = null;
    var original_button = null;
    var original_transform = null;
    var original_visibility = null;

    var _Create = function() {
        var navBar = $.GetContextPanel().FindChildTraverse("JsMainMenuNavBar");
        if (!navBar) return;

        original_button = navBar.GetChild(2);
        if (!original_button) return;

        original_transform = original_button.style.transform || 'none';
        original_visibility = original_button.style.visibility || 'visible';
        
        original_button.style.transform = 'translate3d(-9999px, -9999px, 0)';
        original_button.style.visibility = 'collapse';

        panel = $.CreatePanel("RadioButton", navBar, "hvh_button");
        if (!panel) return;

        var layout = `
            <root>
                <RadioButton class="mainmenu-navbar__btn-small mainmenu-navbar__btn hvh_button"
                            group="NavBar"
                            onactivate="$.DispatchEvent('PlaySoundEffect', 'mainmenu_press_GO', 'MOUSE'); SteamOverlayAPI.OpenExternalBrowserURL('https://hvh.gg/server?version=csgo2023');"
                            onmouseover=""
                            onmouseout="">
                    <Image textureheight="64" 
                        texturewidth="64" 
                        src="https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/HVH.png"
                        style="vertical-align: center; horizontal-align: center; margin: 4px;" />
                </RadioButton>
            </root>`;

        if (!panel.BLoadLayoutFromString(layout, false, false)) {
            panel.DeleteAsync(0);
            panel = null;
            return;
        }

        navBar.MoveChildBefore(panel, original_button);
    };

    var _Destroy = function() {
        if (original_button) {
            if (panel) {
                panel.DeleteAsync(0.0);
                panel = null;
            }
            original_button.style.transform = original_transform;
            original_visibility = original_visibility;
        }
    };

    return {
        add: _Create,
        remove: _Destroy
    };
]], "CSGOMainMenu")()

local forum_button = panorama.loadstring([[
    var panel
    var _Create = function() {
        var parent = $.GetContextPanel().FindChildTraverse("JsMainMenuNavBar")
        panel = $.CreatePanel("Panel", parent, "forum_button")
        if(!panel)
            return

        if(!panel.BLoadLayoutFromString(`<root>  
                    <RadioButton class="mainmenu-navbar__btn-small"
                                group="NavBar"
                                onactivate="$.DispatchEvent('PlaySoundEffect', 'mainmenu_press_GO', 'MOUSE'); SteamOverlayAPI.OpenExternalBrowserURL('https://razeclub.ru/forums/');"
                                oncancel="MainMenu.OnEscapeKeyPressed();"
                                onmouseover=""
                                onmouseout="">
                        <Image textureheight="32" 
                            texturewidth="-1" 
                            src="https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/2_forum.png"
                            style="vertical-align: center; horizontal-align: center;" />
                    </RadioButton>
            </root>`, false, false))
            return

        parent.MoveChildBefore(panel, parent.GetChild(13))
    }

    var _Destroy = function() {
        if(panel != null) {
            panel.RemoveAndDeleteChildren()
            panel.DeleteAsync(0.0)
            panel = null
        }
    }

    return {
        add: _Create,
        remove: _Destroy,
        get_panel: function() { return panel; }
    }
]], "CSGOMainMenu")()

local button_under = panorama.loadstring([[
    var panel
    var _Create = function(forumPanel) {
        var parent = $.GetContextPanel().FindChildTraverse("JsMainMenuNavBar")
        panel = $.CreatePanel("Panel", parent, "button_under")
        if(!panel)
            return

        if(!panel.BLoadLayoutFromString(`<root>  
            <RadioButton class="mainmenu-navbar__btn-small"
                        group="NavBar"
                        onactivate="$.DispatchEvent('PlaySoundEffect', 'mainmenu_press_GO', 'MOUSE'); SteamOverlayAPI.OpenExternalBrowserURL('https://t.me/raze_club');"
                        oncancel="MainMenu.OnEscapeKeyPressed();">
                <Image textureheight="40" 
                       texturewidth="-1" 
                       src="https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/tg.png"
                       style="vertical-align: center; horizontal-align: center;" />
            </RadioButton>
        </root>`, false, false))
            return

        //var index = parent.GetChildIndex(forumPanel) + 1
        //parent.MoveChildBefore(panel, parent.GetChild(index))
        parent.MoveChildBefore(panel, parent.GetChild(13))
    }

    var _Destroy = function() {
        if(panel != null) {
            panel.RemoveAndDeleteChildren()
            panel.DeleteAsync(0.0)
            panel = null
        }
    }

    return {
        add: _Create,
        remove: _Destroy,
    }
]], "CSGOMainMenu")()

local loading_background = panorama.loadstring([[
    var _ChangeLoadingBackground = function() {
        var loadingScreen = $.GetContextPanel();
        if (!loadingScreen) return;

        var mapImage = loadingScreen.FindChildTraverse("BackgroundMapImage");
        if (!mapImage) return;

        mapImage.SetImage("https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/background.png");
        mapImage.style.width = "100%";
        mapImage.style.height = "100%";
        mapImage.style.backgroundPosition = 'center';
        mapImage.style.backgroundSize = 'cover';
        mapImage.style.backgroundRepeat = 'no-repeat';
        mapImage.style.opacity = "1";
        mapImage.style.blur = "gaussian(3)";
    };

    var _StartUpdate = function() {
        _ChangeLoadingBackground();
        $.Schedule(0.1, _StartUpdate);
    };

    $.RegisterForUnhandledEvent('PopulateLoadingScreen', _ChangeLoadingBackground);
    $.RegisterForUnhandledEvent('QueueConnectToServer', _ChangeLoadingBackground);
    $.RegisterForUnhandledEvent('OnMapConfigLoaded', _ChangeLoadingBackground);
    $.RegisterForUnhandledEvent('UnloadLoadingScreenAndReinit', _ChangeLoadingBackground);

    _StartUpdate();

    return {
        change: _ChangeLoadingBackground
    };
]], "CSGOLoadingScreen")()

local game_background = panorama.loadstring([[
    var _ChangeLoadingBackground = function(imageUrl) {
        var loadingScreen = $.GetContextPanel().FindChildTraverse("LoadingScreen");
        if (!loadingScreen) return;

        var mapBackground = loadingScreen.FindChildTraverse("MapBackgroundImage");
        if (!mapBackground) return;

        mapBackground.style.backgroundImage = 'url("' + imageUrl + '")';
        mapBackground.style.backgroundPosition = 'center';
        mapBackground.style.backgroundSize = 'cover';
        mapBackground.style.backgroundRepeat = 'no-repeat';
        mapBackground.style.opacity = "1";
    };

    $.RegisterForUnhandledEvent('CSGOShowMainMenu', function() {
        _ChangeLoadingBackground("' + imageUrl + '");
    });

    return {
        change: _ChangeLoadingBackground
    };
]], "CSGOLoadingScreen")()

local scoreboard_images = panorama.loadstring([[
    var panel = null;
    var name_panels = {};
    var target_players = {};

    var _Update = function(players) {
        _Destroy();
        target_players = players || {};
        let scoreboard = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard");
        
        if (!scoreboard) return;

        scoreboard.FindChildrenWithClassTraverse("sb-row").forEach(function(row) {
            if (target_players[row.m_xuid]) {
                // Apply background and border
                row.style.backgroundColor = "rgb(0, 0, 0)";
                row.style.border = "1px solid rgb(94, 94, 94)";
                
                // Apply text styles
                row.Children().forEach(function(child) {
                    let nameLabel = child.FindChildTraverse("name");
                    if (nameLabel) {
                        nameLabel.style.color = "rgb(155, 155, 155)";
                        nameLabel.style.fontFamily = "Stratum2 Bold Monodigit";
                        nameLabel.style.fontWeight = "bold";
                    }

                    // Add icon
                    if (nameLabel) {
                        let parent = nameLabel.GetParent();
                        parent.style.flowChildren = "left";

                        let image_panel = $.CreatePanel("Panel", parent, "custom_image_panel_" + row.m_xuid);
                        let layout = `
                        <root>
                            <Panel style="flow-children: left; margin-right: 5px;">
                                <Image textureheight="24" texturewidth="24" src="https://razeclub.ru/styles/razehack/png/logo.png" />
                            </Panel>
                        </root>
                        `;

                        image_panel.BLoadLayoutFromString(layout, false, false);
                        parent.MoveChildBefore(image_panel, nameLabel);
                        name_panels[row.m_xuid] = image_panel;
                    }
                });
            }
        });
    };


    var _Destroy = function() {
        let scoreboard = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard");
        
        if (scoreboard) {
            scoreboard.FindChildrenWithClassTraverse("sb-row").forEach(function(row) {
                row.style.backgroundColor = null;
                row.style.border = null;
                
                row.Children().forEach(function(child) {
                    let nameLabel = child.FindChildTraverse("name");
                    if (nameLabel) {
                        nameLabel.style.color = null;
                        nameLabel.style.fontFamily = "Stratum2";
                        nameLabel.style.fontWeight = "normal";
                    }
                });
            });
        }

        for (let xuid in name_panels) {
            if (name_panels[xuid] && name_panels[xuid].IsValid()) {
                name_panels[xuid].DeleteAsync(0.0);
            }
        }
        
        name_panels = {};
        target_players = {};
    };

    return {
        update: _Update,
        remove: _Destroy
    };
]], "CSGOHud")()

loading_background.change()
game_background.change("https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/background.png")
--forum_button.add()
button_under.add()
hvh_button.add()
watch_button.hide()
stats_button.hide()
image_2_nickname.add("https://razeclub.ru/styles/razehack/png/logo.png")
alert_color.set()
logo_container.create()
background_container.change("https://raw.githubusercontent.com/uwukson4799/asterisk/refs/heads/main/background.png")
menu_container.change()
news_container.create()

client.set_event_callback('shutdown', function()
    --forum_button.remove()
    button_under.remove()
    hvh_button.remove()
    watch_button.show()
    stats_button.show()
    image_2_nickname.remove()
    menu_container.restore()
    news_container.destroy()
    logo_container.destroy()
    background_container.restore()
    alert_color.reset()
end)

local function update_github_file(steamid, action)
    local headers = {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Accept"] = "application/vnd.github.v3+json"
    }
    
    local api_url = string.format(
        "https://api.github.com/repos/%s/%s/contents/%s",
        REPO_OWNER, REPO_NAME, FILE_PATH
    )

    http.get(api_url, {headers = headers}, function(success, response)
        if not success then return end
        
        local current_data = {}
        local sha = nil
        
        if response.status == 200 then
            local content = json.parse(response.body)
            sha = content.sha
            current_data = json.parse(base64.decode(content.content))
        end
        
        if action == "add" then
            current_data[tostring(steamid)] = true
        else
            current_data[tostring(steamid)] = nil
        end
        
        local update_data = {
            message = string.format("update - %s %s", action, steamid),
            content = base64.encode(json.stringify(current_data)),
            sha = sha
        }
        
        http.put(api_url, {
            headers = headers,
            body = json.stringify(update_data)
        }, function(success, response)
            if success then
                if DEBUG_LEVEL > 1 then
                    print("[shared] successfully fully updated")
                end
            end
        end)
    end)
end

scoreboard_images.update(target_players)

local function get_local_steamid()
    return tostring(panorama.open().MyPersonaAPI.GetXuid())
end

client.set_event_callback("player_connect_full", function(e)
    local steamid = get_local_steamid()
    if steamid then
        update_github_file(steamid, "add")

        local target = client.userid_to_entindex(e.userid)
        if target == entity.get_local_player() then
            scoreboard_images.remove()
            client.delay_call(0.5, function()
                scoreboard_images.update(target_players)
            end)
        else
            scoreboard_images.remove()
            client.delay_call(0.5, function()
                scoreboard_images.update(target_players)
            end)
        end
    end
end)

local function update_target_players(github_data)
    target_players = {}
    for steamid, _ in pairs(github_data) do
        target_players[steamid] = true
    end
    scoreboard_images.update(target_players)
end

local function check_and_update_github()
    local headers = {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Accept"] = "application/vnd.github.v3+json"
    }
    
    local api_url = string.format(
        "https://api.github.com/repos/%s/%s/contents/%s",
        REPO_OWNER, REPO_NAME, FILE_PATH
    )

    http.get(api_url, {headers = headers}, function(success, response)
        if success and response.status == 200 then
            local content = json.parse(response.body)
            local current_data = json.parse(base64.decode(content.content))
            update_target_players(current_data)
            if DEBUG_LEVEL > 0 then
                print("[shared] successfully updated")
            end
        end
    end)
end

check_and_update_github()

local last_update = 0
local last_github_check = 0
client.set_event_callback('paint', function()
    local current_time = globals.realtime()
    if current_time - last_update >= 3.0 then
        scoreboard_images.update(target_players)
        last_update = current_time
    end

    if current_time - last_github_check >= 1.5 then
        check_and_update_github()
        last_github_check = current_time
    end

    ui.set_callback(menu.scoreboard, function()
        local steamid = get_local_steamid()
        if not ui.get(menu.scoreboard) then
            scoreboard_images.remove()
            update_github_file(steamid, "remove")
        else
            update_github_file(steamid, "add")
            check_and_update_github()
        end
    end)
end)

client.set_event_callback("shutdown", function()
    local steamid = get_local_steamid()
    if steamid then
        scoreboard_images.remove()
        update_github_file(steamid, "remove")
    end
end)

do
    --local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_random_int, client_latency, client_set_clan_tag, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_visible, client_exec, client_delay_call, client_set_cvar, client_eye_position, client_draw_hitboxes, client_camera_angles, client_open_panorama_context, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.random_int, client.latency, client.set_clan_tag, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.visible, client.exec, client.delay_call, client.set_cvar, client.eye_position, client.draw_hitboxes, client.camera_angles, client.open_panorama_context, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_hotkey, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_mouse_position, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_hotkey, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.mouse_position, ui.new_button, ui.new_multiselect, ui.get
local renderer_load_svg, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_triangle, renderer_measure_text, renderer_world_to_screen, renderer_indicator, renderer_texture = renderer.load_svg, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.triangle, renderer.measure_text, renderer.world_to_screen, renderer.indicator, renderer.texture
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local mat_ambient_light_r, mat_ambient_light_g, mat_ambient_light_b = cvar.mat_ambient_light_r, cvar.mat_ambient_light_g, cvar.mat_ambient_light_b
local r_modelAmbientMin = cvar.r_modelAmbientMin

local wallcolor_reference = ui.new_checkbox("VISUALS", "Effects", "Wall Color")
local wallcolor_color_reference = ui.new_color_picker("VISUALS", "Effects", "Wall Color", 255, 0, 0, 128)

local bloom_reference = ui.new_slider("VISUALS", "Effects", "Bloom scale", -1, 500, -1, true, nil, 0.01, {[-1]="Off"})
local exposure_reference = ui.new_slider("VISUALS", "Effects", "Auto Exposure", -1, 2000, -1, true, nil, 0.001, {[-1]="Off"})
local model_ambient_min_reference = ui.new_slider("VISUALS", "Effects", "Minimum model brightness", 0, 1000, -1, true, nil, 0.05)

local max_val = 1

local bloom_default, exposure_min_default, exposure_max_default
local bloom_prev, exposure_prev, model_ambient_min_prev, wallcolor_prev

local function reset_bloom(tone_map_controller)
	if bloom_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 0)
		entity_set_prop(tone_map_controller, "m_flCustomBloomScale", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 1)
		entity_set_prop(tone_map_controller, "m_flCustomBloomScale", bloom_default)
	end
end

local function reset_exposure(tone_map_controller)
	if exposure_min_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 0)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 1)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", exposure_min_default)
	end
	if exposure_max_default == -1 then
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 0)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", 0)
	else
		entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 1)
		entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", exposure_max_default)
	end
end

local function on_paint()
	local wallcolor = ui_get(wallcolor_reference)
	if wallcolor or wallcolor_prev then
		if wallcolor then
			local r, g, b, a = ui_get(wallcolor_color_reference)
			r, g, b = r/255, g/255, b/255
			local a_temp = a / 128 - 1
			local r_res, g_res, b_res
			if a_temp > 0 then
				local multiplier = 900^(a_temp) - 1
				a_temp = a_temp * multiplier
				r_res, g_res, b_res = r*a_temp, g*a_temp, b*a_temp
			else
				a_temp = a_temp * max_val
				r_res, g_res, b_res = (1-r)*a_temp, (1-g)*a_temp, (1-b)*a_temp
			end
			if mat_ambient_light_r:get_float() ~= r_res or mat_ambient_light_g:get_float() ~= g_res or mat_ambient_light_b:get_float() ~= b_res then
				mat_ambient_light_r:set_raw_float(r_res)
				mat_ambient_light_g:set_raw_float(g_res)
				mat_ambient_light_b:set_raw_float(b_res)
			end
		else
			mat_ambient_light_r:set_raw_float(0)
			mat_ambient_light_g:set_raw_float(0)
			mat_ambient_light_b:set_raw_float(0)
		end
	end
	wallcolor_prev = wallcolor

	local model_ambient_min = ui_get(model_ambient_min_reference)
	if model_ambient_min > 0 or (model_ambient_min_prev ~= nil and model_ambient_min_prev > 0) then
		if r_modelAmbientMin:get_float() ~= model_ambient_min*0.05 then
			r_modelAmbientMin:set_raw_float(model_ambient_min*0.05)
		end
	end
	model_ambient_min_prev = model_ambient_min

	local bloom = ui_get(bloom_reference)
	local exposure = ui_get(exposure_reference)
	if bloom ~= -1 or exposure ~= -1 or bloom_prev ~= -1 or exposure_prev ~= -1 then
		local tone_map_controllers = entity_get_all("CEnvTonemapController")
		for i=1, #tone_map_controllers do
			local tone_map_controller = tone_map_controllers[i]
			if bloom ~= -1 then
				if bloom_default == nil then
					if entity_get_prop(tone_map_controller, "m_bUseCustomBloomScale") == 1 then
						bloom_default = entity_get_prop(tone_map_controller, "m_flCustomBloomScale")
					else
						bloom_default = -1
					end
				end
				entity_set_prop(tone_map_controller, "m_bUseCustomBloomScale", 1)
				entity_set_prop(tone_map_controller, "m_flCustomBloomScale", bloom*0.01)
			elseif bloom_prev ~= nil and bloom_prev ~= -1 and bloom_default ~= nil then
				reset_bloom(tone_map_controller)
			end
			if exposure ~= -1 then
				if exposure_min_default == nil then
					if entity_get_prop(tone_map_controller, "m_bUseCustomAutoExposureMin") == 1 then
						exposure_min_default = entity_get_prop(tone_map_controller, "m_flCustomAutoExposureMin")
					else
						exposure_min_default = -1
					end
					if entity_get_prop(tone_map_controller, "m_bUseCustomAutoExposureMax") == 1 then
						exposure_max_default = entity_get_prop(tone_map_controller, "m_flCustomAutoExposureMax")
					else
						exposure_max_default = -1
					end
				end
				entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMin", 1)
				entity_set_prop(tone_map_controller, "m_bUseCustomAutoExposureMax", 1)
				entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMin", math_max(0.0000, exposure*0.001))
				entity_set_prop(tone_map_controller, "m_flCustomAutoExposureMax", math_max(0.0000, exposure*0.001))
			elseif exposure_prev ~= nil and exposure_prev ~= -1 and exposure_min_default ~= nil then
				reset_exposure(tone_map_controller)
			end
		end
	end
	bloom_prev = bloom
	exposure_prev = exposure
end
client.set_event_callback("paint", on_paint)

local function task()
	if globals_mapname() == nil then
		bloom_default, exposure_min_default, exposure_max_default = nil, nil, nil
	end
	client_delay_call(0.5, task)
end
task()

local function on_shutdown()
	local tone_map_controllers = entity_get_all("CEnvTonemapController")
	for i=1, #tone_map_controllers do
		local tone_map_controller = tone_map_controllers[i]
		if bloom_prev ~= -1 and bloom_default ~= nil then
			reset_bloom(tone_map_controller)
		end
		if exposure_prev ~= -1 and exposure_min_default ~= nil then
			reset_exposure(tone_map_controller)
		end
	end
	mat_ambient_light_r:set_raw_float(0)
	mat_ambient_light_g:set_raw_float(0)
	mat_ambient_light_b:set_raw_float(0)
	r_modelAmbientMin:set_raw_float(0)
end
client.set_event_callback("shutdown", on_shutdown)
end

do
-- "From community, for community" © qhouz

local ffi = require "ffi"

local item_crash_fix do
    local CS_UM_SendPlayerItemFound = 63

    -- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/client/cdll_client_int.cpp#L883
    local DispatchUserMessage_t = ffi.typeof [[
        bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
    ]]

    local VClient018 = client.create_interface("client.dll", "VClient018")

    local pointer = ffi.cast("uintptr_t**", VClient018)
    local vtable = ffi.cast("uintptr_t*", pointer[0])

    local size = 0

    while vtable[size] ~= 0x0 do
       size = size + 1
    end

    local hooked_vtable = ffi.new("uintptr_t[?]", size)

    for i = 0, size - 1 do
        hooked_vtable[i] = vtable[i]
    end

    pointer[0] = hooked_vtable

    local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])

    local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
        if msg_type == CS_UM_SendPlayerItemFound then
            return false
        end

        return oDispatch(thisptr, msg_type, nFlags, size, msg)
    end

    client.set_event_callback("shutdown", function()
        hooked_vtable[38] = vtable[38]
        pointer[0] = vtable
    end)

    hooked_vtable[38] = ffi.cast("uintptr_t", ffi.cast(DispatchUserMessage_t, hkDispatch))
end

end

do


    local uilib = require("gamesense/uilib")
    local http = require("gamesense/http")
    local ffi = require("ffi")
    local bit = require("bit")
    local color = require("gamesense/color")
    local filesystem_interface = ffi.cast(ffi.typeof("void***"), client.create_interface("filesystem_stdio.dll", "VFileSystem017"))
    local filesystem_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", filesystem_interface[0][20])
    local filesystem_create_directories = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", filesystem_interface[0][22])
    local filesystem_find = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)", filesystem_interface[0][32])
    
    local function remove_file(file, path_id)
        filesystem_remove_file(filesystem_interface, file, path_id)
    end
    
    local function create_directories(file, path_id)
        filesystem_create_directories(filesystem_interface, file, path_id)
    end
    
    local exists = function(file)
        local int_ptr = ffi.new("int[1]")
        local res = filesystem_find(filesystem_interface, file, int_ptr)
        if res == ffi.NULL then
            return nil
        end
    
        return int_ptr, ffi.string(res)
    end
    
    if not exists("materials\\panorama\\images\\icons\\revealer") then
        create_directories("materials\\panorama\\images\\icons\\revealer", "revealer")
        create_directories("materials\\panorama\\images\\icons\\revealer\\multicolored", "multicolored")
        create_directories("materials\\panorama\\images\\icons\\revealer\\unicolored", "unicolored")
        create_directories("materials\\panorama\\images\\icons\\revealer\\nadoryha", "nadoryha")
    end
    
    local missing_icons = {}
    local downloaded_icons = {}
    
    local function download_icon(path, cheat)
        local file_path = ("csgo/materials/panorama/images/icons/revealer/%s/%s.png"):format(path, cheat)
    
        http.get(("https://ghproxy.com/https://raw.githubusercontent.com/dave3x8/revealer-icons/main/%s/%s.png"):format(path, cheat), function(status, response)
            if not status then
                return error("Revealer: Couldn't retrieve " .. path .. " " .. cheat:upper() .. " icon due to " .. response.status_message:lower())
            end
    
            writefile(file_path, response.body)
    
            downloaded_icons[#downloaded_icons + 1] = path .. " " .. cheat:upper()
        end)
    end
    
    for path, cheats in pairs({
        multicolored = {
            "nl1",
            "nl2",
            "gs",
            "ft",
            "nw",
            "ev",
            "ot",
            "pd",
            "pl",
            "r7",
            "af",
            "wh"
        },
        unicolored = {
            "nl1",
            "nl2",
            "gs",
            "ft",
            "nw",
            "ev",
            "ot",
            "pd",
            "pl",
            "r7",
            "af",
            "wh"
        },
        nadoryha = {
            "nl",
            "gs",
            "ft",
            "nw",
            "ev",
            "ot",
            "pd",
            "pl",
            "r7",
            "af",
            "wh"
        }
    }) do
        for _, cheat in ipairs(cheats) do
            local old_file = readfile("csgo/materials/panorama/images/icons/achievements/" .. path .. "_" .. cheat .. ".png")
            if not old_file and not readfile("csgo/materials/panorama/images/icons/revealer/" .. path .. "/" .. cheat .. ".png") then
                missing_icons[#missing_icons + 1] = path .. " " .. cheat:upper()
                download_icon(path, cheat)
            elseif old_file then
                writefile("csgo/materials/panorama/images/icons/revealer/" .. path .. "/" .. cheat .. ".png", old_file)
                remove_file(("materials\\panorama\\images\\icons\\achievements\\%s_%s.png"):format(path, cheat), "")
            end
        end
    end
    
    if #missing_icons > 0 then
        print("Revealer: Missing icons: " .. table.concat(missing_icons, ", "))
    end
    
    local voice_data_t = ffi.typeof([[
        struct {
            char		 pad_0000[8];
            int32_t	client;
            int32_t	audible_mask;
            uint32_t xuid_low;
            uint32_t xuid_high;
            void*		voice_data;
            bool		 proximity;
            bool		 caster;
            char		 pad_001E[2];
            int32_t	format;
            int32_t	sequence_bytes;
            uint32_t section_number;
            uint32_t uncompressed_sample_offset;
            char		 pad_0030[4];
            uint32_t has_bits;
        } *
    ]])
    
    local js = panorama.loadstring([[
    // @ the guy trying to see what panorama i got (again?), chill bruh
    let entity_panels = {}
    let entity_data = {}
    let event_callbacks = {}
        let SLOT_LAYOUT = `
            <root>
                <Panel style="min-width: 3px; padding-top: 2px; padding-left: 0px;" scaling='stretch-to-fit-y-preserve-aspect'>
                    <Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"	/>
                    <Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
                    <Image id="image" textureheight="21" style="opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
                </Panel>
            </root>
        `
        let _DestroyEntityPanel = function (key) {
            let panel = entity_panels[key]
            if(panel != null && panel.IsValid()) {
                var parent = panel.GetParent()
                let musor = parent.GetChild(0)
                musor.visible = true
                if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                    parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                }
                panel.DeleteAsync(0.0)
            }
            delete entity_panels[key]
        }
        let _DestroyEntityPanels = function() {
            for(key in entity_panels){
                _DestroyEntityPanel(key)
            }
        }
        let _GetOrCreateCustomPanel = function(xuid) {
            if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
                entity_panels[xuid] = null
                let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")
                if(scoreboard_context_panel == null){
                    _Clear()
                    _DestroyEntityPanels()
                    return
                }
                scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
                    let scoreboard_el
                    if(el.m_xuid == xuid) {
                        el.Children().forEach(function(child_frame){
                            let stat = child_frame.GetAttributeString("data-stat", "")
                            if(stat == "rank")
                                scoreboard_el = child_frame.GetChild(0)
                        })
                        if(scoreboard_el) {
                            let scoreboard_el_parent = scoreboard_el.GetParent()
                            let custom_icons = $.CreatePanel("Panel", scoreboard_el_parent, "revealer-icon", {
                            })
                            if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
                                scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
                            }
                            scoreboard_el_parent.MoveChildAfter(custom_icons, scoreboard_el_parent.GetChild(1))
                            let prev_panel = scoreboard_el_parent.GetChild(0)
                            prev_panel.visible = false
                            let panel_slot_parent = $.CreatePanel("Panel", custom_icons, `icon`)
                            panel_slot_parent.visible = false
                            panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)
                            entity_panels[xuid] = custom_icons
                            return custom_icons
                        }
                    }
                })
            }
            return entity_panels[xuid]
        }
        let _UpdatePlayer = function(entindex, path_to_image) {
            if(entindex == null || entindex == 0)
                return
            entity_data[entindex] = {
                applied: false,
                image_path: path_to_image
            }
        }
        let _ApplyPlayer = function(entindex) {
            let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
            let panel = _GetOrCreateCustomPanel(xuid)
            if(panel == null)
                return
            let panel_slot_parent = panel.FindChild(`icon`)
            panel_slot_parent.visible = true
            let panel_slot = panel_slot_parent.FindChild("image")
            panel_slot.visible = true
            panel_slot.style.opacity = "1"
            panel_slot.SetImage(entity_data[entindex].image_path)
            return true
        }
        let _ApplyData = function() {
            for(entindex in entity_data) {
                entindex = parseInt(entindex)
                let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)
                if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
                    if(_ApplyPlayer(entindex)) {
                        entity_data[entindex].applied = true
                    }
                }
            }
        }
        let _Create = function() {
            event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
            event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
                _ApplyData()
            })
            event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
        }
        let _Clear = function() { entity_data = {} }
        let _Destroy = function() {
            // clear entity data
            _Clear()
            _DestroyEntityPanels()
            for(event in event_callbacks){
                $.UnregisterForUnhandledEvent(event, event_callbacks[event])
                delete event_callbacks[event]
            }
        }
        return {
            create: _Create,
            destroy: _Destroy,
            clear: _Clear,
            update: _UpdatePlayer,
            destroy_panel: _DestroyEntityPanels
        }
    ]], "CSGOHud")()
    
    js.create()
    
    local tab = "Visuals"
    local container = "Player ESP"
    local images_path = "file://{images}/icons/revealer/multicolored/%s.png"
    
    local main_data_table
    
    local function get_players()
        local players = {}
        local player_resource = entity.get_player_resource()
    
        for i = 1, globals.maxplayers() do
            repeat
                if entity.get_prop(player_resource, "m_bConnected", i) == 0 then
                    if main_data_table.users[i] then
                        main_data_table.users[i] = nil
                    end
    
                    break
                else
                    local flags = entity.get_prop(i, "m_fFlags")
                    if not flags then
                        break
                    end
    
                    if bit.band(flags, 512) == 512 then
                        break
                    end
                end
    
                players[#players + 1] = i
            until true
        end
    
        return players
    end
    
    local function find_duplicate_element(array, divisor)
        local visited_elements = {}
    
        for current_index = 1, #array do
            local current_element = array[current_index]
    
            if not visited_elements[current_element] then
                visited_elements[current_element] = true
    
                for next_index = current_index + 4, #array do
                    if current_index % divisor == 0 then
                        if array[next_index] == current_element then
                            return true
                        end
                    elseif array[next_index] == current_element then
                        return false
                    end
                end
            end
        end
    
        return false
    end
    
    
    main_data_table = {
        main = uilib.new_checkbox(tab, container, "Cheat revealer"),
        display_method = uilib.new_multiselect(tab, container, "\nCheat revealer display options", {
            "Scoreboard icon",
            "Flag"
        }),
        icon_type = uilib.new_multiselect(tab, container, "\nCheat revealer icon set", {
            "Multicolored",
            "Unicolored",
            "Nado & Ryha",
            "Alternative NL icon"
        }),
        plist_handler = uilib.create_plist(),
        yeah = {
            names = {
                gs = {
                    long = "gamesense",
                    color = color.hex("95B80CFF")
                },
                nl = {
                    long = "neverlose",
                    color = color.hex("037696FF")
                },
                nw = {
                    long = "nixware",
                    color = color.hex("FFFFFFFF")
                },
                pd = {
                    long = "pandora",
                    color = color.hex("D4A9FFFF")
                },
                pr = {
                    long = "primordial",
                    color = color.hex("E2B6C7FF")
                },
                ot = {
                    long = "onetap",
                    color = color.hex("f7a414FF")
                },
                ft = {
                    long = "fatality",
                    color = color.hex("f00657FF")
                },
                pl = {
                    long = "plaguecheat",
                    color = color.hex("6BFF87FF")
                },
                ev = {
                    long = "ev0lve",
                    color = color.hex("42B7FFFF")
                },
                r7 = {
                    long = "rifk7",
                    color = color.hex("FF00FFFF")
                },
                af = {
                    long = "airflow",
                    color = color.hex("8E76C0FF")
                },
                wh = {
                    long = "unknown",
                    color = color.hex("9F9F9FFF")
                }
            },
            colored_names = {
                gs = {
                    short = "\aEAEAEAFFG\a95B80CFFS",
                    long = "\aEAEAEAFFgame\a95B80CFFsense"
                },
                nl = {
                    short = "\a037696FFNL",
                    long = "\aEAEAEAFFnever\a037696FFlose"
                },
                nw = {
                    short = "\aFFFFFFFFNW",
                    long = "\aFFFFFFFFnixware"
                },
                pd = {
                    short = "\aD4A9FFFFPD",
                    long = "\aD4A9FFFFpandora"
                },
                pr = {
                    short = "\aE2B6C7FFPR",
                    long = "\aE2B6C7FFprimordial"
                },
                ot = {
                    short = "\aEAEAEAFFO\af7a414FFT",
                    long = "\aEAEAEAFFone\af7a414FFtap"
                },
                ft = {
                    short = "\af00657FFFT",
                    long = "\aF00657FFfatality"
                },
                pl = {
                    short = "\a6BFF87FFPLG",
                    long = "\a6BFF87FFplaguecheat"
                },
                ev = {
                    short = "\a42B7FFFFEV0",
                    long = "\a42B7FFFFev0\aFFFFFFFFlve"
                },
                r7 = {
                    short = "\a00F600FFR\aFF00FFFF7",
                    long = "\a00F600FFrifk\aFF00FFFF7"
                },
                af = {
                    short = "\a8E76C0FFAF",
                    long = "\a8E76C0FFairflow"
                },
                wh = {
                    short = false,
                    long = "\a515364FFunknown"
                }
            },
        },
        users = {}
    }
    
    main_data_table.list_label = main_data_table.plist_handler:add(ui.new_label, "Cheat: " .. main_data_table.yeah.colored_names.wh.long)
    
    local scoreboard_icon_enabled = false
    
    main_data_table.display_method:add_callback(function(method)
        if method:contains("Scoreboard icon") then
            js.create()
        else
            js.destroy()
        end
    
        scoreboard_icon_enabled = method:contains("Scoreboard icon")
    end)
    
    local esp_flag_enabled = false
    
    local last_scoreboard_icon_enabled = false
    local last_esp_flag_enabled = false
    
    local nl_path = nil
    
    local is_multicolored = false
    local is_unicolored = false
    local is_nadoryha = false
    local is_alternate_nl_icon = false
    
    local icon_changed = false
    
    main_data_table.icon_type:add_callback(function(icon_type)
        icon_changed = true
        if icon_type:contains("Unicolored") and (is_multicolored or is_nadoryha) then
            icon_type:remove("Multicolored")
            icon_type:remove("Nado & Ryha")
        elseif icon_type:contains("Multicolored") and (is_unicolored or is_nadoryha) then
            icon_type:remove("Unicolored")
            icon_type:remove("Nado & Ryha")
        elseif icon_type:contains("Nado & Ryha") and (is_multicolored or is_unicolored) then
            icon_type:remove("Unicolored")
            icon_type:remove("Multicolored")
            icon_type:remove("Alternative NL icon")
        elseif icon_type:contains("Alternative NL icon") and is_nadoryha then
            icon_type:remove("Alternative NL icon")
        else
            icon_type:add(is_multicolored and "Multicolored" or is_unicolored and "Unicolored" or is_nadoryha and "Nado & Ryha" or "Multicolored")
        end
    
        is_nadoryha = icon_type:contains("Nado & Ryha")
        is_unicolored = icon_type:contains("Unicolored")
        is_multicolored = icon_type:contains("Multicolored")
        nl_path = not is_nadoryha and (icon_type:contains("Alternative NL icon") and "nl2" or "nl2") or "nl2"
        images_path = "file://{images}/icons/revealer/" .. (is_multicolored and "multicolored" or is_unicolored and "unicolored" or is_nadoryha and "nadoryha") .. "/%s.png"
    
        for _, user in pairs(main_data_table.users) do
            user.icon_set = false
        end
    end)
    main_data_table.icon_type:add("Multicolored")
    
    local detection_storage_table = {
        nl = {
            sig_count = {},
            found = {}
        },
        nw = {},
        pd = {},
        ot = {},
        ft = {},
        pl = {},
        ev = {},
        r7 = {},
        af = {},
        gs = {}
    }
    local detector_table = {
        nl = function(packet, target)
            if packet.xuid_high == 0 then
                return
            end
    
            local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 22)[0])
    
            if sig == detection_storage_table.current_signature then
                detection_storage_table.nl.sig_count[target] = (detection_storage_table.nl.sig_count[target] or 0) + 1
    
                if detection_storage_table.nl.sig_count[target] > 24 then
                    detection_storage_table.nl.found[target] = 1
    
                    return true
                else
                    detection_storage_table.nl.sig_count[target] = nil
                end
            end
    
            if #detection_storage_table.nl.found > 3 then
                return false
            end
    
            if not detection_storage_table.nl[target] then
                detection_storage_table.nl[target] = {}
            end
    
            detection_storage_table.nl[target][#detection_storage_table.nl[target] + 1] = packet.xuid_high
    
            if #detection_storage_table.nl[target] > 24 then
                if find_duplicate_element(detection_storage_table.nl[target], 4) and packet.xuid_high ~= 0 then
                    detection_storage_table.current_signature = sig
                    detection_storage_table.nl[target] = {}
    
                    return true
                end
    
                table.remove(detection_storage_table.nl[target], 1)
            end
    
            return false
        end,
        nw = function(packet, target)
            if not detection_storage_table.nw[target] then
                detection_storage_table.nw[target] = 0
            end
    
            if detection_storage_table.nw[target] > 34 then
                detection_storage_table.nw[target] = nil
    
                return true
            elseif packet.xuid_high == 0 then
                detection_storage_table.nw[target] = detection_storage_table.nw[target] + 1
            else
                detection_storage_table.nw[target] = 0
            end
    
            return false
        end,
        pd = function(packet, target)
            if not detection_storage_table.pd[target] then
                detection_storage_table.pd[target] = 0
            end
    
            local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])
    
            if detection_storage_table.pd[target] > 24 then
                return true
            elseif sig == "695B" or sig == "1B39" then
                detection_storage_table.pd[target] = detection_storage_table.pd[target] + 1
            else
                detection_storage_table.pd[target] = 0
            end
    
            return false
        end,
        ot = function(packet, target)
            if not detection_storage_table.ot[target] then
                detection_storage_table.ot[target] = {}
            end
    
            detection_storage_table.ot[target][#detection_storage_table.ot[target] + 1] = {
                sequence_bytes = packet.sequence_bytes,
                xuid_low = packet.xuid_low,
                section_number = packet.section_number,
                umcompressed_sample_offset = packet.uncompressed_sample_offset
            }
    
            if #detection_storage_table.ot[target] > 16 then
                local oldest_packet = detection_storage_table.ot[target][1]
    
                for i = 2, #detection_storage_table.ot[target] do
                    local loop_packet = detection_storage_table.ot[target][i]
                    if loop_packet.xuid_low ~= oldest_packet.xuid_low or loop_packet.section_number ~= oldest_packet.section_number or loop_packet.uncompressed_sample_offset ~= oldest_packet.uncompressed_sample_offset then
                        table.remove(detection_storage_table.ot[target], 1)
    
                        return false
                    end
                end
    
                table.remove(detection_storage_table.ot[target], 1)
    
                return true
            end
    
            return false
        end,
        ft = function(packet, target)
            if not detection_storage_table.ft[target] then
                detection_storage_table.ft[target] = 0
            end
    
            local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])
    
            if detection_storage_table.ft[target] > 36 then
                return true
            elseif sig == "7FFA" or sig == "7FFB" then
                detection_storage_table.ft[target] = detection_storage_table.ft[target] + 1
            end
    
            return false
        end,
        pl = function(packet, target)
            if not detection_storage_table.pl[target] then
                detection_storage_table.pl[target] = 0
            end
    
            if detection_storage_table.pl[target] > 24 then
                return true
            elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 44)[0]) == "7275" then
                detection_storage_table.pl[target] = detection_storage_table.pl[target] + 1
            else
                detection_storage_table.pl[target] = 0
            end
    
            return false
        end,
        ev = function(packet, target)
            if not detection_storage_table.ev[target] then
                detection_storage_table.ev[target] = {}
            end
    
            detection_storage_table.ev[target][#detection_storage_table.ev[target] + 1] = packet.xuid_high
    
            if #detection_storage_table.ev[target] > 44 then
                for i = 1, #detection_storage_table.ev[target] - 4 do
                    local loop_info = detection_storage_table.ev[target][i]
                    if detection_storage_table.ev[target][i + 1] + detection_storage_table.ev[target][i + 2] == detection_storage_table.ev[target][i] * 2 and detection_storage_table.ev[target][i + 4] == loop_info + 1 then
                        detection_storage_table.ev[target] = {}
    
                        return true
                    end
                end
    
                table.remove(detection_storage_table.ev[target], 1)
            end
    
            return false
        end,
        r7 = function(packet, target)
            if not detection_storage_table.r7[target] then
                detection_storage_table.r7[target] = 0
            end
    
            local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0])
    
            if detection_storage_table.r7[target] > 24 then
                return true
            elseif sig == "234" or sig == "134" then
                detection_storage_table.r7[target] = detection_storage_table.r7[target] + 1
            else
                detection_storage_table.r7[target] = 0
            end
    
            return false
        end,
        af = function(packet, target)
            if not detection_storage_table.af[target] then
                detection_storage_table.af[target] = 0
            end
    
            if detection_storage_table.af[target] > 24 then
                return true
            elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 16)[0]) == "AFF1" then
                detection_storage_table.af[target] = detection_storage_table.af[target] + 1
            else
                detection_storage_table.af[target] = 0
            end
    
            return false
        end,
        gs = function(packet, target)
            local sig = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", packet) + 22)[0])
            local sequence_bytes = string.sub(packet.sequence_bytes, 1, 4)
    
            if not detection_storage_table.gs[target] then
                detection_storage_table.gs[target] = {
                    repeated = 0,
                    packet = sig,
                    bytes = sequence_bytes
                }
            end
    
            if sequence_bytes ~= detection_storage_table.gs[target].bytes and sig ~= detection_storage_table.gs[target].packet then
                detection_storage_table.gs[target].packet = sig
                detection_storage_table.gs[target].bytes = sequence_bytes
                detection_storage_table.gs[target].repeated = detection_storage_table.gs[target].repeated + 1
            else
                detection_storage_table.gs[target].repeated = 0
            end
    
            if detection_storage_table.gs[target].repeated >= 36 then
                detection_storage_table.gs[target] = {
                    repeated = 0,
                    packet = sig,
                    bytes = sequence_bytes
                }
    
                return true
            end
    
            return false
        end
    }
    
    client.register_esp_flag("", 220, 220, 220, function(target)
        if not main_data_table.main.value then
            return false
        end
    
        if not main_data_table.users[target] or not main_data_table.users[target].cheat then
            return false
        end
    
        local cheat = main_data_table.users[target].cheat or "wh"
    
        if not esp_flag_enabled or not cheat or cheat == "wh" then
            return false
        end
    
        return true, (entity.is_dormant(target) and cheat or main_data_table.yeah.colored_names[cheat].short or ""):upper()
    end)
    
    local function info_update_callback()
        main_data_table.icon_type.vis = main_data_table.main.value
        main_data_table.display_method.vis = main_data_table.main.value
        scoreboard_icon_enabled = main_data_table.display_method:contains("Scoreboard icon") and main_data_table.main.value
        esp_flag_enabled = main_data_table.display_method:contains("Flag") and main_data_table.main.value
    
        if icon_changed then
            icon_changed = false
            for _, user in pairs(main_data_table.users) do
                user.icon_set = false
            end
        end
    
        if scoreboard_icon_enabled and not last_scoreboard_icon_enabled then
            last_scoreboard_icon_enabled = true
    
            js.create()
        elseif not scoreboard_icon_enabled and last_scoreboard_icon_enabled then
            last_scoreboard_icon_enabled = false
    
            for _, user in pairs(main_data_table.users) do
                user.icon_set = false
            end
    
            js.destroy()
        end
    end
    
    main_data_table.main:add_event_callback("paint", function()
        if not scoreboard_icon_enabled then
            return
        end
    
        if (not is_multicolored) and (not is_unicolored) and (not is_nadoryha) then
            return
        end
    
        for _, target in pairs(get_players()) do
            local user = main_data_table.users[target]
            if user then
                if not user.icon_set then
                    js.update(target, images_path:format(user.cheat and (user.cheat == "nl" and nl_path or user.cheat) or target == entity.get_local_player() and "gs" or "wh"))
    
                    user.icon_set = true
                end
            else
                main_data_table.users[target] = {}
            end
        end
    end)
    
    main_data_table.main:add_event_callback("voice", function(event)
        local packet = ffi.cast(voice_data_t, event.data)
        local target = (ffi.cast("char*", packet) + 8)[0] + 1
        if not main_data_table.users[target] then
            main_data_table.users[target] = {}
        end
    
        local user = main_data_table.users[target]
    
        for cheat_identifier, cheat_detection_function in pairs(detector_table) do
            repeat
                local cheat = user.cheat
                if user.cheat ~= cheat_identifier and (cheat_identifier ~= "nl" or user.cheat ~= "ev" and user.cheat ~= "gs" and user.cheat ~= "pl" and user.cheat ~= "pd" and user.cheat ~= "r7" and user.cheat ~= "af" and user.cheat ~= "ft") and (cheat_identifier ~= "nw" or user.cheat ~= "nl") and (cheat_identifier ~= "ev" or user.cheat ~= "pd" and user.cheat ~= "nl" and user.cheat ~= "ft") and (cheat_identifier ~= "gs" or user.cheat ~= "ev" and user.cheat ~= "ot" and user.cheat ~= "pl" and user.cheat ~= "pd" and user.cheat ~= "r7" and user.cheat ~= "ft") and (cheat_identifier ~= "ot" or user.cheat ~= "nw" and user.cheat ~= "ft" and user.cheat ~= "pd" and user.cheat ~= "pl") then
                    if cheat_identifier == "ft" and (user.cheat == "nw" or user.cheat == "pd") then
                        break
                    end
    
                    if cheat_detection_function(packet, target) then
                        user.cheat = cheat_identifier
                        user.icon_set = false
    
                        main_data_table.plist_handler:set_state(main_data_table.list_label, target, ("Cheat: %s"):format(main_data_table.yeah.colored_names[cheat_identifier].long) or main_data_table.yeah.colored_names.wh.long)
    
                        if (user.cheat or "wh") == "wh" or cheat ~= cheat_identifier then
                            client.fire_event("cheat_detected", {
                                player = target,
                                cheat_id = cheat_identifier,
                                cheat_long = main_data_table.yeah.names[cheat_identifier].long,
                                cheat_color = main_data_table.yeah.names[cheat_identifier].color
                            })
                        end
                    end
                end
            until true
        end
    end)
    main_data_table.main:add_event_callback("player_connect_full", function(event)
        local target = client.userid_to_entindex(event.userid)
        if target == entity.get_local_player() then
            main_data_table.users = {}
    
            js.clear()
            js.destroy()
            client.delay_call(0.5, function()
                js.create()
            end)
        else
            for _, user in pairs(main_data_table.users) do
                user[target] = {}
            end
        end
    end)
    main_data_table.main:add_event_callback("game_start", function()
        for _, user in pairs(main_data_table.users) do
            user.icon_set = false
        end
    end)
    main_data_table.main:add_callback(info_update_callback)
    main_data_table.display_method:add_callback(info_update_callback)
    main_data_table.icon_type:add_callback(info_update_callback)
    main_data_table.main:invoke()
    client.set_event_callback("shutdown", function()
        js.clear()
        js.destroy()
    end)
    
    package.preload["gamesense/cheat_revealer"] = function()
        return {
            get_cheat = function(target)
                local cheat = main_data_table.users[target].cheat or "wh"
    
                return {
                    cheat_id = cheat,
                    cheat_long = main_data_table.yeah.names[cheat].long or "unknown",
                    cheat_color = main_data_table.yeah.names[cheat].color or color.hex("9F9F9FFF")
                }
            end,
            has_data = function(target)
                return main_data_table.users[target] ~= nil
            end,
            clear_data = function(target)
                if main_data_table.users[target] == nil then
                    return false
                end
    
                main_data_table.users[target] = nil
    
                for _, detection in pairs(detection_storage_table) do
                    detection[target] = nil
                end
    
                return true
            end
        }
    end
    
end

do
    local ffi = require("ffi")

    local client_create_interface, client_find_signature, client_userid_to_entindex, client_reload_active_scripts, client_set_event_callback, client_unset_event_callback = client.create_interface, client.find_signature, client.userid_to_entindex, client.reload_active_scripts, client.set_event_callback, client.unset_event_callback
    local entity_get_local_player = entity.get_local_player
    local ui_new_checkbox, ui_new_listbox, ui_get, ui_set, ui_set_callback, ui_set_visible = ui.new_checkbox, ui.new_listbox, ui.get, ui.set, ui.set_callback, ui.set_visible
    local string_format = string.format
    local table_sort = table.sort
    local pairs, pcall, error, next = pairs, pcall, error, next
    local ffi_cast, ffi_typeof, ffi_string, ffi_sizeof = ffi.cast, ffi.typeof, ffi.string, ffi.sizeof
    
    local skybox_names = {}
    
    local skybox_list = {
        ["Tibet"] = "cs_tibet",
        ["RAZE"] = "Sky051",
    }
    
    local old_custom_skyboxes = nil
    
    local function bind_signature(module, interface, signature, typestring)
        local interface = client_create_interface(module, interface) or error("invalid interface", 2)
        local instance = client_find_signature(module, signature) or error("invalid signature", 2)
        local success, typeof = pcall(ffi_typeof, typestring)
        if not success then
            error(typeof, 2)
        end
        local fnptr = ffi_cast(typeof, instance) or error("invalid typecast", 2)
        return function(...)
            return fnptr(interface, ...)
        end
    end
    
    local int_ptr           = ffi_typeof("int[1]")
    local char_buffer       = ffi_typeof("char[?]")
    
    local find_first        = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D", "const char*(__thiscall*)(void*, const char*, const char*, int*)")
    local find_next         = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC", "const char*(__thiscall*)(void*, int)")
    local find_close        = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x53\x8B\x5D\x08\x85", "void(__thiscall*)(void*, int)")
    
    local current_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C", "bool(__thiscall*)(void*, char*, int)")
    local add_to_searchpath = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57", "void(__thiscall*)(void*, const char*, const char*, int)")
    local find_is_directory = bind_signature("filesystem_stdio.dll", "VFileSystem017", "\x55\x8B\xEC\x0F\xB7\x45\x08", "bool(__thiscall*)(void*, int)")
    
    local function collect_custom_skyboxes()
        local files = {}
        local file_handle = int_ptr()
        local file = find_first("*", "XGAME", file_handle)
        while file ~= nil do
            local file_name = ffi_string(file)
            if find_is_directory(file_handle[0]) == false and (file_name:find("dn.vtf")) then
                files[#files+1] = file_name:sub(1, -7)
            end
            file = find_next(file_handle[0])
        end
        find_close(file_handle[0])
        return files
    end
    
    local function normalize_file_name(name)
        -- uppcercase the first letter
        local first_letter = name:sub(1, 1)
        local rest = name:sub(2)
        name = "Custom: ".. first_letter:upper() .. rest
        if name:find("_") then
            name = name:gsub("_", " ")
        end
        if name:find(".vtf") then
            name = name:gsub(".vtf", "")
        end
        return name
    end
    
    -- find the differences between two tables
    local function table_diff(t1, t2)
        local diff = {}
        for k, v in pairs(t1) do
            if t2[k] ~= v then
                diff[k] = v
            end
        end
        for k, v in pairs(t2) do
            if t1[k] ~= v then
                diff[k] = v
            end
        end
        return next(diff) ~= nil
    end
    
    local function collect()
        local current_path = char_buffer(192)
        current_directory(current_path, ffi_sizeof(current_path))
        current_path = string_format("%s\\csgo\\materials\\skybox", ffi_string(current_path))
        add_to_searchpath(current_path, "XGAME", 0)
    
        local custom_skyboxes = collect_custom_skyboxes()
    
        if old_custom_skyboxes ~= nil and table_diff(custom_skyboxes, old_custom_skyboxes) then
            client_reload_active_scripts()
        end
    
        for i = 1, #custom_skyboxes do
            local file_name = custom_skyboxes[i]
            local normalized_name = normalize_file_name(file_name)
            if not skybox_list[normalized_name] then
                skybox_list[normalized_name] = file_name
                skybox_names[#skybox_names + 1] = normalized_name
            end
        end
    
        old_custom_skyboxes = custom_skyboxes
        skybox_names = {}
    
        for k, v in pairs(skybox_list) do
            skybox_names[#skybox_names+1] = k
        end
        table_sort(skybox_names)
    end
    
    collect()
    
    local skybox_settings = {
        override = ui_new_checkbox("VISUALS", "Effects", "Override skybox"),
        skybox = ui_new_listbox("VISUALS", "Effects", "Skybox name", skybox_names),
        remove_3d_sky = ui_new_checkbox("VISUALS", "Effects", "Remove 3D Sky"),
    }
    
    ui_set_visible(skybox_settings.skybox, false)
    ui_set_visible(skybox_settings.remove_3d_sky, false)
    
    local load_name_sky_address = client_find_signature("engine.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45") or error("signature for load_name_sky is outdated")
    local load_name_sky = ffi_cast(ffi_typeof("void(__fastcall*)(const char*)"), load_name_sky_address)
    
    local sv_skyname = cvar.sv_skyname
    local r_3dsky = cvar.r_3dsky
    local default_skyname = nil
    
    local function update_skybox()
        if default_skyname == nil then
            default_skyname = sv_skyname:get_string()
        end
    
        if not ui_get(skybox_settings.override) then
            load_name_sky(default_skyname)
            return
        end
    
        local name = skybox_names[ui_get(skybox_settings.skybox) + 1]
        load_name_sky(skybox_list[name])
    end
    
    local function on_player_connect_full(event)
        if client_userid_to_entindex(event.userid) == entity_get_local_player() then
            default_skyname = nil
            update_skybox()
            collect()
        end
    end
    
    ui_set_callback(skybox_settings.override, function(var)
        local state = ui_get(var)
    
        ui_set_visible(skybox_settings.skybox, state)
        ui_set_visible(skybox_settings.remove_3d_sky, state)
        if not state then
            if default_skyname ~= nil then
                load_name_sky(default_skyname)
            else
                load_name_sky(sv_skyname:get_string())
            end
        else
            update_skybox()
        end
    end)
    
    ui_set_callback(skybox_settings.skybox, update_skybox)
    ui_set_callback(skybox_settings.remove_3d_sky, function(var)
        local state = ui_get(var)
        r_3dsky:set_raw_int(state and 0 or 1)
    end)
    
    client_set_event_callback("player_connect_full", on_player_connect_full)
    client_set_event_callback("shutdown", function()
        if default_skyname ~= nil then
            load_name_sky(default_skyname)
        end
    end)
end