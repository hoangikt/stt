# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:51972266d431c2e69bfb25c38b8056d8cabebd4783b3d18d4d9235c713c7ff71 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4d6554b55830cb531e3b96d97916ce2a6bd68aea5b98585bfe9c799c518d9dc4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
