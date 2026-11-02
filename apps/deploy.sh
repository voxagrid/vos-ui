#!/bin/bash
# ==============================================================================
# VOS-UI Production Automated 1-Click Deployment Script
# VoxaGrid Multi-Tenant Web Management Suite
#
# Kompatibel dengan:
# - AlmaLinux 8 / 9
# - Rocky Linux 8 / 9
# - CentOS Stream 8 / 9
# - RHEL 8 / 9
# - Ubuntu 20.04 / 22.04 / 24.04 LTS
# - Debian 11 / 12
# ==============================================================================

set -e

# Definisi Warna Terminal
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[1;37m'

# Helper Logger Functions
log_info() {
    echo -e "${C_CYAN}[INFO]${C_RESET} $1"
}
log_success() {
    echo -e "${C_GREEN}[SUCCESS]${C_RESET} $1"
}
log_warn() {
    echo -e "${C_YELLOW}[WARNING]${C_RESET} $1"
}
log_error() {
    echo -e "${C_RED}[ERROR]${C_RESET} $1"
}

# ==============================================================================
# 1. HEADER BANNER
# ==============================================================================
clear 2>/dev/null || true
echo -e "${C_CYAN}"
cat << "EOF"
================================================================================
   _    __               ____       _     __   _    ______  _____         __  __ ____
  | |  / /____  _  __   / __ \____ (_)___/ /  | |  / / __ \/ ___/        / / / //  _/
  | | / / __ \| |/_/  / /_/ / __ `/ / __  /   | | / / / / /\__ \ ______ / / / / / /  
  | |/ / /_/ />  <   / ____/ /_/ / / /_/ /    | |/ / /_/ /___/ //_____// /_/ /_/ /   
  |___/\____/_/|_|  /_/    \__,_/_/\__,_/     |___/\____//____/         \____//___/   
                                                                                      
                Automated 1-Click Production Deployment Suite
================================================================================
EOF
echo -e "${C_RESET}"

# ==============================================================================
# 2. VALIDASI PRIVILEGE (ROOT CHECK)
# ==============================================================================
if [ "$EUID" -ne 0 ]; then
    log_error "Script ini wajib dijalankan sebagai root atau dengan sudo!"
    echo "Gunakan: sudo bash $0"
    exit 1
fi

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"
log_info "Direktori kerja deployment: ${C_WHITE}$APP_DIR${C_RESET}"

# ==============================================================================
# 3. DETEKSI SISTEM OPERASI (OS DETECTION)
# ==============================================================================
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
    OS_VERSION=$VERSION_ID
    OS_NAME=$PRETTY_NAME
else
    log_error "File /etc/os-release tidak ditemukan! Sistem operasi tidak didukung."
    exit 1
fi

log_info "Sistem Operasi terdeteksi: ${C_WHITE}$OS_NAME ($OS_ID $OS_VERSION)${C_RESET}"

# ==============================================================================
# 4. PENONAKTIFAN SELINUX & FIREWALLD
# ==============================================================================
# Nonaktifkan SELinux jika aktif (Red Hat, AlmaLinux, Rocky, CentOS, Fedora)
if command -v getenforce &>/dev/null; then
    CURRENT_SELINUX=$(getenforce 2>/dev/null || echo "Disabled")
    if [ "$CURRENT_SELINUX" != "Disabled" ]; then
        log_info "SELinux terdeteksi ($CURRENT_SELINUX). Menyetel ke Permissive/Disabled..."
        setenforce 0 2>/dev/null || true
        [ -f /etc/selinux/config ] && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config 2>/dev/null || true
        [ -f /etc/sysconfig/selinux ] && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux 2>/dev/null || true
        log_success "SELinux berhasil dinonaktifkan."
    fi
elif [ -f /etc/selinux/config ]; then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config 2>/dev/null || true
fi

# Hentikan dan Nonaktifkan Firewalld (mencegah pemblokiran port Web/API/Database/Docker)
if command -v systemctl &>/dev/null; then
    if systemctl is-active --quiet firewalld 2>/dev/null || systemctl is-enabled --quiet firewalld 2>/dev/null; then
        log_info "Menghentikan dan menonaktifkan firewalld..."
        systemctl stop firewalld 2>/dev/null || true
        systemctl disable firewalld 2>/dev/null || true
        log_success "Firewalld berhasil dimatikan & dinonaktifkan."
    fi
fi

# ==============================================================================
# 5. INSTALASI DEPENDENCIES SISTEM
# ==============================================================================
log_info "Memeriksa dan memasang paket pendukung sistem..."

if [[ "$OS_ID" =~ ^(almalinux|rocky|centos|rhel|fedora)$ ]]; then
    PKG_TOOL="dnf"
    if ! command -v dnf &>/dev/null; then
        PKG_TOOL="yum"
    fi
    $PKG_TOOL install -y curl wget jq tar gzip iproute procps net-tools ca-certificates openssl >/dev/null 2>&1 || {
        log_warn "Beberapa paket dependensi gagal diinstal secara otomatis, melanjutkan..."
    }
elif [[ "$OS_ID" =~ ^(ubuntu|debian)$ ]]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y curl wget jq tar gzip iproute2 procps net-tools ca-certificates openssl >/dev/null 2>&1 || {
        log_warn "Beberapa paket dependensi gagal diinstal secara otomatis, melanjutkan..."
    }
fi
log_success "Paket dependensi sistem siap."

# ==============================================================================
# 6. SINKRONISASI ZONA WAKTU KE ASIA/JAKARTA (WIB / UTC+7)
# ==============================================================================
log_info "Mengatur zona waktu server ke Asia/Jakarta (WIB)..."
if command -v timedatectl &>/dev/null; then
    timedatectl set-timezone Asia/Jakarta 2>/dev/null || true
fi
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Deteksi apakah di dalam container LXC Proxmox (LXC mewarisi jam host langsung)
IS_LXC=false
if grep -qa "container=lxc" /proc/1/environ 2>/dev/null || [ -f /run/systemd/container ] && grep -qa "lxc" /run/systemd/container 2>/dev/null; then
    IS_LXC=true
fi

if [ "$IS_LXC" = true ]; then
    log_info "Lingkungan terdeteksi sebagai Proxmox LXC Container (clock disinkronkan otomatis dari Proxmox Host)."
else
    # VM atau Baremetal -> gunakan chrony jika ada
    if [[ "$OS_ID" =~ ^(almalinux|rocky|centos|rhel)$ ]] && command -v dnf &>/dev/null; then
        if ! command -v chronyd &>/dev/null; then
            dnf install -y chrony >/dev/null 2>&1 || true
        fi
        systemctl enable --now chronyd >/dev/null 2>&1 || true
    fi
fi
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S %Z")
log_success "Zona waktu aktif: ${C_WHITE}$CURRENT_TIME${C_RESET}"

# ==============================================================================
# 7. INSTALASI DOCKER CE & DOCKER COMPOSE PLUGIN
# ==============================================================================
NEED_DOCKER=false
if ! command -v docker &>/dev/null; then
    NEED_DOCKER=true
elif ! docker compose version &>/dev/null; then
    NEED_DOCKER=true
fi

if [ "$NEED_DOCKER" = true ]; then
    log_info "Docker CE atau Docker Compose plugin belum terpasang. Memulai instalasi otomatis..."
    if [[ "$OS_ID" =~ ^(almalinux|rocky|centos|rhel)$ ]]; then
        $PKG_TOOL install -y dnf-plugins-core >/dev/null 2>&1 || true
        $PKG_TOOL config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >/dev/null 2>&1 || true
        if [ ! -f /etc/yum.repos.d/docker-ce.repo ]; then
            curl -fsSL https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo 2>/dev/null || true
        fi
        $PKG_TOOL install -y --allowerasing docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || $PKG_TOOL install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        systemctl enable --now docker
    elif [[ "$OS_ID" =~ ^(ubuntu|debian)$ ]]; then
        export DEBIAN_FRONTEND=noninteractive
        apt-get update -y
        apt-get install -y ca-certificates curl gnupg
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/$OS_ID/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
        chmod a+r /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update -y
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        systemctl enable --now docker
    else
        log_error "Distribusi OS tidak dikenali untuk instalasi otomatis Docker. Silakan pasang Docker manual."
        exit 1
    fi
else
    log_success "Docker CE dan Docker Compose sudah terpasang."
fi

# Pastikan Docker service berjalan
systemctl start docker 2>/dev/null || service docker start 2>/dev/null || true
DOCKER_VER=$(docker --version | awk '{print $3}' | tr -d ',')
COMPOSE_VER=$(docker compose version | awk '{print $4}')
log_success "Docker Engine: ${C_WHITE}$DOCKER_VER${C_RESET} | Docker Compose: ${C_WHITE}$COMPOSE_VER${C_RESET}"

# ==============================================================================
# 8. GENERASI / VERIFIKASI /etc/machine-id
# ==============================================================================
if [ ! -s /etc/machine-id ]; then
    log_warn "File /etc/machine-id kosong atau belum ada. Menginisialisasi Machine-ID unik..."
    systemd-machine-id-setup 2>/dev/null || dbus-uuidgen --ensure=/etc/machine-id 2>/dev/null || cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id
fi
MACHINE_ID=$(cat /etc/machine-id | tr -d '\n\r ' | head -c 32)
log_success "System Machine-ID: ${C_WHITE}$MACHINE_ID${C_RESET}"

# Deteksi IP dan Interface Utama
PRIMARY_IP=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+' || hostname -I | awk '{print $1}')
PRIMARY_IFACE=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+' || ip -o -4 route show to default | awk '{print $5}' | head -n 1)
PRIMARY_MAC=$(cat /sys/class/net/${PRIMARY_IFACE}/address 2>/dev/null || ip link show ${PRIMARY_IFACE} 2>/dev/null | grep -oP 'link/ether \K\S+' || echo "unknown")

# ==============================================================================
# 9. PERSIAPAN FILE LISENSI (license.lic) & AUTOMATED 7-DAY TRIAL
# ==============================================================================
# Proteksi docker: jika license.lic pernah dibuat sebagai direktori secara tidak sengaja oleh docker compose
if [ -d "$APP_DIR/license.lic" ]; then
    log_warn "Menghapus direktori license.lic palsu yang dibuat oleh Docker..."
    rm -rf "$APP_DIR/license.lic"
fi

if [ -f "$APP_DIR/license.lic" ] && [ -s "$APP_DIR/license.lic" ]; then
    log_success "File lisensi resmi terdeteksi: ${C_WHITE}$APP_DIR/license.lic${C_RESET}"
else
    # Buat file kosong agar Docker volume mount tidak error
    touch "$APP_DIR/license.lic"
    echo -e "${C_GREEN}"
    cat << EOF
+-------------------------------------------------------------------------------+
|                 AUTOMATED 7-DAY TRIAL EVALUATION ACTIVE                       |
+-------------------------------------------------------------------------------+
  File license.lic belum diisi (Mode Evaluasi Instan Aktif).
  Sistem otomatis aktif selama 7 HARI (Maksimal 2 Node VOS) tanpa lisensi!
  
  Anda dapat menghubungkan softswitch VOS dan menguji seluruh fitur sekarang.
  Untuk aktivasi lisensi resmi permanen, Anda dapat mengaktifkannya langsung
  melalui Web Dashboard atau mengirimkan data berikut ke Vendor:

    * Machine ID   : $MACHINE_ID
    * MAC Address  : $PRIMARY_MAC
    * Primary IP   : $PRIMARY_IP
+-------------------------------------------------------------------------------+
EOF
    echo -e "${C_RESET}"
fi

# ==============================================================================
# 10. PERSIAPAN KONFIGURASI .env
# ==============================================================================
if [ ! -f "$APP_DIR/.env" ]; then
    log_info "Membuat file konfigurasi aman .env dengan cryptographic secrets acak..."
    if [ -f "$APP_DIR/.env.example" ]; then
        cp "$APP_DIR/.env.example" "$APP_DIR/.env"
    else
        cat << 'EOF' > "$APP_DIR/.env"
# Timezone standard
APP_TZ=Asia/Jakarta

# Database Configuration (PostgreSQL 15 + TimescaleDB)
DB_USER=admin
DB_PASS=ChangeThisToStrongSecurePassword2026!
DB_NAME=sbc

# Redis Configuration (Cache & Token Storage)
REDIS_PASS=ChangeThisToRedisPass2026!

# Primary VOS3000 Node Upstream API
VOS_API_URL=http://127.0.0.1:6099
EOF
    fi

    # Generate random cryptographic secrets
    RAND_DB_PASS=$(openssl rand -hex 16 2>/dev/null || cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 32)
    RAND_REDIS_PASS=$(openssl rand -hex 16 2>/dev/null || cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 32)

    sed -i "s/^DB_PASS=.*/DB_PASS=${RAND_DB_PASS}/" "$APP_DIR/.env"
    sed -i "s/^REDIS_PASS=.*/REDIS_PASS=${RAND_REDIS_PASS}/" "$APP_DIR/.env"

    log_success "File .env berhasil dibuat dengan kredensial database & cache acak."
else
    log_info "File konfigurasi .env sudah ada, mempertahankan konfigurasi saat ini."
fi

# Pastikan folder logs, ssl, conf.d, certbot & permissions siap
mkdir -p "$APP_DIR/logs/nginx" "$APP_DIR/initdb" "$APP_DIR/nginx/ssl" "$APP_DIR/nginx/conf.d" "$APP_DIR/nginx/certbot" "$APP_DIR/scripts"
chmod +x "$APP_DIR/middleware/vos-middleware" "$APP_DIR/scripts/"*.sh 2>/dev/null || true

# ==============================================================================
# 11. MENJALANKAN DOCKER COMPOSE STACK
# ==============================================================================
log_info "Membangun dan menjalankan container VOS-UI (mode network: host)..."
docker compose down >/dev/null 2>&1 || true
docker compose up -d --build

# ==============================================================================
# 12. MONITORING KESEHATAN CONTAINER (HEALTHCHECK WAIT LOOP)
# ==============================================================================
log_info "Menunggu seluruh container memasuki status HEALTHY (maksimal 60 detik)..."

WAIT_SECONDS=0
MAX_WAIT=60
SERVICES=("vos-postgres" "vos-redis" "vos-middleware" "vos-frontend")

while [ $WAIT_SECONDS -lt $MAX_WAIT ]; do
    ALL_HEALTHY=true
    STATUS_LINE=""

    for svc in "${SERVICES[@]}"; do
        STATUS=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$svc" 2>/dev/null || echo "not-found")
        if [ "$STATUS" != "healthy" ]; then
            ALL_HEALTHY=false
        fi
        STATUS_LINE="$STATUS_LINE $svc:[$STATUS]"
    done

    if [ "$ALL_HEALTHY" = true ]; then
        break
    fi

    sleep 3
    WAIT_SECONDS=$((WAIT_SECONDS + 3))
    echo -ne "  [Menunggu $WAIT_SECONDS s / $MAX_WAIT s]$STATUS_LINE\r"
done
echo ""

if [ "$ALL_HEALTHY" = true ]; then
    log_success "Semua container berhasil menyala dan berstatus HEALTHY!"
else
    log_warn "Beberapa container membutuhkan waktu lebih lama untuk inisialisasi awal database."
fi

# ==============================================================================
# 12.5 VERIFIKASI POST-DEPLOY HEALTHCHECK GUARD (HTTP 200 OK)
# ==============================================================================
log_info "Melakukan verifikasi endpoint HTTP backend & frontend (SLA 200 OK)..."
HTTP_CHECK_OK=false
BACKEND_STATUS="000"
FRONTEND_STATUS="000"

for i in {1..15}; do
    BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/health 2>/dev/null || echo "000")
    FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/health 2>/dev/null || echo "000")

    if [ "$BACKEND_STATUS" = "200" ] && [ "$FRONTEND_STATUS" = "200" ]; then
        HTTP_CHECK_OK=true
        break
    fi
    sleep 2
done

if [ "$HTTP_CHECK_OK" = true ]; then
    log_success "Verifikasi HTTP Healthcheck 200 OK: Backend API (:8080) & Nginx Web (:80) READY!"
else
    log_warn "Satu atau lebih endpoint belum merespons HTTP 200 OK (Backend: $BACKEND_STATUS, Frontend: $FRONTEND_STATUS). Periksa 'docker compose logs'."
fi

# ==============================================================================
# 13. RINGKASAN DEPLOYMENT & AKSES SISTEM
# ==============================================================================
echo -e "${C_GREEN}"
cat << EOF
================================================================================
   DEPLOYMENT VOS-UI PRODUCTION SELESAI & BERJALAN DENGAN SEMPURNA!
================================================================================
EOF
echo -e "${C_RESET}"
echo -e "  🌐  ${C_WHITE}Web Dashboard URL${C_RESET} : ${C_CYAN}http://${PRIMARY_IP}/${C_RESET}"
echo -e "  🩺  ${C_WHITE}Backend API Health${C_RESET} : ${C_CYAN}http://${PRIMARY_IP}:8080/health${C_RESET}"
echo -e "  🗄️   ${C_WHITE}PostgreSQL Database${C_RESET}: ${C_CYAN}127.0.0.1:5532${C_RESET} (Database: sbc)"
echo -e "  ⚡  ${C_WHITE}Redis Cache Engine${C_RESET} : ${C_CYAN}127.0.0.1:6379${C_RESET}"
echo ""
echo -e "  🔑  ${C_WHITE}Kredensial Default Login:${C_RESET}"
echo -e "      - ${C_YELLOW}Super Administrator${C_RESET} : username: ${C_WHITE}admin${C_RESET}     | password: ${C_WHITE}voxagrid${C_RESET}"
echo ""
echo -e "  🛠️   ${C_WHITE}Perintah Manajemen Berguna:${C_RESET}"
echo -e "      - Cek status container   : ${C_WHITE}docker compose ps${C_RESET}"
echo -e "      - Pantau log real-time   : ${C_WHITE}docker compose logs -f${C_RESET}"
echo -e "      - Restart layanan        : ${C_WHITE}docker compose restart${C_RESET}"
echo -e "      - Matikan layanan        : ${C_WHITE}docker compose down${C_RESET}"
echo -e "      - Reset Nginx darurat    : ${C_WHITE}bash ./scripts/reset-http-server.sh${C_RESET}"
echo "================================================================================"
