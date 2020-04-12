FROM python:2.7.17-slim

LABEL maintainer="TheMeanCanEHdian"

ARG VERSION
ARG BRANCH

ENV TAUTULLI_DOCKER=True
ENV TZ=UTC
ENV PYTHONPATH="${PYTHONPATH}:/usr/lib/python2.7"

WORKDIR /app

RUN \
  apt-get -q -y update --no-install-recommends && \
  apt-get install -q -y --no-install-recommends \
    build-essential libssl-dev libffi-dev \
    curl && \
  pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir --upgrade \
    pycryptodomex \
    pyopenssl && \
  rm -rf /var/lib/apt/lists/* && \
  echo ${VERSION} > /app/version.txt && \
  echo ${BRANCH} > /app/branch.txt && \
  apt-get purge -y --auto-remove \
    build-essential libssl-dev libffi-dev

COPY . /app

CMD [ "python", "Tautulli.py", "--datadir", "/config" ]

VOLUME /config /plex_logs
EXPOSE 8181
HEALTHCHECK  --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
