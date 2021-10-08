#!/bin/sh

#if [[ "${UID}" -eq 0 ]]
#then
    #echo "You are root"
#else
    #echo "You are not root"
#fi


#a=2
#b=3

#((${a} < ${b}))

#echo $?

#if [[ $(id -nu) -eq "admin" ]]
#then
    #echo "You are admin"
#else
    #echo "Yor are not admin"
#fi


while [[ "${#}" > 0 ]]
  do
    echo "${@}"
    shift
  done

echo "Enter your name"
#read READ
#echo ${READ}
echo $(basename ${0})