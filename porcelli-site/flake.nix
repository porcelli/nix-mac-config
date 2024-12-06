{
  description = "porcelli.me website dev setup";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs-bundler2326.url = "github:nixos/nixpkgs/80c24eeb9ff46aa99617844d0c4168659e35175f";
    nixpkgs-clang1110.url = "github:nixos/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby, nixpkgs-bundler2326, nixpkgs-clang1110 }:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; 
                                overlays = [nixpkgs-ruby.overlays.default];
                                config = { allowUnfree = true; permittedInsecurePackages = ["openssl-1.1.1w"]; };
                              };
        bundler-ps = import nixpkgs-bundler2326 { inherit system; };
        clang-ps = import nixpkgs-clang1110 { inherit system; };
      } );
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, bundler-ps, clang-ps }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [gcc nixpkgs-ruby.packages.aarch64-darwin."ruby-2.6.5"]) ++ (with bundler-ps; [bundler] ) ++ (with clang-ps; [clang] );
        };
      });
    };
}
