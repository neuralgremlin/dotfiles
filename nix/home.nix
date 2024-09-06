{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #home.username = "jdoe";
  #home.homeDirectory = "/home/jdoe";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
  home.packages = [
      pkgs.cowsay
      pkgs.starship
      pkgs.neovim
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.yazi
      pkgs.portal
  ];

  home.file = {
    ".zshrc".source = ../zsh/.zshrc;
    ".zprofile".source = ../zsh/.zprofile;
    #".config/wezterm".source = ~/dotfiles/wezterm;
    #".config/skhd".source = ~/dotfiles/skhd;
    ".config/starship".source = ../starship;
    #".config/zellij".source = ~/dotfiles/zellij;
    #".config/nvim".source = ../nvim;
    ".config/tmux".source = ../tmux;
    ".config/pypoetry".source = ../pypoetry;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools ={
        go = "1.23";
        node = "20";
        python = "3.11";
      };
    };
  };

  programs.poetry = {
    enable = true;
  };

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 100;
      lint = {
        select = [ "E4" "E7" "E9" "F" ];
        ignore = [ ];
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

}
