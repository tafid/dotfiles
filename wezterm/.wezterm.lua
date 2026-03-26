-- Pull in the wezterm API
local wezterm = require 'wezterm'
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

-- Автосохранение каждые 15 минут
--resurrect.periodic_save({
--    interval_seconds = 900, -- 15 минут
--    save_workspaces = true,
--    save_windows = true,
--    save_tabs = true,
--})

-- Автоматическая перезагрузка при изменении
config.automatically_reload_config = true

wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)

-- Leader key (как в tmux)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Автоматически подключаться к unix domain socket
config.default_gui_startup_args = { 'connect', 'unix' }

-- Определяем unix domain (сессию)
config.unix_domains = {
    {
        name = 'unix',
        socket_path = os.getenv('HOME') .. '/.local/share/wezterm/sock',
    },
}

-- SSH-домены для удалённых подключений
config.ssh_domains = {
    --{
    --  name = 'hipanel',
    --  remote_address = 'user@myserver.com',
    --},
}

-- Курсор
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 800

-- Bell
config.audible_bell = 'Disabled'

-- BIDI support для арабского/иврита
config.bidi_enabled = true

-- Производительность
config.front_end = 'WebGpu' -- или 'Software' для старых систем


config.keys = {

    -- Ручное сохранение всей сессии
    {
        key = 'S',
        mods = 'LEADER',
        action = wezterm.action_callback(function(win, pane)
            resurrect.save_state(resurrect.workspace_state.get_workspace_state())
            wezterm.notify("Session saved", "Workspace state saved successfully")
        end),
    },

    -- Восстановление сессии (fuzzy finder)
    {
        key = 'R',
        mods = 'LEADER',
        action = wezterm.action.Multiple({
            wezterm.action_callback(function(win, pane)
                resurrect.fuzzy_load(win, pane, function(id, label)
                    local state = resurrect.load_state(id, "workspace")
                    resurrect.workspace_state.restore_workspace(state, {
                        relative = true,
                        restore_text = true,
                        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
                    })
                end)
            end),
        }),
    },

    -- Быстрое восстановление последней сессии
    {
        key = 'L',
        mods = 'LEADER',
        action = wezterm.action.Multiple({
            wezterm.action_callback(function(win, pane)
                resurrect.resurrect.load_state("default", "workspace")
            end),
        }),
    },

    -- Detach (выйти из сессии, оставив её работать)
    {
        key = 'd',
        mods = 'LEADER',
        action = wezterm.action.DetachDomain { DomainName = 'unix' }
    },

    -- Attach (войти в существующую сессию)
    {
        key = 'a',
        mods = 'LEADER',
        action = wezterm.action.AttachDomain 'unix'
    },

    -- Показать список воркспейсов
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' }
    },

    -- Переключение между воркспейсами (разные проекты)
    { key = '9', mods = 'LEADER', action = wezterm.action.SwitchToWorkspace { name = 'default' } },
    { key = '0', mods = 'LEADER', action = wezterm.action.SwitchToWorkspace { name = 'work' } },

    -- Вход в copy-mode с Vi bindings
    { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },

    -- Разделение панелей
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- Навигация между панелями
    { key = 'h', mods = 'ALT',    action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'ALT',    action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'ALT',    action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'ALT',    action = wezterm.action.ActivatePaneDirection 'Right' },

    -- Новая вкладка
    { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    -- Закрыть вкладку
    { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true } },

    -- Переключение вкладок
    --{ key = 'n', mods = 'ALT',    action = wezterm.action.ActivateTabRelative(1) },
    --{ key = 'p', mods = 'ALT',    action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'h', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'l', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1) },

    -- Переименование вкладки
    {
        key = ',',
        mods = 'LEADER',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }
    },


    -- Zoom/unzoom панели
    { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },

    -- Перемещение панелей
    { key = '{', mods = 'LEADER', action = wezterm.action { MoveTabRelative = -1 } },
    { key = '}', mods = 'LEADER', action = wezterm.action { MoveTabRelative = 1 } },

    -- Switch to the default workspace
    {
        key = 'y',
        mods = 'CTRL|SHIFT|ALT',
        action = act.SwitchToWorkspace {
            name = 'default',
        },
    },
    -- Switch to a monitoring workspace, which will have `top` launched into it
    {
        key = 'u',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'monitoring',
            spawn = {
                args = { 'top' },
            },
        },
    },
    -- Create a new workspace with a random name and switch to it
    { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
    -- Show the launcher in fuzzy selection mode and have it list all workspaces
    -- and allow activating one.
    {
        key = '9',
        mods = 'ALT',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    -- Prompt for a name to use for a new workspace and switch to it.
    {
        key = 'W',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },
}


-- Цвета границ панелей
config.colors = {
    split = '#444444',
}

-- Толщина границы
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}

-- Подсветка активной панели
config.window_frame = {
    active_titlebar_bg = '#333333',
    inactive_titlebar_bg = '#1a1a1a',
}


-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return '3024 (dark) (terminal.sexy)'
    else
        return '3024 (light) (terminal.sexy)'
    end
end

-- This is where you actually apply your config choices.

-- Размер окна при старте
config.initial_cols = 120
config.initial_rows = 28

--config.window_decorations = "NONE"

-- Скрыть таб-бар если только одна вкладка
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Прозрачность и размытие (macOS/Windows)
config.window_background_opacity = 0.99
config.macos_window_background_blur = 20 -- если macOS

-- changing the font size and color scheme.
--config.font = wezterm.font 'JetBrains Mono'
config.font = wezterm.font {
    family = 'JetBrainsMono Nerd Font',
    weight = 'Medium',
}
config.font_size = 12.0
config.line_height = 1.2

config.color_scheme = scheme_for_appearance(get_appearance())


-- Finally, return the configuration to wezterm:
return config
