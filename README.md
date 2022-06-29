![GitHub](https://img.shields.io/github/license/leizongmin/newos)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fleizongmin%2Fnewos?ref=badge_shield)
[![Makefile CI](https://github.com/leizongmin/newos/actions/workflows/makefile.yml/badge.svg)](https://github.com/leizongmin/newos/actions/workflows/makefile.yml)

# newos

A Linux kernel based operating system.

## Why this project

This is my testing ground for learning the operating system, and I want to implement it in a different way from the traditional.

I want this new OS to keep the following features:

-   As far as I know, Rust will be merged into the Linux kernel. In this operating system, it uses **Rust** as much as possible to develop core software.
-   All software will be **statically compiled** as much as possible to ensure that you can use the latest or very old version, no matter what the libc version is.
-   Use **modern alternatives** to essential command line tools as much as possible.
-   Use the **latest software version** whenever possible.

## Development

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

-   [ ] Core software:
    -   [x] Use [uutils/coreutils](https://github.com/uutils/coreutils) as an alternative to GNU coreutils.
    -   [ ] Use [BusyBox](https://busybox.net/) as a complement to uutils/coreutils.
    -   [x] Use [Nushell](https://www.nushell.sh/) as the default shell.
    -   [ ] Use [Homebrew](https://brew.sh/) as the default package manager.
    -   [ ] [Git](https://git-scm.com/).
    -   [ ] [libc](https://www.gnu.org/software/libc/).
    -   [ ] Use [Vim](https://www.vim.org/) as the default text editor.
    -   [ ] Use [ncdu](https://dev.yorhel.nl/ncdu) as a replacement for du.
    -   [ ] Use [htop](https://htop.dev/) as a replacement for top.
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
