# Flake

/**
  Entry point of NixOS configuration

  - Defines external sources and locking their commit, which gives up __purity__.
  - Declares ready-to-use configurations (e.g. development shells, packages, etc.)

  Essentially, `flake.nix` is like `Cargo.toml` in Rust or `package.json` in Node.js, but for an entire operating system.
*/
{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.default ];

  systems = inputs.nixpkgs.lib.systems.flakeExposed;

  flake-file.inputs = import ./inputs;
  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./flake";
  flake-file.description = "A very basic flake";
