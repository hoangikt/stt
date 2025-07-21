# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9d2be9b96ad17eda14e653708e4948ebd61dd57b65bd07ba1d6dcbfd3e49a1a0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:533dfd470b306239285e33c08305b0f4c8a8841edde49e05e6bd567c5424d8fe

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
