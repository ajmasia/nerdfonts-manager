# Nerd Fonts Manager (nfm)

Easily install, manage, and remove [Nerd Fonts](https://www.nerdfonts.com/) directly from your terminal.

## ✨ Features

* Interactive font selection with **fzf**
* Install fonts from the official Nerd Fonts releases
* Uninstall fonts interactively or by name
* Works with `$XDG_DATA_HOME/fonts` or `~/.fonts`
* Distro/NixOS detection for missing dependencies

## 📦 Installation

### From GitHub (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/ajmasia/nerdfonts-manager/main/install.sh | bash
```

### From source (dev mode)

Clone the repository and run directly:

```bash
git clone https://github.com/ajmasia/nerdfonts-manager.git
cd nerdfonts-manager
./nfm -h
```

## 🚀 Usage

| Command                   | Description                                  | Example                      |
| ------------------------- | -------------------------------------------- | ---------------------------- |
| `nfm -h`                  | Show global help                             | `nfm -h`                     |
| `nfm -v`, `nfm --version` | Show current version                         | `nfm --version`              |
| `nfm list`                | List installed fonts                         | `nfm list`                   |
| `nfm install`             | Interactive installation (select with `fzf`) | `nfm install`                |
| `nfm install <FONT...>`   | Install one or more specific fonts           | `nfm install FiraCode Meslo` |
| `nfm uninstall`           | Interactive uninstall (select with `fzf`)    | `nfm uninstall`              |
| `nfm uninstall <FONT...>` | Uninstall one or more specific fonts         | `nfm uninstall Meslo`        |

## ❌ Uninstall

To remove Nerd Fonts Manager from your system:

```bash
curl -fsSL https://raw.githubusercontent.com/ajmasia/nerdfonts-manager/main/uninstall.sh | bash
```

## 📝 License

This project is licensed under the [MIT License](./LICENSE).

