# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5a34283cae520c1c413cc333a1865a673f4de28cc5b47cb57ac6db20403450d1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fa1f81a0bf96988a576e7f03078b8461d4af90e5585236f8a37e9bafaf81468d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
