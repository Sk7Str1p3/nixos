# User inputs :: Sk7Str1p3

/**
  Inputs used by user `Sk7Str1p3`
*/
{ ... }:
{
  /**
    Flake for configuring Niri.
    Used because home-manager does not support Niri yet.
  */
  niri = {
    url = "github:sodiboo/niri-flake";
  };
  /**
    Spotify wrapper (spicetify) with better customization
  */
  spotify = {
    url = "github:Gerg-L/spicetify-nix";
  };
}
