FREE_DATA=$(free -m | grep Mem)
TOTAL=$(echo $FREE_DATA | cut -f2 -d' ')
FREE=$(echo $FREE_DATA | cut -f4 -d' ')
USED=$(expr $TOTAL - $FREE)
RAM=$(echo "scale = 2; $USED/$TOTAL*100" | bc)
WARN=0
CRIT=0
if [ $(echo "$RAM > 90" |bc -l) -gt 0 ]; then
    echo "$(hostname) MEMORY: ${RAM}%"
    CRIT=2
elif [ $(echo "$RAM > 80" |bc -l) -gt 0 ]; then
    echo "$(hostname) MEMORY: ${RAM}%"
    WARN=1
else
    echo "$(hostname) MEMORY: ${RAM}%"
fi

if [ $(echo "$CRIT > 0" |bc -l) -gt 0 ]; then
    exit 2
elif [ $(echo "$WARN > 0" |bc -l) -gt 0 ]; then
    exit 1
else
    exit 0
fi
