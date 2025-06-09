# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7afb09b5eb12528c36a8b1fc1bab2045a6218cade155dbc6cb936e9756e29c84 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5aa7ba42455f6367df5120bf1225add6310cbee6f112a474a80b971ea26a6928

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
