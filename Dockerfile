# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:58864372c172ebf84f42244281c4bed2f9cdc98451b6f55839bea35db2f56ec0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fb3e7d0de3245e05df3b16aefd6a0bb250a708201d4fce60f7de17a40121d26f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
