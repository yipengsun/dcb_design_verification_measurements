# DCB design verification measurements [![github CI](https://github.com/yipengsun/dcb_design_verification_measurements/workflows/CI/badge.svg?branch=master)](https://github.com/yipengsun/dcb_design_verification_measurements/actions?query=workflow%3ACI)

We collect all measurements for DCB design verification propose and compile
them into a single documentation.


## Build

This project utilizes `nix` (with `flake`) to build new pdf files.
The build procedure is the following:

1. Install `nix` with `flake` support
2. Go to project root, run `nix develop`
3. In the resulting shell, run `make`
