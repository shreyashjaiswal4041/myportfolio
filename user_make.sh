#!/bin/bash

#scripts should be execute with sudo/root access.
if [[ "${UID}" -ne 0 ]]
then  
	echo " please run with sudo or root "
	exit 1
fi

#user should provide atleat one argument as username alse guide him
if [[ "${#} -lt 1 ]]
then
	echo "usage :${0} USER_NAME [comment]...."
	echo "create a user with name USER_NAME and comments field of COMMENT"
	exit 1
fi

#store 1st argument as user name
USER_NAME="${1}"
echo $USER_NAME

#in case of more than one argument ,store it as account comments 
shift 
COMMENT="${@}"
echo $COMMENT

# create a password .
#[[[date +%s%N]]] insted od $RANDOM we are using it to generate random values here we are mergeing date %s second %N nanosecond as o/p
 
PASSWORD=$(date +%s%N)


#create the user 
# -c comment,and -m means home directory,useradd ads a new user have path -m[home dir then] username

useradd -c "${COMMENT}" -m $USER_NAME

#check if user is successfully created or not
if [[ $? -ne 0 ]]
then 
	echo "the account could not be created "
	exit 1
fi

# set the password for the user .
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# check if password is successfully set or not
if [[ $? -ne 0 ]]
then 
        echo "the password could not be set "
        exit 1
fi

#force password change on login.
passwd -e $USER_NAME

#display the username ,password and the host where the user was created.
echo 
echo "username :$USER_NAME"
echo
echo "password :$PASSWORD"
echo
echo $(hostname)

