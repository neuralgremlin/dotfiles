# dotfiles
dotfiles for my machines


Replace HOSTNAME with the name of the nix host you are trying to config
```shell
sudo -H --preserve-env=USER,SUDO_USER \
nix run nix-darwin/nix-darwin-25.05#darwin-rebuild \
-- switch --impure --flake .#[HOSTNAME]
```
