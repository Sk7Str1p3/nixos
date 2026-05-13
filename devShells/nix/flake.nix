{
  description = "Development shell for nix projects";

  inputs.nixpkgs = "github:nixos/nixpkgs";
  inputs.utils = "github:numtide/flake-utils";

  outputs =
    {
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      sys:
      let
        pkgs = nixpkgs.legacyPackages.${sys};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "nix";
          packages = map (p: p) (builtins.attrValues (import ./. pkgs).packages);
        };
      }
    );
}
