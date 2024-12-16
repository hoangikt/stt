# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e22e86b81a5ef8bf50ed6899e5d55ae44725791febde5a67bc2e8afd5939bad6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b69271bb5c3f06f5afa4c40a77867784e907408ab991e4d6e907f5aa796b87b8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
