# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:255af1bad580e902ae0cf634cee6cdb83fbd7047513b11a7595dfc98c8422e5c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bb4f22b100e31fc42451710ac2ccafe198c3d2d5bb17a309033a782f5c8685ea

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
