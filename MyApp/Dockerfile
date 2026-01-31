# ========== Stage 1: Build Angular App ==========
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy rest of the project
COPY . .

# Build Angular (production)
RUN npm run build --configuration production


# ========== Stage 2: Serve with Nginx ==========
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Angular build output to Nginx HTML folder
COPY --from=build /app/dist/my-app /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]