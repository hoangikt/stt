# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3adc324ec3a261daf0bf4c74f8d2cfa97b472f8af6a740b2e2607bb9275a62ca as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:66418898f7988b578e7fc785768757541b5c3ba78202faf135fda92a81b298a2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
