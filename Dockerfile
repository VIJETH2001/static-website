# Use an official Python image as the base
FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Git to clone the repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for the app inside the container
WORKDIR /app

# Define the repository and deployment details as build arguments
ARG REPO_URL="https://github.com/Tarun177/static-website.git"
ARG BRANCH="main"
ARG DEPLOY_DIR="/var/www/html/cafe"
ARG PORT=8081

# Step 1: Clone the GitHub repository
RUN git clone -b "$BRANCH" "$REPO_URL" /app/static-website

# Step 2: Deploy the website (copy the repo contents into the final deploy directory)
RUN mkdir -p "$DEPLOY_DIR" && \
    cp -r /app/static-website/* "$DEPLOY_DIR" && \
    chown -R www-data:www-data "$DEPLOY_DIR" && \
    chmod -R 755 "$DEPLOY_DIR"

# Expose the port that the Python HTTP server will use
EXPOSE 8081

# Step 3: Start the Python HTTP server to serve the static files
CMD ["python3", "-m", "http.server", "8081", "--directory", "/var/www/html/cafe"]
