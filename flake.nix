{
  description = "Talks by me.";

  inputs = {
    nixpkgs-pointer.url = "github:yipengsun/nixpkgs-pointer";
    nixpkgs.follows = "nixpkgs-pointer/nixpkgs";
    flake-utils.follows = "nixpkgs-pointer/flake-utils";
  };

  outputs = { self, nixpkgs-pointer, nixpkgs, flake-utils }:
    {
      overlay = import ./nix/overlay.nix;
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        devShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; } {
          buildInputs = [
            pkgs.gitinfo-hook
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-basic
                # Explicit dependencies
                gitinfo2
                # Implicit dependencies
                ;
            })
          ];
        };
      });
}
