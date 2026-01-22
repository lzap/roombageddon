-- Comment out for the release build
FIRST_LEVEL = 11

LEVEL_TEXT = {
	[0] = "D-pad or arrows to move",
	[1] = "All tiles must be cleaned",
	[2] = "Cleaning is single-pass only",
	[3] = "No backtracking allowed",
	[4] = "You move them all",
	[5] = "Clean all rooms",
	[6] = "There is only one way",
	[7] = "Do not get stuck",
	[8] = "",
	[9] = "",
}

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

UP = 0
DOWN = 1
LEFT = 2
RIGHT = 3

local A = 4 -- Z
local B = 5 -- X
local X = 6 -- A
local Y = 7 -- S
local NONE = 99

SCREEN_WIDTH = 240
SCREEN_HEIGHT = 136

TILE_SIZE = 8
SPRITE_SIZE = 8
MOVE_SPEED = 1

MAPS_PER_ROW = 8
MAP_WIDTH = 30
MAP_HEIGHT = 17

GONE = 1
GTWO = 2

PONE_SPR_UP = 64
PONE_SPR_DOWN = 80
PONE_SPR_LEFT = 96
PONE_SPR_RIGHT = 112

PTWO_SPR_UP = 128
PTWO_SPR_DOWN = 144
PTWO_SPR_LEFT = 160
PTWO_SPR_RIGHT = 176

MAX_LEVELS = MAPS_PER_ROW * MAPS_PER_ROW

BUTTONS = {
	A = A,
	B = B,
	X = X,
	Y = Y,
	LEFT = LEFT,
	RIGHT = RIGHT,
	UP = UP,
	DOWN = DOWN,
	NONE = NONE,
}

DIRS = {
	[UP] = {
		x = 0,
		y = -1,
	},
	[DOWN] = {
		x = 0,
		y = 1,
	},
	[LEFT] = {
		x = -1,
		y = 0,
	},
	[RIGHT] = {
		x = 1,
		y = 0,
	},
	[NONE] = {
		x = 0,
		y = 0,
	},
}

ROTATE_NONE = 0
ROTATE_90 = 1
ROTATE_180 = 2
ROTATE_270 = 3

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
	D_GRAY = D_GRAY,
}

SFX_NONE = 0
SFX_MOVED = 1
SFX_BUMPED = 2
