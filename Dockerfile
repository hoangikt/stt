# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:49a37f101ac0949a3a5dd5ca94bb93de9637aa001e2218ad51cad21062e01207 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f849a6e62a8f2d7d2a0231949fb92a5e70765ad3adb585410a3497b691d77e7b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
