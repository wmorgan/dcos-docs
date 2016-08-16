FROM node:6.4.0-slim

RUN apt-get update && apt-get install -y \
    git \
    python \
    build-essential \
    rsync \
    inotify-tools \
 && rm -rf /var/lib/apt/lists/*
