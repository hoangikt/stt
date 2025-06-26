# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ec4d7d778f4b3d535102e680ba343608e708bd08ec2cdff3b7fd909e8c38e5b1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:36f63157191eb52f3296e149e009b6e5a989f5fa03a2e307728545e3cc46fcf0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
