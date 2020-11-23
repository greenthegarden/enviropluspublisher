#!/usr/bin/env bash

# Default values

BUILD_DOCS=false
BUILD_CODE=false

ASYNCAPI_FILE=asyncapi-min.yaml


# Process command line arguments
while getopts "cdf:" opt ; do
    case ${opt} in
        c ) # process option c
            BUILD_CODE=true
            ;;
        d ) # process option d
            BUILD_DOCS=true
            ;;
        f ) # process option f
            ASYNCAPI_FILE="${OPTARG}"
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            exit 1
            ;;
        \? ) echo "Usage: cmd [-c] [-d]"
            exit 1
            ;;
    esac
done


# Build documentation

if [ "${BUILD_DOCS}" = true ] ; then
    printf "Building docs from %s\n" "${ASYNCAPI_FILE}"

    ASYNCAPI_DOCS_DIR=fastapistaticserver/app/static

    if [[ -d "${ASYNCAPI_DOCS_DIR}" ]]; then
        mkdir -p "${ASYNCAPI_DOCS_DIR}"
    fi

    # Create documentation
    docker run --rm -it \
        -v "${PWD}/${ASYNCAPI_FILE}":/app/asyncapi.yml \
        -v "${PWD}/${ASYNCAPI_DOCS_DIR}":/app/output \
        asyncapi/generator:latest -o /app/output /app/asyncapi.yml \
        @asyncapi/html-template --force-write

    # Post process files if build was successful
    if [ $? -eq 0 ]; then
        sudo chown -R philip:philip "${PWD}/${ASYNCAPI_DOCS_DIR}"
        sed -i 's/css\//\/static\/css\//g' \
            "${PWD}/${ASYNCAPI_DOCS_DIR}/index.html"
        sed -i 's/js\//\/static\/js\//g' \
            "${PWD}/${ASYNCAPI_DOCS_DIR}/index.html"
    else
        exit 1
    fi
fi


# Build code

if [ "${BUILD_CODE}" = true ] ; then
    printf "Building code from %s\n" "${ASYNCAPI_FILE}"

    ASYNCAPI_TAG=0.53.1

    PYTHON_PROJ=enviropluspublisher

    if [[ ! -d "${PYTHON_PROJ}" ]]; then
        mkdir -p "${PYTHON_PROJ}"
    fi

    # Create python code
    docker run --rm -it \
        -v "${PWD}/${ASYNCAPI_FILE}":/app/asyncapi.yml \
        -v "${PWD}/${PYTHON_PROJ}":/app/output \
        "asyncapi/generator:${ASYNCAPI_TAG}" -o /app/output /app/asyncapi.yml @asyncapi/python-paho-template --force-write

    # Post process files if build was successful
    if [ $? -eq 0 ]; then
        sudo chown -R philip:philip "${PWD}/${PYTHON_PROJ}"
    else
        exit 1
    fi
fi
