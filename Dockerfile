# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ad26c1543e1348597b9030d2b320f61127e137f30710c795d82e93791534a018 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0a32c558cb68f9743a0492377c84c6d838d52b08cabfca962a17fce3d0ef02aa

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
