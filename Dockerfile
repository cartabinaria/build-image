FROM golang:alpine AS go-builder
WORKDIR /tmp
RUN go install github.com/lucat1/statik@latest
RUN cp $GOPATH/bin/statik /tmp/statik

FROM alpine:edge
COPY --from=go-builder /tmp/statik /usr/bin/statik
COPY md2pdf /usr/bin/m2pdf
COPY rec /usr/bin/rec
COPY page.gohtml /usr/share/page.gohtml

RUN apk update && apk add --no-cache texlive-full libreoffice pandoc
