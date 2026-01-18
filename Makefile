.PHONY: all build lint fmt run

LUACC := luacc
TIC80 ?= $(shell which tic80 || echo /Applications/tic80.app/Contents/MacOS/tic80)

PLATFORM := html
GAME_NAME := roombageddon

BUILD_DIR := build
SRC_DIR := src

SOURCES := $(shell find ./$(SRC_DIR) -type f -name "*.lua" | sed -e "s/^\.\/$(SRC_DIR)\/// ; s/\.lua$$// ; s/\//\./g")

all: build

build:
	$(LUACC) -o game.lua -p 6 -i ./ -i ./$(SRC_DIR) main $(SOURCES)
	mkdir -p $(BUILD_DIR)
	$(TIC80) --skip --fs=. --cli --cmd="new lua & import game.lua & export $(PLATFORM) $(BUILD_DIR)/$(GAME_NAME) alone=1 & exit"

fmt:
	@stylua src/ main.lua

lint:
	@./lint

run:
	$(TIC80) --scale=5 --skip --fs=. --cmd="load main.lua & run"
