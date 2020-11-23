#!/usr/bin/env bash

cd app

uvicorn main:app --reload --port 5000
