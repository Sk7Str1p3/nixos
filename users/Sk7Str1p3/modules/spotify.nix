{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.spotify.homeManagerModules.spicetify
    (lib.mkAliasOptionModule [ "programs" "music" "spotify" ] [ "programs" "spicetify" ])
  ];

  config = {
    programs.music.spotify = {
      wayland = true;
      windowManagerPatch = true;
      # theme = { ... } # Theming done with stylix.
      enabledExtensions = with spicePkgs.extensions; [
        adblock
      ];
    };
  };
}
