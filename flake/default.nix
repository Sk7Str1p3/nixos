# Flake

/**
  Entry point of NixOS configuration

  - Defines external sources and locking their commit, which gives us __purity__.
  - Declares ready-to-use configurations (e.g. development shells, packages, etc.)

  Essentially, `flake.nix` is like `Cargo.toml` in Rust or `package.json` in Node.js, but for an entire operating system.
*/
{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
    ../devShells
    ../docs
    ../hosts
  ];

  systems = [ "x86_64-linux" ];

  flake-file.inputs = import ./inputs { inherit lib; };
  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./flake";
  flake-file.description = "A very basic flake";
}
