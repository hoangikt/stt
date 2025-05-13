# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:568947a2b6dd940d18546a7c0364c0037b56828d04f99dda17c08cd67f8686f5 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ed6a2d722024f3cf86347f8cc6d2b95a9f1894c7ddb84caf97a4b253a0616e5b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
