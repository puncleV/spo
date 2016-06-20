#!/bin/ksh
USAGE="./script_2.ksh groupname"
group_id="`getent group | gawk -F':' -v gname="$1" '{if ($1 == gname) {print $3; exit 0;}}'`"

getent group | gawk -F':' -v arg="$1" '{if($1 == arg){print $4}}' | tr "," "\n" | sort -u | while read -r user; do
        bIsHere=0
        if [[ "$group_id" != "" ]]; then
                getent passwd | gawk -F':' -v grp_id="$group_id" '{if ($4 == grp_id) {print $1} }' | tr "," "\n" | sort -u | while read -r auser; do
                        if [[ "$auser" == "$user" ]]; then
                                bIsHere=1
                        fi
                done
        fi
        if [ $bIsHere -eq 0 ]; then
                echo "$user" | sed "/^$/d"
        fi

done
if [[ "$group_id" != "" ]]; then
        getent passwd | gawk -F':' -v grp_id="$group_id" '{if ($4 == grp_id) {print $1} }' | tr "," "\n" | sort -u
fi