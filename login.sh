#!/bin/bash

hostlist=()
userlist=()
passwdlist=()

# call expect script to login
function login()
{
    ./login_tool.exp $1 $2 $3
}

# index of array about host, user, and password
index=0

# read from file into array 
while read line
do
    hostlist[$index]=`echo $line | awk '{print $1}'`
    userlist[$index]=`echo $line | awk '{print $2}'`
    passwdlist[$index]=`echo $line | awk '{print $3}'`
    echo -e "\033[40;37m${hostlist[$index]} \033[0m"
    index=`expr $index + 1`
done < host.conf

echo -e "\033[3A"

# get length of hostlist
length=`expr ${#hostlist[@]} - 1`

# current index that user choose
index=0

# catch input of user to choose which host to login
KEY=()
while :
do
    read -s -n 1 KEY
    case ${KEY[0]} in
        "A")
	    index=`expr $index - 1`
            if [ $index -lt 0 ];
            then
                index=0
            else
                echo -e "\033[2A" # move the pointer up one step
                # echo -e "\033[47;30m ${hostlist[$index]} \033[0m"
            fi
            ;;
        "B")
            index=`expr $index + 1`
            if [ $index -gt $length ];
            then
                index=$length
            else
                # echo -e "\033[40;37m ${hostlist[`expr $index - 1`]} \033[0m"
                # echo -e "\033[47;30m ${hostlist[$index]} \033[0m"
                echo -e "\033[1B" # move the pointer down two step
                echo -e "\033[2A" # move the pointer up one step
            fi
            ;;
        "D")
            ;;
        "C")
            ;;
        "")
            echo -e "\033[2J"
            echo ${hostlist[$index]}" "${userlist[$index]}" "${passwdlist[$index]}
            login ${hostlist[$index]} ${userlist[$index]} ${passwdlist[$index]}
            break
            ;;
        *)
            continue
            ;;
    esac 
done


