# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b7d7c6386055883f607b90063cd0fd14cc6cdf6681d02d79f5f71d151ab3ef33 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f05174c45fa717309a5d504a976c12690eccd650efeac5221d1d53b32ff41e71

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
