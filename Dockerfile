FROM python:3.12.6

# Set up environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV TORCHINDUCTOR_FREEZING=1

# Create and set the working directory
WORKDIR /app
# Copy only the requirements file first to leverage Docker caching
COPY requirements.txt .
# mount th secret that will allow to connect to the artifactory registry 
#RUN --mount=type=secret,id=pip-index-url,env=PIP_INDEX_URL
# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Copy the entire application code
COPY . .
# Expose the port your application will run on
EXPOSE 5000
# Specify the command to run on container start
ENTRYPOINT [ "python" ]
CMD ["application.py" ]