# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:784e9e8704ae00052110f9bab595f015c3a6ebdb4ebabcde02e791a8e9e48aed as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e439e0fc4504e7f3984833358bb59971f0874ad55c31b45cdf4751901f3402e8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
