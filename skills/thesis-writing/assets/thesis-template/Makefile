MAIN=thesis
WATERMARKED=thesis-watermarked
PYTHON=python3
XELATEX=xelatex
BIBTEX=bibtex
AUX_EXTENSIONS=aux bbl bcf blg fdb_latexmk fls lof log lot out run.xml synctex.gz toc xdv
MAIN_AUX=$(addprefix $(MAIN).,$(AUX_EXTENSIONS)) $(MAIN)-blx.bib
WATERMARKED_AUX=$(addprefix $(WATERMARKED).,$(AUX_EXTENSIONS)) $(WATERMARKED)-blx.bib

.PHONY: all convert pdf watermarked clean

all: pdf

convert:
	$(PYTHON) scripts/convert_md_to_tex.py

pdf: convert
	@set -e; \
	trap 'rm -f watermark.tex' EXIT; \
	cp src/without-watermark.tex watermark.tex; \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(MAIN) thesis.tex; \
	$(BIBTEX) $(MAIN); \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(MAIN) thesis.tex; \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(MAIN) thesis.tex

watermarked: convert
	@set -e; \
	trap 'rm -f watermark.tex' EXIT; \
	cp src/with-watermark.tex watermark.tex; \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(WATERMARKED) thesis.tex; \
	$(BIBTEX) $(WATERMARKED); \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(WATERMARKED) thesis.tex; \
	$(XELATEX) -interaction=nonstopmode -halt-on-error -jobname=$(WATERMARKED) thesis.tex

clean:
	rm -f chapters/*.tex watermark.tex
	rm -f $(MAIN).pdf $(WATERMARKED).pdf $(MAIN_AUX) $(WATERMARKED_AUX)
