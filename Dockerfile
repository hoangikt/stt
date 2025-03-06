# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:496738ae51d16cd9142cf150254cbaf7304bc83384b2a8ab9f1a20cc464dc0ae as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ac23585412b5fdb4867e6495c05857a7982374439f6cfffaf9887dded55536a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
