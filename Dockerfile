# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a287c47b92f41107e07d825738607d6cdd7a85121e5bffc917303815724d4dfc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6543611b772e428f9506542b16ec58ac085b28ac849b1d40737f9da23ce5f4e1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
