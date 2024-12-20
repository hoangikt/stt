# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9b55ebf49d114350bbbdd579fdad5dd9ff1a35416d8a4100b9b3995330e7adee as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fad17edd9fe58769045cf15229984b3cbcf7516112ae9140fba087d4a76630d3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
