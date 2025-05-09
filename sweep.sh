#!/bin/bash

export CONF="./bancos.txt"
export FBUSER="SYSDBA"
export FBPASS="skycl0ud"
export SERVER="localhost/3050"

logMsg () {
        echo -e "$(date): $1" >> $LOG_DIR'incremental.log'
        echo "$1"
}

which gfix &> /dev/null
[ $? -ne 0 ] && logMsg "Comando sweep não existe" && exit 1
[ ! -e $CONF ] && logMsg "Arquivo de configuração $CONF não existe" && exit 1

bancos=$(grep '^[^#[:space:]]' "$CONF")
for banco in $bancos; do
	echo "$banco"
	gfix -user $FBUSER -pass $FBPASS -sweep "$SERVER:$banco"
done
