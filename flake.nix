{
  description = "Project starter";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs =
    { self, nixpkgs, flakeUtils, zig-overlay, nix2container, ... }@inputs:
    flakeUtils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              zig = zig-overlay.outputs.packages.${system}.default;
            })
          ];
          config.allowUnfree = true;
        };
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            zig
            zls
            lldb_9
            # zig-overlay.outputs.apps.${system}
          ];
        };
      });
}
