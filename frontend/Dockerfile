FROM node:18 as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npx react-scripts build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
