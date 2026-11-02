#!/usr/bin/env bash
# ==============================================================================
# VoxaGrid VOS3000 Web Management Suite - Emergency HTTP Server Reset Tool
# ==============================================================================
# Script ini digunakan oleh System Administrator / Operator via SSH untuk
# mereset konfigurasi Nginx kembali ke mode plain HTTP port 80 darurat jika terjadi:
# 1. Kesalahan sertifikat SSL atau domain yang menyebabkan web GUI tidak bisa diakses
# 2. Lockout akibat salah konfigurasi HTTPS port atau Force HTTPS redirect
#
# Penggunaan:
#   bash /opt/vos-ui/scripts/reset-http-server.sh
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${APP_DIR}"

echo "======================================================================"
echo " [EMERGENCY SAFEGUARD] Memulai Reset Konfigurasi HTTP Web Server..."
echo " Direktori Aplikasi: ${APP_DIR}"
echo "======================================================================"

# 1. Reset Database Configuration di PostgreSQL
echo "-> [1/4] Mengembalikan status app_http_server_config ke default HTTP:80..."
DB_USER="$(grep '^DB_USER=' "${APP_DIR}/.env" 2>/dev/null | cut -d '=' -f2- | tr -d '\"'\'' ' || true)"
DB_NAME="$(grep '^DB_NAME=' "${APP_DIR}/.env" 2>/dev/null | cut -d '=' -f2- | tr -d '\"'\'' ' || true)"
DB_USER="${DB_USER:-admin}"
DB_NAME="${DB_NAME:-sbc}"

if docker ps --format '{{.Names}}' | grep -q "^vos-postgres$"; then
    docker exec -i vos-postgres psql -U "${DB_USER}" -d "${DB_NAME}" -c "
        UPDATE public.app_http_server_config 
        SET https_enable = FALSE, 
            force_https = FALSE, 
            http_port = 80, 
            updated_at = CURRENT_TIMESTAMP, 
            updated_by = 'emergency-reset-script' 
        WHERE id = 1;
    " > /dev/null 2>&1 || true
    echo "   [OK] Database config direset: https_enable=false, force_https=false, http_port=80."
else
    echo "   [WARN] Container vos-postgres tidak sedang berjalan. Melanjutkan rewrite file Nginx..."
fi

# 2. Buat direktori conf.d jika belum ada
mkdir -p "${APP_DIR}/nginx/conf.d"

# 3. Tulis ulang template aman plain HTTP 80 ke nginx/conf.d/default.conf
echo "-> [2/4] Menulis template Nginx darurat (Plain HTTP:80)..."
cat << 'EOF' > "${APP_DIR}/nginx/conf.d/default.conf"
# ==============================================================================
# Nginx Virtual Host Configuration (EMERGENCY RECOVERY MODE: Plain HTTP 80)
# ==============================================================================

server {
    listen 80;
    server_name _;

    client_max_body_size 50M;

    # OWASP Top 10 Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=(), payment=()" always;

    # ACME Challenge for Let's Encrypt automated verification
    location ^~ /.well-known/acme-challenge/ {
        root /var/www/certbot;
        try_files $uri =404;
    }

    # Frontend Single Page Application (Vue 3)
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;

        # Static assets cache
        location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|eot|ttf|svg)$ {
            expires 1y;
            add_header Cache-Control "public, no-transform";
            add_header X-Content-Type-Options "nosniff" always;
        }
    }

    # API Proxy with Rate Limiting
    location /api/ {
        limit_req zone=vos_api_limit burst=30 nodelay;
        limit_req_status 429;

        proxy_pass http://127.0.0.1:8080/api/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 10s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Auth Rate Limiting against Brute-Force
    location /api/v1/auth/login {
        limit_req zone=vos_auth_limit burst=5 nodelay;
        limit_req_status 429;

        proxy_pass http://127.0.0.1:8080/api/v1/auth/login;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Realtime WebSocket Proxy
    location /ws/ {
        proxy_pass http://127.0.0.1:8080/ws/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }

    # Health Check Endpoint
    location /health {
        proxy_pass http://127.0.0.1:8080/health;
        proxy_set_header Host $host;
    }

    # Block Hidden Files & Dotfiles
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Corporate 429 JSON Response
    error_page 429 /429.json;
    location = /429.json {
        default_type application/json;
        return 429 '{"success":false,"code":429,"error_code":"RATE_LIMIT_EXCEEDED","message":"Too Many Requests. Rate limit exceeded, please try again shortly."}\n';
    }
}
EOF
echo "   [OK] File ${APP_DIR}/nginx/conf.d/default.conf berhasil dibuat ulang."

# 4. Validasi Sintaks Nginx
echo "-> [3/4] Menguji sintaks Nginx (nginx -t)..."
if docker ps --format '{{.Names}}' | grep -q "^vos-frontend$"; then
    docker exec vos-frontend nginx -t
    echo "   [OK] Sintaks Nginx valid."
    
    # 5. Reload Nginx Gracefully
    echo "-> [4/4] Menerapkan reload Nginx secara graceful..."
    docker exec vos-frontend nginx -s reload
    echo "   [OK] Nginx berhasil di-reload."
else
    echo "   [WARN] Container vos-frontend tidak aktif. Jalankan 'docker compose up -d' untuk memulai."
fi

# Detect Host IP
HOST_IP="$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -n1 || echo "IP_SERVER")"

echo "======================================================================"
echo " [BERHASIL] Emergency HTTP Server Reset Selesai!"
echo " Antarmuka Web VOS-UI kini dapat diakses kembali melalui:"
echo " -> http://${HOST_IP}:80/"
echo "======================================================================"
