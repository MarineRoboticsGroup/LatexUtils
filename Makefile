# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

PAPER = main
CMD_TEX = pdflatex
CMD_DIA = dia
ISPELL = ispell

all: init
	$(CMD_TEX) --shell-escape -interaction=nonstopmode $(PAPER) && bibtex $(PAPER) && $(CMD_TEX) --shell-escape -interaction=nonstopmode $(PAPER) && $(CMD_TEX) --shell-escape -interaction=nonstopmode $(PAPER)
	@$(MAKE) -f $(THIS_FILE) ispell

init:
	touch $(PAPER).pdf
	touch figures/dia/exports/nongaussian-fg.eps

figures: init
	@echo "Exporting Dia figures"
	$(CMD_DIA) --export figures/dia/exports/nongaussian-fg.eps figures/dia/nongaussian-fg.dia

clean:
	rm -f *.aux *.log *.blg *.bbl *.tmp *.out

clean_ispell:
	rm -rf ispell

clean_all: clean clean_ispell
	rm -f $(PAPER).pdf

install_deps:
	sudo apt-get install dia ispell texlive

ispell: clean_ispell
	mkdir -p ispell
	$(ISPELL) -l <$(PAPER).tex | sort | uniq > ispell/check00.txt
	# tail -n +1 check??.txt

show:
	evince $(PAPER).pdf &

.PHONY: all
