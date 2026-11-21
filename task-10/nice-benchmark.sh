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
