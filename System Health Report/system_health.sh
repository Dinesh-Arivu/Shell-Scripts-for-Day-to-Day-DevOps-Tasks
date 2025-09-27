#!/bin/bash
# System Health Report Script

echo "====================================="
echo "📊 System Health Report - $(hostname)"
echo "📅 Date: $(date)"
echo "====================================="

# Uptime
echo -e "\n⏱️ Uptime:"
uptime -p

# Load Average
echo -e "\n⚡ Load Average:"
uptime | awk -F'load average:' '{ print $2 }'

# Disk Usage
echo -e "\n💽 Disk Usage:"
df -h --output=source,size,used,avail,pcent,target | grep '^/dev/'

# Memory Usage
echo -e "\n🧠 Memory Usage:"
free -h

# CPU Usage (1 sample)
echo -e "\n🖥️ CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "User: "$2"% | System: "$4"% | Idle: "$8"%"}'

# Top 5 Processes by CPU
echo -e "\n🔥 Top 5 Processes (by CPU):"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6

# Top 5 Processes by Memory
echo -e "\n💾 Top 5 Processes (by Memory):"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -6

# Network Interfaces
echo -e "\n🌐 Network Interfaces:"
ip -br addr show | grep -v "LOOPBACK"

# Active Services (example: sshd, docker)
echo -e "\n🛠️ Critical Services Status:"
for service in sshd docker; do
    if systemctl is-active --quiet "$service"; then
        echo "✅ $service is running"
    else
        echo "❌ $service is NOT running"
    fi
done

echo -e "\n✅ Report generated successfully."
# End of Report