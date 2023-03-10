# Use an official Node.js runtime as a parent image
FROM node:16.19.1-alpine 

WORKDIR /app

COPY ./src/ ./src
COPY ./package* ./

RUN npm ci

# Expose port 8089
EXPOSE 8089

# Start the server when the container launches
CMD ["npm", "run", "start"]