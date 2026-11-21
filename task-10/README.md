# Задание 10. Управление процессами. 
## Вариант 3. Конкурирующие процессы по CPU и nice

## Текст задания
- Создайте скрипт, запускающий два процесса, конкурирующих за процессорное время.
- Назначьте процессам разные значения nice.
- Выполните несколько запусков с разными параметрами приоритета.
- Зафиксируйте время выполнения и сравните результаты.

Ожидаемый результат: рабочий скрипт, демонстрирующий влияние nice на выполнение CPU-нагрузки.

## Используемое окружение
Arch Linux

## nice-benchmark.sh
```
#!/usr/bin/env bash
set -ueo pipefail
IFS=$'\n\t'

if [ "$(id -u)" -ne 0 ]; then
    printf 'must run as root: sudo %s ...\n' "$0" >&2
    exit 1
fi

nice_val_1="$1"
nice_val_2="$2"

run_timed() {
    local nice_val="$1" out="$2"
    shift 2
    # taskset - чтобы команды выполнялись на одном и том же ядре
    /usr/bin/time -f "%e" -o "$out" \
        nice -n "$nice_val" taskset -c 0 "$@"
    printf 'nice %s finished\n' "$nice_val"
}

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# создает тестовый файл с рандомными данными в памяти (tmpfs), а не на диске,
# чтобы избежать I/O bottleneck при параллельном чтении командами `xz`
testfile=/dev/shm/nice_test_data
[ -f "$testfile" ] || head -c 100M /dev/urandom >"$testfile"

run_timed "$nice_val_1" "$tmpdir/t1" xz -6 -c "$testfile" >/dev/null &
p1=$!
run_timed "$nice_val_2" "$tmpdir/t2" xz -6 -c "$testfile" >/dev/null &
p2=$!

wait "$p1" "$p2" || true

{
    printf '%s %s\n' "nice" "elapsed(s)"
    printf '%s %s\n' "$nice_val_1" "$(cat "$tmpdir/t1")"
    printf '%s %s\n' "$nice_val_2" "$(cat "$tmpdir/t2")"
} | column -t
```

## Пример запуска и вывод команд
Скрипт выполняет две команды `xz` параллельно на одном ядре с указанными параметрами `nice` и выводит время выполнения каждой команды. Ниже скрипт вызывается три раза последовательно с разными параметрами `nice`.
```
~/Projects/otus-linux-administration-professional/task-10 > sudo ./nice-benchmark.sh -10 10; sudo ./nice-benchmark.sh 10 -10; sudo ./nice-benchmark.sh -20 19
nice  elapsed(s)
-10   58.91
10    117.54
nice  elapsed(s)
10    119.83
-10   61.58
nice  elapsed(s)
-20   59.04
19    118.18
```

## Демо
https://github.com/user-attachments/assets/305a7ce2-6a56-429c-89d3-16cf15e9e1a5

