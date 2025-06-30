local sbar = require('sketchybar')
local colors = require('colors')

sbar.add('event', 'aerospace_workspace_change')

sbar.exec('aerospace list-workspaces --all', function(results) 
	for workspace_name in string.gmatch(results, "%S+") do
		sbar.add(
			"item",
			"space."..workspace_name,
			{
				align = "left",
				label = workspace_name:sub(3,4),
				background = {
					color = colors.blue,
					corner_radius = 5,
					height = 20,
					drawing = false,
				},
				script = './plugins/aerospace.sh',
				click_script = 'aerospace workspace ' .. workspace_name,
			}
		)
	end
end)
