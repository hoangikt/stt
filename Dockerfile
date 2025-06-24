# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:eb677f2d18459e6ac274e441ad6a7c932faafc79c2cd81efd10c1eeaa96ea4c0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1e8da8caa7cd3544aa2e5f3e447f99458ae44fc6a12b5bfe8b47c817367cb45e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
