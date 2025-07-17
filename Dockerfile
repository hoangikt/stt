# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e8310675bf84a4592ce7a8c1cb420d933a369b0fd15c9b47f94941301a78797c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8dd870e92bb2a4d4d9d654af902171ea73c10a9f646f18a264807e6788830835

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
