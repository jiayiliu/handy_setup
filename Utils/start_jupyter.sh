#!/bin/bash

if [ -e ~/.jupyter.pid ]; then
    PID=$(cat ~/.jupyter.pid)
    if ps -p $PID > /dev/null ; then
        read -p "Kill current jupter instance [y/N]?" flag
        if [[ $flag != "y" ]]; then
            echo "Keep current jupyter running"
            exit
        else
            kill $PID
            echo "Existing jupyter instance stopped"
        fi
    fi
fi

nohup jupyter lab > .jupyter.out 2> .jupyter.err &
echo $! > ~/.jupyter.pid
echo "Jupyter is running. "