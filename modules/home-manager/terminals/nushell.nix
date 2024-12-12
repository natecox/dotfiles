{ ... }:
{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = { show_banner: false }
      source ~/.config/nushell/.zoxide.nu
    '';
  };
}
