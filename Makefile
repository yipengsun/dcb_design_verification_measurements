# Author: Yipeng Sun <syp at umd dot edu>
#
# Based on: https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# Last Change: Wed Sep 26, 2018 at 06:20 PM -0400

# Set default programs for compiling and archiving
MAKE_TEX	:=	lualatex
ZIP_FILE	:=	dcb_design_verification_measurements.zip

# We assume if the generated file is newer than the source, then it is good enough.
.PHONY: all clean pack

all: dcb_design_verification_measurements.pdf

dcb_design_verification_measurements.pdf: dcb_design_verification_measurements.tex .git/gitHeadInfo.gin
	@latexmk -pdf \
		-pdflatex="$(MAKE_TEX) -interaction=nonstopmode -synctex=1" \
		-use-make \
		-jobname=build/dcb_design_verification_measurements \
		dcb_design_verification_measurements
	@mv build/dcb_design_verification_measurements.pdf .
	@mv build/dcb_design_verification_measurements.synctex.gz .

clean:
	@rm -rf build/*

pack:
	@echo "Packing all files into a zip bundle..."
	@apack $(ZIP_FILE) ./Makefile ./README.md ./pkgs ./*.tex ./*.pdf
