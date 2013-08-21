#### -*- mode:makefile -*-
## Build-Depends: xml2rfc, enscript, ghostscript, calibre, wkhtmltopdf, libsaxon-java, fop

NAME=rfc6189bis
NAME0=rfc6189
OUTPUTS=$(NAME0).txt $(NAME0).html $(NAME0).nr $(NAME0).txt.pdf $(NAME0).html.epub $(NAME0).xslt.pdf
OUTPUTS+=$(NAME).txt $(NAME).html $(NAME).nr $(NAME).txt.pdf $(NAME).html.epub $(NAME).xslt.pdf
OUTPUTS+=$(NAME).diff.html

all: all-docs bundle

all-docs: $(OUTPUTS)

bundle: $(NAME).tar.gz

clean:
	rm -f *.txt *.html *.nr *.ps *.pdf *.epub *.exp.xml *.fo *.fop

fetch:
	wget -N http://zfone.com/docs/ietf/$(NAME).xml

$(NAME).diff.html: $(NAME0).txt $(NAME).txt
	./rfcdiff --stdout $(NAME0).txt $(NAME).txt > $@

$(NAME).tar.gz: $(OUTPUTS)
	mkdir -p $(NAME)
	cp $(OUTPUTS) $(NAME)/
	tar cvf $(NAME).tar $(NAME)
	rm -rf $(NAME)
	gzip -f -9 $(NAME).tar

%.txt: %.xml
	xml2rfc $< $@

%.html: %.xml
	xml2rfc $< $@

%.nr: %.xml
	xml2rfc $< $@

%.exp.xml: %.xml
	xml2rfc $< $@

%.txt.ps: %.txt
	enscript --no-header -M A4 -f Courier12 $< -o $@

%.txt.pdf: %.txt.ps
	ps2pdf $<

%.html.epub: %.html
	ebook-convert $< $@

%.html.pdf: %.html
	wkhtmltopdf --zoom 1.25 $< $@

%.fo: %.exp.xml
	saxon-xslt $< rfc2629toFO.xslt > $@

%.fop: %.fo
	saxon-xslt $< xsl11toFop.xslt > $@

%.xslt.pdf: %.fop
	fop $< $@

