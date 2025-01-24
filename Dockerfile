# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1d2375eb154e22ae32adbd620f1a36443e468e2124d2c58efaa307af969fd555 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:578490b43157f444bcdab2f444a4727917a3515987e49b1c350dd2152dfec4c1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
