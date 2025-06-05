# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ba5153fcf45fff5eb44070fe1d9311cb94e8dc4f1aa850605578deb54aaade9a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:08e91d4a86cc9e39829b867b0722234a6440b8ff9faedda57e542f8bf8c2b0c5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
