# Use Node 20 LTS (Debian-based)
FROM node:lts

# Create app directory
WORKDIR /usr/src/app

# Download and install kepubify
RUN apt-get update && apt-get install -y wget && \
    wget https://github.com/pgaskin/kepubify/releases/download/v4.0.4/kepubify-linux-64bit && \
    mv kepubify-linux-64bit /usr/local/bin/kepubify && \
    chmod +x /usr/local/bin/kepubify && \
    rm -rf /var/lib/apt/lists/*

# Download and install kindlegen
RUN apt-get update && apt-get install -y tar wget && \
    wget https://github.com/zzet/fp-docker/raw/f2b41fb0af6bb903afd0e429d5487acc62cb9df8/kindlegen_linux_2.6_i386_v2_9.tar.gz && \
    echo "9828db5a2c8970d487ada2caa91a3b6403210d5d183a7e3849b1b206ff042296 kindlegen_linux_2.6_i386_v2_9.tar.gz" | sha256sum -c && \
    mkdir kindlegen && \
    tar xvf kindlegen_linux_2.6_i386_v2_9.tar.gz --directory kindlegen && \
    cp kindlegen/kindlegen /usr/local/bin/kindlegen && \
    chmod +x /usr/local/bin/kindlegen && \
    rm -rf kindlegen kindlegen_linux_2.6_i386_v2_9.tar.gz && \
    rm -rf /var/lib/apt/lists/*

# Install pipx and pdfCropMargins
RUN apt-get update && apt-get install -y python3-pip pipx && \
    pipx ensurepath && \
    pipx install pdfCropMargins && \
    rm -rf /var/lib/apt/lists/*

# Ensure pipx binaries are in PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy files needed by npm install
COPY package*.json ./

# Install app dependencies
RUN npm install --omit=dev

# Copy the rest of the app files (see .dockerignore)
COPY . ./

# Create uploads directory if it doesn't exist
RUN mkdir -p uploads

# Expose app port
EXPOSE 3019

# Start the app
CMD [ "npm", "start" ]
