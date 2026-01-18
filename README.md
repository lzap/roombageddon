# ROOMBAGEDDON

A TIC-80 game by Lukáš Zapletal aka `lzap`.

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

To run and test your game:

```
make run
```

### Building

To build your game:

```
make build
```

## Acknowledgments

- [@nesbox](https://github.com/nesbox): the [TIC-80](https://tic80.com/) creator.
- [@luizdepra's template](https://github.com/luizdepra/tic80-lua-template): the project template.
