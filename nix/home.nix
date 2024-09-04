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
  ];

  home.file = {
    #".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    #".config/wezterm".source = ~/dotfiles/wezterm;
    #".config/skhd".source = ~/dotfiles/skhd;
    #".config/starship".source = ~/dotfiles/starship;
    #".config/zellij".source = ~/dotfiles/zellij;
    #".config/nvim".source = ~/dotfiles/nvim;
    #".config/nix".source = ~/dotfiles/nix;
    #".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    #".config/tmux".source = ~/dotfiles/tmux;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}