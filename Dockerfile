# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4cd06b43fca46f24925373e09356ab6028005a0225a54c6e4867921289477cc0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:92c3483c8ac7eda088e51952b744cce1f3087fe7560a5da672d918b7c57a65fc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
