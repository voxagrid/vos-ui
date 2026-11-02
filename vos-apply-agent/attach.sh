#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$DIR/bin"
JDK_HOME="/home/kunshi/base/jdk_default"
PORT="${1:-9095}"
FORCE="${2}"
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    PORT="9095"
    FORCE="--force"
fi

# Cek apakah sudah running (kecuali jika dipaksa reload)
if [ "$FORCE" != "--force" ] && [ "$FORCE" != "-f" ]; then
    if curl -s -m 2 "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
        echo "[vos-apply-agent] Already running on http://127.0.0.1:$PORT"
        exit 0
    fi
fi

# Temukan PID vos3000
VOS_PID=$(pgrep -f "vos3000/bin/vos3000" | head -n 1 || true)
if [ -z "$VOS_PID" ] && [ -f /home/kunshi/.run/vos3000.pid ]; then
    VOS_PID=$(cat /home/kunshi/.run/vos3000.pid)
fi

if [ -z "$VOS_PID" ]; then
    echo "[vos-apply-agent] Error: vos3000 process not found!"
    exit 1
fi

echo "[vos-apply-agent] Attaching to vos3000 (PID: $VOS_PID) on port $PORT..."
TS=$(date +%s)
TMP_JAR="/tmp/vos-agent-$TS.jar"
cp "$BIN_DIR/vos-apply-agent.jar" "$TMP_JAR"
chown kunshi:kunshi "$TMP_JAR"
su - kunshi -c "$JDK_HOME/bin/java -cp '$BIN_DIR/attach.jar:$JDK_HOME/lib/tools.jar' com.kunshi.agent.AttachAgent $VOS_PID '$TMP_JAR' $PORT"
rm -f "$TMP_JAR"

# Tunggu sampai endpoint aktif
for i in {1..10}; do
    if curl -s -m 1 "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
        echo "[vos-apply-agent] Successfully running on http://127.0.0.1:$PORT"
        exit 0
    fi
    sleep 0.5
done

echo "[vos-apply-agent] Warning: Agent attached but health check did not respond yet."
exit 0
