# Issues Found & Fixed — kickstart.nvim on Ubuntu 22.04

## ✅ Fix: Broken `tree-sitter-cli` npm binary (GLIBC incompatibility)

**Environment**: Ubuntu 22.04 LTS (Jammy), GLIBC 2.35, Neovim 0.12+, nvim-treesitter `main` branch.

**Symptom**: All nvim-treesitter parser compilations failed on startup with:

```
[nvim-treesitter/install/<lang>] error: Error during "tree-sitter build":
/home/revota/.nvm/versions/node/v22.19.0/lib/node_modules/tree-sitter-cli/tree-sitter:
/lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.39' not found
(required by /home/revota/.nvm/versions/node/v22.19.0/lib/node_modules/tree-sitter-cli/tree-sitter)
```

**Root cause**: `tree-sitter-cli` v0.26.8 was installed via `npm install -g tree-sitter-cli`.
The npm-distributed binary is compiled against GLIBC 2.39, which is not available on Ubuntu 22.04
(ships with GLIBC 2.35). Additionally, nvim-treesitter `main` branch requires `tree-sitter-cli`
≥ 0.26.1 and explicitly states it should be installed **via your package manager, not npm**.

**Specific GLIBC 2.39 symbols required** (both weak/optional, but still cause a load failure):
- `pidfd_getpid`
- `pidfd_spawnp`

**Fix**:

1. Install the Rust toolchain (installs to `~/.cargo`, no system packages affected):
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   source "$HOME/.cargo/env"
   ```

2. Install `libclang-dev` (required by the `bindgen` dependency during compilation):
   ```sh
   sudo apt-get install -y libclang-dev
   ```

3. Build and install `tree-sitter-cli` from source via cargo:
   ```sh
   cargo install tree-sitter-cli
   ```

4. Remove the broken npm version:
   ```sh
   npm uninstall -g tree-sitter-cli
   ```

The Rust toolchain's `~/.cargo/env` is sourced automatically via `~/.bashrc` and `~/.profile`.

**Result**: All 11 nvim-treesitter parsers compiled and installed successfully:
`bash`, `c`, `diff`, `html`, `lua`, `luadoc`, `markdown`, `markdown_inline`,
`query`, `vim`, `vimdoc`.

Neovim now starts with zero errors.
