package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

local sbar = require('sketchybar')

sbar.begin_config()
require('bar')
require('aerospace')
sbar.end_config()

sbar.event_loop()
