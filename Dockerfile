# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7500c2ba49e1061f88901b77780cb40f54431c7958606c85ef2e04c9e3d22a9a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:52820d1718fe1263cb8459cf7db1b136bcdf4758ac7f6dff7599d309ebd3eaf8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
