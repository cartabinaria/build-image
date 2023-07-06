FROM ghcr.io/csunibo/statik:latest as statik

FROM alpine
RUN apk add --no-cache tectonic libreoffice pandoc ruby xournalpp
RUN gem install --no-document asciidoctor-pdf asciidoctor
COPY --from=statik /usr/bin/statik /usr/bin/statik
COPY md2pdf /usr/bin/md2pdf
COPY xopp2pdf /usr/bin/xopp2pdf
COPY rec /usr/bin/rec
COPY page.gohtml /usr/share/page.gohtml
