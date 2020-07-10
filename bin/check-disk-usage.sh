HDD=$(df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1)
WARN=0
CRIT=0
if [ $(echo "$HDD > 90" |bc -l) -gt 0 ]; then
    echo "$(hostname) DISK: ${HDD}%"
    CRIT=2
elif [ $(echo "$HDD > 80" |bc -l) -gt 0 ]; then
    echo "$(hostname) DISK: ${HDD}%"
    WARN=1
else
    echo "$(hostname) DISK: ${HDD}%"
fi

if [ $(echo "$CRIT > 0" |bc -l) -gt 0 ]; then
    exit 2
elif [ $(echo "$WARN > 0" |bc -l) -gt 0 ]; then
    exit 1
else
    exit 0
fi
