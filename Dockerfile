# Container image that runs your code
FROM --platform=$BUILDPLATFORM debian:stable-slim AS base

RUN apt-get update \
&& apt-get install wget=1.21.\* -y \
&& wget -q https://github.com/CycloneDX/sbom-utility/releases/download/v0.17.0/sbom-utility-v0.17.0-linux-amd64.tar.gz \
&& tar -xvzf sbom-utility-v0.17.0-linux-amd64.tar.gz


FROM python:3.12-alpine
RUN apk add gcompat=~1.1 --no-cache \
&& apk add sudo=~1.9 --no-cache \
&& pip3 --no-cache-dir install tabulate==0.9.0 \
&& rm -rf /var/cache/apk/*
COPY analyze_and_check_sbom.sh check_usage_policy.py mw_license_policy.json /
COPY --from=base /sbom-utility /
RUN chmod +x /analyze_and_check_sbom.sh \
&& chmod +x ./sbom-utility
RUN addgroup sudo \
&& adduser --disabled-password --gecos '' docker \
&& adduser docker sudo \
&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker
ENTRYPOINT [ "sh", "-c", "/analyze_and_check_sbom.sh"]
