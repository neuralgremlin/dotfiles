{
  description = "My macOS (nix-darwin) + Arch Linux (HM-only) flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager pinned to the matching stable branch (25.05)
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # Get the calling user from environment (impure)
    currentUser =
      let su = builtins.getEnv "SUDO_USER";
          u  = builtins.getEnv "USER";
      in if su != "" then su else u;

    pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };

    # Shared macOS base; keep only true system-level bits here
    darwinBase = { pkgs, user, ... }: {

      #Since we are using Determinate Nix, niz darwin should not manage it
      nix.enable = false;

      #nix.settings.experimental-features = [ "nix-command" "flakes" ];
      #nix.gc = { automatic = true; options = "--delete-older-than 7d"; };
      #nix.optimise.automatic = true;

      system.primaryUser = user;

      # System-level tools (user CLIs live in Home Manager to avoid duplication)
      environment.systemPackages = with pkgs; [
        #colima
        docker docker-compose docker-credential-helpers
      ];

      programs.zsh.enable = true;

      security.pam.services.sudo_local.touchIdAuth = true;

      # Homebrew managed by nix-darwin. Hosts can extend lists with mkAfter.
      homebrew = {
        enable = true;
        brews = [
          "mas"
          "gh"
          "postgresql"
          "uv"
          "marp-cli"
        ];
        casks = [
          "bitwarden"
          "brave-browser"
          "bruno"
          "codex"
          "codex-app"
          "dbeaver-community"
          "ghostty"
          "git-credential-manager"
          "obsidian"
          "zed"

        ];
        onActivation = { autoUpdate = true; upgrade = true; cleanup = "none"; };
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      nixpkgs.hostPlatform = "aarch64-darwin";
      system.stateVersion = 4;
    };
    # ---------------------- helpers ----------------------
    mkDarwin = { name, extraModules ? [ ] }:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { user = currentUser; };
        modules = [
          darwinBase
          ./hosts/${name}.nix
          # Home Manager
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { user = currentUser; };
            home-manager.users.${currentUser} = import ./home/default.nix;
          }
        ] ++ extraModules;
      };

    mkLinux = { name, system }:
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = pkgsFor system;
        extraSpecialArgs = { user = currentUser; };
        modules = [
          { home.username = currentUser; home.homeDirectory = "/home/${currentUser}"; }
          ./home/default.nix
          ./hosts/${name}.nix
        ];
      };
  in
  {
    ###########################
    # macOS hosts (Darwin)
    ###########################

    darwinConfigurations.going-merry =
      mkDarwin {
        name = "going-merry";
        extraModules = [
          # Host-specific packages (merges with default)
          ({ lib, pkgs, ... }: {
            homebrew.brews = lib.mkAfter [ "imagemagick"];
            #homebrew.casks = lib.mkAfter [ "codex-app" ]; #Blocked By ZScaler for now
          })
        ];
      };

    darwinConfigurations.thousand-sunny =
      mkDarwin {
        name = "thousand-sunny";
        extraModules = [
          # Host-specific packages (merges with default)
          ({ lib, pkgs, ... }: {
            environment.systemPackages = lib.mkAfter [ pkgs.awscli2 ];
            homebrew.brews = lib.mkAfter [
              "libomp"
              #"cdktf"
            ];
            homebrew.casks = lib.mkAfter [ "notion" ]; #Notion
          })
        ];
      };
    ###########################
    # linux hosts
    ###########################

    homeConfigurations."polar-tang" =
      mkLinux {
        name = "polar-tang";
        system = "x86_64-linux";
      };
  };
}
