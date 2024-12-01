# check out the script [.scripts/code-update-installed-exts.sh](https://github.com/alphatechnolog/crazy/tree/main/.scripts/code-update-installed-exts.sh)
# in order to generate more extensions here when adding more manually.
{ pkgs }:
pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "rust-bundle";
    publisher = "1yib";
    version = "1.0.0";
    sha256 = "19d53vkmn08rvysg934xdhhxbiwd52ha1dwjfwhnaan1s9gwfsqv";
  }
  {
    name = "rust-syntax";
    publisher = "dustypomerleau";
    version = "0.6.1";
    sha256 = "0rccp8njr13jzsbr2jl9hqn74w7ji7b2spfd4ml6r2i43hz9gn53";
  }
  {
    name = "vscode-clangd";
    publisher = "llvm-vs-code-extensions";
    version = "0.1.28";
    sha256 = "1kys452zd99519jwvw5yqil0lm8wjvfaczsb555l0lk9lligbn35";
  }
  {
    name = "color-highlight";
    publisher = "naumovs";
    version = "2.8.0";
    sha256 = "14capk3b7rs105ij4pjz42zsysdfnkwfjk9lj2cawnqxa7b8ygcr";
  }
]
