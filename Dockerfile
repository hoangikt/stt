# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:51693823bf4fd7bcbf56fee2c9d100b263503258019f723288f796f1fdb5947f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5e9c360bf22db15b87f7c41ec123564ac044a167e9feb9ebce67c562f07bb007

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
