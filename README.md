# **🚀 Site Monitoring System with Prometheus & Grafana**  
*A lightweight yet powerful monitoring tool to track website availability, latency, and errors in real time.*  

![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)  
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=Grafana&logoColor=white)  
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white)  
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=Python&logoColor=white)  

---

## **📌 Overview**  
This project provides a **simple but effective** way to monitor websites by:  
✅ **Checking HTTP status codes** (200, 404, 500, etc.)  
✅ **Measuring response latency** (how fast a site responds)  
✅ **Detecting errors** (timeouts, connection failures)  
✅ **Storing metrics** in **Prometheus**  
✅ **Visualizing data** in **Grafana**  

**Use cases:**  
- Uptime monitoring for personal projects  
- SLA tracking for APIs  
- Debugging slow web services  

---

## **⚡ Quick Start**  

### **Prerequisites**  
- Docker & Docker Compose  
- Python 3.9+ (only for running `mon.py` manually)  

### **Setup & Run**  
1. **Clone the repo:**  
   ```sh
   git clone https://github.com/axialix-ops/site-monitoring.git && cd site-monitoring
   ```  

2. **Add target URLs** to `sites.txt` (one per line):  
   ```txt
   https://google.com  
   https://github.com  
   ```  

3. **Launch services:**  
   ```sh
   chmod +x setup.sh  
   ./setup.sh  # Installs dependencies & starts containers  
   ```  

4. **Access dashboards:**  
   - **Prometheus**: http://localhost:9090  
   - **Grafana**: http://localhost:3000 (Login: `admin` / `admin`)  

---

## **🛠️ Architecture**  
```mermaid  
flowchart LR  
    mon.py -->|Pushes metrics| Pushgateway  
    Pushgateway -->|Scrapes| Prometheus  
    Prometheus -->|Data source| Grafana  
```  

### **Components**  
| Service         | Description                          | Port  |  
|----------------|--------------------------------------|-------|  
| **Prometheus** | Metrics storage & alerting engine    | 9090  |  
| **Pushgateway** | Temporary metrics storage           | 9091  |  
| **Grafana**    | Visualization & dashboards           | 3000  |  
| **mon.py**     | Python script that checks sites      | -     |  

---

## **📊 Example Metrics**  
The script tracks:  
- `site_status{instance="example.com"}` → HTTP status code (e.g., `200`)  
- `site_latency{instance="example.com"}` → Response time in seconds (e.g., `0.45`)  
- `site_error{instance="example.com"}` → `1` if error occurred, else `0`  

**Sample PromQL queries:**  
```promql  
# Sites with errors  
site_error{job="site-check"} == 1  

# Average latency per site  
avg(site_latency) by (instance)  
```  

---

## **🔧 Advanced Configuration**  

### **Modify Scrape Interval**  
Edit `assembling/prometheus.yml`:  
```yaml  
scrape_configs:  
  - job_name: "site-check"  
    scrape_interval: 10s  # Change as needed  
```  

### **Run Without Docker**  
```sh  
python3 -m pip install requests  
python3 mon.py  # Sends metrics to Pushgateway  
```  
---

## **🚨 Troubleshooting**  
| Issue                          | Solution                          |  
|--------------------------------|-----------------------------------|  
| `setup.sh` fails               | Check if Docker/Python 3 is installed |  
| No data in Prometheus          | Verify `mon.py` is running (`ps aux | grep mon.py`) |  
| Pushgateway unreachable        | Run `docker ps` to check containers |  

---

## **📜 License**  
MIT License. See [LICENSE](LICENSE).  

---

**Made by [Axilix]**  
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/axialix-ops)  

--- 

✨ **Happy Monitoring!** ✨  

---
