# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5d964e2b42d231e78beba4ab87146e7f10b4d93f5c1e29ac4a1b430decfe954b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d100c2fc9b03eec266ff76e8f9bcda304ae10c3cb9a5b5bb5739cae5584fe4ed

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
