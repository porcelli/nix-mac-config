{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
  ];

  home = {
    stateVersion = "24.11";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
      pkgs.nixd
      pkgs.ripgrep
      pkgs.curl
      pkgs.wget
      pkgs.jq
      pkgs.coreutils
      pkgs.tree
      pkgs.docker
      # pkgs.rancher
      pkgs.tmuxPlugins.cpu
      # pkgs.openshift
    ];

    sessionVariables = {
    };
  };

  programs = {
    tmux = {
      enable = true;
      tmuxinator.enable = true;
      extraConfig = ''
        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix
        set -g mouse on
        set -g history-limit 100000
        set -g set-clipboard on
        set -g escape-time 10
        set -g renumber-windows on
        set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
        set-window-option -g xterm-keys on
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      '';
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
            "git"
            "docker"
            "iterm2"
        ];
      };
      # initExtra = ''
      #   if [[ -n "$IN_NIX_SHELL" ]]; then
      #     export PS1="$PS1%F{red}:nix-shell>%f "
      #   fi
      #   export PATH=$PATH:$HOME/.rd/bin
      #   export TESTCONTAINERS_HOST_OVERRIDE=$(rdctl shell ip a show rd0 | awk '/inet / {sub("/.*",""); print $2}')
      # '';
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.6.0";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
          file = "zsh-syntax-highlighting.zsh";
        }
      ];
    };

    direnv = {
      enable = false;
      nix-direnv.enable = false;
    };

    starship.enable = false;

  };
}
