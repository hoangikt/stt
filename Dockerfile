# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7805dfaa784da1919f3479c497d03f4e6d6b2c5bf28a8968edf679b08a29c32c as builder

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
