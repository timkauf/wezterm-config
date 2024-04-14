local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action

if wezterm.config_builder then config = wezterm.config_builder() end

config.color_scheme = 'Catppuccin Frappe'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 13

config.hide_tab_bar_if_only_one_tab = true

config.leader = { key = ' ', mods = 'CTRL' }

config.keys = {
    -- Panes
    -- Zoom current pane
    {key = 'm', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState},

    -- Create splits
    {key = '\\', mods = 'LEADER', action = wezterm.action.SplitVertical({domain = 'CurrentPaneDomain'})},
    {key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal({domain = 'CurrentPaneDomain'})},

    -- Select pane by default alpha chars
    { key = 'a', mods = 'LEADER', action = act.PaneSelect },

    -- Switch to pane (independent keymaps)
    {key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left')},
    {key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down')},
    {key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up')},
    {key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Right')},

    -- Switch to pane (key table mode)
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'switch_pane',
            one_shot = false,
            timeout_milliseconds = 1500,
        },
    },

    -- Resize pane (enters mode until ESC)
    {
        key = 's',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false,
            timeout_milliseconds = 1500,
        },
    },

    -- TABS
    -- Switch to tab
    {
        key = 't',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'switch_tab',
            one_shot = false,
            timeout_milliseconds = 1500,
        },
    },

    -- Move current tab
    {
        key = 'v',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'move_tab',
            one_shot = false,
            timeout_milliseconds = 1500,
        },
    },

    -- Rename current tab
    {
        key = 'e',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
}

config.key_tables = {
    switch_pane = {
        { key = 'LeftArrow', action = act.ActivatePaneDirection('Left')},
        { key = 'h', action = act.ActivatePaneDirection('Left')},

        { key = 'DownArrow', action = act.ActivatePaneDirection('Down')},
        { key = 'j', action = act.ActivatePaneDirection('Down')},

        { key = 'UpArrow', action = act.ActivatePaneDirection('Up')},
        { key = 'k', action = act.ActivatePaneDirection('Up')},

        { key = 'RightArrow', action = act.ActivatePaneDirection('Right')},
        { key = 'l', action = act.ActivatePaneDirection('Right')},

        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
    },
    resize_pane = {
        { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

        { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

        { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
    },
    switch_tab = {
        {key = 'RightArrow', action = wezterm.action({ActivateTabRelative = 1})},
        {key = 'l', action = wezterm.action({ActivateTabRelative = 1})},
        {key = 'LeftArrow', action = wezterm.action({ActivateTabRelative = -1})},
        {key = 'h', action = wezterm.action({ActivateTabRelative = -1})},

        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
    },
    move_tab = {
        {key = 'RightArrow', action = act.MoveTabRelative(1)},
        {key = 'l', action = act.MoveTabRelative(1)},
        {key = 'LeftArrow', action = act.MoveTabRelative(-1)},
        {key = 'h', action = act.MoveTabRelative(-1)},

        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
    },
}

return config

