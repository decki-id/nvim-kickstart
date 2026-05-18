# nvim-kickstart

![StyLua](https://github.com/decki-id/nvim-kickstart/actions/workflows/stylua.yml/badge.svg)

A personalized Neovim configuration built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

This is **not** a generic starter template — it is my daily-driver setup, maintained across Ubuntu 22.04 and Windows 11. It keeps kickstart's single-file philosophy and extensive inline documentation, but adds opinionated UI enhancements, multi-platform tooling fixes, and AI-friendly documentation conventions.

---

## What's Different from Upstream Kickstart

| Addition | Description |
|----------|-------------|
| **alpha-nvim** | Startify-style dashboard with smart buffer-guard logic |
| **bufferline.nvim** | Numbered buffer tabs with `<leader>1-9` shortcuts and `<Tab>`/`<S-Tab>` cycling |
| **vim-visual-multi** | Multi-cursor editing (Vimscript plugin) |
| **nvim-treesitter-context** | Sticky context lines at the top of the window |
| **~/.cargo/bin PATH injection** | Ensures `tree-sitter-cli` (installed via cargo) is discoverable regardless of shell config |
| **Cross-platform variants** | `init.lua.cargo.ubuntu.example` and `init.lua.gcc.w11.example` capture platform-specific compiler setups |

### Notable Custom Behaviors

- **`:Bd`** — wraps `vim-bbye`'s `:Bdelete` to preserve window layout when closing buffers
- **`:STerm`** — opens a terminal, automatically moving focus out of neo-tree
- **Diagnostics float on jump** — automatically opens a floating diagnostic window when navigating with `[d` / `]d`
- **Empty buffer cleanup** — auto-wipes unnamed empty buffers when real files or terminals are opened
- **2-space indent** — enforced for `sql`, `php`, and `json`

---

## Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Ubuntu 22.04 | ✅ Primary | `tree-sitter-cli` compiled from source via cargo (see [TREESITTER_ISSUE_UBU_FIXED.md](TREESITTER_ISSUE_UBU_FIXED.md)) |
| Windows 11 | ✅ Supported | MinGW gcc with UCRT DLL fix applied (see [TREESITTER_ISSUE_W11_FIXED.md](TREESITTER_ISSUE_W11_FIXED.md)) |
| Decki's Laptop | ✅ Active | Ubuntu 22.04 + W11 dual-boot |

---

## Requirements

- Neovim 0.11+ (stable or nightly)
- `git`, `make`, `unzip`
- `ripgrep`, `fd-find`
- `tree-sitter` CLI
- Nerd Font (set `vim.g.have_nerd_font = true` in `init.lua`)
- C compiler (`gcc` / `clang`)

For OS-specific install commands, see the [upstream kickstart install recipes](https://github.com/nvim-lua/kickstart.nvim#install-recipes).

---

## Installation

> ⚠️ Back up your existing `~/.config/nvim` first.

```sh
git clone https://github.com/decki-id/nvim-kickstart.git ~/.config/nvim
```

Then start Neovim:

```sh
nvim
```

Lazy.nvim will bootstrap itself and install all plugins. Use `:Lazy` to check status, `:checkhealth` to validate your environment, and `:checkhealth kickstart` for kickstart-specific diagnostics.

---

## Structure

```
~/.config/nvim/
├── init.lua                          # Main config (single-file)
├── init.lua.example                  # Pristine upstream kickstart reference
├── init.lua.cargo.ubuntu.example     # Ubuntu: tree-sitter via cargo
├── init.lua.gcc.w11.example          # Windows 11: tree-sitter via gcc
├── lazy-lock.json                    # Plugin lockfile (committed)
├── .stylua.toml                      # Lua formatter config
├── .github/copilot-instructions.md   # AI assistant conventions
├── GEMINI.md                         # Gemini CLI session context
├── AI-SESSIONS.md                    # Cross-machine AI tool history
├── TREESITTER_ISSUE_UBU_FIXED.md     # Ubuntu tree-sitter troubleshooting
├── TREESITTER_ISSUE_W11_FIXED.md     # Windows 11 tree-sitter troubleshooting
├── lua/custom/plugins/init.lua       # Personal plugins
└── lua/kickstart/plugins/            # Optional upstream plugins
```

---

## Formatting

StyLua is the sole formatter. CI enforces it on every push.

```sh
# Check formatting
stylua --check .

# Format in place
stylua .
```

Configuration: `.stylua.toml` — 160 columns, Unix line endings, 2-space indent, single quotes preferred, no call parentheses, collapse simple statements always.

---

## Troubleshooting

| Issue | Document |
|-------|----------|
| Ubuntu: GLIBC 2.39 mismatch with npm `tree-sitter-cli` | [TREESITTER_ISSUE_UBU_FIXED.md](TREESITTER_ISSUE_UBU_FIXED.md) |
| Windows 11: MinGW `cc1.exe` silent crash (XAMPP DLL shadowing) | [TREESITTER_ISSUE_W11_FIXED.md](TREESITTER_ISSUE_W11_FIXED.md) |
| General health check | `:checkhealth` inside Neovim |

---

## AI Conventions

This repository is designed to be AI-assistant-friendly:

- **`.github/copilot-instructions.md`** — codifies conventions (native LSP API, `mason-org` namespace, nvim-treesitter `main` branch) so AI tools don't suggest deprecated patterns.
- **`GEMINI.md`** — live project context for Gemini CLI sessions.
- **`AI-SESSIONS.md`** — tracks AI tool sessions across machines for continuity.

---

## License

This configuration is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries and contributors, licensed under the MIT License. See [LICENSE.md](LICENSE.md).
