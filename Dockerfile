# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bb0e5e122bfb721609f9774bd717f6265e080a4ff3b6b55f644f412b3c0bfe50 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a3894f8ed4e65e21ed1bb423b054c4564b09c92c13835bcbd37d229d5efc9d7d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
