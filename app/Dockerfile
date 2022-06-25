FROM alpine:3.16 AS server
WORKDIR /tmp/

RUN apk update && \
    apk add ldc gcc dub zlib-dev openssl-dev libcurl musl-dev && \
    rm -rf /var/cache/apk/*

COPY ./server/dub.selections.json /tmp/
RUN dub run fetch-selections

COPY ./server/dub.sdl /tmp/
ARG BUILD_MODE=release
RUN dub build --build=${BUILD_MODE} --config=deps-only --parallel

COPY ./server /tmp
RUN dub build --build=${BUILD_MODE} --parallel --nodeps

FROM node:16-buster-slim AS client
WORKDIR /tmp

COPY ./client /tmp
RUN npm i && npm run build

FROM alpine:3.16 as publish
EXPOSE 8080
WORKDIR /app

RUN apk update && \
    apk add ldc-runtime zlib openssl && \
    rm -rf /var/cache/apk/*

RUN addgroup --gid 2000 appgroup \
    && adduser --uid 1000 -D appuser appgroup \
    && chown appuser:appgroup  /app
USER appuser:appgroup

COPY --from=server /tmp/bin /app
COPY --from=client /tmp/build /app/public

ENTRYPOINT ["/app/app-server"]