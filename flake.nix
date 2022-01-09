{
  description = "DCB design verification document.";

  inputs = {
    nixpkgs-pointer.url = "github:yipengsun/nixpkgs-pointer";
    nixpkgs.follows = "nixpkgs-pointer/nixpkgs";
    flake-utils.follows = "nixpkgs-pointer/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs-pointer, nixpkgs, flake-utils, pre-commit-hooks }:
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
          name = "dcb_design_verfication_doc";
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
