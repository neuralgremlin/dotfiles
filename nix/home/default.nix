{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux  = pkgs.stdenv.isLinux;
in
{
  home.stateVersion = "24.05"; # fine to keep; bump later only if you want HM’s new defaults

  home.sessionVariables = {
    EDITOR = "code";
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship/starship.toml";
    # UV_PYTHON_PREFERENCE = "managed";
    # UV_VENV_IN_PROJECT = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ] ++ lib.optionals isDarwin [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];

  # User-scoped CLIs (shared across macOS & Arch)
  home.packages = with pkgs; [
    uv
    git jq fd
    bat ripgrep fzf
    nodejs_24           # npm included
    rustup              # cargo via rustup under ~/.cargo
    ghostty
  ] ++ lib.optionals isLinux [
    wl-clipboard
  ];

  xdg.configFile."starship".source =  ../../starship;

  # Global Ruff defaults (used when a project has no local config)
  xdg.configFile."ruff/ruff.toml".text = ''
    line-length = 100

    [lint]
    select = ["E4", "E7", "E9", "F"]
    ignore = []
  '';

  programs.home-manager.enable = true;
  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    loginExtra = "";
    
    #OPTIONAL: Make `brew` available in shells on macOS if not handled via nix-darwin
    #loginExtra = lib.optionalString isDarwin ''
    #  if [ -x /opt/homebrew/bin/brew ]; then
    #    eval "$(/opt/homebrew/bin/brew shellenv)"
    #  fi
    #'';

    initContent = ''
      eval "$(starship init zsh)"

      alias cat="bat"
      alias la="ls -la"
      alias ..="cd .."; alias ...="cd ../.."; alias ....="cd ../../.."
      alias .....="cd ../../../.."; alias ......="cd ../../../../.."
      alias cl="clear"

      # uv-first tools
      alias py="uv run python"
      alias pip="uv pip"
      alias ruff="uvx ruff"
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.lazygit.enable = true;
  programs.yazi.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    extraConfig = builtins.readFile ../../tmux/tmux.conf;
  };
}
