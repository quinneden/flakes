{
  inputs,
  pkgs,
}:
let
  normal = with pkgs.vscode-extensions; [
    bbenoist.nix
    sumneko.lua
    xaver.clang-format
    ziglang.vscode-zig
  ];

  marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
  open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;

  community =
    (with marketplace; [
      ms-python.python
      ms-python.black-formatter
      johnnymorganz.stylua
      rvest.vs-code-prettier-eslint
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      miguelsolorio.symbols
      # github.copilot
    ])
    ++ (with open-vsx; [
      pr1sm8.theme-panda
    ]);
in
[ ] ++ normal ++ community
