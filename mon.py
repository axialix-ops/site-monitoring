import requests
import time
import os

def check_site(url):
    try:
        start_time = time.time()
        response = requests.get(url)
        end_time = time.time()
        latency = end_time - start_time
        return {
            "status_code": response.status_code,
            "latency_seconds": latency,
            "error": False
        }
    except Exception as e:
        return {
            "status_code": None,
            "latency_seconds": None,
            "error": True,
            "exception": str(e)
        }

if __name__ == "__main__":
    # Читаем список сайтов из файла
    sites_file = "sites.txt"
    if not os.path.exists(sites_file):
        print(f"Файл {sites_file} не найден.")
        exit(1)

    with open(sites_file, "r") as f:
        urls = [line.strip() for line in f if line.strip()]

    while True:
        metric_data = ""

        for url in urls:
            domain = url.split("//")[-1].split("/")[0]  # Извлекаем домен
            result = check_site(url)

            metric_data += f"""
                site_status{{job="site-check", instance="{domain}"}} {result['status_code'] or 0}
                site_latency{{job="site-check", instance="{domain}"}} {result['latency_seconds'] or 0}
                site_error{{job="site-check", instance="{domain}"}} {1 if result['error'] else 0}
            """

        push_url = "http://localhost:9091/metrics/job/site-check"
        headers = {'Content-Type': 'text/plain'}
        requests.post(push_url, data=metric_data, headers=headers)

        print("Метрики отправлены:", time.ctime())
        time.sleep(10)
