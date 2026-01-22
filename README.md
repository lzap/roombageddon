# ROOMBAGEDDON

A TIC-80 game by Lukas `lzap` Zapletal & Ondra `ozap` Zapletal.

### HOW TO PLAY

* Use D-Pad or keyboard arrows to move the robot.
* Robot cleans the floor but will not enter already cleaned tiles.
* You control multiple robots at once.
* Solve all levels.
* When you get stuck, press `(A)` or key `X` to reset the level
* Rename to RUMBAPOCALYPSE and make music in Rumba style.

### TODO

* Add obfuscator (I am almost at 64k now)
* Two-hand mode (dpad + ABXY)
* Auto level find instead of constant
* Sort levels
* More levels
* Multiplayer (2 players each one hand)

## Requirements

- TIC-80 PRO (consider buying the PRO version or sponsoring @nesbox)
- Linux or MacOS (it probably works on Windows with MinGW or WSL)
- GNU Make
- luarocks
- luacc
- stylua

Something like (MacOS):

```
brew install lua luarocks stylua
luarocks install luacc
```

### Runing

To run and test the game:

```
make run
```

### Building

To build the game:

```
make fmt lint build
```

## Acknowledgments

- [@nesbox](https://github.com/nesbox): the [TIC-80](https://tic80.com/) creator.
- [@luizdepra's template](https://github.com/luizdepra/tic80-lua-template): the project template.
- [fancade](https://play.fancade.com/): the main game mechanic.
