# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:71271354480c32cb2adcbc8548d075a13a592bb6704da34ef79f4b5c40ae0b39 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7efa3128e165b02b4ca81c87851218603b7788bd217d4d9b31e3cc66105e9288

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
