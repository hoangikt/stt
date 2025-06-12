# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0b0ba7c35c5d02663238ea96543eca76fec83d82ee663fef4cf7e62685c3041d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3dbdfe5d705096a1d18df13b4a055f85862440e37b93876f1ed3e2b2abad6739

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
