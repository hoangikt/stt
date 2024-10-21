# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c7b985fed6442b5cc9b2f97364b7e824c7fd279051dfd9989ebb63c1b3029751 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c73e2dcefb8e97860ab0c0b374758df9b4938f023b56a1298526a645f6e6be51

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
