# makefile

all: rfc6189.txt rfc6189.html rfc6189.nr rfc6189.txt.ps rfc6189.txt.pdf rfc6189.html.epub rfc6189.html.pdf rfc6189bis.txt rfc6189bis.html rfc6189bis.nr rfc6189bis.txt.ps rfc6189bis.txt.pdf rfc6189bis.html.epub rfc6189bis.html.pdf rfc6189bis.diff.html

clean:
	rm -f *.html

rfc6189bis.diff.html: rfc6189.txt rfc6189bis.txt
	./rfcdiff --stdout rfc6189.txt rfc6189bis.txt > $@

%.txt: %.xml
	xml2rfc $< $@

%.html: %.xml
	xml2rfc $< $@

%.nr: %.xml
	xml2rfc $< $@

%.txt.ps: %.txt
	enscript --no-header -M A4 -f Courier12 $< -o $@

%.txt.pdf: %.txt.ps
	ps2pdf $<

%.html.epub: %.html
	ebook-convert $< $@

%.html.pdf: %.html
	wkhtmltopdf --zoom 1.25 $< $@

