# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d447718eb6e6ab2f0f4c9bd41e7559e3f6a67a66536dec6b103239c8beb04ceb as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ae93505cca87c6ea679ef7b1c61ec33a86e89329067c059d54e8a585313098e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
