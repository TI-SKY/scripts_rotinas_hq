#!/bin/bash

export CONF="./bancos.txt"
export SQL="./recalculo.sql"
export LOG_DIR="/sky/logs/"
export FBUSER="SYSDBA"
export FBPASS="skycl0ud"
export SERVER="localhost/3050"

logMsg () {
        echo -e "$(date): $1" >> $LOG_DIR'recalculo_de_indice.log'
        echo "$1"
}

which isql &> /dev/null
[ $? -ne 0 ] && logMsg "Comando isql não existe" && exit 1
[ ! -e $CONF ] && logMsg "Arquivo de configuração $CONF não existe" && exit 1

bancos=$(grep '^[^#[:space:]]' "$CONF")
for banco in $bancos; do
	echo "$banco"
	isql -user $FBUSER -pass $FBPASS "$SERVER:$banco" -i $SQL 
done
