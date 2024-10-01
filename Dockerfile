# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:570e7c248854d36acfc47758d0f72a844e26c06207750bb16243a21d86cc53e2 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d36f443087be26e55b2bf18ab624dd17c8968a637c6bde750f80dc0c4ce81860

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
