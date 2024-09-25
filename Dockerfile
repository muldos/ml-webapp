FROM python:3.12.6 as backend-build

# Set up environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TORCHINDUCTOR_FREEZING=1

# Create and set the working directory
WORKDIR /app
# Copy the entire application code
COPY requirements.txt *.py ./
COPY templates ./templates
# Mount th secret that will allow to connect to the artifactory registry, and expose it as an 
#environment variable only for this line of the dockerfile 
# Install dependencies with pip, that will use our private registry
RUN --mount=type=secret,id=pip-index-url \
    export PIP_INDEX_URL=$(cat /run/secrets/pip-index-url) && \ 
    pip install -v --no-cache-dir -r requirements.txt
#pre-load hf model from artifactory
RUN --mount=type=secret,id=HF_ENDPOINT \
    --mount=type=secret,id=HF_TOKEN \
    export HF_ENDPOINT=$(cat /run/secrets/HF_ENDPOINT) && \ 
    export HF_TOKEN=$(cat /run/secrets/HF_TOKEN) && \ 
    python preload-hf-model.py


FROM python:3.12.6 
# Set up environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TORCHINDUCTOR_FREEZING=1

WORKDIR /app

# Copy the installed dependencies from the previous stage
COPY --from=backend-build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Copy the application source code from the previous stage
COPY --from=backend-build /app /app
# Expose the port your application will run on
EXPOSE 5000
# Specify the command to run on container start
ENTRYPOINT [ "python" ]
CMD ["application.py" ]