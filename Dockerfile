# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:339c79f7f3f664f5a1446a77ef90bebe48b2e2024467cf3277792a8d36150f1e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:62d8d564561e3f0680f4246677a7b790620f498119657f859dedd0d2348fae0b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
