FROM nginx:1.23.3-alpine
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p certificates
COPY ./certificates /certificates
COPY ./public /public
