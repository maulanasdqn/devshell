{
  description = "Dev Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    {
      templates = rec {
        Android = {
          path = ./Android;
          description = "Android development environment";
        };

        C = {
          path = ./C;
          description = "C development environment";
        };

        GoLang = {
          path = ./GoLang;
          description = "Go Lang development environment";
        };

        Java = {
          path = ./Java;
          description = "Java development environment";
        };
        
        Java11 = {
          path = ./Java/Java11;
          description = "Java development environment";
        };
        
        Java18 = {
          path = ./Java/Java18;
          description = "Java development environment";
        };
        
        Java19 = {
          path = ./Java/Java19;
          description = "Java development environment";
        };

        Kotlin = {
          path = ./Kotlin;
          description = "Kotlin development environment";
        };

        NodeJS = {
          path = ./NodeJS;
          description = "NodeJS development environment";
        };
        
        NodeJS14 = {
          path = ./NodeJS/NodeJS14;
          description = "NodeJS development environment";
        };
        
        NodeJS16 = {
          path = ./NodeJS/NodeJS16;
          description = "NodeJS development environment";
        };
        
        NodeJS18 = {
          path = ./NodeJS/NodeJS18;
          description = "NodeJS development environment";
        };

        NodeJS19 = {
          path = ./NodeJS/NodeJS19;
          description = "NodeJS development environment";
        };

        Python = {
          path = ./Python;
          description = "Python development environment";
        };

        # rt = rust-toolchain;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) mkShell writeScriptBin;
        exec = pkg: "${pkgs.${pkg}}/bin/${pkg}";

        format = writeScriptBin "format" ''
          ${exec "nixpkgs-fmt"} **/*.nix
        '';

        dvt = writeScriptBin "dvt" ''
          if [ -z $1 ]; then
            echo "no template specified"
            exit 1
          fi

          TEMPLATE=$1

          ${exec "nix"} \
            --experimental-features 'nix-command flakes' \
            flake init \
            --template \
            "github:the-nix-way/dev-templates#''${TEMPLATE}"
        '';

        update = writeScriptBin "update" ''
          for dir in `ls -d */`; do # Iterate through all the templates
            (
              cd $dir
              ${exec "nix"} flake update # Update flake.lock
              ${exec "direnv"} reload    # Make sure things work after the update
            )
          done
        '';
      in
      {
        devShells = {
          default = mkShell {
            packages = [ format update ];
          };
        };

        packages = rec {
          default = dvt;
          inherit dvt;
        };
      });
}