FROM ghcr.io/csunibo/statik:latest as statik
FROM alpine:edge

# Add edge testing repo
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache tectonic libreoffice pandoc ruby xournalpp git git-lfs typst
RUN gem install --no-document asciidoctor-pdf asciidoctor

COPY --from=statik /usr/bin/statik /usr/bin/statik

COPY md2pdf /usr/bin/md2pdf
COPY xopp2pdf /usr/bin/xopp2pdf
COPY rec /usr/bin/rec
COPY page.gohtml /usr/share/page.gohtml
