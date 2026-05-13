# Nix
/**
  Basic shell for nix-only projects.
  Many nix projects have their own devshell,
  but they don't install most necessary tools.
*/
pkgs: {
  /**
    nix language server
  */
  packages.nixd = pkgs.nixd;
  /**
    another one nix language server
  */
  packages.nil = pkgs.nil;
  /**
    nix formatter
  */
  packages.nixfmt = pkgs.nixfmt;
  /**
    nix linter
  */
  packages.statix = pkgs.statix;
}
