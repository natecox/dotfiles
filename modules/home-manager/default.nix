{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    (aspellWithDicts (d: [ d.en ]))
    (nerdfonts.override { fonts = [ "Agave" ]; })
    cmake
    coreutils
    delta
    devenv
    exercism
    gh
    gitoxide
    jq
    nerd-font-patcher
    nil
    nixfmt-rfc-style
    tree
    zoxide
  ];
}
