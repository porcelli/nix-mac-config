Install Nix on Mac:

```
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install
```

Rebuild local setup

```
darwin-rebuild switch --flake .
```

Run develop config from local:

```
nix develop "git+file:///Users/porcelli/Code/nix-mac-config?dir=bamoe8"
```

Run develop config from GitHub:

```
nix develop "github:porcelli/nix-mac-config?dir=apache-kie"
```

Create develop config:

```
nix develop --profile ~/java-bamoe8 "git+file:///Users/porcelli/Code/nix-mac-config?dir=java-bamoe8"
```

Run local develop profile

```
nix develop ~/java-bamoe8 -c $SHELL
```

For website, while I don't fix the allow insecure config, this is how to use:

NIXPKGS_ALLOW_INSECURE=1 nix develop --impure "git+file:///Users/porcelli/Code/nix-mac-config?dir=porcelli-site" -c $SHELL