# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:622986ddd1689be97faffb0bed9dd3264d03ba76aedad61056ddb4d44c8045cd as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e5691d84c8404df61a1da30a5ab994e31c2d852f45ae4e12eb5fbf2edebfc37b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
