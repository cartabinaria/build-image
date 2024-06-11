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
    xournalpp \
    gcc \
    python3-dev \
    musl-dev \
    linux-headers
RUN gem install --no-document asciidoctor-pdf asciidoctor
RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install jupyter
RUN apk del ruby-dev build-base gcc python3-dev musl-dev linux-headers
COPY --from=statik /usr/bin/statik /usr/bin/statik
COPY md2pdf /usr/bin/md2pdf
COPY xopp2pdf /usr/bin/xopp2pdf
COPY rec.sh /usr/bin/rec
COPY convert.sh /usr/bin/fconvert
COPY jupyter2html /usr/bin/jupyter2html
COPY --from=statik /opt/page.gohtml /usr/share/page.gohtml
COPY --from=statik /opt/style.css /usr/share/style.css
