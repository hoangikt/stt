# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:01dd535bfe0e5be9ab3ab49f25c60c94505db9175e15a3108fc6ff243f65ab4a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:191d13a12981ab476bafcc311aafea78d26948db0c26c22c1b35ff072d5e0ab4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
