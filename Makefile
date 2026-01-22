.PHONY: run fmt lint build export clean

LUACC := luacc
TIC80 ?= $(shell which tic80 || echo /Applications/tic80.app/Contents/MacOS/tic80)
DARKLUA = darklua

PLATFORM := html
GAME_NAME := roombageddon

BUILD_DIR := build
EXPORT_DIR := export
SRC_DIR := src
TIC := $(BUILD_DIR)/$(GAME_NAME).tic

SOURCES := $(shell find . -type f -name "*.lua" ! -name "$(GAME_NAME).lua" ! -path "./$(BUILD_DIR)/*" ! -path "./$(EXPORT_DIR)/*")
TABLES := $(shell find ./$(SRC_DIR) -type f -name "*.lua" | sed -e "s/^\.\/$(SRC_DIR)\/// ; s/\.lua$$// ; s/\//\./g")

run:
	$(TIC80) --scale=5 --skip --fs=. --cmd="load main.lua & run"

fmt:
	@stylua src

lint:
	@./lint

$(GAME_NAME).lua: $(SOURCES)
	$(LUACC) -o $(GAME_NAME).lua -p 6 -i ./ -i ./$(SRC_DIR) main $(TABLES)

$(TIC): $(GAME_NAME).lua
	@rm -f $(TIC)
	$(TIC80) --skip --fs=. --cli --cmd="load $(GAME_NAME).lua & save $(TIC) & exit"

build: $(TIC)

export: $(TIC)
	@mkdir -p $(EXPORT_DIR)
	$(TIC80) --skip --fs=. --cli --cmd="load $(TIC) & export html $(EXPORT_DIR)/$(GAME_NAME) & exit"

clean:
	@rm -rf $(EXPORT_DIR) $(GAME_NAME).lua $(GAME_NAME).tic
