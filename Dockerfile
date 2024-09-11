# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:779a791e0569d06c03785d0d130b072aa2bad10e38bbc4203a2923ab2bcef2b0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f7b840c6b5b3144359e7801ad00ecb5483acd7d6957aaf34b4ecdcaed3532c52

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
