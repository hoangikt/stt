# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:07f7e8e7d95c997a29394b2bf4bcddc4b538191327d21931fecb36972e555872 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f67a0761e8c0af5b4fd7c94d7834b8d759815f283a00dd29ccaca6cd7089d39c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
