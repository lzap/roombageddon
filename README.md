# ROOMBAGEDDON

A TIC-80 game by Lukáš `lzap` Zapletal & Ondra `ozap` Zapletal.

### HOW TO PLAY

* Use D-Pad or keyboard arrows to move the robot.
* Robot cleans the floor but will not enter already cleaned tiles.
* You control multiple robots at once.
* Solve all levels.
* When you get stuck, press `(A)` or key `X` to reset the level

### TODO

* Sort levels
* More levels
* Auto level find instead of constant
* Last "bonus" level (spawn 99 players)

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
