# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3e3ad4d787d0ee40e4b1cab27d2d5d6b0d213937ccd0aefaf8ebc1e8fe6dbd52 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8d7bf8f0939c186fc2dbfc252a22df0fcc1ecef2490ea3f124aa448e14bf19c9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
