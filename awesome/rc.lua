-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("volume")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- start up some programs I use with awesome
awful.util.spawn_with_shell("xmodmap ~/.Xmodmap")       -- set caps lock to modkey
awful.util.spawn_with_shell("amixer sset Front on")     -- turn volume on
awful.util.spawn_with_shell("amixer sset Headphone on")
awful.util.spawn_with_shell("amixer sset PCM on")
awful.util.spawn_with_shell("xscreensaver -no-splash")  -- screensaver/lock

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

config_dir = awful.util.getdir("config")
home_dir = os.getenv("HOME")

globalkeys = awful.util.table.join()

beautiful.init(home_dir .. "/.dotfiles/awesome/themes/cstm-apexskier/theme.lua") -- initialize theme

modkey = "Mod4" -- remapped by xmodmap

layouts = {
    awful.layout.suit.floating,         -- 1
    awful.layout.suit.tile,             -- 2
    awful.layout.suit.tile.left,        -- 3
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,   -- 4
    awful.layout.suit.max,              -- 5
    awful.layout.suit.max.fullscreen,   -- 6
    -- awful.layout.suit.magnifier
}

tags = {}
tag_layouts = { -- aliases for layouts
    tileright = layouts[2],
    tileleft  = layouts[3],
    floating  = layouts[1],
    maximize  = layouts[5],
    spiral    = layouts[4]
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(
        { "r", "l", "f", "m", "s", 6, 7, 8 },
        s,
        {
            tag_layouts["tileright"], -- set some default layouts per tag
            tag_layouts["tileleft"],
            tag_layouts["floating"],
            tag_layouts["maximize"],
            tag_layouts["spiral"],
            tag_layouts["tileleft"],
            tag_layouts["tileright"],
            tag_layouts["floating"],
        })
end

-- laucher widget and a main menu
myawesomemenu = { { "manual", terminal .. " -e man awesome" },
                  { "edit config", editor_cmd .. " " .. awesome.conffile },
                  { "restart", awesome.restart },
                  { "exit", awesome.quit } }
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal } } })
mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- text clock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- systray widget (for system widgets)
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(           -- clicking tags --
    awful.button({ }, 1, awful.tag.viewonly),            -- move to tag (left click)
    awful.button({ modkey }, 1, awful.client.movetotag), -- move active window to tag (left click + modkey)
    awful.button({ }, 3, awful.tag.viewtoggle),          -- activate tag
    awful.button({ modkey }, 3, awful.client.toggletag), -- add active window to tag
    awful.button({ }, 4, awful.tag.viewnext),            -- scroll to change tag
    awful.button({ }, 5, awful.tag.viewprev))
mytasklist = {}
mytasklist.buttons = awful.util.table.join(          -- clicking window titles --
    awful.button({ }, 1, function (c)                    -- click to focus/open window
        if c == client.focus then
            c.minimized = true
        else
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c)                    -- middle click to close window
        c:kill()
    end),
    awful.button({ }, 4, function ()                     -- scroll to change active windows
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        volume_widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

root.buttons(awful.util.table.join( -- clicking on background --
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

function zoom (c) -- maximize window within layout
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
    if c.maximized_horizontal and c.maximized_vertical then
        c.ontop = true
    else
        c.ontop = false
    end
end

globalkeys = awful.util.table.join(globalkeys,
    -- lock screen with mod + alt + l
    awful.key({ modkey, "Mod1"    }, "l", function () awful.util.spawn_with_shell("xscreensaver-command -lock") end),
    -- take screenshot with printscreen button
    awful.key({ }, "Print", function () awful.util.spawn_with_shell("xwd -root | xwdtopnm | pnmtopng > screenshot.png") end),

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ), -- next tag
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ), -- previous tag
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore), -- last tag

    awful.key({ modkey,           }, "j", -- next window
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k", -- previous window
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end), -- switch windows
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end), -- "
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end), -- switch screens
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end), -- "
    awful.key({ modkey, "Mod1" }, "j", function () awful.screen.focus_relative( 1) end),    -- "
    awful.key({ modkey, "Mod1" }, "k", function () awful.screen.focus_relative(-1) end),    -- "
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, "Shift"   }, "Left",                                                -- switch windows by direction
        function ()
            awful.client.focus.bydirection('left')
        end),
    awful.key({ modkey, "Shift"   }, "Right",                                               -- "
        function ()
            awful.client.focus.bydirection('right')
        end),
    awful.key({ modkey, "Shift"   }, "Up",                                                  -- "
        function ()
            awful.client.focus.bydirection('up')
        end),
    awful.key({ modkey, "Shift"   }, "Down",                                                -- "
        function ()
            awful.client.focus.bydirection('down')
        end),
    awful.key({ modkey,           }, "Tab",                                                 -- tries to simulate alt+tab on most os's
        function ()
            awful.client.focus.byidx(1)
            if awful.client.ismarked() then
                awful.screen.focus_relative(-1)
                awful.client.getmarked()
            end
            if client.focus then
                client.focus:raise()
            end
            awful.client.togglemarked()
        end),
    awful.key({ modkey,           }, "p",                                                   -- switch to last screen
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end), -- resize windows horizontally
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end), -- "
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end), -- change layout behavior (vertical/horizontal)
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end), -- "
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end), -- resize windows vertically
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end), -- "
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end), -- next layout
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end), -- previous layout

    awful.key({ modkey, "Control" }, "n", awful.client.restore), -- unminimize

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end), -- run program
    awful.key({ modkey },            "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ "Control"         }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "z",      function (c) zoom(c)                          end)
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { name = "xmessage" },
      properties = {
          opacity = 0.75,
          floating = true,
          ontop = true,
          focus = true
      },
      callback = function(c)
        awful.client.moveresize(20, 20, 0, 20, c)
      end },
    { rule = { instance = "plugin-container" },
      properties = { floating = true,
                     focus = yes } },
    { rule = { type = "dialog" },
      properties = {
          opacity = 0.75,
          floating = true,
          ontop = true,
          focus = true
      } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- www
    { rule = { class = "Firefox",
               name = "Downloads" },
      properties = { floating = true, ontop = true },
      callback = function(c)
        awful.titlebar.add(c, { modkey = modkey })
        awful.client.moveresize(20, 20, 0, 0, c)
      end },
    { rule = { class = "Iceweasel",
               name = "Downloads" },
      properties = { floating = true, ontop = true },
      callback = function(c)
        awful.titlebar.add(c, { modkey = modkey })
        awful.client.moveresize(20, 20, 0, 0, c)
      end },
    -- files
    { rule = { class = "Thunar" },
      properties = { floating = true },
      callback = function(c)
        awful.titlebar.add(c, { modkey = modkey })
      end },
    { rule = { class = "Pcmanfm" },
      properties = { floating = true },
      callback = function(c)
        awful.titlebar.add(c, { modkey = modkey })
      end },
    { rule = { class = "Nautilus" },
      properties = { floating = true },
      callback = function(c)
        awful.titlebar.add(c, { modkey = modkey })
      end },
}

-- move a client to a tag on a screen and then show it (preserving already
-- shown tags)
function awful.tag.put_and_show(c, tag, screen)
    awful.client.movetotag(tag, c)
    if not awful.tag.visible(tag, screen) then
        awful.tag.viewtoggle(tag)
    end
end
-- is a tag visible on a screen?
function awful.tag.visible(tag, screen)
    local selected = awful.tag.selectedlist(screen)
    local found = false
    for i_, v in ipairs(selected) do
        if v == tag then
            return true
        end
    end
end

-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

