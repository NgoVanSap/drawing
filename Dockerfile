# Sử dụng ảnh node.js làm cơ sở
# FROM node:14 as build-stage
FROM node as build-stage

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Sao chép mã nguồn của ứng dụng vào container
COPY . .

# Cài đặt các gói phụ thuộc
RUN npm install

# Build ứng dụng Vue.js
RUN npm run build

# Ứng dụng web server cho ứng dụng Vue.js
FROM nginx:alpine as production-stage

# Sao chép tệp build của Vue.js từ build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Cấu hình cổng mà Nginx lắng nghe
EXPOSE 80

# Khởi chạy Nginx
CMD ["nginx", "-g", "daemon off;"]

# Build docker image: docker build -t manager_draw_vue_app .
# Run docker container: docker run -d --name docker_manager_draw_vue_app -p 9000:80 manager_draw_vue_app
# Run docker container: docker run -d --name docker_manager_draw_vue_app -p 80:80 manager_draw_vue_app