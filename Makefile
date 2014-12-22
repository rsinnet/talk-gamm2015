PROJNAME=gamm2015_sinnet_ames
LATEX_CMD=latex -interaction=nonstopmode
PDFLATEX_CMD=pdflatex -interaction=nonstopmode

$(PROJNAME).pdf: $(PROJNAME).ps
	ps2pdf $<

$(PROJNAME).ps: $(PROJNAME).dvi
	dvips $<

$(PROJNAME).dvi: $(PROJNAME).aux
	$(LATEX_CMD) $(basename $<)
	$(LATEX_CMD) $(basename $<)

$(PROJNAME).aux: $(PROJNAME).tex myrefs.bib
	$(LATEX_CMD) $<
	bibtex $(basename $<)

myrefs.bib: refs.bib format_bibtex_months
	./format_bibtex_months refs.bib myrefs.bib

.PHONY: clean

clean:
	rm -f myrefs.bib $(PROJNAME).pdf $(PROJNAME).ps \
	$(PROJNAME).bbl $(PROJNAME).aux $(PROJNAME).dvi \
	$(PROJNAME).log $(PROJNAME).blg $(PROJNAME).out
