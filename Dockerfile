# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1b66369f2985c906d1713152da2d68f6752dbf46cef97304d00224d8c1e380ff as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7104953a948fcdfcc1305a4140d65e3be95846b109f1fee9c4f8988e215632bc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
