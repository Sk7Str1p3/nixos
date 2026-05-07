# Users
/**
  This module contains users' configuration which is declared on system level.
  It includes user's password, shell, etc.
  Parameters is imported from `about.json` in user's folder. File can have these keys (may be expanded in future):

  - `realName`: User's real name  (optionally)
  - `extraGroups`: groups (optionally)
  - `shell`: User's shell
  - `session`: User's default graphical session (optionally)

  Session must have format of "{type}:{session}" where type is one of `co` (short for "compositor") and `de` (short for "desktop environment").
  This `type` is actually important, because it depends where nix will search corresponding option for enabling your session.
  If `co`, it will search it in `programs.*`, and if `de`, in `services.desktopManager.*`

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

    Wallpapers can be `png` or `jpg` format, and must be stored at `users/{user}/wallpaper.{ext}`
*/
{
  lib,
  pkgs,
  cfg,
  config,
  inputs, 
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

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
    backupFileExtension = "backup-${builtins.toString inputs.self.lastModified}";

    users = lib.mkMerge (
      map (user: {
        ${user} = {
          imports = [
            ./${user}/modules

            inputs.stylix.homeModules.stylix
          ];
          stylix = {
            enable = true;
            image =
              if builtins.pathExists ./${user}/wallpaper.png then
                ./${user}/wallpaper.png
              else
                ./${user}/wallpaper.jpg;
          };
          home.stateVersion = config.system.stateVersion;
        };
      }) cfg.usersList
    );
  };

  # Configure DM and users' default sessions
  services.displayManager.gdm.enable = true;
  systemd.tmpfiles.settings."20-gdm-default-session" = lib.mkMerge (
    map (user: {
      "/run/tmpfiles/var/lib/AccountsService/users/${user}".f = {
        argument = "${lib.generators.toINI { } {
          User = {
            Session = builtins.toString (
              builtins.tail (
                lib.splitString ":" (builtins.fromJSON (builtins.readFile ./${user}/about.json)).session
              )
            );
            SystemAccount = false;
          }
          // (
            let
              pic = ./${user}/face.png;
            in
            if builtins.pathExists pic then { Icon = "${pic}"; } else { }
          );
        }}";
      };
      "/var/lib/AccountsService/users/${user}"."L+" = {
        argument = "/run/tmpfiles/var/lib/AccountsService/users/${user}";
      };
    }) cfg.usersList
  );
}
// (lib.foldl (acc: elem: acc // elem) { } (
  map (
    user:
    let
      __session = lib.splitString ":" (builtins.fromJSON (builtins.readFile ./${user}/about.json))
      .session;
      sessionType = (builtins.head __session);
      session = builtins.toString (builtins.tail __session);
    in
    assert sessionType == "co" || sessionType == "de";
    if sessionType == "co" then
      {
        programs.${session}.enable = true;
      }
    else if sessionType == "de" then
      { services.desktopManager.${session}.enable = true; }
    else
      { }
  ) cfg.usersList
))
