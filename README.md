# dotfiles

Dotfiles and Nix configurations for multiple machines.

## Overview

- The Nix flake for this repo lives under `[PATH_TO_FLAKE]`.
- Determinate Nix manages the Nix installation and daemon on macOS.
- `nix-darwin` manages macOS system configuration.
- Home Manager is embedded in the Darwin configuration, so user packages update when the host is rebuilt.

## Hosts

- `going-merry` - macOS (`aarch64-darwin`)
- `thousand-sunny` - macOS (`aarch64-darwin`)
- `polar-tang` - Linux (Home Manager only)

## Rebuild macOS Systems

Use one of these forms for a macOS host rebuild.

From anywhere:

```sh
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake [PATH_TO_FLAKE]#going-merry
```

From the flake directory:

```sh
cd [PATH_TO_FLAKE]
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake .#going-merry
```

Generic host form:

```sh
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake [PATH_TO_FLAKE]#[HOSTNAME]
```

`darwin-rebuild` must be run as root on this setup.

## Upgrade Determinate Nix

Upgrade the installed Determinate Nix runtime and daemon with:

```sh
sudo determinate-nixd upgrade
```

This upgrades Nix itself. It does not update the versions pinned in `flake.lock`.

## Update Flake Inputs And Packages

Update all pinned inputs:

```sh
nix flake update --flake [PATH_TO_FLAKE]
```

Update only the main Nix inputs:

```sh
nix flake lock \
  --update-input nixpkgs \
  --update-input nix-darwin \
  --update-input home-manager \
  --flake [PATH_TO_FLAKE]
```

Apply the updated lockfile to `going-merry`:

```sh
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake [PATH_TO_FLAKE]#going-merry
```

On macOS 26, the Homebrew bundle phase may take a long time while fetching casks. Slow output such as `Fetching bitwarden, git-credential-manager` does not necessarily mean the rebuild is stuck.

## Per-Host Notes

### `going-merry`

Purpose:
Primary macOS host example.

Apply command:

```sh
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake [PATH_TO_FLAKE]#going-merry
```

Notes:
- Uses the shared Darwin base configuration from this flake.
- Home Manager changes apply as part of the same rebuild.
- Homebrew activation may be slow during cask fetches.

### `thousand-sunny`

Purpose:
Secondary macOS host with host-specific package additions.

Apply command:

```sh
sudo -H --preserve-env=USER,SUDO_USER darwin-rebuild switch --impure --flake [PATH_TO_FLAKE]#thousand-sunny
```

Notes:
- Add host-specific notes here.
- Document any extra apps, brews, or operational differences here.

### `polar-tang`

Purpose:
Linux host managed with Home Manager only.

Apply command:

```sh
home-manager switch --flake [PATH_TO_FLAKE]#polar-tang
```

Notes:
- Template section for Linux usage.
- Confirm bootstrap and install steps separately if this host is being set up from scratch.
