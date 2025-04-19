panorama.loadstring([[
    let doom_panel = $.CreatePanel('Panel', $.GetContextPanel(), 'DoomGame');
    doom_panel.style.width = '640px';
    doom_panel.style.height = '400px';
    doom_panel.style.backgroundColor = '#000000';
    doom_panel.style.align = 'center center';
    doom_panel.style.verticalAlign = 'center';
    doom_panel.style.flowChildren = 'none';
    
    doom_panel.SetDraggable(true);

    let doom_title = $.CreatePanel('Panel', doom_panel, 'title');
    doom_title.style.width = '100%';
    doom_title.style.height = '20px';
    doom_title.style.backgroundColor = '#333333';
    
    let doom_frame = $.CreatePanel('HTML', doom_panel, 'DoomFrame');
    doom_frame.style.width = '100%';
    doom_frame.style.height = '380px';
    doom_frame.SetURL('https://js-dos.com/games/doom.exe.html');
    doom_frame.SetAcceptsFocus(true);
    
    doom_frame.RunJavascript(`
        document.addEventListener('DOMContentLoaded', function() {
            const style = document.createElement('style');
            style.textContent = 'body > *:not(canvas) { display: none !important; } canvas { width: 100% !important; height: 100% !important; }'; // uwukson: @needfix
            document.head.appendChild(style);

            setTimeout(() => {
                document.getElementById('fullscreen').click(); // uwukson: @needfix
            }, 200);
        });
    `);
]], "CSGOMainMenu")()