{
  perSystem =
    { pkgs, ... }:
    rec {
      packages.docBuild = pkgs.callPackage ../docs/docgen.nix { };
      packages.docServe = pkgs.callPackage ../docs/server.nix { doc = packages.docBuild; };
    };
}
