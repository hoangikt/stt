# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:251bebc53d005d78dddb22dee13fea68a86a5246bf65ade877f0529b78e2f14a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0e8989f79bc33e6219661e165fd343e281a21a8e94457ddb07af446860c9baa0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
