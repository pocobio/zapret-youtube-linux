#!/bin/bash
CONFIG_DIR="/etc/zapret"

if command -v doas > /dev/null 2>&1; then
  SUDO=doas
elif command -v sudo > /dev/null 2>&1; then
  SUDO=sudo
else
  echo "Не найдено ни doas, ни sudo. Установите одну из этих программ и повторите попытку."
  exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Каталог $CONFIG_DIR не найден. Пожалуйста, убедитесь, что файлы со списками находятся в этом каталоге."
    exit 1
fi

$SUDO iptables -I OUTPUT -p tcp --dport 80 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p tcp --dport 80 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p tcp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p tcp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p udp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p udp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -I OUTPUT -p udp --dport 50000:50100 -j NFQUEUE --queue-num 0

$SUDO nfqws \
    --qnum=0 \
    --filter-udp=443 \
    --hostlist="$CONFIG_DIR/list-general.txt" \
    --dpi-desync=fake \
    --dpi-desync-repeats=6 \
    --dpi-desync-fake-quic="$CONFIG_DIR/quic_initial_www_google_com.bin" \
    --new \
    --filter-udp=50000-50100 \
    --ipset="$CONFIG_DIR/ipset-discord.txt" \
    --dpi-desync=fake \
    --dpi-desync-any-protocol \
    --dpi-desync-repeats=6 \
    --new \
    --filter-tcp=80 \
    --hostlist="$CONFIG_DIR/list-general.txt" \
    --dpi-desync=fake,split2 \
    --dpi-desync-autottl=2 \
    --dpi-desync-fooling=md5sig \
    --new \
    --filter-tcp=443 \
    --hostlist="$CONFIG_DIR/list-general.txt" \
    --dpi-desync=fake \
    --dpi-desync-autottl=2 \
    --dpi-desync-repeats=6 \
    --dpi-desync-fooling=md5sig \
    --dpi-desync-fake-tls="$CONFIG_DIR/tls_clienthello_www_google_com.bin" \
    --filter-udp=443 \
    --ipset="$CONFIG_DIR/ipset-cloudflare.txt" \
    --dpi-desync=fake \
    --dpi-desync-repeats=6 \
    --dpi-desync-fake-quic="$CONFIG_DIR/quic_initial_www_google_com.bin" \
    --new \
    --filter-tcp=80 \
    --ipset="$CONFIG_DIR/ipset-cloudflare.txt" \
    --dpi-desync=fake,split2 \
    --dpi-desync-autottl=2 \
    --dpi-desync-fooling=md5sig \
    --new \
    --filter-tcp=443 \
    --ipset="$CONFIG_DIR/ipset-cloudflare.txt" \
    --dpi-desync=fake \
    --dpi-desync-fooling=md5sig

$SUDO iptables -D OUTPUT -p tcp --dport 80 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p tcp --dport 80 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p tcp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p tcp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p udp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p udp --dport 443 -j NFQUEUE --queue-num 0
$SUDO iptables -D OUTPUT -p udp --dport 50000:50100 -j NFQUEUE --queue-num 0
