FROM dlang2/ldc-ubuntu:1.14.0 as builder
WORKDIR /src
COPY dub.sdl dub.selections.json /src/
# do a first build without sources to fetch and build all dependencies
RUN dub build -c release || true
COPY source /src/source
RUN dub build -c release

FROM busybox
COPY --from=builder /src/d-template /app
RUN chmod +x /app
WORKDIR /src
EXPOSE 8080
ENTRYPOINT [ "/app" ]
