{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./terminals/kitty.nix
  ];

  home.packages = with pkgs; [
    (aspellWithDicts (d: [ d.en ]))
    (nerdfonts.override { fonts = [ "Agave" ]; })
    cmake
    coreutils
    delta
    devenv
    exercism
    freecad-wayland
    gh
    gitoxide
    jq
    nerd-font-patcher
    nil
    nixfmt-rfc-style
    tree
    zoxide
  ];

  programs.fzf.enable = true;
}
