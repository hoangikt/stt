# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a07274cf8c42ca856be7e28b123b19e68ee63c0d15b54ead2d16f713c2a2f243 as builder

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
