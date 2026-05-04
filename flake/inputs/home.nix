# Home inputs

/**
  Inputs providing modules or packages for user configuration.
*/
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
