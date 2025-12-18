# STAGE 1: Build (The "AS build" is the important part!)
FROM node:20-alpine AS build
WORKDIR /app

# Copy dependency files
COPY package*.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build -- --configuration production

# STAGE 2: Serve with Nginx
FROM nginx:alpine

# 1. Clean the default nginx directory
RUN rm -rf /usr/share/nginx/html/*

# 2. Copy the build output from the 'build' stage
# Make sure "student-management-front" matches the folder name in your dist folder
COPY --from=build /app/dist/student-management-front /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]