# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:645eb0d4d6aad8f87c63ea2c90e152354a7f36c34fc4b72a555bcb703bb79411 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:68aef1701ad7b295f463887b6b48c3b649639de599c6b159912d728f4149c872

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
