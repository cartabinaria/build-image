# SPDX-FileCopyrightText: 2022 - 2023 Luca Tagliavini <luca@teapot.ovh>
# SPDX-FileCopyrightText: 2023 - 2025 Eyad Issa <eyadlorenzo@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

ARG ALPINE_VERSION=3.22

FROM ghcr.io/cartabinaria/statik:latest AS statik

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    build-base \
    git \
    git-lfs \
    libreoffice \
    pandoc \
    ruby \
    ruby-dev \
    tectonic \
    biber \
    typst \
    xournalpp \
    gcc \
    python3-dev \
    musl-dev \
    linux-headers \
    font-noto-cjk-extra \
    font-noto-emoji \
    font-noto-hebrew \
    font-noto-math \
    font-noto-symbols

RUN gem install --no-document asciidoctor-pdf asciidoctor
RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install jupyter

RUN apk del ruby-dev build-base gcc python3-dev musl-dev linux-headers

COPY --from=statik /usr/bin/statik /usr/bin/statik
COPY --from=statik /opt/page.gohtml /usr/share/page.gohtml
COPY --from=statik /opt/style.css /usr/share/style.css

COPY md2pdf /usr/bin/md2pdf
COPY xopp2pdf /usr/bin/xopp2pdf
COPY rec.sh /usr/bin/rec
COPY convert.sh /usr/bin/fconvert
COPY jupyter2html.sh /usr/bin/jupyter2html
