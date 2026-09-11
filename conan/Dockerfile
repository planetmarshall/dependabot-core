# syntax=docker.io/docker/dockerfile:1.20
FROM ghcr.io/dependabot/dependabot-updater-core

ENV PATH=/opt/conan-venv/bin:${PATH}

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-venv && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/conan-venv && \
    /opt/conan-venv/bin/python -m pip install conan==2.32.0

USER dependabot

ENV REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

RUN conan profile detect

COPY --chown=dependabot:dependabot --parents conan common $DEPENDABOT_HOME/
COPY --chown=dependabot:dependabot updater $DEPENDABOT_HOME/dependabot-updater
