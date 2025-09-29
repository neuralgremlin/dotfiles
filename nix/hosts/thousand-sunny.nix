{ pkgs, ... }:
{
  system.defaults = {
    screencapture.location = "/Users/portizmonast/Pictures/screenshots";
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  users.users.portizmonast = {
    home = "/Users/portizmonast";
    shell = pkgs.zsh;
  };
}
