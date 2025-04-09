# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9a07910eabb5768e1254737380b0053a304cb7dd5143938129a7318bc244c143 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ae85bc17424cbf379920683c7d8db82612bf78521372bc81b26d8a5a89418aa

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
