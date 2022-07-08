FROM node:lts as dependencies
WORKDIR /my-app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /my-app
COPY . .
COPY --from=dependencies /my-app/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /my-app
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /my-app/public ./public
COPY --from=builder /my-app/.next ./.next
COPY --from=builder /my-app/node_modules ./node_modules
COPY --from=builder /my-app/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]