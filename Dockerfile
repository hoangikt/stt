# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2a94e33cfa90eb3b6753453129356e08065413676f8a5f64181fe4818c50d6c1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:90754693c030f39d0619cdf97971dcae0c94a23b4e354e8fae8cb1d6d746afa5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
