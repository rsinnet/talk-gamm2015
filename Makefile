PROJNAME=gamm2015_sinnet_ames
LATEX_CMD=latex -interaction=nonstopmode
PDFLATEX_CMD=pdflatex -interaction=nonstopmode

EPS_ALL := $(wildcard figs/*.eps)
EPS_TEX := $(wildcard figs/*.eps_tex)

EPS_LATEX := $(subst .eps_tex,.eps_latex,$(EPS_TEX))
EPS_NO_LATEX := $(filter-out $(subst .eps_tex,.eps,$(EPS_TEX)), $(EPS_ALL))

$(PROJNAME).pdf: $(PROJNAME).ps
	ps2pdf $<

$(PROJNAME).ps: $(PROJNAME).dvi
	dvips $<

$(PROJNAME).dvi: $(PROJNAME).aux
	$(LATEX_CMD) $(basename $<)
	$(LATEX_CMD) $(basename $<)

$(PROJNAME).aux: $(PROJNAME).tex $(EPS_LATEX) $(EPS_NO_LATEX) myrefs.bib
	$(LATEX_CMD) $<
	bibtex $(basename $<)

myrefs.bib: refs.bib format_bibtex_months
	./format_bibtex_months refs.bib myrefs.bib

figs/%.eps_latex: figs/%.eps_tex figs/%.eps figs/do_latex_subs.py figs/latex_subs.json
	$(MAKE) -C figs/ $(notdir $@)

.PHONY: clean

clean:
	rm -f myrefs.bib $(PROJNAME).pdf $(PROJNAME).ps \
	$(PROJNAME).bbl $(PROJNAME).aux $(PROJNAME).dvi \
	$(PROJNAME).log $(PROJNAME).blg $(PROJNAME).out
	$(MAKE) -C figs/ clean
