{
  description = "NodeJS Dev Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

    let
      pkgs = nixpkgs.legacyPackages.${system};
    in

    {

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [
          nodejs-18_x
          nodePackages.yarn
          nodePackages.prettier
          nodePackages.typescript
          nodePackages.prisma
          openssl
        ];
        shellHook = with pkgs; ''
          export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/migration-engine"
          export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
          export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
          export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
          export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"
          export PATH=~/.npm-packages/bin:$PATH
          export NODE_PATH=~/.npm-packages/lib/node_modules
          echo "Anda menggunakan NodeJS versi $(node -v)"
        '';
      };

    });
}