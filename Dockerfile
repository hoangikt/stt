# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d3555b64f34dac1ad6cf72dad87fb756dc43dc3f395b8e762bc69648a74885cb as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fb78813b39c4d8f5caf3acfe5d048f366b9708920eadb5ba768e1b0ace31560b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
