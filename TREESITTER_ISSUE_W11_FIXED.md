# Issues Found & Fixed — kickstart.nvim on Windows 11

## ✅ Fix 1: Deprecated API in `init.lua` (line 189)

`jump = { float = true }` was deprecated in Neovim 0.12. Changed to:

```lua
jump = { on_jump = function() vim.diagnostic.open_float() end }
```

## ✅ Fix 2: Broken MinGW gcc (root cause of all tree-sitter failures)

**Root cause**: XAMPP had `api-ms-win-crt-*.dll` DLLs earlier in `PATH` than MinGW.
These were old versions from XAMPP MySQL, which were missing entry points that gcc
15.2.0's `cc1.exe` requires, causing **STATUS_ENTRYPOINT_NOT_FOUND** (silent crash
with empty stderr).

**Fix**: Copied the correct UCRT DLLs from `C:\Windows\System32\downlevel\` to
`cc1.exe`'s own directory (`libexec\gcc\x86_64-w64-mingw32\15.2.0\`). DLLs in the
executable's directory take priority over PATH.

All 11 nvim-treesitter parsers now compile and install successfully:
`bash`, `c`, `diff`, `html`, `lua`, `luadoc`, `markdown`, `markdown_inline`,
`query`, `vim`, `vimdoc`.

## ✅ Fix 3: Missing ripgrep

Installed `ripgrep` via Chocolatey — needed for Telescope's live grep.

```
choco install ripgrep -y
```

---

## Remaining Warnings (non-breaking, optional)

| Warning | Notes |
|---|---|
| `unzip`, `wget`, `gzip`, `7z` | Optional Mason tools — not required for basic use |
| `luarocks` | No plugins currently require it — safe to ignore |
| Node.js `neovim` package | Run `npm install -g neovim` to enable Node provider |
| Python 3.9+ | Current Python 3.8 (32-bit) is too old; upgrade to enable Python provider |
| Perl, Ruby | Optional providers — install only if needed |
