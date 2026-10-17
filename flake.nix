{
  description = "Neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    neovim-src = {
      url = "github:neovim/neovim";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://gtsaqib.cachix.org"
    ];
    extra-trusted-public-keys = [
      "gtsaqib.cachix.org-1:2o0uyw7seQ59glhJ9Epk8isXlFbvN+oL5YElsZFOMZ8="
    ];
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./flake
      ];
    };
}
