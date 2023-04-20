{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-buffer
      nvim-snippy
      cmp-snippy
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-treesitter.withAllGrammars
      catppuccin-nvim
      plenary-nvim
      neorg
      lspkind-nvim
    ];

    extraLuaConfig = lib.fileContents ./neovim.lua;
  };
}
