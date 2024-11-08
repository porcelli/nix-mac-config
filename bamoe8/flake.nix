{
  description = "A Nix-flake-based Java development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-maven386.url = "github:nixos/nixpkgs/4d887ae7666a6ffb79e1767d8fd417daf9e4220f";
  };

  outputs = { self, nixpkgs, nixpkgs-maven386 }:
    let
      javaVersion = 11; # Change this value to update the whole stack
      overlays = [
        (final: prev: rec {
          jdk = prev."temurin-bin-${toString javaVersion}";
          maven = prev.maven.override { inherit jdk; };
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { 
          inherit overlays system; 
          config = { allowUnfree = true; };
        };
        maven-ps = import nixpkgs-maven386 { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, maven-ps }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ jdk git jetbrains.idea-ultimate docker ] ++ (with maven-ps; [ maven ]) ;
          # shellHook = ''
          #   tmuxinator bamoe8
          # '';
        };
      });
    };
}
