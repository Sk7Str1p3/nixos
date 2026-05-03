# Users
/**
  This module contains users' configuration which is declared on system level.
  It includes user's password, shell, etc.
  Parameters is imported from `about.json` in user's folder. File can have these keys (may be expanded in future):

  - `realName`: User's real name  (optionally)
  - `extraGroups`: groups (optionally)
  - `shell`: User's shell

  User's face (optionally)
    - if any, should be located at users/{user}/face.png
    - i prefer store this encrypted, but you can keep it in clear text

  User's password must be stored at users/{user}/password.yaml and encrypted with sops. Format of unencrypted file:
    ```yaml
    # {your password}
    {username}:
      userPassword: {hash}
    ```
    where `{hash}` is result of `echo {your password} | mkpasswd -s`
*/
{
  lib,
  pkgs,
  cfg,
  config,
  ...
}:
{
  # Configure users' passwords as sops secret.
  sops.secrets = lib.mkMerge (
    map (user: {
      "${user}/userPassword" = {
        sopsFile = ./${user}/password.yaml;
        neededForUsers = true;
      };
    }) cfg.usersList
  );

  # Configure users
  users.users = lib.mkMerge (
    map (user: {
      ${user} =
        let
          cfg = builtins.fromJSON (builtins.readFile ./${user}/about.json);
        in
        {
          description = cfg.realName or user;
          hashedPasswordFile = config.sops.secrets."${user}/userPassword".path;
          isNormalUser = true;
          shell = pkgs."${cfg.shell}";
          extraGroups = cfg.extraGroups or [ ];
        };
    }) cfg.usersList
  );

  # Configurure home-manager
  home-manager = {
    backupFileExtension = "backup-${builtins.currentTime}";

    users = lib.mkMerge (
      map (user: {
        ${user} = {
          imports = [
            ./${user}/modules
          ];
        }
      }) cfg.usersList
    )
  };
}
