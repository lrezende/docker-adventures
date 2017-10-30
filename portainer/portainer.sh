#!/bin/bash

# docker-compose.yml baseado no github https://github.com/softonic/portainer-endpoint

SECRET_NAME=portainer_password.v1

echo "Secret(${SECRET_NAME}) exists?"

secret=$(docker secret ls --filter name="$SECRET_NAME" -q)

if [ -z "$secret" ]; then
  read -n1 -p "Secret doesn't exists. Let's create it? (Y|n) " doit
  echo

  case $doit in  
    y|Y) 
      read -s -p "Inform a password(8 length at least): " passwd
      echo

      read -s -p "Confirm password: " repasswd
      echo
      if [ "$passwd" = "$repasswd" ]; then
        echo -n $passwd | docker secret create $SECRET_NAME -
      else
        echo "Password does not match!"
        exit
      fi ;;
    *) echo "Secret must exists"; exit ;;
  esac
else
  echo "Secret exists! Let's go ahead..."
fi

#if [ ! -f certs/portainer.crt ]; then
#  openssl genrsa -out certs/portainer.key 2048
#  openssl ecparam -genkey -name secp384r1 -out certs/portainer.key
#  openssl req -new -x509 -sha256 -key certs/portainer.key -out certs/portainer.crt -days 3650
#fi

docker stack deploy --compose-file docker-compose.yml portainer

exit

