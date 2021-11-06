FROM alpine:latest AS server
WORKDIR /tmp

RUN apk update && \
    apk add dub gcc ldc libcurl libevent-dev musl-dev openssl-dev zlib-dev && \
    rm -rf /var/cache/apk/*

COPY ./server/dub.selections.json /tmp
RUN dub run fetch-selections

COPY ./server /tmp

ARG BUILD_MODE=release
RUN dub build --build=${BUILD_MODE} --parallel

FROM node:16-buster-slim AS client
WORKDIR /tmp

COPY ./client /tmp
RUN npm i && npm run build

FROM alpine:latest as publish
WORKDIR /app

RUN apk update && \
    apk add ldc-runtime zlib openssl && \
    rm -rf /var/cache/apk/*

COPY --from=server /tmp/bin /app
COPY --from=client /tmp/build /app/public

ENTRYPOINT ["/app/app-server"]