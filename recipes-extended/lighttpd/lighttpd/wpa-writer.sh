#!/bin/bash

if [ "$REQUEST_METHOD" = "POST" ]; then
    read params

    essidParam=${params%&*}
    passwordParam=${params#*&}
    
    essid=${essidParam#essid=}

    priority=$(echo $OUTPUT | awk '$1 ~ /network=\{/ {++c} END {print c}' FS=: /etc/wpa_supplicant.conf) 
    ((priority++))

    if [ "$passwordParam" != "$essidParam" ]; then
        password=${passwordParam#password=}
        
        INCORRECT_PASSWORD_ERR="Passphrase must be 8..63 characters"
        passphraseRes=$(wpa_passphrase "$essid" "$password")
        if [ "$?" != "0" ]; then
            if [ "$passphraseRes" = "$INCORRECT_PASSWORD_ERR" ]; then
                echo $'HTTP/1.1 422 Unprocessable Entity\r\n'
            else
                echo $'HTTP/1.1 500 Internal Server Error\r\n'
            fi
        else
            passphraseRes=$(echo -e "$passphraseRes" | grep -v ^$'\t\#') 
            networkStr="${passphraseRes::-2}"
            networkStr=$(printf "$networkStr\n\tpriority=%d\n}" $priority)
            echo -e "$networkStr" >> /etc/wpa_supplicant.conf
            if [ "$?" = "0" ]; then
                sync
                echo "OK"
            else
                echo $'HTTP/1.1 500 Internal Server Error\r\n'
            fi
        fi
    else
        networkStr="network={\n\tssid=\"$essid\"\n\tkey_mgmt=NONE\n\tpriority=$priority\n\tdisabled=1\n}"
        echo -e "$networkStr" >> /etc/wpa_supplicant.conf
        if [ "$?" = "0" ]; then
            sync
            echo "OK"
        else
            echo $'HTTP/1.1 500 Internal Server Error\r\n'
        fi
    fi
fi
