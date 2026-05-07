# Issues Found & Fixed — kickstart.nvim on Windows 11

## Prerequisites

The following tools must be installed via Chocolatey before applying any fixes:

```powershell
choco install mingw make tree-sitter ripgrep -y
```

| Tool | Purpose |
|---|---|
| `mingw` | Provides `gcc`/`g++` — required to compile tree-sitter parsers |
| `make` | Required by nvim-treesitter's build system |
| `tree-sitter` | CLI used by nvim-treesitter (main branch) to build parsers |
| `ripgrep` | Required for Telescope's live grep |

---

## Applying Fixes — Requires a New CMD Session

After applying any of the fixes below, **do not** just close and reopen Neovim within
the same terminal tab/window. Windows CMD (and PowerShell) inherit the environment — including
the DLL search order — from when the session was first opened. Any changes to PATH or
files on disk that affect DLL resolution won't be picked up until a brand-new terminal
session is started.

**To apply the fixes**: close the current CMD/PowerShell tab/window and open a fresh
one, then launch Neovim from there.

> 💡 In some environments (e.g., terminals not managed by CMD, or where PATH changes
> aren't involved), simply restarting Neovim may be enough. But if parsers still fail to
> compile after a fix, always try a new terminal session first.

---

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

**Fix**: Copied **all** UCRT DLLs from `C:\Windows\System32\downlevel\` to
`cc1.exe`'s own directory (`libexec\gcc\x86_64-w64-mingw32\15.2.0\`). DLLs in the
executable's directory take priority over PATH.

```powershell
Copy-Item "C:\Windows\System32\downlevel\api-ms-win-crt-*.dll" `
    "C:\ProgramData\mingw64\mingw64\libexec\gcc\x86_64-w64-mingw32\15.2.0\"
```

> ⚠️ Copying only `ucrtbase.dll` is **not enough** — all 15 `api-ms-win-crt-*.dll`
> files must also be copied, or XAMPP's old versions will still shadow them via PATH.

All 11 nvim-treesitter parsers now compile and install successfully:
`bash`, `c`, `diff`, `html`, `lua`, `luadoc`, `markdown`, `markdown_inline`,
`query`, `vim`, `vimdoc`.

---

## Remaining Warnings (non-breaking, optional)

| Warning | Notes |
|---|---|
| `unzip`, `wget`, `gzip`, `7z` | Optional Mason tools — not required for basic use |
| `luarocks` | No plugins currently require it — safe to ignore |
| Node.js `neovim` package | Run `npm install -g neovim` to enable Node provider |
| Python 3.9+ | Current Python 3.8 (32-bit) is too old; upgrade to enable Python provider |
| Perl, Ruby | Optional providers — install only if needed |
