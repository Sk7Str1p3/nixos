# Core Inputs

/**
  Essential inputs that form
  the foundation of the NixOS configuration
*/
{
  /**
    The Core of NixOS, providing packages and modules.
    Points to `nixos-unstable` branch for latest features an updates
  */
  nixpkgs = {
    url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  /**
    A modular flake framework that simplifies flake organizing
    and reduces boilerplate code.
  */
  flake-parts = {
    url = "github:hercules-ci/flake-parts";
  };

  /**
    Like flake-parts, but for flake inputs
  */
  flake-file = {
    url = "github:vic/flake-file";
  };
}
