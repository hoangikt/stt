# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0666fa50e16e47197f762b925ee95eb19d0888416ada8774d34466abb2f7da69 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3b0a6aa280f6e2ef661798a4a6a0e9025ee38a3998b49e546ce37711ab1c91e9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
