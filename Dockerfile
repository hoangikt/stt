# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:512e56156955532ad952d1c8809c8b6d4caa444fa5796d64cfead7bf3928abfe as builder

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
