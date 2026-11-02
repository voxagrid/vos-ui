FROM nginx:1.25-alpine
RUN apk add --no-cache tzdata curl wget
COPY ./dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
