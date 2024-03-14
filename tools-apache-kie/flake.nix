{
  description = "A Nix-flake for KIE Tools";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-maven386.url = "github:nixos/nixpkgs/4d887ae7666a6ffb79e1767d8fd417daf9e4220f";
    nixpkgs-pnpm876.url = "github:nixos/nixpkgs/517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";
    nixpkgs-helm3133.url = "github:nixos/nixpkgs/160b762eda6d139ac10ae081f8f78d640dd523eb";
  };

  outputs = { self, nixpkgs, nixpkgs-maven386, nixpkgs-pnpm876, nixpkgs-helm3133 }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        maven-ps = import nixpkgs-maven386 { inherit system; };
        pnpm-ps = import nixpkgs-pnpm876 { inherit system; };
        helm-ps  = import nixpkgs-helm3133 { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, maven-ps, pnpm-ps, helm-ps }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [ 
            nodejs_18 
            temurin-bin-11
            gnumake
            go
            gtk3
            docker ]) ++ (with maven-ps; [ maven ]) ++ (with pnpm-ps; [ nodePackages.pnpm ]) ++ (with helm-ps; [ kubernetes-helm ]);
        };
        shellHook = ''
          tmuxinator tools-apache-kie
        '';
      });
    };
}