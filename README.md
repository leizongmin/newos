![GitHub](https://img.shields.io/github/license/leizongmin/newos)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos?ref=badge_shield)
[![Makefile CI](https://github.com/leizongmin/newos/actions/workflows/makefile.yml/badge.svg)](https://github.com/leizongmin/newos/actions/workflows/makefile.yml)

# newos

A Linux kernel based operating system

## Build

Requirements:

-   Newer macOS or Linux operating system.
-   Newer [Docker](https://www.docker.com/) installed.
-   Newer [Rust](https://www.rust-lang.org/) installed _(will be installed automatically via the `make init` command)_.

Run below commands:

```bash
# initialize the development environment
make init
# make all targets
make all
```

## Try it with Docker

Build and run manually:

```bash
make docker-image && make docker-run
```

or use a pre-built version:

```bash
docker run -it --rm ghcr.io/leizongmin/newos:main
```

## TODO

-   [ ] Softwares:
    -   [x] Use [uutils/coreutils](https://github.com/uutils/coreutils) as an alternative to GNU coreutils.
    -   [x] Use [Nushell](https://www.nushell.sh/) as the default shell.
    -   [ ] Use [Homebrew](https://brew.sh/) as the default package manager.
-   [ ] Boot:
    -   [ ] Build the [Linux Kernel](https://github.com/torvalds/linux) from source.
    -   [ ] Use [GRUB](https://www.gnu.org/software/grub/) as the boot loader.
    -   [ ] Start and develop with [QEMU](https://www.qemu.org/).
    -   [ ] Text-based Installer.
-   [ ] GUI:
    -   [ ] [Wayland](https://wayland.freedesktop.org/).
    -   [ ] A window manager written in rust.

## License

Under the terms of the [MIT License](LICENSE).

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos?ref=badge_large)
