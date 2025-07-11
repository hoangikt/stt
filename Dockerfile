# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:50c95e552d7a74f678005fd0d579e4f7fe71c8f371ffe61a651a4648d1da38a7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:191d13a12981ab476bafcc311aafea78d26948db0c26c22c1b35ff072d5e0ab4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
