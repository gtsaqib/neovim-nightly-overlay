# To use the overlay

> [!IMPORTANT]
> When using this overlay, you might encounter `error: hash mismatch in fixed-output derivation '/nix/store/...-tree-sitter-bundled-vendor-staging.drv'`.\
> The issue is that `neovim-nightly-overlay` uses and overrides the `treesitter` **from your own package set**. If this `treesitter` is different than the one we expect, you might get a hash mismatch.\
> To work around this, you can either:
>
> - Do not use this flake as an overlay, but simply get its default package output (`inputs.neovim-nightly.packages.${system}.default`)
> - Override `treesitter` with your own version: `pkgs.neovim.override ...`


## with Flakes

If you are using [flakes] to configure your system, you can either reference the
package provided by this flake directly, e.g. for nixos:

```nix
{ inputs, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # or

  environment.systemPackages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```

or you can apply the overlay to your package set, e.g for home-manager:

```nix
{
  inputs = {
    neovim-nightly-overlay.url = "github:gtsaqib/neovim-nightly-overlay";
  };

  outputs = { self, ... }@inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    {
      homeConfigurations = {
        macbook-pro = inputs.home-manager.lib.homeManagerConfiguration {
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
          ];
        };
      };
    };
}
```

### Updating

The `neovim-nightly-overlay` flake itself is updated every day to use the latest `neovim` source code.

However, your own flake needs to be synced **manually**. Remember to regularly update your flake (e.g. by using `nix flake update`) to get a most recent neovim build.

### How to test a neovim pull-request ?

You can select an alternative branch of neovim via nix run
`github:gtsaqib/neovim-nightly-overlay' --override-input neovim-src github:neovim/neovim?ref=pull/XXXX/head` (replace XXXX with the PR number).


# Binary cache

See: https://app.cachix.org/cache/gtsaqib

[flakes]: https://wiki.nixos.org/wiki/Flakes
