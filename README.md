# Dotfiles

My personal configuration files for Neovim and tmux.

## Installation

### tmux

1. Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Move tmux configuration:
```bash
cp tmux/.tmux.conf ~/.tmux.conf
```

### Neovim

1. Install NvChad (backup existing config first):
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
git clone https://github.com/NvChad/starter ~/.config/nvim
```

2. Open Neovim to complete NvChad installation:
```bash
nvim
```

3. Move my custom configuration:
```bash
cp -r nvim/* ~/.config/nvim/
```

For more information about NvChad, visit: https://nvchad.com/docs/quickstart/install