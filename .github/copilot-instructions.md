# Copilot Instructions — nvim (kickstart.nvim)

This is a personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
running on **Windows 11** with **Neovim 0.12+**.

## Formatting / Linting

StyLua is the only code formatter and CI check.

```sh
# Check formatting (what CI runs)
stylua --check .

# Format in place
stylua .
```

StyLua config (`.stylua.toml`): 160-column width, Unix line endings, 2-space indent,
single quotes preferred, no call parentheses, collapse simple statements always.

## Repository Structure

| Path | Purpose |
|---|---|
| `init.lua` | Main config — the only file Neovim loads directly |
| `init.lua.example` | Unmodified upstream kickstart reference (zero point) |
| `lua/kickstart/plugins/` | Optional bundled plugins (disabled by default) |
| `lua/custom/plugins/` | User-owned plugin additions (safe from merge conflicts) |
| `lua/kickstart/health.lua` | Custom `:checkhealth kickstart` module |
| `lazy-lock.json` | Plugin lockfile — should be committed |
| `TREESITTER_ISSUE_W11_FIXED.md` | Documents the Windows 11 gcc/UCRT fix applied to this machine |

## Architecture

`init.lua` is intentionally a **single file**. All core configuration lives there in order:
leader key → options → keymaps → autocommands → lazy.nvim bootstrap → plugin specs.

**Optional plugins** in `lua/kickstart/plugins/` are enabled by uncommenting their
`require` lines near the bottom of `init.lua`:
```lua
-- require 'kickstart.plugins.debug',
-- require 'kickstart.plugins.neo-tree',
-- etc.
```

**User plugins** go in `lua/custom/plugins/` as individual `.lua` files, each returning
a lazy.nvim plugin spec. They are loaded via:
```lua
-- { import = 'custom.plugins' },   -- uncomment to activate
```

## Key Conventions

### Plugin configuration style
Prefer `opts = {}` over `config = function() require('x').setup({}) end` — lazy.nvim
calls `setup` automatically with `opts`:
```lua
{ 'plugin/name', opts = { key = value } }
```

Use `config = function() ... end` only when setup logic goes beyond a plain options table.

### Type annotations on plugin opts
Always pair `opts` with `---@module` + `---@type` annotations so lua-language-server
provides accurate completions:
```lua
---@module 'blink.cmp'
---@type blink.cmp.Config
opts = { ... }
```

### LSP setup (Neovim 0.11+ native API)
This config uses the **native** Neovim LSP API introduced in 0.11, **not**
`require('lspconfig').*.setup()`:
```lua
vim.lsp.config('server_name', { ... })
vim.lsp.enable('server_name')
```
Do not suggest the old lspconfig pattern here.

### nvim-treesitter — main branch (new API)
This config pins `branch = 'main'` of nvim-treesitter, which is a complete rewrite.
The old master-branch API (`require('nvim-treesitter.configs').setup()`,
`compilers`, `ensure_installed`) does **not exist** on this branch.

Parser installation is done via:
```lua
require('nvim-treesitter').install({ 'lua', 'bash', ... })
```
Parser compilation uses the `tree-sitter` CLI (`tree-sitter build`) — not gcc directly.

### Mason organisation namespace
Mason and its companions moved to the `mason-org` GitHub org. Use:
- `mason-org/mason.nvim`
- `mason-org/mason-lspconfig.nvim`

Not `williamboman/`.

### `vim.g.have_nerd_font` gate
All icon-related configuration is gated on `vim.g.have_nerd_font` (set at the top of
`init.lua`). When adding icons, always respect this flag.

### Windows-specific compiler setup
At startup, `init.lua` auto-sets `CC=gcc` and `CXX=g++` on Windows when `gcc.exe` is
found. If gcc compilation fails silently on a system with XAMPP installed, see
`TREESITTER_ISSUE_W11_FIXED.md` — XAMPP's old `api-ms-win-crt-*.dll` DLLs can shadow
MinGW's `cc1.exe` through PATH ordering.

## Health Check

Run inside Neovim to validate the full setup:
```
:checkhealth
:checkhealth kickstart    " kickstart-specific checks only
```
