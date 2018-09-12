# Set default programs for compiling, viewing, and archiving
VIEW_PDF	:=	zathura
PACK_ZIP	:=	apack
TEX_COMP	:=	xelatex
MAKE_BIB	:=	biber
UPDT_VCS	:=	git

# Basic variables
BASEFILE	?=	$(basename $(wildcard *.tex))
TEX_FILE	:=	$(BASEFILE).tex
BIB_FILE	:=	$(BASEFILE).bib
TMP_FILE	:=	$(BASEFILE)-print.tex
PDF_FILE	:=	$(BASEFILE).pdf
ZIP_FILE	:=	$(BASEFILE).zip
VCS_FILE	:=	.$(UPDT_VCS)
GEN_FILE	:=	*.swp *.bak *.out *.bbl *.blg *.log *.aux *.bcf *.xml *.snm *.toc *.vrb *.nav _minted*

# If version control exists, run corresponding command to generate info.
ifeq ($(wildcard $(VCS_FILE)),)
	vcsExists = @echo "No '$(VCS_FILE)' found. Skipping..."
else
	vcsExists = @$(UPDT_VCS) checkout
endif

# If '.bib' exists, run corresponding command to generate bibliography.
ifeq ($(wildcard $(BIB_FILE)),)
	bibExists = @echo "No '$(BIB_FILE)' found. Skipping..."

else
	define bibExists
		@$(2) $(1);
		@$(MAKE_BIB) $(basename $(1));
endef
endif

# Main compile function
define compileTeX
	$(call vcsExists)
	$(call bibExists, $(1), $(2))
	@$(2) $(1);
	@$(2) $(1);
endef

pdf:
	$(call compileTeX, $(TEX_FILE), $(TEX_COMP))

view:
	$(VIEW_PDF) $(PDF_FILE)

clean:
	@echo "Cleaning generated files during compilation..."
	@for tmp in $(GEN_FILE); do				\
		find . -name $$tmp | xargs rm -rf;	\
	done

pack: clean
	@echo "Packing all files into a zip bundle..."
	@apack $(ZIP_FILE) ./

all: pdf pack
