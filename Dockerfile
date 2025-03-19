# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:69fb65b317048024e5749fcd292a847d207dc0963ca0916be7333e2c513da39a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2abc89970a8732fcc8f4a5011705a0e823c12c80f4e00e3d322b7c09145a016d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
