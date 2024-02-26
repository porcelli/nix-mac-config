{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.home-manager
    ];

  # # Use a custom configuration.nix location.
  # # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/src/github.com/evantravers/dotfiles";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on catalina
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.monaspace
  ];

  security.pam.enableSudoTouchIdAuth = true;

  nix.extraOptions = ''
    extra-platforms = aarch64-linux x86_64-darwin aarch64-darwin
  '';

  nix.settings.trusted-users = [ "@admin" ];

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
  };
}