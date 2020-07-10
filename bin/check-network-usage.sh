in="$(cat /proc/net/dev | egrep 'eth0|ens3' | awk '{print $2}')"
net_in=$(echo "scale=2; $in/1000000" | bc)

out="$(cat /proc/net/dev | egrep 'eth0|ens3' | awk '{print $10}')"
net_out=$(echo "scale=2; $out/1000000" | bc)

echo "Bandwidth - Incoming: $net_in MByte"
echo "Bandwidth - Outgoing: $net_out MByte"
