FROM python:3.12.6

# Set up environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TORCHINDUCTOR_FREEZING=1

# Create and set the working directory
WORKDIR /app
# Copy only the requirements file first to leverage Docker caching
COPY requirements.txt .
# Mount th secret that will allow to connect to the artifactory registry, and expose it as an 
#environment variable only for this line of the dockerfile 
# Install dependencies with pip, that will use our private registry
RUN --mount=type=secret,id=pip-index-url \
    export PIP_INDEX_URL=$(cat /run/secrets/pip-index-url) && \ 
    pip install Flask request transformers[torch]
# Copy the entire application code
COPY . .
# Expose the port your application will run on
EXPOSE 5000
# Specify the command to run on container start
ENTRYPOINT [ "python" ]
CMD ["application.py" ]