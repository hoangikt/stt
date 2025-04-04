# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:00396799cece46e38788a4935a7647f7e9233d929f363c0275b6743677cd3680 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fb3e7d0de3245e05df3b16aefd6a0bb250a708201d4fce60f7de17a40121d26f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
