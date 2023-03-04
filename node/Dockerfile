FROM node:lts-alpine

# App must run on port 8000
EXPOSE 8000
# Add your instructions to dockerize the application
WORKDIR /app

#CACHE docker-entrypoint
COPY ./docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#CACHE NPM INSTALL
COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json
RUN npm install --omit=dev

# COPY SOURCE
COPY . .

ENTRYPOINT [ "docker-entrypoint.sh" ]
