{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
  };
}
