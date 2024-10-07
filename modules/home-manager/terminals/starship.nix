{ pkgs, ... }:
let
  flavor = "mocha";
in
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings =
      {
        command_timeout = 1000;
        format = "$all";
        palette = "catppuccin_${flavor}";
        directory = {
          style = "bold lavender";
        };
      }
      // builtins.fromTOML (
        builtins.readFile (
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "starship";
            rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
            sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
          }
          + /palettes/${flavor}.toml
        )
      );
  };
}
