{ pkgs, ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    useTheme = "catppuccin_mocha";
  };
}
