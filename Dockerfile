# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0ba7c37037fc1669dd600e3e5348ab0774fc07e504c714cb14bde02708d3290a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0d5b9954eeb7a71c3305bf2c39bfab22ad795931d804e15eb6358c8b57e4dac8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
