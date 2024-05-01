# Build stage
FROM node:14-alpine as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:14-alpine
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD node dist/healthcheck.js
EXPOSE 3000
CMD ["node", "dist/index.js"]