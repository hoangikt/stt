# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e957d47693d3a9cc23ce7438f287d8332301b1adad0312d258529c5e3abfda68 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:653ad741c10082637dcb1b07146bafd807548ad7bd1e89cdc01ccac057a9f7ca

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
