# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bc6dd9d412ba16a0e7bb02db73b4773cf6b33702c60da52fb2a7decca04eb2fa as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1d131f75c981ff77135f9428abe54584a99b579398dfabba4d85998d0709fb1f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
