FROM node:current-alpine3.17 AS builder

WORKDIR /builder

COPY package.json ./

RUN npm install
RUN npx prisma generate

COPY . .

# RUN npm run build

FROM node:current-alpine3.17 AS development

WORKDIR /YOUR-APP-NAME

COPY --from=builder /builder .


EXPOSE 3000
EXPOSE 49153

ENV PORT=3000

RUN npx prisma generate

CMD ["npm", "run", "dev:migrate"]

FROM node:current-alpine3.17 AS production

WORKDIR /YOUR-APP-NAME-prod

COPY --from=builder /builder .

RUN npm install --only=production

EXPOSE 3000

ENV PORT=3000

RUN npx prisma generate

CMD ["npm", "run", "start"]

