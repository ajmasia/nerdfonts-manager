{
  description = "Nerd Fonts Manager (nfm)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      packages.x86_64-linux.nfm = pkgs.stdenv.mkDerivation {
        pname = "nfm";
        version = "1.0.0";

        src = ./.;

        installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/share/nfm/lib
          cp nfm $out/bin/nfm
          cp lib/utils.sh $out/share/nfm/lib/utils.sh
        '';
      };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.nfm;
    };
}

