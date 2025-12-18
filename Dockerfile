FROM nginx:alpine

# Clean the default directory
RUN rm -rf /usr/share/nginx/html/*

# Copy from the 'browser' subfolder specifically
COPY --from=build /app/dist/student-management-front/browser /usr/share/nginx/html

# Important: Add this config to handle Angular Routing (deep linking)
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