.PHONY: all build run

LUACC := luacc
TIC80 := /Applications/tic80.app/Contents/MacOS/tic80

PLATFORM := linux
GAME_NAME := mygame

BUILD_DIR := build
SRC_DIR := src

SOURCES := $(shell find ./$(SRC_DIR) -type f -name "*.lua" | sed -e "s/^\.\/$(SRC_DIR)\/// ; s/\.lua$$// ; s/\//\./g")

all: build

build:
	$(LUACC) -o game.lua -p 6 -i ./ -i ./$(SRC_DIR) main $(SOURCES)
	mkdir -p $(BUILD_DIR)
	$(TIC80) --skip --fs=. --cli --cmd="load game.lua & export $(PLATFORM) $(BUILD_DIR)/$(GAME_NAME) alone=1 & exit"

run:
	$(TIC80) --scale=5 --skip --fs=. --cmd="load main.lua & run"

.PHONY: lint
lint:
	~/.cursor/extensions/sumneko.lua-3.16.4-darwin-arm64/server/bin/lua-language-server --check=.