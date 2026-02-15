FROM hugomods/hugo:go-0.141.0 AS builder
WORKDIR /src
COPY . .
RUN hugo --minify

FROM caddy:2-alpine
COPY --from=builder /src/public /usr/share/caddy
EXPOSE 80
