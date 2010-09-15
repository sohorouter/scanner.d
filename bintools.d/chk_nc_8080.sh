ip=$1
addr8080="$ip 8080"
res8080="ncp8080.$1.html"
echo $ip
nc -q 3 -w 2 $addr8080 >$res8080 <samplereq
[ $? -eq 0 ] && {
    echo $ip >> ncsuccess8080.lst
} || {
    echo $ip >> ncfail8080.lst
    rm $res8080
}
