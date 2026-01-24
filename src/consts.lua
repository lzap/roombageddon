-- Comment out for the release build
FIRST_LEVEL = 12

SPR_UP = 480
SPR_RIGHT = 481
SPR_DOWN = 482
SPR_LEFT = 483
SPR_A = 484
SPR_S = 485
SPR_D = 486
SPR_W = 487
SPR_Z = 488
SPR_X = 489

SPRK_UP = 496
SPRK_RIGHT = 497
SPRK_DOWN = 498
SPRK_LEFT = 499
SPRK_A = 500
SPRK_S = 501
SPRK_D = 502
SPRK_W = 503
SPRK_Z = 504
SPRK_X = 505

LEVELS = {
	{ Text = { "USE", SPR_UP, SPR_RIGHT, SPR_DOWN, SPR_LEFT, "TO MOVE" } },
	{ Text = { "CLEAN ALL FLOOR, RESET WITH", SPR_Z, "OR", SPR_X } },
	{ Text = "CANNOT CROSS CLEANED FLOOR" },
	{ Text = "NO WAY BACK" },
	{ Text = "MOVE THEM BOTH" },
	{ Text = "WALLS CAN HELP" },
	{
		Text = "USE WALLS WISELY",
		Solution = "1>1>1^1>1>1<1<1v1<1<",
	},
	{ Text = "THE FIRST CHALLENGE" },
	{ Text = { "MOVE THE BLUE ONE WITH", SPR_W, SPR_A, SPR_S, SPR_D } },
	{ Text = "BATTERY IS LIMITED", BatOne = { 18, 18 }, BatTwo = { 18, 18 } },
	{ Text = "BATTERIES ARE LIMITED", BatOne = { 6, 7 }, BatTwo = { 6, 7 } },
	{ Text = "UNLIMITED BATTERY FOR THIS ONE" },
	{
		Text = "YOU KNOW WHAT...",
		BatOne = { 9, 11 },
		BatTwo = { 5, 9 },
		Solution = "1<1v1<1^1^1<1v1<1^1^1<1>1v1v1>1^1>1v1>1^2v2>2v2<2<2v2^2>2^2<2^2^2>2^",
	},
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

DIRECTION_CHARS = {
	[LEFT] = "<",
	[RIGHT] = ">",
	[UP] = "^",
	[DOWN] = "v",
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
