FROM timescale/timescaledb-ha:pg18-ts2.26-all

USER root
RUN apt-get update && apt-get install -y openssl sudo && rm -rf /var/lib/apt/lists/*
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown, /usr/bin/openssl" > /etc/sudoers.d/postgres

COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh
USER postgres

ENV PGDATA=/var/lib/postgresql/data/pgdata

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
