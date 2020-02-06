FROM python:2.7.17-slim

LABEL maintainer="TheMeanCanEHdian"

ARG VERSION
ARG RELEASE

ENV TAUTULLI_DOCKER=True
ENV TZ=UTC

VOLUME /config /plex_logs

RUN \
apt-get -q -y update --no-install-recommends && \
apt-get install -q -y --no-install-recommends \
  curl \
  git && \
rm -rf /var/lib/apt/lists/* && \
pip install --no-cache-dir --upgrade pip && \
pip install --no-cache-dir --upgrade \
  pycryptodomex \
  pyopenssl && \
echo ${VERSION} > /config/version.lock && \
echo ${RELEASE} > /config/release.lock

WORKDIR /app

COPY . /app

CMD [ "python", "Tautulli.py", "--datadir", "/config" ]

EXPOSE 8181
HEALTHCHECK  --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
