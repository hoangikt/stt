# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b8010c3edc86e4e473f83d912f9fc78d1f3efc2dcb984152fe8d31d908f7a25c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:84f5d749d6388e677919fd4bf3d40686e34a62453eb602b2f343b8074a1cbb78

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
