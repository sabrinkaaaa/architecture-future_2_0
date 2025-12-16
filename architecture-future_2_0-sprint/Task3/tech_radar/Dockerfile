FROM node:23-alpine3.21

WORKDIR /app

COPY package*.json .

RUN npm install --omit=dev

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "serve"]
