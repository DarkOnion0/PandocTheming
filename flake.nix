{
  description = "A CLI app to render markdown code to awesome PDF with the help of pandoc";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs @ {
    self,
    flake-utils,
    nixpkgs,
    devenv,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        inherit (builtins) substring;

        # to work with older version of flakes
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

        # Generate a user-friendly version number.
        version = builtins.substring 0 8 lastModifiedDate;

        # Packages aliases
        pkgs = nixpkgs.legacyPackages.${system};

        prodPackages = with pkgs; [
          fish
          python3Packages.weasyprint
          #wkhtmltopdf
          nerdfonts
          pandoc
          nodePackages.sass
        ];
      in rec {
        devShell = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              enterShell = ''
                # Welcome script
                echo -e "\n$(tput bold)Welcome in the nix flake of PandocTheming repo$(tput sgr0)"
              '';

              packages = with pkgs;
                [
                  alejandra
                  nodePackages.prettier
                ]
                ++ prodPackages;

              scripts = {
                run-build.exec = "sass --update 'style/sass:style/css'";
              };

              pre-commit.hooks = {
                # Nix
                alejandra.enable = true;

                # Markdown...
                prettier = {
                  enable = true;
                  files = "\\.(scss|md|html)$";
                };

                # Sass compilation
                #sass-compilation = {
                #  enable = true;
                #  name = "Sass Compilation";
                #  entry = "run-build";
                #  files = "\\.scss$";
                #};
              };
            }
          ];
        };

        packages = rec {
          default = pandocTheming;
          pandocTheming = pkgs.stdenv.mkDerivation {
            inherit version;
            name = "pandocTheming";
            src = ./.;

            dontUnpack = true;

            buildInputs = prodPackages;

            nativeBuildInputs = [
              pkgs.makeWrapper
            ];

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin

              ls -larth $src/style

              #sass $src/style/sass:$src/style/css # TODO: implement this inside nix
              cp -r $src/style $out/
              cp -r $src/template $out/
              cp -r $src/cli.fish $out/
              cp -r $src/filter $out/

              chmod +x $out/cli.fish

              runHook postInstall
            '';

            preFixup = ''
              # Replace var inside cli
              # TODO: use substitute-all instead https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/substitute/substitute-all.nix
              sed -i "s|@styleDir@|$out/style|g" $out/cli.fish
              sed -i "s|@templateDir@|$out/template|g" $out/cli.fish

              cat $out/cli.fish

              makeWrapper $out/cli.fish $out/bin/pandocTheming \
                --prefix PATH : ${pkgs.lib.makeBinPath prodPackages} \
            '';
          };
        };

        apps = rec {
          default = pandocTheming;
          pandocTheming = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/pandocTheming";
          };
        };
      }
    );
}
