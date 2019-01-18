ARG ALPINE=alpine:3.7

FROM ${ALPINE} AS verify

RUN apk add --no-cache gnupg

ARG SERF_PGP_FINGERPRINT=91a6e7f85d05c65630bef18951852d87348ffc4c
ARG SERF_PLATFORM=linux_amd64
ARG SERF_VERSION=0.8.1

ADD https://keybase.io/hashicorp/pgp_keys.asc?fingerprint=${SERF_PGP_FINGERPRINT} /tmp/hashicorp.asc
ADD https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_SHA256SUMS /tmp
ADD https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_SHA256SUMS.sig /tmp
ADD https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_${SERF_PLATFORM}.zip /tmp

WORKDIR /tmp

RUN gpg --import /tmp/hashicorp.asc
RUN gpg --verify serf_${SERF_VERSION}_SHA256SUMS.sig serf_${SERF_VERSION}_SHA256SUMS
RUN grep ${SERF_PLATFORM}.zip serf_${SERF_VERSION}_SHA256SUMS | sha256sum -cs

WORKDIR /opt/hashicorp/serf/bin

RUN unzip /tmp/serf_${SERF_VERSION}_linux_amd64.zip

FROM scratch AS serf

COPY --from=verify /opt /opt

ENV PATH=/opt/hashicorp/serf/bin
ENTRYPOINT ["serf"]
CMD ["help"]
