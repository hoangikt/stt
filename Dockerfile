# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c5e406eb35c03bcb54120d4f33b5985d4294384d2c0e78b1baad38235ecaf447 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:08c3327089fd3654746519c0eaa762e3bc52c6ed8f50f908821756b8a1221056

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
