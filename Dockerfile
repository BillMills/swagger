FROM node:16.8.0
COPY node /app
WORKDIR /app
CMD npm start
