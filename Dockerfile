FROM node

COPY package.json package.json
RUN npm install
COPY package-lock.json package-lock.json

COPY index.js index.js

ENTRYPOINT ["node", "index.js"]

