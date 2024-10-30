# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:352d74d1373b540e0dcbdc0b293c2f0d64ef6a0b78ad93a31a85647da287efcc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bb5aced663cb78557d153075d6e9ccc7be461502a729d7cf1ed7a36cc3d42f18

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
