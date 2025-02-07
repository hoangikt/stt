# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a19acee8f1e6ee27c9ee4e18cbd2388e2d2d31f7b631e1ad20e4f715f87d2322 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:de1dc38837ece938b6afe731a9c86bd197114e404db2df187d81ccd9c1fe3227

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
