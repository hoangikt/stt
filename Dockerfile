# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d583c8203a456b7e016c61a5ecaf9d1f8153a1cba561e438edb5a1a1495ce031 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e7dc21120d9df2ad36b5b25bcf307ce62e7168810a82c7773cca5c9495339c8a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
