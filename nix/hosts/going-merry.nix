{ pkgs, user, config, ... }:
{
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  system.defaults = {
    screencapture.location = "${config.users.users.${user}.home}/Pictures/screenshots";
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };
}
