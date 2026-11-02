FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata curl wget iproute2 procps docker-cli
WORKDIR /app
COPY vos-middleware /app/vos-middleware
RUN chmod +x /app/vos-middleware
EXPOSE 8080
ENTRYPOINT ["/app/vos-middleware"]
