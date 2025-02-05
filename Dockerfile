# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9834f8ffd9a497df9dc62dd2a21075f4000985d65444686eca19ca2fd82dd6f0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:40b5c7ba23f16cb4d88081bfadf12912be667f8d50cb467b967cb85600d2daa3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
