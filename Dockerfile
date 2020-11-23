FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

LABEL maintainer="Philip Cutler <greenthegarden@gmail.com>"

# Update pip and install poetry
RUN python -m pip install --no-cache --upgrade pip poetry supervisor

# Copy dependency files using poetry.lock* in case it doesn't exist yet
COPY fastapistaticserver/pyproject.toml fastapistaticserver/poetry.lock* ./
RUN POETRY_VIRTUALENVS_CREATE=false poetry install --no-root --no-dev && \
  rm poetry.lock pyproject.toml

COPY fastapistaticserver/app /app

COPY enviropluspublisher/pyproject.toml enviropluspublisher/poetry.lock* ./
RUN POETRY_VIRTUALENVS_CREATE=false poetry install --no-root --no-dev && \
  rm poetry.lock pyproject.toml

COPY enviropluspublisher/enviropluspublisher /enviropluspublisher

COPY supervisord.conf /supervisord.conf
