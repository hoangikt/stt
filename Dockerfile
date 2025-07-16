# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:be1b3d6016894d9275d10eb7cb688a0f7878c1c39d9d7a81c26d960948fd5cf7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:218df92adba38017a5faa371c2c524d19f4f1bcfc551ca8055820b866ec1ebf1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
