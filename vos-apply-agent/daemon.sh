#!/bin/bash
DIR="/home/kunshi/services/vos-apply-agent"
JDK_HOME="/home/kunshi/base/jdk_default"
LOG_FILE="/home/kunshi/services/vos-apply-agent/vos-apply-agent.log"
VAR_LOG="/var/log/vos-apply-agent.log"

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE" 2>/dev/null || true
    echo "$msg" >> "$VAR_LOG" 2>/dev/null || true
}

log "[vos-apply-agent-daemon] Starting VOS Host Agent & Monitor suite..."

while true; do
    # 1. Pastikan In-JVM VosApplyAgent (Port 9095) ter-attach jika vos3000d sedang berjalan
    if ! curl -s -m 2 http://127.0.0.1:9095/health >/dev/null 2>&1; then
        $DIR/attach.sh >/dev/null 2>&1 || true
    fi

    # 2. Pastikan Independent Root Host Monitor (Port 9096) selalu hidup (bahkan saat vos3000d mati)
    if ! curl -s -m 2 http://127.0.0.1:9096/health >/dev/null 2>&1; then
        pkill -f "com.kunshi.agent.VosHostMonitor" >/dev/null 2>&1 || true
        log "[vos-apply-agent-daemon] Spawning VosHostMonitor (Port 9096)..."
        nohup nice -n 10 ionice -c 3 $JDK_HOME/bin/java -Xmx256m -Xms128m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -cp "$DIR/bin/vos-apply-agent.jar:$DIR/lib/mysql-connector-java-5.1.49.jar" com.kunshi.agent.VosHostMonitor 9096 >> /var/log/vos-host-monitor.log 2>&1 &
    fi

    sleep 3
done
