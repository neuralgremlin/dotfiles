{
  description = "Pedro's macOS (nix-darwin) + Arch Linux (HM-only) flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager pinned to the matching stable branch (25.05)
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };

    # Shared macOS base; keep only true system-level bits here
    darwinBase = { pkgs, ... }: {
      services.nix-daemon.enable = true;

      nix = {
        settings.experimental-features = [ "nix-command" "flakes" ];
        gc = { automatic = true; options = "--delete-older-than 7d"; };
        optimise.automatic = true;
      };

      # System-level tools (user CLIs live in Home Manager to avoid duplication)
      environment.systemPackages = with pkgs; [
        colima
        docker docker-compose docker-credential-helpers
      ];

      programs.zsh.enable = true;
      security.pam.enableSudoTouchIdAuth = true;

      # Homebrew managed by nix-darwin. Hosts can extend lists with mkAfter.
      homebrew = {
        enable = true;
        taps  = [ "homebrew/cask" ];
        brews = [ "mas" ];
        casks = [
          "visual-studio-code"
          "obsidian"
          "ghostty"
        ];
        onActivation = { autoUpdate = true; cleanup = "zap"; };
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      nixpkgs.hostPlatform = "aarch64-darwin";
      system.stateVersion = 4;
    };
  in
  {
    # ---------------------- macOS: egghead ----------------------
    darwinConfigurations.egghead = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        darwinBase
        ./hosts/egghead.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pedro = import ./home/pedro.nix;
        }
      ];
    };

    # --------------- macOS: MX000KMQ0JNVHGW (work) ---------------
    darwinConfigurations.MX000KMQ0JNVHGW = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        darwinBase
        ./hosts/MX000KMQ0JNVHGW.nix

        # Host-specific adds (merge with base; don't overwrite)
        ({ lib, pkgs, ... }: {
          environment.systemPackages = lib.mkAfter [ pkgs.awscli2 ];
          homebrew.brews = lib.mkAfter [ "codex" ];  # Codex CLI via Homebrew formula
        })

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.portizmonast = import ./home/pedro.nix;
        }
      ];
    };

    # ------------------- Arch Linux (HM-only) -------------------
    homeConfigurations."pedro@arch" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor "x86_64-linux"; # switch to aarch64 if needed
      modules = [
        { home.username = "pedro"; home.homeDirectory = "/home/pedro"; }
        ./home/pedro.nix
        ./hosts/linux-arch.nix
      ];
    };
  };
}
