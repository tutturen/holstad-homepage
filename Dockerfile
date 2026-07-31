FROM hugomods/hugo:go-git-0.164.0 AS builder
WORKDIR /src
COPY . .
RUN hugo --minify

FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /src/public /usr/share/caddy
EXPOSE 80
