MARKDOWN_FILE = agile-editing-pandoc.md
PANDOC_DEFAULT_OPTIONS = -S -s --columns=5

PANDOC_LATEX_OPTIONS = --template=pandoc-peerj.latex
PANDOC_LATEX_OPTIONS += --latex-engine=xelatex
PANDOC_LATEX_OPTIONS += -M fontsize=10pt
PANDOC_LATEX_OPTIONS += -M classoption=fleqn
PANDOC_LATEX_OPTIONS += -M documentclass=wlpeerj
PANDOC_LATEX_OPTIONS += --csl=peerj.csl

PANDOC_NONTEX_OPTIONS = --filter pandoc-citeproc --csl=plos.csl

# LATEX code will produce with the --natbib option, which also enables the
# extraction of citations using BibTool PDF generation uses the --filter
# pandoc-citeproc option.

all: outfile.tex outfile.pdf outfile.docx outfile.odt outfile.epub outfile.html

outfile.tex: $(MARKDOWN_FILE) pandoc-peerj.latex
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
	       --natbib \
	       $(PANDOC_LATEX_OPTIONS) \
	       -o $@ $<

outfile.pdf: $(MARKDOWN_FILE) pandoc-peerj.latex agile-markdown.bib
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
	        --filter pandoc-citeproc \
	       $(PANDOC_LATEX_OPTIONS) \
	       -o $@ $<

outfile.docx: $(MARKDOWN_FILE)
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
	       $(PANDOC_NONTEX_OPTIONS) \
	       --reference-docx=pandoc-manuscript.docx \
	       -o $@ $<

outfile.odt: $(MARKDOWN_FILE)
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
				 $(PANDOC_NONTEX_OPTIONS) \
				 --reference-odt=pandoc-manuscript.odt \
				 -o $@ $<


outfile.epub: $(MARKDOWN_FILE)
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
	       $(PANDOC_NONTEX_OPTIONS) \
	       --toc \
	       -o $@ $<

outfile.html: $(MARKDOWN_FILE)
	pandoc $(PANDOC_DEFAULT_OPTIONS) \
	       $(PANDOC_NONTEX_OPTIONS) \
	       --toc \
				 --mathjax \
				 -c pandoc.css \
	       -M include-after:'<script src="https://d3js.org/d3.v4.min.js"></script><script src="graphs/pub-costs.js"></script>' \
	       -o $@ $<

clean:
	rm -f outfile.*

.PHONY: all clean
