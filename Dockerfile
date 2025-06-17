# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cacf65cb67d586dc10c8631d9f2c3fab17b110ca6073d7e71968602b095f9110 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:93fcf61f278621f8c9bf56a0a54bc41309444ef67b8fc7f27bc9bfd860013585

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
