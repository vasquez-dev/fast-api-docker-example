FROM python:alpine3.8

WORKDIR /app

ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    POETRY_VERSION=1.0.5

# Deps required ony for the build
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make

# Deps required in the final Image
RUN apk add \
    libffi-dev
    
# Install Poetry
RUN pip install --upgrade pip==19.2.2 \
    && pip install "poetry==$POETRY_VERSION"

#Install Python package dependencies
COPY poetry.lock poetry.toml pyproject.toml ./
RUN poetry install

RUN apk del --no-cache .build-deps

COPY ./app /app