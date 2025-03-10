# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9bf10af912a9203b9f788f17c6b6f98676a91df9b02d0b26109ac139faea7896 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:73d6dc810155cb01bdc69ff9074cb31010b1cc4926ff1cf28ffdac2fc04a2c12

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
