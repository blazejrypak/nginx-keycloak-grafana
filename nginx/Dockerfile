FROM nginx:1.21.6

RUN apt update && \
    apt install libnss3-tools curl -y && \
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
    chmod +x mkcert-v*-linux-amd64 && \
    cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert

RUN mkcert -install

RUN mkcert -key-file /etc/ssl/private/key.pem -cert-file /etc/ssl/certs/cert.pem localhost

# COPY nginx.conf /etc/nginx/nginx.conf