{
  description = "GritQL - A query language for searching, linting, and modifying code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        platformData = {
          x86_64-linux = {
            platform = "unknown-linux-gnu";
            arch = "x86_64";
          };
          aarch64-linux = {
            platform = "unknown-linux-gnu";
            arch = "aarch64";
          };
          x86_64-darwin = {
            platform = "apple-darwin";
            arch = "x86_64";
          };
          aarch64-darwin = {
            platform = "apple-darwin";
            arch = "aarch64";
          };
        };

        platData = platformData.${system} or (throw "Unsupported system: ${system}");
        filename = "grit-${platData.arch}-${platData.platform}";
        
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "gritql";
          version = "0.5.1";

          src = pkgs.fetchurl {
            url = "https://github.com/getgrit/gritql/releases/latest/download/${filename}.tar.gz";
            sha256 = "FtCyQ9+hTPa9+TjMSmo17+5uasZcjGUUu1t4AZD40x8=";
          };

          nativeBuildInputs = [ pkgs.makeWrapper ];
          sourceRoot = ".";
          installPhase = ''
            mkdir -p $out/bin
            cp ${filename}/grit $out/bin/
            chmod +x $out/bin/grit
          '';

          meta = with pkgs.lib; {
            description = "GritQL - A query language for searching, linting, and modifying code";
            homepage = "https://docs.grit.io/language/overview";
            license = licenses.mit;
            platforms = [ system ];
          };
        };
      });
}
