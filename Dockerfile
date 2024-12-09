# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b8ab26fff67a85bf658ca9fe5ffefa8fe8543f69c66b76bf1c96a6a7fe566c53 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:befe3a041ad0a2cec97f1a62cedcf088babef3f3b0b79155e08af6f97aec45eb

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
