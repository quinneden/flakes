{
  description = "quinneden vscode config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  # inputs.fish-flake = {
  #   url = "github:heywoodlh/flakes?dir=fish";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      # fish-flake,
      nix-vscode-extensions,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        lib = nixpkgs.lib;
        allExtensions = nix-vscode-extensions.extensions.${system};
        myVSCodium = (
          pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = [ ] ++ (import ./extensions/general.nix { inherit inputs pkgs; });
          }
        );
        #
        #         myFish = fish-flake.packages.${system}.fish;
        #         fishProfile = {
        #           "fish" = {
        #             "path" = "${myFish}/bin/fish";
        #           };
        #         };
        vscode-keybindings = pkgs.writeText "keybindings.json" (
          builtins.toJSON [
            {
              key = "ctrl+/";
              command = "editor.action.commentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "ctrl+shift+/";
              command = "editor.action.blockComment";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "ctrl+s";
              command = "workbench.action.files.saveFiles";
            }
            {
              key = "meta+s";
              command = "workbench.action.files.saveFiles";
            }
            {
              key = "meta+shift+w";
              command = "workbench.action.terminal.toggleTerminal";
              when = "terminal.active";
            }
            {
              key = "ctrl+w";
              command = "";
            }
            {
              key = "ctrl+d";
              command = "editor.action.duplicateSelection";
            }
            {
              key = "meta+shift+e";
              command = "workbench.view.explorer";
              when = "viewContainer.workbench.view.explorer.enabled";
            }
            {
              key = "meta+shift+f";
              command = "workbench.action.findInFiles";
            }
            {
              key = "alt+left";
              command = "workbench.action.focusPreviousGroup";
            }
            {
              key = "alt+right";
              command = "workbench.action.focusNextGroup";
            }
          ]
        );

        vscode-settings = pkgs.writeText "settings.json" (
          builtins.toJSON {
            "editor.fontFamily" = "CaskaydiaCove Nerd Font";
            "editor.fontWeight" = "500";
            "editor.fontSize" = 15;
            "editor.tabSize" = 2;
            "editor.fontLigatures" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnPaste" = false;
            "editor.guides.indentation" = false;
            "editor.minimap.enabled" = false;
            "editor.scrollbar.vertical" = "hidden";
            "editor.scrollbar.horizontal" = "hidden";
            "terminal.integrated.cursorStyle" = "line";
            "terminal.integrated.defaultProfile.linux" = "zsh";
            "terminal.integrated.fontFamily" = "CaskcaydiaCove Nerd Font";
            "terminal.integrated.fontSize" = 14;
            "terminal.integrated.shellIntegration.decorationsEnabled" = "never";
            "black-formatter.path" = [ (lib.getExe pkgs.black) ];
            "stylua.styluaPath" = lib.getExe pkgs.stylua;
            "Lua.misc.executablePath" = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = lib.getExe pkgs.nil;
            "nix.formatterPath" = lib.getExe pkgs.nixfmt-rfc-style;
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = {
                  "command" = [ "nixfmt" ];
                };
                "diagnostics" = {
                  "ignored" = [ "unused_binding" ];
                };
              };
            };
            "[lua]"."editor.defaultFormatter" = "JohnnyMorganz.stylua";
            "extensions.ignoreRecommendations" = true;
            "breadcrums.enabled" = false;
            "html.autoCreateQuotes" = false;
            "explorer.compactFolders" = false;
            "explorer.fileNesting.enabled" = false;
            "window.commandCenter" = false;
            "window.customMenuBarAltFocus" = false;
            "window.menuBarVisibility" = "compact";
            "window.restoreFullscreen" = true;
            "window.titleBarStyle" = "custom";
            "window.zoomLevel" = 0.3;
            "workbench.activityBar.location" = "bottom";
            "workbench.colorTheme" = "Panda Syntax";
            "workbench.editor.labelFormat" = "short";
            "workbench.iconTheme" = "symbols";
            "workbench.layoutControl.enabled" = false;
          }
        );

        userDir = pkgs.stdenv.mkDerivation {
          name = "userDir";
          builder = pkgs.bash;
          args = [
            "-c"
            "${pkgs.coreutils}/bin/mkdir -p $out; ${pkgs.coreutils}/bin/cp ${vscode-settings} $out/settings.json; ${pkgs.coreutils}/bin/cp ${vscode-keybindings} $out/keybindings.json"
          ];
        };
        codium-configured = pkgs.writeShellScriptBin "code" ''
          dataDir="$HOME/Documents/codium"
          mkdir -p "$dataDir/User"
          rm "$dataDir/User/settings.json" &>/dev/null || true
          rm "$dataDir/User/keybindings.json" &>/dev/null || true
          ln -s ${userDir}/settings.json "$dataDir/User/settings.json"
          ln -s ${userDir}/keybindings.json "$dataDir/User/keybindings.json"
          ${myVSCodium}/bin/codium --user-data-dir "$dataDir" $@
        '';
      in
      {
        packages = {
          user-dir = userDir;
          code-bin = myVSCodium;
          default = codium-configured;
        };
      }
    );
}
