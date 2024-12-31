# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f4d352be4dbf850c0135a21b69bf9e334ca9c990fbdebb635c8ca4537ce43f92 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8485986f5483c93e0e154a6dd186695c0b218eab68ae6e72573df506b3cffdb2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
