{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.hello;

        devenv.shells.default = {
          packages = [ config.packages.default ];
          enterShell = ''
            hello
            echo "Welcome to Maulana Sodiqin Shell!"
          '';
        };

        devenv.shells.NodeJS = {
          packages = with pkgs; [ 
            nodejs 
            nodePackages.yarn
            nodePackages.prettier
          ];

          enterShell = ''
            node -v
          '';
        };

        devenv.shells.Python = {
          packages = with pkgs; [ 
            python310
            python310Packages.pip
            python310Packages.virtualenv
          ];

          enterShell = ''
            python --version
          '';
        };
        
      };
    };
}
