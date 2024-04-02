# Node version
ARG NODE_VERSION=12.18.1

# Using node base image
FROM node:$NODE_VERSION

# Use non-root user
USER node

# Set working dir
WORKDIR /app

# Copy src code to app dir
COPY --chown=node:node . .

# Install app dependencies
RUN npm install

# Port exposed
EXPOSE 3000

# Start node app
CMD ["node", "server.js"]
