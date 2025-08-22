{
  description = "Nerd Fonts Manager (nfm)";

  inputs = {
    # Pin nixpkgs to unstable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Step 1: Wrap the main script with writeShellApplication.
      # This ensures runtime dependencies (fzf, unzip, wget, curl)
      # are available in PATH when executing the binary.
      nfmBin = pkgs.writeShellApplication {
        name = "nfm";
        runtimeInputs = [
          pkgs.fzf
          pkgs.unzip
          pkgs.wget
          pkgs.curl
        ];
        # Use the local script as source
        text = builtins.readFile ./nfm;

        # Disable shellcheck here since it complains
        # about dynamic `source` paths not being constant.
        checkPhase = '' true '';
      };
    in {
      # Step 2: Combine the wrapped binary with extra files
      # (utils.sh library and bash completion).
      packages.${system}.default = pkgs.runCommand "nerdfonts-manager-1.3.2" {
        pname = "nerdfonts-manager";
        version = "1.3.2";

        meta = with pkgs.lib; {
          description = "A simple Nerd Fonts manager written in Bash";
          homepage = "https://github.com/ajmasia/nerdfonts-manager";
          license = licenses.mit;         # adjust if needed
          maintainers = with maintainers; [ ajmasia ]; # replace with your handle
          platforms = platforms.linux;    # restrict only to Linux

        };
      } ''
        mkdir -p $out

        # Copy the binary produced by writeShellApplication
        cp -r ${nfmBin}/* $out/

        # Install extra resources: utils.sh and bash completion
        mkdir -p $out/share/nfm/lib
        mkdir -p $out/share/bash-completion/completions

        install -m644 ${./lib/utils.sh} $out/share/nfm/lib/utils.sh
        install -m644 ${./contrib/nfm-completion.bash} \
          $out/share/bash-completion/completions/nfm

        # Patch the script so it points to the correct utils.sh location
        substituteInPlace $out/bin/nfm \
          --replace '/usr/local/share/nfm/lib/utils.sh' \
                    "$out/share/nfm/lib/utils.sh"
      '';

      # Step 3: Expose the package as an app so you can run it with `nix run .`
      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nfm";
      };
    };
}

