{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =[
          pkgs.age
          pkgs.bat
          pkgs.fzf
          pkgs.git
          pkgs.portal
          pkgs.ripgrep
          pkgs.tmux
          pkgs.zoxide
          pkgs.docker
          pkgs.docker-compose
          pkgs.docker-credential-helpers
          pkgs.colima
          pkgs.starship
          pkgs.neovim
          pkgs.lazydocker
          pkgs.lazygit
          pkgs.yazi
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true; # default shell on catalina
        enableCompletion = true; # default true
        enableSyntaxHighlighting = true; # default false
      };
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      security.pam.enableSudoTouchIdAuth = true;
      
      system.defaults = {
        screencapture.location = "~/Pictures/screenshots";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MX000KMQ0JNVHGW
    darwinConfigurations = {
      "MX000KMQ0JNVHGW" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.portizmonast = import ./home.nix;
            };
            users.users.portizmonast = {
              home = "/Users/portizmonast";
              name = "portizmonast";
            };
          }
        ];
      };
      "egghead" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pedro = import ./home.nix;
            };
            users.users.pedro = {
              home = "/Users/pedro";
              name = "pedro";
            };
          }
        ];
      };
    };
    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations."MX000KMQ0JNVHGW".pkgs;
  };
}
