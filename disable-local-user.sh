#/bin/bash

ARCHIVE_DIR="/archive"


usage() {
    echo "Usage: ${0} [-dra] USER [USERN]..." >&2
    echo "Disable a local linux account" >&2
    echo " -d Delete account instead of disabling" >&2
    echo " -r Remove the home directory" >&2
    echo " -a Create an archive of the home directory of user" >&2
    exit 1
}

if [[ ${UID} -ne 0 ]]
then
    echo "Please run script as root" >&2
    exit 1
fi

# Parse options

while getopts dra OPTION
do
    case ${OPTION} in
        d) DELETE_USER='true' ;;
        r) REMOVE_OPTION='-r' ;;
        a) ARCHIVE='true' ;;
        ?) usage ;;
    esac
done

shift "$(( OPTIND - 1 ))"

if [[ "${#}" -lt 1 ]]
then
    usage
fi

for USERNAME in "${#}" 
do
    echo "Proccesing user: ${USERNAME}"
    
    USERID=$(id -u ${USERNAME})

    if [[ "${USERID}" -lt 1000 ]]
    then
        echo "Cann't delete ${USERNAME}" >&2
        exit 1
    fi

    if [[ "${ARCHIVE}" == 'true' ]]
    then 
        if [[ ! -d "${ARCHIVE_DIR}" ]]
        then
            echo "Creating ${ARCHIVE_DIR}"
            mkdir -p "${ARCHIVE_DIR}"

            if [[ "${?}" -ne 0 ]]
            then
                echo "The archive directory ${ARCHIVE_DIR} could not be created" >&2
                exit 1
            fi
        fi

        HOME_DIR="/home/${USERNAME}"
        ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
        if [[ -d "${HOME_DIR}" ]]
        then
            echo "Archiving ${HOME_DIR} to ${ARCHIVE_DIR}"
            tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null

            if [[ "${?}" -ne 0 ]]
            then 
                echo "Could not create ${ARCHIVE_FILE}" >&2
                exit 1
            fi
        else 
            echo "${HOME_DIR} does not exist" >&2
            exit 1
        fi
    fi

    if [[ "${DELETE_USER}" == "true" ]]
    then
        userdel ${REMOVE_OPTION} ${USERNAME}

        if [[ "${?}" -ne 0 ]]
        then
            echo "${USERNAME} account cann't be deleted" >&2
            exit 1
        else 
            echo "${USERNAME} account was deleted"
        fi
    else
        change -E 0 ${USERNAME}
        if [[ "${?}" -ne 0 ]]
        then
            echo "${USERNAME} account cann't be banned" >&2
            exit 1
        fi
    fi    
done

exit 0



