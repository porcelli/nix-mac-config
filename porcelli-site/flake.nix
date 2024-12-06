{
  description = "porcelli.me website dev setup";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby }:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; permittedInsecurePackages = ["openssl-1.1.1w"] }; };
        ruby-ps = import nixpkgs-ruby.url { inherit system; };
      } );
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, ruby-ps }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [
            docker ]) ++ (with ruby-ps; [ruby-2.6.5]);
          shellHook = ''
            # tmuxinator apache-kie
          '';
        };
      });
    };
}
