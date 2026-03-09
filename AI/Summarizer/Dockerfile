# -- BUILD STAGE ---
FROM python:3.10-slim

ARG HF_TOKEN
ARG HF_MODEL
ARG HF_API

# Create a group and non-root user
RUN addgroup --gid 1234 flask && adduser --gid 1234 --uid 1234 --home /home/flask --disabled-password flask
RUN mkdir -p /home/flask && chown -R flask:flask /home/flask

# Change user
USER flask:flask
WORKDIR /home/flask

# Copy files, active virtual env and download dependencies
COPY requirements.txt .
COPY main.py .

RUN python3 -m venv .venv
ENV PATH="/home/flask/.venv/bin:$PATH"

RUN pip install -r requirements.txt

ENV HF_TOKEN=${HF_TOKEN}
ENV HF_MODEL=${HF_MODEL}
ENV HF_API=${HF_API}

# --- WSGI ---
RUN pip install gunicorn==25.1.0

EXPOSE 8000

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "main:app"]
