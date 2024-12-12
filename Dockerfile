# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:912ce75048fac19785891f3ab53f4ccd3ac714d920aaf6e5f8919bb25e109126 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2d14d0505ffe2d03b1cef2675dec60b3d1da3576732a127249058655cecf64dc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
