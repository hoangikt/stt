# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:083c912c707f1d61b9cc41097bacabfc6136aee979e7b570c479632e9e706b6f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fd728e07eea2a5ea9acef0050720485f2a9738cef52ec8931e18cf94ba12c7e2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
