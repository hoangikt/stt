# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:00776ae12928af25d95aa070402b7da978004ac0fea9273bade8f52ff1ba0c22 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3792747455b65ebfcb8e193d24617aeed067975a6e64fdb1c507ae482f305459

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
