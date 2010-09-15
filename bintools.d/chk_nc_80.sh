ip=$1
addr80="$ip 80"
res80="ncp80.$1.html"
echo $ip
nc -q 3 -w 2 $addr80 >$res80 <samplereq
[ $? -eq 0 ] && {
    echo $ip >> ncsuccess80.lst
} || {
    echo $ip >> ncfail80.lst
    rm $res80
}
