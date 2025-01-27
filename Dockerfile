# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:03e4584d7f79ad60d0be8b68d4b2b48134df1708d1a0c28f5ec3f6df5321c928 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:807a80038a7545f2780c50bbbf900bf8bea0e0d8a9e59d7af8e62e8b5fbcd319

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
