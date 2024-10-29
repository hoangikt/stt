# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6e0d1b38cea9fa271a817d35fe836402249681a34b1bb82c007abffa6975c468 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c227171043105c2778349aac2b90ebfea60a85a95b77f2df716bdf56515a3d48

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
