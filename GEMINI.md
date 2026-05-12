# Project Documentation: Kickstart.nvim (Modified)

This project is a personalized configuration of **Kickstart.nvim**, a lightweight and modular starting point for Neovim. It is designed to be fully readable and customizable while providing a modern development environment.

## 🏗 Architecture & Structure

The configuration follows a modular layout:

- **`init.lua`**: The primary entry point. It handles core settings, keymaps, autocommands, and orchestrates the plugin manager (`lazy.nvim`).
- **`lua/kickstart/`**: Contains baseline Kickstart modules.
    - `plugins/*.lua`: Modularized core plugins (e.g., `neo-tree`, `gitsigns`, `lint`, `debug`).
- **`lua/custom/`**: The designated area for user-specific extensions.
    - `plugins/init.lua`: Your custom plugin list (e.g., `alpha-nvim`, `bufferline.nvim`, `vim-visual-multi`).

## 🛠 Core Tech Stack

- **Plugin Manager**: `lazy.nvim`
- **LSP Support**: `nvim-lspconfig` with `mason.nvim` for tool management.
- **Autocompletion**: `saghen/blink.cmp` (modern alternative to nvim-cmp).
- **Tree-sitter**: `nvim-treesitter` for advanced syntax highlighting and indentation.
- **Fuzzy Finder**: `telescope.nvim`.
- **UI**: `tokyonight-night` colorscheme, `bufferline.nvim` for tabs, and `alpha-nvim` for the dashboard.
- **Utils**: `mini.nvim` (various modules), `conform.nvim` (formatting), `which-key.nvim` (keybind documentation).

## ⌨️ Key Conventions

### Leader Keys
- `mapleader`: `<Space>`
- `maplocalleader`: `<Space>`

### Custom Keymaps (Highlights)
- **General**:
  - `<Esc>`: Clear search highlights.
  - `<leader>q`: Open diagnostic quickfix list.
  - `<C-h/j/k/l>`: Navigate between windows.
- **Editing**:
  - `p` (Visual Mode): Paste without losing current registry ("_dP).
  - `<`/`>` (Visual Mode): Stay in indent mode after shifting.
- **Navigation**:
  - `<Tab>`/`<S-Tab>`: Cycle through buffers (`bufferline`).
  - `<leader>1-9`: Go to specific buffer.
  - `<leader>sh`: [S]earch [H]elp (Telescope).
- **LSP**:
  - `grn`: [R]e[n]ame symbol.
  - `gra`: [G]oto Code [A]ction.
  - `grD`: [G]oto [D]eclaration.

## 🔄 Workflows

### Plugin Management
- Add core Kickstart plugins by uncommenting `require 'kickstart.plugins.xxx'` in `init.lua`.
- Add personal plugins to `lua/custom/plugins/init.lua`.
- Run `:Lazy` to manage plugin installation and updates.

### LSP & Formatting
- **Installation**: Use `:Mason` to install LSPs, formatters, and linters.
- **Formatting**: Triggered on save (`BufWritePre`) via `conform.nvim` or manually with `<leader>f`.

### Diagnostics & Linting
- Diagnostics are shown in-line and in the gutter.
- Linting is handled by `nvim-lint` (when enabled via `kickstart.plugins.lint`).

## 🗒 System Notes
- **Cargo Path**: The config automatically adds `~/.cargo/bin` to the Neovim PATH to ensure `tree-sitter-cli` and other Rust-based tools are accessible.
- **Nerd Fonts**: `vim.g.have_nerd_font` is set to `true`.
- **Operating System**: Optimized for Linux (specifically Ubuntu/Debian based on example files).
