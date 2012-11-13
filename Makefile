# makefile

OUTPUTS=rfc6189.txt rfc6189.html rfc6189.nr rfc6189.txt.pdf rfc6189.html.epub rfc6189.xslt.pdf rfc6189bis.txt rfc6189bis.html rfc6189bis.nr rfc6189bis.txt.pdf rfc6189bis.html.epub rfc6189bis.xslt.pdf rfc6189bis.diff.html

all: all-docs bundle

all-docs: $(OUTPUTS)

bundle: rfc6189bis.tar.gz

clean:
	rm -f *.txt *.html *.nr *.ps *.pdf *.epub *.exp.xml *.fo *.fop

fetch:
	wget -N http://zfone.com/docs/ietf/rfc6189bis.xml

rfc6189bis.diff.html: rfc6189.txt rfc6189bis.txt
	./rfcdiff --stdout rfc6189.txt rfc6189bis.txt > $@

rfc6189bis.tar.gz: $(OUTPUTS)
	mkdir -p rfc6189bis
	cp $(OUTPUTS) rfc6189bis/
	tar cvf rfc6189bis.tar rfc6189bis
	rm -rf rfc6189bis
	gzip -f -9 rfc6189bis.tar

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

