#/bin/bash

SERVER_LIST='/vagrant/servers'

#Options for ssh command

SSH_OPTIONS="-o ConnectTimeout=2"

usage() {
    echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" &>2
    exit 1
}

if [[ "${UID}" -eq 0 ]]
then
    echo " Do not execute this script as root. Use the -s option instead." >&2
    usage
    exit1
fi

#Parse options
while getopts f:nsv OPTION
do
    case ${OPTION} in
        f) SERVER_LIST="${OPTARG}" ;;
        n) DRY_RUN='true' ;;
        s) SUDO='sudo' ;;
        v) VERBOSE='true' ;;
        ?) usage ;;
    esac
done



if [[ ! -e "${SERVER_LIST}" ]]
then

