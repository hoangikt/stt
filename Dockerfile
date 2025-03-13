# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b2a43e091b7c81ac79dec710254970fffc52a091ae060083e35daeb46e612ac3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ac069eca3ddab59f2971d3220e124f3389fb0abefe7eb2624038d1e5e47bbc62

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
