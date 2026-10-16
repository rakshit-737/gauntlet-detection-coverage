# syntax=docker/dockerfile:1
FROM python:3.14-slim@sha256:a2b82f3c48559aa0a8446d9af49826b6e2b2016f4cd2afabfe6013ec53729170 AS build
WORKDIR /src
COPY pyproject.toml README.md LICENSE ./
COPY gauntlet ./gauntlet
RUN pip wheel --no-cache-dir --wheel-dir /wheels .

FROM python:3.14-slim@sha256:a2b82f3c48559aa0a8446d9af49826b6e2b2016f4cd2afabfe6013ec53729170
LABEL org.opencontainers.image.source="https://github.com/rakshit-737/gauntlet-detection-coverage" \
      org.opencontainers.image.description="Threat-informed purple-team coverage scoring (lab-only, never executes techniques; replays recorded telemetry)" \
      org.opencontainers.image.licenses="MIT"
RUN useradd --create-home --uid 10001 gauntlet
COPY --from=build /wheels /wheels
RUN pip install --no-cache-dir /wheels/*.whl && rm -rf /wheels
USER gauntlet
WORKDIR /home/gauntlet
ENV GAUNTLET_DATA_DIR=/data
ENTRYPOINT ["gauntlet"]
CMD ["--help"]
