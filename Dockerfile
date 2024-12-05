# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ef2d25e44389622761fa5a6ecd1c8be168e6ede22bcad4f13b603b5360a80128 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6a558e87748efe40413345e149e70906a32a3f9d180e128d7f9071debfac2461

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
