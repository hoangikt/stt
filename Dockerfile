# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ebc0a0590256a939ff57d18a78e1d69ee156ea5745ec366110ab4d1e332b34dd as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:71dbbc42e33f405d403df86bc6d6c79d9054b190b11c2a7909086e4906118a62

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
