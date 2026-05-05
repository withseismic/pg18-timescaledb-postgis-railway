FROM timescale/timescaledb-ha:pg18-ts2.26-all

USER root
RUN apt-get update && apt-get install -y openssl sudo && rm -rf /var/lib/apt/lists/*
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown, /usr/bin/openssl" > /etc/sudoers.d/postgres

COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh
COPY --chmod=755 healthcheck.sh /usr/local/bin/healthcheck.sh
USER postgres

ENV PGDATA=/var/lib/postgresql/data/pgdata

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
  CMD ["healthcheck.sh"]

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
