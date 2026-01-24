.PHONY: run fmt lint build export clean

LUACC := luacc
TIC80 ?= $(shell which tic80 || echo /Applications/tic80.app/Contents/MacOS/tic80)
DARKLUA = darklua
MINIFY := ./minify.py

PLATFORM := html
GAME_NAME := roombageddon

BUILD_DIR := build
EXPORT_DIR := export
SRC_DIR := src
LUA_FILE := $(BUILD_DIR)/$(GAME_NAME).lua
TIC_FILE := $(BUILD_DIR)/$(GAME_NAME).tic

SOURCES := $(shell find . -type f -name "*.lua" ! -path "./$(BUILD_DIR)/*" ! -path "./$(EXPORT_DIR)/*")
TABLES := $(shell find ./$(SRC_DIR) -type f -name "*.lua" | sed -e "s/^\.\/$(SRC_DIR)\/// ; s/\.lua$$// ; s/\//\./g")

run:
	$(TIC80) --scale=5 --skip --fs=. --cmd="load main.lua & run"

run-minified: $(LUA_FILE)
	$(TIC80) --scale=5 --skip --fs=. --cmd="load $(LUA_FILE) & run"

fmt:
	@stylua src

lint:
	@./lint

$(LUA_FILE): $(SOURCES) $(MINIFY)
	$(LUACC) -o $(LUA_FILE) -p 6 -i ./ -i ./$(SRC_DIR) main $(TABLES)
	$(MINIFY) $(LUA_FILE)

$(TIC_FILE): $(LUA_FILE)
	@rm -f $(TIC_FILE)
	$(TIC80) --skip --fs=. --cli --cmd="load $(LUA_FILE) & save $(TIC_FILE) & exit"

build: $(TIC_FILE)

export:
	@mkdir -p $(EXPORT_DIR)
	$(TIC80) --skip --fs=. --cli --cmd="load $(TIC_FILE) & export html $(EXPORT_DIR)/$(GAME_NAME) & exit"

clean:
	@rm -rf $(EXPORT_DIR) $(LUA_FILE) $(TIC_FILE)
