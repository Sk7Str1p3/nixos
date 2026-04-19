# Development shells

/**
  Isolated environments for convenient software development.
  Provides shells for all languages I use:
  - ❄️  [Nix](./devShells/nix.md)
  - ~~🦀 Rust~~  (not yet)
  - ~~🐍 Python~~  (not yet)

  Also provides separate shell for configuration development (not yet).

  `devShells/{name}/default.nix` files contain package list (as attrset for documentation comments) and,
  for some shells, shell hooks. It usually looks like this:
  ```nix
  # {language name}
  /**
    Some info on shell
  * /
  pkgs:
  {
    /**
      description on foo
    * /
    packages.foo = pkgs.foo;
    /**
      description on bar
    * /
    packages.bar = pkgs.bar

    /**
      comments on shell hook
    * /
    shellHook = ''
      ...
    '';
  }
  ```

  Also, it has templates, so you can use development shell for projects which don't have their own.
*/
let
  dirs =
    let
      contents = builtins.readDir ./.;
    in
    builtins.filter (name: contents.${name} == "directory") (builtins.attrNames contents);
in
{
  perSystem =
    {
      pkgs,
      ...
    }:

    {
      devShells = builtins.listToAttrs (
        map (name: {
          inherit name;
          value =
            let
              cfg = import ./${name}/default.nix pkgs;
            in
            pkgs.mkShell {
              inherit name;
              packages = map (p: p) (builtins.attrValues cfg.packages);
              shellHook = cfg.shellHook or "";
            };
        }) dirs 
      );
    };
  flake.templates = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = {
        path = ./${name};
        description = "${name}";
      };
    }) dirs
  );
}
