# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d0bc0282661c24b71a2b552390e4684d1aad454e4bb70c17badd50032e519f87 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:eb676f7c8a373d47d13ca954a718e8860eb53ac3cd4fb9be7f18c683d4339924

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
