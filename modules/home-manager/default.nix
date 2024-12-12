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
    cmake
    coreutils
    delta
    devenv
    exercism
    fontconfig
    gh
    gitoxide
    jq
    nerd-font-patcher
    nerd-fonts.agave
    nil
    nixfmt-rfc-style
    tintin
    tree
    zoxide
  ];

  programs.fzf.enable = true;
}
