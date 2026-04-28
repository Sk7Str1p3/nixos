# SkyOS
/**
  Development shell with tools needed for configuration editing
*/
pkgs: {
  /**
    tool for managing __runtime__ secrets. See [sops-nix](https://github.com/mic92/sops-nix) for more info
  */
  packages.sops = pkgs.sops;
  /**
    tool for managing __eval time__ secrets.

    In near future, it's going to be replaced by my own project which uses `sops` instead of bare `age`
  */
  packages.git-agecrypt = pkgs.git-agecrypt;

  /**
    tool for generating documentation from comments in .nix files
  */
  packages.nixdoc = pkgs.nixdoc;
  /**
    tool for generating book from md files made by `nixdoc`
  */
  packages.mdbook = pkgs.mdbook;
}
