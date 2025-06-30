local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 17

config.enable_tab_bar = false

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.window_decorations = "RESIZE"

-- Helper function to find the tmux executable in common locations
local function find_tmux_executable()
  -- wezterm.glob is a safe, documented way to check for file existence.
  -- It returns a table of matching file paths.
  local search_paths = {
    '/opt/homebrew/bin/tmux', -- Standard for Apple Silicon Homebrew
    '/usr/local/bin/tmux',    -- Standard for Intel Homebrew
    '/usr/bin/tmux',
    '/bin/tmux',
  }
  for _, path in ipairs(search_paths) do
    if #wezterm.glob(path) > 0 then
      return path
    end
  end
  return nil
end

local tmux_path = find_tmux_executable()

if tmux_path then
  wezterm.log_info("tmux found at: " .. tmux_path .. ", setting as default program.")
  config.default_prog = { tmux_path, 'new-session', '-As', 'main' }
else
  wezterm.log_warn("tmux not found in search paths, using default shell.")
end

return config
