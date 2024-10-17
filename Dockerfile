# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a8b3d3b06b317ee028e572617440f0ef177141862d128f6632691a170c4dd9c6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:396753727a726e5bec91a16eeb239e2959320f79bdf9c33bdd4eba876d4d3c86

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
