FROM node:15.14.0-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY src ./

CMD ["node", "--trace-deprecation", "server.js"]