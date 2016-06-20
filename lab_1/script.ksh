#!/bin/ksh
USAGE="./script.ksh"
print_menu(){
echo "1) Where i am?
2) What is here?
3) Make directory
4) Change directory
5) Delete directory
6) Exit"
}
rm $HOME/lab1_err
iExit=0
while (( $iExit == 0 )); do
        print_menu
        read iOption || exit 0
        case $iOption in
                1)
                        if [[ -d $PWD ]]
                        then
                                /bin/pwd -L  2>>$HOME/lab1_err
                        else
                                echo fail>>$HOME/lab1_err; echo fail >&2
                        fi
                ;;
                2)
                        ls 2>>$HOME/lab1_err || echo Fail >&2
                ;;
                3)
                        echo "Dir name?"
                        IFS=
                        read arg || exit 0
                        IFS=' '
                        mkdir -- "$arg" 2>>$HOME/lab1_err || echo "Fail" >&2
                ;;
                4)
                        echo "Where u wish to be:"
                        IFS=
                        read arg || exit 0
                        IFS=' '
                        if [[ -d $arg ]]; then
                                { cd "`/bin/pwd`" "$arg" 2>> ~/lab1_err; } || { echo "Fail" >&2 ; }
                        else
                                echo "Dir not found">>$HOME/lab1_err; echo "Dir not found" >&2
                        fi
                ;;
                5)
                        echo "What directory have annoyed u?"
                        IFS=
                        read arg || exit 0
                        IFS=' '
                        if [[ -d "$arg" ]] then
                                echo "rmdir: delete directory \"$arg\"?"
                                read isDel || exit 0
                                if [[ "$isDel" == "yes" ]]
                                        then
                                                rmdir -- "$arg" 2>>$HOME/lab1_err || echo "FAIL" >&2
                                        else
                                                echo "Nothing to do here" >>$HOME/lab1_err; echo "Nothing to do here" >&2
                                fi
                        else
                                if [[ -f "$arg" ]] then
                                echo "ITS FILE!!!!">>$HOME/lab1_err; echo "ITS FILE!!!!" >&2
                                else
                                echo "Dir not found">>$HOME/lab1_err; echo "Dir not found" >&2
                                fi
                        fi
                ;;
                6)
                        iExit=1
                ;;
                esac
done