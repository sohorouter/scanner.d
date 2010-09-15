sect=$1
[ -z "$sect" ] && {
    echo provide sector number
    exit 1
}
f_date=`date +"%Y%m%d"`
target_d=~/proj/cnyper/scanner/data.d/r${f_date}.sub_live.${sect}.d
grep 80 ipscan.lst | grep -v 8080 | awk -F: '{print $1}' > ipscan.80.lst
grep 8080 ipscan.lst | awk -F: '{print $1}' > ipscan.8080.lst
cmd="cat ipscan.${sect}.res.txt | grep 80 | grep -v 'n/a' | awk {'print \$1'} > ${target_d}/hl.norm.lst"
echo mkdir $target_d
echo $cmd

