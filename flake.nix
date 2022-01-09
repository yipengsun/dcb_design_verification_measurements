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
    # Meh, this pre-commit check is pretty heavy on dependency
    # Still preserved as it may be useful for a future project
    #
    # FIXME: I need to explicitly list platforms, otherwise I got this:
    #          error: attribute 'aarch64-darwin' missing
    #
    #                 at /nix/store/xq146v7sp6xrya78dfa546ppr0f4kwl5-source/flake.nix:24:30:
    #
    #                     23|         checks = {
    #                     24|           pre-commit-check = pre-commit-hooks.lib.${system}.run {
    #                       |                              ^
    #                     25|             src = ./.;
    #
    #        presumbly this is because pre-commit-hooks doesn't support Apple M1 yet?
    #
    #        also, the check would fail with error code 1, so don't run:
    #          nix flake check
    #        yet!
    flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              gitinfo = {
                enable = true;
                name = "Generate gitinfo version file";
                entry = "${pkgs.gitinfo-hook}/bin/gitinfo-hook";
                files = "\\.(tex)$";
                pass_filenames = false;
              };
            };
          };
        };
        devShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; } {
          name = "dcb_design_verfication_doc";
          buildInputs = [
            pkgs.gitinfo-hook
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-basic
                # Explicit dependencies
                latexmk
                refman
                gitinfo2
                mathtools
                cleveref
                caption
                microtype
                xcolor
                framed
                booktabs
                siunitx
                placeins
                chngcntr
                # Implicit dependencies
                etoolbox
                xstring
                eso-pic
                pgf      # <- tikz
                pgfopts  # <- also tikz
                ;
            })
          ];
        };
        shellHook = ''
          # Fix date problem for LuaLaTeX
          # self.lastModified is the date of last commit
          SOURCE_DATE_EPOCH=${toString self.lastModified}
        '';
      });
}
