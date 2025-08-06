# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b75d0c87f3a7ffe86ab330009d78a3d2d1c7f1b5cd784bdf8429ff9882192622 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b4e613576560761bdc76b3692e8020e1e44303a56048368d8f4f98bb16d245bf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
