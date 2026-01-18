-- consts --
local BLACK = 0
local PURPLE = 1
local RED = 2
local ORANGE = 3
local YELLOW = 4
local L_GREEN = 5
local GREEN = 6
local D_GREEN = 7
local D_BLUE = 8
local BLUE = 9
local L_BLUE = 10
local CYAN = 11
local WHITE = 12
local L_GRAY = 13
local GRAY = 14
local D_GRAY = 15

local UP = 0
local DOWN = 1
local LEFT = 2
local RIGHT = 3
local A = 4 -- Z
local B = 5 -- X
local X = 6 -- A
local Y = 7 -- S
local NONE = 99

---@type number
SCREEN_WIDTH = 240
---@type number
SCREEN_HEIGHT = 136

---@type number
TILE_SIZE = 8
---@type number
SPRITE_SIZE = 8

---@type number
MAPS_PER_ROW = 8
---@type number
MAP_WIDTH = 30
---@type number
MAP_HEIGHT = 17

---@class ButtonsTable
---@field A number
---@field B number
---@field X number
---@field Y number
---@field LEFT number
---@field RIGHT number
---@field UP number
---@field DOWN number
---@field NONE number

---@type ButtonsTable
BUTTONS = {
	A = A,
	B = B,
	X = X,
	Y = Y,
	LEFT = LEFT,
	RIGHT = RIGHT,
	UP = UP,
	DOWN = DOWN,
	NONE = NONE
}

---@class Direction
---@field x number
---@field y number

---@type table<number, Direction>
DIRS = {
	[UP] = {
		x = 0,
		y = -1
	},
	[DOWN] = {
		x = 0,
		y = 1
	},
	[LEFT] = {
		x = -1,
		y = 0
	},
	[RIGHT] = {
		x = 1,
		y = 0
	},
	[NONE] = {
		x = 0,
		y = 0
	}
}

---@class ColorsTable
---@field BLACK number
---@field PURPLE number
---@field RED number
---@field ORANGE number
---@field YELLOW number
---@field L_GREEN number
---@field GREEN number
---@field D_GREEN number
---@field D_BLUE number
---@field BLUE number
---@field L_BLUE number
---@field CYAN number
---@field WHITE number
---@field L_GRAY number
---@field GRAY number
---@field D_GRAY number

---@type ColorsTable
COLORS = {
	BLACK = BLACK,
	PURPLE = PURPLE,
	RED = RED,
	ORANGE = ORANGE,
	YELLOW = YELLOW,
	L_GREEN = L_GREEN,
	GREEN = GREEN,
	D_GREEN = D_GREEN,
	D_BLUE = D_BLUE,
	BLUE = BLUE,
	L_BLUE = L_BLUE,
	CYAN = CYAN,
	WHITE = WHITE,
	L_GRAY = L_GRAY,
	GRAY = GRAY,
	D_GRAY = D_GRAY
}
