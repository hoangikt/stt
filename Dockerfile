# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1e7504bdd6ef32989a7014b37ef2e8262c4d74feab017dc1da0a25b7d198e149 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5e1aa298ad3f50f105b9121b1d3a39bdbe33e17a5a28555a1d12a7c91529fc15

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
