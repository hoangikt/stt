# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d3f9afd3ed35bb30563318d6b2e3182f7e6f0a2ece4e16897b4eb9ffccc7bbeb as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:528fadcfbab064b4ad1e90c30850eb9042c11ff595322024517da095e7d1da4d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
