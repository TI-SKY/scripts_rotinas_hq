#!/bin/bash

export CONF="/sky/scripts/scripts_rotinas_hq/bancos.txt"
export BACKUP_DIR="/backup/incremental/"
export LOG_DIR="/sky/logs/incremental/"
export FBUSER="SYSDBA"
export FBPASS="5kyC10uD"
export SERVER="localhost/3050"
export LEVEL="$1"
export KEEP_FILES="$2"
export CONF_OVERRIDE="$3"

logMsg () {
        echo -e "$(date): $1" >> $LOG_DIR'incremental.log'
        echo "$1"
}


[ ! -e $LOG_DIR ] && logMsg "Criando diretório $LOG_DIR" && mkdir -p $LOG_DIR
[ "$#" -lt 2 ] && logMsg "é necessário especificar o nível do backup e quantidade de arquivos. eg.: incremental.sh 2 21" && exit 1
[ $LEVEL -lt 0 ] && logMsg "o nível  deve ser 0, 1 ou 2" && exit 1
[ $LEVEL -gt 2 ] && logMsg "o nível deve ser 0, 1 ou 2" && exit 1
[ ! $KEEP_FILES -gt 0 ] && logMsg "a quantidade de arquivos a manter deve ser maior que 0" && exit 1
which nbackup &> /dev/null
[ $? -ne 0 ] && logMsg "Comando nbackup não existe" && exit 1
[ ! -e $BACKUP_DIR ] && logMsg "Criando diretório $BACKUP_DIR" && mkdir -p $BACKUP_DIR

if [ -n "$CONF_OVERRIDE" ]; then
        bancos="$CONF_OVERRIDE"
else
        [ ! -e $CONF ] && logMsg "Arquivo de configuração $CONF não existe" && exit 1
        bancos=$(grep '^[^#[:space:]]' "$CONF")
fi

for banco in $bancos; do
        cliente=$(echo $banco | cut -d "/" -f 2);
        nomebanco=$(echo ${banco%.?db} | cut -d "/" -f 4);
        final_dir="$BACKUP_DIR$cliente/$nomebanco/";
        timestamp="_$(date +%Y%m%d_%H%M%S)";
        [ ! -e $final_dir ] && logMsg "Criando diretório $final_dir" && mkdir -p $final_dir;
        backup_name="$final_dir$nomebanco$timestamp.nb$LEVEL";
        echo "$banco ->  $backup_name";
        nbackup -user $FBUSER -pass $FBPASS -b $LEVEL "$SERVER:$banco" "$backup_name";
        if [[ -e $backup_name ]]; then
                ls -t $final_dir*.nb$LEVEL 2>/dev/null | tail -n +$(($KEEP_FILES + 1)) | xargs rm -f;
        else
                logMsg "Erro ao realizar o backup $backup_name de $banco"
        fi
done
