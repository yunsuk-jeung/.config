local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
	-- padding_left = -8,
	display = "active",
	icon = {
		font = settings.icons,
		y_offset = -1,
	},
	label = {
		padding_left = 6,
		font = {
			style = settings.font.style_map["Bold"],
			size = 13.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	local lookup = app_icons[env.INFO]
	local icon = ((lookup == nil) and app_icons["default"] or lookup)

	front_app:set({
		icon = {
			string = icon,
		},
		label = {
			string = env.INFO,
		},
	})
end)

-- front_app:subscribe("mouse.clicked", function(env)
--     sbar.trigger("swap_menus_and_spaces")
-- end)
