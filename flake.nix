{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    devshell.url = "github:numtide/devshell";
    nci.url = "github:yusdacra/nix-cargo-integration";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [inputs.pre-commit-hooks.flakeModule inputs.devshell.flakeModule inputs.nci.flakeModule];
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        pre-commit = {
          settings.hooks = {
            alejandra.enable = true;
            deadnix.enable = true;
          };
        };
        packages.volts = pkgs.callPackage ./pkgs/volts {};
        devShells.default = config.nci.outputs.lapce-haskell.devShell;
        nci.projects.lapce-haskell.path = ./.;
        nci.crates.lapce-haskell = {
          profiles.release.runTests = false;
          targets = {
            wasm32-unknown-unknown = {
              default = true;
            };
          };
        };
      };
    };
}
