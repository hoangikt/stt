# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cd0e098eca23dd3bb9b5f40615b0dcdc88f9aacfcf36752e0a92d1d23f6472c3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b9328fd1f02d7836c7a75b0423ea9b0098e1cc10f6d3b9398bac5ebb4410f316

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
