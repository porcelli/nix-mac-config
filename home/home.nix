{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
  ];

  home = {
    stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
      pkgs.nixd
      pkgs.ripgrep
    ];

    sessionVariables = {
    };
  };

  programs = {
    zsh = {
      enable = true;
    };

    direnv = {
      enable = true;

      nix-direnv.enable = true;
    };

    starship = {
      enable = true;

      settings = {
        add_newline = false;
        line_break.disable = true;
        command_timeout = 100;
        format = "[$all](dimmed white)";

        character = {
          success_symbol = "[➜](dimmed green)";
          error_symbol = "[✖](dimmed red)";
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          symbol = "λ ";
          style = "bold purple bg:0xFCA17D";
          truncation_length = 9223372036854775807;
          truncation_symbol = "…";
          only_attached = false;
          always_show_remote = false;
          ignore_branches = [];
          disabled = false;
        };

        git_status = {
          ahead = "↑$count";
          behind = "↓$count";
          conflicted = "✖";
          deleted = " 🗑 ";
          disabled = false;
          # diverged = " 😵 ";
          format = "([$all_status$ahead_behind]($style) )";
          ignore_submodules = false;
          modified = "*";
          staged = "[++($count)](green)";
          stashed = "📦";
          style = "red bold bg:0xFCA17D";
          untracked = "…";
          up_to_date = "✓";
        };

        java = {
          disabled = false;
          format = "[$symbol($version )]($style)";
          style = "red dimmed bg:0x86BBD8";
          symbol = "☕ ";
          version_format = "v$raw";
          detect_extensions = [
            "java"
            "class"
            "jar"
            "gradle"
            "clj"
            "cljc"
          ];
          detect_files = [
            "pom.xml"
            "build.gradle.kts"
            "build.sbt"
            ".java-version"
            "deps.edn"
            "project.clj"
            "build.boot"
          ];
          detect_folders = [];
        };

        jobs.disabled = true;
      };
    };

  };
}