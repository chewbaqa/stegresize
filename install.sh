#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if ! command -v git &> /dev/null
then
    echo "git could not be found, please install git"
    exit
fi

chmod +x stegresize

mv stegresize /usr/local/bin/

echo "Installation completed successfully. You can now use the 'stegresize' command."