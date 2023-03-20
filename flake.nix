{
  description = "Maulana Sodiqin DevShell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = {self, nixpkgs, devenv, ...}@inputs:

  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
  in

  {
    devShell.x86_64-linux = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({ pkgs, ... }: {
          packages =  [ 
            pkgs.nodejs
            pkgs.nodePackages.yarn
            pkgs.nodePackages.prettier
          ];

          enterShell = ''
          echo "Welcome to NodeJS Shell!"
          zsh
          '';
        })
      ];
    };

  };

}
