# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d9e1598a9f44205d4182c0c54196f7dd6e73ac8cf15cf57ab063ac431b84b5f8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f488e4481f27bb0e2c312a4e2e0383b7ddbc62dd03290ef7a5e9459fde32447b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
