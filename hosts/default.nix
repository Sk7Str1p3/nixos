# Hosts

/**
  Entry point for machines' configurations.

  Each host forder must has the following structure:
  ```
  └── {hostname}
      ├── about.nix
      ├── configuration.nix
      └── hardware.nix
  ```

  `configuration.nix` can be used to override default values, and `hardware.nix` is used to store hardware-related stuff.

  # About file
  File which keep some info about host. It can have these fiels (may be extended in future):
  ### `name`
    used as `networking.hostName` value
  ### `users`
    sets machine users. Users must have their configuration defined at `users/`
*/
{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.nixpkgs.lib.mkMerge (
    map
      (
        host:
        let
          cfg = import ./${host}/about.nix;
        in
        {
          ${host} = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit cfg inputs;
            };
            modules = with inputs; [
              ./${host}/configuration.nix
              sops-nix.nixosModules.sops
              ./${host}/hardware.nix
              ../users
            ];
          };
        }
      )
      (
        let
          hosts = builtins.readDir ./.;
        in
        builtins.filter (name: hosts.${name} == "directory") (builtins.attrNames hosts)
      )
  );
}
