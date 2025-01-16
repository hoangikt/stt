# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:04ef4c6c16d25cfd581eab1dbc20631b60573b2acd7c752e93dce9c6bb662879 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d1fb6ae5c70de53b0aa232d7dd083cc46978e12b5f20510a1ab03ae5b660d9e1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
