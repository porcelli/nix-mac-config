{
  description = "A Nix-flake for Apache KIE 10";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-maven396.url = "github:nixos/nixpkgs/a9858885e197f984d92d7fe64e9fff6b2e488d40";
    nixpkgs-pnpm930.url = "github:nixos/nixpkgs/b3f3c1b13fb08f3828442ee86630362e81136bbc";
    nixpkgs-helm3152.url = "github:nixos/nixpkgs/b60793b86201040d9dee019a05089a9150d08b5b";
    nixpkgs-python3125.url = "github:nixos/nixpkgs/5ed627539ac84809c78b2dd6d26a5cebeb5ae269";
  };

  outputs = { self, nixpkgs, nixpkgs-maven396, nixpkgs-pnpm930, nixpkgs-helm3152, nixpkgs-python3125 }:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
        maven-ps = import nixpkgs-maven396 { inherit system; };
        pnpm-ps = import nixpkgs-pnpm930 { inherit system; };
        helm-ps  = import nixpkgs-helm3152 { inherit system; };
        python-ps  = import nixpkgs-python3125 { inherit system; };
      } );
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, maven-ps, pnpm-ps, helm-ps, python-ps }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [
            nodejs_20
            yarn
            temurin-bin-17
            gnumake
            gnupg
            gh
            subversion
            go_1_23
            gotools
            jetbrains.idea-ultimate
            gtk3
            docker ]) ++ (with pnpm-ps; [nodePackages.pnpm] ) ++ (with maven-ps; [ maven ]) ++ (with helm-ps; [ kubernetes-helm helm-docs ]) ++ (with python-ps; [ python312 python312Packages.pip ]);
          shellHook = ''
            python -m venv .venv
            source .venv/bin/activate
            pip install --force-reinstall -v "docker-squash==1.2.0"
            pip install docker cekit ruamel-yaml
            export GOPATH=$(go env GOPATH)
            export PATH=$GOPATH/bin:$PATH
            # tmuxinator apache-kie
          '';
        };
      });
    };
}
