# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:76b93ba9466714276b0407aef4b464e3a9dfd3190f1d68ac0bed9e1bbe9b172d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5e7e242e9f587737df9864210c90810bbfb07a68d55ef8a2d314b8a3212fc10e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
