# Base image: Python 3.13.2
FROM python:3.13.2

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install vim-tiny for editing files inside the container
RUN apt-get update && apt-get install -y vim-tiny && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the application files
COPY django /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Ensure database directory exists for persistent storage
RUN mkdir -p /app/db
RUN chmod -R 777 /app/db
# Give execute permissions to entrypoint script
RUN chmod +x /app/django-entrypoint.sh


# Set up the volume for database persistence
VOLUME /app/db

# Expose port 8000
#EXPOSE 8000


# Set the entrypoint script to run when the container starts
CMD ["/app/django-entrypoint.sh"]


