FROM python:3.11-slim

# 1. Install system dependencies first
# We include xvfb and x11vnc for the virtual display
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    libnss3 \
    libnspr4 \
    libasound2 \
    libgbm1 \
    ca-certificates \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Install Playwright Browsers
# --with-deps here ensures any missed OS-level dependencies for Chromium are grabbed
RUN python -m playwright install chromium --with-deps

# 4. Setup Environment
ENV DISPLAY=:99
ENV PYTHONUNBUFFERED=1

COPY . .

# Ensure entrypoint is executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]


