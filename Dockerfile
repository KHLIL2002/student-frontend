# ... (rest of your build stages) ...

FROM nginx:alpine
# 1. Remove the default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# 2. Copy the CONTENTS of your build folder (note the / at the end or the /*)
COPY --from=build /app/dist/student-management-front /usr/share/nginx/html

# 3. Optional: If you use Angular Routing, you need a custom nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]