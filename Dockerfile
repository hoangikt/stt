# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:037cc7a0b833510c4b7c8dede3857f08f0e13e6a5552987c1b66c147be38b035 as builder

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
