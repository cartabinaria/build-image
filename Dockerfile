FROM ghcr.io/csunibo/statik:latest as statik

FROM alpine
RUN apk add --no-cache \
    build-base \
    git \
    git-lfs \
    libreoffice \
    pandoc \
    ruby \
    ruby-dev \
    tectonic \
    typst \
    xournalpp
RUN gem install --no-document asciidoctor-pdf asciidoctor
RUN apk del ruby-dev build-base
COPY --from=statik /usr/bin/statik /usr/bin/statik
COPY md2pdf /usr/bin/md2pdf
COPY xopp2pdf /usr/bin/xopp2pdf
COPY rec.sh /usr/bin/rec
COPY convert.sh /usr/bin/fconvert
COPY --from=statik /opt/page.gohtml /usr/share/page.gohtml
COPY --from=statik /opt/style.css /usr/share/style.css
