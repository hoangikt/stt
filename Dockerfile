# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:47455624f1081267acc700be45da753a3ac88b572465db5ba4d8d19b2e741684 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0d1fe818c0f946c68e87ed0967e5048c6736decf1f564dba850d371c70efd094

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
