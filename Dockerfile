# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3d576a0d94b05c0da7fba83c8dbf1d909a61a95132d3f65b409b3eb01bf18633 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5de85837816e630c79597cb0934c352469fe5c2b8e7871da583cec3ef9ec4f43

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
