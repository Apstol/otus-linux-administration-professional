# Задание 9. Bash

## Текст задания
Написать скрипт для CRON, который раз в час формирует отчёт и отправляет его на заданную почту.

Отчёт должен содержать:
- IP-адреса с наибольшим числом запросов (с момента последнего запуска);
- Запрашиваемые URL с наибольшим числом запросов (с момента последнего запуска);
- Ошибки веб-сервера/приложения (с момента последнего запуска);
- HTTP-коды ответов с указанием их количества (с момента последнего запуска).

## Используемое окружение
Arch Linux -> VirtualBox -> Ubuntu 24.04.3 LTS

## /opt/generate-nginx-report.sh
```
#!/bin/bash

TEST_MODE=0

while [ $# -gt 0 ]; do
    case "$1" in
        --test) TEST_MODE=1; shift ;;
        --)     shift; break ;;
        -*)     echo "Unknown option: $1" >&2; exit 1 ;;
        *)      break ;;
    esac
done

another_report_running()
{
    echo "There is another report running. Aborting."
    exit 1
}

LOCK_FILE=${1:-/run/lock/generate-nginx-report.lock}
REPORT_FILE=${2:-nginx-report.txt}
LOG_FILE=${3:-access-4560-644067.log}

(
	flock -n 100 || another_report_running

	print_header() {
		echo "$1" | boxes -d jstone
	}

	if [ "$TEST_MODE" -eq 1 ]; then
		echo "This is a concurrency test. Sleeping for 10 seconds..."
		sleep 10s
		echo "Finished sleeping."
	fi

	echo "Running report generation..."
	
	rm "$REPORT_FILE" 2>/dev/null

	# Временной диапазон
	printf '%s\n%s\n\n' "$(print_header "Time interval")" "$(sed -n '1p;$p' "$LOG_FILE" | awk '{print $4}' | sed 's/\[//' | sed ':a; N; $!ba; s/\n/ - /')" >> "$REPORT_FILE"

	# IP-адреса с наибольшим числом запросов
	printf '%s\n%s\n\n' "$(print_header "Top IPs")" "$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -k1 -nr | head -n 5 | awk '{print $2 " " $1}' | sed '1i IP Requests\n' | column -t)" >> "$REPORT_FILE"

	# Запрашиваемые URL с наибольшим числом запросов
	# Фильтрует шум (пустые URL)
	printf '%s\n%s\n\n' "$(print_header "Top URLs")" "$(awk -F '"' '{print $2}' "$LOG_FILE" | awk 'NF>=2 {print $2}' | sort | uniq -c | sort -k1 -nr | head -n 5 | awk '{print $2 " " $1}' | sed '1i URL Requests' | column -t)" >> "$REPORT_FILE"

	# Ошибки веб-сервера/приложения
	printf '%s\n%s\n\n' "$(print_header "Server errors")" "$(awk -F '"' '{print $3}' "$LOG_FILE" | awk '{print $1}' | grep -E '^5' | sort | uniq -c | sort -k1 -nr | awk '{print $2 " " $1}' | sed '1i Code Count' | column -t)" >> "$REPORT_FILE"

	# HTTP-коды ответов с указанием их количества
	printf '%s\n%s\n\n' "$(print_header "HTTP response codes")" "$(awk -F '"' '{print $3}' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -k1 -nr | awk '{print $2 " " $1}' | sed '1i Code Count' | column -t)" >> "$REPORT_FILE"

	echo "Report generation finished."
) 100>"$LOCK_FILE"
```

## /root/nginx-report.txt
```
/*---------------+
 | Time interval |
 +---------------*/
14/Aug/2019:04:12:10 - 15/Aug/2019:00:25:46

/*---------+
 | Top IPs |
 +---------*/
IP               Requests
93.158.167.130   45
109.236.252.130  39
212.57.117.19    37
188.43.241.106   33
87.250.233.68    31

/*----------+
 | Top URLs |
 +----------*/
URL            Requests
/              157
/wp-login.php  120
/xmlrpc.php    57
/robots.txt    26
/favicon.ico   12

/*---------------+
 | Server errors |
 +---------------*/
Code  Count
500   3

/*---------------------+
 | HTTP response codes |
 +---------------------*/
Code  Count
200   498
301   95
404   51
400   18
500   3
499   2
405   1
403   1
304   1
```

## Заметки
- Скрипт создает отчет в `/root`. По почте не отправляется, так как обговорили, что этого делать не нужно.
- Использовалась сторонняя утилита `boxes` для оформления заголовков в отчете.
- Для исправления условий гонки при конкурентном выполнении скрипта вместо `trap` использовался `flock`.
- Для тестирования конкурентности добавлен параметр `--test`, имитирующий долгое выполнение.
- Скрипт выполняется systemd юнитом по таймеру каждый час.

## Демо

https://github.com/user-attachments/assets/6fa5aa7f-732c-45b9-b7e2-49493562f4e8

