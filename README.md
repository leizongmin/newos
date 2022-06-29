![GitHub](https://img.shields.io/github/license/leizongmin/newos)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos?ref=badge_shield)
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


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos?ref=badge_large)
