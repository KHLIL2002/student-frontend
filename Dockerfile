# STAGE 1: Build (The 'AS build' here is MANDATORY)
FROM node:20-alpine AS build
WORKDIR /app

# 1. Install dependencies
COPY package*.json ./
RUN npm install

# 2. Build the application
COPY . .
RUN npm run build -- --configuration production

# STAGE 2: Serve with Nginx
FROM nginx:alpine

# 3. Clean default files
RUN rm -rf /usr/share/nginx/html/*

# 4. Copy build output (Note the /browser folder)
COPY --from=build /app/dist/student-management-front/browser /usr/share/nginx/html

# 5. Add custom config to handle Angular routes and prevent 404s
RUN printf 'server {\n\
    listen 80;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html index.htm;\n\
        try_files $uri $uri/ /index.html =404;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]