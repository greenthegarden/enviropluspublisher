FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

LABEL maintainer="Philip Cutler <greenthegarden@gmail.com>"

# Update pip and install poetry
RUN python -m pip install --no-cache --upgrade pip poetry supervisor

ARG PORT
ENV PORT ${PORT}

# using information from https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid ${GROUP_ID} user
RUN adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} user

RUN chown -R ${USER_ID}:${GROUP_ID} /app /start.sh /start-reload.sh /gunicorn_conf.py

USER user

# Copy dependency files using poetry.lock* in case it doesn't exist yet
COPY --chown=${USER_ID}:${GROUP_ID} fastapistaticserver/pyproject.toml fastapistaticserver/poetry.lock* ./
RUN POETRY_VIRTUALENVS_CREATE=false poetry install --no-root --no-dev && \
  rm poetry.lock pyproject.toml

COPY --chown=${USER_ID}:${GROUP_ID} fastapistaticserver/app /app

COPY --chown=${USER_ID}:${GROUP_ID} enviropluspublisher/pyproject.toml enviropluspublisher/poetry.lock* ./
RUN POETRY_VIRTUALENVS_CREATE=false poetry install --no-root --no-dev && \
  rm poetry.lock pyproject.toml

COPY --chown=${USER_ID}:${GROUP_ID} enviropluspublisher/enviropluspublisher /enviropluspublisher

COPY --chown=${USER_ID}:${GROUP_ID} supervisord.conf /supervisord.conf

# COPY --chown=${USER_ID}:${GROUP_ID} start.sh /start.sh

RUN sed 's/os.getenv("PORT", "80")/os.getenv("PORT", "8080")/' /gunicorn_conf.py > /app/gunicorn_conf.py

CMD ["/usr/local/bin/supervisord", "-c",  "/supervisord.conf"]
