# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b86f6c494852b9cd7f4fea35d43594e217d5e5c654e8ce30f40bcf57da3c7234 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:eecc25a11ece319b35025e65080b5a7423507a1a429e9a15e3f936af6845b7a4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
