# makefile

all: rfc6189.txt rfc6189.html rfc6189.nr rfc6189bis.txt rfc6189bis.html rfc6189bis.nr rfc6189bis.diff.html

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

