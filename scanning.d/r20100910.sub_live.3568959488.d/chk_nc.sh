ip=$1
addr80="$ip 80"
addr8080="$ip 8080/"
res80="ncp80.$1.html"
res8080="ncp8080.$1.html"
echo $ip
nc -q 1 -w 3 $addr80 >$res80 <samplereq
[ $? -eq 0 ] && {
    echo $ip >> ncsuccess80.lst
} || {
    echo $ip >> ncfail80.lst
    rm $res80
}
nc -q 1 -w 3 $addr8080 >$res8080 <samplereq
[ $? -eq 0 ] && {
    echo $ip >> ncsuccess8080.lst
} || {
    echo $ip >> ncfail8080.lst
    rm $res8080
}
