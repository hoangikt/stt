# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0a901d4eca5a4d2f4233d5d14606ca87fc95a04989850f4e280ba0798155c972 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:84bcee609619750752fcbd3e853709b210b8028df354f98b8dcf6538ce420e94

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
