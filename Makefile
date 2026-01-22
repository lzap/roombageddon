.PHONY: run fmt lint export clean

LUACC := luacc
TIC80 ?= $(shell which tic80 || echo /Applications/tic80.app/Contents/MacOS/tic80)
DARKLUA = darklua

PLATFORM := html
GAME_NAME := roombageddon

BUILD_DIR := build
EXPORT_DIR := export
SRC_DIR := src
TIC := $(BUILD_DIR)/$(GAME_NAME).tic

SOURCES := $(shell find . -type f -name "*.lua")
TABLES := $(shell find ./$(SRC_DIR) -type f -name "*.lua" | sed -e "s/^\.\/$(SRC_DIR)\/// ; s/\.lua$$// ; s/\//\./g")

run:
	$(TIC80) --scale=5 --skip --fs=. --cmd="load main.lua & run"

fmt:
	@stylua src

lint:
	@./lint

$(GAME_NAME).lua: $(SOURCES)
	@mkdir -p $(BUILD_DIR)
	@rm -f $(TIC)
	$(LUACC) -o $(GAME_NAME).lua -p 6 -i ./ -i ./$(SRC_DIR) main $(TABLES)

build: $(TIC)

export:
	@mkdir -p $(EXPORT_DIR)
	$(TIC80) --skip --fs=. --cli --cmd="load $(TIC) & export html $(EXPORT_DIR)/$(GAME_NAME) & exit"

clean:
	@rm -rf $(EXPORT_DIR) $(GAME_NAME).lua $(GAME_NAME).tic
