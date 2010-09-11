ip=$1
addr80="http://$ip/"
addr8080="http://$ip:8080/"
res80="p80.$1.html"
res8080="p8080.$1.html"
echo $ip
curl --connect-timeout 1 -m 60 $addr80 >$res80
[ $? -eq 0 ] && {
    echo $ip >> success80.lst
} || {
    echo $ip >> fail80.lst
    rm $res80
}
curl --connect-timeout 1 -m 60 $addr8080 >$res8080
[ $? -eq 0 ] && {
    echo $ip >> success8080.lst
} || {
    echo $ip >> fail8080.lst
    rm $res8080
}
