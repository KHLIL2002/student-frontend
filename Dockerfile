FROM node:20-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build -- --configuration production

FROM nginx:alpine
# ATTENTION: Vérifie dans angular.json le "outputPath". 
# Par défaut c'est dist/student-management-front
COPY --from=build /app/dist/student-management-front /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]