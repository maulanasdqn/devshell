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
          packages = with pkgs; [ 
            hello
          ];

          enterShell = ''
          hello
          '';
        })
      ];
    };

    devShell.x86_64-linux.nodejs = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({ pkgs, ... }: {
          packages = with pkgs; [ 
            nodejs
            nodePackages.yarn
            nodePackages.prettier
          ];

          enterShell = ''
          echo "Welcome to NodeJS Shell!"
          '';
        })
      ];
    };

    devShell.x86_64-linux.python = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({ pkgs, ... }: {
          packages = with pkgs; [ 
            python310
          ];

          enterShell = ''
          echo "Welcome to Python Shell!"
          '';
        })
      ];
    };

  };
}
