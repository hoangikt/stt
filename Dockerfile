# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:8442919b64ed879e2fde0dcbf935d70a6402c45d75c44364bfdd0c98e4666b5e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2fc6f46589ffc4eaffdde315ddd9e76f7da9255eb117349023d8e4507a558770

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
