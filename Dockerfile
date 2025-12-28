# Root Dockerfile for CI builders that expect a Dockerfile at repository root.
# This builds the backend service so automated builders without docker-compose succeed.

FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Copy backend package and lockfile
COPY backend/package.json ./package.json
COPY backend/yarn.lock ./yarn.lock

# Install dependencies using yarn (backend uses yarn)
RUN yarn install --frozen-lockfile

# Copy backend source files and build config
COPY backend/src ./src
COPY backend/tsconfig.json ./tsconfig.json

# Build the backend
RUN yarn build

# Install process manager and copy process config
RUN yarn global add pm2
COPY backend/docker/processes.config.js ./processes.config.js

RUN mkdir -p log && touch log/.keep

EXPOSE 8080
CMD [ "pm2-runtime", "./processes.config.js" ]
