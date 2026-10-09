FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash coreutils iputils-ping libc-bin procps \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app/app.sh /app/app.sh
RUN chmod +x /app/app.sh
ENTRYPOINT ["/app/app.sh"]
CMD ["help"]
