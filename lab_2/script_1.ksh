#!/bin/ksh
USAGE="./script_1.ksh filename"
gfind -maxdepth 1 -type l -printf "%t /%f\n" | sort -k4 | sed -n "s/.*\/\(.*\)/\1/p" | while read -r f; do
        gfind -samefile "$1" | while read -r sf; do
                if [[ "$f" == "$1" ]]; then
                        break
                fi
                sLinkName=$(perl -e "use Cwd realpath; print realpath(\"$f\");")
                sSameFile=$(perl -e "use Cwd realpath; print realpath(\"$sf\");")
                if [[ "$sLinkName" == "$sSameFile" ]]; then
                        echo "$f"
                        break
                fi
        done
done
