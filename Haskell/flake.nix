{
  description = "A Nix-flake-based Haskell development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ cabal-install ghc ];

        shellHook = with pkgs; ''
          ${ghc}/bin/ghc --version
          ${cabal-install}/bin/cabal --version
        '';
      };
    });
}