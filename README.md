
# Shell-Scripts-for-Day-to-Day-DevOps-Tasks

A collection of **day-to-day DevOps shell scripts** to automate common system administration and monitoring tasks. These scripts help in **monitoring, deployment, backups, service management, and system health checks**.

---

## 📂 Repository Structure

```

devops-shell-scripts/
│
├── check_disk_usage.sh       # Monitor disk usage & send alert
├── check_service_status.sh   # Check and restart services if stopped
├── backup_directory.sh       # Backup directories with timestamp
├── monitor_cpu_mem.sh        # Monitor CPU and memory usage
├── log_rotation.sh           # Rotate and archive log files
├── check_open_ports.sh       # Check if required ports are open
├── deploy_application.sh     # Deploy app via git pull and restart service
├── monitor_docker.sh         # Monitor running Docker containers
├── check_ssl_expiry.sh       # Check SSL certificate expiry
├── system_health_report.sh   # Generate system health report
└── README.md

````

---

## ⚡ Features

- **Disk Monitoring:** Alerts if disk usage crosses a defined threshold.
- **Service Management:** Checks the status of services and restarts them if stopped.
- **Backup Automation:** Compress and store backups with timestamps.
- **CPU & Memory Monitoring:** Quick check for resource usage.
- **Log Rotation:** Archive old logs and maintain fresh log files.
- **Port Monitoring:** Check if important ports are open.
- **Application Deployment:** Simple deployment automation with Git and service restart.
- **Docker Monitoring:** Lists running Docker containers and their status.
- **SSL Monitoring:** Check SSL certificate expiry dates for domains.
- **System Health Report:** Consolidated overview of uptime, disk, memory, and top processes.

---

## 📥 How to Use

### 1. Clone the Repository

```bash
git clone https://github.com/Dinesh-Arivu/Shell-Scripts-for-Day-to-Day-DevOps-Tasks.git
cd Shell-Scripts-for-Day-to-Day-DevOps-Tasks
````

---

### 2. Manual Execution

Make scripts executable:

```bash
sudo chmod +x script_name.sh
```

Run any script manually:

```bash
sudo ./script_name.sh
```

---

### 3. Automated Execution (Cron Jobs)

To run scripts automatically at regular intervals:

1. Open the crontab editor:

```bash
crontab -e
```

2. Add a cron job. Example:

```bash
# Run disk usage check every day at 8 AM
0 8 * * * /path/to/Shell-Scripts-for-Day-to-Day-DevOps-Tasks/script_name.sh

---

## 🛠 Prerequisites

* Linux environment (Ubuntu/Debian recommended)
* `bash` shell
* Optional tools depending on script:

  * `mail` for sending email alerts
  * `docker` for container monitoring
  * `openssl` for SSL checking
  * `git` for deployment scripts

