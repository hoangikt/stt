# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7dcb95346634efbbf666c4608dd152e195e5e5b82ef7c6d937342aa1c7ca9388 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:666459b40c3a531a9a55d29ace7943a05fbb8b074e880a9b09a6039bcaaddcef

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
