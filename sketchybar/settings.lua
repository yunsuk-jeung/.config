local colors = require("colors")
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 3,
	modes = {
		main = {
			icon = icons.apple,
			-- color = colors.rainbow[1],
			color = colors.white,
		},
		service = {
			icon = icons.nuke,
			color = 0xffff9e64,
		},
	},
	bar = {
		height = 36,
		padding = {
			x = 10,
			y = 0,
		},
		background = colors.transparent,
		-- background = colors.bar.bg
	},
	items = {
		height = 22,
		gap = 5,
		padding = {
			right = 16,
			left = 12,
			top = 0,
			bottom = 0,
		},
		default_color = function(workspace)
			return colors.rainbow[workspace + 1]
		end,
		highlight_color = function(workspace)
			return colors.rainbow[workspace + 1]
		end,
		colors = {
			background = colors.bg1,
		},
		corner_radius = 6,
	},

	icons = "sketchybar-app-font:Regular:16.0", -- alternatively available: NerdFont

	-- NOTE: icons.lua 의 아이콘 대부분이 SF Symbols 전용 글리프(U+100xxx)라
	-- Nerd Font 로 두면 두부(tofu)로 깨진다. SF Pro / SF Mono 필요:
	--   brew install --cask font-sf-pro font-sf-mono
	font = {
		text = "SF Pro", -- Used for text
		numbers = "SF Mono", -- Used for numbers
		-- SF Symbols 에 대응 글리프가 없는 아이콘(apple/nuke)만 이 폰트로 렌더한다.
		nerd = "FiraCode Nerd Font Mono",
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Semibold",
			["Bold"] = "Bold",
			["Heavy"] = "Heavy",
			["Black"] = "Black",
		},
	},
}
