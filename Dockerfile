# Container image that runs your code
FROM --platform=$BUILDPLATFORM alpine:3.21 AS base

ENV SBOMUTILITY_VERSION "0.17.0"
ARG TARGETARCH
RUN echo "$BUILDPLATFORM" && wget -q \
  "https://github.com/CycloneDX/sbom-utility/releases/download/v${SBOMUTILITY_VERSION}/sbom-utility-v${SBOMUTILITY_VERSION}-linux-${TARGETARCH}.tar.gz" \
  -O sbom-utility.tar.gz \
  && tar -xvzf sbom-utility.tar.gz


FROM python:3.12-alpine
RUN adduser --disabled-password --gecos '' -h /sbom sbom \
  && apk add gcompat=~1.1 --no-cache \
  && apk add sudo=~1.9 --no-cache \
  && pip3 --no-cache-dir install tabulate==0.9.0 \
  && rm -rf /var/cache/apk/*
COPY analyze_and_check_sbom.sh check_usage_policy.py mw_license_policy.json /sbom/
COPY --from=base /sbom-utility /sbom
RUN chmod +x /sbom/analyze_and_check_sbom.sh \
  && chmod +x ./sbom/sbom-utility
USER sbom
ENTRYPOINT [ "sh", "-c", "/sbom/analyze_and_check_sbom.sh"]
