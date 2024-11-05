# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7d78e97bd1bf71a44166eeec161ffa14df56ab8f22c75b6f8aad0439d23a650f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a6e6f139e1f3ec9238bce5ec72d9edfbfc2bec727d34263007d2df49708c96e5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
