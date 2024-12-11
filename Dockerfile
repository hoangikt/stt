# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cf09a89b435b8b9776022c04fc2a05eeed17a8b3ede1f5810412f5229126c08c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a2fc83d0c025dd354c826af42f8a88471372d35de19b88aeb2fd1a041d89a6a4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
