{ pkgs, ... }:
{
  system.defaults = {
    screencapture.location = "/Users/pedro/Pictures/screenshots";
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  users.users.pedro = {
    home = "/Users/pedro";
    shell = pkgs.zsh;
  };
}
