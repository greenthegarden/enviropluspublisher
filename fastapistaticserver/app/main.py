# -*- coding: utf-8 -*-
"""FastAPI Static Server."""

# Based on https://fastapi.tiangolo.com/advanced/templates/
# https://medium.com/better-programming/migrate-from-flask-to-fastapi-smoothly-cc4c6c255397

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from typing import Any
import uvicorn

# initialization
app = FastAPI()

# mount static folder to serve static files
app.mount("/static", StaticFiles(directory="static"), name="static")


# serve webpage, GET method, return HTML
@app.get("/")
async def root(request: Request) -> Any:
    """Serve static webpage from root.

    Args:
        request (Request):

    Returns:
        Any: HTML page content from ./static/index.html
    """
    return FileResponse("./static/index.html", media_type="text/html")


# main
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=5000)
