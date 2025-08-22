{
  description = "Nerd Fonts Manager (nfm)";

  inputs = {
    # Use the stable nixpkgs release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # Main package definition
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "nerdfonts-manager";
        version = "1.3.2";

        # Source is the current repo
        src = ./.;

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          # Create output directories
          mkdir -p $out/bin
          mkdir -p $out/share/nfm/lib
          mkdir -p $out/share/bash-completion/completions

          # Install main script
          install -m755 nfm $out/bin/nfm

          # Install library script
          install -m644 lib/utils.sh $out/share/nfm/lib/utils.sh

          # Install bash completion
          install -m644 contrib/nfm-completion.bash $out/share/bash-completion/completions/nfm

          # wrap nfm to ensure dependencies are in PATH
          wrapProgram $out/bin/nfm \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.fzf pkgs.curl pkgs.wget pkgs.unzip ]}

          runHook postInstall
        '';
      };

      # Expose the app so you can run it via `nix run .`
      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nfm";
      };
    };
}
