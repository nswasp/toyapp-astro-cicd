# Multi-stage Dockerfile for Astro SSR
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --production=false
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund
EXPOSE 4321
ENV NODE_ENV=production
CMD ["node", "dist/server/entry.mjs"]
