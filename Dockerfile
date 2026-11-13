# syntax=docker/dockerfile:1
FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928 AS build
WORKDIR /src
COPY pyproject.toml README.md LICENSE ./
COPY gauntlet ./gauntlet
RUN pip wheel --no-cache-dir --wheel-dir /wheels .

FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928
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
