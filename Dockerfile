# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d1142f4047abd80526fa4917faf4b570f1a1959f77a073388e4b04f4af2a4c0e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b4d22085870a58cb7c55328c108ca5b53ba89d438ce1709f958d8ac98b6cf5f0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
