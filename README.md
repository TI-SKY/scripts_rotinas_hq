# Configuração em um novo servidor

Clone o repositório

```bash
cd /sky/scripts/ && \
git clone https://github.com/TI-SKY/scripts_rotinas_hq.git
```

Configurar os parâmetros dentro de *CADA* script

```shell
export CONF="./bancos.txt"                         # arquivo de configuração
export BACKUP_DIR="/backup/incremental/temp/"      # diretório final onde os backups serão armazenados
export LOG_DIR="/sky/scripts/incremental/logs/"    # diretório onde os logs serão armazenados
export FBUSER="SYSDBA"                             # usuário do firebird 
export FBPASS="skycl0ud"                           # senha do firebird
export SERVER="localhost/3050"                     # servidor e porta onde o script vai se conectar
```

Selecionar os bancos em que o script deve ser executado

```shell
find /clienteCNS/dados -iname "*.?db" | grep -v imagens >> bancos.txt  && vim bancos.txt
```
Remover todos os bancos que não seriam cadastrados no painel do hq

Salvar o arquivo

```shell
:wq
```

Adicionar os scripts na crontab

```shell
0 7 * * 0              root  /sky/scripts/script_rotinas_hq/incremental.sh 0 2
0 4 * * 1-5            root  /sky/scripts/script_rotinas_hq/incremental.sh 1 2
0-59/30 08-18 * * 1-5  root  /sky/scripts/script_rotinas_hq/incremental.sh 2 21

30 0 * * *             root  /sky/scripts/script_rotinas_hq/sweep.sh
40 0 * * *             root  /sky/scripts/script_rotinas_hq/recalculo_de_indice.sh
```

# Adicionar novos bancos

```shell
find /clienteCNS/dados -iname "*.?db" | grep -v imagens >> bancos.txt  && vim bancos.txt
```
Manter somente os bancos necessários
