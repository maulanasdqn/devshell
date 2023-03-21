{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
    phps.url = "github:loophp/nix-shell";
  };

  outputs = inputs@{ flake-parts, phps, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.hello;

        devenv.shells.default = {
          packages = [
            config.packages.default
            pkgs.starship
          ];
          enterShell = ''
            eval "$(starship init bash)"
            hello
            echo "Welcome to Maulana Sodiqin Shell!"
          '';
        };

        devenv.shells.PHP81 = {
          packages = [
            pkgs.starship
            phps.packages.${system}.env-php81
          ];
          enterShell = ''
            eval "$(starship init bash)"
            echo "Anda menggunakan versi PHP $(php --version)"
          '';
          languages.php.enable = true;
        };

        devenv.shells.PHP74 = {
          packages = [
            pkgs.starship
            phps.packages.${system}.env-php74
          ];
          enterShell = ''
            eval "$(starship init bash)"
            echo "Anda menggunakan versi PHP $(php --version)"
          '';
          languages.php.enable = true;
        };

        devenv.shells.NodeJSLTS = {
          packages = with pkgs; [ 
            nodejs 
            nodePackages.yarn
            nodePackages.prettier
            starship
          ];
          enterShell = ''
            eval "$(starship init bash)"
            echo "Anda menggunakan versi NodeJS $(node -v)"
          '';
          languages.javascript.enable = true;
          languages.typescript.enable = true;
        };

        devenv.shells.NodeJSLatest = {
          packages = with pkgs; [ 
            nodejs-19_x 
            nodePackages.yarn
            nodePackages.prettier
            starship
          ];
          enterShell = ''
            eval "$(starship init bash)"
            echo "Anda menggunakan versi NodeJS $(node -v)"
          '';
          languages.javascript.enable = true;
          languages.typescript.enable = true;
        };

        devenv.shells.Python310 = {
          packages = with pkgs; [ 
            python310
            python310Packages.pip
            python310Packages.virtualenv
            poetry
            starship
          ];
          enterShell = ''
            python --version
            eval "$(starship init bash)"
          '';
          languages.python.enable = true;
        };

        devenv.shells.Python311 = {
          packages = with pkgs; [ 
            python311
            python311Packages.pip
            python311Packages.virtualenv
            poetry
            starship
          ];
          enterShell = ''
            eval "$(starship init bash)"
            echo "Anda menggunakan versi Python $(python --version)"
          '';
          languages.python.enable = true;
        };
        
      };
    };
}
