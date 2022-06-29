[![Makefile CI](https://github.com/leizongmin/newos/actions/workflows/makefile.yml/badge.svg)](https://github.com/leizongmin/newos/actions/workflows/makefile.yml)

# newos
A Linux kernel based operating system

## Build

```bash
# initialize the development environment
make init
# make all targets
make all
```

## Run on Docker

```bash
make docker-image && make docker-run
```

## TODO

- [x] Use [uutils/coreutils](https://github.com/uutils/coreutils) as an alternative to GNU coreutils.
- [ ] Use [Nushell](https://www.nushell.sh/) as the default shell.
- [ ] Use [Homebrew](https://brew.sh/) as the default package manager.

## License

Under the terms of the [MIT License](LICENSE).
