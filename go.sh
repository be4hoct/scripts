#!/bin/bash

# This script should help me access servers faster
# Created by Todor Pehlivanov, 2024

# This shows the basic usage:

if [ -z "$1" ]; then
        echo -e "usage: \033[1mgo\033[0m [servername]"
        echo "This connects you to server [servername]."
        exit 1;
fi

# This is the function that connects us to the server. We use port 22 and user `root` for the connection :

connect_to_server() {
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -p 22 -l root "$1"
}	

# Let's connect to the server:

echo -e "\033[1mConnecting to Server: \033[15m $1 \033[0m\n" && connect_to_server "$1"

# The END.
