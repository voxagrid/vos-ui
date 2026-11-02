#!/bin/bash
# ==============================================================================
# VOS3000 Apply Agent & Host Monitor Automated 1-Click Deployment Script
# Digunakan khusus pada Mesin Host Softswitch VOS3000
#
# Memasang dan mengonfigurasi:
# - Port 9095: In-JVM Agent (Sinkronisasi Routing, Rate Table, SIP Circular Ring Buffer)
# - Port 9096: Standalone Host Monitor & Secure Loopback Proxy (Tomcat 6099 & MySQL 3306)
# - Systemd Unit: vos-apply-agent.service
# - Whitelist Tomcat Webserver & Database MySQL (e_web_access_control)
# - Zero-Exposure Firewall: Kunci Port 3306 & 6099 dari luar, buka Port 9095 & 9096 untuk VOS-UI
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
   _    __               ___                __         ___                    __ 
  | |  / /____  _____   /   |  ____  ____  / /_  __   /   | ____ ____  ____  / /_
  | | / / __ \/ ___/   / /| | / __ \/ __ \/ / / / /  / /| |/ __ `/ _ \/ __ \/ __/
  | |/ / /_/ (__  )   / ___ |/ /_/ / /_/ / / /_/ /  / ___ / /_/ /  __/ / / / /_  
  |___/\____/____/   /_/  |_/ .___/ .___/_/\__, /  /_/  |_\__, /\___/_/ /_/\__/  
                           /_/   /_/      /____/         /____/                  
                                                                                 
         VOS3000 Host Agent (Port 9095 & 9096) Production Installer
================================================================================
EOF
echo -e "${C_RESET}"

# ==============================================================================
# 2. VALIDASI PRIVILEGE (ROOT CHECK)
# ==============================================================================
if [ "$EUID" -ne 0 ]; then
    log_error "Script ini wajib dijalankan sebagai root!"
    echo "Gunakan: sudo bash $0"
    exit 1
fi

# ==============================================================================
# 3. PENONAKTIFAN SELINUX & FIREWALLD
# ==============================================================================
# Nonaktifkan SELinux jika aktif (Red Hat, AlmaLinux, Rocky, CentOS)
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

# Hentikan dan Nonaktifkan Firewalld (mencegah pemblokiran port SIP/VOS/Agent/DB)
if command -v systemctl &>/dev/null; then
    if systemctl is-active --quiet firewalld 2>/dev/null || systemctl is-enabled --quiet firewalld 2>/dev/null; then
        log_info "Menghentikan dan menonaktifkan firewalld..."
        systemctl stop firewalld 2>/dev/null || true
        systemctl disable firewalld 2>/dev/null || true
        log_success "Firewalld berhasil dimatikan & dinonaktifkan."
    fi
fi

# ==============================================================================
# 3.5 INSTALASI DEPENDENCIES SISTEM (CURL, WGET, JQ, OPENSSL, IP TOOLS)
# ==============================================================================
log_info "Memeriksa dan memasang paket pendukung sistem otomatis..."
if command -v dnf &>/dev/null; then
    dnf install -y curl wget jq tar gzip openssl ca-certificates iproute procps net-tools >/dev/null 2>&1 || true
elif command -v yum &>/dev/null; then
    yum install -y curl wget jq tar gzip openssl ca-certificates iproute procps net-tools >/dev/null 2>&1 || true
elif command -v apt-get &>/dev/null; then
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y curl wget jq tar gzip openssl ca-certificates iproute2 procps net-tools >/dev/null 2>&1 || true
fi
log_success "Paket dependensi sistem siap."

# ==============================================================================
# 4. VALIDASI LINGKUNGAN VOS3000
# ==============================================================================
log_info "Memeriksa lingkungan Softswitch VOS3000..."

JDK_DEFAULT="/home/kunshi/base/jdk_default"
if [ ! -d "$JDK_DEFAULT" ]; then
    if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME" ]; then
        JDK_DEFAULT="$JAVA_HOME"
    else
        log_error "Direktori JDK VOS3000 (/home/kunshi/base/jdk_default) tidak ditemukan!"
        echo "Pastikan script ini dijalankan di server yang sudah terinstal VOS3000."
        exit 1
    fi
fi
log_success "JDK VOS3000 terdeteksi di: ${C_WHITE}$JDK_DEFAULT${C_RESET}"

# Periksa direktori softswitch
if [ ! -d "/home/kunshi" ]; then
    log_error "Direktori home kunshi (/home/kunshi) tidak ditemukan!"
    exit 1
fi

# ==============================================================================
# 5. PENYIAPAN DIREKTORI KERJA TARGET (/home/kunshi/services/vos-apply-agent)
# ==============================================================================
TARGET_DIR="/home/kunshi/services/vos-apply-agent"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$CURRENT_DIR" != "$TARGET_DIR" ]; then
    log_info "Menyalin file agent ke direktori target: ${C_WHITE}$TARGET_DIR${C_RESET}..."
    mkdir -p "$TARGET_DIR"
    cp -r "$CURRENT_DIR"/* "$TARGET_DIR/"
fi

cd "$TARGET_DIR"
mkdir -p "$TARGET_DIR/bin"
chown -R kunshi:kunshi "$TARGET_DIR"
chmod +x "$TARGET_DIR"/*.sh

# ==============================================================================
# 6. VERIFIKASI PAKET BINARY PRE-COMPILED JAR
# ==============================================================================
log_info "Memeriksa paket binary pre-compiled JAR (vos-apply-agent.jar & attach.jar)..."

if [ ! -f "$TARGET_DIR/bin/vos-apply-agent.jar" ] || [ ! -f "$TARGET_DIR/bin/attach.jar" ]; then
    log_error "File binary JAR di $TARGET_DIR/bin/ tidak lengkap atau belum ada!"
    exit 1
fi
chmod 644 "$TARGET_DIR/bin"/*.jar
[ -d "$TARGET_DIR/lib" ] && chmod 644 "$TARGET_DIR/lib"/*.jar 2>/dev/null || true
chown -R kunshi:kunshi "$TARGET_DIR"
log_success "Paket binary JAR terverifikasi dan siap digunakan."

# ==============================================================================
# 7. INSTALASI SYSTEMD SERVICE (vos-apply-agent.service)
# ==============================================================================
log_info "Memasang dan mengaktifkan service systemd vos-apply-agent.service..."

cat << 'EOF' > /etc/systemd/system/vos-apply-agent.service
[Unit]
Description=VOS3000 Apply Agent & Host Process Monitor (Port 9095 & 9096)
After=network.target vos3000d.service

[Service]
Type=simple
User=root
ExecStart=/home/kunshi/services/vos-apply-agent/daemon.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now vos-apply-agent.service
log_success "Service vos-apply-agent.service aktif dan berjalan."

# ==============================================================================
# 8. PERBAIKAN BOOT-SAFE SERVERMONITORD (PROCESS MONITOR ANTI-KOSONG)
# ==============================================================================
log_info "Menerapkan patch boot-safe untuk servermonitord..."

# Wrapper runlevel boot-safe untuk CentOS 7 / systemd
if [ -f /etc/redhat-release ]; then
    rm -f /usr/sbin/runlevel
    cat << 'EOF' > /usr/sbin/runlevel
#!/bin/bash
OUT=$(exec -a runlevel /bin/systemctl 2>/dev/null)
if [ "$OUT" = "unknown" -o -z "$OUT" ]; then
    echo "N 3"
else
    echo "$OUT"
fi
EOF
    chmod 755 /usr/sbin/runlevel
fi

if [ -f /etc/init.d/servermonitord ]; then
    sed -i 's/^# Should-Start:.*/# Should-Start: mysql empd vos3000d webdatad webserverd mgcd callserviced audioplayerd mbx3000d mediarecordd/' /etc/init.d/servermonitord
    systemctl daemon-reload
    /etc/init.d/servermonitord restart >/dev/null 2>&1 || true
    log_success "Patch boot-safe servermonitord berhasil dipasang."
fi

# ==============================================================================
# 9. WHITELIST IP SERVER VOS-UI & KEBIJAKAN ZERO-EXPOSURE (PORT 9095 & 9096)
# ==============================================================================
VOS_HOST_IP=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+' || hostname -I | awk '{print $1}')
VOS_UI_IP="$1"

if [ -z "$VOS_UI_IP" ]; then
    if [ -t 0 ]; then
        echo ""
        echo -e "${C_YELLOW}--------------------------------------------------------------------------------${C_RESET}"
        echo -e "${C_WHITE}Konfigurasi Akses IP Server VOS-UI (Arsitektur Zero-Exposure):${C_RESET}"
        echo -e "Masukkan alamat IP dari server VOS-UI agar Softswitch mengizinkan akses ke"
        echo -e "Agent Ports (9095 & 9096). Port 6099 (Tomcat) & Port 3306 (MySQL) otomatis"
        echo -e "DITUTUP/DI-DROP dari akses eksternal demi keamanan maksimal."
        echo -e "(Untuk multi-node cluster, pisahkan dengan koma, misal: 10.0.0.10,10.0.0.11)"
        read -p "Masukkan IP Server VOS-UI [tekan Enter jika ingin lewati]: " VOS_UI_IP
        echo -e "${C_YELLOW}--------------------------------------------------------------------------------${C_RESET}"
        echo ""
    fi
fi

# Pastikan IP host lokal selalu terdaftar di ALLOWED_IPS agent.conf
if [ -n "$VOS_HOST_IP" ] && [ -f "$TARGET_DIR/agent.conf" ]; then
    if ! grep -q "$VOS_HOST_IP" "$TARGET_DIR/agent.conf"; then
        sed -i "/^ALLOWED_IPS=/ s/$/,${VOS_HOST_IP}/" "$TARGET_DIR/agent.conf"
    fi
fi

# Baca kredensial MySQL lokal dari agent.conf
MYSQL_USER_CFG=$(grep '^MYSQL_LOCAL_USER=' "$TARGET_DIR/agent.conf" 2>/dev/null | cut -d'=' -f2 | sed "s/['\"\r ]//g" || echo "root")
MYSQL_PASS_CFG=$(grep '^MYSQL_LOCAL_PASS=' "$TARGET_DIR/agent.conf" 2>/dev/null | cut -d'=' -f2 | sed "s/['\"\r ]//g" || echo "")
[ -z "$MYSQL_USER_CFG" ] && MYSQL_USER_CFG="root"

if [ -n "$VOS_UI_IP" ]; then
    log_info "Menerapkan izin akses whitelist untuk IP VOS-UI: ${C_WHITE}$VOS_UI_IP${C_RESET}..."

    IFS=',' read -ra UI_IP_LIST <<< "$VOS_UI_IP"

    for SINGLE_IP in "${UI_IP_LIST[@]}"; do
        SINGLE_IP=$(echo "$SINGLE_IP" | tr -d ' ')
        [ -z "$SINGLE_IP" ] && continue

        # 1. Update ALLOWED_IPS pada agent.conf
        if [ -f "$TARGET_DIR/agent.conf" ]; then
            if ! grep -q "$SINGLE_IP" "$TARGET_DIR/agent.conf"; then
                sed -i "/^ALLOWED_IPS=/ s/$/,${SINGLE_IP}/" "$TARGET_DIR/agent.conf"
                log_success "IP $SINGLE_IP ditambahkan ke ALLOWED_IPS di agent.conf"
            fi
        fi

        # 2. Update Tomcat webserver_access_control.conf via Python (Local Loopback + UI IP)
        TOMCAT_CONF="/home/kunshiweb/base/apache-tomcat/conf/webserver_access_control.conf"
        if [ -f "$TOMCAT_CONF" ] && command -v python &>/dev/null; then
            python -c '
import json, sys
ip = sys.argv[1]
conf_file = sys.argv[2]
try:
    with open(conf_file, "r") as f:
        data = json.load(f)
    modified = False
    for entry in data:
        ips = entry.get("allowIps", [])
        for target in ["127.0.0.1", ip]:
            if target and target not in ips:
                ips.append(target)
                modified = True
        entry["allowIps"] = ips
    if modified:
        with open(conf_file, "w") as f:
            json.dump(data, f)
        print("TOMCAT_CONF_UPDATED")
except Exception as e:
    print("ERR: %s" % e)
' "$SINGLE_IP" "$TOMCAT_CONF" >/dev/null 2>&1 || true
        fi

        # 3. Update Database e_web_access_control di MySQL VOS3000
        if command -v mysql &>/dev/null; then
            if [ -n "$MYSQL_PASS_CFG" ]; then
                mysql -u"$MYSQL_USER_CFG" -p"$MYSQL_PASS_CFG" vos3000 -e "
                UPDATE e_web_access_control 
                SET allowip = CONCAT(allowip, ',127.0.0.1,$SINGLE_IP') 
                WHERE allowip NOT LIKE '%$SINGLE_IP%' AND id IN (101, 102);
                " >/dev/null 2>&1 || true
            else
                mysql -u"$MYSQL_USER_CFG" vos3000 -e "
                UPDATE e_web_access_control 
                SET allowip = CONCAT(allowip, ',127.0.0.1,$SINGLE_IP') 
                WHERE allowip NOT LIKE '%$SINGLE_IP%' AND id IN (101, 102);
                " >/dev/null 2>&1 || true
            fi
        fi

        # 4. Izinkan Port 9095 & 9096 untuk SINGLE_IP di iptables
        if command -v iptables &>/dev/null; then
            for port in 9095 9096; do
                if ! iptables -C INPUT -p tcp -s "${SINGLE_IP}" --dport "${port}" -j ACCEPT 2>/dev/null; then
                    iptables -I INPUT -p tcp -s "${SINGLE_IP}" --dport "${port}" -j ACCEPT 2>/dev/null || true
                fi
            done
        fi
    done

    log_success "Akses Tomcat & Database dikonfigurasi untuk Loopback & IP VOS-UI ($VOS_UI_IP)."

    # 5. Restart Tomcat Webserver jika konfigurasi diperbarui
    if [ -x /etc/init.d/webserverd ]; then
        log_info "Mereload layanan Tomcat webserverd..."
        /etc/init.d/webserverd reload >/dev/null 2>&1 || /etc/init.d/webserverd restart >/dev/null 2>&1 || true
    fi

    # 6. Konfigurasi Firewall Zero-Exposure (Kunci Port 3306 & 6099 dari luar)
    if command -v iptables &>/dev/null; then
        log_info "Menerapkan aturan firewall Zero-Exposure..."
        for port in 3306 6099; do
            if ! iptables -C INPUT -p tcp --dport "${port}" ! -s 127.0.0.1 -j DROP 2>/dev/null; then
                iptables -I INPUT -p tcp --dport "${port}" ! -s 127.0.0.1 -j DROP 2>/dev/null || true
            fi
        done
        /sbin/iptables-save > /etc/sysconfig/iptables 2>/dev/null || true
        log_success "Firewall Zero-Exposure aktif: Port 3306 & 6099 terkunci, Port 9095 & 9096 diizinkan untuk $VOS_UI_IP."
    fi
else
    log_info "IP VOS-UI dilewati. Anda dapat mengonfigurasi whitelist IP kapan saja nanti."
fi

# ==============================================================================
# 10. VERIFIKASI KESEHATAN AGENT (PORT 9095, 9096, VOS API PROXY & MYSQL PROXY)
# ==============================================================================
log_info "Memverifikasi endpoint kesehatan Agent dan Secure Proxy..."
sleep 3

PORT_9095_OK=false
PORT_9096_OK=false
PORT_PROXY_OK=false
PORT_MYSQL_OK=false
AGENT_KEY=$(grep '^AGENT_SECRET=' "$TARGET_DIR/agent.conf" 2>/dev/null | cut -d'=' -f2 | sed "s/['\"\r ]//g" || echo "voxagrid-agent-secret-2026")

for i in {1..10}; do
    if curl -s -m 2 http://127.0.0.1:9095/health >/dev/null 2>&1; then
        PORT_9095_OK=true
    fi
    if curl -s -m 2 http://127.0.0.1:9096/health >/dev/null 2>&1; then
        PORT_9096_OK=true
    fi
    if curl -s -m 2 -H "X-VOS-Agent-Key: $AGENT_KEY" http://127.0.0.1:9096/health/vos-api 2>/dev/null | grep -q '"connected":true'; then
        PORT_PROXY_OK=true
    fi
    if curl -s -m 2 -H "X-VOS-Agent-Key: $AGENT_KEY" http://127.0.0.1:9096/health/mysql 2>/dev/null | grep -q "UP"; then
        PORT_MYSQL_OK=true
    fi
    if [ "$PORT_9095_OK" = true ] && [ "$PORT_9096_OK" = true ] && [ "$PORT_PROXY_OK" = true ] && [ "$PORT_MYSQL_OK" = true ]; then
        break
    fi
    sleep 1
done

echo ""
if [ "$PORT_9095_OK" = true ]; then
    log_success "Port 9095 (In-JVM Apply & Ring Buffer Agent): ${C_GREEN}ONLINE${C_RESET}"
else
    log_warn "Port 9095 belum merespon. Pastikan proses vos3000d sedang berjalan di host ini."
fi

if [ "$PORT_9096_OK" = true ]; then
    log_success "Port 9096 (Standalone Host Process Monitor): ${C_GREEN}ONLINE${C_RESET}"
else
    log_warn "Port 9096 belum merespon."
fi

if [ "$PORT_PROXY_OK" = true ]; then
    log_success "Port 9096 Secure VOS API Proxy Loopback (:6099): ${C_GREEN}HEALTHY (200 OK)${C_RESET}"
else
    log_warn "Port 9096 Secure Proxy ke Tomcat (:6099) belum merespon atau Tomcat sedang restarting."
fi

if [ "$PORT_MYSQL_OK" = true ]; then
    log_success "Port 9096 Secure MySQL Loopback (:3306): ${C_GREEN}HEALTHY (200 OK)${C_RESET}"
else
    log_warn "Port 9096 Secure MySQL (:3306) belum merespon. Periksa MYSQL_LOCAL_USER/PASS di agent.conf."
fi

# ==============================================================================
# 11. RINGKASAN DEPLOYMENT HOST AGENT
# ==============================================================================
VOS_HOST_IP=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+' || hostname -I | awk '{print $1}')

echo -e "${C_GREEN}"
cat << EOF
================================================================================
   VOS-APPLY-AGENT BERHASIL DIPASANG & SIAP DIGUNAKAN!
================================================================================
EOF
echo -e "${C_RESET}"
echo -e "  📍  ${C_WHITE}Lokasi Instalasi${C_RESET}       : ${C_CYAN}$TARGET_DIR${C_RESET}"
echo -e "  ⚙️   ${C_WHITE}Systemd Service${C_RESET}        : ${C_CYAN}systemctl status vos-apply-agent.service${C_RESET}"
echo -e "  🔌  ${C_WHITE}Port 9095 (Apply/Trace)${C_RESET} : ${C_GREEN}http://${VOS_HOST_IP}:9095/health${C_RESET}"
echo -e "  🖥️   ${C_WHITE}Port 9096 (Host Monitor)${C_RESET}: ${C_GREEN}http://${VOS_HOST_IP}:9096/health${C_RESET}"
echo -e "  🛡️   ${C_WHITE}Port 9096 (VOS Proxy)${C_RESET}   : ${C_GREEN}http://${VOS_HOST_IP}:9096/health/vos-api${C_RESET}"
echo -e "  🗄️   ${C_WHITE}Port 9096 (MySQL Proxy)${C_RESET} : ${C_GREEN}http://${VOS_HOST_IP}:9096/health/mysql${C_RESET}"
echo -e "  🔒  ${C_WHITE}Zero-Exposure Ports${C_RESET}    : ${C_YELLOW}Port 3306 (MySQL) & Port 6099 (Tomcat) DITUTUP DARI LUAR${C_RESET}"
if [ -n "$VOS_UI_IP" ]; then
echo -e "  🛡️   ${C_WHITE}Whitelisted IP VOS-UI${C_RESET}  : ${C_YELLOW}$VOS_UI_IP${C_RESET}"
fi
echo ""
echo -e "  🛠️   ${C_WHITE}Perintah Manajemen Berguna:${C_RESET}"
echo -e "      - Cek status agent  : ${C_WHITE}systemctl status vos-apply-agent.service${C_RESET}"
echo -e "      - Restart agent     : ${C_WHITE}systemctl restart vos-apply-agent.service${C_RESET}"
echo -e "      - Pantau log agent  : ${C_WHITE}journalctl -u vos-apply-agent.service -f${C_RESET}"
echo "================================================================================"
