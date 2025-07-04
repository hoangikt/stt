# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3ed6be59514f93cedfbcc145f8b8ca499d026230394bfb76535147f8256fd471 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3f7e24839e1831eb79f694227d31ec2a2f77c917a883948d3149cc41c85ef5ce

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
