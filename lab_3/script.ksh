#!/bin/bash
USAGE="./script.ksh filename"

if [[ "$1" == "" ]]; then
        echo "Usage: $USAGE" >&2
        exit -1
fi
if [[ ! -f "$1" ]]; then
        echo "\"$1\" is not file" >&2
        exit -2
fi

bIsOwner=0
bIsGroup=0
bIsOthers=0 #hihs
owner=$(ls -v -- "$1" | head -n1| awk '{print $3}')
ownerId=$(getent passwd | awk -F":" "/$owner/{print \$3}")
ownerGroup=$(ls -v -- "$1" | head -n1| awk '{print $4}')
bIsOwner=$(ls -l -- "$1" | sed -n "s/^.\(.\).*/\1/p")
bIsGroup=$(ls -l -- "$1" | sed -n "s/^....\(.\).*/\1/p")
bIsOthers=$(ls -l -- "$1" | sed -n "s/^.......\(.\).*/\1/p")
if [[ "$bIsOwner" == "r" ]]; then #owner
        echo $owner
fi
if [[ "$bIsGroup" == "r" ]]; then #group
        bIsGroup=1
fi
if [[ "$bIsOthers" == "r" ]]; then #Others
        bIsOthers=1
fi
if [[ "$bIsOthers" == 1 || "$bIsGroup" == 1 ]]; then
        getent passwd | awk -F":" '{print $1}' | while read -r sUserName; do
                if [[ "$sUserName" != "$owner" ]]; then #Group members
                        bIsGroupMember=$(groups $sUserName| grep -w "$ownerGroup")
                        bIsAnotherGroups=$(groups $sUserName| grep -vw "$ownerGroup")
                        if [[ ! "$bIsGroupMember" = "" ]]; then
                                if [[ "$bIsGroup" == 1 ]]; then #Others
                                        echo "$sUserName"
                                fi
                        else
                                if [[ ! "$bIsAnotherGroups" = "" ]]; then
                                        if [[ "$bIsOthers" == 1 ]]; then #Others
                                                echo "$sUserName"
                                        fi
                                fi
                        fi
                fi
        done
fi
exit 0