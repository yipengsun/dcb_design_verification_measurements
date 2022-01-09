# Author: Yipeng Sun <syp at umd dot edu>
#
# Based on: https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# Last Change: Sun Jan 09, 2022 at 08:02 PM +0100
MAKE_TEX	:=	pdflatex
ZIP_FILE	:=	dcb_design_verification_measurements.zip

.PHONY: all clean pack version-info

all: dcb_design_verification_measurements.pdf

dcb_design_verification_measurements.pdf: dcb_design_verification_measurements.tex version-info
	@latexmk -pdf \
		-pdflatex="$(MAKE_TEX) -interaction=nonstopmode -synctex=1" \
		-use-make \
		-jobname=build/dcb_design_verification_measurements \
		dcb_design_verification_measurements
	@mv build/dcb_design_verification_measurements.pdf .

clean:
	@rm -rf build/*

pack:
	@echo "Packing all files into a zip bundle..."
	@apack $(ZIP_FILE) ./Makefile ./README.md ./*.tex ./*.pdf ./.latexmkrc ./res

version-info:
	@gitinfo-hook
