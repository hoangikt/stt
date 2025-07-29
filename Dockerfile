# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:03d012ce7ed5018f61b952f0306e041cdea211ce3bf96ae6c0e748affd1393ea as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2fa2e1d5396c78a166f4efa26d1661d89629d897d6c71a00c53d951427d2e8c0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
