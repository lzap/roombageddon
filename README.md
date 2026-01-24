# ROOMBAGEDDON

A TIC-80 game by Lukas `lzap` Zapletal & Ondra `ozap` Zapletal.

This one is a tad overengineered since it will be used for my talk at DevConf.

### HOW TO PLAY

* Use D-Pad on gamepad or keyboard arrows to move the robot one.
* Use ABXY gamepad buttons or ASDW keys to move the robot two.
* Robots clean the floor but will not enter already cleaned tiles.
* You control multiple robots at once.
* Solve all levels.
* When you get stuck, press `(A)` or key `X` to reset the level

[Play ROOMBAGEDDON in your browser!](https://lukas.zapletalovi.com/roombageddon/)

### TODO

* Each robot has battery (limited amount of moves).
* Add music, perhaps in Rumba style.

## Requirements for development

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
