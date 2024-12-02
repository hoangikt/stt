# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f1826309fe5ce4453460670aae62cb3673423f9454c7b5bab9a58abfacf693a9 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9f93210d15a82eed4a4167817871ee7f1adf901256aba4bfdebc51bda96e0668

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
