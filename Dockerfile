# syntax=docker/dockerfile:1

# ---- Builder ----
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# ---- Runtime ----
FROM node:20-alpine AS runtime

ENV NODE_ENV=production
WORKDIR /app

# Install only production deps
COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
	&& mkdir -p logs

# Copy built app
COPY --from=builder /app/dist ./dist

# Default port
ENV port=3000
EXPOSE 3000

# Healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://127.0.0.1:${port} || exit 1

# Run the server
CMD ["node", "dist/app.js"]
