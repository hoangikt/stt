# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e9faad625d4ae1c8a6d8f402653f751aa9ca837146f34f956fce940ba31aad14 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:678db9554b6e1803adf77309a6e0ddee394ab0cf8d0b31f637bac385777bae56

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
