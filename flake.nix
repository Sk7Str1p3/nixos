# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "A very basic flake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./flake;

  inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.url = "github:nix-community/stylix";
  };
}
