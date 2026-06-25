# User inputs

/**
  Inputs providing modules or packages for user configurations. Check next chapters to learn more.
*/
{ lib, ... }:
{
  /**
    System for managing a user environment.
    Allows declarative configuration of user specific (non-global) packages and dotfiles.
  */
  home-manager = {
    url = "github:nix-community/home-manager";
  };
  /**
    Theming framework for NixOS
  */
  stylix = {
    url = "github:nix-community/stylix";
  };
}
// lib.foldl' (acc: value: lib.recursiveUpdate acc value) { } (
  map (file: import ./${file} { inherit lib; }) (
    builtins.filter (name: name != "default.nix") (builtins.attrNames (builtins.readDir ./.))
  )
)
