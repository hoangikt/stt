# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e73c8bd31b26c2729ecea6baddbec03c80a49fa7b4a04cbe5e96ffbe64f0b273 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:efb835dda221cc69f2730a9f48ada139a505a9ce54c40f1637177d775f3ca5b9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
